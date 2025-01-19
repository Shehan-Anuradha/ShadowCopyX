ShadowCopyX

ShadowCopyX is a powerful, lightweight, and user-friendly backup automation tool for Windows, built using PowerShell. It enables seamless file backup and restoration with integrity verification, utilizing 7-Zip for compression and Windows Task Scheduler for automated execution.

Features

✅ Automated Backups – Schedule daily, weekly, or monthly backups effortlessly.✅ Secure Compression – Uses 7-Zip with password protection for enhanced security.✅ One-Click Restore – Easily retrieve lost files with minimal effort.✅ Customizable Configuration – Modify settings like backup location, frequency, and encryption key.✅ Integrity Verification – Ensures data accuracy after extraction.✅ Lightweight & Fast – Runs efficiently in the background without slowing down your system.

Installation

Prerequisites

Windows 10 or later

PowerShell 5.1+

7-Zip (Ensure 7z.exe is installed at C:\Program Files\7-Zip\7z.exe or modify the script accordingly)

Setup

Clone the repository:

git clone https://github.com/yourusername/ShadowCopyX.git
cd ShadowCopyX

Ensure execution policy allows running scripts:

Set-ExecutionPolicy Bypass -Scope Process -Force

Run the script:

.\ShadowCopyX.ps1

Usage

Main Menu

Upon running the script, you will be presented with the following options:

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

To schedule an automatic backup:

Select option 3 from the menu.

Choose the backup frequency (Daily, Weekly, or Monthly).

Specify the time for the backup to execute.

The script will create a Windows Scheduled Task to run the backup automatically.

Running a Backup Manually

Select option 6 to perform an immediate backup of your files.

Restoring Files

Select option 7 and choose the backup archive you want to restore.

Viewing Logs

Select option 8 to check backup and restore logs.

Converting to EXE

To convert this script into an .exe file with an icon:

Use PS2EXE:

Install-Module ps2exe -Scope CurrentUser
ps2exe .\ShadowCopyX.ps1 .\ShadowCopyX.exe -icon .\icon.ico

The ShadowCopyX.exe file will be generated, allowing you to run it without opening PowerShell.

Troubleshooting

Issue: Access Denied Errors

Run PowerShell as Administrator.

Ensure the script has permission to write to the configured backup directory.

Issue: 7-Zip Not Found

Ensure 7z.exe is installed in C:\Program Files\7-Zip\

Update $Global:defaultSevenZipPath in the script if installed elsewhere.
