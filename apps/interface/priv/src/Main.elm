import Http
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Date exposing (Date)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options exposing (css)
import Material.Layout as Layout
import Material.Icon as Icon
import Material.Color as Color
import Material.Progress as Loading
import Material.Typography as Typography
import Material.Grid exposing (grid, cell, size, Device(..))
import Material.Options as Options exposing (Style)
import Material.Menu as Menu
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Dict exposing (Dict)
import WebSocket
import Util.ColorPicker
import Util.Histogram
import Debug
import Task as Task

-- MediaPlayers
import Model.MediaPlayers as MediaPlayers
import View.MediaPlayer
-- Lights
import Model.Lights as Lights
import View.Light
import Update.Light
-- IEQ
import Model.IEQ as IEQ
import View.IEQ
-- HVAC
import Model.HVAC as HVAC
import View.HVAC
import Update.HVAC
-- WeatherStations
import Model.WeatherStations as WeatherStations
import View.WeatherStation
-- SmartMeters
import Model.SmartMeters as SmartMeters
import View.SmartMeter
-- Cpus
import Model.Cpu as Cpu
import View.Cpu
-- Memory
import Model.Memory as Memory
import View.Memory
-- DeviceMetrics
import Model.DeviceMetrics exposing(..)
-- Main
import Model.Main exposing (Model, model)
import Config exposing(eventServer)
import Msg exposing(Msg)

historyLength : Int
historyLength = 120

white : Options.Property c m
white =
  Color.text Color.white

type alias Event =
  { event_type : EventType
  , interface_pid: String
  }

type EventType
  = HVAC
  | Light
  | MediaPlayer
  | SmartMeter
  | WeatherStation
  | IEQ
  | Cpu
  | Memory
  | Unknown

event =
  succeed Event
    |: (("type" := string) `andThen` decodeEventType)
    |: ("interface_pid" := string)


decodeEventType : String -> Decoder EventType
decodeEventType event_type = succeed (eventType event_type)

eventType : String -> EventType
eventType event_type =
  case event_type of
    "hvac" -> HVAC
    "light" -> Light
    "media_player" -> MediaPlayer
    "smart_meter" -> SmartMeter
    "weather_station" -> WeatherStation
    "ieq" -> IEQ
    "cpu" -> Cpu
    "memory" -> Memory
    _ -> Unknown

-- UPDATE

decodeDevice : Decoder a -> String -> Maybe a
decodeDevice decoder payload =
  case (decodeString decoder payload) of
    Ok d -> Just d
    Err _ -> Nothing

deviceList : List { d | id : Int, device : { a | interface_pid: String }}
  -> { a | interface_pid: String }
  -> ( { a | interface_pid : String }
    -> { d | id : Int, device : { a | interface_pid : String } }
  )
  -> List { d | id : Int, device : { a | interface_pid: String }}
deviceList list device interface =
  case List.any (\d -> d.device.interface_pid == device.interface_pid) list of
    True ->
      List.indexedMap (\i d ->
        case d.device.interface_pid == device.interface_pid of
          True -> { d | id = i, device = device}
          False -> { d | id = i }
      ) list
    False ->
      (interface device) :: list

updateHistory : { b | state: a, interface_pid: String }
  -> Dict String (List (Date, { b | state : a, interface_pid : String }))
  -> Time
  -> Dict String (List (Date, { b | state : a, interface_pid : String }))
updateHistory device history time =
  case Dict.get device.interface_pid history of
    Just h -> Dict.update device.interface_pid (\l -> Just (List.take historyLength ((Date.fromTime time, device) :: h))) history
    Nothing -> Dict.insert device.interface_pid [(Date.fromTime time, device)] history

updateModel : { c
    | devices : List { d | id : Int, device : { b | interface_pid : String, state : a }}
    , history : Dict String (List (Date, { b | interface_pid : String, state : a }))
  }
  -> String
  -> Decoder { b | state : a, interface_pid : String }
  -> ( { b | interface_pid : String, state : a }
    -> { d | id : Int, device : { b | interface_pid : String, state : a } }
  )
  -> Time
  -> { c | devices : List { d | id : Int, device : { b | state : a, interface_pid : String }}
    , history : Dict String (List (Date, { b | interface_pid : String, state : a }))
  }
