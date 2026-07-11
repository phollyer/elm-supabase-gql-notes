module Api.Input.BooleanListFilter exposing
    ( BooleanListFilter
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

@docs BooleanListFilter, input, decoder

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


type alias BooleanListFilter =
    Api.Input.BooleanListFilter


input : BooleanListFilter
input =
    GraphQL.InputObject.inputObject "BooleanListFilter"


containedBy : List Bool -> BooleanListFilter -> BooleanListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Boolean!]"
        (Json.Encode.list Json.Encode.bool newArg_)
        inputObj_


contains : List Bool -> BooleanListFilter -> BooleanListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Boolean!]"
        (Json.Encode.list Json.Encode.bool newArg_)
        inputObj_


eq : List Bool -> BooleanListFilter -> BooleanListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Boolean!]"
        (Json.Encode.list Json.Encode.bool newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BooleanListFilter -> BooleanListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Bool -> BooleanListFilter -> BooleanListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Boolean!]"
        (Json.Encode.list Json.Encode.bool newArg_)
        inputObj_


null :
    { containedBy : BooleanListFilter -> BooleanListFilter
    , contains : BooleanListFilter -> BooleanListFilter
    , eq : BooleanListFilter -> BooleanListFilter
    , is : BooleanListFilter -> BooleanListFilter
    , overlaps : BooleanListFilter -> BooleanListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Boolean!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Boolean!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "[Boolean!]"
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
                "[Boolean!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BooleanListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BooleanListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Boolean!]" }
                      , { name = "contains", type_ = "[Boolean!]" }
                      , { name = "eq", type_ = "[Boolean!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Boolean!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)