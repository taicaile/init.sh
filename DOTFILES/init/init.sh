#!/usr/bin/env bash

# 交互式模式的初始化脚本
# 防止被加载两次
if [ -z "$_INIT_SH_LOADED" ]; then
    _INIT_SH_LOADED=1
else
    return
fi

# 如果是非交互式则退出，比如 bash test.sh 这种调用 bash 运行脚本时就不是交互式
# 只有直接敲 bash 进入的等待用户输入命令的那种模式才成为交互式，才往下初始化
case "$-" in
    *i*) ;;
    *) return
esac

appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# set PATH so it includes user's private bin if it exists
PRIVATE_BINS=("$HOME/bin" "$HOME/.local/bin")

for PRIVATE_BIN in "${PRIVATE_BINS[@]}"; do
  if [ -d "$PRIVATE_BIN" ]; then
    # PATH="$PRIVATE_BIN:$PATH"
    appendpath "$PRIVATE_BIN"
  fi
done

# initialize bash prompt
# add some commonly used functions

# update history size
HISTSIZE=2000
HISTFILESIZE=20000

# get command execution time
function roundseconds() {
  # rounds a number to 3 decimal places
  echo m="$1;h=0.5;scale=4;t=1000;if(m<0) h=-0.5;a=m*t+h;scale=3;a/t;" | bc
}

function bash_getstarttime() {
  # places the epoch time in ns into shared memory
  date +%s.%N >"/dev/shm/${USER}.bashtime.${1}"
}

function bash_getstoptime() {
  # reads stored epoch time and subtracts from current
  local endtime
  endtime=$(date +%s.%N)
  local starttime
  starttime=$(cat /dev/shm/"${USER}".bashtime."${1}")
  roundseconds "$(echo "$endtime - $starttime" | bc)"
}

ROOTPID=$BASHPID
bash_getstarttime $ROOTPID

# set the PS0 variable,
# shellcheck disable=SC2016,SC2034
PS0='$(bash_getstarttime $ROOTPID)'

# bash prompt theme, ref https://github.com/microsoft/vscode-dev-containers/blob/v0.202.5/containers/ubuntu/.devcontainer/library-scripts/common-debian.sh
# shellcheck disable=SC2016,SC1004
__bash_prompt() {
  get_model() {
    local model=""
    if [[ -d "/system/app/" && -d "/system/priv-app" ]]; then
      model+="$(getprop ro.product.brand) $(getprop ro.product.model)"

    elif [[ -f /sys/devices/virtual/dmi/id/product_name ||
      -f /sys/devices/virtual/dmi/id/product_version ]]; then
      model+="$(</sys/devices/virtual/dmi/id/product_name)"
      model+=" $(</sys/devices/virtual/dmi/id/product_version)"

    elif [[ -f /sys/firmware/devicetree/base/model ]]; then
      model+="$(</sys/firmware/devicetree/base/model)"

    elif [[ -f /tmp/sysinfo/model ]]; then
      model+="$(</tmp/sysinfo/model)"
    fi

    # Remove dummy OEM info.
    model="${model//To be filled by O.E.M./}"
    model="${model//To Be Filled*/}"
    model="${model//OEM*/}"
    model="${model//Not Applicable/}"
    model="${model//System Product Name/}"
    model="${model//System Version/}"
    model="${model//Undefined/}"
    model="${model//Default string/}"
    model="${model//Not Specified/}"
    model="${model//Type1ProductConfigId/}"
    model="${model//INVALID/}"
    model="${model//�/}"
    echo "$model" | xargs echo -n
  }
  # this line shall place first,
  local EXIT_CODE='`export XIT=$? && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;91m\] $XIT |"`'
  # docker
  local MODEL
  MODEL=$(get_model)
  # local CONTAINER=$([ "$(ls -ali / | sed '2!d' | awk {'print $1'})" != "2" ] && echo -n "\033[4;31m\]$MODEL\033[0;31m\] ➜ ")
  local HYPERVISOR
  HYPERVISOR=$(systemd-detect-virt | sed 's/none//')
  local CONTAINER
  CONTAINER=$([[ -n "$HYPERVISOR" ]] && echo -n "\[\033[4;33m\]($HYPERVISOR)\[\033[0;33m\] \[\033[4;31m\]$MODEL\[\033[0;31m\] ➜ ")
  # user
  local USER_PART='`[ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} ➜" || echo -n "\[\033[0;32m\]\u@$HOSTNAME ➜"`'
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
  # venv
  local VENV='`[[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]] \
        && echo -n "\[\033[4;33m\]($(basename "$VIRTUAL_ENV"):$(python3 --version | cut -d\  -f2))\[\033[0m\] "`'
  local BG_JOBS='`[ $(jobs | wc -l) -ne 0 ] && echo -n "\033[0;31m\033[43m$(jobs | wc -l) "`'
  local LIGHT_BLUE='\[\033[1;34m\]'
  local REMOVE_COLOR='\[\033[0m\]'
  local EXECUTION_TIME='\[\033[1;33m\] $(bash_getstoptime $ROOTPID)s\n'
  PS1="${EXIT_CODE}${EXECUTION_TIME} ${VENV}${CONTAINER}${USER_PART} ${LIGHT_BLUE}\w ${GIT_BRANCH}$BG_JOBS${REMOVE_COLOR}\$ "
  unset -f __bash_prompt
}

__bash_prompt
export PROMPT_DIRTRIM=4

function runonexit() {
  rm /dev/shm/"${USER}".bashtime.${ROOTPID}
}

trap runonexit EXIT

# ---- functions ----

sshnotify() {
  # send notify if ssh disconnected from trycloudflare
  reqsubstr=trycloudflare.com
  string="$*"
  if [ -z "${string##*$reqsubstr*}" ]; then
    /usr/bin/ssh "$string" || notify-send "SSH" "Colab SSH Disconnected"
  else
    /usr/bin/ssh "$string"
  fi
}

lxcbash() {
  lxc exec "$1" -- sudo --login --user ubuntu
}

dockerbash() {
  docker exec -it "$1" /bin/bash
}
