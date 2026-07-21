module Pages.Notes.Search exposing
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
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import SearchNotes.SearchNotes as SearchNotes
import UI.FormElements as FE


type alias Model =
    { searchTerm : String
    , searchResults : List Supabase.Note
    , status : Maybe Status
    , requestId : Int
    , accessToken : Maybe String
    , userId : Maybe String
    , config : GraphQL.Config
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { searchTerm = ""
    , searchResults = []
    , status = Nothing
    , requestId = 0
    , accessToken = accessToken
    , userId = userId
    , config = config
    }


flattenSearchNotes : SearchNotes.Response -> List SearchNotes.Node
flattenSearchNotes response =
    List.map .node response.notesCollection.edges


getSearchNotesToSupabaseNotes : SearchNotes.Response -> List Supabase.Note
getSearchNotesToSupabaseNotes =
    flattenSearchNotes >> List.map toSupabaseSearchNote


toSupabaseSearchNote : SearchNotes.Node -> Supabase.Note
toSupabaseSearchNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString updatedAt
    , deletedAt = Maybe.map Api.datetimeToString deletedAt
    }


type Msg
    = SearchFieldUpdated String
    | ClearResults
    | AttemptSearch
    | GraphQLSearchNotesLoaded (Result GraphQL.Engine.Error SearchNotes.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchFieldUpdated searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        ClearResults ->
            ( { model
                | searchResults = []
                , searchTerm = ""
                , status = Nothing
              }
            , Cmd.none
            )

        AttemptSearch ->
            case model.accessToken of
                Just accessToken ->
                    ( { model | status = Just (Info "Searching notes...") }
                    , GraphQL.searchNotesCmd model.config accessToken GraphQLSearchNotesLoaded model.searchTerm
                    )

                Nothing ->
                    ( { model | status = Just (Error "No access token. Re-checking session...") }
                    , GraphQL.refreshSessionCmd <|
                        "refresh-session-"
                            ++ String.fromInt model.requestId
                    )

        GraphQLSearchNotesLoaded (Ok response) ->
            let
                results =
                    getSearchNotesToSupabaseNotes response

                count =
                    List.length results
            in
            ( { model
                | searchResults = getSearchNotesToSupabaseNotes response
                , status = Just (Info <| "Found " ++ String.fromInt count ++ " notes matching your search")
              }
            , Cmd.none
            )

        GraphQLSearchNotesLoaded (Err error) ->
            ( { model | status = Just (Error ("Search failed: " ++ GraphQL.formatError error)) }
            , Cmd.none
            )


view : Html msg -> (Supabase.Note -> Html msg) -> (Supabase.Note -> Html msg) -> (Msg -> msg) -> Model -> List (Html msg)
view navButton editButton trashButton wrapperMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Search Notes" ]
    , Status.view model.status
    , FE.searchNotesInput model.searchTerm (wrapperMsg << SearchFieldUpdated)
    , FE.buttons
        [ FE.searchButton (wrapperMsg AttemptSearch)
        , FE.clearResultsButton (wrapperMsg ClearResults)
        , navButton
        ]
    , div [ style "margin-top" "1rem" ] (List.map (noteCard editButton trashButton) model.searchResults)
    ]


noteCard : (Supabase.Note -> Html msg) -> (Supabase.Note -> Html msg) -> Supabase.Note -> Html msg
noteCard editButton trashButton note =
    div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
        , p [ style "margin" "0" ] [ text note.body ]
        , FE.buttons
            [ editButton note
            , trashButton note
            ]
        ]
