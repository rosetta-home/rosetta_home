module View.Memory exposing(..)

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
import Model.Memory exposing (Memory, MemoryInterface)
import Model.Main exposing (Model)
import Msg exposing (Msg)
import Util.Layout exposing(card, viewGraph, grey)
import Date exposing (Date)
import Time exposing (Time)
import Chart.LineChart as LineChart
import Dict exposing (Dict)
import String

type alias Mdl = Material.Model

white : Options.Property c m
white =
  Color.text Color.white

view : Model -> MemoryInterface -> Material.Grid.Cell Msg
view model memory_i =
  let
    memory = memory_i.device
    allocated = LineChart.getHistory memory.interface_pid model.memory.history .allocated
    content =
      [ viewGraph model memory.interface_pid "Allocated" (String.join " / " [(toString (memory.state.allocated/1000000000)), (toString (memory.state.total/1000000000))]) (lazy LineChart.view allocated)
      ]
  in
    card memory.interface_pid memory.name "" content grey [ css "height" "450px" ]
