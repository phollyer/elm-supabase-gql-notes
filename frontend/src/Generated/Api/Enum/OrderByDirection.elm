module Api.Enum.OrderByDirection exposing (OrderByDirection(..), all, decoder, encode)

{-|

This file wass generated using `elm-gql`

Please avoid modifying directly.


@docs OrderByDirection, all, decoder, encode


-}


import Json.Decode
import Json.Encode


type OrderByDirection
    = AscNullsFirst
    | AscNullsLast
    | DescNullsFirst
    | DescNullsLast


all : List OrderByDirection
all =
    [ AscNullsFirst, AscNullsLast, DescNullsFirst, DescNullsLast ]


decoder : Json.Decode.Decoder OrderByDirection
decoder =
    Json.Decode.andThen
        (\andThenUnpack ->
             case andThenUnpack of
                 "AscNullsFirst" ->
                     Json.Decode.succeed AscNullsFirst

                 "AscNullsLast" ->
                     Json.Decode.succeed AscNullsLast

                 "DescNullsFirst" ->
                     Json.Decode.succeed DescNullsFirst

                 "DescNullsLast" ->
                     Json.Decode.succeed DescNullsLast

                 _ ->
                     Json.Decode.fail "Invalid type"
        )
        Json.Decode.string


encode : OrderByDirection -> Json.Encode.Value
encode val =
    case val of
        AscNullsFirst ->
            Json.Encode.string "AscNullsFirst"

        AscNullsLast ->
            Json.Encode.string "AscNullsLast"

        DescNullsFirst ->
            Json.Encode.string "DescNullsFirst"

        DescNullsLast ->
            Json.Encode.string "DescNullsLast"