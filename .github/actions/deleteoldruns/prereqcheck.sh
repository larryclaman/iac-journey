#!/bin/bash
for tool in jq git gh
do
    if ! [ -x "$(command -v $tool)" ]; then
    echo "Error: $tool is not installed." >&2
    exit 1
    fi
done
exit 0