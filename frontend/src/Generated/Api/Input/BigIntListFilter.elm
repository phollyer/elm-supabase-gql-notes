module Api.Input.BigIntListFilter exposing
    ( BigIntListFilter
    , containedBy
    , contains
    , decoder
    , eq
    , input
    , is
    , null
    , overlaps
    )

{-|
## Creating an input

@docs BigIntListFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs containedBy, contains, eq, is, overlaps
-}


import Api
import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias BigIntListFilter =
    Api.Input.BigIntListFilter


input : BigIntListFilter
input =
    GraphQL.InputObject.inputObject "BigIntListFilter"


containedBy : List Api.BigInt -> BigIntListFilter -> BigIntListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[BigInt!]"
        (Json.Encode.list Api.bigInt.encode newArg_)
        inputObj_


contains : List Api.BigInt -> BigIntListFilter -> BigIntListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[BigInt!]"
        (Json.Encode.list Api.bigInt.encode newArg_)
        inputObj_


eq : List Api.BigInt -> BigIntListFilter -> BigIntListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[BigInt!]"
        (Json.Encode.list Api.bigInt.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BigIntListFilter -> BigIntListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.BigInt -> BigIntListFilter -> BigIntListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[BigInt!]"
        (Json.Encode.list Api.bigInt.encode newArg_)
        inputObj_


null :
    { containedBy : BigIntListFilter -> BigIntListFilter
    , contains : BigIntListFilter -> BigIntListFilter
    , eq : BigIntListFilter -> BigIntListFilter
    , is : BigIntListFilter -> BigIntListFilter
    , overlaps : BigIntListFilter -> BigIntListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[BigInt!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[BigInt!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
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
    , overlaps =
        \inputObj ->
            GraphQL.InputObject.addField
                "overlaps"
                "[BigInt!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BigIntListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BigIntListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[BigInt!]" }
                      , { name = "contains", type_ = "[BigInt!]" }
                      , { name = "eq", type_ = "[BigInt!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[BigInt!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)