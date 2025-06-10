#!/bin/bash

# Get script directory and .n8n config path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.n8n"

# Check if .n8n file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "X .n8n config file not found at $CONFIG_FILE"
    exit 0
fi

# Load variables from .n8n
set -a
source "$CONFIG_FILE"
set +a

# Strip whitespace/newlines from variables
TestOrProd=$(echo "$TestOrProd" | tr -d '\r\n')
TESTURL=$(echo "$TESTURL" | tr -d '\r\n')
PRODURL=$(echo "$PRODURL" | tr -d '\r\n')

# Validate and choose target URL
if [ "$TestOrProd" == "TEST" ]; then
    TARGET_URL="$TESTURL"
elif [ "$TestOrProd" == "PROD" ]; then
    TARGET_URL="$PRODURL"
else
    echo "TestOrProd must be either TEST or PROD. Got: '$TestOrProd'"
    exit 0
fi

# Validate MESSAGE
if [ -z "$MESSAGE" ]; then
    echo "MESSAGE not set in .n8n file."
    exit 0
fi

# Escape double quotes in MESSAGE for safe JSON
ESCAPED_MESSAGE=$(echo "$MESSAGE" | sed 's/"/\\"/g')

# Optional: define payload if needed
PAYLOAD="$ESCAPED_MESSAGE"

# Send POST request (no authentication)
wget_output=$(wget --method POST \
    --body-data "$PAYLOAD" \
    --header="Content-Type: text/plain" \
    "$TARGET_URL" -O - 2>&1)

status=$?

# Output result
echo "=== wget exit code: $status ==="
echo "=== wget output ==="
echo "$wget_output"
echo "==================="

if [ $status -ne 0 ]; then
    echo "POST request failed."
    exit 0
fi

echo "POST request sent to $TARGET_URL"
exit 0
