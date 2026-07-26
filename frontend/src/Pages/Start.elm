module Pages.Start exposing
    ( Model
    , init
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Shared.Status as Status exposing (Status(..))
import UI.FormElements as FE


type alias Model =
    { status : Maybe Status }


init : Model
init =
    { status = Just (Info "Please sign up or sign in") }


view : List (Html msg) -> Model -> List (Html msg)
view navButtons model =
    [ h1 [] [ text "Welcome to the Notes App" ]
    , Status.view model.status
    , div
        [ class "start-buttons" ]
        [ FE.buttons navButtons
        ]
    ]
