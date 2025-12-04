#!/bin/bash
# JGroups cluster member - joins a cluster and shows membership changes
# This is the most realistic JBoss cluster simulation

CLUSTER_NAME="${CLUSTER_NAME:-jboss-cluster}"
MULTICAST_ADDR="${MULTICAST_ADDR:-224.0.1.105}"
MULTICAST_PORT="${MULTICAST_PORT:-45688}"
JGROUPS_JAR="${JGROUPS_JAR:-/opt/jgroups/jgroups.jar}"
BIND_ADDR=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]}' | head -1)

echo "=== JGroups Cluster Member ==="
echo "Cluster Name: $CLUSTER_NAME"
echo "Multicast Address: $MULTICAST_ADDR"
echo "Port: $MULTICAST_PORT"
echo "Bind Address: $BIND_ADDR"
echo ""
echo "Joining cluster... (other nodes should appear when they join)"
echo ""

# Create a minimal UDP-based JGroups config compatible with JGroups 5.3.x
cat > /tmp/jgroups-udp.xml << EOF
<config xmlns="urn:org:jgroups"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="urn:org:jgroups http://www.jgroups.org/schema/jgroups.xsd">
    <UDP
         mcast_group_addr="$MULTICAST_ADDR"
         mcast_port="$MULTICAST_PORT"
         ip_ttl="4"
         tos="8"
         ucast_recv_buf_size="5M"
         ucast_send_buf_size="640K"
         mcast_recv_buf_size="5M"
         mcast_send_buf_size="640K"
         thread_pool.min_threads="0"
         thread_pool.max_threads="20"
         thread_pool.keep_alive_time="30000"/>

    <PING />
    <MERGE3 max_interval="30000" min_interval="10000"/>
    <FD_SOCK />
    <FD_ALL3 timeout="10000" interval="3000"/>
    <VERIFY_SUSPECT timeout="1500"/>
    <pbcast.NAKACK2 xmit_interval="500"
                    xmit_table_num_rows="100"
                    xmit_table_msgs_per_row="2000"
                    xmit_table_max_compaction_time="30000"/>
    <UNICAST3 xmit_interval="500"
              xmit_table_num_rows="100"
              xmit_table_msgs_per_row="2000"
              xmit_table_max_compaction_time="60000"/>
    <pbcast.STABLE desired_avg_gossip="50000"
                   max_bytes="4M"/>
    <pbcast.GMS print_local_addr="true" join_timeout="2000"/>
    <UFC max_credits="2M" min_threshold="0.4"/>
    <MFC max_credits="2M" min_threshold="0.4"/>
    <FRAG4 frag_size="60000"/>
</config>
EOF

exec java -cp "$JGROUPS_JAR" \
    -Djgroups.bind_addr="$BIND_ADDR" \
    -Djava.net.preferIPv4Stack=true \
    org.jgroups.demos.Chat \
    -props /tmp/jgroups-udp.xml \
    -name "$(hostname)"
