module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (role)
import Html.Events exposing (onClick, onInput)
import Model exposing (Progress, PlayStatus(..), Model, Station)
import Messages exposing (..)
import Routing exposing (Route(..), routeAttrs)
import Helpers exposing (melodyToFile)
import Icons exposing (playIcon, pauseIcon)
import Markdown


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


controlButton : PlayStatus -> Html Msg
controlButton playStatus =
    case playStatus of
        Paused ->
            span [ onClick Play ] [ playIcon ]

        Playing ->
            span [ onClick Pause ] [ pauseIcon ]

        Ended ->
            span [ onClick Play ] [ playIcon ]

        Unstarted ->
            span [ onClick Play ] [ playIcon ]


melodyTime : Progress -> String -> Html Msg
melodyTime progress filename =
    let
        timeFormat str =
            case (String.length str) of
                1 ->
                    "00:0" ++ str

                _ ->
                    "00:" ++ str

        elapsedTime =
            round progress.elapsed
                |> toString
                |> timeFormat

        totalTime =
            round progress.total
                |> toString
                |> timeFormat
    in
        case ( elapsedTime, totalTime ) of
            ( "00:00", "00:00" ) ->
                div [ class "time" ] []

            _ ->
                div [ class "time cf" ]
                    [ span [ class "time-elapsed" ] [ text elapsedTime ]
                    , span [ class "time-total" ] [ text totalTime ]
                    ]


stationList : String -> Route -> List Station -> Html Msg
stationList query current stations =
    filterStations query stations
        |> List.map
            (\station ->
                let
                    attributes =
                        [ onClick (GetBlurb station.blurb) ] ++ (routeAttrs current (StationDetails (toString station.id)) "underlined")
                in
                    li []
                        [ a attributes
                            [ text station.displayName ]
                        ]
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
    nav [ role "navigation" ]
        [ label [ Html.Attributes.for "search" ] [ text "Stations" ]
        , input [ type_ "text", id "search", role "search", placeholder "Search", onInput SetQuery ] []
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
                main_ [ role "main" ]
                    [ h2 [] [ text station.displayName ]
                    , div [] [ ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml []) ]
                    , progressBar model.progress
                    , melodyTime model.progress (melodyToFile station.melody)
                    , div [] [ controlButton model.playStatus ]
                    , audio [ src ("./melodies/" ++ (melodyToFile station.melody)), id "audio-player" ]
                        [ p []
                            [ text "Download "
                            , a [ href ("./melodies/" ++ (melodyToFile station.melody)) ]
                                [ text (melodyToFile station.melody) ]
                            ]
                        ]
                    ]

            Nothing ->
                main_ [ role "main" ] []


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
    div [ id "app" ]
        [ header [ role "banner" ] [ text "header text" ]
        , section [ id "app-body" ]
            [ sidebar model
            , page model
            ]
        , footerLinks model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            homePage model

        Stations ->
            homePage model

        StationDetails id ->
            stationDetailsPage model id

        NotFound ->
            notFoundPage


notFoundPage : Html Msg
notFoundPage =
    main_ [ role "main" ] [ text "404 :-(" ]


stationDetailsPage : Model -> String -> Html Msg
stationDetailsPage model stationId =
    stationDetails model stationId


homePage : Model -> Html Msg
homePage model =
    main_ [ role "main" ] [ text "welcome home!" ]
