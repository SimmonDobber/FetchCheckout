#!/bin/bash

PREFIX="remotes/origin/"
SUFFIX=''
UPDATE=''
NAME=${@: -1}

while getopts 's:uh' flag; do
    case "${flag}" in
        s) SUFFIX="${OPTARG}" ;;
        u) UPDATE="true" ;;
        h) 
            echo "Syntax: ./fetchCheckout [OPTIONS] [BRANCH_NAME]"
            echo "Options:"
            echo "-h    prints help."
            echo "-u    updates branch."
            echo "-s    [SUFFIX] searches only for branches ending with given suffix."
            exit 0 ;;
    esac
done

if [[ $NAME != $SUFFIX ]]; then
    if [[ $NAME =~ ^[0-9]+$ ]]; then
        BRANCH=$(git branch -a | grep -E [A-Z]+-$NAME[^0-9]+.*$SUFFIX$ | sort | head -1 | awk '{print $NF}')
    else
        BRANCH=$(git branch -a | grep -Ew $NAME | sort | head -1 | awk '{print $NF}')
    fi
    if [[ ! -z $BRANCH ]] && [[ ${#BRANCH[@]} -gt 0 ]]; then
        BRANCH=${BRANCH#$PREFIX}
        git fetch
        git checkout $BRANCH
        if [[ ! -z $UPDATE ]]; then
            git merge $(git branch -a | grep 'origin'/$BRANCH$)
        fi
    else
        echo Given branch has not been found!
    fi
else
    echo Empty branch name!
fi
