module Pages.Auth.MagicLink exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { email : String
    , emailError : Maybe Error
    , status : Maybe Status
    }


init : Model
init =
    { email = ""
    , emailError = Nothing
    , status = Just (Info "Use the magic link to sign in via email")
    }


type Msg
    = EmailUpdated String
    | AttemptMagicLinkSignIn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated value ->
            ( { model | email = value }, Cmd.none )

        AttemptMagicLinkSignIn ->
            case Error.checkEmail model.email of
                Just emailError ->
                    ( { model
                        | status = Just (Status.Error "Please fix the errors below")
                        , emailError = Just emailError
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | status = Just (Status.Info "Sending magic link...") }
                    , Supabase.sendCommand
                        (Supabase.SignInWithMagicLink
                            { email = model.email }
                        )
                    )


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ Status.view model.status
    , FE.emailInput model.email (wrapperMsg << EmailUpdated)
    , Error.view model.emailError
    , FE.buttons
        [ navButton
        , FE.attemptButton "Send magic link" (wrapperMsg AttemptMagicLinkSignIn)
        ]
    ]
