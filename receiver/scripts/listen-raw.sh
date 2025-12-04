#!/bin/bash
# Simple raw listener
MULTICAST_ADDR="${1:-${MULTICAST_ADDR:-224.0.1.105}}"
MULTICAST_PORT="${2:-${MULTICAST_PORT:-45688}}"

echo "Listening on $MULTICAST_ADDR:$MULTICAST_PORT..."
socat UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:0.0.0.0,fork -

