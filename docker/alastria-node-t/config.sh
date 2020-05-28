#!/bin/bash

IMAGE_NAME=digitelts/alastria-node-t:latest

DIRECTORY="./config"

# alejandro.alfonso
# FIJADO POR AHORA NODO REGULAR. A EVOLUCIONAR!
# documentar posiblidad de EXTRA_ARGUMENTS para docker
# necesaria password para account.eth[0}
NODE_TYPE="general"
NODE_NAME="REG_"

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

  PS3="Do you want to enable the constellation? => "

  if [[ ! -z ${ENABLE_CONSTELLATION} ]]; then
    echo "ENABLE_CONSTELLATION envvar set to: $ENABLE_CONSTELLATION"
    ENABLE_CONSTELLATION=${ENABLE_CONSTELLATION}
    return
  fi

  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        ENABLE_CONSTELLATION=true
  	echo ""
        break
        ;;
      "No")
        ENABLE_CONSTELLATION=false
  	echo ""
        break
        ;;
    esac
  done
}

function setVolume {
  echo "Set the absolute path of the permanent data directory in Docker Host => "
  if [[ -z ${DATA_DIR} ]]; then
    read DATA_DIR
  else
    echo "DATA_DIR envvar set to: $DATA_DIR"
    DATA_DIR=${DATA_DIR}
  fi
  echo ""
}

function launchConfig {

  if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
  fi

  echo $NODE_NAME > $DIRECTORY/NODE_NAME
  echo $NODE_TYPE > $DIRECTORY/NODE_TYPE
  echo $DATA_DIR > $DIRECTORY/DATA_DIR
  echo $ENABLE_CONSTELLATION > $DIRECTORY/ENABLE_CONSTELLATION
  EXTRA_DOCKER_ARGUMENTS=${EXTRA_DOCKER_ARGUMENTS:-}

}

function checkName {

  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Volumen Name => $DATA_DIR"$'\n'"Constellation Enabled => $DATA_DIR"$'\n'"Press 1 (Yes) or 2 (No) => "

  options=("Yes" "No")

  select opt in "${options[@]}"
  do
    case $opt in
      "Yes")
        echo -n "Making config..."
        launchConfig
        echo "...done"
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
setConstellation
setVolume

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_T_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkName
