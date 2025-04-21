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




Bash Scripts for Server Management

These scripts help manage my server and API by monitoring, backing up, and updating.


 Scripts Overview

 I. health_check.sh
This script monitors:
- CPU usage (warns if above 80%)
- Memory usage (warns if above 80%)
- Disk space (warns if less than 10% available)
- Web server status (apache2 or nginx)
- API endpoints (/students and /subjects)
- All results logged to /var/log/server_health.log

 II. backup_api.sh
This script handles backups:
- Creates backups of API files from /var/www/html/api
- Exports the database (api_database)
- Compresses everything to tar.gz format
- Removes backups older than 7 days
- Logs all operations to /var/log/backup_api.log

 III. update_server.sh
This script updates the server:
- Updates Ubuntu packages (apt-get update & upgrade)
- Pulls latest code from https://github.com/Dev-Meh/university-api.git
- Restarts the web server when needed
- Logs everything to /var/log/update_server.log

 My Backup Scheme

I. Daily backups at 2:00 AM using cron
II. 7-day retention policy (older ones get deleted)
III. Storage location: /home/ubuntu/backups
IV. Format: tar.gz compressed archives
V. Contents: API files + database dump

 Cron Jobs Configuration

I. Edit crontab:
```
crontab -e
```

II. Add these entries:
```
0 * * * * /home/ubuntu/university-api/bash_scripts/health_check.sh
0 2 * * * /home/ubuntu/university-api/bash_scripts/backup_api.sh
0 4 * * * /home/ubuntu/university-api/bash_scripts/update_server.sh
```

III. Save and exit

 Troubleshooting Tips

I. Check script permissions (should be executable)
II. Review log files for errors
III. Verify paths in scripts match your setup
IV. Try running scripts with sudo if permission errors occur
