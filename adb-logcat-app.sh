#!/bin/bash

declare VERSION=0.1.0

usage () {
  echo "usage: adb-logcat-app [-hV] [adb logcat options] <appid>"
  echo
  echo "adb logcat options:"
  echo "  See 'adb logcat -h' "
  echo
  echo "options:"
  echo "  -h,--help      Print this help dialogue and exit"
  echo "  -V,--version   Print the current version and exit"
}

adb-logcat-app () {
  local id opt pid adbpid
  local args=()

  for opt in "$@"; do
    case "$opt" in
      -h|--help)
        usage
        return 0
        ;;
      -V|--version)
        echo "$VERSION"
        return 0
        ;;

       *)
         if [ -z "$id" ] && [ "${opt:0:1}" != "-" ]; then
          id="$opt"
        else
          args+=("$opt")
         fi
         ;;
    esac
  done

  if [ -z "$id" ]; then
    echo >&2 "error: An application id must be given"
    usage >&2
    return 1
  fi

  while true; do
    ## Probe for application process ID
    pid="$(adb shell ps 2>/dev/null | grep "$id" | awk '{print $2}' | xargs echo -n)"
    if [  -n "$pid" ]; then
      clear
      # echo adb logcat --pid="$pid" "${args[@]}" 2>/dev/null
      adb logcat --pid="$pid" "${args[@]}" 2>/dev/null & adbpid=$!
      # shellcheck disable=SC2064
      trap "kill -9 $adbpid; exit" SIGTERM SIGINT

      while [ -n "$pid" ]; do
        pid="$(adb shell ps 2>/dev/null | grep "$id" | awk '{print $2}' | xargs echo -n)"
      done

      kill -9 "$adbpid"
      wait
    fi
    sleep 1s
  done
}

if [[ ${BASH_SOURCE[0]} != "$0" ]]; then
  export -f adb-logcat-app
else
  adb-logcat-app "${@}"
  exit $?
fi
