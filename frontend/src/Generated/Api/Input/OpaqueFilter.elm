module Api.Input.OpaqueFilter exposing
    ( OpaqueFilter
    , decoder
    , eq
    , input
    , is
    , null
    )

{-|
## Creating an input

@docs OpaqueFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, is
-}


import Api
import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias OpaqueFilter =
    Api.Input.OpaqueFilter


input : OpaqueFilter
input =
    GraphQL.InputObject.inputObject "OpaqueFilter"


eq : Api.Opaque -> OpaqueFilter -> OpaqueFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "Opaque"
        (Api.opaque.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> OpaqueFilter -> OpaqueFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


null : { eq : OpaqueFilter -> OpaqueFilter, is : OpaqueFilter -> OpaqueFilter }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "Opaque" Json.Encode.null inputObj
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
decoder : Json.Decode.Decoder OpaqueFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "OpaqueFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "Opaque" }
                      , { name = "is", type_ = "FilterIs" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)