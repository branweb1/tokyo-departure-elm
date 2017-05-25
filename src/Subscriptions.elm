module Subscriptions exposing (..)

import Model exposing (Model)
import Helpers exposing (decodeResponse, decodedEndedResponse)
import Commands exposing (ended, progress)
import Messages exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ progress decodeResponse
        , ended decodedEndedResponse
        ]
