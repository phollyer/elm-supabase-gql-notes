module Pages.Auth.SignUp exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Auth.SignIn exposing (Msg)
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { email : String
    , password : String
    , passwordConfirm : String
    , emailError : Maybe Error
    , passwordError : Maybe Error
    , passwordConfirmError : Maybe Error
    , status : Maybe Status
    , requestId : Int
    }


init : Model
init =
    { email = ""
    , password = ""
    , passwordConfirm = ""
    , emailError = Nothing
    , passwordError = Nothing
    , passwordConfirmError = Nothing
    , status = Nothing
    , requestId = 0
    }


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | PasswordConfirmUpdated String
    | AttemptSignUpWithPassword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated value ->
            ( { model | email = value }, Cmd.none )

        PasswordUpdated value ->
            ( { model | password = value }, Cmd.none )

        PasswordConfirmUpdated value ->
            ( { model | passwordConfirm = value }, Cmd.none )

        AttemptSignUpWithPassword ->
            let
                emailError =
                    Error.checkEmail model.email

                passwordError =
                    Error.checkPassword model.password

                passwordConfirmError =
                    Error.checkPasswordConfirm model.password model.passwordConfirm
            in
            case ( emailError, passwordError, passwordConfirmError ) of
                ( Nothing, Nothing, Nothing ) ->
                    let
                        newRequestId =
                            model.requestId + 1
                    in
                    ( { model
                        | status = Just (Status.Info "Signing up...")
                        , requestId = newRequestId
                      }
                    , Supabase.sendCommand
                        (Supabase.SignUpWithPassword
                            { requestId = "sign-up-password-" ++ String.fromInt newRequestId
                            , email = model.email
                            , password = model.password
                            }
                        )
                    )

                _ ->
                    ( { model
                        | status = Just (Status.Error "Please fix the errors below")
                        , emailError = emailError
                        , passwordError = passwordError
                        , passwordConfirmError = passwordConfirmError
                      }
                    , Cmd.none
                    )


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Sign Up" ]
    , Status.view model.status
    , FE.emailInput model.email (wrapperMsg << EmailUpdated)
    , Error.view model.emailError
    , FE.passwordInput model.password (wrapperMsg << PasswordUpdated)
    , Error.view model.passwordError
    , FE.passwordConfirmInput model.passwordConfirm (wrapperMsg << PasswordConfirmUpdated)
    , Error.view model.passwordConfirmError
    , FE.buttons
        [ navButton
        , FE.attemptButton "Sign up" (wrapperMsg AttemptSignUpWithPassword)
        ]
    ]
