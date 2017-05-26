port module Commands exposing (..)

import Json.Decode as Decode


port playAudio : () -> Cmd msg


port pauseAudio : () -> Cmd msg


port trackProgress : () -> Cmd msg


port trackEnded : () -> Cmd msg


port progress : (Decode.Value -> msg) -> Sub msg


port ended : (Decode.Value -> msg) -> Sub msg


port reset : () -> Cmd msg