module Api.Input.BooleanFilter exposing
    ( BooleanFilter
    , decoder
    , eq
    , input
    , is
    , null
    )

{-|
## Creating an input

@docs BooleanFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, is
-}


import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias BooleanFilter =
    Api.Input.BooleanFilter


input : BooleanFilter
input =
    GraphQL.InputObject.inputObject "BooleanFilter"


eq : Bool -> BooleanFilter -> BooleanFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "Boolean"
        (Json.Encode.bool newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> BooleanFilter -> BooleanFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


null :
    { eq : BooleanFilter -> BooleanFilter, is : BooleanFilter -> BooleanFilter }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "Boolean"
                Json.Encode.null
                inputObj
    , is =
        \inputObj ->
            GraphQL.InputObject.addField
                "is"
                "FilterIs"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder BooleanFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "BooleanFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Boolean" }
                      , { name = "is", type_ = "FilterIs" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)