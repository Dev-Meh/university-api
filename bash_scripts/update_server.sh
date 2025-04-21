
LOG_FILE="/var/log/update_server.log"
REPO_DIR="/home/ubuntu/your-repo-name"  
WEB_SERVER="apache2"  


touch $LOG_FILE 2>/dev/null || { echo "Cannot write to $LOG_FILE. Run with sudo?"; exit 1; }


TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "==== Server Update: $TIMESTAMP ====" >> $LOG_FILE


echo "Updating system packages..." >> $LOG_FILE
apt-get update >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "Package lists updated successfully." >> $LOG_FILE
    
   
    echo "Upgrading packages..." >> $LOG_FILE
    apt-get upgrade -y >> $LOG_FILE 2>&1
    if [ $? -eq 0 ]; then
        echo "Packages upgraded successfully." >> $LOG_FILE
    else
        echo "WARNING: Package upgrade completed with errors." >> $LOG_FILE
    fi
else
    echo "ERROR: Failed to update package lists!" >> $LOG_FILE
fi


echo "Pulling latest code from repository..." >> $LOG_FILE
cd $REPO_DIR || { echo "ERROR: Could not change to repository directory!" >> $LOG_FILE; exit 1; }


OLD_COMMIT=$(git rev-parse HEAD)


git fetch >> $LOG_FILE 2>&1
git pull >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    NEW_COMMIT=$(git rev-parse HEAD)
    
    if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
        echo "Repository updated from $OLD_COMMIT to $NEW_COMMIT" >> $LOG_FILE
        
        
        COMMIT_MSG=$(git log -1 --pretty=format:"%s")
        echo "Latest commit: $COMMIT_MSG" >> $LOG_FILE
        
       
        if [[ $COMMIT_MSG == *"[restart]"* ]]; then
            echo "Restart flag found in commit message. Restarting web server..." >> $LOG_FILE
            systemctl restart $WEB_SERVER >> $LOG_FILE 2>&1
            if [ $? -eq 0 ]; then
                echo "$WEB_SERVER restarted successfully." >> $LOG_FILE
            else
                echo "ERROR: Failed to restart $WEB_SERVER!" >> $LOG_FILE
            fi
        else
            echo "No restart needed based on commit message." >> $LOG_FILE
        fi
    else
        echo "No new updates available. Repository already up to date." >> $LOG_FILE
    fi
else
    echo "ERROR: Failed to pull latest changes!" >> $LOG_FILE
fi


if systemctl is-active --quiet $WEB_SERVER; then
    echo "$WEB_SERVER is running correctly." >> $LOG_FILE
else
    echo "WARNING: $WEB_SERVER is not running! Attempting to start..." >> $LOG_FILE
    systemctl start $WEB_SERVER >> $LOG_FILE 2>&1
    if [ $? -eq 0 ]; then
        echo "$WEB_SERVER started successfully." >> $LOG_FILE
    else
        echo "ERROR: Failed to start $WEB_SERVER!" >> $LOG_FILE
    fi
fi

echo "Update process completed at $(date "+%Y-%m-%d %H:%M:%S")" >> $LOG_FILE
echo "" >> $LOG_FILE