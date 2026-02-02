#!/usr/bin/env bash
#
# This script targets to be run first after a fresh Ubuntu VPS is started.
# It updates the system, installs common server utilities, and applies
# basic security configurations.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions for Logging ---
info() {
    printf '\033[0;32m%s\033[0m\n' "$@"
}

error() {
    printf '\033[0;31m%s\033[0m\n' "$@" >&2
}

# --- Permission Check ---
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root!"
   error "Please run it with 'sudo'."
   exit 1
fi

# --- Helper function to avoid redundant apt-get update ---
apt_get_update_if_needed() {
    # If /var/lib/apt/lists is empty, force an update.
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(find /var/lib/apt/lists/ -maxdepth 1 ! -name "$(basename /var/lib/apt/lists)" | wc -l)" = "0" ]; then
        info "Running apt-get update..."
        apt-get update
    else
        info "Skipping apt-get update as lists are already populated."
    fi
}

# --- 1. System Update and Upgrade ---
info "Updating and upgrading system packages..."
apt_get_update_if_needed
apt-get upgrade -y

# --- 2. Install Common Server Utilities ---
info "Installing common server utilities..."
apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    htop \
    vnstat \
    net-tools \
    zip \
    unzip \
    gnupg \
    locate \
    neofetch \
    lsb-release \
    ca-certificates

apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    gh

apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3

# --- 3. Install Core Services ---
info "Installing core services: Nginx and Fail2ban..."
apt-get install -y --no-install-recommends \
    nginx \
    fail2ban

info "Server setup complete!"
info "Enabled services: Nginx, Fail2ban."
