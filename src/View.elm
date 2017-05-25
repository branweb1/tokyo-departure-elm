module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (Progress, PlayStatus(..), Model, Station)
import Messages exposing (..)
import Routing exposing (Route(..), routeAttrs)
import Helpers exposing (melodyToFile)


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


stationDetails : Model -> String -> Html Msg
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
