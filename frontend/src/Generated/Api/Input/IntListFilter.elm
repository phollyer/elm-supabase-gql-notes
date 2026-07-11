module Api.Input.IntListFilter exposing
    ( IntListFilter
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

@docs IntListFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs containedBy, contains, eq, is, overlaps
-}


import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias IntListFilter =
    Api.Input.IntListFilter


input : IntListFilter
input =
    GraphQL.InputObject.inputObject "IntListFilter"


containedBy : List Int -> IntListFilter -> IntListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Int!]"
        (Json.Encode.list Json.Encode.int newArg_)
        inputObj_


contains : List Int -> IntListFilter -> IntListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Int!]"
        (Json.Encode.list Json.Encode.int newArg_)
        inputObj_


eq : List Int -> IntListFilter -> IntListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Int!]"
        (Json.Encode.list Json.Encode.int newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> IntListFilter -> IntListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Int -> IntListFilter -> IntListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Int!]"
        (Json.Encode.list Json.Encode.int newArg_)
        inputObj_


null :
    { containedBy : IntListFilter -> IntListFilter
    , contains : IntListFilter -> IntListFilter
    , eq : IntListFilter -> IntListFilter
    , is : IntListFilter -> IntListFilter
    , overlaps : IntListFilter -> IntListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Int!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Int!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "[Int!]" Json.Encode.null inputObj
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
                "[Int!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder IntListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "IntListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Int!]" }
                      , { name = "contains", type_ = "[Int!]" }
                      , { name = "eq", type_ = "[Int!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Int!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)