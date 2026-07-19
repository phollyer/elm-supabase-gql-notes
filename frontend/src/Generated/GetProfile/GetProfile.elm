module GetProfile.GetProfile exposing
    ( Input
    , Response
    , query
    , ProfilesByPk
    )

{-| This file is generated from ../supabase/queries/getProfile.gql using `elm-gql`

Please avoid modifying directly.

@docs Input

@docs Response

@docs query

@docs ProfilesByPk

-}

import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias Input =
    { id : Api.Uuid }


query : Input -> Api.Query Response
query args =
    GraphQL.Engine.operation
        (Just "GetProfile")
        (\version_ ->
            { args =
                GraphQL.InputObject.toFieldList
                    (GraphQL.InputObject.inputObject
                        "Input"
                        |> GraphQL.InputObject.addField
                            "id"
                            "UUID!"
                            (Api.uuid.encode args.id)
                    )
            , body = toPayload_ version_
            , fragments = toFragments_ version_
            }
        )
        decoder_



{- Return data -}


type alias Response =
    { profilesByPk : Maybe ProfilesByPk }


type alias ProfilesByPk =
    { id : Api.Uuid
    , email : String
    , displayName : Maybe String
    , avatarPath : Maybe String
    , createdAt : Api.Datetime
    , updatedAt : Api.Datetime
    }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response
        |> GraphQL.Decode.versionedField
            version_
            "profilesByPk"
            (Json.Decode.nullable
                (Json.Decode.succeed
                    ProfilesByPk
                    |> GraphQL.Decode.field
                        "id"
                        Api.uuid.decoder
                    |> GraphQL.Decode.field
                        "email"
                        Json.Decode.string
                    |> GraphQL.Decode.field
                        "displayName"
                        (Json.Decode.nullable
                            Json.Decode.string
                        )
                    |> GraphQL.Decode.field
                        "avatarPath"
                        (Json.Decode.nullable
                            Json.Decode.string
                        )
                    |> GraphQL.Decode.field
                        "createdAt"
                        Api.datetime.decoder
                    |> GraphQL.Decode.field
                        "updatedAt"
                        Api.datetime.decoder
                )
            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((GraphQL.Engine.versionedAlias version_ "profilesByPk" ++ " (id: ")
        ++ GraphQL.Engine.versionedName version_ "$id"
    )
        ++ """) {id
email
displayName
avatarPath
createdAt
updatedAt }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []
