#!/bin/sh
# Listen for JBoss JGroups cluster messages
MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"

# Get the primary interface IP (Alpine/BusyBox compatible)
LOCAL_IP=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]}' | head -1)

echo "Starting JBoss-style multicast receiver..."
echo "Listening on: $MULTICAST_ADDR:$MULTICAST_PORT"
echo "Local interface: $LOCAL_IP"
echo "Waiting for messages..."
echo ""

exec socat -u "UDP4-RECVFROM:${MULTICAST_PORT},ip-add-membership=${MULTICAST_ADDR}:${LOCAL_IP},reuseaddr,fork" \
  SYSTEM:'echo "[$(date)] Received:" && cat && echo ""'

