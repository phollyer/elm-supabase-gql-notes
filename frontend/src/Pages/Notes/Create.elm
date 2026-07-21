module Pages.Notes.Create exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Api
import CreateNote.CreateNote as CreateNote
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { note : Maybe Supabase.Note
    , title : String
    , body : String
    , titleError : Maybe Error
    , status : Maybe Status
    , requestId : Int
    , accessToken : Maybe String
    , userId : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { note = Nothing
    , title = ""
    , body = ""
    , titleError = Nothing
    , status = Nothing
    , requestId = 0
    , accessToken = accessToken
    , userId = userId
    , config = config
    }


toSupabaseCreatedNote : CreateNote.Records -> Supabase.Note
toSupabaseCreatedNote { id, title, body, createdAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString createdAt
    , deletedAt = Nothing
    }


type Msg
    = TitleUpdated String
    | BodyUpdated String
    | AttemptCreateNote
    | GraphqlNoteCreated (Result GraphQL.Engine.Error CreateNote.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleUpdated value ->
            ( { model | title = value }, Cmd.none )

        BodyUpdated value ->
            ( { model | body = value }, Cmd.none )

        AttemptCreateNote ->
            case Error.checkNoteTitle model.title of
                Just error ->
                    ( { model
                        | status = Just (Status.Error "Please fix the errors below")
                        , titleError = Just error
                      }
                    , Cmd.none
                    )

                Nothing ->
                    case ( model.accessToken, model.userId ) of
                        ( Just accessToken, Just userId ) ->
                            ( { model | status = Just (Status.Info "Creating note...") }
                            , GraphQL.createNoteCmd model.config accessToken userId GraphqlNoteCreated model.title model.body
                            )

                        _ ->
                            let
                                newRequestId =
                                    model.requestId + 1
                            in
                            ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                            , GraphQL.refreshSessionCmd <|
                                ("refresh-session-" ++ String.fromInt newRequestId)
                            )

        GraphqlNoteCreated result ->
            case result of
                Ok response ->
                    case response.insertIntoNotesCollection of
                        Just { records } ->
                            case records of
                                record :: _ ->
                                    ( { model
                                        | note = Just (toSupabaseCreatedNote record)
                                        , status = Just (Success "Note created successfully")
                                        , title = ""
                                        , titleError = Nothing
                                        , body = ""
                                      }
                                    , Cmd.none
                                    )

                                [] ->
                                    ( { model | status = Just (Error "Create mutation returned an empty records list; likely causes: INSERT happened but no row was returned by the GraphQL selection, or RLS limited visible rows") }
                                    , Cmd.none
                                    )

                        Nothing ->
                            ( { model | status = Just (Error "Create mutation returned null for insertIntoNotesCollection; likely causes: mutation field resolved to null due to permissions, schema mismatch, or upstream GraphQL resolver failure") }
                            , Cmd.none
                            )

                Err error ->
                    GraphQL.handleFailure "GraphQL note creation failed" error model


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Create Note" ]
    , Status.view model.status
    , FE.notesTitleInput model.title (wrapperMsg << TitleUpdated)
    , Error.view model.titleError
    , FE.notesContentInput model.body (wrapperMsg << BodyUpdated)
    , FE.buttons
        [ FE.attemptButton "Create note" (wrapperMsg AttemptCreateNote)
        , navButton
        ]
    ]
