module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html)
import Pages.SpreadSheet as SpreadSheet
import Url exposing (Url)


type Model
    = SpreadSheet SpreadSheet.Model


type Msg
    = GotSpreadSheetMsg SpreadSheet.Msg
    | ClickedLink UrlRequest
    | UrlChanged Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = ClickedLink
        , onUrlChange = UrlChanged
        }


init : flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( SpreadSheet (SpreadSheet.init key), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSpreadSheetMsg spreadSheetMsg, SpreadSheet spreadSheetModel ) ->
            SpreadSheet.update spreadSheetMsg spreadSheetModel
                |> mapUpdate SpreadSheet GotSpreadSheetMsg

        ( ClickedLink urlRequest, _ ) ->
            ( model, Cmd.none )

        ( UrlChanged url, _ ) ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    case model of
        SpreadSheet spreadSheetModel ->
            SpreadSheet.view spreadSheetModel
                |> mapView GotSpreadSheetMsg


mapUpdate : (model -> Model) -> (msg -> Msg) -> ( model, Cmd msg ) -> ( Model, Cmd Msg )
mapUpdate toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map toMsg cmd )


mapView : (msg -> Msg) -> { title : String, body : List (Html msg) } -> Document Msg
mapView toMsg { title, body } =
    { title = title
    , body = List.map (Html.map toMsg) body
    }
