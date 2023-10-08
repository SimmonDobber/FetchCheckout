#!/bin/bash

PREFIX="remotes/origin/"
SUFFIX='_master'
USE_SUFFIX=''
UPDATE=''
COPY=''
NAME=${@: -1}

while getopts 's:uhc' flag; do
  case "${flag}" in
    s) USE_SUFFIX="true" ;;
    u) UPDATE="true" ;;
    c) COPY="true" ;;
    h)
      echo "Syntax: ./fetchCheckout [OPTIONS] [BRANCH_NAME]"
      echo "Options:"
      echo "-h    prints help,"
      echo "-u    updates branch,"
      echo "-s    searches only for branches ending with '_master' suffix,"
      echo "-c 	creates _master branch from give branch."
      exit 0 ;;
  esac
done

if [[ -z $UPDATE ]]; then
	if [[ $NAME =~ ^[0-9]+$ ]]; then
		if [[ -n $USE_SUFFIX ]]; then
      BRANCH=$(git branch -a | grep -E [A-Z]+-$NAME[^0-9]+.*$SUFFIX$ | sort | head -1 | awk '{print $NF}')
		else
			BRANCH=$(git branch -a | grep -E [A-Z]+-$NAME[^0-9]+.* | sort | head -1 | awk '{print $NF}')
		fi
    else
      BRANCH=$(git branch -a | grep -E ^[[:space:]]*$NAME$ | sort | head -1 | awk '{print $NF}')
    fi
    if [[ -n $BRANCH ]] && [[ ${#BRANCH[@]} -gt 0 ]]; then
      BRANCH=${BRANCH#$PREFIX}
		if [[ -n $COPY ]]; then
			git checkout -b $BRANCH$SUFFIX $BRANCH
		else 
      git fetch
      git checkout $BRANCH
      if [[ -n $UPDATE ]]; then
        git merge $(git branch -a | grep 'origin'/$BRANCH$)
      fi
		fi
    else
      echo Given branch has not been found!
    fi
else
  echo Empty branch name!
fi
