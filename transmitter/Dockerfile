FROM alpine:3.19

LABEL org.opencontainers.image.source="https://github.com/NiranEC77/multicast-test-pods"
LABEL org.opencontainers.image.description="Multicast transmitter for JBoss/JGroups testing"
LABEL org.opencontainers.image.licenses="MIT"

# Install required packages
# - socat for basic multicast sending
# - Java for JGroups protocol testing
RUN apk add --no-cache \
    socat \
    iproute2 \
    iputils \
    bash \
    openjdk17-jre-headless \
    curl \
    && rm -rf /var/cache/apk/*

# Download JGroups JAR
ENV JGROUPS_VERSION=5.3.1.Final
RUN mkdir -p /opt/jgroups && \
    curl -sL "https://repo1.maven.org/maven2/org/jgroups/jgroups/${JGROUPS_VERSION}/jgroups-${JGROUPS_VERSION}.jar" \
    -o /opt/jgroups/jgroups.jar

# Copy scripts
COPY scripts/ /opt/multicast/

# Make scripts executable
RUN chmod +x /opt/multicast/*.sh

# Set working directory
WORKDIR /opt/multicast

# Default environment variables
ENV MULTICAST_ADDR=224.0.1.105
ENV MULTICAST_PORT=45688
ENV INTERVAL=2
ENV JGROUPS_JAR=/opt/jgroups/jgroups.jar

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
