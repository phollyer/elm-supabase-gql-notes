module Api.Input.DatetimeFilter exposing
    ( DatetimeFilter
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

@docs DatetimeFilter, input, decoder

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


type alias DatetimeFilter =
    Api.Input.DatetimeFilter


input : DatetimeFilter
input =
    GraphQL.InputObject.inputObject "DatetimeFilter"


eq : Api.Datetime -> DatetimeFilter -> DatetimeFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


gt : Api.Datetime -> DatetimeFilter -> DatetimeFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


gte : Api.Datetime -> DatetimeFilter -> DatetimeFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


in_ : List Api.Datetime -> DatetimeFilter -> DatetimeFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[Datetime!]"
        (Json.Encode.list Api.datetime.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> DatetimeFilter -> DatetimeFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Api.Datetime -> DatetimeFilter -> DatetimeFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lt"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


lte : Api.Datetime -> DatetimeFilter -> DatetimeFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


neq : Api.Datetime -> DatetimeFilter -> DatetimeFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "Datetime"
        (Api.datetime.encode newArg_)
        inputObj_


null :
    { eq : DatetimeFilter -> DatetimeFilter
    , gt : DatetimeFilter -> DatetimeFilter
    , gte : DatetimeFilter -> DatetimeFilter
    , in_ : DatetimeFilter -> DatetimeFilter
    , is : DatetimeFilter -> DatetimeFilter
    , lt : DatetimeFilter -> DatetimeFilter
    , lte : DatetimeFilter -> DatetimeFilter
    , neq : DatetimeFilter -> DatetimeFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "Datetime"
                Json.Encode.null
                inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField
                "gt"
                "Datetime"
                Json.Encode.null
                inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField
                "gte"
                "Datetime"
                Json.Encode.null
                inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
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
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField
                "lt"
                "Datetime"
                Json.Encode.null
                inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField
                "lte"
                "Datetime"
                Json.Encode.null
                inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField
                "neq"
                "Datetime"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder DatetimeFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "DatetimeFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Datetime" }
                      , { name = "gt", type_ = "Datetime" }
                      , { name = "gte", type_ = "Datetime" }
                      , { name = "in", type_ = "[Datetime!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "Datetime" }
                      , { name = "lte", type_ = "Datetime" }
                      , { name = "neq", type_ = "Datetime" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)