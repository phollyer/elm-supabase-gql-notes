module Lib.GraphQL exposing
    ( Config
    , createNoteCmd
    , formatError
    , handleFailure
    , isAuthError
    , refreshSessionCmd
    , updateNoteCmd
    )

import Api exposing (Datetime(..), Uuid(..))
import CreateNote.CreateNote as CreateNote
import GraphQL.Engine
import Http
import Pages.Shared.Status exposing (Status(..))
import Ports.Supabase as Supabase
import UpdateNote.UpdateNote as UpdateNote


type alias Config =
    { graphqlUrl : String
    , publishableKey : String
    }


headers : String -> String -> List Http.Header
headers publishableKey accessToken =
    [ Http.header "apiKey" publishableKey
    , Http.header "Authorization" ("Bearer " ++ accessToken)
    ]


isAuthError : GraphQL.Engine.Error -> Bool
isAuthError error =
    case error of
        GraphQL.Engine.BadStatus badStatus ->
            badStatus.status == 401

        _ ->
            False


formatError : GraphQL.Engine.Error -> String
formatError error =
    case error of
        GraphQL.Engine.BadUrl badUrl ->
            "Bad URL: " ++ badUrl

        GraphQL.Engine.Timeout ->
            "Request timed out."

        GraphQL.Engine.NetworkError ->
            "Network error."

        GraphQL.Engine.BadStatus badStatus ->
            "HTTP " ++ String.fromInt badStatus.status ++ ": " ++ badStatus.responseBody

        GraphQL.Engine.BadBody badBody ->
            "Response decoding failed: " ++ badBody.decodingError

        GraphQL.Engine.ErrorField field ->
            case field.errors of
                [] ->
                    "GraphQL returned an empty errors list."

                errors ->
                    "GraphQL error: "
                        ++ String.join ", " (List.map .message errors)


handleFailure : String -> GraphQL.Engine.Error -> { m | status : Maybe Status, requestId : Int } -> ( { m | status : Maybe Status, requestId : Int }, Cmd msg )
handleFailure prefix error model =
    if isAuthError error then
        ( { model | status = Just (Error (prefix ++ ": session expired, refreshing...")) }
        , refreshSessionCmd <| "refresh-session-" ++ String.fromInt model.requestId
        )

    else
        ( { model | status = Just (Error (prefix ++ ": " ++ formatError error)) }
        , Cmd.none
        )


refreshSessionCmd : String -> Cmd msg
refreshSessionCmd requestId =
    Supabase.sendCommand (Supabase.RefreshSession { requestId = requestId })


createNoteCmd : Config -> String -> String -> (Result GraphQL.Engine.Error CreateNote.Response -> msg) -> String -> String -> Cmd msg
createNoteCmd config accessToken userId graphqlNoteCreated title body =
    Cmd.map graphqlNoteCreated <|
        Api.mutation
            (CreateNote.mutation
                { userId = Uuid userId
                , title = title
                , body = body
                }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


updateNoteCmd : Config -> String -> (Result GraphQL.Engine.Error UpdateNote.Response -> msg) -> Supabase.Note -> Cmd msg
updateNoteCmd config accessToken graphqlNoteUpdated note =
    Cmd.map graphqlNoteUpdated <|
        Api.mutation
            (UpdateNote.mutation
                { id = Uuid note.id
                , title = note.title
                , body = note.body
                }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }
