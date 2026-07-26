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
    = InitializeSession
    | RefreshSession
    | SignInWithPassword { email : String, password : String }
    | SignInWithMagicLink { email : String }
    | SignUpWithPassword { email : String, password : String }
    | SignOut
    | UploadAvatar


type Event
    = SessionReady { accessToken : String, userId : String, email : String }
    | SessionMissing
    | AvatarUploaded { avatarUrl : String, avatarPath : String }
    | ErrorRaised { message : String }


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
        InitializeSession ->
            Encode.object
                [ ( "type", Encode.string "initialize-session" ) ]

        RefreshSession ->
            Encode.object
                [ ( "type", Encode.string "refresh-session" ) ]

        SignUpWithPassword payload ->
            Encode.object
                [ ( "type", Encode.string "sign-up-password" )
                , ( "email", Encode.string payload.email )
                , ( "password", Encode.string payload.password )
                ]

        SignInWithPassword payload ->
            Encode.object
                [ ( "type", Encode.string "sign-in-password" )
                , ( "email", Encode.string payload.email )
                , ( "password", Encode.string payload.password )
                ]

        SignInWithMagicLink payload ->
            Encode.object
                [ ( "type", Encode.string "sign-in-magic-link" )
                , ( "email", Encode.string payload.email )
                ]

        SignOut ->
            Encode.object
                [ ( "type", Encode.string "sign-out" ) ]

        UploadAvatar ->
            Encode.object
                [ ( "type", Encode.string "upload-avatar" ) ]


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
            Decode.map3
                (\accessToken userId email ->
                    SessionReady { accessToken = accessToken, userId = userId, email = email }
                )
                (Decode.field "accessToken" Decode.string)
                (Decode.field "userId" Decode.string)
                (Decode.field "email" Decode.string)

        "session-missing" ->
            Decode.succeed SessionMissing

        "avatar-uploaded" ->
            Decode.map2
                (\avatarUrl avatarPath -> AvatarUploaded { avatarUrl = avatarUrl, avatarPath = avatarPath })
                (Decode.field "avatarUrl" Decode.string)
                (Decode.field "avatarPath" Decode.string)

        "error" ->
            Decode.map
                (\message -> ErrorRaised { message = message })
                (Decode.field "message" Decode.string)

        _ ->
            Decode.fail ("Unknown event type: " ++ eventType)
