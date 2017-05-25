module Main exposing (..)

import Model exposing (initialModel, Model)
import Navigation exposing (Location)
import Routing exposing (parseLocation)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)
import Messages exposing (Msg(ChangeLocation))


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseLocation location
    in
        ( initialModel route, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program ChangeLocation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
