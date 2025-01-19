# ShadowCopyX
![GitHub License](https://img.shields.io/github/license/Shehan-Anuradha/ShadowCopyX)
**ShadowCopyX** is a powerful, automated file backup and restoration tool designed for Windows. It utilizes `7-Zip` for efficient compression and encryption, making backups secure and reliable.

## Features  
- **Automated Backups**  
  - Schedule daily, weekly, or monthly backups.  
  - Secure backup files using AES-256 encryption.  

- **Easy Restoration**  
  - Restore files to their original locations.  
  - View logs of previous backup and restore operations.  

- **Customizable Settings**  
  - Modify backup directories, schedules, and passwords.  
  - Set up logging for troubleshooting and monitoring.  

- **Task Scheduling**  
  - Integrates with Windows Task Scheduler for automated execution.  
  - Supports manual and scheduled backup modes.  

## Installation  
1. **Install 7-Zip** (Required)  
   - Download and install [7-Zip](https://www.7-zip.org/download.html).  

2. **Clone or Download the Repository**  
   ```sh
   git clone https://github.com/yourusername/ShadowCopyX.git
   cd ShadowCopyX


## Usage  

### Run the Script  
- **Open PowerShell as Administrator**  
  - Press `Win + X`, then select **PowerShell (Admin)**.  
  - Navigate to the script directory:  
   
    cd C:\Path\To\ShadowCopyX
 
  - Run the script:  
  
    .\ShadowCopyX.ps1
  

### Manual Backup  
- **Run the script and choose:**  
  - `6. Backup Files Now` to perform an instant backup.  

### Scheduled Backup  
- **Run the script and choose:**  
  - `3. Schedule Backup` to set up automated backups.  

### Restore Files  
- **Run the script and choose:**  
  - `7. Restore Files Now` to extract the latest backup.  

### View Logs  
- **Run the script and choose:**  
  - `8. View Logs` to check past backup and restore activities.  

## Configuration  
Modify the script variables to customize settings:  

```powershell
$Global:defaultBackupDir = "C:\Backup\"
$Global:defaultRestoreDir = "C:\Restore\"
$Global:defaultFrequency = "daily"
$Global:defaultPassword = "MySecurePassword"

## License
This project is licensed under the [MIT License](https://github.com/Shehan-Anuradha/ShadowCopyX/blob/master/LICENSE).

