module UI.FormElements exposing
    ( attemptButton
    , emailInput
    , gotoButton
    , gotoStartButton
    , notesContentInput
    , notesTitleInput
    , passwordConfirmInput
    , passwordInput
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



{- ######### Buttons ######### -}


attemptButton : String -> msg -> Html msg
attemptButton label onClickMsg =
    button
        [ onClick onClickMsg, style "margin-right" "0.5rem" ]
        [ text label ]


gotoButton : String -> msg -> Html msg
gotoButton label onClickMsg =
    button
        [ onClick onClickMsg, style "margin-right" "0.5rem" ]
        [ text label ]


gotoStartButton : msg -> Html msg
gotoStartButton onClickMsg =
    gotoButton "Back to Start" onClickMsg



{- ######### Input Fields ######### -}
--
--
--
{- ##### Session Fields ##### -}


emailInput : String -> (String -> msg) -> Html msg
emailInput email onInputMsg =
    input
        [ placeholder "Email"
        , value email
        , onInput onInputMsg
        , style "display" "block"
        , style "margin" "0.5rem 0"
        , style "padding" "0.5rem"
        , style "width" "100%"
        ]
        []


passwordInput : String -> (String -> msg) -> Html msg
passwordInput password onInputMsg =
    input
        [ type_ "password"
        , placeholder "Password"
        , value password
        , onInput onInputMsg
        , style "display" "block"
        , style "margin" "0.5rem 0"
        , style "padding" "0.5rem"
        , style "width" "100%"
        ]
        []


passwordConfirmInput : String -> (String -> msg) -> Html msg
passwordConfirmInput passwordConfirm onInputMsg =
    input
        [ type_ "password"
        , placeholder "Confirm Password"
        , value passwordConfirm
        , onInput onInputMsg
        , style "display" "block"
        , style "margin" "0.5rem 0"
        , style "padding" "0.5rem"
        , style "width" "100%"
        ]
        []



{- ##### Notes Fields ##### -}


notesTitleInput : String -> (String -> msg) -> Html msg
notesTitleInput title onInputMsg =
    input
        [ placeholder "Title"
        , value title
        , onInput onInputMsg
        , style "display" "block"
        , style "margin" "0.5rem 0"
        , style "padding" "0.5rem"
        , style "width" "100%"
        ]
        []


notesContentInput : String -> (String -> msg) -> Html msg
notesContentInput content onInputMsg =
    textarea
        [ placeholder "Body"
        , value content
        , onInput onInputMsg
        , style "display" "block"
        , style "min-height" "100px"
        , style "margin" "0.5rem 0"
        , style "padding" "0.5rem"
        , style "width" "100%"
        ]
        []
