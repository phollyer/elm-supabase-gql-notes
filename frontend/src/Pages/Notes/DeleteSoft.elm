module Pages.Notes.DeleteSoft exposing
    ( Model
    , Msg
    , init
    , setNote
    , update
    , view
    )

import Api
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Notes.DeleteNoteSoft.DeleteNoteSoft as DeleteNoteSoft
import Notes.RestoreNote.RestoreNote as RestoreNote
import Pages.Shared.Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { note : Maybe Supabase.Note
    , status : Maybe Status
    , state : State
    , accessToken : Maybe String
    , userId : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { note = Nothing
    , status = Nothing
    , state = Ready
    , accessToken = accessToken
    , userId = userId
    , config = config
    }


type State
    = Ready
    | Trashing
    | TrashedOk
    | TrashError
    | Restoring
    | RestoredOk
    | RestoreError


setNote : Supabase.Note -> Model -> Model
setNote note model =
    { model | note = Just note }


toSupabaseDeleteNoteSoft : DeleteNoteSoft.Records -> Supabase.Note
toSupabaseDeleteNoteSoft { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString updatedAt
    , deletedAt = Maybe.map Api.datetimeToString deletedAt
    }


type Msg
    = AttemptTrashNote
    | AttemptRestoreNote
    | GraphqlNoteTrashed (Result GraphQL.Engine.Error DeleteNoteSoft.Response)
    | GraphqlNoteRestored (Result GraphQL.Engine.Error RestoreNote.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptTrashNote ->
            case ( model.accessToken, model.note ) of
                ( Just accessToken, Just note ) ->
                    ( { model
                        | status = Just (Info "Sending your note to the trash...")
                        , state = Trashing
                      }
                    , GraphQL.softDeleteNoteCmd model.config accessToken GraphqlNoteTrashed note
                    )

                ( Nothing, _ ) ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , GraphQL.refreshSessionCmd
                    )

                ( _, Nothing ) ->
                    ( { model | status = Just (Error "No note selected for deletion") }, Cmd.none )

        AttemptRestoreNote ->
            case ( model.accessToken, model.note ) of
                ( Just accessToken, Just note ) ->
                    ( { model
                        | status = Just (Info "Sending your note to the trash...")
                        , state = Restoring
                      }
                    , GraphQL.restoreNoteCmd model.config accessToken GraphqlNoteRestored note
                    )

                ( Nothing, _ ) ->
                    ( { model
                        | status = Just (Error "Session info missing. Re-checking session...")
                        , state = RestoreError
                      }
                    , GraphQL.refreshSessionCmd
                    )

                ( _, Nothing ) ->
                    ( { model
                        | status = Just (Error "No note selected for restoration")
                        , state = RestoreError
                      }
                    , Cmd.none
                    )

        GraphqlNoteTrashed result ->
            case result of
                Ok response ->
                    case response.updateNotesCollection.records of
                        record :: _ ->
                            ( { model
                                | status = Just (Success "Note has been trashed successfully")
                                , state = TrashedOk
                                , note = Just (toSupabaseDeleteNoteSoft record)
                              }
                            , Cmd.none
                            )

                        [] ->
                            ( { model
                                | status = Just (Error "Soft delete mutation returned empty records list")
                                , state = TrashError
                              }
                            , Cmd.none
                            )

                Err error ->
                    GraphQL.handleFailure "GraphQL note soft deletion failed" error <|
                        { model | state = TrashError }

        GraphqlNoteRestored result ->
            case result of
                Ok response ->
                    case response.updateNotesCollection.affectedCount of
                        1 ->
                            case model.note of
                                Just note ->
                                    ( { model
                                        | status = Just (Success "Note restored successfully")
                                        , state = RestoredOk
                                        , note = Just { note | deletedAt = Nothing }
                                      }
                                    , Cmd.none
                                    )

                                Nothing ->
                                    ( { model
                                        | status = Just (Error "No current note to restore")
                                        , state = RestoreError
                                      }
                                    , Cmd.none
                                    )

                        0 ->
                            ( { model
                                | status = Just (Error "Restore mutation returned no records")
                                , state = RestoreError
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( { model
                                | status = Just (Error "Restore mutation affected multiple records, which is unexpected")
                                , state = RestoreError
                              }
                            , Cmd.none
                            )

                Err error ->
                    GraphQL.handleFailure "GraphQL note restoration failed" error <|
                        { model | state = RestoreError }


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    case model.note of
        Just note ->
            [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Trash Note" ]
            , Status.view model.status
            , div
                [ style "border" "1px solid #ddd"
                , style "padding" "0.75rem"
                , style "border-radius" "0.5rem"
                , style "margin-bottom" "0.5rem"
                ]
                [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
                , p [ style "margin" "0" ] [ text note.body ]
                ]
            , FE.buttons <|
                case model.state of
                    Ready ->
                        [ FE.attemptButton "Confirm" (wrapperMsg AttemptTrashNote)
                        , navButton
                        ]

                    Trashing ->
                        [ navButton ]

                    TrashedOk ->
                        [ FE.attemptButton "Restore" (wrapperMsg AttemptRestoreNote)
                        , navButton
                        ]

                    TrashError ->
                        [ navButton ]

                    Restoring ->
                        [ navButton ]

                    RestoredOk ->
                        [ FE.attemptButton "Trash Again" (wrapperMsg AttemptTrashNote)
                        , navButton
                        ]

                    RestoreError ->
                        [ navButton ]
            ]

        Nothing ->
            []
