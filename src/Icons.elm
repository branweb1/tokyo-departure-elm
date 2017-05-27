module Icons exposing (playIcon, pauseIcon)

import Svg exposing (path, Svg, svg, g)
import Svg.Attributes exposing (d, version, viewBox, xmlSpace, preserveAspectRatio, height, width, class)


playIcon =
    svg
        [ xmlSpace "http://www.w3.org/2000/svg"
        , version "1.1"
        , viewBox "0 0 66 66"
        , preserveAspectRatio "xMidYMid meet"
        , class "icon"
        ]
        [ g []
            [ path [ d "M33,1.9C15.8,1.9,1.9,15.8,1.9,33s14,31.1,31.1,31.1s31.1-14,31.1-31.1S50.2,1.9,33,1.9z M33,61.1C17.5,61.1,4.9,48.5,4.9,33S17.5,4.9,33,4.9S61.1,17.5,61.1,33S48.5,61.1,33,61.1z" ] []
            , path [ d "M44.2,31.2l-18.9-9.5c-1.3-0.7-2.9,0.3-2.9,1.8v18.9c0,1.5,1.6,2.5,2.9,1.8l18.9-9.5C45.7,34.1,45.7,31.9,44.2,31.2z" ] []
            ]
        ]


pauseIcon =
    svg
        [ xmlSpace "http://www.w3.org/2000/svg"
        , version "1.1"
        , viewBox "0 0 66 66"
        , preserveAspectRatio "xMidYMid meet"
        , class "icon"
        ]
        [ g []
            [ path [ d "M33,1.9C15.8,1.9,1.9,15.8,1.9,33s14,31.1,31.1,31.1c17.2,0,31.1-14,31.1-31.1S50.2,1.9,33,1.9z M33,61.1C17.5,61.1,4.9,48.5,4.9,33S17.5,4.9,33,4.9c15.5,0,28.1,12.6,28.1,28.1S48.5,61.1,33,61.1z" ] []
            , path [ d "M28.9,21.4h-4.5c-1.1,0-2,0.9-2,2v19.1c0,1.1,0.9,2,2,2h4.5c1.1,0,2-0.9,2-2V23.4C30.9,22.3,30,21.4,28.9,21.4z" ] []
            , path [ d "M41.6,21.4h-4.5c-1.1,0-2,0.9-2,2v19.1c0,1.1,0.9,2,2,2h4.5c1.1,0,2-0.9,2-2V23.4C43.6,22.3,42.7,21.4,41.6,21.4z" ] []
            ]
        ]
