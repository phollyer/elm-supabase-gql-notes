module Pages.Shared.Error exposing
    ( Error
    , emailIsRequired
    , toString
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)


type Error
    = FormError FormErrorType


type FormErrorType
    = EmailError EmailErrorType


type EmailErrorType
    = EmailIsRequired
    | EmailIsInvalid


emailIsRequired : Error
emailIsRequired =
    FormError <|
        EmailError <|
            EmailIsRequired


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


emailErrorToString : EmailErrorType -> String
emailErrorToString emailErrorType =
    case emailErrorType of
        EmailIsRequired ->
            "An email address is required"

        EmailIsInvalid ->
            -- TODO: Add email validation
            "The email address is invalid"
