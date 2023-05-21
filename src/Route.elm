module Route exposing (Route(..), parse)

import Url exposing (Url)
import Url.Parser as Parser


type Route
    = Index
    | Usage


parse : Url -> Maybe Route
parse url =
    Parser.parse parser url


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.s "index.html" |> Parser.map Index
        , Parser.s "usage" |> Parser.map Usage
        ]
