module CreateNote.CreateNote exposing (Input, InsertIntoNotesCollection, Records, Response, mutation)

{-|
This file is generated from ../supabase/queries/createNote.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs InsertIntoNotesCollection, Records


-}


import Api
import GraphQL.Decode
import GraphQL.Engine
import GraphQL.InputObject
import Json.Decode
import Json.Encode


type alias Input =
    { userId : Api.Uuid, title : String, body : String }


mutation : Input -> Api.Mutation Response
mutation args =
    GraphQL.Engine.operation
        (Just "CreateNote")
        (\version_ ->
             { args =
                 GraphQL.InputObject.toFieldList
                     (GraphQL.InputObject.inputObject
                          "Input" |> GraphQL.InputObject.addField
                                             "body"
                                             "String!"
                                             (Json.Encode.string args.body
                                             ) |> GraphQL.InputObject.addField
                                                          "title"
                                                          "String!"
                                                          (Json.Encode.string
                                                                   args.title
                                                          ) |> GraphQL.InputObject.addField
                                                                       "userId"
                                                                       "UUID!"
                                                                       (Api.uuid.encode
                                                                                args.userId
                                                                       )
                     )
             , body = toPayload_ version_
             , fragments = toFragments_ version_
             }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { insertIntoNotesCollection : Maybe InsertIntoNotesCollection }


type alias InsertIntoNotesCollection =
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
                                            "insertIntoNotesCollection"
                                            (Json.Decode.nullable
                                                     (Json.Decode.succeed
                                                              InsertIntoNotesCollection |> GraphQL.Decode.field
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
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((((((GraphQL.Engine.versionedAlias
              version_
              "insertIntoNotesCollection" ++ " (objects: [{userId: "
         ) ++ GraphQL.Engine.versionedName version_ "$userId"
        ) ++ ", title: "
       ) ++ GraphQL.Engine.versionedName version_ "$title"
      ) ++ ", body: "
     ) ++ GraphQL.Engine.versionedName version_ "$body"
    ) ++ """}]) {records {id
title
body
createdAt
updatedAt } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []