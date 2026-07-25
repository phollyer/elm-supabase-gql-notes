module Main exposing (main)

import Api exposing (Datetime(..), Uuid(..), datetimeToString, uuidToString)
import Browser
import CreateNote.CreateNote as CreateNote
import GetActiveNotes.GetActiveNotes as GetActiveNotes
import GetProfile.GetProfile as GetProfile
import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode
import Lib.GraphQL as GraphQL
import Pages.Auth.MagicLink as MagicLink
import Pages.Auth.SignIn as SignIn
import Pages.Auth.SignUp as SignUp
import Pages.Notes.Create as CreateNote
import Pages.Notes.DeleteHard as DeleteNoteHard
import Pages.Notes.DeleteSoft as DeleteNoteSoft
import Pages.Notes.Edit as EditNote
import Pages.Notes.Notes as Notes
import Pages.Notes.Search as SearchNotes
import Pages.Notes.Trash as Trash
import Pages.Profile as Profile
import Pages.Shared.Status exposing (Status(..))
import Ports.Supabase as Supabase
import RestoreNote.RestoreNote as RestoreNote
import SearchNotes.SearchNotes as SearchNotes
import UI.FormElements exposing (attemptButton, buttons, gotoButton, gotoStartButton)
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
    { config : Config
    , accessToken : Maybe String
    , userId : Maybe String
    , magicLinkPage : MagicLink.Model
    , signInPage : SignIn.Model
    , signUpPage : SignUp.Model
    , createNotePage : CreateNote.Model
    , deleteNoteHardPage : DeleteNoteHard.Model
    , deleteNoteSoftPage : DeleteNoteSoft.Model
    , editNotePage : EditNote.Model
    , notesPage : Notes.Model
    , searchNotesPage : SearchNotes.Model
    , trashPage : Trash.Model
    , profilePage : Profile.Model
    , status : Maybe Status
    , state : State
    , currentNote : Maybe Supabase.Note
    , notes : List Supabase.Note
    , trashedNotes : List Supabase.Note
    , nextId : Int
    }


type alias Flags =
    { publishableKey : String
    , graphqlUrl : String
    }


type alias Config =
    GraphQL.Config


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        config =
            { graphqlUrl = flags.graphqlUrl
            , publishableKey = flags.publishableKey
            }
    in
    ( { config = config
      , accessToken = Nothing
      , userId = Nothing
      , magicLinkPage = MagicLink.init
      , signInPage = SignIn.init
      , signUpPage = SignUp.init
      , createNotePage = CreateNote.init config Nothing Nothing
      , deleteNoteHardPage = DeleteNoteHard.init config Nothing Nothing
      , deleteNoteSoftPage = DeleteNoteSoft.init config Nothing Nothing
      , editNotePage = EditNote.init config Nothing Nothing
      , notesPage = Notes.init config Nothing Nothing
      , searchNotesPage = SearchNotes.init config Nothing Nothing
      , trashPage = Trash.init config Nothing Nothing
      , profilePage = Profile.init
      , status = Just (Info "Checking session...")
      , state = Start
      , currentNote = Nothing
      , notes = []
      , trashedNotes = []
      , nextId = 1
      }
    , Supabase.sendCommand (Supabase.InitializeSession { requestId = "init-0" })
    )


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
    | TrashingNote
    | DeleteNote


type Msg
    = SignInMsg SignIn.Msg
    | SignUpMsg SignUp.Msg
    | MagicLinkMsg MagicLink.Msg
    | ProfileMsg Profile.Msg
    | CreateNoteMsg CreateNote.Msg
    | DeleteNoteHardMsg DeleteNoteHard.Msg
    | DeleteNoteSoftMsg DeleteNoteSoft.Msg
    | EditNoteMsg EditNote.Msg
    | SearchNotesMsg SearchNotes.Msg
    | TrashMsg Trash.Msg
    | NotesMsg Notes.Msg
    | StartSessionCheck
    | AttemptSignOut
    | AttemptRestoreNote Supabase.Note
    | GotoTrash
    | AttemptFetchProfile
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
    | GraphqlNoteRestored (Result GraphQL.Engine.Error RestoreNote.Response)
    | GraphqlAvatarPathUpdated (Result GraphQL.Engine.Error UpdateProfileAvatar.Response)
    | GraphqlProfileLoaded (Result GraphQL.Engine.Error GetProfile.Response)
    | SupabaseEventReceived Decode.Value


graphqlHeaders : String -> String -> List Http.Header
graphqlHeaders publishableKey accessToken =
    [ Http.header "apiKey" publishableKey
    , Http.header "Authorization" ("Bearer " ++ accessToken)
    ]


nextRequestId : Model -> String
nextRequestId model =
    "req-" ++ String.fromInt model.nextId


