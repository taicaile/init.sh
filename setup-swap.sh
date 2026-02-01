#!/usr/bin/env bash
# --------------------------------------------------------------------------
#
# setup-swap.sh - Automatic SWAP Setup Script
#
# This script automates the creation or recreation of a swap file on a
# Linux system. It checks for existing swap, removes it if necessary,
# and creates a new one based on the system's physical RAM.
#
# Usage:
#
# 1. Remote execution (recommended):
#    curl -sL <URL>/setup-swap.sh | sudo bash
#
# 2. Local execution:
#    sudo ./setup-swap.sh [options]
#
# Options:
#   -h, --help    Display this help message and exit.
#
# Notes:
# - The script must be run with root privileges (e.g., using sudo).
# - It creates a swap file named /swapfile.
# - Swap size is calculated based on these rules:
#   - RAM <= 2GB:        SWAP = 2 * RAM
#   - 2GB < RAM < 32GB:  SWAP = RAM + 2GB
#   - RAM >= 32GB:       SWAP = RAM (or a fixed size like 32GB)
# --------------------------------------------------------------------------

function show_help() {
    cat <<-EOF
	setup-swap.sh - Automatic SWAP Setup Script

	This script automates the creation or recreation of a swap file on a
	Linux system. It checks for existing swap, removes it if necessary,
	and creates a new one based on the system's physical RAM.

	Usage:
	  sudo ./setup-swap.sh [options]
	  curl -sL <URL>/setup-swap.sh | sudo bash

	Options:
	  -h, --help    Display this help message and exit.

	Notes:
	- The script must be run with root privileges (e.g., using sudo).
	- It creates a swap file named /swapfile.
	EOF
}

#remove disable swap, remove it and remove entry from fstab
function remove_swap() {
    echo -e "Will remove existing swap and backup fstab.\n"

    #get the date time to help the scripts
    local backup_time
    backup_time=$(date +%y-%m-%d--%H-%M-%S)

    #get the swapfile name
    local swap_file
    swap_file=$(swapon --show --noheadings | awk '{print $1}')

    if [[ -z "$swap_file" ]]; then
        echo -e "No active swap file found to remove. Skipping.\n"
        return
    fi

    echo "--> Turning off swap for $swap_file..."
    swapoff "$swap_file"

    echo "--> Backing up /etc/fstab to /etc/fstab.$backup_time ..."
    cp /etc/fstab "/etc/fstab.${backup_time}"

    echo "--> Removing swap entry from /etc/fstab ..."
    sed -i -e "\|^${swap_file}|d" /etc/fstab

    echo "--> Removing swap file $swap_file ..."
    rm -f "$swap_file"

    echo ""
    echo "--> Done"
    echo ""
}

#spinner by: https://www.shellscript.sh/tips/spinner/
function setup_swap_spinner() {
  spinner="/|\\-/|\\-"
  while :
  do
    for i in $(seq 0 7)
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 1
    done
  done
}


