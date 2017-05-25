module Routing exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (href, class)
import UrlParser as Url exposing (Parser, (</>))
import Navigation exposing (Location)


type Route
    = Home
    | Stations
    | StationDetails String
    | NotFound


route : Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home (Url.top)
        , Url.map StationDetails (Url.s "stations" </> Url.string)
        , Url.map Stations (Url.s "stations")
        ]


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


activeLink : Route -> Route -> String -> Attribute msg
activeLink currentRoute linkRoute className =
    if linkRoute == currentRoute then
        class className
    else
        class ""


routeAttrs : Route -> Route -> String -> List (Attribute msg)
routeAttrs currentRoute linkRoute className =
    [ href (routeToString linkRoute), (activeLink currentRoute linkRoute className) ]
