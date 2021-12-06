#!/usr/bin/bash

info() {
  printf '\E[32m'; echo "$@"; printf '\E[0m'
}


error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}


# add swap
info "add swap file, by default it is 4GB"
sudo dd if=/dev/zero of=/swapfile4gb bs=1024 count=4194304
sudo chmod 600 /swapfile4gb
sudo mkswap /swapfile4gb
sudo swapon /swapfile4gb
echo '/swapfile4gb swap swap defaults 0 0' | sudo tee -a /etc/fstab
# verify
sudo swapon --show

# install python evn
info "install python3"
sudo apt -q install -y --no-install-recommends \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev

# install mysql
info "isntall mysql"
sudo apt -q  install -y --no-install-recommends mysql-server

#
