module Api.Input.DateListFilter exposing
    ( DateListFilter
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

@docs DateListFilter, input, decoder

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


type alias DateListFilter =
    Api.Input.DateListFilter


input : DateListFilter
input =
    GraphQL.InputObject.inputObject "DateListFilter"


containedBy : List Api.Date -> DateListFilter -> DateListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Date!]"
        (Json.Encode.list Api.date.encode newArg_)
        inputObj_


contains : List Api.Date -> DateListFilter -> DateListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Date!]"
        (Json.Encode.list Api.date.encode newArg_)
        inputObj_


eq : List Api.Date -> DateListFilter -> DateListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Date!]"
        (Json.Encode.list Api.date.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> DateListFilter -> DateListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.Date -> DateListFilter -> DateListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Date!]"
        (Json.Encode.list Api.date.encode newArg_)
        inputObj_


null :
    { containedBy : DateListFilter -> DateListFilter
    , contains : DateListFilter -> DateListFilter
    , eq : DateListFilter -> DateListFilter
    , is : DateListFilter -> DateListFilter
    , overlaps : DateListFilter -> DateListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Date!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Date!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
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
    , overlaps =
        \inputObj ->
            GraphQL.InputObject.addField
                "overlaps"
                "[Date!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder DateListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "DateListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Date!]" }
                      , { name = "contains", type_ = "[Date!]" }
                      , { name = "eq", type_ = "[Date!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Date!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)