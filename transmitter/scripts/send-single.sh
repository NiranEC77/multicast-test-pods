#!/bin/bash
# Send a single multicast message
MULTICAST_ADDR="${1:-${MULTICAST_ADDR:-224.0.1.105}}"
MULTICAST_PORT="${2:-${MULTICAST_PORT:-45688}}"
MESSAGE="${3:-Test multicast message from JBoss transmitter}"

echo "Sending to $MULTICAST_ADDR:$MULTICAST_PORT"
echo "Message: $MESSAGE"
echo "$MESSAGE" | socat - UDP4-DATAGRAM:${MULTICAST_ADDR}:${MULTICAST_PORT},so-broadcast
echo "Done."

