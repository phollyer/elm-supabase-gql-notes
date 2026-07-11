module Api.Input.FloatFilter exposing
    ( FloatFilter
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

@docs FloatFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, gt, gte, in_, is, lt, lte, neq
-}


import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias FloatFilter =
    Api.Input.FloatFilter


input : FloatFilter
input =
    GraphQL.InputObject.inputObject "FloatFilter"


eq : Float -> FloatFilter -> FloatFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


gt : Float -> FloatFilter -> FloatFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gt"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


gte : Float -> FloatFilter -> FloatFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


in_ : List Float -> FloatFilter -> FloatFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[Float!]"
        (Json.Encode.list Json.Encode.float newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> FloatFilter -> FloatFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Float -> FloatFilter -> FloatFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lt"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


lte : Float -> FloatFilter -> FloatFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


neq : Float -> FloatFilter -> FloatFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "Float"
        (Json.Encode.float newArg_)
        inputObj_


null :
    { eq : FloatFilter -> FloatFilter
    , gt : FloatFilter -> FloatFilter
    , gte : FloatFilter -> FloatFilter
    , in_ : FloatFilter -> FloatFilter
    , is : FloatFilter -> FloatFilter
    , lt : FloatFilter -> FloatFilter
    , lte : FloatFilter -> FloatFilter
    , neq : FloatFilter -> FloatFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "Float" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "Float" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField "gte" "Float" Json.Encode.null inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
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
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField "lt" "Float" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField "lte" "Float" Json.Encode.null inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField "neq" "Float" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder FloatFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "FloatFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Float" }
                      , { name = "gt", type_ = "Float" }
                      , { name = "gte", type_ = "Float" }
                      , { name = "in", type_ = "[Float!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "Float" }
                      , { name = "lte", type_ = "Float" }
                      , { name = "neq", type_ = "Float" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)