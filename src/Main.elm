module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Routes
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)



-- START:type.Page


type Page
    = Home
    | Reaction String
    | NotFound



-- END:type.Page
-- START:model


type alias Model =
    { page : Page
    , navigationKey : Navigation.Key
    }


initialModel : Navigation.Key -> Model
initialModel navigationKey =
    { page = NotFound
    , navigationKey = navigationKey
    }



-- END:model
-- START:init


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init () url navigationKey =
    setNewPage (Routes.match url) (initialModel navigationKey)



-- END:init
---- VIEW ----
-- START:viewContent


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        Home ->
            ( "Picshare"
            , h1 [] [ text "Public Feed" ]
            )

        Reaction xxxx ->
            ( "Reaction"
            , h1 [] [ text xxxx ]
            )

        NotFound ->
            ( "Not Found"
            , div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]
            )



-- END:viewContent
-- START:view


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.page
    in
    { title = title
    , body = [ content ]
    }



-- END:view
---- UPDATE ----
-- START:type.Msg


type Msg
    = NewRoute (Maybe Routes.Route)
    | Visit UrlRequest



-- END:type.Msg
-- START:setNewPage


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            ( { model | page = Home }, Cmd.none )

        Just (Routes.Reaction xxxx) ->
            ( { model | page = Reaction xxxx }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )



-- END:setNewPage
-- START:update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute maybeRoute ->
            setNewPage maybeRoute model

        _ ->
            ( model, Cmd.none )



-- END:update


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- PROGRAM ----


main : Program () Model Msg



-- START:main


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Visit
        , onUrlChange = Routes.match >> NewRoute
        }



-- END:main
---- MODEL ----
-- type alias Model =
--     {}
-- init : ( Model, Cmd Msg )
-- init =
--     ( {}, Cmd.none )
-- ---- UPDATE ----
-- type Msg
--     = NoOp
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     ( model, Cmd.none )
-- ---- VIEW ----
-- view : Model -> Html Msg
-- view model =
--     div []
--         [ img [ src "/logo.svg" ] []
--         , h1 [] [ text "Your Elm App is working!" ]
--         ]
-- ---- PROGRAM ----
-- main : Program () Model Msg
-- main =
--     Browser.element
--         { view = view
--         , init = \_ -> init
--         , update = update
--         , subscriptions = always Sub.none
--         }
-- -- import Json.Decode.Pipeline exposing (hardcoded, required)
-- ---- MODEL ----
-- baseUrl : String
-- baseUrl =
--     "https://chemist.swiswiswift.com/resource/"
-- personListDecoder : Decoder Reactions
-- personListDecoder =
--     Json.Decode.list photoDecoder
-- photoDecoder : Decoder Reaction
-- photoDecoder =
--     Json.Decode.map3 Reaction
--         (Json.Decode.field "directoryName" Json.Decode.string)
--         (Json.Decode.field "english" Json.Decode.string)
--         (Json.Decode.field "thmbnailName" Json.Decode.string)
-- type alias Reaction =
--     { directoryName : String
--     , english : String
--     , thmbnailName : String
--     }
-- -- type alias Model =
-- --     List Reaction
-- type alias Reactions =
--     List Reaction
-- type alias Model =
--     { reactions : Maybe Reactions
--     }
-- initialModel : Model
-- initialModel =
--     { reactions = Nothing
--     }
-- init : ( Model, Cmd Msg )
-- init =
--     ( initialModel, fetchFeed )
-- fetchFeed : Cmd Msg
-- fetchFeed =
--     Http.get
--         { url = baseUrl ++ "reactions.json"
--         , expect = Http.expectJson LoadFeed personListDecoder
--         }
-- ---- UPDATE ----
-- type Msg
--     = LoadFeed (Result Http.Error Reactions)
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         LoadFeed (Ok reactions) ->
--             ( { model | reactions = Just reactions }
--             , Cmd.none
--             )
--         LoadFeed (Err _) ->
--             ( model, Cmd.none )
-- ---- VIEW ----
-- liComponent : Reaction -> Html msg
-- liComponent reaction =
--     div []
--         [ h1 [] [ text reaction.english ]
--         , img [ src (baseUrl ++ "images/" ++ reaction.directoryName ++ "/" ++ reaction.thmbnailName) ] []
--         ]
-- ulComponent : List Reaction -> Html msg
-- ulComponent reactions =
--     ul [] (List.map liComponent reactions)
-- viewFeed : Maybe Reactions -> Html Msg
-- viewFeed maybeReactions =
--     case maybeReactions of
--         Just reactions ->
--             ulComponent reactions
--         Nothing ->
--             div [ class "loading-feed" ]
--                 [ text "Loading Feed..." ]
-- view : Model -> Html Msg
-- view model =
--     div []
--         [ viewFeed model.reactions
--         ]
-- ---- PROGRAM ----
-- main : Program () Model Msg
-- main =
--     Browser.element
--         { view = view
--         , init = \_ -> init
--         , update = update
--         , subscriptions = always Sub.none
--         }
