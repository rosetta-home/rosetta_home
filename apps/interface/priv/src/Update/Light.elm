module Update.Light exposing (..)

import Msg exposing(Msg)
import Model.Lights exposing (Model, LightInterface)
import Model.Main as Main
import Util.ColorPicker
import Config exposing(eventServer)
import WebSocket
import Json.Encode

type alias ColorCommand =
  { command_type : LightCommand
  , payload : ColorData
  }

type alias ToggleCommand =
  { command_type : LightCommand
  , id : String
  , payload : Bool
  }

type alias ColorData =
  { h : Int
  , s : Int
  , v : Int
  , id : String
  }

type LightCommand
  = LightColor
  | LightPower

encodeColorCommand : ColorCommand -> String
encodeColorCommand record =
  let
    v =
      Json.Encode.object
      [ ("type",  commandToValue record.command_type)
      , ("payload",  encodeColorData record.payload)
      ]
  in
    Json.Encode.encode 0 v

encodeToggleCommand : ToggleCommand -> String
encodeToggleCommand record =
  let
    v =
      Json.Encode.object
      [ ("type",  commandToValue record.command_type)
      , ("id" , Json.Encode.string record.id)
      , ("payload", Json.Encode.bool record.payload)
      ]
  in
    Json.Encode.encode 0 v

encodeColorData : ColorData -> Json.Encode.Value
encodeColorData record =
  Json.Encode.object
  [ ("h",  Json.Encode.int <| record.h)
  , ("s",  Json.Encode.int <| record.s)
  , ("v",  Json.Encode.int <| record.v)
  , ("id",  Json.Encode.string <| record.id)
  ]

commandToValue : LightCommand -> Json.Encode.Value
commandToValue command =
  case command of
    LightColor -> Json.Encode.string "LightColor"
    LightPower -> Json.Encode.string "LightPower"

updateLight : Model -> String -> (LightInterface -> String -> LightInterface) -> Model
updateLight model interface_pid fn =
  {model | devices = (List.map (\i ->
    if i.device.interface_pid == interface_pid then
      fn i interface_pid
    else
      i
  ) model.devices)}


update : Msg -> Main.Model -> Model -> (Model, Cmd Msg)
update msg main_model model =
  case msg of
    Msg.LightOff interface_pid ->
      let
        cmd = ToggleCommand LightPower interface_pid False
      in
        (model, WebSocket.send ("ws://"++main_model.hostname++":8081/ws") (cmd |> encodeToggleCommand))
    Msg.LightOn interface_pid ->
      let
        cmd = ToggleCommand LightPower interface_pid True
      in
        (model, WebSocket.send ("ws://"++main_model.hostname++":8081/ws") (cmd |> encodeToggleCommand))
    Msg.ShowColorPicker interface_pid ->
      (updateLight
        model
        interface_pid
        (\i id -> { i | colorPickerOpen = True }
      ), Util.ColorPicker.showColorPicker interface_pid)
    Msg.HideColorPicker interface_pid ->
      (updateLight
        model
        interface_pid
        (\i id -> { i | colorPickerOpen = False }
      ), Util.ColorPicker.hideColorPicker interface_pid)
    Msg.GotColor color->
      let
        cmd = ColorCommand LightColor color
      in
        ({model | devices = (List.map (\i ->
          if i.device.interface_pid == color.id then
            let
              d = i.device
              s = d.state
              hsbk = s.hsbk
              n_h = { hsbk | hue = color.h, saturation = color.s, brightness = color.v}
              n_s = {s | hsbk = n_h}
              n_d = {d | state = n_s }
            in
              { i | device = n_d }
          else
            i
        ) model.devices)}, WebSocket.send ("ws://"++main_model.hostname++":8081/ws") (cmd |> encodeColorCommand))
    _ -> (model, Cmd.none)
