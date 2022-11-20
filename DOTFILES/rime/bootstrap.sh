#!/usr/bin/env bash

sudo apt install ibus-rime

CONFIG_PATH=~/.config/ibus/rime
mkdir -p $CONFIG_PATH
cp default.custom.yaml $CONFIG_PATH/
cp ibus_rime.yaml ~/.config/ibus/rime/build/
cp luna_pinyin.custom.yaml ~/.config/ibus/rime/
ibus-daemon -drx
