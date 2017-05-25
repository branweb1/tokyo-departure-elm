module Helpers exposing (..)

import Json.Decode as Decode
import Char
import Model exposing (Melody(..), Progress)
import Messages exposing (Msg(SetProgress, SetEnded, NoOp))


melodyToFile : Melody -> String
melodyToFile melody =
    case melody of
        AstroBoyV2 ->
            "astro_boy_v2.mp3"

        Ebisu ->
            "ebisu.mp3"

        Harajuku ->
            "harajuku_a.mp3"

        SH3 ->
            "sh-3.mp3"

        Babble ->
            "babble.mp3"

        CieloEstrellado ->
            "cielo_estrellado.mp3"


decodeResponse json =
    case Decode.decodeValue progressDecoder json of
        Ok resp ->
            if isNaN resp.total || isNaN resp.elapsed then
                SetProgress { elapsed = 0.0, total = 0.0 }
            else
                SetProgress resp

        Err err ->
            NoOp


progressDecoder =
    Decode.map2 Progress
        (Decode.field "elapsed" Decode.float)
        (Decode.field "total" Decode.float)


decodedEndedResponse json =
    case Decode.decodeValue endedDecoder json of
        Ok resp ->
            SetEnded

        Err err ->
            NoOp


endedDecoder =
    Decode.map identity
        (Decode.field "ended" Decode.bool)


validateQuery : String -> Result String String
validateQuery query =
    let
        isLetter a =
            Char.isUpper a || Char.isLower a
    in
        case String.all isLetter query of
            True ->
                Ok query

            False ->
                Err "Search can only contain letters"
