module Helpers exposing (..)

import Json.Decode as Decode
import Char
import Model exposing (Melody(..), Progress)
import Messages exposing (Msg(SetProgress, SetEnded, NoOp, SetBlurb))


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

        BellB ->
            "bell_b.mp3"

        BabblingBrook ->
            "babbling_brook_v2.mp3"

        Twilight ->
            "twilight.mp3"

        WaterCrown ->
            "water_crown.mp3"

        SF1 ->
            "sf-1.mp3"

        Spring ->
            "spring.mp3"

        JRMelody ->
            "melody.mp3"

        FrayingFlowers ->
            "fraying_of_flowers_v2.mp3"


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
    case Decode.decodeValue (Decode.field "ended" Decode.bool) json of
        Ok resp ->
            SetEnded

        Err err ->
            NoOp


decodeMarkdownFile str =
    case Decode.decodeValue Decode.string str of
        Ok text ->
            SetBlurb (Just text)

        Err err ->
            SetBlurb (Nothing)


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
