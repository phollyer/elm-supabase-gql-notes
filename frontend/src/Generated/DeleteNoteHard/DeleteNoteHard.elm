module DeleteNoteHard.DeleteNoteHard exposing (DeleteFromNotesCollection, Input, Response, mutation)

{-|
This file is generated from ../supabase/queries/deleteNoteHard.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs mutation

@docs DeleteFromNotesCollection


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
        (Just "DeleteNoteHard")
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
    { affectedCount : Int }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response |> GraphQL.Decode.versionedField
                                            version_
                                            "deleteFromNotesCollection"
                                            (Json.Decode.succeed
                                                     DeleteFromNotesCollection |> GraphQL.Decode.field
                                                                                              "affectedCount"
                                                                                              Json.Decode.int
                                            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((GraphQL.Engine.versionedAlias
          version_
          "deleteFromNotesCollection" ++ " (filter: {id: {eq: "
     ) ++ GraphQL.Engine.versionedName version_ "$id"
    ) ++ "}}, atMost: 1) {affectedCount }"


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []