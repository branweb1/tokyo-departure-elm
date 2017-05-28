module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, PlayStatus(..))
import Commands exposing (..)
import Routing exposing (parseLocation, Route(..))
import Helpers exposing (validateQuery)
import View exposing (getById)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- let
    --     _ =
    --         Debug.log "" model
    -- in
    case msg of
        Play ->
            ( { model | playStatus = Playing }, Cmd.batch [ playAudio (), trackProgress (), trackEnded () ] )

        Pause ->
            ( { model | playStatus = Paused }, pauseAudio () )

        SetProgress progress ->
            ( { model | progress = progress }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        SetEnded ->
            ( { model | playStatus = Ended }, Cmd.none )

        SetQuery query ->
            case validateQuery query of
                Ok query ->
                    ( { model | query = query, errorMsg = Nothing }, Cmd.none )

                Err msg ->
                    ( { model | errorMsg = Just msg }, Cmd.none )

        SetBlurb blurb ->
            ( { model | blurb = blurb }, Cmd.none )

        ChangeLocation location ->
            let
                route =
                    parseLocation location

                fileName =
                    case route of
                        StationDetails stationId ->
                            case String.toInt stationId of
                                Ok idNum ->
                                    getById model.stations idNum
                                        |> Maybe.andThen (\station -> station.blurb)

                                Err err ->
                                    Nothing

                        _ ->
                            Nothing

                commands =
                    case fileName of
                        Just name ->
                            [ reset (), loadMarkdownFile (name) ]

                        Nothing ->
                            [ reset () ]
            in
                ( { model | route = route, progress = { elapsed = 0.0, total = 0.0 }, playStatus = Unstarted, blurb = Nothing }, Cmd.batch commands )
