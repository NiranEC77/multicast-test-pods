#!/bin/bash
# Simple raw listener
MULTICAST_ADDR="${1:-${MULTICAST_ADDR:-224.0.1.105}}"
MULTICAST_PORT="${2:-${MULTICAST_PORT:-45688}}"

# Get the primary interface IP
LOCAL_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
if [ -z "$LOCAL_IP" ]; then
  LOCAL_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
fi
if [ -z "$LOCAL_IP" ]; then
  LOCAL_IP="0.0.0.0"
fi

echo "Listening on $MULTICAST_ADDR:$MULTICAST_PORT (interface: $LOCAL_IP)..."
socat -u UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:${LOCAL_IP},reuseaddr,fork -

