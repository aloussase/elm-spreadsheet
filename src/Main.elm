module Main exposing (main)

import Browser
import Char
import Dict
import Expr
import Html exposing (Html, div, h1, input, table, td, text, th, tr)
import Html.Attributes exposing (id, type_, value)
import Html.Events exposing (onFocus, onInput)
import Maybe
import Model exposing (..)
import Msg exposing (..)
import Parser


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        EditCell cellPosition input ->
            { model | cells = Dict.insert cellPosition input model.cells }

        FocusCell cellPosition ->
            { model | currentCell = Just cellPosition }


view : Model -> Html Msg
view model =
    div [ id "spreadsheet" ]
        [ h1 [] [ text "Elm SpreadSheet" ]
        , table []
            ([ viewSpreadSheetHeader model.cols ] ++ viewSpreadSheetRows model)
        ]


viewSpreadSheetRows : Model -> List (Html Msg)
viewSpreadSheetRows model =
    List.range 1 model.rows
        |> List.map
            (\row ->
                tr []
                    (List.range 0 model.cols
                        |> List.map
                            (\col ->
                                if col == 0 then
                                    td [] [ text <| String.fromInt row ]

                                else
                                    let
                                        cellPosition =
                                            ( row, getLetterForColumn col )

                                        cellContents =
                                            Maybe.withDefault "" <| Dict.get cellPosition model.cells
                                    in
                                    td []
                                        [ input
                                            [ type_ "text"
                                            , value <|
                                                case model.currentCell of
                                                    Nothing ->
                                                        evalCellContents cellContents

                                                    Just currentCellPos ->
                                                        if currentCellPos == cellPosition then
                                                            cellContents

                                                        else
                                                            evalCellContents cellContents
                                            , onInput (EditCell cellPosition)
                                            , onFocus (FocusCell cellPosition)
                                            ]
                                            []
                                        ]
                            )
                    )
            )


viewSpreadSheetHeader : Int -> Html Msg
viewSpreadSheetHeader cols =
    tr []
        (List.range 0 cols
            |> List.map
                (\col ->
                    if col == 0 then
                        th [] []

                    else
                        th [] [ text <| String.fromChar <| getLetterForColumn col ]
                )
        )


getLetterForColumn : Int -> Char
getLetterForColumn col =
    Char.fromCode (col + 64)


evalCellContents : String -> String
evalCellContents cellContents =
    Parser.parse cellContents
        |> Maybe.map Expr.toString
        |> Maybe.withDefault "#ERR"
