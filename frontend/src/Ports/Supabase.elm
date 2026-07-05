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
    | SignInWithPassword { requestId : String, email : String, password : String }
    | SignInWithMagicLink { requestId : String, email : String }
    | SignOut { requestId : String }
    | FetchNotes { requestId : String }
    | CreateNote { requestId : String, title : String, body : String }


type Event
    = SessionReady { requestId : String, userId : String, email : String }
    | SessionMissing { requestId : String }
    | NotesLoaded { requestId : String, notes : List Note }
    | NoteCreated { requestId : String, note : Note }
    | ErrorRaised { requestId : String, message : String }


type alias Note =
    { id : String
    , title : String
    , body : String
    , createdAt : String
    }


noteDecoder : Decoder Note
noteDecoder =
    Decode.map4 Note
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "body" Decode.string)
        (Decode.field "created_at" Decode.string)


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

        FetchNotes payload ->
            Encode.object
                [ ( "type", Encode.string "fetch-notes" )
                , ( "requestId", Encode.string payload.requestId )
                ]

        CreateNote payload ->
            Encode.object
                [ ( "type", Encode.string "create-note" )
                , ( "requestId", Encode.string payload.requestId )
                , ( "title", Encode.string payload.title )
                , ( "body", Encode.string payload.body )
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
            Decode.map3
                (\requestId userId email ->
                    SessionReady { requestId = requestId, userId = userId, email = email }
                )
                (Decode.field "requestId" Decode.string)
                (Decode.field "userId" Decode.string)
                (Decode.field "email" Decode.string)

        "session-missing" ->
            Decode.map
                (\requestId -> SessionMissing { requestId = requestId })
                (Decode.field "requestId" Decode.string)

        "notes-loaded" ->
            Decode.map2
                (\requestId notes -> NotesLoaded { requestId = requestId, notes = notes })
                (Decode.field "requestId" Decode.string)
                (Decode.field "notes" (Decode.list noteDecoder))

        "note-created" ->
            Decode.map2
                (\requestId note -> NoteCreated { requestId = requestId, note = note })
                (Decode.field "requestId" Decode.string)
                (Decode.field "note" noteDecoder)

        "error" ->
            Decode.map2
                (\requestId message -> ErrorRaised { requestId = requestId, message = message })
                (Decode.field "requestId" Decode.string)
                (Decode.field "message" Decode.string)

        _ ->
            Decode.fail ("Unknown event type: " ++ eventType)
