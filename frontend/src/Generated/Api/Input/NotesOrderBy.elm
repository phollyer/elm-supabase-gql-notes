module Api.Input.NotesOrderBy exposing
    ( NotesOrderBy
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

@docs NotesOrderBy, input, decoder

## Null values

@docs null

## Optional fields

@docs id, userId, title, body, createdAt, updatedAt
-}


import Api.Enum.OrderByDirection
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias NotesOrderBy =
    Api.Input.NotesOrderBy


input : NotesOrderBy
input =
    GraphQL.InputObject.inputObject "NotesOrderBy"


id : Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
id newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "id"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


userId :
    Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
userId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "userId"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


title :
    Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
title newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "title"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


body :
    Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
body newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "body"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


createdAt :
    Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


updatedAt :
    Api.Enum.OrderByDirection.OrderByDirection -> NotesOrderBy -> NotesOrderBy
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


null :
    { id : NotesOrderBy -> NotesOrderBy
    , userId : NotesOrderBy -> NotesOrderBy
    , title : NotesOrderBy -> NotesOrderBy
    , body : NotesOrderBy -> NotesOrderBy
    , createdAt : NotesOrderBy -> NotesOrderBy
    , updatedAt : NotesOrderBy -> NotesOrderBy
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField
                "id"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , userId =
        \inputObj ->
            GraphQL.InputObject.addField
                "userId"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , title =
        \inputObj ->
            GraphQL.InputObject.addField
                "title"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , body =
        \inputObj ->
            GraphQL.InputObject.addField
                "body"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , createdAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "createdAt"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , updatedAt =
        \inputObj ->
            GraphQL.InputObject.addField
                "updatedAt"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder NotesOrderBy
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "NotesOrderBy"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "OrderByDirection" }
                      , { name = "userId", type_ = "OrderByDirection" }
                      , { name = "title", type_ = "OrderByDirection" }
                      , { name = "body", type_ = "OrderByDirection" }
                      , { name = "createdAt", type_ = "OrderByDirection" }
                      , { name = "updatedAt", type_ = "OrderByDirection" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)