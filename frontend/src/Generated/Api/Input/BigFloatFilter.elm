module Api.Input.BigFloatFilter exposing
    ( BigFloatFilter
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

@docs BigFloatFilter, input, decoder

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


type alias BigFloatFilter =
    Api.Input.BigFloatFilter


input : BigFloatFilter
input =
    GraphQL.InputObject.inputObject "BigFloatFilter"


eq : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


gt : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gt"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


gte : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


in_ : List Api.BigFloat -> BigFloatFilter -> BigFloatFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[BigFloat!]"
        (Json.Encode.list Api.bigFloat.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BigFloatFilter -> BigFloatFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lt"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


lte : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


neq : Api.BigFloat -> BigFloatFilter -> BigFloatFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "BigFloat"
        (Api.bigFloat.encode newArg_)
        inputObj_


null :
    { eq : BigFloatFilter -> BigFloatFilter
    , gt : BigFloatFilter -> BigFloatFilter
    , gte : BigFloatFilter -> BigFloatFilter
    , in_ : BigFloatFilter -> BigFloatFilter
    , is : BigFloatFilter -> BigFloatFilter
    , lt : BigFloatFilter -> BigFloatFilter
    , lte : BigFloatFilter -> BigFloatFilter
    , neq : BigFloatFilter -> BigFloatFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "BigFloat"
                Json.Encode.null
                inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField
                "gt"
                "BigFloat"
                Json.Encode.null
                inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField
                "gte"
                "BigFloat"
                Json.Encode.null
                inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
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
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField
                "lt"
                "BigFloat"
                Json.Encode.null
                inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField
                "lte"
                "BigFloat"
                Json.Encode.null
                inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField
                "neq"
                "BigFloat"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BigFloatFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BigFloatFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "BigFloat" }
                      , { name = "gt", type_ = "BigFloat" }
                      , { name = "gte", type_ = "BigFloat" }
                      , { name = "in", type_ = "[BigFloat!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "BigFloat" }
                      , { name = "lte", type_ = "BigFloat" }
                      , { name = "neq", type_ = "BigFloat" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)