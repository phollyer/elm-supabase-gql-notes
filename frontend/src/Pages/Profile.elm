module Pages.Profile exposing
    ( Model
    , Msg
    , init
    , setAvatarUrl
    , setDisplayName
    , setEmailAddress
    , update
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Ports.Supabase as Supabase
import UI.FormElements exposing (uploadButton)


type alias Model =
    { email : String
    , displayName : String
    , avatarUrl : Maybe String
    }


init : Model
init =
    { email = ""
    , displayName = ""
    , avatarUrl = Nothing
    }


setEmailAddress : String -> Model -> Model
setEmailAddress emailAddress model =
    { model | email = emailAddress }


setDisplayName : String -> Model -> Model
setDisplayName displayName model =
    { model | displayName = displayName }


setAvatarUrl : Maybe String -> Model -> Model
setAvatarUrl avatarUrl model =
    { model | avatarUrl = avatarUrl }


type Msg
    = UploadAvatarClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UploadAvatarClicked ->
            ( model, Supabase.sendCommand (Supabase.UploadAvatar { requestId = "upload-avatar" }) )


view : Model -> List (Html Msg)
view model =
    [ h1 [ style "font-size" "1.3rem", style "margin-top" "1.5rem" ] [ text "Profile" ]
    , div
        [ style "display" "flex"
        , style "align-items" "center"
        , style "gap" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ case model.avatarUrl of
            Just avatarUrl ->
                img
                    [ src avatarUrl
                    , alt "Avatar"
                    , style "width" "50px"
                    , style "height" "50px"
                    , style "border-radius" "50%"
                    ]
                    []

            _ ->
                img
                    [ src "https://via.placeholder.com/50"
                    , alt "Avatar"
                    , style "width" "50px"
                    , style "height" "50px"
                    , style "border-radius" "50%"
                    ]
                    []
        , uploadButton "Upload Avatar" UploadAvatarClicked
        ]
    , div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text "Display Name" ]
        , p [ style "margin" "0" ] [ text model.displayName ]
        ]
    , div
        [ style "border" "1px solid #ddd"
        , style "padding" "0.75rem"
        , style "border-radius" "0.5rem"
        , style "margin-bottom" "0.5rem"
        ]
        [ p [ style "font-weight" "700", style "margin" "0 0 0.4rem" ] [ text "Email" ]
        , p [ style "margin" "0" ] [ text model.email ]
        ]
    ]
