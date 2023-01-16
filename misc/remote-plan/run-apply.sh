#!/bin/bash

APPLY_OUT_FILE="apply-out.txt"

function assertFailure () {
  command=$1
  echo "testing $command failure"

  status="0"
  terraform -chdir='./local-run' $command 2> $APPLY_OUT_FILE || status="1"
  if [ "$status" -eq "0" ]; then
    echo "Apply succeeding instead of failing"
    exit 1
  fi
  ERRORS=`grep -c 'Apply not allowed for workspaces with a VCS connection' $APPLY_OUT_FILE`
  if [ "$ERRORS" -eq "0" ]; then echo "Apply failed fo a reason other than VCS" 1>&2 && exit 1; fi
}

assertFailure "apply"
assertFailure "destroy"