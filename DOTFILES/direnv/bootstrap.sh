#!/usr/bin/env bash

echo "https://direnv.net/docs/installation.html"

sudo apt install direnv

USER_RC=$HOME/.bashrc
HOOK_LINE="eval \"\$(direnv hook bash)\""

grep -qF -- "$HOOK_LINE" "$USER_RC" || {
    echo "$HOOK_LINE" >>"$USER_RC"
    # shellcheck disable=SC1090
        source "$USER_RC"
}

# # check if direnv is installed
# if command -v direnv &>/dev/null; then
#   # activate direnv
#   eval "$(direnv hook bash)"
#   # `direnv hook bash` returns the string of hook function
# fi
