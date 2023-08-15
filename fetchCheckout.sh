#!/bin/bash

SUFFIX=''
NAME=''

while getopts 's:n:' flag; do
    case "${flag}" in
        s) SUFFIX="${OPTARG}" ;;
        n) NAME="${OPTARG}" ;;
    esac
done

if [[ ! -z "$NAME" ]]; then
    if [[ $NAME =~ [0-9]+ ]]; then
        BRANCH=$(git branch -a | grep -v 'remotes' | grep -E [A-Z]+-$NAME[^0-9]+.*$SUFFIX$)
    else
        BRANCH=$(git branch -a | grep -v 'remotes' | grep $NAME)
    fi
    if [[ -z $BRANCH ]] || [[ ${#BRANCH[@]} -eq 0 ]]; then
        echo Given branch has not been found!
    elif [[ ${#BRANCH[@]} -eq 1 ]]; then
        git fetch
        git checkout $BRANCH
    else
        echo Ambigous branch name!
    fi
else
    echo Empty branch name!
fi
