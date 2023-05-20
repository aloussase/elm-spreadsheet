module Eval exposing (..)

import Dict exposing (Dict)
import Expr exposing (..)
import Model exposing (CellPosition)
import Parser_ exposing (parse)


eval : Dict CellPosition String -> Expr -> Maybe Int
eval env expr =
    case expr of
        ENum n ->
            Just n

        EString _ ->
            Just 69

        EPlus e1 e2 ->
            Maybe.map2 (+)
                (eval env e1)
                (eval env e2)

        EVar row col ->
            Dict.get ( row, col ) env
                |> Maybe.andThen
                    (\cellContents ->
                        case parse cellContents of
                            Just result ->
                                eval env result

                            Nothing ->
                                Nothing
                    )
