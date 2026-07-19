module Api.Input.ProfilesFilter exposing
    ( ProfilesFilter
    , and
    , avatarPath
    , createdAt
    , decoder
    , displayName
    , email
    , id
    , input
    , nodeId
    , not
    , null
    , or
    , updatedAt
    )

{-|
## Creating an input

@docs ProfilesFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs id, email, displayName, createdAt, updatedAt, avatarPath, nodeId, and, or, not
-}


import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias ProfilesFilter =
    Api.Input.ProfilesFilter


input : ProfilesFilter
input =
    GraphQL.InputObject.inputObject "ProfilesFilter"


id : Api.Input.UUIDFilter -> ProfilesFilter -> ProfilesFilter
id newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "id"
        "UUIDFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


email : Api.Input.StringFilter -> ProfilesFilter -> ProfilesFilter
email newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "email"
        "StringFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


displayName : Api.Input.StringFilter -> ProfilesFilter -> ProfilesFilter
displayName newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "displayName"
        "StringFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


createdAt : Api.Input.DatetimeFilter -> ProfilesFilter -> ProfilesFilter
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "DatetimeFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


updatedAt : Api.Input.DatetimeFilter -> ProfilesFilter -> ProfilesFilter
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "DatetimeFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


avatarPath : Api.Input.StringFilter -> ProfilesFilter -> ProfilesFilter
avatarPath newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "avatarPath"
        "StringFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


nodeId : Api.Input.IDFilter -> ProfilesFilter -> ProfilesFilter
nodeId newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "nodeId"
        "IDFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


and : List Api.Input.ProfilesFilter -> ProfilesFilter -> ProfilesFilter
and newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "and"
        "[ProfilesFilter!]"
        (Json.Encode.list GraphQL.InputObject.encode newArg_)
        inputObj_


or : List Api.Input.ProfilesFilter -> ProfilesFilter -> ProfilesFilter
or newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "or"
        "[ProfilesFilter!]"
        (Json.Encode.list GraphQL.InputObject.encode newArg_)
        inputObj_


not : Api.Input.ProfilesFilter -> ProfilesFilter -> ProfilesFilter
not newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "not"
        "ProfilesFilter"
        (GraphQL.InputObject.encode newArg_)
        inputObj_


null :
    { id : ProfilesFilter -> ProfilesFilter
    , email : ProfilesFilter -> ProfilesFilter
    , displayName : ProfilesFilter -> ProfilesFilter
    , createdAt : ProfilesFilter -> ProfilesFilter
    , updatedAt : ProfilesFilter -> ProfilesFilter
    , avatarPath : ProfilesFilter -> ProfilesFilter
    , nodeId : ProfilesFilter -> ProfilesFilter
    , and : ProfilesFilter -> ProfilesFilter
    , or : ProfilesFilter -> ProfilesFilter
    , not : ProfilesFilter -> ProfilesFilter
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField
                "id"
                "UUIDFilter"
                Json.Encode.null
                inputObj
    , email =
        \inputObj ->
            GraphQL.InputObject.addField
                "email"
                "StringFilter"
                Json.Encode.null
                inputObj
    , displayName =
        \inputObj ->
            GraphQL.InputObject.addField
                "displayName"
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
    , avatarPath =
        \inputObj ->
            GraphQL.InputObject.addField
                "avatarPath"
                "StringFilter"
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
                "[ProfilesFilter!]"
                Json.Encode.null
                inputObj
    , or =
        \inputObj ->
            GraphQL.InputObject.addField
                "or"
                "[ProfilesFilter!]"
                Json.Encode.null
                inputObj
    , not =
        \inputObj ->
            GraphQL.InputObject.addField
                "not"
                "ProfilesFilter"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder ProfilesFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "ProfilesFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "UUIDFilter" }
                      , { name = "email", type_ = "StringFilter" }
                      , { name = "displayName", type_ = "StringFilter" }
                      , { name = "createdAt", type_ = "DatetimeFilter" }
                      , { name = "updatedAt", type_ = "DatetimeFilter" }
                      , { name = "avatarPath", type_ = "StringFilter" }
                      , { name = "nodeId", type_ = "IDFilter" }
                      , { name = "and", type_ = "[ProfilesFilter!]" }
                      , { name = "or", type_ = "[ProfilesFilter!]" }
                      , { name = "not", type_ = "ProfilesFilter" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)