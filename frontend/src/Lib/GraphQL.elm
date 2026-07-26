module Lib.GraphQL exposing
    ( Config
    , createNoteCmd
    , fetchNotesCmd
    , fetchProfileCmd
    , fetchTrashCmd
    , formatError
    , getActiveNotesToSupabaseNotes
    , handleFailure
    , hardDeleteNoteCmd
    , isAuthError
    , refreshSessionCmd
    , restoreNoteCmd
    , searchNotesCmd
    , softDeleteNoteCmd
    , updateNoteCmd
    )

import Api exposing (Datetime(..), Uuid(..))
import GraphQL.Engine
import Http
import Notes.CreateNote.CreateNote as CreateNote
import Notes.DeleteNoteHard.DeleteNoteHard as DeleteNoteHard
import Notes.DeleteNoteSoft.DeleteNoteSoft as DeleteNoteSoft
import Notes.GetActiveNotes.GetActiveNotes as GetActiveNotes
import Notes.GetTrashedNotes.GetTrashedNotes as GetTrashedNotes
import Notes.RestoreNote.RestoreNote as RestoreNote
import Notes.SearchNotes.SearchNotes as SearchNotes
import Notes.UpdateNote.UpdateNote as UpdateNote
import Pages.Shared.Status exposing (Status(..))
import Ports.Supabase as Supabase
import Profile.GetProfile.GetProfile as GetProfile


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


handleFailure : String -> GraphQL.Engine.Error -> { m | status : Maybe Status } -> ( { m | status : Maybe Status }, Cmd msg )
handleFailure prefix error model =
    if isAuthError error then
        ( { model | status = Just (Error (prefix ++ ": session expired, refreshing...")) }
        , refreshSessionCmd
        )

    else
        ( { model | status = Just (Error (prefix ++ ": " ++ formatError error)) }
        , Cmd.none
        )


flattenGetActiveNotes : GetActiveNotes.Response -> List GetActiveNotes.Node
flattenGetActiveNotes response =
    List.map .node response.notesCollection.edges


getActiveNotesToSupabaseNotes : GetActiveNotes.Response -> List Supabase.Note
getActiveNotesToSupabaseNotes =
    flattenGetActiveNotes >> List.map toSupabaseNote


toSupabaseNote : GetActiveNotes.Node -> Supabase.Note
toSupabaseNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = Api.uuidToString id
    , title = title
    , body = body
    , createdAt = Api.datetimeToString createdAt
    , updatedAt = Api.datetimeToString updatedAt
    , deletedAt = Maybe.map Api.datetimeToString deletedAt
    }


refreshSessionCmd : Cmd msg
refreshSessionCmd =
    Supabase.sendCommand Supabase.RefreshSession


fetchProfileCmd : Config -> String -> String -> (Result GraphQL.Engine.Error GetProfile.Response -> msg) -> Cmd msg
fetchProfileCmd config accessToken userId graphqlProfileLoaded =
    Cmd.map graphqlProfileLoaded <|
        Api.query
            (GetProfile.query
                { id = Uuid userId }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchNotesCmd : Config -> String -> (Result GraphQL.Engine.Error GetActiveNotes.Response -> msg) -> Cmd msg
fetchNotesCmd config accessToken graphqlNotesLoaded =
    Cmd.map graphqlNotesLoaded <|
        Api.query GetActiveNotes.query
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchTrashCmd : Config -> String -> (Result GraphQL.Engine.Error GetTrashedNotes.Response -> msg) -> Cmd msg
fetchTrashCmd config accessToken graphqlTrashLoaded =
    Cmd.map graphqlTrashLoaded <|
        Api.query GetTrashedNotes.query
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


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


searchNotesCmd : Config -> String -> (Result GraphQL.Engine.Error SearchNotes.Response -> msg) -> String -> Cmd msg
searchNotesCmd config accessToken graphqlSearchNotesLoaded query =
    Cmd.map graphqlSearchNotesLoaded <|
        Api.query
            (SearchNotes.query
                { query = "%" ++ query ++ "%" }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


restoreNoteCmd : Config -> String -> (Result GraphQL.Engine.Error RestoreNote.Response -> msg) -> Supabase.Note -> Cmd msg
restoreNoteCmd config accessToken graphqlNoteRestored note =
    Cmd.map graphqlNoteRestored <|
        Api.mutation
            (RestoreNote.mutation
                { id = Uuid note.id
                , deletedAt = Api.null
                }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


hardDeleteNoteCmd : Config -> String -> (Result GraphQL.Engine.Error DeleteNoteHard.Response -> msg) -> Supabase.Note -> Cmd msg
hardDeleteNoteCmd config accessToken graphqlNoteDeletedHard note =
    Cmd.map graphqlNoteDeletedHard <|
        Api.mutation
            (DeleteNoteHard.mutation
                { id = Uuid note.id }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


softDeleteNoteCmd : Config -> String -> (Result GraphQL.Engine.Error DeleteNoteSoft.Response -> msg) -> Supabase.Note -> Cmd msg
softDeleteNoteCmd config accessToken graphqlNoteDeletedSoft note =
    Cmd.map graphqlNoteDeletedSoft <|
        Api.mutation
            (DeleteNoteSoft.mutation
                { id = Uuid note.id
                , deletedAt = Datetime "1970-01-01T00:00:00Z"
                }
            )
            { headers = headers config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }
