module UpdateProfileAvatar.UpdateProfileAvatar exposing (Input, Response, UpdateProfilesCollection, mutation)

{-|
This file is generated from ../supabase/queries/updateProfileAvatar.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs UpdateProfilesCollection


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


{-| This input has optional args, which are wrapped in `Api.Option`.

First up, if it makes sense, you can make this argument required in your graphql query
by adding ! to that variable definition at the top of the query.  This will make it easier to handle in Elm.

If the field is truly optional, here's how to wrap it.

    - Api.present myValue -- this field should be myValue
    - Api.absent -- do not include this field at all in the GraphQL
    - Api.null -- include this field as a null value.  Not as common as .absent.
-}
type alias Input =
    { id : Api.Uuid, avatarPath : Api.Option String }


mutation : Input -> Api.Mutation Response
mutation args =
    GraphQL.Engine.operation
        (Just "UpdateProfileAvatar")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addOptionalField
                                             "avatarPath"
                                             "String"
                                             args.avatarPath
                                             Json.Encode.string |> GraphQL.InputObject.addField
                                                                           "id"
                                                                           "UUID!"
                                                                           (Api.uuid.encode
                                                                                    args.id
                                                                           )
                     )
             , body = toPayload_ version_
             , fragments = toFragments_ version_
             }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { updateProfilesCollection : UpdateProfilesCollection }


type alias UpdateProfilesCollection =
    { affectedCount : Int }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response |> GraphQL.Decode.versionedField
                                            version_
                                            "updateProfilesCollection"
                                            (Json.Decode.succeed
                                                     UpdateProfilesCollection |> GraphQL.Decode.field
                                                                                             "affectedCount"
                                                                                             Json.Decode.int
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((((GraphQL.Engine.versionedAlias
            version_
            "updateProfilesCollection" ++ " (set: {avatarPath: "
       ) ++ GraphQL.Engine.versionedName version_ "$avatarPath"
      ) ++ "}, filter: {id: {eq: "
     ) ++ GraphQL.Engine.versionedName version_ "$id"
    ) ++ "}}, atMost: 1) {affectedCount }"


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []