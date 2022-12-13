#!/usr/bin/env bash

echo "https://github.com/hacdias/webdav"

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/hacdias/webdav/releases/latest \
        | grep browser_download_url \
        | grep linux-amd64 \
        | cut -d '"' -f 4)

echo "$DOWNLOAD_URL"

# curl -s -L --create-dirs -o .download "$DOWNLOAD_URL"

cat <<'END'
On windows, you need to use the following url to connect the server,

Open file browser, type http://server-ip:8080/ , then type the user name and password

Or, right click the `This PC`, click the `Map network drive...`, then add the url,

http://server-ip:8080

or,
\\server-ip@8080\

You may also need to check the `Connect using different credentials` if auth is required.

On Ubuntu, you can use the
dav://server-ip:8080/

END
