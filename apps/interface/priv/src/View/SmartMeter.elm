module View.SmartMeter exposing(..)

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
import Model.SmartMeters exposing (SmartMeter, SmartMeterInterface)
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

view : Model -> SmartMeterInterface -> Material.Grid.Cell Msg
view model smart_meter_i =
  let
    smart_meter = smart_meter_i.device
    delivered = LineChart.getHistory smart_meter.interface_pid model.smart_meters.history .kw_delivered
    received = LineChart.getHistory smart_meter.interface_pid model.smart_meters.history .kw_received
    demand = LineChart.getHistory smart_meter.interface_pid model.smart_meters.history .kw
    content =
      [ viewGraph model smart_meter.interface_pid "KW" (toString smart_meter.state.kw) (lazy LineChart.view demand)
      , viewGraph model smart_meter.interface_pid "KW Delivered" (toString smart_meter.state.kw_delivered) (lazy LineChart.view delivered)
      , viewGraph model smart_meter.interface_pid "KW Received" (toString smart_meter.state.kw_received) (lazy LineChart.view received)
      ]
  in
    card smart_meter.interface_pid smart_meter.name "" content grey [ css "height" "800px" ]
