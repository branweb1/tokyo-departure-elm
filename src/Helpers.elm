module Helpers exposing (..)

import Json.Decode as Decode
import Char
import Model exposing (Melody(..), Progress, Station)
import Messages exposing (Msg(SetProgress, SetEnded, NoOp, SetBlurb))


getById : List Station -> Int -> Maybe Station
getById list id =
    List.filter (\item -> item.id == id) list
        |> List.head


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

        GotaDelVient ->
            "gota_del_vient.mp3"

        SH21 ->
            "sh-2-1.mp3"

        Sakura ->
            "sakura.mp3"

        Airly ->
            "airly.mp3"

        AstroBoyReggae ->
            "astro_boy_v4.mp3"

        SH1 ->
            "sh-1.mp3"

        SH52 ->
            "sh-5-2.mp3"

        TR4 ->
            "tr4.mp3"

        TR11 ->
            "tr11.mp3"

        TR2 ->
            "tr2.mp3"

        Notification ->
            "station_notification.mp3"

        Notifcation2 ->
            "station_notification_2.mp3"

        DoorChime ->
            "ddg_nds_e231_door_chime.mp3"

        DoorChime2 ->
            "ddg_ss_atc_kincon.mp3"

        Brakes ->
            "ddg_ios_brake.mp3"


decodeResponse json =
    case Decode.decodeValue progressDecoder json of
        Ok progress ->
            if isNaN progress.total || isNaN progress.elapsed then
                SetProgress { elapsed = 0.0, total = 0.0 }
            else
                SetProgress progress

        Err err ->
            NoOp


progressDecoder =
    Decode.map2 Progress
        (Decode.field "elapsed" Decode.float)
        (Decode.field "total" Decode.float)


decodedEndedResponse json =
    case Decode.decodeValue (Decode.field "ended" Decode.bool) json of
        Ok _ ->
            SetEnded

        Err err ->
            NoOp


endedDecoder =
    Decode.map2 (,)
        (Decode.field "id" Decode.int)
        (Decode.field "ended" Decode.bool)


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
                Err "Letters only please"
