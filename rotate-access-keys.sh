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
#    - See the 'displayUsage' function below for command-line arguments. Or run this script with the --help option.
#
# Legal stuff:
#    - Copyright (c) 2018 Morgan Stake
#    - Licensed under the MIT License - https://opensource.org/licenses/MIT

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="${SCRIPT_DIR}/bin"
source ${BIN_DIR}/array_menu.sh
source ${BIN_DIR}/olderThan.sh

IAAS_OPTIONS=( "Exit with no selection" azure aws gcp )

function getArrayIndex()
{
  value=$1
  shift
  array_in=( "$@" )
#  echo ${array_in[@]} $value
  x=1
  for i in "${!array_in[@]}";
  do
     if [[ "${array_in[$i]}" = "${value}" ]];
     then
         echo $x
         return
     fi
    ((x=x+1))
  done
  echo -1
}
# ================================================================
# === FUNCTIONS
# ================================================================

function displayUsage() {
    echo "usage: $0.sh [options...] "
    echo "options:"
    echo " -a  AWS Access Credentials file ( defaults to ~/.aws/credentials ) "
    echo " -i  The desired Cloud Platform (IAAS): ( ${IAAS_OPTIONS[@]:1})"
    echo " -d  The Number of days since the last rotation, indicating expiry"
    echo "     (-d 15 = 15 days and older will be rotated)"
    echo " -h  This help text"
    echo " -s  S3 Bucket filename to test access for the new keys."
    echo " -1  Preview the users needing rotation"

}

function rotateAzure() {
  echo "TBD"
}

function rotateAws() {

  echo "Rotating AWS User Id Access Keys On or before $1"
  if [ -z ${S3_TEST_FILE} ]
  then
    echo "We will need an S3 Bucket filename to test access for the new keys."
    echo "URL format for the Bucket filename <s3://bucketName/filename>"
    read -p "Bucket filename: " S3_TEST_FILE
  else
    echo "S3 Bucket filename to test access for the new keys: "${S3_TEST_FILE}
  fi

#  AllActiveUsers=$(for i in `aws iam list-users |jq -r '.Users[].UserName'` ; do aws iam list-access-keys  --user-name $i| jq -j -r '.AccessKeyMetadata[]|select(.Status=="Active")|.UserName,"=",.CreateDate, "\n"';done)
  AllActiveUsers="anault=2018-03-17T22:07:59Z cgi-concourse-user=2018-03-30T22:30:18Z Darwesh-remote=2018-03-30T22:08:15Z darwesh.singh@cgi.com=2018-03-30T22:08:31Z dbrown=2018-03-30T22:08:46Z ecs-concourse-ci=2018-03-30T21:52:09Z ganderson=2018-03-30T22:09:04Z jlutz=2018-03-30T22:09:20Z jslCfUser=2018-03-30T22:09:40Z kkellner=2018-03-22T00:02:51Z mcarlson=2018-03-30T20:56:56Z mgw=2018-03-30T20:33:27Z mlove=2018-03-30T22:09:59Z mminges=2018-03-30T22:10:15Z morgan-concourse=2018-03-30T20:03:28Z morgan.stake@cgi.com=2018-03-30T20:24:14Z pcf-stack-PcfIamUser-1CW4P398VBY72=2018-03-30T22:10:35Z pcf17admin=2018-03-30T22:10:50Z rdrew=2018-03-30T22:11:08Z rlargent=2018-03-30T22:11:23Z rsambandan=2018-03-30T22:11:39Z ryslas=2018-03-30T22:11:58Z shutto=2018-03-30T22:12:14Z sraja=2018-03-30T22:12:29Z sravan.neppalli@cgi.com=2018-03-30T22:12:49Z swall=2018-03-30T22:13:06Z tanderson=2018-03-30T20:50:22Z tariq=2018-03-30T16:59:40Z tsiddiqui=2018-03-30T22:13:23Z tyslas=2018-03-30T22:13:39Z"
  needingRotation=0
  for i in $AllActiveUsers
  do
    XUSER=$(echo $i|cut -d"=" -f1 );
    XDate=$(echo $i|cut -d"=" -f2);

    if isOlderThan $XDate $expiration_date $XUSER
    then
      ((needingRotation = needingRotation + 1))
      echo "Need to rotate" $XUSER
      FILE_PREFIX=$(echo $XUSER |sed 's/@/_/')
      $PREVIEW_COMMAND "${SCRIPT_DIR}/aws/rotate-iam-user-key.sh  -a ${ACCESS_KEY_FILE} -s ${S3_TEST_FILE} -u ${XUSER} -j ${FILE_PREFIX}.json"
    fi
  #    $SCRIPT_DIR/aws/rotate-iam-user-key.sh $@
  done
  echo "Users Needing Rotation: ${needingRotation:-0}"
}

function rotateAzure() {
  echo "TBD"
}


#set -x

if [  $# -eq 0 ]
then
  displayUsage
  exit 1
fi

IAAS=-1
VALID_OPTION=""
ACCESS_KEY_FILE=${ACCESS_KEY_FILE:-"~/.aws/credentials"}
S3_TEST_FILE=""
PREVIEW_COMMAND=""

while getopts ":s:i:d:a:1h" opt; do
  case ${opt} in
    1)
      PREVIEW_COMMAND="echo "
      echo "======================================="
      echo "===== Preview Mode ===================="
      echo "======================================="
      ;;
    i)
      IAAS=$(getArrayIndex $OPTARG "${IAAS_OPTIONS[@]}")
#      VALID_OPTION=$( printf '%s\n' "${IAAS_OPTIONS[@]}"|grep -w '$IAAS' )
      VALID_OPTION=${IAAS_OPTIONS[$IAAS]}
      ;;
    d)
      days=$OPTARG
      expiration_date=$(date -v -${days}d +%Y-%m-%d)
      ;;
    h)
      displayUsage
      exit 1
      ;;
    s)
      S3_TEST_FILE=$OPTARG
      ;;
    a)
      ACCESS_KEY_FILE=$OPTARG
      ;;
  esac
done

if [ -z ${days:=""} ]
then
  echo "Default to 15 days or older for expiration"
fi

if [ $IAAS -lt 0 ]
then
  echo  "Pick an IAAS - azure, aws, or gcp: "
  createMenu "${#IAAS_OPTIONS[@]}" "${IAAS_OPTIONS[@]}"
  IAAS=$MENU_SELECTION_POSITION
else
  MENU_SELECTION_POSITION=$IAAS
  MENU_SELECTION=${IAAS_OPTIONS[${IAAS} - 1]}
fi

echo "IAAS: $MENU_SELECTION selected"

case ${IAAS} in
    1)
      echo "Aborting execution..."
      exit 0
      ;;
    2)
      rotateAzure $@
      ;;
    3)
      rotateAws $expiration_date $@
      ;;
    4)
      rotateGcp $@
      ;;
    \?)
      displayUsage
      exit 1
      ;;
  esac
