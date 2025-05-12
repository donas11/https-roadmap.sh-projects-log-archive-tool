# [project page URL](https://roadmap.sh/projects/log-archive-tool)    
# Log Archive Tool
Build a tool to archive logs from the CLI with the date and time.

In this project, you will build a tool to archive logs on a set schedule by compressing them and storing them in a new directory, this is especially useful for removing old logs and keeping the system clean while maintaining the logs in a compressed format for future reference. This project will help you practice your programming skills, including working with files and directories, and building a simple cli tool.

The most common location for logs on a unix based system is `/var/log`.

# Requirements
The tool should run from the command line, accept the log directory as an argument, compress the logs, and store them in a new directory. The user should be able to:

Provide the log directory as an argument when running the tool.

´´´
log-archive log-directory
´´´

The tool should compress the logs in a tar.gz file and store them in a new directory.
The tool should log the date and time of the archive to a file.

´´´logs_archive_20240816_100648.tar.gz
´´´
You can learn more about the tar command [here.](https://www.gnu.org/software/tar/manual/tar.html)

If you are looking to build a more advanced version of this project, you can consider adding functionality to the tool like emailing the user updates on the archive, or sending the archive to a remote server or cloud storage.


#  How to run

´´´bash log-archive name-directory-with-logs
´´´

## Copy to Google email
Create a New App password

´´´bash config-email.sh correoenvio@gmail.com --ask
> New_App_password
´´´

´´´bash send-logs-email.sh "Receptor@gmail.com" "Logs Compresed" "Adjunto Logs Comprimidos" "./compresed_logs/log-archive_date.tar.gz"
´´´

## Copy all compresed files to GDrive

´´´curl https://rclone.org/install.sh | sudo bash
´´´

´´´rclone config
´´´

´´´cd /compresed_logs
rclone copy ./ logsdrive: --include "*.tar.gz"
´´´
