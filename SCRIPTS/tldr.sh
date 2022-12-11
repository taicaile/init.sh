#!/usr/bin/env bash

# this script used to install tldr
# https://github.com/tldr-pages/tldr

set -e

pip3 install tldr
tldr -u
