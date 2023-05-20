module Parser exposing (..)

import Expr exposing (..)


parse : String -> Maybe Expr
parse input =
    case input of
        "" ->
            Just <| EString ""

        _ ->
            Just <| ENum 12
