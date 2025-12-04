#!/bin/bash
# Simulates JBoss JGroups cluster heartbeat
MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"
INTERVAL="${INTERVAL:-2}"

echo "Starting JBoss-style multicast transmitter..."
echo "Address: $MULTICAST_ADDR:$MULTICAST_PORT"
echo "Interval: ${INTERVAL}s"
echo ""

count=0
while true; do
  count=$((count + 1))
  message="JBOSS_HEARTBEAT|node=$(hostname)|seq=$count|time=$(date -Iseconds)"
  echo "Sending: $message"
  echo "$message" | socat - UDP4-DATAGRAM:${MULTICAST_ADDR}:${MULTICAST_PORT},so-broadcast
  sleep $INTERVAL
done

