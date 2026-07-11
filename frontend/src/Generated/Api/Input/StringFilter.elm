module Api.Input.StringFilter exposing
    ( StringFilter
    , decoder
    , eq
    , gt
    , gte
    , ilike
    , in_
    , input
    , iregex
    , is
    , like
    , lt
    , lte
    , neq
    , null
    , regex
    , startsWith
    )

{-|
## Creating an input

@docs StringFilter, input, decoder

## Null values

@docs null

## Optional fields

@docs eq, gt, gte, ilike, in_, iregex, is, like, lt, lte, neq, regex, startsWith
-}


import Api.Enum.FilterIs
import Api.Input
import Dict
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias StringFilter =
    Api.Input.StringFilter


input : StringFilter
input =
    GraphQL.InputObject.inputObject "StringFilter"


eq : String -> StringFilter -> StringFilter
eq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "eq"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


gt : String -> StringFilter -> StringFilter
gt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gt"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


gte : String -> StringFilter -> StringFilter
gte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "gte"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


ilike : String -> StringFilter -> StringFilter
ilike newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "ilike"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


in_ : List String -> StringFilter -> StringFilter
in_ newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "in"
        "[String!]"
        (Json.Encode.list Json.Encode.string newArg_)
        inputObj_


iregex : String -> StringFilter -> StringFilter
iregex newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "iregex"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


is : Api.Enum.FilterIs.FilterIs -> StringFilter -> StringFilter
is newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "is"
        "FilterIs"
        (Api.Enum.FilterIs.encode newArg_)
        inputObj_


like : String -> StringFilter -> StringFilter
like newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "like"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


lt : String -> StringFilter -> StringFilter
lt newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lt"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


lte : String -> StringFilter -> StringFilter
lte newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "lte"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


neq : String -> StringFilter -> StringFilter
neq newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "neq"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


regex : String -> StringFilter -> StringFilter
regex newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "regex"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


startsWith : String -> StringFilter -> StringFilter
startsWith newArg_ inputObj_ =
    GraphQL.InputObject.addField
        "startsWith"
        "String"
        (Json.Encode.string newArg_)
        inputObj_


null :
    { eq : StringFilter -> StringFilter
    , gt : StringFilter -> StringFilter
    , gte : StringFilter -> StringFilter
    , ilike : StringFilter -> StringFilter
    , in_ : StringFilter -> StringFilter
    , iregex : StringFilter -> StringFilter
    , is : StringFilter -> StringFilter
    , like : StringFilter -> StringFilter
    , lt : StringFilter -> StringFilter
    , lte : StringFilter -> StringFilter
    , neq : StringFilter -> StringFilter
    , regex : StringFilter -> StringFilter
    , startsWith : StringFilter -> StringFilter
    }
null =
    { eq =
        \inputObj ->
            GraphQL.InputObject.addField "eq" "String" Json.Encode.null inputObj
    , gt =
        \inputObj ->
            GraphQL.InputObject.addField "gt" "String" Json.Encode.null inputObj
    , gte =
        \inputObj ->
            GraphQL.InputObject.addField
                "gte"
                "String"
                Json.Encode.null
                inputObj
    , ilike =
        \inputObj ->
            GraphQL.InputObject.addField
                "ilike"
                "String"
                Json.Encode.null
                inputObj
    , in_ =
        \inputObj ->
            GraphQL.InputObject.addField
                "in"
                "[String!]"
                Json.Encode.null
                inputObj
    , iregex =
        \inputObj ->
            GraphQL.InputObject.addField
                "iregex"
                "String"
                Json.Encode.null
                inputObj
    , is =
        \inputObj ->
            GraphQL.InputObject.addField
                "is"
                "FilterIs"
                Json.Encode.null
                inputObj
    , like =
        \inputObj ->
            GraphQL.InputObject.addField
                "like"
                "String"
                Json.Encode.null
                inputObj
    , lt =
        \inputObj ->
            GraphQL.InputObject.addField "lt" "String" Json.Encode.null inputObj
    , lte =
        \inputObj ->
            GraphQL.InputObject.addField
                "lte"
                "String"
                Json.Encode.null
                inputObj
    , neq =
        \inputObj ->
            GraphQL.InputObject.addField
                "neq"
                "String"
                Json.Encode.null
                inputObj
    , regex =
        \inputObj ->
            GraphQL.InputObject.addField
                "regex"
                "String"
                Json.Encode.null
                inputObj
    , startsWith =
        \inputObj ->
            GraphQL.InputObject.addField
                "startsWith"
                "String"
                Json.Encode.null
                inputObj
    }


{-| This is a rarely needed function and it is unlikely that you will need this.

It may be useful in edge cases where you need to do mocking/simulation of your queries within your app (tests shouldn't need this).
-}
decoder : Json.Decode.Decoder StringFilter
decoder =
    Json.Decode.map
        (\mapUnpack ->
             GraphQL.InputObject.raw
                 "StringFilter"
                 (List.map
                      (\mapUnpack0 ->
                           ( mapUnpack0.name
                           , { gqlTypeName = mapUnpack0.type_
                             , value = Dict.get mapUnpack0.name mapUnpack
                             }
                           )
                      )
                      [ { name = "eq", type_ = "String" }
                      , { name = "gt", type_ = "String" }
                      , { name = "gte", type_ = "String" }
                      , { name = "ilike", type_ = "String" }
                      , { name = "in", type_ = "[String!]" }
                      , { name = "iregex", type_ = "String" }
                      , { name = "is", type_ = "FilterIs" }
                      , { name = "like", type_ = "String" }
                      , { name = "lt", type_ = "String" }
                      , { name = "lte", type_ = "String" }
                      , { name = "neq", type_ = "String" }
                      , { name = "regex", type_ = "String" }
                      , { name = "startsWith", type_ = "String" }
                      ]
                 )
        )
        (Json.Decode.dict Json.Decode.value)