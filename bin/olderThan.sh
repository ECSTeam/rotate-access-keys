#!/usr/bin/env bash
#set -x
expiration_date=$(date -v -15d +%Y-%m-%d)


#  $1 is the expiration date
#  $2 is the date to compare to
#  $3 is the iam user id
function isOlder()
{
  if [[ $1 < $2 ]]
  then
    FILE_PREFIX=$(echo $3 |sed 's/@/_/')
    echo "./rotate-iam-user-key.sh  -a accessKeys.csv -s s3://morgan-test2/junk.test -c ${FILE_PREFIX}.csv -u ${3} -j ${FILE_PREFIX}.json"
  else
    echo "$3 does not need rotation"
  fi
}

#isOlder $2 $expiration_date $1