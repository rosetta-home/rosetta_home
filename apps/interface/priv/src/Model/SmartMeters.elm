module Model.SmartMeters exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
-- elm-package install --yes circuithub/elm-json-extra
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List SmartMeterInterface
  , history: Dict String (List (Date, SmartMeter))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : SmartMeter -> SmartMeterInterface
interface sm =
  (SmartMeterInterface sm 0)

type alias SmartMeterInterface =
  { device : SmartMeter
  , id : Int
  }

type alias SmartMeter =
    { event_type : String
    , state : SmartMeterState
    , name : String
    , namespace : String
    , interface_pid : String
    , device_pid : String
    }

type alias SmartMeterState =
    { signal : Int
    , price : Float
    , meter_type : String
    , meter_mac_id : String
    , kw_received : Float
    , kw_delivered : Float
    , kw: Float
    , connection_status : String
    , channel : String
    }

decodeSmartMeter : Json.Decode.Decoder SmartMeter
decodeSmartMeter =
    Json.Decode.succeed SmartMeter
        |: ("type" := Json.Decode.string)
        |: ("state" := decodeSmartMeterState)
        |: ("name" := Json.Decode.string)
        |: ("module" := Json.Decode.string)
        |: ("interface_pid" := Json.Decode.string)
        |: ("device_pid" := Json.Decode.string)

decodeSmartMeterState : Json.Decode.Decoder SmartMeterState
decodeSmartMeterState =
    Json.Decode.succeed SmartMeterState
        |: ("signal" := Json.Decode.int)
        |: ("price" := Json.Decode.float)
        |: ("meter_type" := Json.Decode.string)
        |: ("meter_mac_id" := Json.Decode.string)
        |: ("kw_received" := Json.Decode.float)
        |: ("kw_delivered" := Json.Decode.float)
        |: ("kw" := Json.Decode.float)
        |: ("connection_status" := Json.Decode.string)
        |: ("channel" := Json.Decode.string)

encodeSmartMeter : SmartMeter -> Json.Encode.Value
encodeSmartMeter record =
    Json.Encode.object
        [ ("type",  Json.Encode.string <| record.event_type)
        , ("state",  encodeSmartMeterState <| record.state)
        , ("name",  Json.Encode.string <| record.name)
        , ("module",  Json.Encode.string <| record.namespace)
        , ("interface_pid",  Json.Encode.string <| record.interface_pid)
        , ("device_pid",  Json.Encode.string <| record.device_pid)
        ]

encodeSmartMeterState : SmartMeterState -> Json.Encode.Value
encodeSmartMeterState record =
    Json.Encode.object
        [ ("signal",  Json.Encode.int <| record.signal)
        , ("price",  Json.Encode.float <| record.price)
        , ("meter_type",  Json.Encode.string <| record.meter_type)
        , ("meter_mac_id",  Json.Encode.string <| record.meter_mac_id)
        , ("kw_received",  Json.Encode.float <| record.kw_received)
        , ("kw_delivered",  Json.Encode.float <| record.kw_delivered)
        , ("connection_status",  Json.Encode.string <| record.connection_status)
        , ("channel",  Json.Encode.string <| record.channel)
        ]
