module View.Light exposing(..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Set exposing (Set)
import String

import Material
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Color as Color
import Material.Button as Button
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (Style, cs, css, div, nop, when)

import Model.Lights exposing (Light, LightInterface)
import Model.Main exposing (Model)

import Util.Layout exposing(card)
import Msg exposing(Msg)

type alias Align =
  ( String, Menu.Property Msg.Msg )

menu : Model -> LightInterface -> Html Msg
menu model light =
  Menu.render Msg.Mdl [ light.id ] model.mdl
    [ Menu.bottomRight
    , Menu.ripple
    , css "position" "absolute"
    , css "right" "16px"
    , css "top" "16px"
    , Color.text Color.accent
    ]
    [ Menu.item
      [ Menu.onSelect
        ( if light.colorPickerOpen then
            Msg.HideColorPicker light.device.interface_pid
          else
            Msg.ShowColorPicker light.device.interface_pid
        ) ]
      [ text
        (if light.colorPickerOpen then
          "Close Color Picker"
        else
          "Open Color Picker"
        )
      ]
    , Menu.item
      [ Menu.onSelect
        ( if light.device.state.power == 0 then
            Msg.LightOn light.device.interface_pid
          else
            Msg.LightOff light.device.interface_pid
        ) ]
      [ text
        (if light.device.state.power == 0 then
          "On"
        else
          "Off"
        )
      ]
    ]

convertToHSL : Int -> Int -> Int -> Options.Property c m
convertToHSL hue sat bright =
  let
    l = ( 2 - ((toFloat sat) / 100) ) * ( (toFloat bright) / 2 )
    l_mult = if l < 50 then
      l * 2
    else
      200 - l * 2
    h = hue
    s = (toFloat sat) * ( (toFloat bright) / l_mult )
  in
    css "background" ("hsla(" ++ (toString h) ++ ", " ++ (toString s) ++ "%, " ++ (toString l) ++ "%, 0.85)")


white : Options.Property c m
white =
  Color.text Color.white

view : Model -> LightInterface -> Material.Grid.Cell Msg.Msg
view model light =
  let
    content = [ (menu model light) ]
    hsbk = light.device.state.hsbk
    col = if light.device.state.power == 0 then
      Color.background Color.primary
    else
      convertToHSL hsbk.hue hsbk.saturation hsbk.brightness
  in
    card light.device.interface_pid light.device.name (toString light.device.state.tx) content col []
