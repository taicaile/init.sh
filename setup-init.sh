#!/usr/bin/env bash

# This script is used to initialize the vps/container for Python development

info() {
  printf '\E[32m'
  echo "$@"
  printf '\E[0m'
}

error() {
  printf '\E[31m'
  echo "$@"
  printf '\E[0m'
}

function is_installed {
  command -v "$1" &>/dev/null
}

function apt_install {
  sudo apt -q install -y --no-install-recommends "$1"
}

function install_if_not {
  # if ! apt -qq list "$1" --installed 2>/dev/null | grep -qE "(installed|upgradeable)";  then
  if ! command -v "$1" &>/dev/null; then
    echo " $1 is not installed, install it now..."

  fi
}

info "commanly used libraries"
sudo apt -q install -y --no-install-recommends \
  wget \
  curl \
  neofetch \
  screenfetch \
  vim \
  git \
  htop

# install python3
info "install python3"
sudo apt -q install -y --no-install-recommends \
  python3 \
  python3-venv \
  python3-pip \
  python3-dev \
  direnv \
  pre-commit \
  shellcheck

# install nodejs and markdownlint,

if ! is_installed "markdownlint"; then
  info "nodejs and markdownlint"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  nvm install --lts
  nvm use --lts
  npm install -g markdownlint-cli
fi
