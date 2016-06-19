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
    rules : Rules.RuleSet
}

emptyModel : Model
emptyModel =
    Model (Decks.Deck []) Nothing 0 (Rules.RuleSet Rules.buildBasic)

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
    Html.div [ Html.Attributes.attribute "class" "playingCards" ] [
        Html.button [ Html.Events.onClick ResetAll ] [ Html.text "Reset" ],
        Html.button [ Html.Events.onClick DrawACard ] [ Html.text "Draw A Card" ],
        case model.selectedCard of
            Just card ->
                Html.App.map CardMsg (Cards.view card)
            Nothing ->
                Html.text "no card drawn"
        ,
        Html.p [] [
            Html.text ((toString (List.length model.deck.cards)) ++ " cards remaining")
        ],
        Html.p [] [
            Html.text ((toString model.kingsSeen) ++ " kings seen")
        ],
        Html.App.map DeckMsg (Decks.view model.deck),
        Html.App.map RuleMsg (Rules.view model.rules)
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
            let
                (c, newdeck) = Decks.pop model.deck
            in
                case c of
                    Just card ->
                        if card.face.symbol == "k" then
                            ({model | deck = newdeck, selectedCard = c, kingsSeen = model.kingsSeen + 1}, Cmd.none)
                        else
                            ({model | deck = newdeck, selectedCard = c}, Cmd.none)
                    Nothing ->
                        -- TODO if cards is empty
                        (model, Cmd.none)
        ResetAll ->
            let
                (emptymodel, deck) = (emptyModel, Decks.newDeck)
            in
                (emptymodel, Cmd.map DeckMsg (Decks.shuffle deck.cards))
        _ ->
            (model, Cmd.none)

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
