
BACKUP_DIR="/home/ubuntu/backups"
API_DIR="/var/www/html/api" 
DB_NAME="api_database"       
DB_USER="db_user"            
DB_PASS="db_password"       
MAX_BACKUPS_AGE=7          
LOG_FILE="/var/log/backup_api.log"


touch $LOG_FILE 2>/dev/null || { echo "Cannot write to $LOG_FILE. Run with sudo?"; exit 1; }

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="$BACKUP_DIR/api_backup_$TIMESTAMP"


LOG_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "==== Backup Started: $LOG_TIMESTAMP ====" >> $LOG_FILE

mkdir -p $BACKUP_DIR
mkdir -p $BACKUP_PATH


echo "Backing up API files from $API_DIR to $BACKUP_PATH/files..." >> $LOG_FILE
if cp -r $API_DIR $BACKUP_PATH/files; then
    echo "API files backup successful." >> $LOG_FILE
else
    echo "ERROR: API files backup failed!" >> $LOG_FILE
fi

echo "Exporting database $DB_NAME..." >> $LOG_FILE
if mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_PATH/$DB_NAME.sql; then
    echo "Database export successful." >> $LOG_FILE
else
    echo "WARNING: Database export failed or no database in use." >> $LOG_FILE
fi


echo "Creating compressed archive..." >> $LOG_FILE
tar -czf $BACKUP_PATH.tar.gz -C $BACKUP_DIR $(basename $BACKUP_PATH)
if [ $? -eq 0 ]; then
    echo "Compressed backup created at $BACKUP_PATH.tar.gz" >> $LOG_FILE
   
    rm -rf $BACKUP_PATH
else
    echo "ERROR: Failed to create compressed backup!" >> $LOG_FILE
fi

echo "Removing backups older than $MAX_BACKUPS_AGE days..." >> $LOG_FILE
find $BACKUP_DIR -name "api_backup_*" -type f -mtime +$MAX_BACKUPS_AGE -delete
if [ $? -eq 0 ]; then
    echo "Old backups cleaned up successfully." >> $LOG_FILE
else
    echo "WARNING: Failed to clean up some old backups." >> $LOG_FILE
fi


TOTAL_SIZE=$(du -sh $BACKUP_DIR | cut -f1)
echo "Total backup size: $TOTAL_SIZE" >> $LOG_FILE


echo "Backup completed at $(date "+%Y-%m-%d %H:%M:%S")" >> $LOG_FILE
echo "" >> $LOG_FILE