module Api.Input.IntFilter exposing
    ( IntFilter
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

@docs IntFilter, input, decoder

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


type alias IntFilter =
    Api.Input.IntFilter


input : IntFilter
input =
    GraphQL.InputObject.inputObject "IntFilter"


eq : Int -> IntFilter -> IntFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField "eq" "Int" (Json.Encode.int newArg_) inputObj_


gt : Int -> IntFilter -> IntFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField "gt" "Int" (Json.Encode.int newArg_) inputObj_


gte : Int -> IntFilter -> IntFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField "gte" "Int" (Json.Encode.int newArg_) inputObj_


in_ : List Int -> IntFilter -> IntFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[Int!]"
        (Json.Encode.list Json.Encode.int newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> IntFilter -> IntFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Int -> IntFilter -> IntFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField "lt" "Int" (Json.Encode.int newArg_) inputObj_


lte : Int -> IntFilter -> IntFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField "lte" "Int" (Json.Encode.int newArg_) inputObj_


neq : Int -> IntFilter -> IntFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField "neq" "Int" (Json.Encode.int newArg_) inputObj_


null :
    { eq : IntFilter -> IntFilter
    , gt : IntFilter -> IntFilter
    , gte : IntFilter -> IntFilter
    , in_ : IntFilter -> IntFilter
    , is : IntFilter -> IntFilter
    , lt : IntFilter -> IntFilter
    , lte : IntFilter -> IntFilter
    , neq : IntFilter -> IntFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "Int" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "Int" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField "gte" "Int" Json.Encode.null inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField "in" "[Int!]" Json.Encode.null inputObj
    , is =
        \inputObj ->
            GraphQL.InputObject.addField
                "is"
                "FilterIs"
                Json.Encode.null
                inputObj
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField "lt" "Int" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField "lte" "Int" Json.Encode.null inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField "neq" "Int" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder IntFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "IntFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Int" }
                      , { name = "gt", type_ = "Int" }
                      , { name = "gte", type_ = "Int" }
                      , { name = "in", type_ = "[Int!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "Int" }
                      , { name = "lte", type_ = "Int" }
                      , { name = "neq", type_ = "Int" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)