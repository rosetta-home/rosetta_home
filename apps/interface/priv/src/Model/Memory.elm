module Model.Memory exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

type alias Model =
  { devices: List MemoryInterface
  , history: Dict String (List (Date, Memory))
  }

model : Model
model =
  { devices = []
  , history = Dict.empty
  }

interface : Memory -> MemoryInterface
interface memory =
    (MemoryInterface memory 0)

type alias MemoryInterface =
  { device : Memory
  , id : Int
  }

type alias Memory =
    { event_type : String
    , state : MemoryState
    , name : String
    , namespace : String
    , interface_pid : String
    , device_pid : String
    }

type alias MemoryState =
    { total : Float
    , allocated : Float
    }

decodePacket : Json.Decode.Decoder Memory
decodePacket =
    Json.Decode.succeed Memory
        |: ("type" := Json.Decode.string)
        |: ("state" := decodeMemoryState)
        |: ("name" := Json.Decode.string)
        |: ("module" := Json.Decode.string)
        |: ("interface_pid" := Json.Decode.string)
        |: ("device_pid" := Json.Decode.string)

decodeMemoryState : Json.Decode.Decoder MemoryState
decodeMemoryState =
    Json.Decode.succeed MemoryState
        |: ("total" := Json.Decode.float)
        |: ("allocated" := Json.Decode.float)
