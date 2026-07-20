module Main exposing (main)

import Api exposing (Datetime(..), Uuid(..))
import Browser
import CreateNote.CreateNote as CreateNote
import DeleteNoteHard.DeleteNoteHard as DeleteNoteHard
import DeleteNoteSoft.DeleteNoteSoft as DeleteNoteSoft
import GetActiveNotes.GetActiveNotes as GetActiveNotes
import GetProfile.GetProfile as GetProfile
import GetTrashedNotes.GetTrashedNotes as GetTrashedNotes
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode
import Pages.Profile as Profile
import Ports.Supabase as Supabase
import RestoreNote.RestoreNote as RestoreNote
import SearchNotes.SearchNotes as SearchNotes
import String
import UI.FormElements exposing (attemptButton, clearResultsButton, emailInput, gotoButton, gotoStartButton, notesContentInput, notesTitleInput, passwordConfirmInput, passwordInput, searchButton, searchNotesInput)
import UpdateNote.UpdateNote as UpdateNote
import UpdateProfileAvatar.UpdateProfileAvatar as UpdateProfileAvatar


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { email : String
    , emailError : Maybe String
    , password : String
    , passwordError : Maybe String
    , passwordConfirm : String
    , passwordConfirmError : Maybe String
    , config : Config
    , accessToken : Maybe String
    , userId : Maybe String
    , title : String
    , titleError : Maybe String
    , body : String
    , profilePage : Profile.Model
    , status : Maybe Status
    , state : State
    , currentNote : Maybe Supabase.Note
    , notes : List Supabase.Note
    , trashedNotes : List Supabase.Note
    , searchQuery : String
    , searchResults : List Supabase.Note
    , nextId : Int
    }


type alias Config =
    { graphqlUrl : String
    , publishableKey : String
    }


type alias Flags =
    { publishableKey : String
    , graphqlUrl : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { email = ""
      , emailError = Nothing
      , password = ""
      , passwordError = Nothing
      , passwordConfirm = ""
      , passwordConfirmError = Nothing
      , config = { graphqlUrl = flags.graphqlUrl, publishableKey = flags.publishableKey }
      , accessToken = Nothing
      , userId = Nothing
      , title = ""
      , titleError = Nothing
      , body = ""
      , profilePage = Profile.init
      , status = Just (Info "Checking session...")
      , state = Start
      , currentNote = Nothing
      , notes = []
      , trashedNotes = []
      , searchQuery = ""
      , searchResults = []
      , nextId = 1
      }
    , Supabase.sendCommand (Supabase.InitializeSession { requestId = "init-0" })
    )


type Status
    = Success String
    | Error String
    | Warning String
    | Info String


type State
    = Start
    | SignUp
    | SignIn
    | MagicLink
    | SignedIn ViewState


type ViewState
    = ViewReady
    | ViewingNotes
    | ViewingTrash
    | ViewingProfile
    | CreatingNote
    | EditingNote
    | SearchingNotes
    | TrashingNote DeleteState
    | DeleteNote DeleteState


type DeleteState
    = DeleteReady
    | DeleteSuccess
    | DeleteFailure


type Msg
    = ProfileMsg Profile.Msg
    | EmailUpdated String
    | PasswordUpdated String
    | PasswordConfirmUpdated String
    | TitleUpdated String
    | BodyUpdated String
    | StartSessionCheck
    | AttemptPasswordSignIn
    | AttemptPasswordSignUp
    | AttemptMagicLinkSignIn
    | AttemptSignOut
    | AttemptCreateNote
    | AttemptDeleteNoteHard
    | AttemptDeleteNoteSoft
    | AttemptRestoreNote Supabase.Note
    | AttemptUpdateNote
    | AttemptFetchNotes
    | AttemptFetchTrash
    | AttemptSearchNotes
    | AttemptFetchProfile
    | SearchQueryUpdated String
    | ClearResults
    | GotoStart
    | GotoSignUp
    | GotoSignIn
    | GotoMagicLink
    | GotoNotes
    | GotoSearch
    | GotoCreateNote
    | GotoEditNote Supabase.Note
    | GotoDeleteNote Supabase.Note
    | GotoTrashNote Supabase.Note
    | GotoProfilePage
    | GraphqlNotesLoaded (Result GraphQL.Engine.Error GetActiveNotes.Response)
    | GraphqlNoteCreated (Result GraphQL.Engine.Error CreateNote.Response)
    | GraphqlNoteDeletedHard (Result GraphQL.Engine.Error DeleteNoteHard.Response)
    | GraphqlNoteDeletedSoft (Result GraphQL.Engine.Error DeleteNoteSoft.Response)
    | GraphqlNoteRestored (Result GraphQL.Engine.Error RestoreNote.Response)
    | GraphqlNoteUpdated (Result GraphQL.Engine.Error UpdateNote.Response)
    | GraphqlSearchNotesLoaded (Result GraphQL.Engine.Error SearchNotes.Response)
    | GraphqlTrashLoaded (Result GraphQL.Engine.Error GetTrashedNotes.Response)
    | GraphqlAvatarPathUpdated (Result GraphQL.Engine.Error UpdateProfileAvatar.Response)
    | GraphqlProfileLoaded (Result GraphQL.Engine.Error GetProfile.Response)
    | SupabaseEventReceived Decode.Value


