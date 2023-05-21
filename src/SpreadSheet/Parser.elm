module SpreadSheet.Parser exposing (..)

import Char
import Maybe
import Maybe.Extra as ME
import Parser exposing ((|.), (|=), Parser)
import Set
import SpreadSheet.Expr exposing (..)
import Tuple


parseNumber : Parser Expr
parseNumber =
    Parser.map ENum Parser.int


parseVariable : Parser Expr
parseVariable =
    Parser.map
        (\var ->
            EVar
                (String.dropLeft 1 var
                    |> String.toInt
                    |> Maybe.withDefault 0
                )
                (String.left 1 var
                    |> String.uncons
                    |> Maybe.map Tuple.first
                    |> Maybe.withDefault 'A'
                )
        )
        (Parser.variable
            { start = Char.isUpper
            , inner = Char.isDigit
            , reserved = Set.empty
            }
        )


parsePrimaryExpr : Parser Expr
parsePrimaryExpr =
    Parser.oneOf [ parseVariable, parseNumber ]


parseSumExpr : Parser Expr
parseSumExpr =
    Parser.oneOf
        [ Parser.succeed EPlus
            |= Parser.backtrackable parsePrimaryExpr
            |. Parser.symbol "+"
            |= Parser.lazy (\_ -> parseSumExpr)
        , parsePrimaryExpr
        ]


parseExpr : Parser Expr
parseExpr =
    Parser.oneOf [ parseSumExpr ]


parseEquation : Parser Expr
parseEquation =
    Parser.symbol "="
        |> Parser.andThen (\_ -> parseExpr)


parser : Parser Expr
parser =
    Parser.succeed identity
        |= Parser.oneOf
            [ parseNumber
            , parseEquation
            ]
        |. Parser.end


parse : String -> Maybe Expr
parse input =
    case Parser.run parser input of
        Err _ ->
            Nothing

        Ok result ->
            Just result
