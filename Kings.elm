import Html
import Html.Events
import Html.App
import Cards
import Decks

-- Types

type alias Model = {
    deck : Decks.Deck
}

-- View

type Msg = DeckMsg Decks.Msg

view : Model -> Html.Html Msg
view model =
    Html.div [] [
        Html.App.map DeckMsg (Decks.view model.deck)
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

-- Init

init : (Model, Cmd Msg)
init =
    -- 'let' gives us some room to define variables that we can reference.
    -- in this case we want to start with an empty deck and shuffle a new deck
    -- into it.
    let
        (emptymodel, deck) = (Model (Decks.Deck []), Decks.newDeck)
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
