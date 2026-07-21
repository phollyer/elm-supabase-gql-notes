module Pages.Auth.SignIn exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Shared.Error as Error exposing (Error)
import Pages.Shared.Status as Status exposing (Status(..))
import Ports.Supabase as Supabase
import UI.FormElements as FE


type alias Model =
    { email : String
    , password : String
    , emailError : Maybe Error
    , passwordError : Maybe Error
    , status : Maybe Status
    , requestId : Int
    }


init : Model
init =
    { email = ""
    , password = ""
    , emailError = Nothing
    , passwordError = Nothing
    , status = Nothing
    , requestId = 0
    }


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | AttemptSignInWithPassword


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated value ->
            ( { model | email = value }, Cmd.none )

        PasswordUpdated value ->
            ( { model | password = value }, Cmd.none )

        AttemptSignInWithPassword ->
            let
                emailError =
                    Error.checkEmail model.email

                passwordError =
                    Error.checkPassword model.password
            in
            case ( emailError, passwordError ) of
                ( Nothing, Nothing ) ->
                    let
                        newRequestId =
                            model.requestId + 1
                    in
                    ( { model
                        | status = Just (Status.Info "Signing in...")
                        , requestId = newRequestId
                      }
                    , Supabase.sendCommand
                        (Supabase.SignInWithPassword
                            { requestId = "sign-in-password-" ++ String.fromInt newRequestId
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
                      }
                    , Cmd.none
                    )


view : Html msg -> (Msg -> msg) -> Model -> List (Html msg)
view navButton wrapperMsg model =
    [ Status.view model.status
    , FE.emailInput model.email (wrapperMsg << EmailUpdated)
    , Error.view model.emailError
    , FE.passwordInput model.password (wrapperMsg << PasswordUpdated)
    , Error.view model.passwordError
    , FE.buttons
        [ navButton
        , FE.attemptButton "Sign in" (wrapperMsg AttemptSignInWithPassword)
        ]
    ]
