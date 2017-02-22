module Update.HVAC exposing (..)

import Msg exposing(Msg)
import Model.HVAC exposing (Model, HVACInterface)
import Model.Main as Main
import Json.Encode
import Config exposing(eventServer)
import WebSocket

type alias HVACCommand =
  { command_type : HVACType
  , id : String
  , payload : String
  }

type HVACType
  = Temperature
  | Fan

encodeHVACCommand : HVACCommand -> String
encodeHVACCommand record =
  let
    v =
      Json.Encode.object
      [ ("type",  commandToValue record.command_type)
      , ("id", Json.Encode.string record.id)
      , ("payload",  Json.Encode.string record.payload)
      ]
  in
    Json.Encode.encode 0 v

commandToValue : HVACType -> Json.Encode.Value
commandToValue command =
  case command of
    Temperature -> Json.Encode.string "Temperature"
    Fan -> Json.Encode.string "Fan"

updateHVAC : Model -> String -> (HVACInterface -> String -> HVACInterface) -> Model
updateHVAC model interface_pid fn =
  {model | devices = (List.map (\i ->
    if i.device.interface_pid == interface_pid then
      fn i interface_pid
    else
      i
  ) model.devices)}


update : Msg -> Main.Model -> Model -> (Model, Cmd Msg)
update msg main_model model =
  case msg of
    Msg.HVACTemperatureChange interface_pid temp ->
      let
        cmd = HVACCommand Temperature interface_pid (toString temp)
      in
        (updateHVAC
          model
          interface_pid
          (\i id -> { i | adjusting_to = temp }
        ), WebSocket.send ("ws://"++main_model.hostname++":8081/ws") (cmd |> encodeHVACCommand))
    _ -> (model, Cmd.none)
