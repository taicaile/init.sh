#!/usr/bin/env bash

sudo apt install wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER
newgrp wireshark

echo "reboot may be required to be effected to capture the all the interface."
