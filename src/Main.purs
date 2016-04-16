module Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Prelude (Unit, bind, const, ($), show, (-), (+))
import Pux (renderToDOM, fromSimple, start)
import Pux.Html (Html, text, button, span, div)
import Pux.Html.Events (onClick)
import Signal.Channel (CHANNEL)

data Action = Increment | Decrement

type Model = Int

update :: Action -> Model -> Model
update Increment = (_ + 1)
update Decrement = (_ - 1)

view :: Model -> Html Action
view count =
  div
    []
    [ button [ onClick $ const Decrement ] [ text "(-)" ]
    , span [] [ text (show count) ]
    , button [ onClick $ const Increment ] [ text "(+)" ]
    ]

main :: forall eff. Eff (err :: EXCEPTION, channel :: CHANNEL | eff) Unit
main = do
  app <- start
    { initialState: 0
    , update: fromSimple update
    , view: view
    , inputs: []
    }
  renderToDOM "#app" app.html
