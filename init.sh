#!/usr/bin/env bash

# check if direnv is installed
if command -v direnv &>/dev/null; then
  # activate direnv
  eval "$(direnv hook bash)"
fi

# update history size
HISTSIZE=2000
HISTFILESIZE=20000

# bash prompt theme, ref https://github.com/microsoft/vscode-dev-containers/blob/v0.202.5/containers/ubuntu/.devcontainer/library-scripts/common-debian.sh
# shellcheck disable=SC2016,SC1004
__bash_prompt() {
  # this line shall place first,
  local EXIT_CODE='`export XIT=$? && [ "$XIT" -ne "0" ] && echo -n "\033[1;91m\] $XIT | "`'
  # venv
  # local VENV='``'
  # docker
  local CONTAINER='$(grep -sq "docker" /proc/1/cgroup && echo -n "\033[4;32m\]docker➜ ")'
  # user
  local USER_PART='`[ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} ➜" || echo -n "\[\033[0;32m\]\u ➜"`'
  # git
  local GIT_BRANCH='`\
        export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
        if [ "${BRANCH}" != "" ]; then \
            echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH}" \
            && if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                    echo -n " \[\033[1;33m\]✗"; \
               fi \
            && echo -n "\[\033[0;36m\]) "; \
        fi`'
  local VENV='`[[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]] && echo -n "\[\033[4;33m\]($(basename $VIRTUAL_ENV):$(python3 --version | cut -d\  -f2))"`'
  local BG_JOBS='`[ $(jobs | wc -l) -ne 0 ] && echo -n "\033[0;31m\033[43m$(jobs | wc -l)"`'
  local LIGHT_BLUE='\[\033[1;34m\]'
  local REMOVE_COLOR='\[\033[0m\]'
  PS1=" ${EXIT_CODE}${VENV}${CONTAINER}${USER_PART} ${LIGHT_BLUE}\w ${GIT_BRANCH}$BG_JOBS${REMOVE_COLOR}\$ "
  unset -f __bash_prompt
}

__bash_prompt
export PROMPT_DIRTRIM=4


# ---- functions ----

ssh() {
  # send notify if ssh disconnected from trycloudflare
  reqsubstr=trycloudflare.com
  string="$*"
  if [ -z "${string##*$reqsubstr*}" ]; then
    /usr/bin/ssh  "$string" || notify-send "SSH" "Colab SSH Disconnected"
  else
    /usr/bin/ssh  "$string"
  fi
}
