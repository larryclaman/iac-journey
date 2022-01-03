#!/bin/bash

# requires gh >= 2.4
# requires jq


# 3600 = 1hr
#  86400 = 1 day
# 864000 = 10 days
export OlderThan=86400

# gh  api -i 'users/{owner}'   ## show scope of auth


#query='.[] | select(.status=="waiting")| select( .createdAt |fromdate < now - (env.OlderThan| tonumber) )|[.workflowDatabaseId]|@tsv'
#echo $query
#items=$(gh run list --json 'databaseId,createdAt,name,status,workflowDatabaseId' | jq -rc "$query")

# Using a two-part query so that we can leverage env variables
query1='.workflow_runs[]| select( .status == "waiting") | {id, created_at, run_number,cancel_url}'
query2='select( .created_at|fromdate < now - (env.OlderThan| tonumber)) | [ .cancel_url] |@tsv'
items=$(gh api "repos/{owner}/{repo}/actions/runs"  --jq "$query1" |jq -rc "$query2")

echo $items

i=0
for item in $items; do
    echo "$i: Cancelling run $item"
    #gh run cancel $item
    gh api -X POST $item

    let "i++"
done
