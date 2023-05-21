module Pages.Usage exposing (..)

import Browser.Navigation as Nav
import Html exposing (Html, br, div, h1, li, p, pre, span, text, ul)
import Html.Attributes exposing (class, id)


type alias Model =
    { key : Nav.Key }


init : Nav.Key -> Model
init key =
    { key = key }


view : Model -> { title : String, content : Html msg }
view _ =
    { title = "Usage"
    , content =
        div [ id "usage" ]
            [ h1 [] [ text "Usage" ]
            , ul []
                [ li [] [ text "Enter a number in a cell" ]
                , li [] [ text "Enter an equation by starting with an '='" ]
                ]
            , p [ class "negrita" ] [ text "Examples:" ]
            , pre []
                [ text "=A1+A2"
                , br [] []
                , text "=A1+79"
                , br [] []
                , text "=A1+B2+C3+..."
                ]
            , p []
                [ span [ class "negrita" ] [ text "Note: " ]
                , text "Currently only '+' is supported in equations."
                , br [] []
                , span [ class "negrita" ] [ text "Note: " ]
                , text "There must be no spaces between operands."
                ]
            ]
    }
