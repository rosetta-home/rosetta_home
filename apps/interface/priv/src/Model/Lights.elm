module Model.Lights exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
-- elm-package install --yes circuithub/elm-json-extra
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List LightInterface
  , history: Dict String (List (Date, Light))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : Light -> LightInterface
interface light =
  let
    on = if light.state.power == 0 then
      False
    else
      True
  in
    (LightInterface on False light 0)

reset : Model -> Model
reset model =
  {model | devices = (List.map (\i ->
    { i | colorPickerOpen = False }
  ) model.devices)}

type alias LightInterface =
  { on: Bool
  , colorPickerOpen : Bool
  , device : Light
  , id : Int
  }

type alias Light =
  { event_type : String
  , state : LightState
  , name : String
  , namespace : String
  , interface_pid : String
  , device_pid : String
  }

type alias LightStateHsbk =
  { saturation : Int
  , kelvin : Int
  , hue : Int
  , brightness : Int
  }

type alias LightState =
  { host : String
  , ip_port : Int
  , label : String
  , power : Int
  , signal : Float
  , rx : Int
  , tx : Int
  , hsbk : LightStateHsbk
  , group : String
  , location : String
  }

decodePacket : Json.Decode.Decoder Light
decodePacket =
  Json.Decode.succeed Light
  |: ("type" := Json.Decode.string)
  |: ("state" := decodeLightState)
  |: ("name" := Json.Decode.string)
  |: ("module" := Json.Decode.string)
  |: ("interface_pid" := Json.Decode.string)
  |: ("device_pid" := Json.Decode.string)


decodeLightStateHsbk : Json.Decode.Decoder LightStateHsbk
decodeLightStateHsbk =
  Json.Decode.succeed LightStateHsbk
  |: ("saturation" := Json.Decode.int)
  |: ("kelvin" := Json.Decode.int)
  |: ("hue" := Json.Decode.int)
  |: ("brightness" := Json.Decode.int)

decodeLightState : Json.Decode.Decoder LightState
decodeLightState =
  Json.Decode.succeed LightState
  |: ("host" := Json.Decode.string)
  |: ("port" := Json.Decode.int)
  |: ("label" := Json.Decode.string)
  |: ("power" := Json.Decode.int)
  |: ("signal" := Json.Decode.float)
  |: ("rx" := Json.Decode.int)
  |: ("tx" := Json.Decode.int)
  |: ("hsbk" := decodeLightStateHsbk)
  |: ("group" := Json.Decode.string)
  |: ("location" := Json.Decode.string)

encodeLight : Light -> Json.Encode.Value
encodeLight record =
  Json.Encode.object
  [ ("type",  Json.Encode.string <| record.event_type)
  , ("state",  encodeLightState <| record.state)
  , ("name",  Json.Encode.string <| record.name)
  , ("module",  Json.Encode.string <| record.namespace)
  , ("interface_pid",  Json.Encode.string <| record.interface_pid)
  , ("device_pid",  Json.Encode.string <| record.device_pid)
  ]

encodeLightStateHsbk : LightStateHsbk -> Json.Encode.Value
encodeLightStateHsbk record =
  Json.Encode.object
  [ ("saturation",  Json.Encode.int <| record.saturation)
  , ("kelvin",  Json.Encode.int <| record.kelvin)
  , ("hue",  Json.Encode.int <| record.hue)
  , ("brightness",  Json.Encode.int <| record.brightness)
  ]

encodeLightState : LightState -> Json.Encode.Value
encodeLightState record =
  Json.Encode.object
  [ ("tx",  Json.Encode.int <| record.tx)
  , ("signal",  Json.Encode.float <| record.signal)
  , ("rx",  Json.Encode.int <| record.rx)
  , ("power",  Json.Encode.int <| record.power)
  , ("port",  Json.Encode.int <| record.ip_port)
  , ("location",  Json.Encode.string <| record.location)
  , ("label",  Json.Encode.string <| record.label)
  , ("hsbk",  encodeLightStateHsbk <| record.hsbk)
  , ("host",  Json.Encode.string <| record.host)
  , ("group",  Json.Encode.string <| record.group)
  ]
