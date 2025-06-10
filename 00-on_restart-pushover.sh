#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "!  .env file not found at $ENV_FILE, skipping Pushover notification."
    exit 0
fi

set -a
source "$ENV_FILE"
set +a

# Strip invisible characters
apptoken=$(echo "$apptoken" | tr -d '\r\n')
usertoken=$(echo "$usertoken" | tr -d '\r\n')

if [ -z "$apptoken" ] || [ -z "$usertoken" ]; then
    echo "!  Missing apptoken or usertoken in .env, skipping Pushover notification."
    exit 0
fi

# Manually URL-encode the message (spaces = +)
MESSAGE="comfyui+server+rebooted"
TITLE="ComfyUI+Restart"
PRIORITY=0
SOUND="incoming"

POST_DATA="token=$apptoken&user=$usertoken&message=$MESSAGE&title=$TITLE&priority=$PRIORITY&sound=$SOUND"

wget_output=$(wget --method POST \
    --body-data "$POST_DATA" \
    --header="Content-Type: application/x-www-form-urlencoded" \
    https://api.pushover.net/1/messages.json -O - 2>&1)

status=$?


if [ $status -ne 0 ]; then
    echo "Pushover notification failed."
    exit 0
fi

echo "Pushover notification sent."
exit 0
