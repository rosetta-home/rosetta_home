module Model.DeviceMetrics exposing (..)

import Json.Decode exposing ((:=), object2, object3)
-- elm-package install --yes circuithub/elm-json-extra
import Json.Decode.Extra exposing ((|:))

type alias HistoryItem =
  { metric : String
  , datapoint : String
  , values : List Float
  }

type alias DeviceMetrics =
  { id : String
  , history : List HistoryItem
  }

decodeDeviceMetrics : Json.Decode.Decoder DeviceMetrics
decodeDeviceMetrics =
  Json.Decode.object2
    DeviceMetrics
    ("id" := Json.Decode.string)
    ("history" := Json.Decode.list decodeHistory)

decodeHistory : Json.Decode.Decoder HistoryItem
decodeHistory =
  Json.Decode.object3
    HistoryItem
    ("metric" := Json.Decode.string)
    ("datapoint" := Json.Decode.string)
    ("values" := Json.Decode.list Json.Decode.float)
