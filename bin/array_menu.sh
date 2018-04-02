#!/usr/bin/env bash
#set -x
LOCAL_AM_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MENU_SELECTION=""
MENU_SELECTION_POSITION=-1

createMenu ()
{
  arrsize=$1
  if [ $arrsize -eq 1 ]
  then
      MENU_SELECTION=${2}
      MENU_SELECTION_POSITION=0
  else
#    echo "Size of array: $arrsize"
#    echo "${@:2}"

    select option in "${@:2}" ;
    do
      re='^[0-9]+$'
      if ! [[ $REPLY =~ $re ]] ; then
         REPLY=-1
      fi
      if [ "$REPLY" -eq "$arrsize" ];
      then
        MENU_SELECTION=$option
        MENU_SELECTION_POSITION=$REPLY
        break;
      elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $((arrsize-1)) ];
      then
#        echo "You selected $option which is option $REPLY"
        MENU_SELECTION=$option
        MENU_SELECTION_POSITION=$REPLY
        break;
      else
        echo "Incorrect Input: Select a number 1-$arrsize" >&2
      fi
    done
  fi
#  echo Selected $MENU_SELECTION
}