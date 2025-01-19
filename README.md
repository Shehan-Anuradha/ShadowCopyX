ShadowCopyX

ShadowCopyX is a powerful and efficient backup and restoration tool built with PowerShell. It enables seamless file backup and restoration while ensuring data integrity. With an intuitive command-line interface, ShadowCopyX simplifies scheduling automated backups, restoring files, and managing logs.

Features

Automated Backups – Schedule backups daily, weekly, or monthly.

Secure Backup – Encrypt backups using 7-Zip with a custom password.

Restoration Support – Restore files efficiently to their original location.

Logging System – Maintain logs for backup and restore activities.

User-friendly CLI – Easy-to-use command-line interface.

Installation

Clone the repository:

git clone https://github.com/yourusername/ShadowCopyX.git
cd ShadowCopyX

Run the script:

powershell -ExecutionPolicy Bypass -File ShadowCopyX.ps1

Ensure 7-Zip is installed (required for compression):

Download and install 7-Zip from https://www.7-zip.org.

Usage

Running the Script

Execute the script by running:

powershell -File ShadowCopyX.ps1

Menu Options

Once executed, the script provides an interactive menu:

 1. Check Configurations
 2. Change Configurations
 3. Schedule Backup
 4. View Scheduled Tasks
 5. Clear Scheduled Tasks
 6. Backup Files Now
 7. Restore Files Now
 8. View Logs
 9. Exit

Scheduling a Backup

To schedule an automated backup:

.\ShadowCopyX.ps1 -Mode schedule

Running a Manual Backup

.\ShadowCopyX.ps1 -Mode manual

Restoring Files

.\ShadowCopyX.ps1 -Mode restore

Configuration

The script provides default configuration settings:

Parameter

Default Value

Backup Directory

.ackups\

Restore Directory

`.

estore`

Source Directory

.\source\

Backup Frequency

daily

Encryption Password

MySecurePassword

Log File Path

`.

estore\Restore.txt`

Scheduled Time

02:00

To modify configurations, select option 2 in the main menu.

Logging System

Backup and restore operations are logged in Restore.txt inside the restore directory. To view logs, select option 8 from the menu.

Contributing

Contributions are welcome! Please follow these steps:

Fork the repository.

Create a new branch (feature-branch).

Commit your changes.

Push to your branch and create a Pull Request.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Author

Shehan Anuradha🚀 Created with PowerShell for efficient backups!
