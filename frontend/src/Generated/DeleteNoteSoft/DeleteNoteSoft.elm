module DeleteNoteSoft.DeleteNoteSoft exposing (Input, Records, Response, UpdateNotesCollection, mutation)

{-|
This file is generated from ../supabase/queries/deleteNoteSoft.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs UpdateNotesCollection, Records


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias Input =
    { id : Api.Uuid, deletedAt : Api.Datetime }


mutation : Input -> Api.Mutation Response
mutation args =
    GraphQL.Engine.operation
        (Just "DeleteNoteSoft")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addField
                                             "deletedAt"
                                             "Datetime!"
                                             (Api.datetime.encode args.deletedAt
                                             ) |> GraphQL.InputObject.addField
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
    { records : List Records }


type alias Records =
    { id : Api.Uuid
    , title : String
    , body : String
    , createdAt : Api.Datetime
    , updatedAt : Api.Datetime
    , deletedAt : Maybe Api.Datetime
    }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response |> GraphQL.Decode.versionedField
                                            version_
                                            "updateNotesCollection"
                                            (Json.Decode.succeed
                                                     UpdateNotesCollection |> GraphQL.Decode.field
                                                                                          "records"
                                                                                          (Json.Decode.list
                                                                                                       (Json.Decode.succeed
                                                                                                                    Records |> GraphQL.Decode.field
                                                                                                                                               "id"
                                                                                                                                               Api.uuid.decoder |> GraphQL.Decode.field
                                                                                                                                                                                   "title"
                                                                                                                                                                                   Json.Decode.string |> GraphQL.Decode.field
                                                                                                                                                                                                                         "body"
                                                                                                                                                                                                                         Json.Decode.string |> GraphQL.Decode.field
                                                                                                                                                                                                                                                               "createdAt"
                                                                                                                                                                                                                                                               Api.datetime.decoder |> GraphQL.Decode.field
                                                                                                                                                                                                                                                                                                       "updatedAt"
                                                                                                                                                                                                                                                                                                       Api.datetime.decoder |> GraphQL.Decode.field
                                                                                                                                                                                                                                                                                                                                               "deletedAt"
                                                                                                                                                                                                                                                                                                                                               (Json.Decode.nullable
                                                                                                                                                                                                                                                                                                                                                                Api.datetime.decoder
                                                                                                                                                                                                                                                                                                                                               )
                                                                                                       )
                                                                                          )
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((((GraphQL.Engine.versionedAlias
            version_
            "updateNotesCollection" ++ " (set: {deletedAt: "
       ) ++ GraphQL.Engine.versionedName version_ "$deletedAt"
      ) ++ "}, filter: {id: {eq: "
     ) ++ GraphQL.Engine.versionedName version_ "$id"
    ) ++ """}}, atMost: 1) {records {id
title
body
createdAt
updatedAt
deletedAt } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []