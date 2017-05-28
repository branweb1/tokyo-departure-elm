module Subscriptions exposing (..)

import Model exposing (Model)
import Helpers exposing (decodeResponse, decodedEndedResponse, decodeMarkdownFile)
import Commands exposing (ended, progress, receiveMarkdownFile)
import Messages exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ progress decodeResponse
        , ended decodedEndedResponse
        , receiveMarkdownFile decodeMarkdownFile
        ]