#identifies available ram, calculate swap file size and configure
function create_swap() {
    echo -e "Will create a swap file and set up fstab.\n"

    #get available physical ram
    local mem_kb
    mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')

    #convert from kb to gb and round it
    local mem_gb
    mem_gb=$(printf "%.0f\n" "$(echo "$mem_kb/1024/1024" | bc -l)")

    echo -e "--> Available Physical RAM: $mem_gb GB\n"
    if [ "$mem_gb" -eq 0 ]; then
        echo "Something went wrong! Memory cannot be 0!"
        exit 1;
    fi

    local swap_size_gb
    if [ "$mem_gb" -le 2 ]; then
        echo "   Memory is less than or equal to 2 GB."
        swap_size_gb=$((mem_gb * 2))
    elif [ "$mem_gb" -gt 2 ] && [ "$mem_gb" -lt 32 ]; then
        echo "   Memory is between 2 GB and 32 GB."
        swap_size_gb=$((mem_gb + 2))
    else # >= 32
        echo "   Memory is 32 GB or more."
        swap_size_gb=$mem_gb
    fi

    local swap_file_path="/swapfile_${swap_size_gb}GB"
    echo -e "--> Recommended swap size: $swap_size_gb GB. File will be created at: $swap_file_path\n"

    echo -e "Creating the swap file! This may take a few minutes.\n"

    #implement swap file

    #start the spinner:
    setup_swap_spinner &

    #make a note of its Process ID (PID):
    local spin_pid=$!

    #kill the spinner on any signal, including our own exit.
    trap "kill -9 $spin_pid &>/dev/null" $(seq 0 15)

    #create swap file on root system and set file size to mb variable
    echo "--> Creating ${swap_size_gb}G swap file at $swap_file_path..."
    fallocate -l "${swap_size_gb}G" "$swap_file_path" || dd if=/dev/zero of="$swap_file_path" bs=1G count="$swap_size_gb" status=progress

    #set read and write permissions
    echo "--> Setting swap file permissions..."
    chmod 600 "$swap_file_path"

    #create swap area
    echo "--> Formatting swap file..."
    mkswap "$swap_file_path"

    #enable swap file for use
    echo "--> Turning on swap..."
    swapon "$swap_file_path"

    # Stop the spinner
    kill -9 "$spin_pid" &>/dev/null
    wait "$spin_pid" 2>/dev/null
    echo

    #update the fstab
    if grep -qF -- "$swap_file_path" /etc/fstab; then
        echo "--> Swap entry for $swap_file_path already exists in /etc/fstab."
    else
        echo "--> Adding swap entry to /etc/fstab for persistence..."
        echo "$swap_file_path swap swap defaults 0 0" >> /etc/fstab
    fi

    echo ""
    echo "--> Done"
    echo ""
}

#the main function that is run by the calling script.
function setup_swap_main() {
    #check if swap is on
    local is_swap_on
    is_swap_on=$(swapon --show)

    if [[ -z "$is_swap_on" ]]; then
        echo "No swap has been configured! Will create."
        echo ""

        create_swap
    else
        echo "Swap has been configured. Will remove and then re-create the swap."
        echo ""

        remove_swap
        create_swap
    fi

    echo "Setup swap complete! Check output to confirm everything is good."
}

#main start

# Handle command-line options
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

#check permissions
if [[ $EUID -ne 0 ]]; then
    echo ""
    echo "This script must be run as root! Login as root, sudo or su."
    echo ""
    exit 1;
fi

# Check for required dependencies
if ! command -v bc &> /dev/null; then
    echo "The 'bc' command is not found. Attempting to install it..."
    apt-get update && apt-get install -y bc
    echo ""
fi

# Define some colors for better output
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'
C_NC='\033[0m' # No Color

echo -e "\n${C_BLUE}--------------------------------------------------------------------------${C_NC}"
echo -e "${C_BLUE}  Automatic SWAP Setup Script${C_NC}"
echo -e "${C_BLUE}--------------------------------------------------------------------------${C_NC}\n"

echo -e "This script will automatically create or re-create a swap file (/swapfile).\n"

echo -e "${C_GREEN}The swap file size will be determined based on your system's RAM:${C_NC}"
echo "  - RAM <= 2GB:      SWAP = 2 * RAM"
echo "  - 2GB < RAM < 32GB:  SWAP = RAM + 2GB"
echo -e "  - RAM >= 32GB:     SWAP = RAM (or a fixed size)\n"

echo -e "${C_YELLOW}WARNING: This script will perform the following actions:${C_NC}"
echo -e "  1. If a swap file already exists, it will be ${C_RED}REMOVED${C_NC}."
echo "  2. A new swap file will be created, which may take several minutes."
echo -e "  3. Your /etc/fstab file will be ${C_RED}MODIFIED${C_NC} to make the swap permanent."
echo -e "     (A backup will be created, e.g., /etc/fstab.YY-MM-DD--HH-MM-SS)\n"

read -p "Do you want to proceed? (y/n): " -r proceed < /dev/tty
echo

if [[ "$proceed" =~ ^[Yy]$ ]]; then
    setup_swap_main
else
    echo "Operation cancelled by user. Exiting."
fi

echo -e "\n${C_BLUE}--------------------------------------------------------------------------${C_NC}\n"

exit 0
