module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)



-- import Json.Decode.Pipeline exposing (hardcoded, required)
---- MODEL ----


baseUrl : String
baseUrl =
    "https://chemist.swiswiswift.com/"


personListDecoder : Decoder Reactions
personListDecoder =
    Json.Decode.list photoDecoder


photoDecoder : Decoder Reaction
photoDecoder =
    Json.Decode.map3 Reaction
        (Json.Decode.field "directoryName" Json.Decode.string)
        (Json.Decode.field "english" Json.Decode.string)
        (Json.Decode.field "thmbnailName" Json.Decode.string)


type alias Reaction =
    { directoryName : String
    , english : String
    , thmbnailName : String
    }



-- type alias Model =
--     List Reaction


type alias Reactions =
    List Reaction


type alias Model =
    { reactions : Maybe Reactions
    }


initialModel : Model
initialModel =
    { reactions = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchFeed )


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "reactions.json"
        , expect = Http.expectJson LoadFeed personListDecoder
        }



---- UPDATE ----


type Msg
    = LoadFeed (Result Http.Error Reactions)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadFeed (Ok reactions) ->
            ( { model | reactions = Just reactions }
            , Cmd.none
            )

        LoadFeed (Err _) ->
            ( model, Cmd.none )



---- VIEW ----


liComponent : Reaction -> Html msg
liComponent reaction =
    div []
        [ h1 [] [ text reaction.english ]
        , img [ src (baseUrl ++ reaction.directoryName ++ "/" ++ reaction.thmbnailName) ] []
        ]


ulComponent : List Reaction -> Html msg
ulComponent reactions =
    ul [] (List.map liComponent reactions)


viewFeed : Maybe Reactions -> Html Msg
viewFeed maybeReactions =
    case maybeReactions of
        Just reactions ->
            ulComponent reactions

        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading Feed..." ]


view : Model -> Html Msg
view model =
    div []
        [ viewFeed model.reactions
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
