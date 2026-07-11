module Api.Enum.FilterIs exposing (FilterIs(..), all, decoder, encode)

{-|

This file wass generated using `elm-gql`

Please avoid modifying directly.


@docs FilterIs, all, decoder, encode


-}


import Json.Decode
import Json.Encode


type FilterIs
    = NULL
    | NOT_NULL


all : List FilterIs
all =
    [ NULL, NOT_NULL ]


decoder : Json.Decode.Decoder FilterIs
decoder =
    Json.Decode.andThen
        (\andThenUnpack ->
             case andThenUnpack of
                 "NULL" ->
                     Json.Decode.succeed NULL

                 "NOT_NULL" ->
                     Json.Decode.succeed NOT_NULL

                 _ ->
                     Json.Decode.fail "Invalid type"
        )
        Json.Decode.string


encode : FilterIs -> Json.Encode.Value
encode val =
    case val of
        NULL ->
            Json.Encode.string "NULL"

        NOT_NULL ->
            Json.Encode.string "NOT_NULL"