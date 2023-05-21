module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Components.Footer as Footer
import Components.Navbar as Navbar
import Html exposing (Html)
import Pages.SpreadSheet as SpreadSheet
import Pages.Usage as Usage
import Route exposing (Route)
import Url exposing (Url)


type Model
    = SpreadSheet SpreadSheet.Model
    | Usage Usage.Model


type Msg
    = GotSpreadSheetMsg SpreadSheet.Msg
    | GotUsageMessage ()
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


init : flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( SpreadSheet (SpreadSheet.init key), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSpreadSheetMsg spreadSheetMsg, SpreadSheet spreadSheetModel ) ->
            SpreadSheet.update spreadSheetMsg spreadSheetModel
                |> mapUpdate SpreadSheet GotSpreadSheetMsg

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl (getNavKey model) (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            case Route.parse url of
                Just Route.Index ->
                    ( SpreadSheet <| SpreadSheet.init (getNavKey model), Cmd.none )

                Just Route.Usage ->
                    ( Usage <| Usage.init (getNavKey model), Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    case model of
        SpreadSheet spreadSheetModel ->
            SpreadSheet.view spreadSheetModel
                |> mapView model GotSpreadSheetMsg

        Usage usageModel ->
            Usage.view usageModel
                |> mapView model GotUsageMessage


mapUpdate : (model -> Model) -> (msg -> Msg) -> ( model, Cmd msg ) -> ( Model, Cmd Msg )
mapUpdate toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map toMsg cmd )


mapView : Model -> (msg -> Msg) -> { title : String, content : Html msg } -> Document Msg
mapView model toMsg { title, content } =
    { title = title
    , body =
        [ Navbar.component (isActive model)
        , Html.map toMsg content
        , Footer.component
        ]
    }


isActive : Model -> Route -> Bool
isActive model route =
    case ( model, route ) of
        ( SpreadSheet _, Route.Index ) ->
            True

        ( Usage _, Route.Usage ) ->
            True

        _ ->
            False


getNavKey : Model -> Nav.Key
getNavKey model =
    case model of
        SpreadSheet spreadSheetModel ->
            spreadSheetModel.key

        Usage usageModel ->
            usageModel.key
