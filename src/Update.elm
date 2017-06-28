module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, PlayStatus(..), PlayerDetails(..))
import Routing exposing (Route(..))
import Commands exposing (..)
import Routing exposing (parseLocation)
import Helpers exposing (validateQuery, getById)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play id ->
            let
                playerDetails =
                    Details id { elapsed = 0.0, total = 0.0 } Playing
            in
                ( { model | details = playerDetails }
                , Cmd.batch [ playAudio id, trackProgress (), trackEnded () ]
                )

        Pause ->
            case model.details of
                Details id progress playStatus ->
                    let
                        newDetails =
                            Details id progress Paused
                    in
                        ( { model | details = newDetails }, pauseAudio () )

                NoDetails ->
                    ( model, Cmd.none )

        SetProgress progress ->
            case model.details of
                Details id oldProgress playStatus ->
                    let
                        newDetails =
                            Details id progress playStatus
                    in
                        ( { model | details = newDetails }, Cmd.none )

                NoDetails ->
                    ( model, Cmd.none )

        SetEnded ->
            case model.details of
                Details id progress playStatus ->
                    let
                        newDetails =
                            Details id progress Ended
                    in
                        ( { model | details = newDetails }, Cmd.none )

                NoDetails ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        SetQuery query ->
            case validateQuery query of
                Ok query ->
                    ( { model | query = query, errorMsg = Nothing }, Cmd.none )

                Err msg ->
                    ( { model | errorMsg = Just msg }, Cmd.none )

        GetBlurb fileName ->
            case fileName of
                Just name ->
                    ( model, loadMarkdownFile name )

                Nothing ->
                    ( model, Cmd.none )

        SetBlurb blurb ->
            ( { model | blurb = blurb }, Cmd.none )

        ChangeLocation location ->
            let
                route =
                    parseLocation location

                currentStation =
                    case route of
                        StationDetails stationId ->
                            Result.toMaybe (String.toInt stationId)
                                |> Maybe.andThen (getById model.stations)

                        _ ->
                            Nothing

                fileName =
                    case route of
                        StationDetails stationId ->
                            String.toInt stationId
                                |> Result.toMaybe
                                |> Maybe.andThen (\id -> getById model.stations id)
                                |> Maybe.andThen (\station -> station.blurb)

                        OrphanedMelodies ->
                            Just "_orphaned.md"

                        StationSounds ->
                            Just "_sounds.md"

                        Home ->
                            Just "_home.md"

                        _ ->
                            Nothing

                cmd =
                    case fileName of
                        Just name ->
                            loadMarkdownFile name

                        Nothing ->
                            Cmd.none
            in
                ( { model
                    | route = route
                    , currentStation = currentStation
                    , details = NoDetails
                    , blurb = Nothing
                  }
                , Cmd.batch [ cmd, reset () ]
                )
