#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $0 names.txt"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "$1 not found"
    exit 1
fi

while read -r line; do
    # remove anything in the name that aren't letters or spaces
    name=$(echo "$line" | tr -cd '[:alpha:][:space:]')
    tokens=($(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '\n'))

    if [ "${#tokens[@]}" -lt 1 ]; then
        # skip empty lines
        continue
    fi

    # assume tokens[0] is the first name
    fname="${tokens[0]}"

    # remaining elements in tokens[] must be the last name
    lname=""

    if [ "${#tokens[@]}" -eq 2 ]; then
        # assume traditional first and last name
        # e.g. John Doe
        lname="${tokens[1]}"
    elif [ "${#tokens[@]}" -gt 2 ]; then
        # assume multi-barrelled surname
        # e.g. Jane van Doe

        # remove the first name
        tokens=("${tokens[@]:1}")

        # combine the multi-barrelled surname
        lname=$(echo "${tokens[*]}" | tr -d '[:space:]')
    fi

    # create possible usernames
    echo "${fname}${lname}"
    echo "${lname}${fname}"
    echo "${fname}.${lname}"
    echo "${lname}.${fname}"
    echo "${lname}${fname:0:1}"
    echo "${fname:0:1}${lname}"
    echo "${lname:0:1}${fname}"
    echo "${fname:0:1}.${lname}"
    echo "${lname:0:1}.${fname}"
    echo "${fname}"
    echo "${lname}"
done < "$1"
