#!/usr/bin/env bash

sudo apt install ibus-rime

CONFIG_PATH=~/.config/ibus/rime
mkdir -p $CONFIG_PATH/build
cp default.custom.yaml $CONFIG_PATH/
cp ibus_rime.yaml $CONFIG_PATH/build/
cp luna_pinyin.custom.yaml $CONFIG_PATH/
ibus-daemon -drx
