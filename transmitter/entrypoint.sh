#!/bin/bash

echo "=== Multicast Transmitter Pod ==="
echo "Multicast Group: ${MULTICAST_ADDR}"
echo "Port: ${MULTICAST_PORT}"
echo ""
echo "Available commands:"
echo "  1. Send test multicast message:"
echo "     echo 'Hello from JBoss Transmitter' | socat - UDP4-DATAGRAM:${MULTICAST_ADDR}:${MULTICAST_PORT},so-broadcast"
echo ""
echo "  2. Continuous multicast sender (every ${INTERVAL} sec):"
echo "     /opt/multicast/send-jboss-heartbeat.sh"
echo ""
echo "  3. Send single message:"
echo "     /opt/multicast/send-single.sh [MULTICAST_IP] [PORT] [MESSAGE]"
echo ""
echo "Pod ready. Keeping container alive..."

# Keep the container running
exec tail -f /dev/null

