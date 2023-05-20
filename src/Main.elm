module Main exposing (main)

import Browser
import Char
import Dict exposing (Dict)
import Eval
import Expr
import FooterView exposing (footerView)
import Html exposing (Html, div, h1, input, table, td, text, th, tr)
import Html.Attributes exposing (class, classList, id, type_, value)
import Html.Events exposing (onFocus, onInput)
import Maybe
import Maybe.Extra as ME
import Model exposing (..)
import Msg exposing (..)
import Parser_


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
        , footerView
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
                                viewSpreadSheetRow model row col
                            )
                    )
            )


viewSpreadSheetRow : Model -> Int -> Int -> Html Msg
viewSpreadSheetRow model row col =
    if col == 0 then
        td [ class "row-number" ] [ text <| String.fromInt row ]

    else
        let
            cellPosition =
                ( row, getLetterForColumn col )

            cellContents =
                Maybe.withDefault "" <| Dict.get cellPosition model.cells
        in
        viewCell model cellPosition cellContents


viewCell : Model -> CellPosition -> String -> Html Msg
viewCell model cellPosition cellContents =
    let
        cellResult =
            runCell model cellPosition cellContents
    in
    td []
        [ input
            [ type_ "text"
            , value (cellResult |> Maybe.withDefault "#ERR")
            , onInput (EditCell cellPosition)
            , onFocus (FocusCell cellPosition)
            , classList
                [ ( "cell-error", ME.isNothing cellResult )
                ]
            ]
            []
        ]


runCell : Model -> CellPosition -> String -> Maybe String
runCell model cellPosition cellContents =
    case model.currentCell of
        Nothing ->
            evalCellContents model.cells cellContents

        Just currentCellPos ->
            if currentCellPos == cellPosition then
                Just cellContents

            else
                evalCellContents model.cells cellContents


evalCellContents : Dict CellPosition String -> String -> Maybe String
evalCellContents cells cellContents =
    if String.isEmpty cellContents then
        Just ""

    else
        Parser_.parse cellContents
            |> Maybe.andThen (Eval.eval cells)
            |> Maybe.map String.fromInt


viewSpreadSheetHeader : Int -> Html Msg
viewSpreadSheetHeader cols =
    tr [] (List.range 0 cols |> List.map viewSpreadSheetHeaderColumn)


viewSpreadSheetHeaderColumn : Int -> Html Msg
viewSpreadSheetHeaderColumn col =
    if col == 0 then
        th [] []

    else
        th [ class "column-header" ] [ text <| String.fromChar <| getLetterForColumn col ]


getLetterForColumn : Int -> Char
getLetterForColumn col =
    Char.fromCode (col + 64)
