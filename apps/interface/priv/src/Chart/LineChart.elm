module Chart.LineChart exposing (..)

import Visualization.Scale as Scale exposing (ContinuousScale, ContinuousTimeScale)
import Visualization.Axis as Axis
import Visualization.List as List
import Visualization.Shape as Shape
import Date
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date exposing (Date)
import String
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)

w : Float
w =
    375

h : Float
h =
    150

padding : Float
padding =
    35

getHistory : String -> Dict String (List (Date, { b | state : a })) -> (a -> e) -> List (Date, e)
getHistory interface_pid history get =
  case Dict.get interface_pid history of
    Just list -> List.map (\(time, d) -> ( time, (get d.state) )) (List.reverse list)
    Nothing -> []

pretty : Int -> Float -> String
pretty decimals n =
  let
    st = toString n
    parts = String.split "." st
    front = case List.head parts of
      Just a -> a
      Nothing -> "0"

    dec = case List.head (List.reverse parts) of
      Just a -> a
      Nothing -> "0"
    dec_p = if (String.length dec) >= decimals then
      String.slice 0 decimals dec
    else
      String.padRight decimals '0' dec
  in
    front ++ "." ++ dec_p

view : List ( Date, Float ) -> Svg msg
view model =
    let
        (start, s_value) = case List.head model of
          Just a -> a
          Nothing -> ( Date.fromTime 0, 0)

        (end, e_value) = case List.head (List.reverse model) of
          Just a -> a
          Nothing -> ( Date.fromTime 0, 0 )

        values = List.map (\(d, val) -> val) model

        min = case List.minimum values of
          Just m -> m
          Nothing -> 1

        max = case List.maximum values of
          Just m -> m
          Nothing -> 1
        xScale : ContinuousTimeScale
        xScale =
            Scale.time ( start, end ) ( 0, w - 2 * padding )

        yScale : ContinuousScale
        yScale =
            Scale.linear ( (min-1), max ) ( h - 2 * padding, 0 )

        opts : Axis.Options a
        opts =
            Axis.defaultOptions

        xAxis : Svg msg
        xAxis =
            Axis.axis { opts | orientation = Axis.Bottom, tickCount = 5 } xScale

        yAxis : Svg msg
        yAxis =
            Axis.axis { opts | orientation = Axis.Left, tickCount = 5, tickFormat = Just (\t -> pretty 1 t )} yScale

        areaGenerator : ( Date, Float ) -> Maybe ( ( Float, Float ), ( Float, Float ) )
        areaGenerator ( x, y ) =
            Just ( ( Scale.convert xScale x, fst (Scale.rangeExtent yScale) ), ( Scale.convert xScale x, Scale.convert yScale y ) )

        lineGenerator : ( Date, Float ) -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xScale x, Scale.convert yScale y )

        area : String
        area =
            List.map areaGenerator model
                |> Shape.area Shape.monotoneInXCurve

        line : String
        line =
            List.map lineGenerator model
                |> Shape.line Shape.linearCurve
    in
        svg [ width "100%", height "150px" ]
            [ g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString (150 - padding) ++ ")") ]
                [ xAxis ]
            , g [ transform ("translate(" ++ toString (padding) ++ ", " ++ toString padding ++ ")") ]
                [ yAxis ]
            , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), class "series" ]
                [ Svg.path [ d line, stroke "black", strokeWidth "2px", fill "none" ] []
                ]
            ]
