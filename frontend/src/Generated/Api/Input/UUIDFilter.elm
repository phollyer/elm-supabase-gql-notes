module Api.Input.UUIDFilter exposing
    ( UUIDFilter
    , decoder
    , eq
    , in_
    , input
    , is
    , neq
    , null
    )

{-|
## Creating an input

@docs UUIDFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, in_, is, neq
-}


import Api
import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias UUIDFilter =
    Api.Input.UUIDFilter


input : UUIDFilter
input =
    GraphQL.InputObject.inputObject "UUIDFilter"


eq : Api.Uuid -> UUIDFilter -> UUIDFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField "eq" "UUID" (Api.uuid.encode newArg_) inputObj_


in_ : List Api.Uuid -> UUIDFilter -> UUIDFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[UUID!]"
        (Json.Encode.list Api.uuid.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> UUIDFilter -> UUIDFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


neq : Api.Uuid -> UUIDFilter -> UUIDFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "UUID"
        (Api.uuid.encode newArg_)
        inputObj_


null :
    { eq : UUIDFilter -> UUIDFilter
    , in_ : UUIDFilter -> UUIDFilter
    , is : UUIDFilter -> UUIDFilter
    , neq : UUIDFilter -> UUIDFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "UUID" Json.Encode.null inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
                "[UUID!]"
                Json.Encode.null
                inputObj
    , is =
        \inputObj ->
            GraphQL.InputObject.addField
                "is"
                "FilterIs"
                Json.Encode.null
                inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField "neq" "UUID" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder UUIDFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "UUIDFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "UUID" }
                      , { name = "in", type_ = "[UUID!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "neq", type_ = "UUID" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)