#!/bin/bash

while getopts ":d" options; do
    case "${options}" in
        d)            # pass duration in minutes
           OlderThan=${OPTARG} 
            ;;
        *)             # Any other option
            exit 1

#OlderThan=$1
let OlderThan=OlderThan*60 # convert to seconds
export OlderThan

query1='.workflow_runs[]| select( .status == "waiting") | {id, created_at, run_number,cancel_url}'
query2='select( .created_at|fromdate < now - (env.OlderThan| tonumber)) | [ .cancel_url] |@tsv'
items=$(gh api "repos/{owner}/{repo}/actions/runs"  --paginate --jq "$query1" |jq -rc "$query2")

i=0
for item in $items; do
    echo "$i: Cancelling pending run $item"
    gh api -X POST $item
    let "i++"   
done

echo "::set-output name=count::$i"