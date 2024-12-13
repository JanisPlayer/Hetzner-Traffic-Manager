#!/bin/bash

# Configuration
API_TOKEN=""  # Set your Hetzner Cloud API token here
SERVER_ID=""  # Set your Hetzner server ID without # here
LIMIT_TB_OFFSET=-1
LIMIT_TB_OFFSET_FLOAT=1 # 10/5 = 2

# Calculation basis (1 TB = 1024^4 Bytes)
LIMIT_BYTES_OFFSET=$((LIMIT_TB_OFFSET * 1024**4))/$((LIMIT_TB_OFFSET_FLOAT))

# Function to get server information in JSON format
function get_servers_json() {
    curl -s -H "Authorization: Bearer $API_TOKEN" \
        "https://api.hetzner.cloud/v1/servers/#$SERVER_ID"
}

# Function to get the server's status
function get_status() {
        echo $SERVERS_JSON | \
        jq -r '.servers[].status'
}

# Function to get outgoing traffic
function get_traffic() {
        echo $SERVERS_JSON | \
        jq -r '.servers[].outgoing_traffic'
}

# Function to get traffic limit
function get_traffic_limit() {
        echo $SERVERS_JSON | \
        jq -r '.servers[].included_traffic'
}

# Function to shut down the server
function shutdown_server() {
    echo "Shutting down server with ID $SERVER_ID ..."
    curl -s -X POST -H "Authorization: Bearer $API_TOKEN" \
        "https://api.hetzner.cloud/v1/servers/$SERVER_ID/actions/shutdown"
}

# Main program
SERVERS_JSON=$(get_servers_json)
STATUS=$(get_status)
TRAFFIC_BYTES=$(get_traffic)
TRAFFIC_BYTES_LIMIT=$(get_traffic_limit)
LIMIT_BYTES=$((TRAFFIC_BYTES_LIMIT+LIMIT_BYTES_OFFSET))

echo "Current outgoing traffic: $((TRAFFIC_BYTES / 1024**3)) GB"
echo "Outgoing traffic limit: $((TRAFFIC_BYTES_LIMIT / 1024**4)) TB (including offset): $((LIMIT_BYTES / 1024**4)) TB"

# Check server status and if traffic exceeds the limit
if [[ "$STATUS" == "running" ]]; then
  if ((TRAFFIC_BYTES >= LIMIT_BYTES)); then
      echo "Traffic limit of $LIMIT_TB TB reached! The server will be shut down."
      shutdown_server
  else
      echo "Traffic limit not reached yet. Current traffic: $TRAFFIC_BYTES Bytes of $LIMIT_BYTES Bytes"
  fi
else
  echo "Server is stopped"
fi

