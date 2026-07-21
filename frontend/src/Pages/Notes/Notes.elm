module Pages.Notes.Notes exposing
    ( Model
    , Msg
    , fetch
    , init
    , update
    , view
    )

import Api
import GetActiveNotes.GetActiveNotes as GetActiveNotes
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { notes : List Supabase.Note
    , status : Maybe Status
    , requestId : Int
    , accessToken : Maybe String
    , userId : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { notes = []
    , status = Nothing
    , requestId = 0
    , accessToken = accessToken
    , userId = userId
    , config = config
    }


fetch : Model -> ( Model, Cmd Msg )
fetch model =
    case model.accessToken of
        Nothing ->
            let
                nextRequestId =
                    model.requestId + 1
            in
            ( { model
                | status = Just (Error "No access token available for initializing notes")
                , requestId = nextRequestId
              }
            , GraphQL.refreshSessionCmd <|
                "refresh-session-"
                    ++ String.fromInt nextRequestId
            )

        Just accessToken ->
            ( { model | status = Just (Info "Fetching notes...") }
            , GraphQL.fetchNotesCmd model.config accessToken GraphQLNotesLoaded
            )


flattenGetNotes : GetActiveNotes.Response -> List GetActiveNotes.Node
flattenGetNotes response =
    List.map .node response.notesCollection.edges


getNotesToSupabaseNotes : GetActiveNotes.Response -> List Supabase.Note
getNotesToSupabaseNotes =
    flattenGetNotes >> List.map toSupabaseNote


toSupabaseNote : GetActiveNotes.Node -> Supabase.Note
toSupabaseNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString updatedAt
    , deletedAt = Maybe.map Api.datetimeToString deletedAt
    }


type Msg
    = Refresh
    | GraphQLNotesLoaded (Result GraphQL.Engine.Error GetActiveNotes.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Refresh ->
            case model.accessToken of
                Nothing ->
                    ( { model | status = Just (Error "No access token available for refreshing notes") }
                    , Cmd.none
                    )

                Just accessToken ->
                    ( { model | status = Just (Info "Refreshing notes...") }
                    , GraphQL.fetchNotesCmd model.config accessToken GraphQLNotesLoaded
                    )

        GraphQLNotesLoaded (Ok response) ->
            case getNotesToSupabaseNotes response of
                [] ->
                    ( { model | status = Just (Error "No notes found in response") }
                    , Cmd.none
                    )

                notes ->
                    ( { model
                        | notes = notes
                        , status = Just (Success "Notes loaded successfully")
                      }
                    , Cmd.none
                    )

        GraphQLNotesLoaded (Err error) ->
            GraphQL.handleFailure "GraphQL note update failed" error model


view : (Supabase.Note -> msg) -> (Supabase.Note -> msg) -> Model -> List (Html msg)
view editMsg trashMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Notes" ]
    , Status.view model.status
    , div [ style "margin-top" "1rem" ] (List.map (noteCard editMsg trashMsg) model.notes)
    ]


noteCard : (Supabase.Note -> msg) -> (Supabase.Note -> msg) -> Supabase.Note -> Html msg
noteCard editMsg trashMsg note =
    div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
        , p [ style "margin" "0" ] [ text note.body ]
        , FE.buttons
            [ FE.gotoButton "Edit" (editMsg note)
            , FE.gotoButton "Trash Note" (trashMsg note)
            ]
        ]
