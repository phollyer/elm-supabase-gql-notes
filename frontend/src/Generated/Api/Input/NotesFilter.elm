module Api.Input.NotesFilter exposing
    ( NotesFilter
    , and
    , body
    , createdAt
    , decoder
    , deletedAt
    , id
    , input
    , nodeId
    , not
    , null
    , or
    , title
    , updatedAt
    , userId
    )

{-|
## Creating an input

@docs NotesFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs id, userId, title, body, createdAt, updatedAt, deletedAt, nodeId, and, or, not
-}


import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias NotesFilter =
    Api.Input.NotesFilter


input : NotesFilter
input =
    GraphQL.InputObject.inputObject "NotesFilter"


id : Api.Input.UUIDFilter -> NotesFilter -> NotesFilter
id newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "id"
        "UUIDFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


userId : Api.Input.UUIDFilter -> NotesFilter -> NotesFilter
userId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "userId"
        "UUIDFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


title : Api.Input.StringFilter -> NotesFilter -> NotesFilter
title newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "title"
        "StringFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


body : Api.Input.StringFilter -> NotesFilter -> NotesFilter
body newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "body"
        "StringFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


createdAt : Api.Input.DatetimeFilter -> NotesFilter -> NotesFilter
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "DatetimeFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


updatedAt : Api.Input.DatetimeFilter -> NotesFilter -> NotesFilter
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "DatetimeFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


deletedAt : Api.Input.DatetimeFilter -> NotesFilter -> NotesFilter
deletedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "deletedAt"
        "DatetimeFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


nodeId : Api.Input.IDFilter -> NotesFilter -> NotesFilter
nodeId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "nodeId"
        "IDFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


and : List Api.Input.NotesFilter -> NotesFilter -> NotesFilter
and newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "and"
        "[NotesFilter!]"
        (Json.Encode.list GraphQL.InputObject.encode newArg_)
        inputObj_


or : List Api.Input.NotesFilter -> NotesFilter -> NotesFilter
or newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "or"
        "[NotesFilter!]"
        (Json.Encode.list GraphQL.InputObject.encode newArg_)
        inputObj_


not : Api.Input.NotesFilter -> NotesFilter -> NotesFilter
not newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "not"
        "NotesFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


null :
    { id : NotesFilter -> NotesFilter
    , userId : NotesFilter -> NotesFilter
    , title : NotesFilter -> NotesFilter
    , body : NotesFilter -> NotesFilter
    , createdAt : NotesFilter -> NotesFilter
    , updatedAt : NotesFilter -> NotesFilter
    , deletedAt : NotesFilter -> NotesFilter
    , nodeId : NotesFilter -> NotesFilter
    , and : NotesFilter -> NotesFilter
    , or : NotesFilter -> NotesFilter
    , not : NotesFilter -> NotesFilter
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField
                "id"
                "UUIDFilter"
                Json.Encode.null
                inputObj
    , userId =
        \inputObj ->
            GraphQL.InputObject.addField
                "userId"
                "UUIDFilter"
                Json.Encode.null
                inputObj
    , title =
        \inputObj ->
            GraphQL.InputObject.addField
                "title"
                "StringFilter"
                Json.Encode.null
                inputObj
    , body =
        \inputObj ->
            GraphQL.InputObject.addField
                "body"
                "StringFilter"
                Json.Encode.null
                inputObj
    , createdAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "createdAt"
                "DatetimeFilter"
                Json.Encode.null
                inputObj
    , updatedAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "updatedAt"
                "DatetimeFilter"
                Json.Encode.null
                inputObj
    , deletedAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "deletedAt"
                "DatetimeFilter"
                Json.Encode.null
                inputObj
    , nodeId =
        \inputObj ->
            GraphQL.InputObject.addField
                "nodeId"
                "IDFilter"
                Json.Encode.null
                inputObj
    , and =
        \inputObj ->
            GraphQL.InputObject.addField
                "and"
                "[NotesFilter!]"
                Json.Encode.null
                inputObj
    , or =
        \inputObj ->
            GraphQL.InputObject.addField
                "or"
                "[NotesFilter!]"
                Json.Encode.null
                inputObj
    , not =
        \inputObj ->
            GraphQL.InputObject.addField
                "not"
                "NotesFilter"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder NotesFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "NotesFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "UUIDFilter" }
                      , { name = "userId", type_ = "UUIDFilter" }
                      , { name = "title", type_ = "StringFilter" }
                      , { name = "body", type_ = "StringFilter" }
                      , { name = "createdAt", type_ = "DatetimeFilter" }
                      , { name = "updatedAt", type_ = "DatetimeFilter" }
                      , { name = "deletedAt", type_ = "DatetimeFilter" }
                      , { name = "nodeId", type_ = "IDFilter" }
                      , { name = "and", type_ = "[NotesFilter!]" }
                      , { name = "or", type_ = "[NotesFilter!]" }
                      , { name = "not", type_ = "NotesFilter" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)