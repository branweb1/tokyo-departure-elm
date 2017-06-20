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
    , imageAttribution : Maybe ImageAttribution
    }


type alias ImageAttribution =
    { author : String
    , url : String
    , license : String
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
      , imageAttribution = Nothing
      }
    , { melody = Ebisu
      , displayName = "Ebisu"
      , id = 1
      , blurb = Just "ebisu.md"
      , image = Just "ebisu_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Spring
      , displayName = "Yoyogi"
      , id = 2
      , blurb = Just "yoyogi.md"
      , image = Just "yoyogi_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Harajuku
      , displayName = "Harajuku"
      , id = 3
      , blurb = Just "harajuku.md"
      , image = Just "harajuku_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = SH3
      , displayName = "Tokyo"
      , id = 4
      , blurb = Just "tokyo.md"
      , image = Just "tokyo_800.jpg"
      , imageAttribution =
            Just
                { author = "mjrtom999"
                , url = "https://www.flickr.com/photos/mjrtom999/12385435164/in/photolist-jSsAnA-46Qy7c-aqHt6p-fyDuT2-nmarQu-5HoQqC-T1rhHr-ioabjg-ddiE43-b4Nydp-2Tk1w-pHtGnH-oYEidV-7AoJ5E-2YKczD-d5U22f-nCy79C-mLKj6d-etbGMH-dosTZ5-NAYrb-2iyr8K-6XuaVt-6pXsV7-dopWBg-5BwVes-dNb6z2-5kwzS5-pHtG72-pdBrVi-doq5oy-8pmhsK-9rtfEP-kmWHoM-jSr9XP-2YKczZ-5kwAH7-deYjDp-nsL5Kv-kyiEL-CPw6ST-and4ry-mNjVEB-nb6AJS-HuoEwQ-aE3gx4-fbmNGQ-b57JwX-8GeKZ2-y8UwVp"
                , license = "Creative Commons"
                }
      }
    , { melody = Babble
      , displayName = "Mejiro"
      , id = 5
      , blurb = Nothing
      , image = Just "mejiro_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Babble
      , displayName = "Kanda"
      , id = 6
      , blurb = Nothing
      , image = Just "kanda_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = CieloEstrellado
      , displayName = "Gotanda"
      , id = 7
      , blurb = Nothing
      , image = Just "gotanda_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = BellB
      , displayName = "Ueno"
      , id = 8
      , blurb = Just "ueno.md"
      , image = Just "ueno_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = BabblingBrook
      , displayName = "Akihabara"
      , id = 9
      , blurb = Just "akihabara.md"
      , image = Just "akihabara_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Twilight
      , displayName = "Shinjuku"
      , id = 10
      , blurb = Just "shinjuku.md"
      , image = Just "shinjuku_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = WaterCrown
      , displayName = "Meguro"
      , id = 11
      , blurb = Nothing
      , image = Just "meguro_800.jpg"
      , imageAttribution =
            Just
                { author = "ykanazawa1999"
                , url = "https://www.flickr.com/photos/27889738@N07/3820153281/in/photolist-6PzhtK-aTtZLa-p3xGx-dCgJmq-aTtPcg-7JR5S5-oXokrP-5J5Mi1-9fXWsD-8RMPyA-825Bfo-5rvVBk-p3xGy-4HLR4M-9g22ZN-9g23dC-5yPB4p-cuqpPd-5yo7Z1-diKL8A-8RMTYC-c3LwR-i6z2a7-pMDd-daGZ8j-5s2irK-jRDehK-8RMU2o-9fXUtP-4KSTCm-95CGRt-aTtPcr-K9DFHY-5s2iuK-9bMUdE-8RJLNF-m2U6aH-aiQcR-adTptm-bJKjGV-bJKs8H-bJKjGv-bvR395-bvR39y-bvR38Y-bJKjGD-bJKE4g-bvRefq-bJKjHt-bvR39E"
                , license = "Creative Commons"
                }
      }
    , { melody = SF1
      , displayName = "Osaki"
      , id = 12
      , blurb = Nothing
      , image = Just "osaki_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = JRMelody
      , displayName = "Ikebukuro"
      , id = 13
      , blurb = Just "ikebukuro.md"
      , image = Just "ikebukuro_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = FrayingFlowers
      , displayName = "Shibuya"
      , id = 14
      , blurb = Just "shibuya.md"
      , image = Just "shibuya_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Babble
      , displayName = "Shinagawa"
      , id = 15
      , blurb = Just "shinagawa.md"
      , image = Just "shinagawa_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = GotaDelVient
      , displayName = "Shimbashi"
      , id = 16
      , blurb = Just "shimbashi.md"
      , image = Just "shimbashi_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = SH21
      , displayName = "Yūracuchō"
      , id = 17
      , blurb = Nothing
      , image = Just "yuracucho_800.jpg"
      , imageAttribution = Nothing
      }
    , { melody = Sakura
      , displayName = "Komagome"
      , id = 18
      , blurb = Just "komagome.md"
      , image = Just "komagome_800.jpg"
      , imageAttribution = Nothing
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


initialModel : Route -> Maybe Station -> Model
initialModel route currentStation =
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
