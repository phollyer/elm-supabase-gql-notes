module Api.Input.TimeFilter exposing
    ( TimeFilter
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

@docs TimeFilter, input, decoder

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


type alias TimeFilter =
    Api.Input.TimeFilter


input : TimeFilter
input =
    GraphQL.InputObject.inputObject "TimeFilter"


eq : Api.Time -> TimeFilter -> TimeFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField "eq" "Time" (Api.time.encode newArg_) inputObj_


gt : Api.Time -> TimeFilter -> TimeFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField "gt" "Time" (Api.time.encode newArg_) inputObj_


gte : Api.Time -> TimeFilter -> TimeFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "Time"
        (Api.time.encode newArg_)
        inputObj_


in_ : List Api.Time -> TimeFilter -> TimeFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[Time!]"
        (Json.Encode.list Api.time.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> TimeFilter -> TimeFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


lt : Api.Time -> TimeFilter -> TimeFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField "lt" "Time" (Api.time.encode newArg_) inputObj_


lte : Api.Time -> TimeFilter -> TimeFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "Time"
        (Api.time.encode newArg_)
        inputObj_


neq : Api.Time -> TimeFilter -> TimeFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "Time"
        (Api.time.encode newArg_)
        inputObj_


null :
    { eq : TimeFilter -> TimeFilter
    , gt : TimeFilter -> TimeFilter
    , gte : TimeFilter -> TimeFilter
    , in_ : TimeFilter -> TimeFilter
    , is : TimeFilter -> TimeFilter
    , lt : TimeFilter -> TimeFilter
    , lte : TimeFilter -> TimeFilter
    , neq : TimeFilter -> TimeFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "Time" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "Time" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField "gte" "Time" Json.Encode.null inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
                "[Time!]"
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
            GraphQL.InputObject.addField "lt" "Time" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField "lte" "Time" Json.Encode.null inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField "neq" "Time" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder TimeFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "TimeFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Time" }
                      , { name = "gt", type_ = "Time" }
                      , { name = "gte", type_ = "Time" }
                      , { name = "in", type_ = "[Time!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "lt", type_ = "Time" }
                      , { name = "lte", type_ = "Time" }
                      , { name = "neq", type_ = "Time" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)