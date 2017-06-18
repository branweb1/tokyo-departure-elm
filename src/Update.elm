module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, PlayStatus(..))
import Commands exposing (..)
import Routing exposing (parseLocation)
import Helpers exposing (validateQuery)
import View exposing (getById)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- let
    --     _ =
    --         Debug.log "" model
    -- in
    case msg of
        Play id ->
            ( { model
                | progress = { elapsed = 0.0, total = 0.0 }
                , playStatus = Playing
                , nowPlaying = Just id
              }
            , Cmd.batch [ playAudio id, trackProgress (), trackEnded () ]
            )

        Pause ->
            ( { model | playStatus = Paused }, pauseAudio () )

        SetProgress progress ->
            ( { model | progress = progress }, Cmd.none )

        SetEnded ->
            ( { model | playStatus = Ended }, Cmd.none )

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
            in
                ( { model
                    | route = route
                    , progress = { elapsed = 0.0, total = 0.0 }
                    , nowPlaying = Nothing
                    , playStatus = Unstarted
                    , blurb = Nothing
                  }
                , reset ()
                )
