module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, PlayStatus(..))
import Commands exposing (..)
import Routing exposing (parseLocation)
import Helpers exposing (validateQuery)


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

        ChangeLocation location ->
            let
                route =
                    parseLocation location
            in
                ( { model | route = route, progress = { elapsed = 0.0, total = 0.0 }, playStatus = Unstarted }, reset () )
