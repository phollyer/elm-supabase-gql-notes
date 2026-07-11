module SearchNotes.SearchNotes exposing
    ( Edges
    , Input
    , Node
    , NotesCollection
    , Response
    , query
    )

{-|
This file is generated from ../supabase/queries/searchNotes.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs query

@docs NotesCollection, Edges, Node


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias Input =
    { query : String }


query : Input -> Api.Query Response
query args =
    GraphQL.Engine.operation
        (Just "SearchNotes")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addField
                                             "query"
                                             "String!"
                                             (Json.Encode.string args.query)
                     )
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
                                                                                                                                                                                                                                                                                                                                                            Api.datetime.decoder
                                                                                                                                       )
                                                                                                 )
                                                                                    )
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((((GraphQL.Engine.versionedAlias
            version_
            "notesCollection" ++ " (filter: {or: [{title: {ilike: "
       ) ++ GraphQL.Engine.versionedName version_ "$query"
      ) ++ "}}, {body: {ilike: "
     ) ++ GraphQL.Engine.versionedName version_ "$query"
    ) ++ """}}]}, orderBy: [{createdAt: DescNullsLast}]) {edges {node {id
title
body
createdAt
updatedAt } } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []