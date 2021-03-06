module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (role, ariaLabelledby)
import Html.Events exposing (onClick, onInput)
import Model
    exposing
        ( Progress
        , PlayStatus(..)
        , Model
        , Station
        , Melody
        , PlayerDetails(..)
        , NowPlayingId
        , ImageAttribution
        )
import Messages exposing (..)
import Routing exposing (Route(..), routeAttrs)
import Helpers exposing (melodyToFile, getById)
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


controlButton : Int -> PlayStatus -> Html Msg
controlButton id playStatus =
    case playStatus of
        Playing ->
            span [ onClick Pause ] [ pauseIcon ]

        _ ->
            span [ onClick (Play id) ] [ playIcon ]


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


miscList : Route -> Html Msg
miscList current =
    ul [ ariaLabelledby "misc-label" ]
        [ li []
            [ a (routeAttrs current OrphanedMelodies "underlined") [ text "Orphaned Melodies" ] ]
        , li []
            [ a (routeAttrs current StationSounds "underlined") [ text "Station Sounds" ] ]
        ]


stationList : String -> Route -> List Station -> Html Msg
stationList query current stations =
    filterStations query stations
        |> List.sortBy (\station -> station.displayName)
        |> List.map
            (\station ->
                li []
                    [ a (routeAttrs current (StationDetails <| toString station.id) "underlined")
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
            , span [ id "misc-label" ] [ text "Misc" ]
            , miscList model.route
            ]


attribution attribution =
    case attribution of
        Just attribution ->
            figcaption []
                [ a [ href attribution.url, target "_blank" ] [ text "Photo" ]
                , text (" by " ++ attribution.author ++ " | " ++ attribution.license)
                ]

        Nothing ->
            text ""


stationImage : Maybe String -> Maybe ImageAttribution -> Html Msg
stationImage imageName attributionInfo =
    case imageName of
        Just imageName ->
            let
                url =
                    "images/" ++ imageName
            in
                figure []
                    [ img [ src url ] []
                    , attribution attributionInfo
                    ]

        Nothing ->
            text ""


audioElement : { b | id : a, melody : Melody } -> Html Msg
audioElement { melody, id } =
    let
        srcValue =
            "./melodies/" ++ (melodyToFile melody)

        idValue =
            "audio-player-" ++ (toString id)

        hrefValue =
            "./melodies/" ++ (melodyToFile melody)
    in
        audio [ src srcValue, Html.Attributes.id idValue ]
            [ p []
                [ text "Download "
                , a [ href hrefValue ]
                    [ text (melodyToFile melody) ]
                ]
            ]


playerControls :
    PlayerDetails
    -> { b | id : NowPlayingId, melody : Melody, displayName : String }
    -> Html Msg
playerControls details sound =
    let
        ( playerId, progress, playStatus ) =
            case details of
                Details id currentProgress currentPlayStatus ->
                    if sound.id == id then
                        ( id, currentProgress, currentPlayStatus )
                    else
                        ( sound.id, { elapsed = 0.0, total = 0.0 }, Unstarted )

                NoDetails ->
                    ( sound.id, { elapsed = 0.0, total = 0.0 }, Unstarted )
    in
        div [ class "audio-player-controls" ]
            [ controlButton playerId playStatus
            , progressBar progress
            , melodyTime progress (melodyToFile sound.melody)
            ]


stationDetails : Model -> Html Msg
stationDetails model =
    case model.currentStation of
        Just currentStation ->
            main_ [ role "main" ]
                [ h2 [] [ text currentStation.displayName ]
                , playerControls model.details currentStation
                , ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml [])
                , stationImage currentStation.image currentStation.imageAttribution
                , audioElement currentStation
                ]

        Nothing ->
            main_ [ role "main" ] []


orphanedMelodyDetails : Model -> Html Msg
orphanedMelodyDetails model =
    main_ [ role "main" ]
        [ h2 []
            [ text "Orphaned Melodies" ]
        , ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml [])
        , div
            []
            (List.map
                (\orphan ->
                    div [ class "misc-detail" ]
                        [ h4 [] [ text orphan.displayName ]
                        , playerControls model.details orphan
                        , audioElement orphan
                        ]
                )
                model.orphanedMelodies
            )
        ]


stationSoundDetails : Model -> Html Msg
stationSoundDetails model =
    main_ [ role "main" ]
        [ h2 []
            [ text "Station Sounds" ]
        , ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml [])
        , div
            []
            (List.map
                (\sound ->
                    div [ class "misc-detail" ]
                        [ h4 [] [ text sound.displayName ]
                        , playerControls model.details sound
                        , audioElement sound
                        ]
                )
                model.stationSounds
            )
        ]


view : Model -> Html Msg
view model =
    div []
        [ header [ role "banner" ]
            [ div [ class "header-contents" ]
                [ a [ href "#/", onClick (GetBlurb (Just "_home.md")) ]
                    [ img [ src "images/logo.png", alt "logo", class "logo" ] [] ]
                , h1 [ class "page-title" ] [ text "Tokyo Ekimelo" ]
                ]
            ]
        , section
            [ id "app-body" ]
            [ sidebar model
            , page model
            ]
        , footer []
            [ text "This site is written in Elm. Go "
            , a [ href "https://github.com/branweb1/tokyo-departure-elm", target "_blank" ] [ text "here" ]
            , text " to view the code. - © 2017 Brandon Webster"
            ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            homePage model

        Stations ->
            homePage model

        StationDetails id ->
            stationDetailsPage model

        OrphanedMelodies ->
            orphanedMelodyPage model

        StationSounds ->
            stationSoundPage model

        NotFound ->
            notFoundPage


stationSoundPage : Model -> Html Msg
stationSoundPage model =
    stationSoundDetails model


orphanedMelodyPage : Model -> Html Msg
orphanedMelodyPage model =
    orphanedMelodyDetails model


notFoundPage : Html Msg
notFoundPage =
    main_ [ role "main" ] [ text "404 :-(" ]


stationDetailsPage : Model -> Html Msg
stationDetailsPage model =
    stationDetails model


homePage : Model -> Html Msg
homePage model =
    main_ [ role "main" ]
        [ ((Maybe.withDefault "" model.blurb) |> Markdown.toHtml []) ]
