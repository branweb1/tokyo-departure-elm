module Messages exposing (..)

import Model exposing (Progress)
import Navigation exposing (Location)


type Msg
    = Play Int
    | Pause
    | SetProgress Progress
    | SetEnded
    | SetQuery String
    | NoOp
    | ChangeLocation Location
    | SetBlurb (Maybe String)
    | GetBlurb (Maybe String)
