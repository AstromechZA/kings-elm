module Rules exposing (Rule, RuleSet, buildBasic, view, Msg)

import Html
import Cards

type alias Rule = {
    name : String,
    description : String,
    filter : RuleFilter
}

type alias RuleFilter = {
    description : String,
    func : (Cards.Card -> Bool)
}

type alias RuleSet = {
    rules : List Rule
}

buildBasic : List Rule
buildBasic =
    [
        (Rule
            "Major Rules"
            "Define 2 major rules of your choosing, or cancel existing ones."
            (RuleFilter
                "Any Ace"
                (\c -> c.face == Cards.ace))),
        (Rule
            "Never have I ever"
            "Going round the circle, each player asks a 'Never have I ever' question. Anyone who has done 2 of things drinks and the round ends."
            (RuleFilter
                "Any Two"
                (\c -> c.face == Cards.two))),
        (Rule
            "Three is for me"
            "The player who draws this card, drinks."
            (RuleFilter
                "Any Three"
                (\c -> c.face == Cards.three))),
        (Rule
            "Girl's drink"
            "All girls at the table, drink"
            (RuleFilter
                "Any Four"
                (\c -> c.face == Cards.four))),
        (Rule
            "Love-Bird"
            "Pick someone who will drink with you for the rest of the round."
            (RuleFilter
                "Red Five"
                (\c -> c.face == Cards.five && (List.any ((==) c.suit) [Cards.diamonds, Cards.hearts])))),
        (Rule
            "Thumbs"
            "Until someone else draws this rule, you can choose to put your thumb on your drink, the last person to do the same, drinks."
            (RuleFilter
                "Black Five"
                (\c -> c.face == Cards.five && (List.any ((==) c.suit) [Cards.clubs, Cards.spades])))),
        (Rule
            "Guy's drink"
            "All guys at the table, drink."
            (RuleFilter
                "Any Six"
                (\c -> c.face == Cards.six))),
        (Rule
            "Waterfall"
            "Begin drinking, everyone to your left around the circle, must match the person on their right."
            (RuleFilter
                "Any Seven"
                (\c -> c.face == Cards.seven))),
        (Rule
            "Nominate"
            "The person you choose, drinks."
            (RuleFilter
                "Any Eight"
                (\c -> c.face == Cards.eight))),
        (Rule
            "Bust-a-rhyme, Story time, Dance time"
            "Everyone must rhyme with the word you choose, or drink; Each person adds 3 words to your story or dance."
            (RuleFilter
                "Any Nine"
                (\c -> c.face == Cards.nine))),
        (Rule
            "Some Rule"
            "Do something."
            (RuleFilter
                "Any Ten"
                (\c -> c.face == Cards.ten))),
        (Rule
            "Lick and Stick"
            "Like the back of your card and stick it to your forehead, drink when it falls off."
            (RuleFilter
                "Any Jack"
                (\c -> c.face == Cards.jack))),
        (Rule
            "Question Master"
            "Until someone else draws this rule, anyone who answers your questions must drink unless they answer with a question."
            (RuleFilter
                "Black Queen"
                (\c -> c.face == Cards.queen && (List.any ((==) c.suit) [Cards.clubs, Cards.spades])))),
        (Rule
            "Stick 'em Up"
            "Until someone else draws this rule, you can choose to stick your hands in the air, the last person to do the same, drinks.."
            (RuleFilter
                "Red Queen"
                (\c -> c.face == Cards.queen && (List.any ((==) c.suit) [Cards.diamonds, Cards.hearts])))),
        (Rule
            "King!"
            "Add a third of your drink to the King's cup, if this is the 4th King, drink it and the game ends!"
            (RuleFilter
                "Any King"
                (\c -> c.face == Cards.king)))
    ]

-- VIEW

type Msg = NoOp

view : RuleSet -> Html.Html Msg
view ruleset =
    Html.table [] (List.map viewRuleRow ruleset.rules)

viewRuleRow : Rule -> Html.Html Msg
viewRuleRow rule =
    Html.tr [] [
        Html.td [] [ Html.text rule.filter.description ],
        Html.td [] [ Html.text rule.name ],
        Html.td [] [ Html.text rule.description ]
    ]