flattenGetNotes : GetActiveNotes.Response -> List GetActiveNotes.Node
flattenGetNotes response =
    List.map .node response.notesCollection.edges


getNotesToSupabaseNotes : GetActiveNotes.Response -> List Supabase.Note
getNotesToSupabaseNotes =
    flattenGetNotes >> List.map toSupabaseNote


toSupabaseNote : GetActiveNotes.Node -> Supabase.Note
toSupabaseNote { id, title, body, createdAt, updatedAt, deletedAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    , updatedAt = datetimeToString updatedAt
    , deletedAt = Maybe.map datetimeToString deletedAt
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Supabase.supabaseIn SupabaseEventReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg |> Debug.log "Main update msg" of
        StartSessionCheck ->
            ( { model | status = Just (Info "Checking session...") }
            , refreshSessionCmd model
            )

        SignUpMsg signUpMsg ->
            let
                ( updatedSignUpModel, signUpCmd ) =
                    SignUp.update signUpMsg model.signUpPage
            in
            ( { model | signUpPage = updatedSignUpModel }
            , Cmd.map SignUpMsg signUpCmd
            )

        SignInMsg signInMsg ->
            let
                ( updatedSignInModel, signInCmd ) =
                    SignIn.update signInMsg model.signInPage
            in
            ( { model | signInPage = updatedSignInModel }
            , Cmd.map SignInMsg signInCmd
            )

        MagicLinkMsg magicLinkMsg ->
            let
                ( updatedMagicLinkModel, magicLinkCmd ) =
                    MagicLink.update magicLinkMsg model.magicLinkPage
            in
            ( { model | magicLinkPage = updatedMagicLinkModel }
            , Cmd.map MagicLinkMsg magicLinkCmd
            )

        CreateNoteMsg createNoteMsg ->
            let
                ( updatedCreateNoteModel, createNoteCmd ) =
                    CreateNote.update createNoteMsg model.createNotePage
            in
            ( { model | createNotePage = updatedCreateNoteModel }
            , Cmd.map CreateNoteMsg createNoteCmd
            )

        DeleteNoteHardMsg deleteNoteHardMsg ->
            let
                ( updatedDeleteNoteSoftModel, deleteNoteHardCmd ) =
                    DeleteNoteHard.update deleteNoteHardMsg model.deleteNoteHardPage
            in
            ( { model | deleteNoteHardPage = updatedDeleteNoteSoftModel }
            , Cmd.map DeleteNoteHardMsg deleteNoteHardCmd
            )

        DeleteNoteSoftMsg deleteNoteSoftMsg ->
            let
                ( updatedDeleteNoteSoftModel, deleteNoteSoftCmd ) =
                    DeleteNoteSoft.update deleteNoteSoftMsg model.deleteNoteSoftPage
            in
            ( { model | deleteNoteSoftPage = updatedDeleteNoteSoftModel }
            , Cmd.map DeleteNoteSoftMsg deleteNoteSoftCmd
            )

        EditNoteMsg updateNoteMsg ->
            let
                ( updatedEditNoteModel, editNoteCmd ) =
                    EditNote.update updateNoteMsg model.editNotePage
            in
            ( { model | editNotePage = updatedEditNoteModel }
            , Cmd.map EditNoteMsg editNoteCmd
            )

        SearchNotesMsg searchNotesMsg ->
            let
                ( updatedSearchNotesModel, searchNotesCmd ) =
                    SearchNotes.update searchNotesMsg model.searchNotesPage
            in
            ( { model | searchNotesPage = updatedSearchNotesModel }
            , Cmd.map SearchNotesMsg searchNotesCmd
            )

        TrashMsg trashMsg ->
            let
                ( updatedTrashModel, trashCmd ) =
                    Trash.update trashMsg model.trashPage
            in
            ( { model | trashPage = updatedTrashModel }
            , Cmd.map TrashMsg trashCmd
            )

        NotesMsg notesMsg ->
            let
                ( updatedNotesModel, notesCmd ) =
                    Notes.update notesMsg model.notesPage
            in
            ( { model | notesPage = updatedNotesModel }
            , Cmd.map NotesMsg notesCmd
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
                | state = SignUp
                , signUpPage = SignUp.init
              }
            , Cmd.none
            )

        GotoSignIn ->
            ( { model
                | state = SignIn
                , signInPage = SignIn.init
              }
            , Cmd.none
            )

        GotoMagicLink ->
            ( { model
                | state = MagicLink
                , magicLinkPage = MagicLink.init
              }
            , Cmd.none
            )

        GotoCreateNote ->
            ( { model
                | state = SignedIn CreatingNote
                , createNotePage = CreateNote.init model.config model.accessToken model.userId
              }
            , Cmd.none
            )

        GotoEditNote note ->
            ( { model
                | state = SignedIn EditingNote
                , editNotePage = EditNote.init model.config model.accessToken (Just note)
              }
            , Cmd.none
            )

        GotoDeleteNote note ->
            ( { model
                | state = SignedIn DeleteNote
                , deleteNoteHardPage =
                    DeleteNoteHard.init model.config model.accessToken model.userId
                        |> DeleteNoteHard.setNote note
              }
            , Cmd.none
            )

        GotoTrashNote note ->
            ( { model
                | state = SignedIn TrashingNote
                , deleteNoteSoftPage =
                    DeleteNoteSoft.init model.config model.accessToken model.userId
                        |> DeleteNoteSoft.setNote note
              }
            , Cmd.none
            )

        GotoNotes ->
            let
                ( updatedNotesModel, notesCmd ) =
                    Notes.init model.config model.accessToken model.userId
                        |> Notes.fetch
            in
            ( { model
                | state = SignedIn ViewingNotes
                , notesPage = updatedNotesModel
              }
            , Cmd.map NotesMsg notesCmd
            )

        GotoSearch ->
            ( { model
                | state = SignedIn SearchingNotes
                , searchNotesPage = SearchNotes.init model.config model.accessToken model.userId
              }
            , Cmd.none
            )

        GotoTrash ->
            let
                ( updatedTrashModel, trashCmd ) =
                    Trash.init model.config model.accessToken model.userId
                        |> Trash.fetch
            in
            ( { model
                | state = SignedIn ViewingTrash
                , trashPage = updatedTrashModel
              }
            , Cmd.map TrashMsg trashCmd
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

        AttemptSignOut ->
            ( { model | status = Just (Info "Signing out...") }
            , Supabase.sendCommand (Supabase.SignOut { requestId = nextRequestId model })
            )

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

        Supabase.NoteCreated payload ->
            ( { model
                | notes = payload.note :: model.notes
                , status = Just (Success "Note saved")
              }
            , Cmd.none
            )

        Supabase.NotesFound _ ->
            ( { model | status = Just (Success "Notes found") }
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
                        , gotoButton "Notes" GotoNotes
                        , gotoButton "Search" GotoSearch
                        ]
                    , div
                        [ style "display" "flex"
                        , style "gap" "0.5rem"
                        , style "margin-left" "auto"
                        ]
                        [ attemptButton "Trash" GotoTrash
                        , gotoButton "Profile" GotoProfilePage
                        , attemptButton "Sign out" AttemptSignOut
                        ]
                    ]

            _ ->
                div [] []

         --, Status.view model.status
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
                        SignUp.view
                            (gotoStartButton GotoStart)
                            SignUpMsg
                            model.signUpPage

                    SignIn ->
                        SignIn.view
                            (gotoStartButton GotoStart)
                            SignInMsg
                            model.signInPage

                    MagicLink ->
                        MagicLink.view
                            (gotoStartButton GotoStart)
                            MagicLinkMsg
                            model.magicLinkPage

                    SignedIn ViewReady ->
                        [ h1 [] [ text "Welcome!" ]
                        , div
                            [ style "margin-top" "1rem"
                            , style "color" "#6b7280"
                            ]
                            [ text "Please fetch/search your notes, or create a new one." ]
                        ]

                    SignedIn ViewingNotes ->
                        Notes.view GotoEditNote GotoTrashNote NotesMsg model.notesPage

                    SignedIn ViewingTrash ->
                        Trash.view
                            (gotoButton "Delete" << GotoDeleteNote)
                            TrashMsg
                            model.trashPage

                    SignedIn SearchingNotes ->
                        SearchNotes.view
                            (gotoButton "Back to Notes" GotoNotes)
                            (gotoButton "Edit" << GotoEditNote)
                            (gotoButton "Trash Note" << GotoTrashNote)
                            SearchNotesMsg
                            model.searchNotesPage

                    SignedIn CreatingNote ->
                        CreateNote.view
                            (gotoButton "Back to Notes" GotoNotes)
                            CreateNoteMsg
                            model.createNotePage

                    SignedIn EditingNote ->
                        EditNote.view
                            (gotoButton "Back to Notes" GotoNotes)
                            EditNoteMsg
                            model.editNotePage

                    SignedIn DeleteNote ->
                        DeleteNoteHard.view
                            (gotoButton "Back to Notes" GotoNotes)
                            DeleteNoteHardMsg
                            model.deleteNoteHardPage

                    SignedIn TrashingNote ->
                        DeleteNoteSoft.view
                            (gotoButton "Back to Notes" GotoNotes)
                            DeleteNoteSoftMsg
                            model.deleteNoteSoftPage

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
