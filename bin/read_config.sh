#!/usr/bin/env bash
#set -x
LOCAL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#source ${LOCAL_SCRIPT_DIR}/array_menu.sh

maskAllButLastChars()
{
  printf "%-$(( ${#1} -$2 ))s${1: -$2}\n" " "|sed -e 's/ /*/g'
}

newline_at_eof()
{
  if [ -z $( tail -c -1 "$1") ]
  then
#      echo "Newline at end of file!"
      return 0
  else
#      echo "No newline at end of file!"
      return 1
  fi
  return 0
}

sections="$(basename ${1}| cut -d'.' -f1)_sections"
declare -a ${sections}
declare i=0

if ! newline_at_eof $1
then
#  echo Need it
   echo "" >> $1
fi


while IFS='= ' read var val
do
    if [[ $var == \[*] ]]
    then
        section=$var
        sections[$i]=$section
    elif [[ $val ]]
    then
#        echo  "$var$section=$val"
        declare "$var$section=$val"
    fi
    ((i++))
done < $1
#
#createMenu "${#sections[@]}" "${sections[@]}"
#SELECTED_SECTION=$MENU_SELECTION