module View.IEQ exposing(..)

import Html exposing (..)
import Html.Lazy exposing(lazy)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material
import Material.Button as Button
import Material.Options exposing (css)
import Material.Color as Color
import Material.Card as Card
import Material.Icon as Icon
import Material.Typography as Typography
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Options as Options exposing (Style)
import Model.IEQ exposing (IEQ, IEQInterface)
import Model.Main exposing (Model)
import Msg exposing (Msg)
import Date exposing (Date)
import Time exposing (Time)
import Chart.LineChart as LineChart
import Dict exposing (Dict)
import Util.Layout exposing(card, viewGraph, grey)

view : Model -> IEQInterface -> Material.Grid.Cell Msg
view model ieq_interface =
  let
    ieq = ieq_interface.device
    co2 = LineChart.getHistory ieq.interface_pid model.ieq.history .co2
    voc = LineChart.getHistory ieq.interface_pid model.ieq.history .voc
    temp = LineChart.getHistory ieq.interface_pid model.ieq.history .temperature
    humidity = LineChart.getHistory ieq.interface_pid model.ieq.history .humidity
    light = LineChart.getHistory ieq.interface_pid model.ieq.history .light
    co = LineChart.getHistory ieq.interface_pid model.ieq.history .co
    --pressure = LineChart.getHistory ieq.interface_pid model.ieq.history .pressure
    --sound = LineChart.getHistory ieq.interface_pid model.ieq.history .sound
    --energy = LineChart.getHistory ieq.interface_pid model.ieq.history .energy
    --rssi = LineChart.getHistory ieq.interface_pid model.ieq.history .rssi
    content =
      [ viewGraph model ieq.interface_pid "CO2" (toString ieq.state.co2) (lazy LineChart.view co2)
      --, viewGraph model ieq.interface_pid "Energy" (toString ieq.state.energy) (lazy LineChart.view energy)
      , viewGraph model ieq.interface_pid "VOC" (toString ieq.state.voc) (lazy LineChart.view voc)
      , viewGraph model ieq.interface_pid "Temperature" (toString ieq.state.temperature) (lazy LineChart.view temp)
      , viewGraph model ieq.interface_pid "Humidity" (toString ieq.state.humidity) (lazy LineChart.view humidity)
      , viewGraph model ieq.interface_pid "Light" (toString ieq.state.light) (lazy LineChart.view light)
      , viewGraph model ieq.interface_pid "CO" (toString ieq.state.co) (lazy LineChart.view co)
      --, viewGraph model ieq.interface_pid "Pressure" (toString ieq.state.pressure) (lazy LineChart.view pressure)
      --, viewGraph model ieq.interface_pid "Sound" (toString ieq.state.sound) (lazy LineChart.view sound)
      --, viewGraph model ieq.interface_pid "RSSI" (toString ieq.state.rssi) (lazy LineChart.view rssi)
      ]
  in
    card ieq.interface_pid ieq.name "" content grey [ css "height" "1175px" ]
