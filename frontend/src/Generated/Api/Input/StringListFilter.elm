module Api.Input.StringListFilter exposing
    ( StringListFilter
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

@docs StringListFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs containedBy, contains, eq, is, overlaps
-}


import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias StringListFilter =
    Api.Input.StringListFilter


input : StringListFilter
input =
    GraphQL.InputObject.inputObject "StringListFilter"


containedBy : List String -> StringListFilter -> StringListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[String!]"
        (Json.Encode.list Json.Encode.string newArg_)
        inputObj_


contains : List String -> StringListFilter -> StringListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[String!]"
        (Json.Encode.list Json.Encode.string newArg_)
        inputObj_


eq : List String -> StringListFilter -> StringListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[String!]"
        (Json.Encode.list Json.Encode.string newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> StringListFilter -> StringListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List String -> StringListFilter -> StringListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[String!]"
        (Json.Encode.list Json.Encode.string newArg_)
        inputObj_


null :
    { containedBy : StringListFilter -> StringListFilter
    , contains : StringListFilter -> StringListFilter
    , eq : StringListFilter -> StringListFilter
    , is : StringListFilter -> StringListFilter
    , overlaps : StringListFilter -> StringListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[String!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[String!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
                "[String!]"
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
                "[String!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder StringListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "StringListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[String!]" }
                      , { name = "contains", type_ = "[String!]" }
                      , { name = "eq", type_ = "[String!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[String!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)