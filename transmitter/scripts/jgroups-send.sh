#!/bin/bash
# JGroups multicast sender - tests actual JGroups protocol
# This simulates what a real JBoss/WildFly node does for cluster discovery

MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"
JGROUPS_JAR="${JGROUPS_JAR:-/opt/jgroups/jgroups.jar}"
INTERVAL="${INTERVAL:-2}"

echo "=== JGroups Multicast Sender ==="
echo "Multicast Address: $MULTICAST_ADDR"
echo "Port: $MULTICAST_PORT"
echo "Interval: ${INTERVAL}s"
echo "JGroups Version: $(java -cp $JGROUPS_JAR org.jgroups.Version 2>/dev/null || echo 'unknown')"
echo ""
echo "Sending JGroups multicast messages..."
echo "Press Ctrl+C to stop"
echo ""

exec java -cp "$JGROUPS_JAR" \
    -Djgroups.bind_addr=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]}' | head -1) \
    org.jgroups.tests.McastSenderTest \
    -mcast_addr "$MULTICAST_ADDR" \
    -port "$MULTICAST_PORT" \
    -ttl 4

