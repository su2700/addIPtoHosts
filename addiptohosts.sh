#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <IP_address> <hostname>"
    exit 1
fi

# Check if the first argument is a valid IP address
ip_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
if ! [[ "$1" =~ $ip_regex ]]; then
    echo "Error: Invalid IP address provided."
    exit 1
fi

# Check if the second argument is a valid hostname
hostname_regex='^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
if ! [[ "$2" =~ $hostname_regex ]]; then
    echo "Error: Invalid hostname provided."
    exit 1
fi

# Check if the entry already exists in /etc/hosts
if grep -q "$1\s\+$2" /etc/hosts; then
    echo "Entry already exists in /etc/hosts"
    exit 0
fi

# Add the entry to /etc/hosts
echo "$1 $2" | sudo tee -a /etc/hosts > /dev/null

echo "Entry added to /etc/hosts"