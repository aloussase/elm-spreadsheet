module Msg exposing (..)

import Model exposing (CellPosition)


type Msg
    = EditCell CellPosition String
    | FocusCell CellPosition
