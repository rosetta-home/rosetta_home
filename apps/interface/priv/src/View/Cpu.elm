module View.Cpu exposing(..)

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
import Material.Elevation as Elevation
import Model.Cpu exposing (Cpu, CpuInterface)
import Model.Main exposing (Model)
import Msg exposing (Msg)
import Util.Layout exposing(card, viewGraph, grey)
import Date exposing (Date)
import Time exposing (Time)
import Chart.LineChart as LineChart
import Dict exposing (Dict)

type alias Mdl = Material.Model

white : Options.Property c m
white =
  Color.text Color.white

view : Model -> CpuInterface -> Material.Grid.Cell Msg
view model cpu_i =
  let
    cpu = cpu_i.device
    busy = LineChart.getHistory cpu.interface_pid model.cpu.history .busy
    idle = LineChart.getHistory cpu.interface_pid model.cpu.history .idle
    content =
      [ viewGraph model cpu.interface_pid "Busy" (toString cpu.state.busy) (lazy LineChart.view busy)
      , viewGraph model cpu.interface_pid "Idle" (toString cpu.state.idle) (lazy LineChart.view idle)
      ]
  in
    card cpu.interface_pid cpu.name "" content grey [ css "height" "450px" ]
