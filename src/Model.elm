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
      , imageAttribution =
            Just
                { author = "ajpscs"
                , url = "https://www.flickr.com/photos/ajpscs/8514440882/in/photolist-dYoJCS-7d5MXE-6hgq7U-pWs7E-qeML7H-UJvfn7-xLiDq-dHWwWH-C3Y4LB-mb2UsM-9xKBVU-6gGQ1s-7ZhjXW-ztw7Y-RErvzG-9yuLan-fruXiq-t1X7g-mb29Ye-UHAtmW-bny3io-7b8rGU-8NFVhP-f6ny2H-9z1DWv-9GdFez-iBD8aN-e4Smqa-8Wehn-jUyJFV-dPAvHv-7bx48F-pbta5P-6EaFio-fVXXLz-9d5eN9-wNyBz9-6E6y54-8TEHF9-4CZLHB-7ALPAU-8e8xJm-cgs3dW-9Cw4ar-7cvvNA-p4NRuh-9DaZMe-66g573-7RJWgJ-5Ljfht"
                , license = "By Permission of Author"
                }
      }
    , { melody = Ebisu
      , displayName = "Ebisu"
      , id = 1
      , blurb = Just "ebisu.md"
      , image = Just "ebisu_800.jpg"
      , imageAttribution =
            Just
                { author = "agiawb"
                , url = "https://www.flickr.com/photos/58032217@N00/108139890/in/photolist-ayfdS-3RL8uU-6mc6qd-f8Umk-nieAd1-bNts1R-4BZCVr-7tbxgT-TF8Qo1-bzz7Ho-6StQtw-8dqnSR-5G9Mrm-bxxaJY-4nqPej-8rGD61-8SYmaC-4BHmeN-b62hA-3341uk-ddDUN1-fhs4cC-5FaQJ5-bKta8H-awvTpn-RdtA48-P5S2B7-4yi3Kr-343BcT-Lho6-4C4VDW-awyCz5-awvScD-3cnEBu-eXXJg8-dq9yuD-7G7miD-8mUYu7-5Cu1nh-csjiAb-9UuCSf-48YLty-CdbUQp-338xaQ-338xWu-9Zt3VU-52qjLS-gHu9R1-6a7BAb-6Knpbr"
                , license = "By Permission of Author"
                }
      }
    , { melody = Spring
      , displayName = "Yoyogi"
      , id = 2
      , blurb = Just "yoyogi.md"
      , image = Just "yoyogi_800.jpg"
      , imageAttribution =
            Just
                { author = "alex"
                , url = "https://www.flickr.com/photos/librarybook/15319046765/in/photolist-pkG7TX-qhW2FD-rfrwgb-8SZUzy-23mpoL-5wiSqT-47DizK-8njEtK-oQRdwA-hTsUiY-h8MLox-5m2avt-9h9pMR-o9THJr-4wq6jh-d7Zq91-GUTdh-pe7bT-9oE2e3-5RBKgx-81Zq6X-fjBWeC-oqDrXH-ajvPiP-arGRSD-qz9BD-ctdxaN-9oTRBL-nzhys-4XhoDR-sq1XHo-aagrVT-CY4JEw-7WN7K9-mEjR6-tLRp-69jRRq-9dsuTT-6JrZcH-7aNShP-auSHng-8Rr27W-9r4pqh-oLwpzA-4nor2b-nZywR-qhXfYB-di8t5E-c2gmHy-4aNnQv"
                , license = "By Permission of Author"
                }
      }
    , { melody = Harajuku
      , displayName = "Harajuku"
      , id = 3
      , blurb = Just "harajuku.md"
      , image = Just "harajuku_800.jpg"
      , imageAttribution =
            Just
                { author = "John Doe"
                , url = "https://www.flickr.com/photos/blazingfire/4463878339/in/photolist-7NsxvD-qXDZAy-7yg687-7XNWHZ-5e7vCJ-wrJRx-rdixBU-dRwVdR-7JuSrZ-bsFQSE-bzvdMf-7WzUH5-8KDqhx-bDhPen-dXxFfH-dkN8Dy-6EWYvi-akGtYM-p4qE44-fLCSpP-cCu16-7vLo1w-HuH1Bs-RdWqVj-ctxEjW-9PSRQD-RQ47HZ-7PYEzr-7QDQR5-8ZtoD4-gJFqfZ-d5WR3-cd9Ndy-9PVGQ9-exX29Z-pZVyb4-T3svXq-aHt3Ge-TxWNZQ-aJzTAk-nwCiAB-6TrfAR-7Jjntk-NFPdmm-7vE2fR-qmaGkn-8ezobd-c3yfv3-fs6tWf-4BRWkd"
                , license = "By Permission of Author"
                }
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
      , imageAttribution =
            Just
                { author = "ブルークレン アシュリー"
                , url = "https://www.flickr.com/photos/haiiro/6309004406/in/photolist-aBvid3-b2E98K-b27ySa-8gxZv4-8Yjmj3-JDHvG-24x4Jj-JDGS5-JDJf7-7kmv4c-5GwkfG-4qP4Nt-9BguQC-33abG-JDJs2-JDHvJ-JDGS9-7Bj3qA-JDGS7-33abE-aLtMw8-JDJrR-6CaQaC-5P4s83-7Bf9qe-7Bf8We-381Uus-7Bf8uD-7Bf8J8-7Bf7fK-33abD-boNs2S-6MXC7y-7TQ5J-bBHmMk-7Bf92K-bGAQYr-3sKf43-ELQGG-37Wk1v-9gnCba-Tkhg1-TkhhE-7iDFQG-JDGSb-JDJrD-j1aMP-MEbxbn-6MTquT-9DgV6P"
                , license = "By Permission of Author"
                }
      }
    , { melody = CieloEstrellado
      , displayName = "Gotanda"
      , id = 7
      , blurb = Nothing
      , image = Just "gotanda_800.jpg"
      , imageAttribution =
            Just
                { author = "Andreas Jakob"
                , url = "https://www.flickr.com/photos/107785646@N08/16473034215/in/photolist-r6EBai-54gM4T-5499xm-9XcGJC-4yVTG2-6k1314-4ohBzn-juYW-65huvx-naht6V-59qtEc-7JkiCk-B1v7AY-9Qkfa2-juYU-6k13NT-7NKf7J-5499Xf-ewt6QS-ewt6YS-5L3M6S-6k5dC7-5qR7nJ-AhkSQ8-CAp8yK-fMsmx9-6k5egY-86mPqk-6ry8QE-8awPSM-5mJfxN-Dt49Dm-qxBJWZ-eWRP1U-2VnssB-qxBJUz-4N5MiX-8tQTBx-5RFmn3-34mNbJ-7FS8dX-7LLqtE-SMjGrv-s6mie-6k11CV-j3RSxp-51yaJ1-6k13xM-ScjFfT-SVfp3Z"
                , license = "By Permission of Author"
                }
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
      , imageAttribution =
            Just
                { author = "Sakak_Flickr"
                , url = "https://www.flickr.com/photos/keisuke9498/33722402911/in/photolist-TnW8vR-UzwV8G-6ddBrv-ch2PJG-jU4NR6-9A1DpZ-mHjPAU-99b3fe-9K9YUE-dXKiZD-9A4Avo-9A1CZe-qk6ALX-91ei6v-ah3sNb-6DbCo6-91ei6r-9btjjY-wp6La-9A1B5Z-85AWMh-fvVguR-dQiqZP-9rqA88-9A1zun-36TSTd-UuByXk-q5ZbUX-9K78Rr-eYENR-bKTRav-t7ixz-bDjHFG-fCV7x-iUq9zp-5uro7v-9K9YnW-fscWtU-599CNm-utsYT-qjhu7c-9btjnQ-f4p83Z-9edHMj-kVJkhX-asbfs2-ETbhvC-qjhFUa-dvpHvo-4kJb49"
                , license = "By Permission of Author"
                }
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
      , imageAttribution =
            Just
                { author = "Nyao148"
                , url = "https://commons.wikimedia.org/wiki/File:Ikebukuro-Sta-JR-Centralgate2.JPG"
                , license = "Creative Commons"
                }
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
      , imageAttribution =
            Just
                { author = "Unknown"
                , url = "https://commons.wikimedia.org/wiki/File:Shinagawa_Station_1897.jpg"
                , license = "Creative Commons"
                }
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
      , imageAttribution =
            Just
                { author = "roevin"
                , url = "https://www.flickr.com/photos/59984889@N00/15105086449"
                , license = "By Permission of Author"
                }
      }
    , { melody = Sakura
      , displayName = "Komagome"
      , id = 18
      , blurb = Just "komagome.md"
      , image = Just "komagome_800.jpg"
      , imageAttribution =
            Just
                { author = "Nesnad"
                , url = "https://commons.wikimedia.org/wiki/File:JR-Komagomestation-platform-june13-2015.jpg"
                , license = "Creative Commons"
                }
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
