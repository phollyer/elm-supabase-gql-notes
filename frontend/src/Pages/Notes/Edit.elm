module Pages.Notes.Edit exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Api
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE
import UpdateNote.UpdateNote as UpdateNote


type alias Model =
    { note : Maybe Supabase.Note
    , title : String
    , body : String
    , titleError : Maybe Error
    , status : Maybe Status
    , requestId : Int
    , accessToken : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe Supabase.Note -> Model
init config accessToken maybeNote =
    case maybeNote of
        Nothing ->
            { note = Nothing
            , title = ""
            , body = ""
            , titleError = Nothing
            , status = Just (Error "No note provided for editing")
            , requestId = 0
            , accessToken = accessToken
            , config = config
            }

        Just note ->
            { note = Just note
            , title = note.title
            , body = note.body
            , titleError = Nothing
            , status = Nothing
            , requestId = 0
            , accessToken = accessToken
            , config = config
            }


toSupabaseUpdateNote : UpdateNote.Records -> Supabase.Note
toSupabaseUpdateNote { id, title, body, createdAt, updatedAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString updatedAt
    , deletedAt = Nothing
    }


type Msg
    = TitleUpdated String
    | BodyUpdated String
    | AttemptUpdateNote
    | GraphqlNoteUpdated (Result GraphQL.Engine.Error UpdateNote.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleUpdated newTitle ->
            ( { model | title = newTitle, titleError = Error.checkNoteTitle newTitle }, Cmd.none )

        BodyUpdated newBody ->
            ( { model | body = newBody }, Cmd.none )

        AttemptUpdateNote ->
            case Error.checkNoteTitle model.title of
                Just error ->
                    ( { model | titleError = Just error }, Cmd.none )

                Nothing ->
                    case ( model.accessToken, model.note ) of
                        ( Just accessToken, Just note ) ->
                            let
                                updatedNote =
                                    { note | title = model.title, body = model.body }
                            in
                            ( { model | status = Just (Status.Info "Updating note...") }
                            , GraphQL.updateNoteCmd model.config accessToken GraphqlNoteUpdated updatedNote
                            )

                        ( Nothing, Just _ ) ->
                            let
                                newRequestId =
                                    model.requestId + 1
                            in
                            ( { model
                                | status = Just (Error "Session info missing. Re-checking session...")
                                , requestId = newRequestId
                              }
                            , GraphQL.refreshSessionCmd <|
                                ("refresh-session-" ++ String.fromInt newRequestId)
                            )

                        ( _, Nothing ) ->
                            ( { model | status = Just (Error "No note provided for updating") }, Cmd.none )

        GraphqlNoteUpdated result ->
            case result of
                Ok response ->
                    case response.updateNotesCollection.records of
                        record :: _ ->
                            let
                                updatedNote =
                                    toSupabaseUpdateNote record
                            in
                            ( { model
                                | note = Just updatedNote
                                , titleError = Nothing
                                , status = Just (Success "Note updated successfully")
                              }
                            , Cmd.none
                            )

                        [] ->
                            ( { model | status = Just (Error "Update mutation returned empty records list") }
                            , Cmd.none
                            )

                Err error ->
                    GraphQL.handleFailure "GraphQL note update failed" error model


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Edit Note" ]
    , Status.view model.status
    , FE.notesTitleInput model.title (wrapperMsg << TitleUpdated)
    , Error.view model.titleError
    , FE.notesContentInput model.body (wrapperMsg << BodyUpdated)
    , FE.buttons
        [ FE.attemptButton "Update note" (wrapperMsg AttemptUpdateNote)
        , navButton
        ]
    ]
