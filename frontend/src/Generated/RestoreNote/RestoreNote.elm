module RestoreNote.RestoreNote exposing (Input, Response, UpdateNotesCollection, mutation)

{-|
This file is generated from ../supabase/queries/restoreNote.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs UpdateNotesCollection


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
    { id : Api.Uuid, deletedAt : Api.Option Api.Datetime }


mutation : Input -> Api.Mutation Response
mutation args =
    GraphQL.Engine.operation
        (Just "RestoreNote")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addOptionalField
                                             "deletedAt"
                                             "Datetime"
                                             args.deletedAt
                                             Api.datetime.encode |> GraphQL.InputObject.addField
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
    { updateNotesCollection : UpdateNotesCollection }


type alias UpdateNotesCollection =
    { affectedCount : Int }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response |> GraphQL.Decode.versionedField
                                            version_
                                            "updateNotesCollection"
                                            (Json.Decode.succeed
                                                     UpdateNotesCollection |> GraphQL.Decode.field
                                                                                          "affectedCount"
                                                                                          Json.Decode.int
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((((GraphQL.Engine.versionedAlias
            version_
            "updateNotesCollection" ++ " (set: {deletedAt: "
       ) ++ GraphQL.Engine.versionedName version_ "$deletedAt"
      ) ++ "}, filter: {id: {eq: "
     ) ++ GraphQL.Engine.versionedName version_ "$id"
    ) ++ "}}, atMost: 1) {affectedCount }"


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []