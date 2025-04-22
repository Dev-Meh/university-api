#!/bin/bash

set -e

export $(grep -v '^#' .env | xargs)

echo "$(date "+%Y-%m-%d %H:%M:%S") - Updating Ubuntu packages..." >> $LOG_FILE
apt update && apt upgrade -y
echo "$(date "+%Y-%m-%d %H:%M:%S") - Ubuntu packages updated successfully" >> $LOG_FILE

echo "$(date "+%Y-%m-%d %H:%M:%S") - Pulling latest changes from GitHub..." >> $LOG_FILE
cd $API_DIR
git pull origin main
echo "$(date "+%Y-%m-%d %H:%M:%S") - GitHub repository updated" >> $LOG_FILE

echo "$(date "+%Y-%m-%d %H:%M:%S") - Restarting web server..." >> $LOG_FILE
systemctl restart $WEB_SERVER
echo "$(date "+%Y-%m-%d %H:%M:%S") - Web server restarted successfully" >> $LOG_FILE
