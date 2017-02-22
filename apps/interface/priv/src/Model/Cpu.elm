module Model.Cpu exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List CpuInterface
  , history: Dict String (List (Date, Cpu))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : Cpu -> CpuInterface
interface cpu =
    (CpuInterface cpu 0)

type alias CpuInterface =
  { device : Cpu
  , id : Int
  }

type alias Cpu =
    { event_type : String
    , state : CpuState
    , name : String
    , namespace : String
    , interface_pid : String
    , device_pid : String
    }

type alias CpuState =
    { cpu : Int
    , busy : Float
    , idle : Float
    }

decodePacket : Json.Decode.Decoder Cpu
decodePacket =
    Json.Decode.succeed Cpu
        |: ("type" := Json.Decode.string)
        |: ("state" := decodeCpuState)
        |: ("name" := Json.Decode.string)
        |: ("module" := Json.Decode.string)
        |: ("interface_pid" := Json.Decode.string)
        |: ("device_pid" := Json.Decode.string)

decodeCpuState : Json.Decode.Decoder CpuState
decodeCpuState =
    Json.Decode.succeed CpuState
        |: ("cpu" := Json.Decode.int)
        |: ("busy" := Json.Decode.float)
        |: ("idle" := Json.Decode.float)