graphqlHeaders : String -> String -> List Http.Header
graphqlHeaders publishableKey accessToken =
    [ Http.header "apiKey" publishableKey
    , Http.header "Authorization" ("Bearer " ++ accessToken)
    ]


uuidToString : Uuid -> String
uuidToString (Uuid uuidStr) =
    uuidStr


datetimeToString : Datetime -> String
datetimeToString (Datetime datetime) =
    datetime


nextRequestId : Model -> String
nextRequestId model =
    "req-" ++ String.fromInt model.nextId


flattenGetNotes : GetActiveNotes.Response -> List GetActiveNotes.Node
flattenGetNotes response =
    List.map .node response.notesCollection.edges


flattenSearchNotes : SearchNotes.Response -> List SearchNotes.Node
flattenSearchNotes response =
    List.map .node response.notesCollection.edges


getNotesToSupabaseNotes : GetActiveNotes.Response -> List Supabase.Note
getNotesToSupabaseNotes =
    flattenGetNotes >> List.map toSupabaseNote


getSearchNotesToSupabaseNotes : SearchNotes.Response -> List Supabase.Note
getSearchNotesToSupabaseNotes =
    flattenSearchNotes >> List.map toSupabaseSearchNote


toSupabaseCreatedNote : CreateNote.Records -> Supabase.Note
toSupabaseCreatedNote { id, title, body, createdAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString createdAt
    , deletedAt = Nothing
    }


toSupabaseUpdateNote : UpdateNote.Records -> Supabase.Note
toSupabaseUpdateNote { id, title, body, createdAt, updatedAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString updatedAt
    , deletedAt = Nothing
    }


toSupabaseDeleteNoteSoft : DeleteNoteSoft.Records -> Supabase.Note
toSupabaseDeleteNoteSoft { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString updatedAt
    , deletedAt = Maybe.map datetimeToString deletedAt
    }


toSupabaseNote : GetActiveNotes.Node -> Supabase.Note
toSupabaseNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString updatedAt
    , deletedAt = Maybe.map datetimeToString deletedAt
    }


toSupabaseSearchNote : SearchNotes.Node -> Supabase.Note
toSupabaseSearchNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString updatedAt
    , deletedAt = Maybe.map datetimeToString deletedAt
    }


