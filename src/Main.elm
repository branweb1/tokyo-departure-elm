module Main exposing (..)

import Model exposing (initialModel, Model)
import Navigation exposing (Location)
import Routing exposing (parseLocation, Route(..))
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view, getById)
import Messages exposing (Msg(ChangeLocation))
import Commands exposing (loadMarkdownFile)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseLocation location

        initModel =
            initialModel route

        fileName =
            case route of
                StationDetails stationId ->
                    String.toInt stationId
                        |> Result.toMaybe
                        |> Maybe.andThen (\id -> getById initModel.stations id)
                        |> Maybe.andThen (\station -> station.blurb)

                _ ->
                    Nothing
    in
        case fileName of
            Just name ->
                ( initModel, loadMarkdownFile name )

            Nothing ->
                ( initModel, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program ChangeLocation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
