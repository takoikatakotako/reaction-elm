module ReactionList exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Routes
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)



---- MODEL ----


baseUrl : String
baseUrl =
    "https://chemist.swiswiswift.com/resource/"


reactionListDecoder : Decoder Reactions
reactionListDecoder =
    Json.Decode.list reactionDecoder


reactionDecoder : Decoder Reaction
reactionDecoder =
    Json.Decode.map3 Reaction
        (Json.Decode.field "directoryName" Json.Decode.string)
        (Json.Decode.field "english" Json.Decode.string)
        (Json.Decode.field "thmbnailName" Json.Decode.string)


type alias Reaction =
    { directoryName : String
    , english : String
    , thmbnailName : String
    }


type alias Reactions =
    List Reaction


type alias Model =
    { fetchStatus : FetchStatus
    , reactions : Maybe Reactions
    }


type FetchStatus
    = Doing
    | Done
    | Error


initialModel : Model
initialModel =
    { fetchStatus = Doing
    , reactions = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchFeed )


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "reactions.json"
        , expect = Http.expectJson LoadFeed reactionListDecoder
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
            ( { model | fetchStatus = Error }
            , Cmd.none
            )



---- VIEW ----


liComponent : Reaction -> Html msg
liComponent reaction =
    div []
        [ h1 [] [ text reaction.english ]
        , img [ src (baseUrl ++ "images/" ++ reaction.directoryName ++ "/" ++ reaction.thmbnailName) ] []
        ]


ulComponent : List Reaction -> Html msg
ulComponent reactions =
    ul [] (List.map liComponent reactions)


view : Model -> Html Msg
view model =
    case model.fetchStatus of
        Doing ->
            div [ class "Doing" ]
                [ text "Loading Feed..." ]

        Done ->
            case model.reactions of
                Just reactions ->
                    ulComponent reactions

                Nothing ->
                    div [ class "loading-feed" ]
                        [ text "UnKnownError" ]

        Error ->
            div [ class "Error" ]
                [ text "Error..." ]



-- ---- PROGRAM ----
-- main : Program () Model Msg
-- main =
--     Browser.element
--         { view = view
--         , init = \_ -> init
--         , update = update
--         , subscriptions = always Sub.none
--         }
-- view2 : String -> Html msg
-- view2 xxxx =
--     div [ class "XXX" ]
--         [ text xxxx ]
