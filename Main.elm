import Html
import Html.Events
import Html.App
import Html.Attributes
import Cards
import Decks
import Rules

-- Types

type alias Model = {
    deck : Decks.Deck,
    selectedCard : Maybe Cards.Card,
    kingsSeen : Int,
    rules : Rules.RuleSet,
    selectedCardRule : Maybe Rules.Rule
}

emptyModel : Model
emptyModel =
    Model (Decks.Deck []) Nothing 0 (Rules.RuleSet Rules.buildBasic) Nothing

-- View

type Msg
    = NoOp
    | DeckMsg Decks.Msg
    | CardMsg Cards.Msg
    | RuleMsg Rules.Msg
    | DrawACard
    | ResetAll

view : Model -> Html.Html Msg
view model =
    Html.div [] [
        Html.a [ Html.Attributes.class "btn btn-default btn-xs", Html.Attributes.href "https://github.com/AstromechZA/kings-elm" ] [ Html.text "Go to repository" ],
        Html.div [ Html.Attributes.class "container playingCards" ] [
            Html.div [ Html.Attributes.class "row text-center main-row" ] [
                Html.a [ Html.Events.onClick DrawACard ] [
                    Html.App.map CardMsg (Cards.view model.selectedCard)
                ]
            ],
            Html.div [ Html.Attributes.class "row" ] (
                case model.selectedCardRule of
                    Just rule -> [
                        Html.div [ Html.Attributes.class "col-md-8 col-md-offset-2" ] [
                            Html.div [ Html.Attributes.class ("panel " ++ (if model.kingsSeen == 4 then "panel-danger" else "panel-default")) ] [
                                Html.div [ Html.Attributes.class "panel-heading" ] [
                                    Html.text rule.filter.description,
                                    Html.text " - ",
                                    Html.i [] [ Html.text rule.name ]
                                ],
                                Html.div [ Html.Attributes.class "panel-body" ] [
                                    Html.text rule.description
                                ]
                            ]
                        ]
                    ]
                    Nothing -> []
            ),
            Html.div [ Html.Attributes.class "row text-center" ] [
                Html.div [ Html.Attributes.class "col-md-4 col-md-offset-4" ] [
                    Html.div [ Html.Attributes.class "panel panel-default" ] [
                        Html.div [ Html.Attributes.class "panel-body" ] [
                            Html.text ((toString (List.length model.deck.cards)) ++ " cards remaining - "),
                            Html.text ((toString model.kingsSeen) ++ " kings seen")
                        ]
                    ]
                ]
            ],
            Html.App.map RuleMsg (Rules.view model.rules),
            Html.button [ Html.Events.onClick ResetAll, Html.Attributes.class "btn btn-default" ] [ Html.text "Reset" ]
        ]
    ]

-- Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- We need a way to trigger updates of nested objects, so we make sure
        -- we wrap the Msg type of the nested object and allow it to be passed
        -- through while also handling any resulting Cmds
        DeckMsg msg ->
            let
                -- call the update on the sub object
                (newdeck, newmsg) = Decks.update msg model.deck
            in
                -- apply the update to the model, and fire any upstream Cmd
                ({model | deck = newdeck}, Cmd.map DeckMsg newmsg)
        DrawACard ->
            if model.kingsSeen < 4 then
                let
                    (c, newdeck) = Decks.pop model.deck
                in
                    case c of
                        Just card ->
                            ({model | deck = newdeck
                                    , selectedCard = c
                                    , kingsSeen = model.kingsSeen + (if (card.face == Cards.king) then 1 else 0)
                                    , selectedCardRule = findRuleForCard model c
                             }, Cmd.none)
                        Nothing ->
                            (model, Cmd.none)
            else
                (model, Cmd.none)
        ResetAll ->
            let
                (emptymodel, deck) = (emptyModel, Decks.newDeck)
            in
                (emptymodel, Cmd.map DeckMsg (Decks.shuffle deck.cards))
        _ ->
            (model, Cmd.none)

findRuleForCard : Model -> Maybe Cards.Card -> Maybe Rules.Rule
findRuleForCard model card =
    case card of
        Just card ->
            List.head (List.filter (\r -> r.filter.func card) model.rules.rules)
        Nothing ->
            Nothing

-- Init

init : (Model, Cmd Msg)
init =
    -- 'let' gives us some room to define variables that we can reference.
    -- in this case we want to start with an empty deck and shuffle a new deck
    -- into it.
    let
        (emptymodel, deck) = (emptyModel, Decks.newDeck)
    in
        (emptymodel, Cmd.map DeckMsg (Decks.shuffle deck.cards))

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main = Html.App.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions}
