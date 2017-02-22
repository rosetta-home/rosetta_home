module Model.IEQ exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
-- elm-package install --yes circuithub/elm-json-extra
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List IEQInterface
  , history: Dict String (List (Date, IEQ))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : IEQ -> IEQInterface
interface ieq =
  (IEQInterface ieq 0)

type alias IEQInterface =
  { device : IEQ
  , id : Int
  }

type alias IEQ =
  { event_type : String
  , state : IEQState
  , name : String
  , namespace : String
  , interface_pid : String
  , device_pid : String
  }

type alias IEQState =
  { voc : Float
  , uv : Float
  , temperature : Float
  , sound : Float
  , rssi : Float
  , pressure : Float
  , pm : Float
  , no2 : Float
  , motion : Float
  , light : Float
  , id : String
  , humidity : Float
  , energy : Float
  , door : Float
  , co2 : Float
  , co : Float
  , battery : Float
  }

decodeIEQ : Json.Decode.Decoder IEQ
decodeIEQ =
    Json.Decode.succeed IEQ
        |: ("type" := Json.Decode.string)
        |: ("state" := decodeIEQState)
        |: ("name" := Json.Decode.string)
        |: ("module" := Json.Decode.string)
        |: ("interface_pid" := Json.Decode.string)
        |: ("device_pid" := Json.Decode.string)

decodeIEQState : Json.Decode.Decoder IEQState
decodeIEQState =
    Json.Decode.succeed IEQState
        |: ("voc" := Json.Decode.float)
        |: ("uv" := Json.Decode.float)
        |: ("temperature" := Json.Decode.float)
        |: ("sound" := Json.Decode.float)
        |: ("rssi" := Json.Decode.float)
        |: ("pressure" := Json.Decode.float)
        |: ("pm" := Json.Decode.float)
        |: ("no2" := Json.Decode.float)
        |: ("motion" := Json.Decode.float)
        |: ("light" := Json.Decode.float)
        |: ("id" := Json.Decode.string)
        |: ("humidity" := Json.Decode.float)
        |: ("energy" := Json.Decode.float)
        |: ("door" := Json.Decode.float)
        |: ("co2" := Json.Decode.float)
        |: ("co" := Json.Decode.float)
        |: ("battery" := Json.Decode.float)

encodeIEQ : IEQ -> Json.Encode.Value
encodeIEQ record =
    Json.Encode.object
        [ ("type",  Json.Encode.string <| record.event_type)
        , ("state",  encodeIEQState <| record.state)
        , ("name",  Json.Encode.string <| record.name)
        , ("module",  Json.Encode.string <| record.namespace)
        , ("interface_pid",  Json.Encode.string <| record.interface_pid)
        , ("device_pid",  Json.Encode.string <| record.device_pid)
        ]

encodeIEQState : IEQState -> Json.Encode.Value
encodeIEQState record =
    Json.Encode.object
        [ ("voc",  Json.Encode.float <| record.voc)
        , ("uv",  Json.Encode.float <| record.uv)
        , ("temperature",  Json.Encode.float <| record.temperature)
        , ("sound",  Json.Encode.float <| record.sound)
        , ("rssi",  Json.Encode.float <| record.rssi)
        , ("pressure",  Json.Encode.float <| record.pressure)
        , ("pm",  Json.Encode.float <| record.pm)
        , ("no2",  Json.Encode.float <| record.no2)
        , ("motion",  Json.Encode.float <| record.motion)
        , ("light",  Json.Encode.float <| record.light)
        , ("id",  Json.Encode.string <| record.id)
        , ("humidity",  Json.Encode.float <| record.humidity)
        , ("energy",  Json.Encode.float <| record.energy)
        , ("door",  Json.Encode.float <| record.door)
        , ("co2",  Json.Encode.float <| record.co2)
        , ("co",  Json.Encode.float <| record.co)
        , ("battery",  Json.Encode.float <| record.battery)
        ]
