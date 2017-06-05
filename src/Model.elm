module Model exposing (..)

import Routing exposing (Route)


type alias Model =
    { stations : List Station
    , progress : Progress
    , playStatus : PlayStatus
    , query : String
    , errorMsg : Maybe String
    , route : Route
    , blurb : Maybe String
    }


type PlayStatus
    = Playing
    | Paused
    | Ended
    | Unstarted


type alias Progress =
    { elapsed : Float, total : Float }


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


type alias Station =
    { melody : Melody
    , displayName : String
    , id : Int
    , blurb : Maybe String
    , image : Maybe String
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
      , image = Nothing
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
      , blurb = Nothing
      , image = Nothing
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
      , image = Nothing
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
      , blurb = Nothing
      , image = Nothing
      }
    , { melody = GotaDelVient
      , displayName = "Shimbashi"
      , id = 16
      , blurb = Nothing
      , image = Nothing
      }
    , { melody = SH21
      , displayName = "Yūracuchō"
      , id = 17
      , blurb = Nothing
      , image = Nothing
      }
    , { melody = Sakura
      , displayName = "Komagome"
      , id = 18
      , blurb = Just "komagome.md"
      , image = Just "komagome_800.jpg"
      }
    ]


initialModel : Route -> Model
initialModel route =
    { stations = stations
    , progress = { elapsed = 0.0, total = 0.0 }
    , playStatus = Unstarted
    , query = ""
    , errorMsg = Nothing
    , route = route
    , blurb = Nothing
    }
