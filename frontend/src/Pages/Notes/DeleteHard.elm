module Pages.Notes.DeleteHard exposing
    ( Model
    , Msg
    , init
    , setNote
    , update
    , view
    )

import DeleteNoteHard.DeleteNoteHard as DeleteNoteHard
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Pages.Shared.Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { note : Maybe Supabase.Note
    , status : Maybe Status
    , state : State
    , requestId : Int
    , accessToken : Maybe String
    , userId : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { note = Nothing
    , status = Nothing
    , state = Ready
    , requestId = 0
    , accessToken = accessToken
    , userId = userId
    , config = config
    }


type State
    = Ready
    | Deleting
    | DeletedOk
    | DeleteError


setNote : Supabase.Note -> Model -> Model
setNote note model =
    { model | note = Just note }


type Msg
    = AttemptDeleteNote
    | GraphqlNoteDeleted (Result GraphQL.Engine.Error DeleteNoteHard.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptDeleteNote ->
            case ( model.accessToken, model.note ) of
                ( Just accessToken, Just note ) ->
                    ( { model | status = Just (Info "Deleting note...") }
                    , GraphQL.hardDeleteNoteCmd model.config accessToken GraphqlNoteDeleted note
                    )

                ( Nothing, _ ) ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , GraphQL.refreshSessionCmd <|
                        "refresh-session-"
                            ++ String.fromInt model.requestId
                    )

                ( _, Nothing ) ->
                    ( { model | status = Just (Error "No note selected for deletion") }, Cmd.none )

        GraphqlNoteDeleted result ->
            case result of
                Ok response ->
                    case response.deleteFromNotesCollection.affectedCount of
                        1 ->
                            ( { model
                                | status = Just (Success "Note deleted successfully")
                                , note = Nothing
                                , state = DeletedOk
                              }
                            , Cmd.none
                            )

                        0 ->
                            ( { model
                                | status = Just (Error "Delete mutation did not affect any records")
                                , state = DeleteError
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( { model
                                | status = Just (Error "Delete mutation affected multiple records, which is unexpected")
                                , state = DeleteError
                              }
                            , Cmd.none
                            )

                Err error ->
                    GraphQL.handleFailure "GraphQL note deletion failed" error model


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    case model.note of
        Just note ->
            [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Delete Note" ]
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
            , FE.buttons
                [ case model.state of
                    Ready ->
                        FE.attemptButton "Confirm Delete" (wrapperMsg AttemptDeleteNote)

                    Deleting ->
                        div [] []

                    DeletedOk ->
                        div [] []

                    DeleteError ->
                        div [] []
                , navButton
                ]
            ]

        Nothing ->
            []
