module Components.Navbar exposing (..)

import Html exposing (Html, a, nav, text)
import Html.Attributes exposing (classList, href, id)
import Route exposing (Route)


type alias IsActive =
    Route -> Bool


component : IsActive -> Html msg
component isActive =
    nav [ id "app-nav" ]
        [ a [ href "/index.html", classList [ ( "active", isActive Route.Index ) ] ] [ text "SpreadSheet" ]
        , a [ href "/usage", classList [ ( "active", isActive Route.Usage ) ] ] [ text "Usage" ]
        ]
