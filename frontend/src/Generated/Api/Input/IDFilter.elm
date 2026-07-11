module Api.Input.IDFilter exposing (IDFilter, decoder, eq, input, null)

{-|
## Creating an input

@docs IDFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq
-}


import Api
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias IDFilter =
    Api.Input.IDFilter


input : IDFilter
input =
    GraphQL.InputObject.inputObject "IDFilter"


eq : Api.Id -> IDFilter -> IDFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField "eq" "ID" (Api.id.encode newArg_) inputObj_


null : { eq : IDFilter -> IDFilter }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "ID" Json.Encode.null inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder IDFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "IDFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "ID" } ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)