updateModel model payload decoder interface time =
  let
    ( devices, history ) = case decodeDevice decoder payload of
      Just d ->
        ( deviceList model.devices d interface
        , updateHistory d model.history time
        )
      Nothing -> ( model.devices, model.history )
  in
    {model | devices = devices, history = history}

updateLastHistory : { a | history : Dict String (List (Date, b)) } -> Time -> { a | history : Dict String (List (Date, b)) }
updateLastHistory model time =
  let
    history = Dict.map (\k list ->
      case List.head list of
        Just (t, device) -> List.take historyLength ((Date.fromTime time, device) :: list)
        Nothing -> list
    ) model.history
  in
    { model | history = history }

handleDeviceEvent : String -> Model -> (Model, Cmd Msg)
handleDeviceEvent payload model =
  case decodeString event payload of
    Ok evt ->
      case evt.event_type of
        Light ->
          let
            lights = updateModel model.lights payload Lights.decodePacket Lights.interface model.time
          in
            ({model | lights = lights}, Cmd.none)
        MediaPlayer ->
          let
            media_players = updateModel model.media_players payload MediaPlayers.decodeMediaPlayer MediaPlayers.interface model.time
          in
            ({model | media_players = media_players}, Cmd.none)
        IEQ ->
          let
            ieq = updateModel model.ieq payload IEQ.decodeIEQ IEQ.interface model.time
          in
            ({model | ieq = ieq}, Cmd.none)
        WeatherStation ->
          let
            weather_stations = updateModel model.weather_stations payload WeatherStations.decodeWeatherStation WeatherStations.interface model.time
          in
            ({model | weather_stations = weather_stations}, Cmd.none)
        SmartMeter ->
          let
            smart_meters = updateModel model.smart_meters payload SmartMeters.decodeSmartMeter SmartMeters.interface model.time
          in
            ({model | smart_meters = smart_meters}, Cmd.none)
        HVAC ->
          let
            hvac = updateModel model.hvac payload HVAC.decodePacket HVAC.interface model.time
          in
            ({model | hvac = hvac}, Cmd.none)
        Cpu ->
          let
            cpu = updateModel model.cpu payload Cpu.decodePacket Cpu.interface model.time
          in
            ({model | cpu = cpu}, Cmd.none)
        Memory ->
          let
            memory = updateModel model.memory payload Memory.decodePacket Memory.interface model.time
          in
            ({model | memory = memory}, Cmd.none)

        _ -> (model, Cmd.none)
    Err _ -> (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msg.LightOn id ->
      let
        (lights, cmd) = Update.Light.update msg model model.lights
      in
        ({ model | lights = lights}, cmd)
    Msg.LightOff id ->
      let
        (lights, cmd) = Update.Light.update msg model model.lights
      in
        ({ model | lights = lights}, cmd)
    Msg.ShowColorPicker id ->
      let
        (lights, cmd) = Update.Light.update msg model model.lights
      in
        ({ model | lights = lights}, cmd)
    Msg.HideColorPicker id ->
      let
        (lights, cmd) = Update.Light.update msg model model.lights
      in
        ({ model | lights = lights}, cmd)
    Msg.GotColor color ->
      let
        (lights, cmd) = Update.Light.update msg model model.lights
      in
        ({ model | lights = lights}, cmd)
    Msg.ShowHistogram data ->
      let
        model = { model | histograms = (data.id++data.metric_type) :: model.histograms }
      in
        (model, Util.Histogram.showHistogram data)
    Msg.HideHistogram data ->
      let
        h = Debug.log "Histograms" model.histograms
        model = { model | histograms = List.filter (\h -> h /= (data.id++data.metric_type)) model.histograms }
      in
        (model, Util.Histogram.hideHistogram data)
    Msg.DeviceEvent payload ->
      if model.time > 0 then
        handleDeviceEvent payload model
      else
        (model, Cmd.none)

    Msg.HVACTemperatureChange interface_pid temp ->
      let
        (hvac, cmd) = Update.HVAC.update msg model model.hvac
      in
        ({model | hvac = hvac}, cmd)
    Msg.SelectTab tab ->
      { model | selectedTab = tab, lights = (Lights.reset model.lights), histograms = []} ! []
    Msg.Mdl msg -> Material.update msg model
    Msg.Tick time ->
      let
        --hvac = updateLastHistory model.hvac time
        ieq = updateLastHistory model.ieq time
        --lights = updateLastHistory model.lights time
        --mp = updateLastHistory model.media_players time
        sm = updateLastHistory model.smart_meters time
        ws = updateLastHistory model.weather_stations time
        cpu = updateLastHistory model.cpu time
        memory = updateLastHistory model.memory time
      in
        (
          { model | time = time
          , ieq = ieq
          , smart_meters = sm
          , weather_stations = ws
          , cpu = cpu
          , memory = memory
          }
        , Cmd.none
        )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ WebSocket.listen ("ws://"++model.hostname++":8081/ws") Msg.DeviceEvent
    , Layout.subs Msg.Mdl model.mdl
    , Time.every second Msg.Tick
    , Menu.subs Msg.Mdl model.mdl
    , Util.ColorPicker.gotColor Msg.GotColor
    ]

