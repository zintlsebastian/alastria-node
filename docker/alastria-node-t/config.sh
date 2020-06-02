#!/bin/bash

IMAGE_NAME=digitelts/alastria-node-t:latest

DIRECTORY="./config"

function setNodeType {

  PS3="Node type? => "

  if [[ ! -z ${NODE_TYPE} ]]; then
    echo "NODE_TYPE envvar set to: $NODE_TYPE"
    NODE_TYPE=${NODE_TYPE}
    return
  fi

  options=("general" "bootnode" "validator")

  select opt in "${options[@]}"
  do
    case $opt in
      "general")
        NODE_TYPE="general"
        NODE_NAME="REG_"
  	    echo ""
        break
        ;;
      "bootnode")
        NODE_TYPE="bootnode"
        NODE_NAME="BOT_"
  	    echo ""
        break
        ;;
        "validator")
        NODE_TYPE="validator"
        NODE_NAME="VAL_"
  	    echo ""
        break
        ;;
    esac
  done
}

function setPassword {
  echo "Set password for account.eth[0]: "
  if [[ -z "${PASSWORD}" ]]; then
    read PASSWORD
  else
    echo "PASSWORD envvar set to: $PASSWORD"
    PASSWORD=${PASSWORD}
  fi
  echo ""
}

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
        ENABLE_CONSTELLATION="true"
  	echo ""
        break
        ;;
      "No")
        ENABLE_CONSTELLATION="false"
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
  echo $PASSWORD > $DIRECTORY/PASSWORD
  EXTRA_DOCKER_ARGUMENTS=${EXTRA_DOCKER_ARGUMENTS:-}

}

function checkName {

  PS3="Are you sure that these data are correct?"$'\n'"Node Type => $NODE_TYPE"$'\n'"Node Name => $NODE_NAME"$'\n'"Persisten Volumen Path => $DATA_DIR"$'\n'"Constellation Enabled => $ENABLE_CONSTELLATION"$'\n'"Password for eth0 account => $PASSWORD"$'\n'"Press 1 (Yes) or 2 (No) => "

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

setNodeType
setCompanyName
setCPUNumber
setRAMNumber
setSequential
setConstellation
setVolume
setPassword

NODE_NAME=$(printf "%s%s%s%s%s%s%s%s" "$NODE_NAME" "$COMPANY_NAME" "_T_" "$CPU" "_" "$RAM" "_" "$SEQ")
checkName
