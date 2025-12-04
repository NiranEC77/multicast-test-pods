#!/bin/bash
# Listen for JBoss JGroups cluster messages
MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"

# Get the primary interface IP
LOCAL_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
if [ -z "$LOCAL_IP" ]; then
  LOCAL_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
fi
if [ -z "$LOCAL_IP" ]; then
  LOCAL_IP="0.0.0.0"
fi

echo "Starting JBoss-style multicast receiver..."
echo "Listening on: $MULTICAST_ADDR:$MULTICAST_PORT"
echo "Local interface: $LOCAL_IP"
echo "Waiting for messages..."
echo ""

socat -u UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:${LOCAL_IP},reuseaddr,fork \
  SYSTEM:'echo "[$(date -Iseconds)] Received:" && cat && echo ""'

