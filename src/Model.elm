module Model exposing (..)

import Routing exposing (Route)


type alias Model =
    { stations : List Station
    , progress : Progress
    , playStatus : PlayStatus
    , query : String
    , errorMsg : Maybe String
    , route : Route
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


type alias Station =
    { melody : Melody
    , displayName : String
    , id : Int
    , blurb : Maybe String
    }


stations : List Station
stations =
    [ { melody = AstroBoyV2
      , displayName = "Takada-no-Baba"
      , id = 0
      , blurb = Just "blah blah"
      }
    , { melody = Ebisu
      , displayName = "Ebisu"
      , id = 1
      , blurb = Nothing
      }
    , { melody = Harajuku
      , displayName = "Harajuku"
      , id = 3
      , blurb = Nothing
      }
    , { melody = SH3
      , displayName = "Tokyo"
      , id = 4
      , blurb = Nothing
      }
    , { melody = Babble
      , displayName = "Mejiro"
      , id = 5
      , blurb = Nothing
      }
    , { melody = Babble
      , displayName = "Kanda"
      , id = 6
      , blurb = Nothing
      }
    , { melody = CieloEstrellado
      , displayName = "Gotanda"
      , id = 7
      , blurb = Nothing
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
    }
