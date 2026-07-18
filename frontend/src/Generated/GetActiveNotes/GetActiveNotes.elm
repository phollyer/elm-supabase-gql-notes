module GetActiveNotes.GetActiveNotes exposing (Edges, Node, NotesCollection, Response, query)

{-|
This file is generated from ../supabase/queries/getActiveNotes.gql using `elm-gql`

Please avoid modifying directly.


@docs Response

@docs query

@docs NotesCollection, Edges, Node


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import Json.Decode


query : Api.Query Response
query =
    GraphQL.Engine.operation
        (Just "GetActiveNotes")
        (\version_ ->
             { args = []
             , body = toPayload_ version_
             , fragments = toFragments_ version_
             }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { notesCollection : NotesCollection }


type alias NotesCollection =
    { edges : List Edges }


type alias Edges =
    { node : Node }


type alias Node =
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
                                            "notesCollection"
                                            (Json.Decode.succeed
                                                     NotesCollection |> GraphQL.Decode.field
                                                                                    "edges"
                                                                                    (Json.Decode.list
                                                                                                 (Json.Decode.succeed
                                                                                                              Edges |> GraphQL.Decode.field
                                                                                                                                       "node"
                                                                                                                                       (Json.Decode.succeed
                                                                                                                                                        Node |> GraphQL.Decode.field
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
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    GraphQL.Engine.versionedAlias
        version_
        "notesCollection" ++ """ (filter: {deletedAt: {is: NULL}}, orderBy: [{createdAt: DescNullsLast}]) {edges {node {id
title
body
createdAt
updatedAt
deletedAt } } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []