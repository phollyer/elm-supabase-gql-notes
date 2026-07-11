module Api.Input.NotesInsertInput exposing
    ( NotesInsertInput
    , body
    , createdAt
    , decoder
    , id
    , input
    , null
    , title
    , updatedAt
    , userId
    )

{-|
## Creating an input

@docs NotesInsertInput, input, decoder

## Null values

@docs null

## Optional fields

@docs id, userId, title, body, createdAt, updatedAt
-}


import Api
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias NotesInsertInput =
    Api.Input.NotesInsertInput


input : NotesInsertInput
input =
    GraphQL.InputObject.inputObject "NotesInsertInput"


id : Api.Uuid -> NotesInsertInput -> NotesInsertInput
id newArg_ inputObj_ =
    GraphQL.InputObject.addField "id" "UUID" (Api.uuid.encode newArg_) inputObj_


userId : Api.Uuid -> NotesInsertInput -> NotesInsertInput
userId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "userId"
        "UUID"
        (Api.uuid.encode newArg_)
        inputObj_


title : String -> NotesInsertInput -> NotesInsertInput
title newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "title"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


body : String -> NotesInsertInput -> NotesInsertInput
body newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "body"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


createdAt : Api.Datetime -> NotesInsertInput -> NotesInsertInput
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


updatedAt : Api.Datetime -> NotesInsertInput -> NotesInsertInput
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


null :
    { id : NotesInsertInput -> NotesInsertInput
    , userId : NotesInsertInput -> NotesInsertInput
    , title : NotesInsertInput -> NotesInsertInput
    , body : NotesInsertInput -> NotesInsertInput
    , createdAt : NotesInsertInput -> NotesInsertInput
    , updatedAt : NotesInsertInput -> NotesInsertInput
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField "id" "UUID" Json.Encode.null inputObj
    , userId =
        \inputObj ->
            GraphQL.InputObject.addField
                "userId"
                "UUID"
                Json.Encode.null
                inputObj
    , title =
        \inputObj ->
            GraphQL.InputObject.addField
                "title"
                "String"
                Json.Encode.null
                inputObj
    , body =
        \inputObj ->
            GraphQL.InputObject.addField
                "body"
                "String"
                Json.Encode.null
                inputObj
    , createdAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "createdAt"
                "Datetime"
                Json.Encode.null
                inputObj
    , updatedAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "updatedAt"
                "Datetime"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder NotesInsertInput
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "NotesInsertInput"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "UUID" }
                      , { name = "userId", type_ = "UUID" }
                      , { name = "title", type_ = "String" }
                      , { name = "body", type_ = "String" }
                      , { name = "createdAt", type_ = "Datetime" }
                      , { name = "updatedAt", type_ = "Datetime" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)