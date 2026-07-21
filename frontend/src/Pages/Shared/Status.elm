module Pages.Shared.Status exposing
    ( Status(..)
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)


type Status
    = Success String
    | Error String
    | Warning String
    | Info String


view : Maybe Status -> Html msg
view maybeStatus =
    let
        defaultStyles =
            [ style "padding" "0.5rem"
            , style "border-radius" "0.75rem"
            ]
    in
    case maybeStatus of
        Just (Info message) ->
            p
                (defaultStyles
                    ++ [ style "background-color" "#e8eaf1"
                       , style "color" "#030c26"
                       ]
                )
                [ text message ]

        Just (Success message) ->
            p
                (defaultStyles
                    ++ [ style "background-color" "#047857"
                       , style "color" "#ffffff"
                       ]
                )
                [ text message ]

        Just (Warning message) ->
            p
                (defaultStyles
                    ++ [ style "background-color" "#ec8b41"
                       , style "color" "#030c26"
                       ]
                )
                [ text message ]

        Just (Error message) ->
            p
                (defaultStyles
                    ++ [ style "background-color" "#b91c1c"
                       , style "color" "#ffffff"
                       ]
                )
                [ text message ]

        Nothing ->
            div [ style "display" "none" ] []
