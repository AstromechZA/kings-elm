module Cards exposing (
    Card,
    allCards,
    toCardString,
    view,
    Msg,
    isKingOfSpades,
    ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king,
    spades, hearts, diamonds, clubs)

import Html
import Html.Attributes
import Dict
import String

type alias Suit = {
    symbol : String,
    cssname : String
}

type alias Face = {
    symbol : String,
    cssname : String
}

spades = Suit "\x2660" "spades"
hearts = Suit "\x2665" "hearts"
diamonds = Suit "\x2666" "diams"
clubs = Suit "\x2663" "clubs"
allSuites = [spades, hearts, diamonds, clubs]

ace = Face "a" "rank-a"
two = Face "2" "rank-2"
three = Face "3" "rank-3"
four = Face "4" "rank-4"
five = Face "5" "rank-5"
six = Face "6" "rank-6"
seven = Face "7" "rank-7"
eight = Face "8" "rank-8"
nine = Face "9" "rank-9"
ten = Face "10" "rank-10"
jack = Face "j" "rank-j"
queen = Face "q" "rank-q"
king = Face "k" "rank-k"
allFaces = [ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king]

type alias Card = {
    suit : Suit,
    face : Face
}

allCards : List Card
allCards =
    List.concat (List.map (\s -> List.map (\f -> (Card s f)) allFaces) allSuites)

toCardString : Card -> String
toCardString card =
    card.face.symbol ++ " of " ++ card.suit.cssname

isKingOfSpades : Card -> Bool
isKingOfSpades card =
    card.suit == spades && card.face == king

-- VIEW

type Msg = NoOp

view : Card -> Html.Html Msg
view card =
    Html.div [ Html.Attributes.attribute "class" (String.join " " ["card", card.suit.cssname, card.face.cssname]) ] [
        Html.span [ Html.Attributes.attribute "class" "rank" ] [ Html.text card.face.symbol ],
        Html.span [ Html.Attributes.attribute "class" "suit" ] [ Html.text card.suit.symbol ]
    ]
