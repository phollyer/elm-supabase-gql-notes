module Pages.Shared.Error exposing
    ( Error
    , checkEmail
    , checkPassword
    , checkPasswordConfirm
    , toString
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)


type Error
    = FormError FormErrorType


type FormErrorType
    = EmailError EmailErrorType
    | PasswordError PasswordErrorType
    | PasswordConfirmError PasswordConfirmErrorType


type EmailErrorType
    = EmailIsRequired
    | EmailIsInvalid


type PasswordErrorType
    = PasswordIsRequired
    | PasswordIsTooShort
    | PasswordIsTooWeak


type PasswordConfirmErrorType
    = PasswordConfirmIsRequired
    | PasswordConfirmDoesNotMatch


checkEmail : String -> Maybe Error
checkEmail email =
    if String.isEmpty email then
        Just emailIsRequired

    else
        Nothing


checkPassword : String -> Maybe Error
checkPassword password =
    if String.isEmpty password then
        Just passwordIsRequired

    else
        Nothing


checkPasswordConfirm : String -> String -> Maybe Error
checkPasswordConfirm password passwordConfirm =
    if String.isEmpty passwordConfirm then
        Just passwordConfirmIsRequired

    else if password /= passwordConfirm then
        Just passwordsDoNotMatch

    else
        Nothing


emailIsRequired : Error
emailIsRequired =
    FormError <|
        EmailError <|
            EmailIsRequired


passwordIsRequired : Error
passwordIsRequired =
    FormError <|
        PasswordError <|
            PasswordIsRequired


passwordConfirmIsRequired : Error
passwordConfirmIsRequired =
    FormError <|
        PasswordConfirmError <|
            PasswordConfirmIsRequired


passwordsDoNotMatch : Error
passwordsDoNotMatch =
    FormError <|
        PasswordConfirmError <|
            PasswordConfirmDoesNotMatch


view : Maybe Error -> Html msg
view maybeError =
    case maybeError of
        Just error ->
            div
                [ style "background-color" "#b91c1c"
                , style "color" "#ffffff"
                , style "padding" "0.5rem"
                , style "border-radius" "0.75rem"
                ]
                [ text (toString error) ]

        Nothing ->
            div [] []


toString : Error -> String
toString error =
    case error of
        FormError formErrorType ->
            formErrorToString formErrorType


formErrorToString : FormErrorType -> String
formErrorToString formError =
    case formError of
        EmailError emailErrorType ->
            emailErrorToString emailErrorType

        PasswordError passwordErrorType ->
            passwordErrorToString passwordErrorType

        PasswordConfirmError passwordConfirmErrorType ->
            passwordConfirmErrorToString passwordConfirmErrorType


emailErrorToString : EmailErrorType -> String
emailErrorToString emailErrorType =
    case emailErrorType of
        EmailIsRequired ->
            "An email address is required"

        EmailIsInvalid ->
            -- TODO: Add email validation
            "The email address is invalid"


passwordErrorToString : PasswordErrorType -> String
passwordErrorToString passwordErrorType =
    case passwordErrorType of
        PasswordIsRequired ->
            "A password is required"

        PasswordIsTooShort ->
            -- TODO: Add password length validation
            "The password is too short"

        PasswordIsTooWeak ->
            -- TODO: Add password strength validation
            "The password is too weak"


passwordConfirmErrorToString : PasswordConfirmErrorType -> String
passwordConfirmErrorToString passwordConfirmErrorType =
    case passwordConfirmErrorType of
        PasswordConfirmIsRequired ->
            "Password confirmation is required"

        PasswordConfirmDoesNotMatch ->
            "Passwords do not match"
