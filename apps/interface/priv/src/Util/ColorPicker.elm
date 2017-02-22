port module Util.ColorPicker exposing (..)

import Json.Encode

type alias ColorData =
  { h : Int
  , s : Int
  , v : Int
  , id : String
  }

port showColorPicker : String -> Cmd msg

port hideColorPicker : String -> Cmd msg

port gotColor : (ColorData -> msg) -> Sub msg
