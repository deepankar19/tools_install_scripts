#!/bin/bash

# Usage: ./monitor_process.sh <process_name>
# Ensure a process is always running, and restart it if it stops.

# Command-line argument: process to monitor
PROCESS_NAME="$1"
MAX_RESTARTS=3
RESTART_COUNT=0

# Function to check if process is running
check_process() {
 if pgrep -x "$PROCESS_NAME" > /dev/null
 then
 echo "Process $PROCESS_NAME is running."
 return 0
 else
 echo "Process $PROCESS_NAME is not running."
 return 1
 fi
}

# Function to restart process
restart_process() {
 if [ "$RESTART_COUNT" -lt "$MAX_RESTARTS" ]; then
 echo "Attempting to restart $PROCESS_NAME..."
 # Restart the process (this assumes the process can be started by just its name)
 $PROCESS_NAME &
 sleep 2
 if check_process; then
 echo "Successfully restarted $PROCESS_NAME."
 RESTART_COUNT=0 # Reset restart count after a successful restart
 else
 echo "Failed to restart $PROCESS_NAME."
 ((RESTART_COUNT++))
 fi
 else
 echo "Max restart attempts reached. Manual intervention required."
 notify_admin
 fi
}

# Function to send a notification if process needs manual intervention
notify_admin() {
 # Example: Sending an email to admin
 echo "Process $PROCESS_NAME needs manual intervention after $MAX_RESTARTS failed attempts" | mail -s "$PROCESS_NAME down" admin@example.com
}

# Main loop: Check process and restart if necessary
if [ -z "$PROCESS_NAME" ]; then
 echo "Usage: $0 <process_name>"
 exit 1
fi