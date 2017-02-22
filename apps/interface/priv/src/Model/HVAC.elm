module Model.HVAC exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
-- elm-package install --yes circuithub/elm-json-extra
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List HVACInterface
  , history: Dict String (List (Date, HVAC))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : HVAC -> HVACInterface
interface hvac =
  let
    adjusting_to =
      case hvac.state.temporary_target_cool > 0 of
        False -> hvac.state.temporary_target_heat
        True -> hvac.state.temporary_target_cool
  in
    (HVACInterface hvac adjusting_to 0)

type alias HVACInterface =
  { device : HVAC
  , adjusting_to : Float
  , id : Int
  }

type alias HVAC =
    { event_type : String
    , state : HVACState
    , name : String
    , namespace : String
    , interface_pid : String
    , device_pid : String
    }

type alias HVACState =
    { temporary_target_heat : Float
    , temporary_target_cool : Float
    , temperature : Float
    , state : String
    , mode : String
    , fan_state : String
    , fan_mode : String
    }

decodePacket : Json.Decode.Decoder HVAC
decodePacket =
    Json.Decode.succeed HVAC
        |: ("type" := Json.Decode.string)
        |: ("state" := decodeHVACState)
        |: ("name" := Json.Decode.string)
        |: ("module" := Json.Decode.string)
        |: ("interface_pid" := Json.Decode.string)
        |: ("device_pid" := Json.Decode.string)

decodeHVACState : Json.Decode.Decoder HVACState
decodeHVACState =
    Json.Decode.succeed HVACState
        |: ("temporary_target_heat" := Json.Decode.float)
        |: ("temporary_target_cool" := Json.Decode.float)
        |: ("temperature" := Json.Decode.float)
        |: ("state" := Json.Decode.string)
        |: ("mode" := Json.Decode.string)
        |: ("fan_state" := Json.Decode.string)
        |: ("fan_mode" := Json.Decode.string)

encodeHVAC : HVAC -> Json.Encode.Value
encodeHVAC record =
    Json.Encode.object
        [ ("type",  Json.Encode.string <| record.event_type)
        , ("state",  encodeHVACState <| record.state)
        , ("name",  Json.Encode.string <| record.name)
        , ("module",  Json.Encode.string <| record.namespace)
        , ("interface_pid",  Json.Encode.string <| record.interface_pid)
        , ("device_pid",  Json.Encode.string <| record.device_pid)
        ]

encodeHVACState : HVACState -> Json.Encode.Value
encodeHVACState record =
    Json.Encode.object
        [ ("temporary_target_heat",  Json.Encode.float <| record.temporary_target_heat)
        , ("temporary_target_cool",  Json.Encode.float <| record.temporary_target_cool)
        , ("temperature",  Json.Encode.float <| record.temperature)
        , ("state",  Json.Encode.string <| record.state)
        , ("mode",  Json.Encode.string <| record.mode)
        , ("fan_state",  Json.Encode.string <| record.fan_state)
        , ("fan_mode",  Json.Encode.string <| record.fan_mode)
        ]
