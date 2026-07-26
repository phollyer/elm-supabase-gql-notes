module Pages.Profile.Profile exposing
    ( Model
    , Msg
    , fetch
    , init
    , setAvatarUrl
    , setDisplayName
    , setEmailAddress
    , update
    , view
    )

import GraphQL.Engine
import Html exposing (..)
import Html.Attributes exposing (..)
import Lib.GraphQL as GraphQL
import Pages.Shared.Status exposing (Status(..))
import Ports.Supabase as Supabase
import Profile.GetProfile.GetProfile as GetProfile
import UI.FormElements exposing (uploadButton)


type alias Model =
    { config : GraphQL.Config
    , accessToken : Maybe String
    , userId : Maybe String
    , status : Maybe Status
    , email : String
    , displayName : String
    , avatarUrl : Maybe String
    }


init : GraphQL.Config -> Maybe String -> Maybe String -> Model
init config accessToken userId =
    { config = config
    , accessToken = accessToken
    , userId = userId
    , status = Nothing
    , email = ""
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


fetch : Model -> ( Model, Cmd Msg )
fetch model =
    case ( model.accessToken, model.userId ) of
        ( Nothing, _ ) ->
            ( { model | email = "Access token is missing." }
            , GraphQL.refreshSessionCmd
            )

        ( Just _, Nothing ) ->
            ( { model | email = "User ID is missing." }
            , GraphQL.refreshSessionCmd
            )

        ( Just accessToken, Just userId ) ->
            ( model
            , GraphQL.fetchProfileCmd model.config accessToken userId GraphqlProfileLoaded
            )


type Msg
    = UploadAvatarClicked
    | GraphqlProfileLoaded (Result GraphQL.Engine.Error GetProfile.Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UploadAvatarClicked ->
            ( model, Supabase.sendCommand Supabase.UploadAvatar )

        GraphqlProfileLoaded result ->
            case result of
                Ok response ->
                    case response.profilesByPk of
                        Just profile ->
                            ( { model
                                | email = profile.email
                                , displayName = Maybe.withDefault "" profile.displayName
                                , avatarUrl = Maybe.map (\path -> "http://localhost:54321/storage/v1/object/public/avatar/" ++ path) profile.avatarPath
                                , status = Just (Success "Profile loaded")
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            ( { model | status = Just (Error "Profile not found") }, Cmd.none )

                Err error ->
                    GraphQL.handleFailure "GraphQL profile load failed" error model


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
