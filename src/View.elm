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

        timeString =
            elapsedTime ++ "/" ++ totalTime
    in
        case ( elapsedTime, totalTime ) of
            ( "00:00", "00:00" ) ->
                span [] []

            _ ->
                span [ class "time" ] [ text timeString ]


stationList : String -> Route -> List Station -> Html Msg
stationList query current stations =
    filterStations query stations
        |> List.sortBy (\station -> station.displayName)
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
    case msg of
        Just errorMessage ->
            div [ class "error-message" ] [ text errorMessage ]

        Nothing ->
            text ""


sidebar : Model -> Html Msg
sidebar model =
    let
        inputClass =
            case model.errorMsg of
                Just _ ->
                    "input-error"

                Nothing ->
                    "input-normal"
    in
        nav [ role "navigation" ]
            [ label [ Html.Attributes.for "search" ] [ text "Stations" ]
            , input [ type_ "text", id "search", role "search", placeholder "Search", onInput SetQuery, class inputClass ] []
            , errorMessage model.errorMsg
            , stationList model.query model.route model.stations
            ]


stationImage : Maybe String -> Html Msg
stationImage imageName =
    case imageName of
        Just imageName ->
            let
                url =
                    "images/" ++ imageName
            in
                img [ src url ] []

        Nothing ->
            text ""


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
                    , div [ class "audio-player-controls" ]
                        [ controlButton model.playStatus
                        , progressBar model.progress
                        , melodyTime model.progress (melodyToFile station.melody)
                        ]
                    , div [] [ ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml []) ]
                    , stationImage station.image
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
    div []
        [ header [ role "banner" ]
            [ div [ class "logo-container" ] [ a [ href "#/" ] [ text "logo here" ] ]
            , h1 [ class "page-title" ] [ text "Tokyo Departure Melodies" ]
            ]
        , section
            [ id "app-body" ]
            [ sidebar model
            , page model
            ]
        , footer [] [ text "all rights reserved blah blah" ]
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
