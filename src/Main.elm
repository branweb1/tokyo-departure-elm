port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Char
import UrlParser as Url exposing (Parser, (</>))
import Navigation exposing (Location)


type alias Model =
    { stations : List Station
    , progress : Progress
    , playStatus : PlayStatus
    , query : String
    , errorMsg : Maybe String
    , route : Route
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


initialModel : Route -> Model
initialModel route =
    { stations = stations
    , progress = { elapsed = 0.0, total = 0.0 }
    , playStatus = Unstarted
    , query = ""
    , errorMsg = Nothing
    , route = route
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
                SetProgress { elapsed = 0.0, total = 0.0 }
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



-- routing


route : Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home (Url.top)
        , Url.map StationDetails (Url.s "stations" </> Url.string)
        , Url.map Stations (Url.s "stations")
        ]


type Route
    = Home
    | Stations
    | StationDetails String
    | NotFound


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                Home ->
                    []

                Stations ->
                    [ "stations" ]

                StationDetails id ->
                    [ "stations", id ]

                NotFound ->
                    [ "blah" ]
    in
        "#/" ++ (String.join "/" pieces)


parseLocation : Location -> Route
parseLocation location =
    case (Url.parseHash route location) of
        Just route ->
            route

        Nothing ->
            NotFound



-- messages


type Msg
    = Play
    | Pause
    | SetProgress Progress
    | SetEnded
    | SetQuery String
    | NoOp
    | ChangeLocation Location



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

        ChangeLocation location ->
            let
                route =
                    parseLocation location
            in
                ( { model | route = route, progress = { elapsed = 0.0, total = 0.0 }, playStatus = Unstarted }, reset () )



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


stationList : String -> Route -> List Station -> Html Msg
stationList query current stations =
    filterStations query stations
        |> List.map
            (\station ->
                li []
                    [ a (routeAttrs current (StationDetails (toString station.id)) "underlined") [ text station.displayName ] ]
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
        , stationList model.query model.route model.stations
        ]


stationDetails model stationId =
    let
        station =
            case String.toInt stationId of
                Ok idNum ->
                    getById model.stations idNum

                Err err ->
                    Nothing
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


activeLink currentRoute linkRoute className =
    if linkRoute == currentRoute then
        class className
    else
        class ""


routeAttrs currentRoute linkRoute className =
    [ href (routeToString linkRoute), (activeLink currentRoute linkRoute className) ]


footerLinks : Model -> Html Msg
footerLinks model =
    footer
        []
        [ a (routeAttrs model.route Stations "active") [ text "stations" ]
        , a (routeAttrs model.route (StationDetails "1") "active") [ text "station" ]
        , a (routeAttrs model.route Home "active") [ text "home" ]
        , a (routeAttrs model.route NotFound "active") [ text "404 page" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ sidebar model
        , page model
        , footerLinks model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            homePage model

        Stations ->
            stationsPage model

        StationDetails id ->
            stationDetailsPage model id

        NotFound ->
            notFoundPage


notFoundPage : Html Msg
notFoundPage =
    div [] [ text "404 :-(" ]


stationDetailsPage : Model -> String -> Html Msg
stationDetailsPage model stationId =
    stationDetails model stationId


stationsPage : Model -> Html Msg
stationsPage model =
    div [] [ text "Nothing here for now" ]


homePage : Model -> Html Msg
homePage model =
    div [] [ text "welcome home!" ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ progress decodeResponse
        , ended decodedEndedResponse
        ]



-- program


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
