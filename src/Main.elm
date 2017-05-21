port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode


type alias Model =
    { stations : List Station
    , progress : Progress
    , playStatus : PlayStatus
    }


type PlayStatus
    = Playing
    | Paused
    | Ended


type alias Progress =
    { elapsed : Float, total : Float }


type Melody
    = AstroBoyV2
    | Ebisu


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
    ]


initialModel : Model
initialModel =
    { stations = stations
    , progress = { elapsed = 0.0, total = 0.0 }
    , playStatus = Paused
    }



-- helpers


melodyToFile : Melody -> String
melodyToFile melody =
    case melody of
        AstroBoyV2 ->
            "astro_boy_v2.mp3"

        Ebisu ->
            "ebisu.mp3"


decodeResponse json =
    case Decode.decodeValue progressDecoder json of
        Ok resp ->
            SetProgress resp

        Err err ->
            NoOp


progressDecoder =
    Decode.map2 Progress
        (Decode.field "elapsed" Decode.float)
        (Decode.field "total" Decode.float)


decodedEndedResponse json =
    case Decode.decodeValue endedDecoder json of
        Ok resp ->
            SetEnded

        Err err ->
            NoOp


endedDecoder =
    Decode.map identity
        (Decode.field "ended" Decode.bool)



-- messages


type Msg
    = Play
    | Pause
    | SetProgress Progress
    | SetEnded
    | NoOp



-- commands


port playAudio : () -> Cmd msg


port pauseAudio : () -> Cmd msg


port trackProgress : () -> Cmd msg


port trackEnded : () -> Cmd msg


port progress : (Decode.Value -> msg) -> Sub msg


port ended : (Decode.Value -> msg) -> Sub msg



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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



-- view


progressBar : Progress -> Html Msg
progressBar progress =
    let
        scaleX =
            case progress.total of
                0.0 ->
                    "scaleX(0)"

                _ ->
                    (progress.elapsed / progress.total)
                        |> toString
                        |> (\val -> "scaleX(" ++ val ++ ")")
    in
        div [ class "outer-bar" ]
            [ div [ style [ ( "transform", scaleX ) ], class "inner-bar" ] []
            ]


playButton : PlayStatus -> Html Msg
playButton playStatus =
    case playStatus of
        Paused ->
            button [ onClick Play ] [ text "play" ]

        Playing ->
            button [ onClick Pause ] [ text "pause" ]

        Ended ->
            button [ onClick Play ] [ text "replay" ]


melodyDetails : Progress -> String -> Html Msg
melodyDetails progress filename =
    let
        elapsedTime =
            round progress.elapsed
                |> toString

        totalTime =
            round progress.total
                |> toString

        timeString =
            elapsedTime ++ "/" ++ totalTime
    in
        div []
            [ span [] [ text <| filename ]
            , span [] [ text timeString ]
            ]


view : Model -> Html Msg
view model =
    div []
        (List.map
            (\station ->
                section []
                    [ playButton model.playStatus
                    , progressBar model.progress
                    , melodyDetails model.progress (melodyToFile station.melody)
                    , audio [ src ("./melodies/" ++ (melodyToFile station.melody)), id "audio-player" ]
                        [ p []
                            [ text "Download "
                            , a [ href ("./melodies/" ++ (melodyToFile station.melody)) ]
                                [ text (melodyToFile station.melody) ]
                            ]
                        ]
                    ]
            )
            model.stations
        )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ progress decodeResponse
        , ended decodedEndedResponse
        ]



-- program


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
