module Api.Input.UUIDListFilter exposing
    ( UUIDListFilter
    , containedBy
    , contains
    , decoder
    , eq
    , input
    , is
    , null
    , overlaps
    )

{-|
## Creating an input

@docs UUIDListFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs containedBy, contains, eq, is, overlaps
-}


import Api
import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias UUIDListFilter =
    Api.Input.UUIDListFilter


input : UUIDListFilter
input =
    GraphQL.InputObject.inputObject "UUIDListFilter"


containedBy : List Api.Uuid -> UUIDListFilter -> UUIDListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[UUID!]"
        (Json.Encode.list Api.uuid.encode newArg_)
        inputObj_


contains : List Api.Uuid -> UUIDListFilter -> UUIDListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[UUID!]"
        (Json.Encode.list Api.uuid.encode newArg_)
        inputObj_


eq : List Api.Uuid -> UUIDListFilter -> UUIDListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[UUID!]"
        (Json.Encode.list Api.uuid.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> UUIDListFilter -> UUIDListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.Uuid -> UUIDListFilter -> UUIDListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[UUID!]"
        (Json.Encode.list Api.uuid.encode newArg_)
        inputObj_


null :
    { containedBy : UUIDListFilter -> UUIDListFilter
    , contains : UUIDListFilter -> UUIDListFilter
    , eq : UUIDListFilter -> UUIDListFilter
    , is : UUIDListFilter -> UUIDListFilter
    , overlaps : UUIDListFilter -> UUIDListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[UUID!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[UUID!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
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
    , overlaps =
        \inputObj ->
            GraphQL.InputObject.addField
                "overlaps"
                "[UUID!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder UUIDListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "UUIDListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[UUID!]" }
                      , { name = "contains", type_ = "[UUID!]" }
                      , { name = "eq", type_ = "[UUID!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[UUID!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)