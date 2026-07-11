module Api.Input.FloatListFilter exposing
    ( FloatListFilter
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

@docs FloatListFilter, input, decoder

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


type alias FloatListFilter =
    Api.Input.FloatListFilter


input : FloatListFilter
input =
    GraphQL.InputObject.inputObject "FloatListFilter"


containedBy : List Float -> FloatListFilter -> FloatListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Float!]"
        (Json.Encode.list Json.Encode.float newArg_)
        inputObj_


contains : List Float -> FloatListFilter -> FloatListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Float!]"
        (Json.Encode.list Json.Encode.float newArg_)
        inputObj_


eq : List Float -> FloatListFilter -> FloatListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Float!]"
        (Json.Encode.list Json.Encode.float newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> FloatListFilter -> FloatListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Float -> FloatListFilter -> FloatListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Float!]"
        (Json.Encode.list Json.Encode.float newArg_)
        inputObj_


null :
    { containedBy : FloatListFilter -> FloatListFilter
    , contains : FloatListFilter -> FloatListFilter
    , eq : FloatListFilter -> FloatListFilter
    , is : FloatListFilter -> FloatListFilter
    , overlaps : FloatListFilter -> FloatListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Float!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Float!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "[Float!]"
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
                "[Float!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder FloatListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "FloatListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Float!]" }
                      , { name = "contains", type_ = "[Float!]" }
                      , { name = "eq", type_ = "[Float!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Float!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)