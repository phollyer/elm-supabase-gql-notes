module Main exposing (main)

import Api exposing (Datetime(..), Uuid(..))
import Browser
import CreateNote.CreateNote as CreateNote
import GraphQL.Engine
import Html exposing (Html, div, h1, h2, p, text)
import Html.Attributes exposing (style, value)
import Http
import Json.Decode as Decode
import Notes.GetNotes as GetNotes
import Ports.Supabase as Supabase
import String
import UI.FormElements exposing (attemptButton, clearResultsButton, emailInput, gotoButton, gotoStartButton, notesContentInput, notesTitleInput, passwordConfirmInput, passwordInput, searchButton, searchNotesInput)


type alias Model =
    { email : String
    , emailError : Maybe String
    , password : String
    , passwordError : Maybe String
    , passwordConfirm : String
    , passwordConfirmError : Maybe String
    , userId : Maybe String
    , title : String
    , body : String
    , status : String
    , state : State
    , notes : List Supabase.Note
    , searchQuery : String
    , searchResults : List Supabase.Note
    , nextId : Int
    }


type State
    = Start
    | SignUp
    | SignIn
    | MagicLink
    | SignedIn
    | Search


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | PasswordConfirmUpdated String
    | StartSessionCheck
    | AttemptPasswordSignIn
    | AttemptPasswordSignUp
    | AttemptMagicLinkSignIn
    | AttemptSignOut
    | AttemptCreateNote
    | AttemptSearchNotes
    | SearchQueryUpdated String
    | ClearResults
    | AttemptFetchNotes
    | GotoStart
    | GotoSignUp
    | GotoSignIn
    | GotoMagicLink
    | GotoNotes
    | GotoSearch
    | TitleUpdated String
    | BodyUpdated String
    | SupabaseEventReceived Decode.Value
    | GraphqlNotesLoaded (Result GraphQL.Engine.Error GetNotes.Response)
    | GraphqlNoteCreated (Result GraphQL.Engine.Error CreateNote.Response)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { userId = Nothing
      , email = ""
      , emailError = Nothing
      , password = ""
      , passwordError = Nothing
      , passwordConfirm = ""
      , passwordConfirmError = Nothing
      , title = ""
      , body = ""
      , status = "Checking session..."
      , state = Start
      , notes = []
      , searchQuery = ""
      , searchResults = []
      , nextId = 1
      }
    , Supabase.sendCommand (Supabase.InitializeSession { requestId = "init-0" })
    )


graphqlUrl : String
graphqlUrl =
    "http://localhost:54321/graphql/v1"


graphqlHeaders : List Http.Header
graphqlHeaders =
    [ Http.header "apiKey" "REDACTED_SUPABASE_SECRET"
    , Http.header "Authorization" "Bearer REDACTED_SUPABASE_SECRET"
    ]


uuidToString : Uuid -> String
uuidToString (Uuid uuidStr) =
    uuidStr


datetimeToString : Datetime -> String
datetimeToString (Datetime datetime) =
    datetime


toSupabaseCreatedNote : CreateNote.Records -> Supabase.Note
toSupabaseCreatedNote { id, title, body, createdAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    }


flattenGetNotes : GetNotes.Response -> List GetNotes.Node
flattenGetNotes response =
    List.map .node response.notesCollection.edges


toSupabaseNote : GetNotes.Node -> Supabase.Note
toSupabaseNote { id, title, body, createdAt } =
    { id = uuidToString id
    , title = title
    , body = body
    , createdAt = datetimeToString createdAt
    }


getNotesToSupabaseNotes : GetNotes.Response -> List Supabase.Note
getNotesToSupabaseNotes =
    flattenGetNotes >> List.map toSupabaseNote


applyGraphqlNotes : GetNotes.Response -> Model -> Model
applyGraphqlNotes response model =
    { model
        | notes = getNotesToSupabaseNotes response
        , status = "Notes loaded."
    }


