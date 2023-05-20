module Model exposing (..)

import Dict exposing (Dict)


type alias CellPosition =
    ( Int, Char )


type alias Model =
    { cells : Dict CellPosition String
    , rows : Int
    , cols : Int
    , currentCell : Maybe CellPosition
    }


initialModel : Model
initialModel =
    { cells = Dict.empty
    , rows = 15
    , cols = 20
    , currentCell = Nothing
    }
