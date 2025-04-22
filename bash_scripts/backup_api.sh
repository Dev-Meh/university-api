#!/bin/bash

set -e

export $(grep -v '^#' .env | xargs)

mkdir -p $BACKUP_DIR

API_BACKUP="$BACKUP_DIR/api_backup_$(date +%F).tar.gz"
echo "$(date "+%Y-%m-%d %H:%M:%S") - Creating API backup..." >> $LOG_FILE
tar -czf $API_BACKUP $API_DIR
echo "$(date "+%Y-%m-%d %H:%M:%S") - API backup created at $API_BACKUP" >> $LOG_FILE

DB_BACKUP="$BACKUP_DIR/db_backup_$(date +%F).sql"
echo "$(date "+%Y-%m-%d %H:%M:%S") - Creating database backup..." >> $LOG_FILE
PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER $DB_NAME > $DB_BACKUP
echo "$(date "+%Y-%m-%d %H:%M:%S") - Database backup created at $DB_BACKUP" >> $LOG_FILE

echo "$(date "+%Y-%m-%d %H:%M:%S") - Removing backups older than 7 days..." >> $LOG_FILE
find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;
echo "$(date "+%Y-%m-%d %H:%M:%S") - Old backups removed" >> $LOG_FILE
