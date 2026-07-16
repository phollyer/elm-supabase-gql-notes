module DeleteNote.DeleteNote exposing (DeleteFromNotesCollection, Input, Records, Response, mutation)

{-|
This file is generated from ../supabase/queries/deleteNote.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs DeleteFromNotesCollection, Records


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias Input =
    { id : Api.Uuid }


mutation : Input -> Api.Mutation Response
mutation args =
    GraphQL.Engine.operation
        (Just "DeleteNote")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addField
                                             "id"
                                             "UUID!"
                                             (Api.uuid.encode args.id)
                     )
             , body = toPayload_ version_
             , fragments = toFragments_ version_
             }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { deleteFromNotesCollection : DeleteFromNotesCollection }


type alias DeleteFromNotesCollection =
    { records : List Records }


type alias Records =
    { id : Api.Uuid
    , title : String
    , body : String
    , createdAt : Api.Datetime
    , updatedAt : Api.Datetime
    }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response |> GraphQL.Decode.versionedField
                                            version_
                                            "deleteFromNotesCollection"
                                            (Json.Decode.succeed
                                                     DeleteFromNotesCollection |> GraphQL.Decode.field
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
                                                                                                                                                                                                                                                                                                           Api.datetime.decoder
                                                                                                           )
                                                                                              )
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((GraphQL.Engine.versionedAlias
          version_
          "deleteFromNotesCollection" ++ " (filter: {id: {eq: "
     ) ++ GraphQL.Engine.versionedName version_ "$id"
    ) ++ """}}, atMost: 1) {records {id
title
body
createdAt
updatedAt } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []