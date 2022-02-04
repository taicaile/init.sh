#!/usr/bin/env bash

# add swap
info "add swap file, by default it is 4GB"
sudo dd if=/dev/zero of=/swapfile4gb bs=1024 count=4194304
sudo chmod 600 /swapfile4gb
sudo mkswap /swapfile4gb
sudo swapon /swapfile4gb
echo '/swapfile4gb swap swap defaults 0 0' | sudo tee -a /etc/fstab
# verify
sudo swapon --show
