port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Char


type alias Model =
    { stations : List Station
    , progress : Progress
    , playStatus : PlayStatus
    , query : String
    , selected : Maybe Int
    , errorMsg : Maybe String
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


initialModel : Model
initialModel =
    { stations = stations
    , progress = { elapsed = 0.0, total = 0.0 }
    , playStatus = Unstarted
    , query = ""
    , selected = Nothing
    , errorMsg = Nothing
    }



-- helpers


melodyToFile : Melody -> String
melodyToFile melody =
    case melody of
        AstroBoyV2 ->
            "astro_boy_v2.mp3"

        Ebisu ->
            "ebisu.mp3"

        Harajuku ->
            "harajuku_a.mp3"

        SH3 ->
            "sh-3.mp3"

        Babble ->
            "babble.mp3"

        CieloEstrellado ->
            "cielo_estrellado.mp3"


decodeResponse json =
    case Decode.decodeValue progressDecoder json of
        Ok resp ->
            if isNaN resp.total || isNaN resp.elapsed then
                SetProgress initialModel.progress
            else
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


validateQuery : String -> Result String String
validateQuery query =
    let
        isLetter a =
            Char.isUpper a || Char.isLower a
    in
        case String.all isLetter query of
            True ->
                Ok query

            False ->
                Err "Search can only contain letters"



-- messages


type Msg
    = Play
    | Pause
    | SetProgress Progress
    | SetEnded
    | SetQuery String
    | SetSelected (Maybe Int)
    | NoOp



-- commands


port playAudio : () -> Cmd msg


port pauseAudio : () -> Cmd msg


port trackProgress : () -> Cmd msg


port trackEnded : () -> Cmd msg


port progress : (Decode.Value -> msg) -> Sub msg


port ended : (Decode.Value -> msg) -> Sub msg


port reset : () -> Cmd msg



-- update


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

        SetSelected mid ->
            ( { model | selected = mid, progress = initialModel.progress, playStatus = Unstarted }, reset () )



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

        Unstarted ->
            button [ onClick Play ] [ text "play" ]


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


alreadySelected : Maybe Int -> Int -> Bool
alreadySelected selectedId stationId =
    Maybe.map ((==) stationId) selectedId
        |> Maybe.withDefault False


stationList : String -> Maybe Int -> List Station -> Html Msg
stationList query selected stations =
    filterStations query stations
        |> List.map
            (\station ->
                let
                    currentlySelected =
                        alreadySelected selected station.id

                    handler =
                        if currentlySelected == True then
                            NoOp
                        else
                            SetSelected <| Just station.id

                    className =
                        if currentlySelected == True then
                            "underlined"
                        else
                            ""
                in
                    li [ onClick handler, class className ]
                        [ text station.displayName ]
            )
        |> ul []


filterStations : String -> List Station -> List Station
filterStations query stations =
    List.filter
        (\station ->
            String.startsWith (String.toLower query) (String.toLower station.displayName)
        )
        stations


getById : List Station -> Int -> Maybe Station
getById list id =
    List.filter (\item -> item.id == id) list
        |> List.head


errorMessage : Maybe String -> Html Msg
errorMessage msg =
    div [] [ text <| Maybe.withDefault "" msg ]


sidebar : Model -> Html Msg
sidebar model =
    nav []
        [ input [ type_ "text", onInput SetQuery ] []
        , errorMessage model.errorMsg
        , stationList model.query model.selected model.stations
        ]


stationDetails model =
    let
        station =
            model.selected
                |> Maybe.andThen (getById model.stations)
    in
        case station of
            Just station ->
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

            Nothing ->
                section [] []


view : Model -> Html Msg
view model =
    div []
        [ sidebar model
        , stationDetails model
        ]



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
