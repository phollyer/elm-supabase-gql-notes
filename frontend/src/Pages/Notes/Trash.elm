module Pages.Notes.Trash exposing
    ( Model
    , Msg
    , fetch
    , init
    , update
    , view
    )

import Api exposing (Datetime(..), Uuid(..))
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL exposing (Config)
import Notes.GetTrashedNotes.GetTrashedNotes as GetTrashedNotes
import Notes.RestoreNote.RestoreNote as RestoreNote
import Pages.Shared.Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { config : Config
    , accessToken : Maybe String
    , userId : Maybe String
    , requestId : Int
    , notes : List Supabase.Note
    , status : Maybe Status
    }


init : Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { config = config
    , accessToken = accessToken
    , userId = userId
    , requestId = 0
    , notes = []
    , status = Nothing
    }


fetch : Model -> ( Model, Cmd Msg )
fetch model =
    case model.accessToken of
        Nothing ->
            ( { model | status = Just (Error "Access token is missing.") }
            , GraphQL.refreshSessionCmd <|
                "refresh-session-"
                    ++ String.fromInt model.requestId
            )

        Just accessToken ->
            ( model
            , GraphQL.fetchTrashCmd model.config accessToken GraphqlTrashLoaded
            )


type Msg
    = AttemptRestoreNote Supabase.Note
    | GraphqlTrashLoaded (Result GraphQL.Engine.Error GetTrashedNotes.Response)
    | GraphqlNoteRestored (Result GraphQL.Engine.Error RestoreNote.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptRestoreNote note ->
            case model.accessToken of
                Nothing ->
                    ( { model | status = Just (Error "Access token is missing.") }
                    , GraphQL.refreshSessionCmd <|
                        "refresh-session-"
                            ++ String.fromInt model.requestId
                    )

                Just accessToken ->
                    ( { model | status = Just (Error "Restoring note...") }
                    , GraphQL.restoreNoteCmd model.config accessToken GraphqlNoteRestored note
                    )

        GraphqlTrashLoaded (Ok response) ->
            ( { model
                | notes = GraphQL.getActiveNotesToSupabaseNotes response
                , status = Nothing
              }
            , Cmd.none
            )

        GraphqlTrashLoaded (Err error) ->
            let
                ( updatedModel, cmd ) =
                    GraphQL.handleFailure "Failed to fetch trashed notes" error model
            in
            ( updatedModel, cmd )

        GraphqlNoteRestored (Ok response) ->
            case response.updateNotesCollection.records of
                record :: _ ->
                    ( { model
                        | notes = List.filter (\n -> n.id /= Api.uuidToString record.id) model.notes
                        , status = Just (Error "Note restored successfully.")
                      }
                    , Cmd.none
                    )

                [] ->
                    ( { model | status = Just (Error "No records returned from restore operation.") }
                    , Cmd.none
                    )

        GraphqlNoteRestored (Err error) ->
            let
                ( updatedModel, cmd ) =
                    GraphQL.handleFailure "Failed to restore note" error model
            in
            ( updatedModel, cmd )


view : (Supabase.Note -> Html msg) -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Trash" ]
    , div [ style "margin-top" "1rem" ] (List.map (noteCard navButton wrapperMsg) model.notes)
    ]


noteCard : (Supabase.Note -> Html msg) -> (Msg -> msg) -> Supabase.Note -> Html msg
noteCard navButton wrapperMsg note =
    div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
        , p [ style "margin" "0" ] [ text note.body ]
        , FE.buttons
            [ FE.attemptButton "Restore" (wrapperMsg <| AttemptRestoreNote note)
            , navButton note
            ]
        ]
