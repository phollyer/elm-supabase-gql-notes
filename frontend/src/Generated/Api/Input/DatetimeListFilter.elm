module Api.Input.DatetimeListFilter exposing
    ( DatetimeListFilter
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

@docs DatetimeListFilter, input, decoder

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


type alias DatetimeListFilter =
    Api.Input.DatetimeListFilter


input : DatetimeListFilter
input =
    GraphQL.InputObject.inputObject "DatetimeListFilter"


containedBy : List Api.Datetime -> DatetimeListFilter -> DatetimeListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Datetime!]"
        (Json.Encode.list Api.datetime.encode newArg_)
        inputObj_


contains : List Api.Datetime -> DatetimeListFilter -> DatetimeListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Datetime!]"
        (Json.Encode.list Api.datetime.encode newArg_)
        inputObj_


eq : List Api.Datetime -> DatetimeListFilter -> DatetimeListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Datetime!]"
        (Json.Encode.list Api.datetime.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> DatetimeListFilter -> DatetimeListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.Datetime -> DatetimeListFilter -> DatetimeListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Datetime!]"
        (Json.Encode.list Api.datetime.encode newArg_)
        inputObj_


null :
    { containedBy : DatetimeListFilter -> DatetimeListFilter
    , contains : DatetimeListFilter -> DatetimeListFilter
    , eq : DatetimeListFilter -> DatetimeListFilter
    , is : DatetimeListFilter -> DatetimeListFilter
    , overlaps : DatetimeListFilter -> DatetimeListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Datetime!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Datetime!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "[Datetime!]"
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
                "[Datetime!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder DatetimeListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "DatetimeListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Datetime!]" }
                      , { name = "contains", type_ = "[Datetime!]" }
                      , { name = "eq", type_ = "[Datetime!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Datetime!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)