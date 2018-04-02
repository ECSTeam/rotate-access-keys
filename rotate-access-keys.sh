#!/usr/bin/env bash

# ================================================================
# === DESCRIPTION
# ================================================================
#
# Summary: This script automatically rotates the key for an IAM user.
#
# Version: 1.0.0
#
# Command-line arguments:
#    - See the 'PrintHelp' function below for command-line arguments. Or run this script with the --help option.
#
# Legal stuff:
#    - Copyright (c) 2018 Morgan Stake
#    - Licensed under the MIT License - https://opensource.org/licenses/MIT

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="${SCRIPT_DIR}/bin"
source ${BIN_DIR}/array_menu.sh
IAAS_OPTIONS=( azure aws gcp )

# ================================================================
# === FUNCTIONS
# ================================================================

function PrintHelp() {
    echo "usage: $0.sh [options...] "
    echo "options:"
    echo " -P  The desired Cloud Platform " `printf '%s\n' "${IAAS_OPTIONS[@]}"`
}

function rotateAzure() {
  PrintHelpAzure
}

function rotateAws() {
    $SCRIPT_DIR/aws/rotate-iam-user-key.sh $@
}

function rotateAzure() {
  PrintHelpAzure
}


#set -x

if [  $# -eq 0 ]
then
  PrintHelp
  exit 1
fi
set -x

IAAS=""

while getopts ":P:" opt; do
  case ${opt} in
    P)
      IAAS=$OPTARG
      ;;
    \?)
      displayUsage
      exit 1
      ;;
  esac

done
VALID_OPTION=$( printf '%s\n' "${IAAS_OPTIONS[@]}"|grep -w $IAAS )
if [ -z $VALID_OPTION ]
then
  echo  "Pick an IAAS - azure, aws, or gcp: "
  createMenu "${#IAAS_OPTIONS[@]}" "${IAAS_OPTIONS[@]}"
  IAAS=$MENU_SELECTION_POSITION
else
  MENU_SELECTION=$IAAS
  IAAS=$( printf '%s\n' "${IAAS_OPTIONS[@]}"|grep -nw $IAAS|cut -d":" -f1 )
fi

echo "IAAS: ${IAAS_OPTIONS[$IAAS - 1]} selected"

case ${IAAS} in
    1)
      rotateAzure $@
      ;;
    2)
      rotateAws $@
      ;;
    3)
      rotateGcp $@
      ;;
    \?)
      PrintHelp
      exit 1
      ;;
  esac