# RosettaHome Installation

The installation steps below have only been tested with Ubuntu 14.04 and 16.04.

Following the installation steps below will allow you to run Rosetta Home locally as well as build the system for a [Raspberry Pi 3 Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)

The much easier path is to just download the [pre-built firmware](https://github.com/rosetta-home/rosetta_home/releases/download/v0.1.0/rosetta_home.fw) and burn it with `mix firmware.burn` this still requires you to install Nerves boostrap from the instructions below, but should work on all OS types.

Once burned and installed on a Raspberry Pi, you can follow the [setup](/SETUP.md) instructions for getting the system on WiFi.

## Installation
* Install build-essential
* Install libmnl-dev
* Install Erlang v20.1
  * Install erlang-esl
  * Install erlang-dev
  * Install erlang-xmerl
  * Install erlang-os-mon
  * Install erlang-src
  * Install erlang-eunit
  * Install erlang-parsetools
* Install [Elixir v1.5](http://elixir-lang.org/install.html#unix-and-unix-like)
* Install [Nerves](http://nerves-project.org)
  * Install fwup
  * Install ssh-askpass
  * Install squashfs-tool
  * Install rebar and hex
  * Install [bootstrap v0.6](https://github.com/nerves-project/archives/raw/master/nerves_bootstrap-0.6.0.ez)
    * You will have to go into `~/.mix/archives/nerves_bootstrap-0.6.0/` and rename `nerves_bootstrap` to `nerves_bootstrap-0.6.0` there is a bug when you install bootstrap and it's not the latest build.
* Install Node >= 6.1
* Install Elm 0.17.1


## Setup
`cp default.env .env`

change cipher keys to [random 10 digits](https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h) *remember to remove the spaces*

Update MQTT Host

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

Insert microSD card and burn it with `MIX_ENV=prod mix firmware.burn`
