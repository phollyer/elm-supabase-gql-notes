module Api.Input.NotesUpdateInput exposing
    ( NotesUpdateInput
    , body
    , createdAt
    , decoder
    , deletedAt
    , id
    , input
    , null
    , title
    , updatedAt
    , userId
    )

{-|
## Creating an input

@docs NotesUpdateInput, input, decoder

## Null values

@docs null

## Optional fields

@docs id, userId, title, body, createdAt, updatedAt, deletedAt
-}


import Api
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias NotesUpdateInput =
    Api.Input.NotesUpdateInput


input : NotesUpdateInput
input =
    GraphQL.InputObject.inputObject "NotesUpdateInput"


id : Api.Uuid -> NotesUpdateInput -> NotesUpdateInput
id newArg_ inputObj_ =
    GraphQL.InputObject.addField "id" "UUID" (Api.uuid.encode newArg_) inputObj_


userId : Api.Uuid -> NotesUpdateInput -> NotesUpdateInput
userId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "userId"
        "UUID"
        (Api.uuid.encode newArg_)
        inputObj_


title : String -> NotesUpdateInput -> NotesUpdateInput
title newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "title"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


body : String -> NotesUpdateInput -> NotesUpdateInput
body newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "body"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


createdAt : Api.Datetime -> NotesUpdateInput -> NotesUpdateInput
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


updatedAt : Api.Datetime -> NotesUpdateInput -> NotesUpdateInput
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


deletedAt : Api.Datetime -> NotesUpdateInput -> NotesUpdateInput
deletedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "deletedAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


null :
    { id : NotesUpdateInput -> NotesUpdateInput
    , userId : NotesUpdateInput -> NotesUpdateInput
    , title : NotesUpdateInput -> NotesUpdateInput
    , body : NotesUpdateInput -> NotesUpdateInput
    , createdAt : NotesUpdateInput -> NotesUpdateInput
    , updatedAt : NotesUpdateInput -> NotesUpdateInput
    , deletedAt : NotesUpdateInput -> NotesUpdateInput
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
    , deletedAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "deletedAt"
                "Datetime"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder NotesUpdateInput
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "NotesUpdateInput"
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
                      , { name = "deletedAt", type_ = "Datetime" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)