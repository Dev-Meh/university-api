#!/bin/bash

export $(grep -v '^#' .env | xargs)

touch $LOG_FILE 2>/dev/null || { echo "Cannot write to $LOG_FILE. Run with sudo?"; exit 1; }

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "==== Health Check: $TIMESTAMP ====" >> $LOG_FILE

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
echo "CPU Usage: $CPU_USAGE%" >> $LOG_FILE
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    echo "WARNING: High CPU usage detected!" >> $LOG_FILE
fi

MEM_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
echo "Memory Usage: $MEM_USAGE%" >> $LOG_FILE
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    echo "WARNING: High memory usage detected!" >> $LOG_FILE
fi

DISK_USAGE=$(df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')
echo "Disk Usage: $DISK_USAGE%" >> $LOG_FILE
if [ $DISK_USAGE -gt $((100 - $DISK_THRESHOLD)) ]; then
    echo "WARNING: Low disk space! Only $((100 - $DISK_USAGE))% available." >> $LOG_FILE
fi

WEB_SERVER=$(ps aux | grep -E 'apache2|nginx' | head -n 1 | awk '{print $11}' | cut -d'/' -f2)
if [ -z "$WEB_SERVER" ]; then
    echo "WARNING: Web server is not running!" >> $LOG_FILE
else
    echo "Web Server ($WEB_SERVER) Status: Running" >> $LOG_FILE
fi

STUDENTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $STUDENTS_ENDPOINT)
if [ $STUDENTS_STATUS -eq 200 ]; then
    echo "API Endpoint /students: OK (200)" >> $LOG_FILE
else
    echo "WARNING: API Endpoint /students returned status $STUDENTS_STATUS" >> $LOG_FILE
fi

SUBJECTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $SUBJECTS_ENDPOINT)
if [ $SUBJECTS_STATUS -eq 200 ]; then
    echo "API Endpoint /subjects: OK (200)" >> $LOG_FILE
else
    echo "WARNING: API Endpoint /subjects returned status $SUBJECTS_STATUS" >> $LOG_FILE
fi

echo "Health check completed." >> $LOG_FILE
echo "" >> $LOG_FILE
