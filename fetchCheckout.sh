#!/bin/bash

SUFFIX=''
NAME=${@: -1}

while getopts 's:h' flag; do
    case "${flag}" in
        s) SUFFIX="${OPTARG}" ;;
        h) 
            echo "Syntax: ./fetchCheckout [OPTIONS] [BRANCH_NAME]"
            echo "Options:"
            echo "-h - prints help."
            echo "-s [SUFFIX] searches only for branches ending with given suffix."
            exit 0 ;;
    esac
done

if [[ ! -z "$NAME" ]]; then
    if [[ $NAME =~ [0-9]+ ]]; then
        BRANCH=$(git branch -a | grep -v 'remotes' | grep -E [A-Z]+-$NAME[^0-9]+.*$SUFFIX$ | sort | head -1 | awk '{print $NF}')
    else
        BRANCH=$(git branch -a | grep -v 'remotes' | grep -Ew $NAME | sort | head -1 | awk '{print $NF}')
    fi
    if [[ ! -z $BRANCH ]] && [[ ${#BRANCH[@]} -gt 0 ]]; then
        git fetch
        git checkout $BRANCH
    else
        echo Given branch has not been found!
    fi
else
    echo Empty branch name!
fi
