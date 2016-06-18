module Cards exposing (Suite, Face, Card, allCards, toCardString, view, Msg)

import Html

type Suite = Spades | Hearts | Diamonds | Clubs
type Face = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King

type alias Card = {
    suite : Suite,
    face : Face
}

allCardsForSuite : Suite -> List Card
allCardsForSuite suite =
    List.map (\f -> (Card suite f)) [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]

allCards : List Card
allCards =
    List.concat (List.map allCardsForSuite [Spades, Hearts, Diamonds, Clubs])

type Msg = NoOp

toCardString : Card -> String
toCardString card =
    (toString card.face) ++ " of " ++ (toString card.suite)

-- VIEW

view : Card -> Html.Html Msg
view card =
    Html.p []
        [ Html.text (toCardString card) ]
