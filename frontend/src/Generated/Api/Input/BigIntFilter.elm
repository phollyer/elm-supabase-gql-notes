module Api.Input.BigIntFilter exposing
    ( BigIntFilter
    , decoder
    , eq
    , gt
    , gte
    , in_
    , input
    , is
    , lt
    , lte
    , neq
    , null
    )

{-|
## Creating an input

@docs BigIntFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, gt, gte, in_, is, lt, lte, neq
-}


import Api
import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias BigIntFilter =
    Api.Input.BigIntFilter


input : BigIntFilter
input =
    GraphQL.InputObject.inputObject "BigIntFilter"


eq : Api.BigInt -> BigIntFilter -> BigIntFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


gt : Api.BigInt -> BigIntFilter -> BigIntFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gt"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


gte : Api.BigInt -> BigIntFilter -> BigIntFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


in_ : List Api.BigInt -> BigIntFilter -> BigIntFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[BigInt!]"
        (Json.Encode.list Api.bigInt.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BigIntFilter -> BigIntFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Api.BigInt -> BigIntFilter -> BigIntFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lt"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


lte : Api.BigInt -> BigIntFilter -> BigIntFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


neq : Api.BigInt -> BigIntFilter -> BigIntFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "BigInt"
        (Api.bigInt.encode newArg_)
        inputObj_


null :
    { eq : BigIntFilter -> BigIntFilter
    , gt : BigIntFilter -> BigIntFilter
    , gte : BigIntFilter -> BigIntFilter
    , in_ : BigIntFilter -> BigIntFilter
    , is : BigIntFilter -> BigIntFilter
    , lt : BigIntFilter -> BigIntFilter
    , lte : BigIntFilter -> BigIntFilter
    , neq : BigIntFilter -> BigIntFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "BigInt" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "BigInt" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField
                "gte"
                "BigInt"
                Json.Encode.null
                inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
                "[BigInt!]"
                Json.Encode.null
                inputObj
    , is =
        \inputObj ->
            GraphQL.InputObject.addField
                "is"
                "FilterIs"
                Json.Encode.null
                inputObj
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField "lt" "BigInt" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField
                "lte"
                "BigInt"
                Json.Encode.null
                inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField
                "neq"
                "BigInt"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BigIntFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BigIntFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "BigInt" }
                      , { name = "gt", type_ = "BigInt" }
                      , { name = "gte", type_ = "BigInt" }
                      , { name = "in", type_ = "[BigInt!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "BigInt" }
                      , { name = "lte", type_ = "BigInt" }
                      , { name = "neq", type_ = "BigInt" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)