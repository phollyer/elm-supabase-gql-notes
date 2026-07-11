module Api.Input.TimeListFilter exposing
    ( TimeListFilter
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

@docs TimeListFilter, input, decoder

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


type alias TimeListFilter =
    Api.Input.TimeListFilter


input : TimeListFilter
input =
    GraphQL.InputObject.inputObject "TimeListFilter"


containedBy : List Api.Time -> TimeListFilter -> TimeListFilter
containedBy newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "containedBy"
        "[Time!]"
        (Json.Encode.list Api.time.encode newArg_)
        inputObj_


contains : List Api.Time -> TimeListFilter -> TimeListFilter
contains newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "contains"
        "[Time!]"
        (Json.Encode.list Api.time.encode newArg_)
        inputObj_


eq : List Api.Time -> TimeListFilter -> TimeListFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "[Time!]"
        (Json.Encode.list Api.time.encode newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> TimeListFilter -> TimeListFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


overlaps : List Api.Time -> TimeListFilter -> TimeListFilter
overlaps newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "overlaps"
        "[Time!]"
        (Json.Encode.list Api.time.encode newArg_)
        inputObj_


null :
    { containedBy : TimeListFilter -> TimeListFilter
    , contains : TimeListFilter -> TimeListFilter
    , eq : TimeListFilter -> TimeListFilter
    , is : TimeListFilter -> TimeListFilter
    , overlaps : TimeListFilter -> TimeListFilter
    }
null =
    { containedBy =
        \inputObj ->
            GraphQL.InputObject.addField
                "containedBy"
                "[Time!]"
                Json.Encode.null
                inputObj
    , contains =
        \inputObj ->
            GraphQL.InputObject.addField
                "contains"
                "[Time!]"
                Json.Encode.null
                inputObj
    , eq =
        \inputObj ->
            GraphQL.InputObject.addField
                "eq"
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
    , overlaps =
        \inputObj ->
            GraphQL.InputObject.addField
                "overlaps"
                "[Time!]"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder TimeListFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "TimeListFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "containedBy", type_ = "[Time!]" }
                      , { name = "contains", type_ = "[Time!]" }
                      , { name = "eq", type_ = "[Time!]" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "overlaps", type_ = "[Time!]" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)