#!/usr/bin/env bash

sudo apt install -y \
                qemu qemu-kvm \ 
                libvirt-daemon libvirt-clients \
                bridge-utils virt-manager

sudo usermod -G libvirt -a $USER

echo "you shall reboot the pc before start the libvirt."