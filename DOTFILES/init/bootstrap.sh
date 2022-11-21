#!/usr/bin/env bash

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

cp init.sh ~
USER_RC=$HOME/.bashrc
INIT_HOOK_LINE="source ~/init.sh"
grep -qF -- "$INIT_HOOK_LINE" "$USER_RC" || {
    echo "$INIT_HOOK_LINE" >>"$USER_RC"
    # shellcheck disable=SC1090
        source "$USER_RC"
}
