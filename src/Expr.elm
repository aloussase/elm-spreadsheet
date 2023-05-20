module Expr exposing (..)

-- C1 + C2
-- C1 + 12


type Expr
    = ENum Int
    | EString String
    | EPlus Expr Expr
    | EVar Int Char


toString : Expr -> String
toString expr =
    case expr of
        ENum n ->
            String.fromInt n

        EString s ->
            s

        EPlus e1 e2 ->
            toString e1 ++ " + " ++ toString e2

        EVar col row ->
            String.fromInt col ++ String.fromChar row
