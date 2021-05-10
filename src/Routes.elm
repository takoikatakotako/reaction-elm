module Routes exposing (Route(..), href, match)

-- END:module
-- START:import
-- START:import.Url.Parser

import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = ReactionList
    | Reaction String


href : Route -> Html.Attribute msg
href route =
    Html.Attributes.href (routeToUrl route)


match : Url -> Maybe Route
match url =
    Parser.parse routes url


routeToUrl : Route -> String
routeToUrl route =
    case route of
        ReactionList ->
            "/"

        Reaction name ->
            "/reaction/" ++ name


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map ReactionList Parser.top
        , Parser.map Reaction (Parser.s "reaction" </> Parser.string)
        ]
