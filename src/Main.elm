module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)



---- MODEL ----


baseUrl : String
baseUrl =
    "https://chemist.swiswiswift.com/"


type alias Reaction =
    { directoryName : String
    , english : String
    , thmbnailName : String
    }


type alias Model =
    List Reaction


initialModel : Model
initialModel =
    [ { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    , { directoryName = "acyloin-condensation"
      , english = "Acyloin Condensation"
      , thmbnailName = "acyloin-condensation-general-formula-0.png"
      }
    ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


liComponent : Reaction -> Html msg
liComponent reaction =
    div []
        [ h1 [] [ text reaction.english ]
        , img [ src (baseUrl ++ reaction.directoryName ++ "/" ++ reaction.thmbnailName) ] []
        ]


view : Model -> Html Msg
view model =
    div []
        [ ul [] (model |> List.map liComponent)
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
