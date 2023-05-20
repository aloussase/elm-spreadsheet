module FooterView exposing (..)

import Html exposing (Html, a, div, footer, i, span, text)
import Html.Attributes exposing (class, href)


footerView : Html msg
footerView =
    footer []
        [ div []
            [ text "Made with "
            , i [ class "fa-solid fa-heart" ] []
            , text " + Elm"
            ]
        , div []
            [ text "Fork me on "
            , a [ href "https://github.com/aloussase/elm-spreadsheet" ]
                [ i [ class "fab fa-github" ] [] ]
            ]
        , div [] [ text "Copyright Alexander Goussas 2023" ]
        ]
