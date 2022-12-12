#!/usr/bin/env bash

echo "https://github.com/gfw-report/trojan-go"

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/gfw-report/trojan-go/releases/latest \
        | grep browser_download_url \
        | grep linux-amd64 \
        | cut -d '"' -f 4)

echo "$DOWNLOAD_URL"

# curl -s -L --create-dirs -o .download "$DOWNLOAD_URL"
