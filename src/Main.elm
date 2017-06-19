module Main exposing (..)

import Model exposing (initialModel, Model, stations)
import Navigation exposing (Location)
import Routing exposing (parseLocation, Route(..))
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)
import Messages exposing (Msg(ChangeLocation))
import Commands exposing (loadMarkdownFile)
import Helpers exposing (getById)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseLocation location

        currentStation =
            case route of
                StationDetails stationId ->
                    String.toInt stationId
                        |> Result.toMaybe
                        |> Maybe.andThen (\id -> getById stations id)

                _ ->
                    Nothing

        initModel =
            initialModel route currentStation

        fileName =
            case route of
                StationDetails stationId ->
                    String.toInt stationId
                        |> Result.toMaybe
                        |> Maybe.andThen (\id -> getById initModel.stations id)
                        |> Maybe.andThen (\station -> station.blurb)

                OrphanedMelodies ->
                    Just "_orphaned.md"

                StationSounds ->
                    Just "_sounds.md"

                Home ->
                    Just "_home.md"

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
