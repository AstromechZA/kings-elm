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
        DeckMsg msg ->
            let
                (newdeck, newmsg) = Decks.update msg model.deck
            in
                ({model | deck = newdeck}, Cmd.map DeckMsg newmsg)

-- Init

init : (Model, Cmd Msg)
init =
    let
        model = Model Decks.newDeck
    in
        (model, Cmd.map DeckMsg (Decks.shuffle model.deck.cards))

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main = Html.App.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions}
