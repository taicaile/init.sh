#!/usr/bin/env bash

#
# This script is used to initialize the vps/container for Python development
#

# exit when any command fails
set -e

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

function apt_install_if_needed {
    # if ! apt -qq list "$1" --installed 2>/dev/null | grep -qE "(installed|upgradeable)";  then
    if ! is_installed "$1"; then
        echo "$1 is not installed, install it now..."
        apt_install "$1"
    fi
}

# Function to call apt-get if needed
apt_get_update_if_needed() {
    theDir="/var/lib/apt/lists/"
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(find "$theDir" -maxdepth 1 ! -name "$(basename $theDir)" | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        sudo apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

UPGRADE_PACKAGES=${UPGRADE_PACKAGES:-"false"}
# Get to latest versions of all packages
if [ "${UPGRADE_PACKAGES}" = "true" ]; then
    info "upgrade packages"
    apt_get_update_if_needed
    sudo apt-get -y upgrade --no-install-recommends
    sudo apt-get autoremove -y
fi

info "install commanly used libraries"

apt_install_if_needed sudo

sudo apt -q install -y --no-install-recommends \
    wget \
    curl \
    neofetch \
    screenfetch \
    vim \
    git \
    htop \
    unzip \
    zip \
    nano \
    less \
    jq \
    lsb-release \
    apt-transport-https \
    lsof \
    htop \
    net-tools \
    rsync \
    ca-certificates \
    tmux \
    nano \
    systemd \
    bc \
    net-tools \
    tree
# plocate

# install python3
info "install python3"
sudo apt -q install -y --no-install-recommends \
    python3 \
    python3-distutils \
    python3-venv \
    python3-pip \
    python3-dev \
    direnv \
    shellcheck

info "install pre-commit"
# install global space
sudo -H pip3 install -q pre-commit

# install nodejs
# info "Install NodeJS"
# sudo apt -q install -y --no-install-recommends \
#    nodejs \
#    nvm

# info "Install markdownlint"
# npm install -g markdownlint-cli

# get_sudo_user() {
#     echo "${SUDO_USER:-$(logname)}"
# }

# CALLER_USERNAME=$(get_sudo_user)
# info "Call user: ${CALLER_USERNAME} detected"

# install nodejs and markdownlint,
if ! is_installed "markdownlint"; then
    info "install nodejs and markdownlint"
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh |  sudo -iu "$CALLER_USERNAME" bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

    # shellcheck disable=SC1091,SC1090
    # source "/home/$CALLER_USERNAME/.nvm/nvm.sh"

    if [ -f "${HOME}/.nvm/nvm.sh" ]; then
        source "${HOME}/.nvm/nvm.sh"
        nvm install --lts
        nvm use --lts
        npm install -g markdownlint-cli
    else
        error "file:${HOME}/.nvm/nvm.sh does not exists, exit..."
    fi
fi
