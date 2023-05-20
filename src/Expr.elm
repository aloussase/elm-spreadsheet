module Expr exposing (..)


type Expr
    = ENum Int
    | EString String


toString : Expr -> String
toString expr =
    case expr of
        ENum n ->
            String.fromInt n

        EString s ->
            s
