module Api.Input.ProfilesInsertInput exposing
    ( ProfilesInsertInput
    , avatarPath
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

@docs ProfilesInsertInput, input, decoder

## Null values

@docs null

## Optional fields

@docs id, email, displayName, createdAt, updatedAt, avatarPath
-}


import Api
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias ProfilesInsertInput =
    Api.Input.ProfilesInsertInput


input : ProfilesInsertInput
input =
    GraphQL.InputObject.inputObject "ProfilesInsertInput"


id : Api.Uuid -> ProfilesInsertInput -> ProfilesInsertInput
id newArg_ inputObj_ =
    GraphQL.InputObject.addField "id" "UUID" (Api.uuid.encode newArg_) inputObj_


email : String -> ProfilesInsertInput -> ProfilesInsertInput
email newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "email"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


displayName : String -> ProfilesInsertInput -> ProfilesInsertInput
displayName newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "displayName"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


createdAt : Api.Datetime -> ProfilesInsertInput -> ProfilesInsertInput
createdAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "createdAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


updatedAt : Api.Datetime -> ProfilesInsertInput -> ProfilesInsertInput
updatedAt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "updatedAt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


avatarPath : String -> ProfilesInsertInput -> ProfilesInsertInput
avatarPath newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "avatarPath"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


null :
    { id : ProfilesInsertInput -> ProfilesInsertInput
    , email : ProfilesInsertInput -> ProfilesInsertInput
    , displayName : ProfilesInsertInput -> ProfilesInsertInput
    , createdAt : ProfilesInsertInput -> ProfilesInsertInput
    , updatedAt : ProfilesInsertInput -> ProfilesInsertInput
    , avatarPath : ProfilesInsertInput -> ProfilesInsertInput
    }
null =
    { id =
        \inputObj ->
            GraphQL.InputObject.addField "id" "UUID" Json.Encode.null inputObj
    , email =
        \inputObj ->
            GraphQL.InputObject.addField
                "email"
                "String"
                Json.Encode.null
                inputObj
    , displayName =
        \inputObj ->
            GraphQL.InputObject.addField
                "displayName"
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
    , avatarPath =
        \inputObj ->
            GraphQL.InputObject.addField
                "avatarPath"
                "String"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder ProfilesInsertInput
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "ProfilesInsertInput"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "id", type_ = "UUID" }
                      , { name = "email", type_ = "String" }
                      , { name = "displayName", type_ = "String" }
                      , { name = "createdAt", type_ = "Datetime" }
                      , { name = "updatedAt", type_ = "Datetime" }
                      , { name = "avatarPath", type_ = "String" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)