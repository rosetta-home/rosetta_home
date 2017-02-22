module View.MediaPlayer exposing(..)

import Html exposing (..)
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
import Model.MediaPlayers exposing (MediaPlayer, MediaPlayerInterface)
import Model.Main exposing (Model)
import Msg exposing (Msg)
import String
import Util.Layout exposing(card, grey)

view : Model -> MediaPlayerInterface -> Material.Grid.Cell Msg
view model media_player =
  let
    url = "url('" ++ media_player.device.state.image.url ++ "') center / cover"
    content =
      [ Options.div
          [ css "background" url
          , css "width" "100%"
          , css "height" "80%"
          ]
          [ ]
      ]
    title = if String.isEmpty media_player.device.state.title then
      media_player.device.name
    else
      media_player.device.state.title
  in
    card media_player.device.interface_pid title "" content grey []
