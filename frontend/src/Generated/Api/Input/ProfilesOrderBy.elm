module Api.Input.ProfilesOrderBy exposing
    ( ProfilesOrderBy
    , createdAt
    , decoder
    , displayName
    , email
    , id
    , input
    , null
    , updatedAt
    )

{-|
## Creating an input

@docs ProfilesOrderBy, input, decoder

## Null values

@docs null

## Optional fields

@docs id, email, displayName, createdAt, updatedAt
-}


import Api.Enum.OrderByDirection
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias ProfilesOrderBy =
    Api.Input.ProfilesOrderBy


input : ProfilesOrderBy
input =
    GraphQL.InputObject.inputObject "ProfilesOrderBy"


id :
    Api.Enum.OrderByDirection.OrderByDirection
    -> ProfilesOrderBy
    -> ProfilesOrderBy
id newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "id"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


email :
    Api.Enum.OrderByDirection.OrderByDirection
    -> ProfilesOrderBy
    -> ProfilesOrderBy
email newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "email"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


displayName :
    Api.Enum.OrderByDirection.OrderByDirection
    -> ProfilesOrderBy
    -> ProfilesOrderBy
displayName newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "displayName"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


createdAt :
    Api.Enum.OrderByDirection.OrderByDirection
    -> ProfilesOrderBy
    -> ProfilesOrderBy
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


updatedAt :
    Api.Enum.OrderByDirection.OrderByDirection
    -> ProfilesOrderBy
    -> ProfilesOrderBy
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "OrderByDirection"
        (Api.Enum.OrderByDirection.encode newArg_)
        inputObj_


null :
    { id : ProfilesOrderBy -> ProfilesOrderBy
    , email : ProfilesOrderBy -> ProfilesOrderBy
    , displayName : ProfilesOrderBy -> ProfilesOrderBy
    , createdAt : ProfilesOrderBy -> ProfilesOrderBy
    , updatedAt : ProfilesOrderBy -> ProfilesOrderBy
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField
                "id"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , email =
        \inputObj ->
            GraphQL.InputObject.addField
                "email"
                "OrderByDirection"
                Json.Encode.null
                inputObj
    , displayName =
        \inputObj ->
            GraphQL.InputObject.addField
                "displayName"
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
decoder : Json.Decode.Decoder ProfilesOrderBy
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "ProfilesOrderBy"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "OrderByDirection" }
                      , { name = "email", type_ = "OrderByDirection" }
                      , { name = "displayName", type_ = "OrderByDirection" }
                      , { name = "createdAt", type_ = "OrderByDirection" }
                      , { name = "updatedAt", type_ = "OrderByDirection" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)