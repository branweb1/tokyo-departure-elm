module Model exposing (..)

import Routing exposing (Route(..))


type alias Model =
    { stations : List Station
    , orphanedMelodies : List MiscSound
    , stationSounds : List MiscSound
    , currentStation : Maybe Station
    , details : PlayerDetails
    , query : String
    , errorMsg : Maybe String
    , route : Route
    , blurb : Maybe String
    }


type alias NowPlayingId =
    Int


type PlayStatus
    = Playing
    | Paused
    | Ended
    | Unstarted


type alias Progress =
    { elapsed : Float, total : Float }


type PlayerDetails
    = NoDetails
    | Details NowPlayingId Progress PlayStatus


type Melody
    = AstroBoyV2
    | Ebisu
    | Harajuku
    | SH3
    | Babble
    | CieloEstrellado
    | BellB
    | BabblingBrook
    | Twilight
    | WaterCrown
    | SF1
    | Spring
    | JRMelody
    | FrayingFlowers
    | GotaDelVient
    | SH21
    | Sakura
    | Airly
    | AstroBoyReggae
    | SH1
    | SH52
    | TR4
    | TR11
    | TR2
    | Notification
    | Notifcation2
    | DoorChime
    | DoorChime2
    | Brakes


type alias Station =
    { melody : Melody
    , displayName : String
    , id : Int
    , blurb : Maybe String
    , image : Maybe String
    }


type alias MiscSound =
    { melody : Melody
    , displayName : String
    , id : Int
    }


stations : List Station
stations =
    [ { melody = AstroBoyV2
      , displayName = "Takada-no-Baba"
      , id = 0
      , blurb = Just "takada-no-baba.md"
      , image = Just "takada-no-baba-astro-boy_800.jpg"
      }
    , { melody = Ebisu
      , displayName = "Ebisu"
      , id = 1
      , blurb = Just "ebisu.md"
      , image = Just "ebisu_800.jpg"
      }
    , { melody = Spring
      , displayName = "Yoyogi"
      , id = 2
      , blurb = Just "yoyogi.md"
      , image = Just "yoyogi_800.jpg"
      }
    , { melody = Harajuku
      , displayName = "Harajuku"
      , id = 3
      , blurb = Just "harajuku.md"
      , image = Just "harajuku_800.jpg"
      }
    , { melody = SH3
      , displayName = "Tokyo"
      , id = 4
      , blurb = Just "tokyo.md"
      , image = Just "tokyo_800.jpg"
      }
    , { melody = Babble
      , displayName = "Mejiro"
      , id = 5
      , blurb = Nothing
      , image = Just "mejiro_800.jpg"
      }
    , { melody = Babble
      , displayName = "Kanda"
      , id = 6
      , blurb = Nothing
      , image = Just "kanda_800.jpg"
      }
    , { melody = CieloEstrellado
      , displayName = "Gotanda"
      , id = 7
      , blurb = Nothing
      , image = Just "gotanda_800.jpg"
      }
    , { melody = BellB
      , displayName = "Ueno"
      , id = 8
      , blurb = Just "ueno.md"
      , image = Just "ueno_800.jpg"
      }
    , { melody = BabblingBrook
      , displayName = "Akihabara"
      , id = 9
      , blurb = Just "akihabara.md"
      , image = Just "akihabara_800.jpg"
      }
    , { melody = Twilight
      , displayName = "Shinjuku"
      , id = 10
      , blurb = Just "shinjuku.md"
      , image = Just "shinjuku_800.jpg"
      }
    , { melody = WaterCrown
      , displayName = "Meguro"
      , id = 11
      , blurb = Nothing
      , image = Just "meguro_800.jpg"
      }
    , { melody = SF1
      , displayName = "Osaki"
      , id = 12
      , blurb = Nothing
      , image = Just "osaki_800.jpg"
      }
    , { melody = JRMelody
      , displayName = "Ikebukuro"
      , id = 13
      , blurb = Just "ikebukuro.md"
      , image = Just "ikebukuro_800.jpg"
      }
    , { melody = FrayingFlowers
      , displayName = "Shibuya"
      , id = 14
      , blurb = Just "shibuya.md"
      , image = Just "shibuya_800.jpg"
      }
    , { melody = Babble
      , displayName = "Shinagawa"
      , id = 15
      , blurb = Just "shinagawa.md"
      , image = Just "shinagawa_800.jpg"
      }
    , { melody = GotaDelVient
      , displayName = "Shimbashi"
      , id = 16
      , blurb = Just "shimbashi.md"
      , image = Just "shimbashi_800.jpg"
      }
    , { melody = SH21
      , displayName = "Yūracuchō"
      , id = 17
      , blurb = Nothing
      , image = Just "yuracucho_800.jpg"
      }
    , { melody = Sakura
      , displayName = "Komagome"
      , id = 18
      , blurb = Just "komagome.md"
      , image = Just "komagome_800.jpg"
      }
    ]


orphanedMelodies : List MiscSound
orphanedMelodies =
    [ { id = 0
      , melody = Airly
      , displayName = "Airly"
      }
    , { id = 1
      , melody = AstroBoyReggae
      , displayName = "Astro Boy Reggae Theme"
      }
    , { id = 2
      , melody = SH1
      , displayName = "SH1"
      }
    , { id = 3
      , melody = SH52
      , displayName = "SH5-2"
      }
    , { id = 4
      , melody = TR4
      , displayName = "TR4"
      }
    , { id = 5
      , melody = TR11
      , displayName = "TR11"
      }
    , { id = 6
      , melody = TR2
      , displayName = "TR2"
      }
    ]


stationSounds : List MiscSound
stationSounds =
    [ { id = 0
      , melody = Notification
      , displayName = "Station Notification"
      }
    , { id = 1
      , melody = Notifcation2
      , displayName = "Station Notification 2"
      }
    , { id = 2
      , melody = DoorChime
      , displayName = "Door Chime"
      }
    , { id = 3
      , melody = DoorChime2
      , displayName = "Door Chime 2"
      }
    , { id = 4
      , melody = Brakes
      , displayName = "Brakes"
      }
    ]


getCurrentStation : Int -> Maybe Station
getCurrentStation id =
    List.filter (\a -> a.id == id) stations
        |> List.head


initialModel : Route -> Model
initialModel route =
    let
        currentStation =
            case route of
                StationDetails stationId ->
                    Result.toMaybe (String.toInt stationId)
                        |> Maybe.andThen getCurrentStation

                _ ->
                    Nothing
    in
        { stations = stations
        , orphanedMelodies = orphanedMelodies
        , stationSounds = stationSounds
        , currentStation = currentStation
        , details = NoDetails
        , query = ""
        , errorMsg = Nothing
        , route = route
        , blurb = Nothing
        }
