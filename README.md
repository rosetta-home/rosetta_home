# Example FW

## Installation
* Install build-essential
* Install libmnl-dev
* Install Erlang
  * Install erlang-esl
  * Install erlang-dev
  * Install erlang-xmerl
  * Install erlang-os-mon
  * Install erlang-src
  * Install erlang-eunit
  * Install erlang-parsetools
* Install Elixir 1.4
* Install Nerves
  * Install fwup
  * Install ssh-askpass
  * Install squashfs-tool
  * Install rebar and hex
  * Install bootstrap
* Install Node >= 6.1
* Install Elm 0.17.1


## Setup
`cp default.env .env`

change cipher keys to random 10 digits

`source .env`

## Build Web UI
`cd apps/interface/priv`

`elm-make src/Main.elm --output=app.js`

## Running locally
`MIX_ENV=dev mix do deps.get, deps.compile`

`MIX_ENV=dev mix compile`

`MIX_ENV=dev iex -S mix`

## Build Firmware
`cd apps/fw`

`MIX_ENV=prod mix do deps.get, deps.compile`

`MIX_ENV=prod mix firmware`

`MIX_ENV=prod mix firmware.burn`