-- VIEW

header : Model -> List (Html Msg)
header model =
  [ Layout.row
    [ css "padding" "10px"
    , Color.background (Color.primary)
    ]
    [ h5 [] [ text "Rosetta Home 2.0" ]
    , Options.styled p
      [ Typography.caption
      , Color.text Color.primaryContrast
      , css "position" "absolute"
      , css "right" "10px"
      ] [ text (toString model.time) ]
    ]
  ]

view : Model -> Html Msg
view model =
  Layout.render Msg.Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.scrolling
    , Layout.selectedTab model.selectedTab
    , Layout.onSelectTab Msg.SelectTab
    ]
    { header = header model
    , drawer = []
    , tabs = ( [ text "Lights", text "Media Players", text "IEQ", text "Weather Stations", text "HVAC", text "Smart Meters", text "CPU", text "Memory", text "_____" ], [ Color.background Color.primaryDark ] )
    , main = [viewBody model]
    }


viewBody : Model -> Html Msg
viewBody model =
  case model.selectedTab of
    0 -> displayTab model model.lights View.Light.view
    1 -> displayTab model model.media_players View.MediaPlayer.view
    2 -> displayTab model model.ieq View.IEQ.view
    3 -> displayTab model model.weather_stations View.WeatherStation.view
    4 -> displayTab model model.hvac View.HVAC.view
    5 -> displayTab model model.smart_meters View.SmartMeter.view
    6 -> displayTab model model.cpu View.Cpu.view
    7 -> displayTab model model.memory View.Memory.view
    8 -> displayTab model model.memory View.Memory.view
    _ -> text "404"


displayTab : Model -> { a | devices: List b } -> (Model -> b -> Material.Grid.Cell c) -> Html c
displayTab model typ view =
  if List.length typ.devices == 0 then
    grid [] [ cell [ Material.Grid.size All 4 ] [ Loading.indeterminate ] ]
  else
    grid [] (List.map (view model) typ.devices)

type alias Flags = { hostname: String }

init : Maybe Flags -> ( Model, Cmd Msg )
init flags =
    case flags of
      Just f -> { model | hostname = f.hostname, mdl =  Layout.setTabsWidth 600 model.mdl} ! [Layout.sub0 Msg.Mdl]
      Nothing -> { model | hostname = "rosetta.local", mdl =  Layout.setTabsWidth 600 model.mdl} ! [Layout.sub0 Msg.Mdl]


main =
  App.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
