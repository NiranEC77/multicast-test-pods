#!/bin/bash

echo "=== Multicast Transmitter Pod ==="
echo "Multicast Group: ${MULTICAST_ADDR}"
echo "Port: ${MULTICAST_PORT}"
echo "Interval: ${INTERVAL}s"
echo ""
echo "=== Basic Multicast Testing ==="
echo "  1. Send continuous heartbeat messages:"
echo "     /opt/multicast/send-jboss-heartbeat.sh"
echo ""
echo "  2. Send a single message:"
echo "     /opt/multicast/send-single.sh [ADDR] [PORT] [MESSAGE]"
echo ""
echo "=== JGroups/JBoss Testing (Real Protocol) ==="
echo "  3. Send JGroups protocol messages:"
echo "     /opt/multicast/jgroups-send.sh"
echo ""
echo "  4. Join a JGroups cluster (most realistic):"
echo "     /opt/multicast/jgroups-cluster.sh"
echo ""
echo "Pod ready. Keeping container alive..."

# Keep the container running
exec tail -f /dev/null

