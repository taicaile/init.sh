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
  local userpart='`export XIT=$? \
        && [ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} " || echo -n "\[\033[0;32m\]\u " \
        && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
  local gitbranch='`\
        export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
        if [ "${BRANCH}" != "" ]; then \
            echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH}" \
            && if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                    echo -n " \[\033[1;33m\]✗"; \
               fi \
            && echo -n "\[\033[0;36m\]) "; \
        fi`'
  local lightblue='\[\033[1;34m\]'
  local removecolor='\[\033[0m\]'
  PS1="${userpart} ${lightblue}\w ${gitbranch}${removecolor}\$ "
  unset -f __bash_prompt
}

__bash_prompt
export PROMPT_DIRTRIM=4

# show python virtual env
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename "$VIRTUAL_ENV"))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env) '$PS1

# show container
show_container() {
  if grep -sq 'docker' /proc/1/cgroup; then
    echo '[Docker]'
  fi
}
export -f show_container
PS1='$(show_container)'$PS1
