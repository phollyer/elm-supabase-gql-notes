port module Ports.Supabase exposing
    ( Command(..)
    , Event(..)
    , Note
    , commandDecoder
    , decodeEvent
    , sendCommand
    , supabaseIn
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type Command
    = InitializeSession { requestId : String }
    | RefreshSession { requestId : String }
    | SignInWithPassword { requestId : String, email : String, password : String }
    | SignInWithMagicLink { requestId : String, email : String }
    | SignUpWithPassword { requestId : String, email : String, password : String }
    | SignOut { requestId : String }
    | UploadAvatar { requestId : String }


type Event
    = SessionReady { requestId : String, accessToken : String, userId : String, email : String }
    | SessionMissing { requestId : String }
    | AvatarUploaded { requestId : String, avatarUrl : String, avatarPath : String }
    | ErrorRaised { requestId : String, message : String }


type alias Note =
    { id : String
    , title : String
    , body : String
    , createdAt : String
    , updatedAt : String
    , deletedAt : Maybe String
    }


port supabaseOut : Encode.Value -> Cmd msg


port supabaseIn : (Encode.Value -> msg) -> Sub msg


sendCommand : Command -> Cmd msg
sendCommand command =
    supabaseOut (encodeCommand command)


encodeCommand : Command -> Encode.Value
encodeCommand command =
    case command of
        InitializeSession payload ->
            Encode.object
                [ ( "type", Encode.string "initialize-session" )
                , ( "requestId", Encode.string payload.requestId )
                ]

        RefreshSession payload ->
            Encode.object
                [ ( "type", Encode.string "refresh-session" )
                , ( "requestId", Encode.string payload.requestId )
                ]

        SignUpWithPassword payload ->
            Encode.object
                [ ( "type", Encode.string "sign-up-password" )
                , ( "requestId", Encode.string payload.requestId )
                , ( "email", Encode.string payload.email )
                , ( "password", Encode.string payload.password )
                ]

        SignInWithPassword payload ->
            Encode.object
                [ ( "type", Encode.string "sign-in-password" )
                , ( "requestId", Encode.string payload.requestId )
                , ( "email", Encode.string payload.email )
                , ( "password", Encode.string payload.password )
                ]

        SignInWithMagicLink payload ->
            Encode.object
                [ ( "type", Encode.string "sign-in-magic-link" )
                , ( "requestId", Encode.string payload.requestId )
                , ( "email", Encode.string payload.email )
                ]

        SignOut payload ->
            Encode.object
                [ ( "type", Encode.string "sign-out" )
                , ( "requestId", Encode.string payload.requestId )
                ]

        UploadAvatar payload ->
            Encode.object
                [ ( "type", Encode.string "upload-avatar" )
                , ( "requestId", Encode.string payload.requestId )
                ]


commandDecoder : Decoder Event
commandDecoder =
    decodeEvent


decodeEvent : Decoder Event
decodeEvent =
    Decode.field "type" Decode.string
        |> Decode.andThen decodeByType


decodeByType : String -> Decoder Event
decodeByType eventType =
    case eventType of
        "session-ready" ->
            Decode.map4
                (\requestId accessToken userId email ->
                    SessionReady { requestId = requestId, accessToken = accessToken, userId = userId, email = email }
                )
                (Decode.field "requestId" Decode.string)
                (Decode.field "accessToken" Decode.string)
                (Decode.field "userId" Decode.string)
                (Decode.field "email" Decode.string)

        "session-missing" ->
            Decode.map
                (\requestId -> SessionMissing { requestId = requestId })
                (Decode.field "requestId" Decode.string)

        "avatar-uploaded" ->
            Decode.map3
                (\requestId avatarUrl avatarPath -> AvatarUploaded { requestId = requestId, avatarUrl = avatarUrl, avatarPath = avatarPath })
                (Decode.field "requestId" Decode.string)
                (Decode.field "avatarUrl" Decode.string)
                (Decode.field "avatarPath" Decode.string)

        "error" ->
            Decode.map2
                (\requestId message -> ErrorRaised { requestId = requestId, message = message })
                (Decode.field "requestId" Decode.string)
                (Decode.field "message" Decode.string)

        _ ->
            Decode.fail ("Unknown event type: " ++ eventType)
