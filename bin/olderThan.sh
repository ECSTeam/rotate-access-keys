#!/usr/bin/env bash
#set -x
expiration_date=$(date -v -15d +%Y-%m-%d)


#  $1 is the date to compare to
#  $2 is the expiration date
#  $3 is the iam user id
function isOlderThan()
{
  if [[ $1 < $2 ]]
  then
    return 0
  else
#    echo "$3 does not need rotation"
    return 1
  fi
}

#isOlder $2 $expiration_date $1