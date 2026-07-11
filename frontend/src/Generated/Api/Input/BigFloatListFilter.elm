module Api.Input.BigFloatListFilter exposing
    ( BigFloatListFilter
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

@docs BigFloatListFilter, input, decoder

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


type alias BigFloatListFilter =
    Api.Input.BigFloatListFilter


input : BigFloatListFilter
input =
    GraphQL.InputObject.inputObject "BigFloatListFilter"


containedBy : List Api.BigFloat -> BigFloatListFilter -> BigFloatListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[BigFloat!]"
        (Json.Encode.list Api.bigFloat.encode newArg_)
        inputObj_


contains : List Api.BigFloat -> BigFloatListFilter -> BigFloatListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[BigFloat!]"
        (Json.Encode.list Api.bigFloat.encode newArg_)
        inputObj_


eq : List Api.BigFloat -> BigFloatListFilter -> BigFloatListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[BigFloat!]"
        (Json.Encode.list Api.bigFloat.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BigFloatListFilter -> BigFloatListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.BigFloat -> BigFloatListFilter -> BigFloatListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[BigFloat!]"
        (Json.Encode.list Api.bigFloat.encode newArg_)
        inputObj_


null :
    { containedBy : BigFloatListFilter -> BigFloatListFilter
    , contains : BigFloatListFilter -> BigFloatListFilter
    , eq : BigFloatListFilter -> BigFloatListFilter
    , is : BigFloatListFilter -> BigFloatListFilter
    , overlaps : BigFloatListFilter -> BigFloatListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[BigFloat!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[BigFloat!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "[BigFloat!]"
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
                "[BigFloat!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BigFloatListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BigFloatListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[BigFloat!]" }
                      , { name = "contains", type_ = "[BigFloat!]" }
                      , { name = "eq", type_ = "[BigFloat!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[BigFloat!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)