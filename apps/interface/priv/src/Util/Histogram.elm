port module Util.Histogram exposing (..)

import Json.Encode

type alias HistogramData =
  { id : String
  , metric_type : String
  }

port showHistogram : HistogramData -> Cmd msg

port hideHistogram : HistogramData -> Cmd msg
