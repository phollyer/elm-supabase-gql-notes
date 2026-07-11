module Api.Input.DateFilter exposing
    ( DateFilter
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

@docs DateFilter, input, decoder

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


type alias DateFilter =
    Api.Input.DateFilter


input : DateFilter
input =
    GraphQL.InputObject.inputObject "DateFilter"


eq : Api.Date -> DateFilter -> DateFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField "eq" "Date" (Api.date.encode newArg_) inputObj_


gt : Api.Date -> DateFilter -> DateFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField "gt" "Date" (Api.date.encode newArg_) inputObj_


gte : Api.Date -> DateFilter -> DateFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "Date"
        (Api.date.encode newArg_)
        inputObj_


in_ : List Api.Date -> DateFilter -> DateFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[Date!]"
        (Json.Encode.list Api.date.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> DateFilter -> DateFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Api.Date -> DateFilter -> DateFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField "lt" "Date" (Api.date.encode newArg_) inputObj_


lte : Api.Date -> DateFilter -> DateFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "Date"
        (Api.date.encode newArg_)
        inputObj_


neq : Api.Date -> DateFilter -> DateFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "Date"
        (Api.date.encode newArg_)
        inputObj_


null :
    { eq : DateFilter -> DateFilter
    , gt : DateFilter -> DateFilter
    , gte : DateFilter -> DateFilter
    , in_ : DateFilter -> DateFilter
    , is : DateFilter -> DateFilter
    , lt : DateFilter -> DateFilter
    , lte : DateFilter -> DateFilter
    , neq : DateFilter -> DateFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "Date" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "Date" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField "gte" "Date" Json.Encode.null inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
                "[Date!]"
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
            GraphQL.InputObject.addField "lt" "Date" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField "lte" "Date" Json.Encode.null inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField "neq" "Date" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder DateFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "DateFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Date" }
                      , { name = "gt", type_ = "Date" }
                      , { name = "gte", type_ = "Date" }
                      , { name = "in", type_ = "[Date!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "Date" }
                      , { name = "lte", type_ = "Date" }
                      , { name = "neq", type_ = "Date" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)