createNoteCmd : Config -> String -> String -> String -> String -> Cmd Msg
createNoteCmd config accessToken userId title body =
    Cmd.map GraphqlNoteCreated <|
        Api.mutation
            (CreateNote.mutation
                { userId = Uuid userId
                , title = title
                , body = body
                }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


restoreNoteCmd : Config -> String -> Supabase.Note -> Cmd Msg
restoreNoteCmd config accessToken note =
    Cmd.map GraphqlNoteRestored <|
        Api.mutation
            (RestoreNote.mutation
                { id = Uuid note.id
                , deletedAt = Api.null
                }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


hardDeleteNoteCmd : Config -> String -> Supabase.Note -> Cmd Msg
hardDeleteNoteCmd config accessToken note =
    Cmd.map GraphqlNoteDeletedHard <|
        Api.mutation
            (DeleteNoteHard.mutation
                { id = Uuid note.id }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


softDeleteNoteCmd : Config -> String -> Supabase.Note -> Cmd Msg
softDeleteNoteCmd config accessToken note =
    Cmd.map GraphqlNoteDeletedSoft <|
        Api.mutation
            (DeleteNoteSoft.mutation
                { id = Uuid note.id
                , deletedAt = Datetime "1970-01-01T00:00:00Z"
                }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


updateNoteCmd : Config -> String -> Supabase.Note -> Cmd Msg
updateNoteCmd config accessToken note =
    Cmd.map GraphqlNoteUpdated <|
        Api.mutation
            (UpdateNote.mutation
                { id = Uuid note.id
                , title = note.title
                , body = note.body
                }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchNotesCmd : Config -> String -> Cmd Msg
fetchNotesCmd config accessToken =
    Cmd.map GraphqlNotesLoaded <|
        Api.query GetActiveNotes.query
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchTrashCmd : Config -> String -> Cmd Msg
fetchTrashCmd config accessToken =
    Cmd.map GraphqlTrashLoaded <|
        Api.query GetTrashedNotes.query
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


searchNotesCmd : Config -> String -> String -> Cmd Msg
searchNotesCmd config accessToken query =
    Cmd.map GraphqlSearchNotesLoaded <|
        Api.query
            (SearchNotes.query
                { query = "%" ++ query ++ "%" }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchProfileCmd : Config -> String -> String -> Cmd Msg
fetchProfileCmd config accessToken userId =
    Cmd.map GraphqlProfileLoaded <|
        Api.query
            (GetProfile.query
                { id = Uuid userId }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


updateProfileAvatarPathCmd : Config -> String -> String -> String -> Cmd Msg
updateProfileAvatarPathCmd config accessToken userId avatarPath =
    Cmd.map GraphqlAvatarPathUpdated <|
        Api.mutation
            (UpdateProfileAvatar.mutation
                { id = Uuid userId
                , avatarPath = Api.present avatarPath
                }
            )
            { headers = graphqlHeaders config.publishableKey accessToken
            , url = config.graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


refreshSessionCmd : Model -> Cmd Msg
refreshSessionCmd model =
    Supabase.sendCommand (Supabase.RefreshSession { requestId = nextRequestId model })


fetchNotes : Model -> ( Model, Cmd Msg )
fetchNotes model =
    case model.accessToken of
        Just accessToken ->
            ( { model
                | state = SignedIn ViewingNotes
                , status = Just (Info "Loading notes...")
                , notes = []
              }
            , fetchNotesCmd model.config accessToken
            )

        Nothing ->
            ( { model | status = Just (Error "No access token. Re-checking session...") }
            , refreshSessionCmd model
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Supabase.supabaseIn SupabaseEventReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartSessionCheck ->
            ( { model | status = Just (Info "Checking session...") }
            , refreshSessionCmd model
            )

        ProfileMsg profileMsg ->
            let
                ( updatedProfileModel, profileCmd ) =
                    Profile.update profileMsg model.profilePage
            in
            ( { model | profilePage = updatedProfileModel }
            , Cmd.map ProfileMsg profileCmd
            )

        GotoStart ->
            ( { model
                | status = Just (Info "Please sign up or sign in")
                , state = Start
              }
            , Cmd.none
            )

        GotoSignUp ->
            ( { model
                | status = Nothing
                , state = SignUp
                , email = ""
                , password = ""
                , passwordConfirm = ""
                , emailError = Nothing
                , passwordError = Nothing
                , passwordConfirmError = Nothing
              }
            , Cmd.none
            )

        GotoSignIn ->
            ( { model
                | status = Nothing
                , state = SignIn
                , email = ""
                , emailError = Nothing
                , password = ""
                , passwordError = Nothing
              }
            , Cmd.none
            )

        GotoMagicLink ->
            ( { model
                | status = Just (Info "Use the magic link to sign in via email")
                , state = MagicLink
                , email = ""
                , emailError = Nothing
              }
            , Cmd.none
            )

        GotoCreateNote ->
            ( { model
                | title = ""
                , body = ""
                , currentNote = Nothing
                , status = Nothing
                , state = SignedIn CreatingNote
              }
            , Cmd.none
            )

        GotoEditNote note ->
            ( { model
                | title = note.title
                , body = note.body
                , currentNote = Just note
                , status = Nothing
                , state = SignedIn EditingNote
              }
            , Cmd.none
            )

        GotoDeleteNote note ->
            ( { model
                | currentNote = Just note
                , status = Just (Warning "Permanently delete this note?")
                , state = SignedIn (DeleteNote DeleteReady)
              }
            , Cmd.none
            )

        GotoTrashNote note ->
            ( { model
                | currentNote = Just note
                , status = Just (Warning "This will put your note in the trash. You can restore it later.")
                , state = SignedIn (TrashingNote DeleteReady)
              }
            , Cmd.none
            )

        GotoNotes ->
            fetchNotes model

        GotoSearch ->
            ( { model
                | status = Nothing
                , state = SignedIn SearchingNotes
              }
            , Cmd.none
            )

        GotoProfilePage ->
            ( { model
                | status = Nothing
                , state = SignedIn ViewingProfile
              }
            , case ( model.accessToken, model.userId ) of
                ( Just accessToken, Just userId ) ->
                    fetchProfileCmd model.config accessToken userId

                _ ->
                    Cmd.none
            )

        SearchQueryUpdated value ->
            ( { model | searchQuery = value }, Cmd.none )

        ClearResults ->
            ( { model | searchResults = [] }, Cmd.none )

        EmailUpdated value ->
            ( { model | email = value }, Cmd.none )

        PasswordUpdated value ->
            ( { model | password = value }, Cmd.none )

        PasswordConfirmUpdated value ->
            ( { model | passwordConfirm = value }, Cmd.none )

        AttemptPasswordSignUp ->
            let
                emailError =
                    if String.isEmpty model.email then
                        Just "Email is required"

                    else
                        Nothing

                passwordError =
                    if String.isEmpty model.password then
                        Just "Password is required"

                    else
                        Nothing

                passwordConfirmError =
                    if model.password /= model.passwordConfirm then
                        Just "Passwords do not match"

                    else
                        Nothing

                newModel =
                    { model
                        | emailError = emailError
                        , passwordError = passwordError
                        , passwordConfirmError = passwordConfirmError
                    }
            in
            case ( emailError, passwordError, passwordConfirmError ) of
                ( Nothing, Nothing, Nothing ) ->
                    ( { newModel | status = Nothing }
                    , Supabase.sendCommand
                        (Supabase.SignUpWithPassword
                            { requestId = nextRequestId model
                            , email = model.email
                            , password = model.password
                            }
                        )
                    )

                _ ->
                    ( { newModel | status = Just (Error "Please fix the errors below") }, Cmd.none )

        AttemptPasswordSignIn ->
            if String.isEmpty model.email && String.isEmpty model.password then
                ( { model
                    | status = Just (Error "Please fix the errors below")
                    , emailError = Just "Email is required"
                    , passwordError = Just "Password is required"
                  }
                , Cmd.none
                )

            else if String.isEmpty model.email then
                ( { model
                    | status = Just (Error "Please fix the errors below")
                    , emailError = Just "Email is required"
                  }
                , Cmd.none
                )

            else if String.isEmpty model.password then
                ( { model
                    | status = Just (Error "Please fix the errors below")
                    , passwordError = Just "Password is required"
                  }
                , Cmd.none
                )

            else
                ( { model | status = Just (Info "Signing in...") }
                , Supabase.sendCommand
                    (Supabase.SignInWithPassword
                        { requestId = nextRequestId model
                        , email = model.email
                        , password = model.password
                        }
                    )
                )

        AttemptMagicLinkSignIn ->
            if String.isEmpty model.email then
                ( { model
                    | status = Just (Error "Please fix the errors below")
                    , emailError = Just "Email is required"
                  }
                , Cmd.none
                )

            else
                ( { model | status = Just (Info "Sending magic link...") }
                , Supabase.sendCommand
                    (Supabase.SignInWithMagicLink
                        { requestId = nextRequestId model
                        , email = model.email
                        }
                    )
                )

        AttemptSignOut ->
            ( { model | status = Just (Info "Signing out...") }
            , Supabase.sendCommand (Supabase.SignOut { requestId = nextRequestId model })
            )

        AttemptFetchNotes ->
            fetchNotes model

        AttemptFetchTrash ->
            case model.accessToken of
                Just accessToken ->
                    ( { model | status = Just (Info "Loading trash...") }
                    , fetchTrashCmd model.config accessToken
                    )

                Nothing ->
                    ( { model | status = Just (Error "No access token. Re-checking session...") }
                    , refreshSessionCmd model
                    )

        AttemptCreateNote ->
            if String.isEmpty model.title then
                ( { model
                    | status = Just (Error "Please fix the errors below")
                    , titleError = Just "Title is required"
                  }
                , Cmd.none
                )

            else
                case ( model.accessToken, model.userId ) of
                    ( Just accessToken, Just userId ) ->
                        ( { model | status = Just (Info "Creating note...") }
                        , createNoteCmd model.config accessToken userId model.title model.body
                        )

                    _ ->
                        ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                        , refreshSessionCmd model
                        )

        AttemptDeleteNoteHard ->
            case ( model.accessToken, model.currentNote ) of
                ( Just accessToken, Just note ) ->
                    ( { model | status = Just (Info "Deleting note...") }
                    , hardDeleteNoteCmd model.config accessToken note
                    )

                ( Nothing, _ ) ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , refreshSessionCmd model
                    )

                ( _, Nothing ) ->
                    ( { model | status = Just (Error "No note selected for deletion") }, Cmd.none )

        AttemptDeleteNoteSoft ->
            case ( model.accessToken, model.currentNote ) of
                ( Just accessToken, Just note ) ->
                    ( { model | status = Just (Info "Sending your note to the trash...") }
                    , softDeleteNoteCmd model.config accessToken note
                    )

                ( Nothing, _ ) ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , refreshSessionCmd model
                    )

                ( _, Nothing ) ->
                    ( { model | status = Just (Error "No note selected for deletion") }, Cmd.none )

        AttemptRestoreNote note ->
            case model.accessToken of
                Just accessToken ->
                    ( { model
                        | status = Just (Info "Restoring note...")
                        , currentNote = Just note
                      }
                    , restoreNoteCmd model.config accessToken note
                    )

                Nothing ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , refreshSessionCmd model
                    )

        AttemptUpdateNote ->
            if String.isEmpty model.title then
                ( { model | status = Just (Error "Please fix the errors below") }, Cmd.none )

            else
                case ( model.accessToken, model.currentNote ) of
                    ( Just accessToken, Just note ) ->
                        ( { model | status = Just (Info "Updating note...") }
                        , updateNoteCmd model.config accessToken <|
                            { note
                                | title = model.title
                                , body = model.body
                            }
                        )

                    _ ->
                        ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                        , refreshSessionCmd model
                        )

        AttemptSearchNotes ->
            case model.accessToken of
                Just accessToken ->
                    ( { model | status = Just (Info "Searching notes...") }
                    , searchNotesCmd model.config accessToken model.searchQuery
                    )

                Nothing ->
                    ( { model | status = Just (Error "No access token. Re-checking session...") }
                    , refreshSessionCmd model
                    )

        AttemptFetchProfile ->
            case ( model.accessToken, model.userId ) of
                ( Just accessToken, Just userId ) ->
                    ( { model | status = Just (Info "Loading profile...") }
                    , fetchProfileCmd model.config accessToken userId
                    )

                _ ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , refreshSessionCmd model
                    )

        GraphqlNoteCreated result ->
            case result of
                Ok response ->
                    case response.insertIntoNotesCollection of
                        Just { records } ->
                            case records of
                                record :: _ ->
                                    ( { model
                                        | notes = toSupabaseCreatedNote record :: model.notes
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
                    handleGraphqlFailure "GraphQL note creation failed" error model

        GraphqlNoteDeletedHard result ->
            case result of
                Ok response ->
                    case response.deleteFromNotesCollection.affectedCount of
                        1 ->
                            let
                                deletedNoteId =
                                    case model.currentNote of
                                        Just note ->
                                            note.id

                                        Nothing ->
                                            ""
                            in
                            ( { model
                                | notes =
                                    List.filter (\n -> n.id /= deletedNoteId) model.notes
                                , status = Just (Success "Note deleted successfully")
                                , currentNote = Nothing
                                , state = SignedIn (DeleteNote DeleteSuccess)
                              }
                            , Cmd.none
                            )

                        0 ->
                            ( { model
                                | status = Just (Error "Delete mutation did not affect any records")
                                , state = SignedIn (DeleteNote DeleteFailure)
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( { model
                                | status = Just (Error "Delete mutation affected multiple records, which is unexpected")
                                , state = SignedIn (DeleteNote DeleteFailure)
                              }
                            , Cmd.none
                            )

                Err error ->
                    handleGraphqlFailure "GraphQL note deletion failed" error model

        GraphqlNoteDeletedSoft result ->
            case result of
                Ok response ->
                    case response.updateNotesCollection.records of
                        record :: _ ->
                            let
                                deletedNoteId =
                                    uuidToString record.id
                            in
                            ( { model
                                | notes =
                                    List.filter (\n -> n.id /= deletedNoteId) model.notes
                                , trashedNotes = toSupabaseDeleteNoteSoft record :: model.trashedNotes
                                , status = Just (Success "Note has been trashed successfully")
                                , currentNote = Nothing
                                , state = SignedIn (TrashingNote DeleteSuccess)
                              }
                            , Cmd.none
                            )

                        [] ->
                            ( { model
                                | status = Just (Error "Soft delete mutation returned empty records list")
                                , state = SignedIn (TrashingNote DeleteFailure)
                              }
                            , Cmd.none
                            )

                Err error ->
                    handleGraphqlFailure "GraphQL note soft deletion failed" error model

        GraphqlNoteRestored result ->
            case result of
                Ok response ->
                    case response.updateNotesCollection.affectedCount of
                        1 ->
                            case model.currentNote of
                                Just note ->
                                    let
                                        restoredNote =
                                            { note | deletedAt = Nothing }
                                    in
                                    ( { model
                                        | notes = restoredNote :: model.notes
                                        , trashedNotes =
                                            List.filter (\n -> n.id /= note.id) model.trashedNotes
                                        , status = Just (Success "Note restored successfully")
                                        , currentNote = Nothing
                                      }
                                    , Cmd.none
                                    )

                                Nothing ->
                                    ( { model | status = Just (Error "No current note to restore") }, Cmd.none )

                        0 ->
                            ( { model | status = Just (Error "Restore mutation returned no records") }
                            , Cmd.none
                            )

                        _ ->
                            ( { model | status = Just (Error "Restore mutation affected multiple records, which is unexpected") }
                            , Cmd.none
                            )

                Err error ->
                    handleGraphqlFailure "GraphQL note restoration failed" error model

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
                                | notes =
                                    List.map
                                        (\n ->
                                            if n.id == updatedNote.id then
                                                updatedNote

                                            else
                                                n
                                        )
                                        model.notes
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
                    handleGraphqlFailure "GraphQL note update failed" error model

        GraphqlNotesLoaded result ->
            case result of
                Ok response ->
                    ( { model
                        | notes = getNotesToSupabaseNotes response
                        , status = Nothing
                        , state = SignedIn ViewingNotes
                      }
                    , Cmd.none
                    )

                Err error ->
                    handleGraphqlFailure "GraphQL notes load failed" error model

        GraphqlSearchNotesLoaded result ->
            case result of
                Ok response ->
                    ( { model
                        | searchResults = getSearchNotesToSupabaseNotes response
                        , status = Just (Success "Search completed")
                      }
                    , Cmd.none
                    )

                Err error ->
                    handleGraphqlFailure "GraphQL search failed" error model

        GraphqlAvatarPathUpdated result ->
            case result of
                Ok response ->
                    case response.updateProfilesCollection.affectedCount of
                        1 ->
                            ( { model
                                | status = Just (Success "Avatar path updated successfully")
                              }
                            , Cmd.none
                            )

                        0 ->
                            ( { model | status = Just (Error "Update avatar mutation returned no records") }
                            , Cmd.none
                            )

                        _ ->
                            ( { model | status = Just (Error "Update avatar mutation affected multiple records, which is unexpected") }
                            , Cmd.none
                            )

                Err error ->
                    handleGraphqlFailure "GraphQL avatar path update failed" error model

        GraphqlTrashLoaded result ->
            case result of
                Ok response ->
                    ( { model
                        | trashedNotes = getNotesToSupabaseNotes response
                        , notes = []
                        , status = Nothing
                        , state = SignedIn ViewingTrash
                      }
                    , Cmd.none
                    )

                Err error ->
                    handleGraphqlFailure "GraphQL trash load failed" error model

        GraphqlProfileLoaded result ->
            case result of
                Ok response ->
                    case response.profilesByPk of
                        Just profile ->
                            ( { model
                                | profilePage =
                                    model.profilePage
                                        |> Profile.setEmailAddress profile.email
                                        |> Profile.setDisplayName (Maybe.withDefault "" profile.displayName)
                                        |> Profile.setAvatarUrl (Maybe.map (\path -> "http://localhost:54321/storage/v1/object/public/avatar/" ++ path) profile.avatarPath)
                                , status = Just (Success "Profile loaded")
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            ( { model | status = Just (Error "Profile not found") }, Cmd.none )

                Err error ->
                    handleGraphqlFailure "GraphQL profile load failed" error model

        TitleUpdated value ->
            ( { model | title = value }, Cmd.none )

        BodyUpdated value ->
            ( { model | body = value }, Cmd.none )

        SupabaseEventReceived payload ->
            case Decode.decodeValue Supabase.decodeEvent payload of
                Ok event ->
                    applyEvent event model

                Err _ ->
                    ( { model | status = Just (Error "Unexpected event payload from JS bridge.") }, Cmd.none )


applyEvent : Supabase.Event -> Model -> ( Model, Cmd Msg )
applyEvent event model =
    case event of
        Supabase.SessionReady payload ->
            ( { model
                | accessToken = Just payload.accessToken
                , userId = Just payload.userId
                , state = SignedIn ViewReady
                , status = Nothing
                , email = payload.email
              }
            , Cmd.none
            )

        Supabase.SessionMissing _ ->
            ( { model
                | accessToken = Nothing
                , userId = Nothing
                , state = Start
                , notes = []
                , status = Just (Success "You are signed out")
              }
            , Cmd.none
            )

        Supabase.NotesLoaded payload ->
            ( { model
                | notes = payload.notes
                , status = Just (Success "Notes loaded")
              }
            , Cmd.none
            )

        Supabase.NotesFound payload ->
            ( { model
                | searchResults = payload.notes
                , status = Just (Success "Notes found")
              }
            , Cmd.none
            )

        Supabase.NoteCreated payload ->
            ( { model
                | notes = payload.note :: model.notes
                , title = ""
                , body = ""
                , status = Just (Success "Note saved")
              }
            , Cmd.none
            )

        Supabase.AvatarUploaded payload ->
            case ( model.accessToken, model.userId ) of
                ( Just accessToken, Just userId ) ->
                    ( { model
                        | status = Just (Success "Avatar uploaded")
                        , profilePage = Profile.setAvatarUrl (Just payload.avatarUrl) model.profilePage
                      }
                    , updateProfileAvatarPathCmd model.config accessToken userId payload.avatarPath
                    )

                _ ->
                    ( { model | status = Just (Error "Session info missing. Re-checking session...") }
                    , refreshSessionCmd model
                    )

        Supabase.ErrorRaised payload ->
            ( { model | status = Just (Error payload.message) }
            , Cmd.none
            )


formatGraphqlError : GraphQL.Engine.Error -> String
formatGraphqlError error =
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


isGraphqlAuthError : GraphQL.Engine.Error -> Bool
isGraphqlAuthError error =
    case error of
        GraphQL.Engine.BadStatus badStatus ->
            badStatus.status == 401

        _ ->
            False


handleGraphqlFailure : String -> GraphQL.Engine.Error -> Model -> ( Model, Cmd Msg )
handleGraphqlFailure prefix error model =
    if isGraphqlAuthError error then
        ( { model | status = Just (Error (prefix ++ ": session expired, refreshing...")) }
        , refreshSessionCmd model
        )

    else
        ( { model | status = Just (Error (prefix ++ ": " ++ formatGraphqlError error)) }
        , Cmd.none
        )


view : Model -> Html Msg
view model =
    div
        [ style "font-family" "ui-sans-serif, system-ui, sans-serif"
        , style "max-width" "760px"
        , style "margin" "2rem auto"
        , style "padding" "0 1rem"
        ]
        ([ headerRow
         , case model.state of
            SignedIn _ ->
                div
                    [ style "display" "flex"
                    , style "gap" "0.5rem"
                    ]
                    [ div
                        [ style "display" "flex"
                        , style "gap" "0.5rem"
                        ]
                        [ gotoButton "Create" GotoCreateNote
                        , attemptButton "Notes" AttemptFetchNotes
                        , gotoButton "Search" GotoSearch
                        ]
                    , div
                        [ style "display" "flex"
                        , style "gap" "0.5rem"
                        , style "margin-left" "auto"
                        ]
                        [ attemptButton "Trash" AttemptFetchTrash
                        , gotoButton "Profile" GotoProfilePage
                        , attemptButton "Sign out" AttemptSignOut
                        ]
                    ]

            _ ->
                div [] []
         , statusView model.status
         ]
            ++ (case model.state of
                    Start ->
                        [ buttons
                            [ gotoButton "Sign up" GotoSignUp
                            , gotoButton "Sign in" GotoSignIn
                            , gotoButton "Magic link" GotoMagicLink
                            ]
                        ]

                    SignUp ->
                        signUpView
                            ( model.email, model.emailError )
                            ( model.password, model.passwordError )
                            ( model.passwordConfirm, model.passwordConfirmError )

                    SignIn ->
                        signInView model.email model.password

                    MagicLink ->
                        magicLinkView model.email

                    SignedIn ViewReady ->
                        [ h1 [] [ text "Welcome!" ]
                        , div
                            [ style "margin-top" "1rem"
                            , style "color" "#6b7280"
                            ]
                            [ text "Please fetch/search your notes, or create a new one." ]
                        ]

                    SignedIn ViewingNotes ->
                        signedInNotesView model.notes

                    SignedIn ViewingTrash ->
                        signedInTrashView model.trashedNotes

                    SignedIn SearchingNotes ->
                        searchNotesView model.searchQuery model.searchResults

                    SignedIn CreatingNote ->
                        createNoteView ( model.title, model.titleError ) model.body

                    SignedIn EditingNote ->
                        editNoteView ( model.title, model.titleError ) model.body

                    SignedIn (DeleteNote state) ->
                        deleteNoteView state model.currentNote

                    SignedIn (TrashingNote state) ->
                        trashingNoteView state model.currentNote

                    SignedIn ViewingProfile ->
                        Profile.view model.profilePage
                            |> List.map (Html.map ProfileMsg)
               )
        )


headerRow : Html Msg
headerRow =
    div
        [ style "display" "flex"
        , style "justify-content" "space-between"
        , style "align-items" "center"
        , style "margin-bottom" "1rem"
        ]
        [ h1 [ style "margin" "0" ] [ text "Elm + Supabase + GraphQL" ]
        ]


statusView : Maybe Status -> Html Msg
statusView maybeStatus =
    let
        ( styles, message ) =
            case maybeStatus of
                Just (Info m) ->
                    ( [ style "background-color" "#e8eaf1"
                      , style "color" "#030c26"
                      ]
                    , m
                    )

                Just (Success m) ->
                    ( [ style "background-color" "#047857"
                      , style "color" "#ffffff"
                      ]
                    , m
                    )

                Just (Warning m) ->
                    ( [ style "background-color" "#ec8b41"
                      , style "color" "#030c26"
                      ]
                    , m
                    )

                Just (Error m) ->
                    ( [ style "background-color" "#b91c1c"
                      , style "color" "#ffffff"
                      ]
                    , m
                    )

                Nothing ->
                    ( [], "" )
    in
    case ( styles, message ) of
        ( [], "" ) ->
            div [ style "display" "none" ] []

        _ ->
            p
                (styles
                    ++ [ style "padding" "0.5rem"
                       , style "border-radius" "0.75rem"
                       ]
                )
                [ text message ]


signUpView : ( String, Maybe String ) -> ( String, Maybe String ) -> ( String, Maybe String ) -> List (Html Msg)
signUpView ( email, emailError ) ( password, passwordError ) ( passwordConfirm, passwordConfirmError ) =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Sign Up" ]
    , emailInput email EmailUpdated
    , errorView emailError
    , passwordInput password PasswordUpdated
    , errorView passwordError
    , passwordConfirmInput passwordConfirm PasswordConfirmUpdated
    , errorView passwordConfirmError
    , buttons
        [ gotoStartButton GotoStart
        , attemptButton "Sign up" AttemptPasswordSignUp
        ]
    ]


errorView : Maybe String -> Html Msg
errorView maybeError =
    case maybeError of
        Just errorMsg ->
            div
                [ style "background-color" "#b91c1c"
                , style "color" "#ffffff"
                , style "padding" "0.5rem"
                , style "border-radius" "0.75rem"
                ]
                [ text errorMsg ]

        Nothing ->
            div [] []


signInView : String -> String -> List (Html Msg)
signInView email password =
    [ emailInput email EmailUpdated
    , passwordInput password PasswordUpdated
    , buttons
        [ gotoStartButton GotoStart
        , attemptButton "Sign in" AttemptPasswordSignIn
        ]
    ]


magicLinkView : String -> List (Html Msg)
magicLinkView email =
    [ emailInput email EmailUpdated
    , buttons
        [ gotoStartButton GotoStart
        , attemptButton "Send magic link" AttemptMagicLinkSignIn
        ]
    ]


createNoteView : ( String, Maybe String ) -> String -> List (Html Msg)
createNoteView ( title, titleError ) body =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Create Note" ]
    , notesTitleInput title TitleUpdated
    , errorView titleError
    , notesContentInput body BodyUpdated
    , buttons
        [ attemptButton "Create note" AttemptCreateNote
        , gotoButton "Back to Notes" GotoNotes
        ]
    ]


signedInNotesView : List Supabase.Note -> List (Html Msg)
signedInNotesView notes =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Notes" ]
    , div [ style "margin-top" "1rem" ] (List.map noteCard notes)
    ]


signedInTrashView : List Supabase.Note -> List (Html Msg)
signedInTrashView trashedNotes =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Trash" ]
    , div [ style "margin-top" "1rem" ] (List.map trashedNoteCard trashedNotes)
    ]



{- ######### Notes View ######### -}


deleteNoteView : DeleteState -> Maybe Supabase.Note -> List (Html Msg)
deleteNoteView state maybeNote =
    case maybeNote of
        Just note ->
            [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Delete Note" ]
            , div
                [ style "border" "1px solid #ddd"
                , style "padding" "0.75rem"
                , style "border-radius" "0.5rem"
                , style "margin-bottom" "0.5rem"
                ]
                [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
                , p [ style "margin" "0" ] [ text note.body ]
                ]
            , buttons
                [ case state of
                    DeleteReady ->
                        attemptButton "Confirm Delete" AttemptDeleteNoteHard

                    DeleteSuccess ->
                        div [] []

                    DeleteFailure ->
                        div [] []
                , gotoButton "Back to Notes" GotoNotes
                ]
            ]

        Nothing ->
            []


trashingNoteView : DeleteState -> Maybe Supabase.Note -> List (Html Msg)
trashingNoteView state maybeNote =
    case maybeNote of
        Just note ->
            [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Trash Note" ]
            , div
                [ style "border" "1px solid #ddd"
                , style "padding" "0.75rem"
                , style "border-radius" "0.5rem"
                , style "margin-bottom" "0.5rem"
                ]
                [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
                , p [ style "margin" "0" ] [ text note.body ]
                ]
            , buttons
                [ case state of
                    DeleteReady ->
                        attemptButton "Confirm" AttemptDeleteNoteSoft

                    DeleteSuccess ->
                        attemptButton "Reinstate" <|
                            AttemptRestoreNote note

                    DeleteFailure ->
                        div [] []
                , gotoButton "Back to Notes" GotoNotes
                ]
            ]

        Nothing ->
            []


editNoteView : ( String, Maybe String ) -> String -> List (Html Msg)
editNoteView ( title, titleError ) body =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Edit Note" ]
    , notesTitleInput title TitleUpdated
    , errorView titleError
    , notesContentInput body BodyUpdated
    , buttons
        [ attemptButton "Update note" AttemptUpdateNote
        , gotoButton "Back to Notes" GotoNotes
        ]
    ]


searchNotesView : String -> List Supabase.Note -> List (Html Msg)
searchNotesView searchQuery searchResults =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Search Notes" ]
    , searchNotesInput searchQuery SearchQueryUpdated
    , buttons
        [ searchButton AttemptSearchNotes
        , clearResultsButton ClearResults
        , gotoButton "Back to Notes" GotoNotes
        ]
    , div [ style "margin-top" "1rem" ] (List.map noteCard searchResults)
    ]


noteCard : Supabase.Note -> Html Msg
noteCard note =
    div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
        , p [ style "margin" "0" ] [ text note.body ]
        , buttons
            [ gotoButton "Edit" (GotoEditNote note)
            , gotoButton "Trash Note" (GotoTrashNote note)
            ]
        ]


trashedNoteCard : Supabase.Note -> Html Msg
trashedNoteCard note =
    div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text note.title ]
        , p [ style "margin" "0" ] [ text note.body ]
        , buttons
            [ attemptButton "Restore" (AttemptRestoreNote note)
            , gotoButton "Delete" (GotoDeleteNote note)
            ]
        ]


buttons : List (Html Msg) -> Html Msg
buttons btns =
    div
        [ style "display" "flex"
        , style "gap" "0.5rem"
        , style "margin-top" "0.5rem"
        ]
        btns
