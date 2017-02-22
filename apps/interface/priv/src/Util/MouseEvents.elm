module Util.MouseEvents exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App exposing (map)
import Json.Decode as Decode exposing ((:=))
import DOM exposing (Rectangle)
import String

type alias Position =
  { x : Int, y : Int }

type alias MouseEvent =
  { clientPos : Position
  , targetPos : Position
  , relPos : Position
  , cls : String
  }

relPos : MouseEvent -> Position
relPos ev =
  Position (ev.clientPos.x - ev.targetPos.x) (ev.clientPos.y - ev.targetPos.y)

mouseEvent : Int -> Int -> Rectangle -> String -> MouseEvent
mouseEvent clientX clientY target cls =
  { clientPos = Position clientX clientY
  , targetPos = Position (truncate target.left) (truncate target.top)
  , relPos = Position 0 0
  , cls = cls
  }

mouseEventDecoder : Decode.Decoder MouseEvent
mouseEventDecoder =
  Decode.object4
    mouseEvent
    ("clientX" := Decode.int)
    ("clientY" := Decode.int)
    ("target" := DOM.boundingClientRect)
    (DOM.target DOM.className)

onClick : (MouseEvent -> msg) -> Html.Attribute msg
onClick target =
  on "click" (Decode.map target mouseEventDecoder)

test : msg -> Html.Attribute msg
test msg =
  on "click" (Decode.succeed msg)
