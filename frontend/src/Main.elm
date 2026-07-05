module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, input, p, text, textarea)
import Html.Attributes exposing (placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Ports.Supabase as Supabase
import String


type alias Model =
    { email : String
    , password : String
    , title : String
    , body : String
    , status : String
    , session : Session
    , notes : List Supabase.Note
    , nextId : Int
    }


type Session
    = SignedOut
    | SignedIn { userId : String, email : String }


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | TitleUpdated String
    | BodyUpdated String
    | StartSessionCheck
    | AttemptPasswordSignIn
    | AttemptMagicLinkSignIn
    | AttemptSignOut
    | AttemptFetchNotes
    | AttemptCreateNote
    | SupabaseEventReceived Decode.Value


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
    let
        model =
            { email = ""
            , password = ""
            , title = ""
            , body = ""
            , status = "Checking session..."
            , session = SignedOut
            , notes = []
            , nextId = 1
            }
    in
    ( model
    , Supabase.sendCommand (Supabase.InitializeSession { requestId = "init-0" })
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Supabase.supabaseIn SupabaseEventReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated value ->
            ( { model | email = value }, Cmd.none )

        PasswordUpdated value ->
            ( { model | password = value }, Cmd.none )

        TitleUpdated value ->
            ( { model | title = value }, Cmd.none )

        BodyUpdated value ->
            ( { model | body = value }, Cmd.none )

        StartSessionCheck ->
            ( { model | status = "Checking session..." }
            , Supabase.sendCommand (Supabase.InitializeSession { requestId = nextRequestId model })
            )

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
            , Supabase.sendCommand (Supabase.FetchNotes { requestId = nextRequestId model })
            )

        AttemptCreateNote ->
            if String.isEmpty model.title then
                ( { model | status = "Title is required." }, Cmd.none )

            else
                ( { model | status = "Saving note..." }
                , Supabase.sendCommand
                    (Supabase.CreateNote
                        { requestId = nextRequestId model
                        , title = model.title
                        , body = model.body
                        }
                    )
                )

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
                | session = SignedIn { userId = payload.userId, email = payload.email }
                , status = "Session ready."
              }
            , Supabase.sendCommand (Supabase.FetchNotes { requestId = nextRequestId model })
            )

        Supabase.SessionMissing _ ->
            ( { model | session = SignedOut, notes = [], status = "You are signed out." }, Cmd.none )

        Supabase.NotesLoaded payload ->
            ( { model | notes = payload.notes, status = "Notes loaded." }, Cmd.none )

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
            ( { model | status = payload.message }, Cmd.none )


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
        ([ h1 [] [ text "Elm + Supabase" ]
         , p [ style "color" "#444" ] [ text "Personal knowledge tracker starter." ]
         , p [ style "padding" "0.5rem" ] [ text model.status ]
         ]
            ++ authView model
            ++ notesView model
        )


authView : Model -> List (Html Msg)
authView model =
    case model.session of
        SignedOut ->
            [ input
                [ placeholder "Email"
                , value model.email
                , onInput EmailUpdated
                , style "display" "block"
                , style "margin" "0.5rem 0"
                , style "padding" "0.5rem"
                , style "width" "100%"
                ]
                []
            , input
                [ type_ "password"
                , placeholder "Password"
                , value model.password
                , onInput PasswordUpdated
                , style "display" "block"
                , style "margin" "0.5rem 0"
                , style "padding" "0.5rem"
                , style "width" "100%"
                ]
                []
            , button [ onClick AttemptPasswordSignIn, style "margin-right" "0.5rem" ] [ text "Sign in" ]
            , button [ onClick AttemptMagicLinkSignIn ] [ text "Magic link" ]
            ]

        SignedIn session ->
            [ p [] [ text ("Signed in as " ++ session.email) ]
            , button [ onClick AttemptSignOut, style "margin-right" "0.5rem" ] [ text "Sign out" ]
            , button [ onClick AttemptFetchNotes ] [ text "Refresh notes" ]
            ]


notesView : Model -> List (Html Msg)
notesView model =
    case model.session of
        SignedOut ->
            []

        SignedIn _ ->
            [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Notes" ]
            , input
                [ placeholder "Title"
                , value model.title
                , onInput TitleUpdated
                , style "display" "block"
                , style "margin" "0.5rem 0"
                , style "padding" "0.5rem"
                , style "width" "100%"
                ]
                []
            , textarea
                [ placeholder "Body"
                , value model.body
                , onInput BodyUpdated
                , style "display" "block"
                , style "min-height" "100px"
                , style "margin" "0.5rem 0"
                , style "padding" "0.5rem"
                , style "width" "100%"
                ]
                []
            , button [ onClick AttemptCreateNote ] [ text "Create note" ]
            , div [ style "margin-top" "1rem" ] (List.map noteCard model.notes)
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
