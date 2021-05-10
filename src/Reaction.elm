module Reaction exposing (Model, Msg, init, initialModel, update, view)

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


type alias Reaction =
    { directoryName : String
    , english : String
    , thmbnailName : String
    }


type alias Model =
    { fetchStatus : FetchStatus
    , reaction : Maybe Reaction
    }


type FetchStatus
    = Doing
    | Done
    | Error


initialModel : Model
initialModel =
    { fetchStatus = Doing
    , reaction = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchReaction )


reactionDecoder : Decoder Reaction
reactionDecoder =
    Json.Decode.map3 Reaction
        (Json.Decode.field "directoryName" Json.Decode.string)
        (Json.Decode.field "english" Json.Decode.string)
        (Json.Decode.field "thmbnailName" Json.Decode.string)


fetchReaction : Cmd Msg
fetchReaction =
    Http.get
        { url = baseUrl ++ "reactions/acetoacetic-ester-synthesis.json"
        , expect = Http.expectJson FetchReaction reactionDecoder
        }



---- UPDATE ----


type Msg
    = FetchReaction (Result Http.Error Reaction)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchReaction (Ok reaction) ->
            ( { fetchStatus = Done
              , reaction = Just reaction
              }
            , Cmd.none
            )

        FetchReaction (Err _) ->
            ( { model | fetchStatus = Error }
            , Cmd.none
            )



---- VIEW ----


viewComponent : Reaction -> Html msg
viewComponent reaction =
    div []
        [ h1 [] [ text reaction.english ]
        , img [ src (baseUrl ++ "images/" ++ reaction.directoryName ++ "/" ++ reaction.thmbnailName) ] []
        ]


view : Model -> Html Msg
view model =
    case model.fetchStatus of
        Doing ->
            div [ class "Doing" ]
                [ text "Loading Feed..." ]

        Done ->
            div [ class "Done" ]
                [ text "Done Feed..." ]

        Error ->
            div [ class "Error" ]
                [ text "Error..." ]
