module Pages.Shared.Error exposing
    ( Error
    , checkEmail
    , checkPassword
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


type EmailErrorType
    = EmailIsRequired
    | EmailIsInvalid


type PasswordErrorType
    = PasswordIsRequired
    | PasswordIsTooShort
    | PasswordIsTooWeak


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
