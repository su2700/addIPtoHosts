#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_or_hostname>"
    exit 1
fi

# Check if the input is an IP address or a hostname
if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    search_pattern="$1"
else
    search_pattern=$(host "$1" | awk '/has address/ {print $4; exit}')
    if [ -z "$search_pattern" ]; then
        echo "Invalid hostname or IP address provided."
        exit 1
    fi
fi

# Create a temporary file
temp_file=$(mktemp)

# Remove the line containing the IP or hostname from /etc/hosts
grep -v "$search_pattern" /etc/hosts > "$temp_file"

# Check if any changes were made
if ! cmp -s /etc/hosts "$temp_file"; then
    # Replace the original /etc/hosts file with the modified version
    sudo mv "$temp_file" /etc/hosts
    echo "Entry removed from /etc/hosts"
else
    echo "No matching entry found in /etc/hosts"
    rm "$temp_file"
fi