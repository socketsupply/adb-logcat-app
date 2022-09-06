#!/bin/bash

VERSION=0.1.0

usage () {
  echo "adb-logcat-app [-hV]"
  echo
  echo "Options:"
  echo "  -h|--help      Print this help dialogue and exit"
  echo "  -V|--version   Print the current version and exit"
}

adb-logcat-app () {
  local id opt pid retries=0

  for opt in "${@}"; do
    case "${opt}" in
      -h|--help)
        usage
        return 0
        ;;
      -V|--version)
        echo "${VERSION}"
        return 0
        ;;

       *)
         id="$opt"
         break
         ;;
    esac
  done

  while [ -z "$pid" ] && (( retries++ < 32 )); do
    ## Probe for application process ID
    pid="$(adb shell ps | grep "$id" | awk '{print $2}' 2>/dev/null)"
    sleep 1s
  done

  adb logcat --pid="$pid"
}

if [[ ${BASH_SOURCE[0]} != "$0" ]]; then
  export -f adb-logcat-app
else
  adb-logcat-app "${@}"
  exit 0
fi

