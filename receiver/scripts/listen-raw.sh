#!/bin/sh
# Simple raw multicast listener using Python
# Note: Using Python instead of socat due to socat 1.8.x bug with ip-add-membership
MULTICAST_ADDR="${1:-${MULTICAST_ADDR:-224.0.1.105}}"
MULTICAST_PORT="${2:-${MULTICAST_PORT:-45688}}"

# Get the primary interface IP for display
LOCAL_IP=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]}' | head -1)

echo "Listening on $MULTICAST_ADDR:$MULTICAST_PORT (interface: $LOCAL_IP)..."

exec python3 -c "
import socket
import struct

MCAST_GRP = '$MULTICAST_ADDR'
MCAST_PORT = $MULTICAST_PORT

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(('', MCAST_PORT))

mreq = struct.pack('4sl', socket.inet_aton(MCAST_GRP), socket.INADDR_ANY)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

while True:
    data, addr = sock.recvfrom(4096)
    try:
        print(data.decode(), end='')
    except:
        print(f'(binary: {len(data)} bytes)')
"
