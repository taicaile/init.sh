#!/usr/bin/env bash

# This script targets to be run first after a fresh vps started

# update, and upgrade
sudo apt update
sudo apt upgrade

# install system metric monitor utilities
sudo apt install vnstat

# install security tool
sudo apt install fail2ban