createNoteCmd : String -> String -> String -> Cmd Msg
createNoteCmd userId title body =
    Cmd.map GraphqlNoteCreated <|
        Api.mutation
            (CreateNote.mutation
                { userId = Uuid userId
                , title = title
                , body = body
                }
            )
            { headers = graphqlHeaders
            , url = graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


fetchNotesCmd : Cmd Msg
fetchNotesCmd =
    Cmd.map GraphqlNotesLoaded <|
        Api.query GetNotes.query
            { headers = graphqlHeaders
            , url = graphqlUrl
            , timeout = Nothing
            , tracker = Nothing
            }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Supabase.supabaseIn SupabaseEventReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartSessionCheck ->
            ( { model | status = "Checking session..." }
            , Supabase.sendCommand (Supabase.InitializeSession { requestId = nextRequestId model })
            )

        GotoStart ->
            ( { model
                | status = "Please sign in or sign up."
                , state = Start
              }
            , Cmd.none
            )

        GotoSignUp ->
            ( { model
                | status = "Registering user..."
                , state = SignUp
              }
            , Cmd.none
            )

        GotoSignIn ->
            ( { model
                | status = "Please sign in."
                , state = SignIn
              }
            , Cmd.none
            )

        GotoMagicLink ->
            ( { model
                | status = "Please sign in with magic link."
                , state = MagicLink
              }
            , Cmd.none
            )

        GotoNotes ->
            ( { model
                | status = "Viewing notes..."
                , state = SignedIn
              }
            , Cmd.none
            )

        GotoSearch ->
            ( { model
                | status = "Search notes..."
                , state = Search
              }
            , Cmd.none
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
                        Just "Email is required."

                    else
                        Nothing

                passwordError =
                    if String.isEmpty model.password then
                        Just "Password is required."

                    else
                        Nothing

                passwordConfirmError =
                    if model.password /= model.passwordConfirm then
                        Just "Passwords do not match."

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
                    ( { newModel | status = "Signing up with password..." }
                    , Supabase.sendCommand
                        (Supabase.SignUpWithPassword
                            { requestId = nextRequestId model
                            , email = model.email
                            , password = model.password
                            }
                        )
                    )

                _ ->
                    ( { newModel | status = "Please fix the errors below." }, Cmd.none )

        AttemptPasswordSignIn ->
            if String.isEmpty model.email || String.isEmpty model.password then
                ( { model | status = "Email and password are required." }, Cmd.none )

            else
                ( { model | status = "Signing in with password..." }
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
                ( { model | status = "Email is required for magic link." }, Cmd.none )

            else
                ( { model | status = "Sending magic link..." }
                , Supabase.sendCommand
                    (Supabase.SignInWithMagicLink
                        { requestId = nextRequestId model
                        , email = model.email
                        }
                    )
                )

        AttemptSignOut ->
            ( { model | status = "Signing out..." }
            , Supabase.sendCommand (Supabase.SignOut { requestId = nextRequestId model })
            )

        AttemptFetchNotes ->
            ( { model | status = "Loading notes..." }
            , fetchNotesCmd
            )

        AttemptCreateNote ->
            if String.isEmpty model.title then
                ( { model | status = "Title is required." }, Cmd.none )

            else
                case model.userId of
                    Just userId ->
                        ( { model | status = "Creating note..." }
                        , createNoteCmd userId model.title model.body
                        )

                    Nothing ->
                        ( { model | status = "User ID is missing. Cannot create note." }
                        , Supabase.sendCommand (Supabase.InitializeSession { requestId = nextRequestId model })
                        )

        AttemptSearchNotes ->
            ( { model | status = "Searching notes..." }
            , Supabase.sendCommand
                (Supabase.SearchNotes
                    { requestId = nextRequestId model
                    , query = model.searchQuery
                    }
                )
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
                                        , status = "Note created successfully."
                                        , title = ""
                                        , body = ""
                                      }
                                    , Cmd.none
                                    )

                                [] ->
                                    ( { model | status = "Create mutation returned empty records list." }
                                    , Cmd.none
                                    )

                        Nothing ->
                            ( { model | status = "Create mutation returned no records." }
                            , Cmd.none
                            )

                Err error ->
                    ( { model | status = "GraphQL note creation failed: " ++ formatGraphqlError error }
                    , Cmd.none
                    )

        GraphqlNotesLoaded result ->
            case result of
                Ok response ->
                    ( applyGraphqlNotes response model, Cmd.none )

                Err error ->
                    ( { model | status = "GraphQL notes load failed: " ++ formatGraphqlError error }, Cmd.none )

        TitleUpdated value ->
            ( { model | title = value }, Cmd.none )

        BodyUpdated value ->
            ( { model | body = value }, Cmd.none )

        SupabaseEventReceived payload ->
            case Decode.decodeValue Supabase.decodeEvent payload of
                Ok event ->
                    applyEvent event model

                Err _ ->
                    ( { model | status = "Unexpected event payload from JS bridge." }, Cmd.none )


applyEvent : Supabase.Event -> Model -> ( Model, Cmd Msg )
applyEvent event model =
    case event of
        Supabase.SessionReady payload ->
            ( { model
                | userId = Just payload.userId
                , state = SignedIn
                , status = "Session ready."
                , email = payload.email
              }
            , fetchNotesCmd
            )

        Supabase.SessionMissing _ ->
            ( { model
                | userId = Nothing
                , state = Start
                , notes = []
                , status = "You are signed out."
              }
            , Cmd.none
            )

        Supabase.NotesLoaded payload ->
            ( { model
                | notes = payload.notes
                , status = "Notes loaded."
              }
            , Cmd.none
            )

        Supabase.NotesFound payload ->
            ( { model
                | searchResults = payload.notes
                , status = "Notes found."
              }
            , Cmd.none
            )

        Supabase.NoteCreated payload ->
            ( { model
                | notes = payload.note :: model.notes
                , title = ""
                , body = ""
                , status = "Note saved."
              }
            , Cmd.none
            )

        Supabase.ErrorRaised payload ->
            ( { model | status = payload.message }
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


nextRequestId : Model -> String
nextRequestId model =
    "req-" ++ String.fromInt model.nextId


view : Model -> Html Msg
view model =
    div
        [ style "font-family" "ui-sans-serif, system-ui, sans-serif"
        , style "max-width" "760px"
        , style "margin" "2rem auto"
        , style "padding" "0 1rem"
        ]
        ([ headerRow model.state
         , p [ style "color" "#444" ] [ text "Personal knowledge tracker starter." ]
         , p [ style "padding" "0.5rem" ] [ text model.status ]
         ]
            ++ (case model.state of
                    Start ->
                        selectView

                    SignUp ->
                        signUpView model.email model.password model.passwordConfirm

                    SignIn ->
                        signInView model.email model.password

                    MagicLink ->
                        magicLinkView model.email

                    SignedIn ->
                        signedInView model.title model.body model.notes

                    Search ->
                        searchNotesView model.searchQuery model.searchResults
               )
        )


headerRow : State -> Html Msg
headerRow state =
    div
        [ style "display" "flex"
        , style "justify-content" "space-between"
        , style "align-items" "center"
        ]
        [ h1 [ style "margin" "0" ] [ text "Elm + Supabase + GraphQL" ]
        , case state of
            SignedIn ->
                div
                    [ style "display" "flex"
                    , style "gap" "0.5rem"
                    ]
                    [ attemptButton "Fetch notes" AttemptFetchNotes
                    , gotoButton "Search notes" GotoSearch
                    , attemptButton "Sign out" AttemptSignOut
                    ]

            _ ->
                div [] []
        ]


selectView : List (Html Msg)
selectView =
    [ gotoButton "Sign up" GotoSignUp
    , gotoButton "Sign in" GotoSignIn
    , gotoButton "Magic link" GotoMagicLink
    ]


signUpView : String -> String -> String -> List (Html Msg)
signUpView email password passwordConfirm =
    [ emailInput email EmailUpdated
    , passwordInput password PasswordUpdated
    , passwordConfirmInput passwordConfirm PasswordConfirmUpdated
    , gotoStartButton GotoStart
    , attemptButton "Sign up" AttemptPasswordSignUp
    ]


signInView : String -> String -> List (Html Msg)
signInView email password =
    [ emailInput email EmailUpdated
    , passwordInput password PasswordUpdated
    , gotoStartButton GotoStart
    , attemptButton "Sign in" AttemptPasswordSignIn
    ]


magicLinkView : String -> List (Html Msg)
magicLinkView email =
    [ emailInput email EmailUpdated
    , gotoStartButton GotoStart
    , attemptButton "Send magic link" AttemptMagicLinkSignIn
    ]


signedInView : String -> String -> List Supabase.Note -> List (Html Msg)
signedInView title body notes =
    notesView title body notes



{- ######### Notes View ######### -}


searchNotesView : String -> List Supabase.Note -> List (Html Msg)
searchNotesView searchQuery searchResults =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Search Notes" ]
    , p [ style "margin-top" "0.5rem" ] [ text "This is a placeholder for the search notes view." ]
    , searchNotesInput searchQuery SearchQueryUpdated
    , searchButton AttemptSearchNotes
    , clearResultsButton ClearResults
    , gotoButton "Back to Notes" GotoNotes
    , div [ style "margin-top" "1rem" ] (List.map noteCard searchResults)
    ]


notesView : String -> String -> List Supabase.Note -> List (Html Msg)
notesView title body notes =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Notes" ]
    , notesTitleInput title TitleUpdated
    , notesContentInput body BodyUpdated
    , attemptButton "Create note" AttemptCreateNote
    , h2 [ style "font-size" "1.1rem", style "margin-top" "1.5rem" ] [ text "Your notes" ]
    , div [ style "margin-top" "1rem" ] (List.map noteCard notes)
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
        ]
