#!/usr/bin/env bash

# copy all fonts,
find ./ -type f -name "*.ttf" -exec cp {} ~/.local/share/fonts \;

# then,
fc-cache -fv
