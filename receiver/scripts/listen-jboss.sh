#!/bin/bash
# Listen for JBoss JGroups cluster messages
MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"

echo "Starting JBoss-style multicast receiver..."
echo "Listening on: $MULTICAST_ADDR:$MULTICAST_PORT"
echo "Waiting for messages..."
echo ""

socat UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:0.0.0.0,fork \
  SYSTEM:'echo "[$(date -Iseconds)] Received:" && cat && echo ""'

