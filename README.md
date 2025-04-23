#GITHUB REPOSTORY URL
https://github.com/Dev-Meh/university-api.git

#student API url 
http://13.61.2.151:8000/api/studensts/

#subject API url
http://13.61.2.151:8000/api/subjects/


Backup Schemes
Here are three common backup schemes used in server management:
1. Full Backup
How it works:
A full backup copies every selected file to the backup storage location. This happens regardless of whether files have changed since the last backup.
Command example:
bashtar -czf backup-full-2025-04-21.tar.gz /var/www/myapi/

Advantages:
i. Easy to understand - everything is in one place
ii. Quick restoration process
iii. No dependencies on other backups
iv. Most reliable when you need to recover everything

Disadvantages:
i. Takes up the most storage space
ii. Longest time to complete
iii. Wastes resources backing up unchanged files
iv. Heavy on network if backing up remotely

2. Incremental Backup
How it works:
Only backs up files that changed since the last backup (whether that was full or incremental). Creates a chain of backups.
Command example:
bashtar --listed-incremental=snapshot.file -czf backup-inc-2025-04-21.tar.gz /var/www/myapi/

Advantages:
i. Fastest backup process
ii. Uses minimal storage space
iii. Less network traffic
iv. Perfect for daily backups of large systems


Disadvantages:
i. Complex restoration - needs last full backup plus all incremental backups
ii. Higher risk if any backup in the chain gets corrupted
iii. Takes longer to restore
iv. Requires careful tracking of backup files

3. Differential Backup
How it works:
Backs up all files that changed since the last full backup (not since the last differential backup).
Command example:
bashrsync -a --compare-dest=/path/to/fullbackup/ /var/www/myapi/ /path/to/diff-backup-2025-04-21/

Advantages:
i. Easier restoration than incremental (just need full + latest differential)
ii. Faster than doing full backups every time
iii. Middle ground for storage needs
iv. More reliable if a backup gets corrupted


Disadvantages:
i. Backups get larger over time as more files change
ii. Uses more space than incremental backups
iii. Slower than incremental backups
Less efficient for long backup cycles





logs

==== Health Check: 2025-04-22 17:18:30 ====
CPU Usage: 6%
Memory Usage: 31%
Disk Usage: 44%
WARNING: Web server not running!
WARNING: API Endpoint /students returned status 301
WARNING: API Endpoint /subjects returned status 301
Health check completed.

2025-04-22 17:18:45 - Creating API backup at /home/ubuntu/backups/api_backup_2025-04-22.tar.gz
2025-04-22 17:18:45 - Creating DB backup at /home/ubuntu/backups/db_backup_2025-04-22.sql
2025-04-22 17:18:45 - Cleaning old backups...
2025-04-22 17:19:03 - Updating Ubuntu packages...
2025-04-22 17:19:11 - Ubuntu packages updated successfully
2025-04-22 17:19:11 - Pulling latest changes from GitHub...
2025-04-22 17:19:11 - GitHub repository updated
2025-04-22 17:19:11 - Restarting web server...

===== /var/log/backup.log =====
2025-04-23 02:00:03 - Starting backup process...
2025-04-23 02:00:03 - Creating API backup at /home/ubuntu/backups/api_backup_2025-04-23.tar.gz
2025-04-23 02:00:03 - API backup completed
2025-04-23 02:00:03 - Creating DB backup at /home/ubuntu/backups/db_backup_2025-04-23.sql
2025-04-23 02:00:04 - Database backup completed
2025-04-23 02:00:04 - Cleaning old backups...
2025-04-23 02:00:04 - Old backups cleaned up

===== /var/log/update.log =====
2025-04-23 01:59:34 - Updating Ubuntu packages...
2025-04-23 01:59:40 - Ubuntu packages updated successfully
2025-04-23 01:59:40 - Pulling latest changes from GitHub...
2025-04-23 01:59:41 - GitHub repository updated
2025-04-23 01:59:41 - Restarting web server...
