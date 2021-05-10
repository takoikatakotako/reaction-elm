module Routes exposing (Route(..), match)

-- END:module
-- START:import
-- START:import.Url.Parser

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = ReactionList
    | Reaction String


match : Url -> Maybe Route
match url =
    Parser.parse routes url


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map ReactionList Parser.top
        , Parser.map Reaction (Parser.s "reaction" </> Parser.string)
        ]
