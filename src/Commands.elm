port module Commands exposing (..)

import Json.Decode as Decode


port playAudio : Int -> Cmd msg


port pauseAudio : () -> Cmd msg


port trackProgress : () -> Cmd msg


port trackEnded : () -> Cmd msg


port progress : (Decode.Value -> msg) -> Sub msg


port ended : (Decode.Value -> msg) -> Sub msg


port reset : () -> Cmd msg


port loadMarkdownFile : String -> Cmd msg


port receiveMarkdownFile : (Decode.Value -> msg) -> Sub msg
