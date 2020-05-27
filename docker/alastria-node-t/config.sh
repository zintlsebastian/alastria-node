#!/bin/bash

NODE_TYPE="general"
NODE_NAME="REG_"
IMAGE_NAME=digitelts/alastria-node-t:latest

function setCompanyName {
  echo "Write company name: "
  if [[ -z "${COMPANY_NAME}" ]]; then
    read COMPANY_NAME
  else
    echo "COMPANY_NAME envvar set to: $COMPANY_NAME"
    COMPANY_NAME=${COMPANY_NAME}
  fi
  echo ""
}
function setCPUNumber {
  echo "Number of CPUs: "
  if [[ -z ${CPU} ]]; then
    read CPU
  else
    echo "CPU envvar set to: $CPU"
    CPU=${CPU}
  fi
  echo ""
}
function setRAMNumber {
  echo "Number of RAM: "
  if [[ -z ${RAM} ]]; then
    read RAM
  else
    echo "RAM envvar set to: $RAM"
    RAM=${RAM}
  fi
  echo ""
}
function setSequential {
  echo "Sequential starting at 00: "
  if [[ -z ${SEQ} ]]; then
    read SEQ
  else
    echo "SEQ envvar set to: $SEQ"
    SEQ=${SEQ}
  fi
  echo ""
}

function setConstellation {
  if [[ ! -z ${ENABLE_CONSTELLATION} ]]; then
    echo "ENABLE_CONSTELLATION envvar set to: $ENABLE_CONSTELLATION"
    ENABLE_CONSTELLATION=${ENABLE_CONSTELLATION}
    return
  fi

  PS3="Do you want to enable the constellation?"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        ENABLE_CONSTELLATION=true
        break
        ;;
      "No")
        ENABLE_CONSTELLATION=
        break
        ;;
    esac
  done
}

function setMonitor {
  if [[ ! -z ${MONITOR_ENABLED} ]]; then
    echo "MONITOR_ENABLED envvar set to: $MONITOR_ENABLED"
    MONITOR_ENABLED=${MONITOR_ENABLED}
    return
  fi

  PS3="Do you want to install the monitor?"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        MONITOR_ENABLED=1
        break
        ;;
      "No")
        MONITOR_ENABLED=0
        break
        ;;
    esac
  done
}

function setVolume {
  echo "Set the absolute path of the data directory in Dockerhost (note, the Image will be at least 40Gb long): "
  read DATA_DIR
  echo ""
  DATA_DIR=${DATA_DIR}
}

function launchConfig {
  DIRECTORY=./config
  if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
  fi

  ACCESS_POINT_DIR="$(pwd)"/alastria-access-point/nginx/conf.d

  echo $NODE_NAME > $DIRECTORY/NODE_NAME
  echo $NODE_TYPE > $DIRECTORY/NODE_TYPE
  echo $MONITOR_ENABLED > $DIRECTORY/MONITOR_ENABLED
  echo $DATA_DIR > $DIRECTORY/DATA_DIR
  echo $ACCESS_POINT_DIR > $DIRECTORY/ACCESS_POINT_DIR
  echo $ENABLE_CONSTELLATION > $DIRECTORY/ENABLE_CONSTELLATION
  EXTRA_DOCKER_ARGUMENTS=${EXTRA_DOCKER_ARGUMENTS:-}

}

function checkName {
  #if [[ ! -z NO_LAUNCH_CONFIRM ]]; then
  #  echo "NO_LAUNCH_CONFIRM enabled, skipping confirmation..."
  #  echo "LAUNCHING with Node Type => $NODE_TYPE and Node Name => $NODE_NAME"
  #  launchNode
  #  return
  #fi

  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Press 1 (Yes) or 2 (No) => "
  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo "Making config"
        launchConfig
        echo "done"
	exit 0
        ;;
      "No")
        echo "Please launch the script again"
        exit 0
        ;;
    esac
  done
}

setCompanyName
setCPUNumber
setRAMNumber
setSequential
setMonitor
setConstellation
setVolume

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_T_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkName
