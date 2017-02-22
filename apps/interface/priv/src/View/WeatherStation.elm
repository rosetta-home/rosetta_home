module View.WeatherStation exposing(..)

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
import Model.WeatherStations exposing (WeatherStation, WeatherStationInterface)
import Model.Main exposing (Model)
import Msg exposing (Msg)
import Util.Layout exposing(card, viewGraph, grey)
import Date exposing (Date)
import Time exposing (Time)
import Chart.LineChart as LineChart
import Dict exposing (Dict)

type alias Mdl = Material.Model

view : Model -> WeatherStationInterface -> Material.Grid.Cell Msg
view model weather_station_i =
  let
    weather_station = weather_station_i.device
    indoor_temp = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .indoor_temperature
    outdoor_temp = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .outdoor_temperature
    humidity = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .humidity
    pressure = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .pressure
    rain = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .rain
    uv = LineChart.getHistory weather_station.interface_pid model.weather_stations.history .uv
    content =
      [ viewGraph model weather_station.interface_pid "Indoor Temperature" (toString weather_station.state.indoor_temperature) (lazy LineChart.view indoor_temp)
      , viewGraph model weather_station.interface_pid "Outdoor Temperature" (toString weather_station.state.outdoor_temperature) (lazy LineChart.view outdoor_temp)
      , viewGraph model weather_station.interface_pid "Humidity" (toString weather_station.state.humidity) (lazy LineChart.view humidity)
      , viewGraph model weather_station.interface_pid "Pressure" (toString weather_station.state.pressure) (lazy LineChart.view pressure)
      , viewGraph model weather_station.interface_pid "Rain" ((toString (weather_station.state.rain*0.01))++"\"") (lazy LineChart.view rain)
      , viewGraph model weather_station.interface_pid "UV" (toString weather_station.state.uv) (lazy LineChart.view uv)
      ]
  in
    card weather_station.interface_pid weather_station.name "" content grey [ css "height" "1200px" ]
