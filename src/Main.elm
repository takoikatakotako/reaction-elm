module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import ReactionList
import Routes
import Url exposing (Url)


type Page
    = ReactionList ReactionList.Model
    | Reaction String
    | NotFound


type alias Model =
    { page : Page
    , navigationKey : Navigation.Key
    }


initialModel : Navigation.Key -> Model
initialModel navigationKey =
    { page = NotFound
    , navigationKey = navigationKey
    }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init () url navigationKey =
    setNewPage (Routes.match url) (initialModel navigationKey)


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        ReactionList reactionListModel ->
            ( "Picshare"
            , ReactionList.view reactionListModel
                |> Html.map ReactionListMsg
            )

        Reaction string ->
            ( "Reaction"
            , div [ class "Reaction" ]
                [ h1 [] [ text "Reaction" ] ]
            )

        NotFound ->
            ( "Not Found"
            , div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]
            )


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.page
    in
    { title = title
    , body = [ content ]
    }


type Msg
    = NewRoute (Maybe Routes.Route)
    | Visit UrlRequest
    | ReactionListMsg ReactionList.Msg


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.ReactionList ->
            let
                ( reactionListModel, reactionListCmd ) =
                    ReactionList.init
            in
            ( { model | page = ReactionList reactionListModel }
            , Cmd.map ReactionListMsg reactionListCmd
            )

        Just (Routes.Reaction xxxx) ->
            ( { model | page = Reaction xxxx }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute maybeRoute ->
            setNewPage maybeRoute model

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Visit
        , onUrlChange = Routes.match >> NewRoute
        }
