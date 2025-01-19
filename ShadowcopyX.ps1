param (
    [string]$Mode = "manual",  # Default mode is manual unless "schedule" is passed
    [string]$BackupDirectory = ""
)


# Default values
$Global:defaultScriptPath = $PSScriptRoot  
$Global:CurrentScriptFile = $MyInvocation.MyCommand.Definition
$Global:defaultBackupDir = "$PSScriptRoot\backups\"
$Global:defaultRestoreDir = "$PSScriptRoot\restore\"
$Global:defaultSourceDir = "$PSScriptRoot\source\"
$Global:defaultFrequency = "daily"
$Global:defaultPassword =  "MySecurePassword"
$Global:defaultSevenZipPath = "C:\Program Files\7-Zip\7z.exe"
$Global:defaultRestoreLogFilePath = "$PSScriptRoot\Restore\Restore.txt "
$Global:defaultBackupLogFilePath = "$PSScriptRoot\backups\backup.txt"
$Global:defaultTime = "02:00"
$banner = @"
  ________ __    __      __      ________     ______   __   __  ___  ______   ______   _______ ___  ___ ___  ___  
  /"       )" |  | "\    /""\    |"      "\   /    " \ |"  |/  \|  "|/" _  "\ /    " \ |   __ "\"  \/"  |"  \/"  | 
  (:   \___(:  (__)  :)  /    \   (.  ___  :) // ____  \|'  /    \:  (: ( \___)/ ____  \(. |__) :)   \  / \   \  /  
  \___  \  \/      \/  /' /\  \  |: \   ) ||/  /    ) :): /'        |\/ \   /  /    ) :):  ____/ \\  \/   \\  \/   
  __/  \\ //  __  \\ //  __'  \ (| (___\ |(: (____/ // \//  /\'    |//  \ (: (____/ //(|  /     /   /    /\.  \   
  /" \   :|:  (  )  :)   /  \\  \|:       :)\        /  /   /  \\   (:   _) \        //|__/ \   /   /    /  \   \  
  (_______/ \__|  |__(___/    \___|________/  \"_____/  |___/    \___|\_______)"_____/(_______) |___/    |___/\___| 
              

              Seamless file backup and restoration with integrity verification
              
              [    Powered by PowerShell      ] 
              [  Created by: Shehan Anuradha  ]
"@



while ($true) {
   
        if ($Mode -eq "Schedule") {
            Write-Host "Running scheduled backup task..."
            if (!(Test-Path $Global:defaultBackupDir)) {
                New-Item -ItemType Directory -Path $Global:defaultBackupDir | Out-Null
            }
        
            # Get all files recursively
            $Files = Get-ChildItem -Path $Global:defaultSourceDir -Recurse -File
        
            # Clear log file
            "" | Set-Content $defaultBackupLogFilePath
        
            # Process each file
            foreach ($File in $Files) {
                $RelativePath = $File.FullName.Replace($Global:defaultSourceDir, "").TrimStart("\")  # Maintain folder structure
                $ZipFile = "$Global:defaultBackupDir\$($RelativePath).zip"
        
                # Ensure the parent directory structure exists in backup location
                $ParentDir = Split-Path -Path $ZipFile
                if (!(Test-Path $ParentDir)) {
                    New-Item -ItemType Directory -Path $ParentDir | Out-Null
                }
        
                # Compute SHA-256 hash
                $Hash = (Get-FileHash -Algorithm SHA256 -Path $File.FullName).Hash
        
                # Use 7-Zip to create a password-protected archive
                & "$Global:defaultSevenZipPath" a -p"$Global:defaultPassword" -y -tzip "$ZipFile" "$($File.FullName)"
        
                # Log original file path, backup location, and hash
                "$($File.FullName) | $ZipFile | $Hash" | Add-Content -Path $defaultBackupLogFilePath
            }
            
            Write-Host "`nBackup completed successfully. Log file saved at: " -ForegroundColor Green -NoNewline
            Write-Host "$defaultBackupLogFilePath`n" -ForegroundColor Yellow
            exit# Exit after running once

    }elseif ($Mode -eq "testschedule") {
        Write-Host "Running scheduled backup task..."
            Start-Process chrome.exe '--new-window https://www.youtube.com/watch?v=GBIIQ0kP15E'
            $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "TestBackupTask" }
                        
                        if ($tasks) {
                            $tasks | ForEach-Object {
                                try {
                                    Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
                                    Write-Host "Deleted Task: $($_.TaskName)" -ForegroundColor Green
                                } catch {
                                    Write-Host "Failed to delete task: $($_.TaskName) - $_" -ForegroundColor Yellow
                                }
                            }
                        }
            exit # Exit after running once
    }

    else {
            #menu-----------------------------


                    #-------------------------------------schedule backup-------------------
                    function Schedule-BackupTask {
                        param (
                            [string]$ScriptPath,
                            [string]$BackupPath,
                            [string]$Frequency,
                            [string]$Time
                        )
                    
                        # Define Task Name
                        $taskName = "BackupTask_$Frequency"
                    
                        # Define Trigger Based on Frequency
                        switch ($Frequency.ToLower()) {
                            "daily" { $trigger = New-ScheduledTaskTrigger -Daily -At $Time }
                            "weekly" { $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At $Time }
                            "monthly" { $trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth 1 -At $Time }
                            default {
                                Write-Error "Invalid frequency. Please choose 'daily', 'weekly', or 'monthly'."
                                return
                            }
                        }
                    
                        # Define the Action
                        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
                            -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command `"& '$ScriptPath' -Mode Schedule -BackupDirectory '$BackupPath'`""
                    
                        # Register the Task
                        try {
                            Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Backup task scheduled to run $Frequency"
                            Write-Host "`n Task '$taskName' has been successfully scheduled." -ForegroundColor Green
                        } catch {
                            Write-Error "Failed to schedule the task: $_"
                        }
                    
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    

                    
                    
                    
                    
                    
                #-------------------------------------schedule backup-------------------/


                function change-config {
                    
                    Write-Host "`n"
                    
                    # Get User Input and Use Default Values if Empty
                    $inputSourceDir = Read-Host " Enter the directory for Sources (press Enter to use default [$defaultSourceDir])"
                    $inputBackupDir = Read-Host " Enter the directory for backups (press Enter to use default [$defaultBackupDir])"
                    $inputFrequency = Read-Host " Enter the backup frequency (daily, weekly, monthly) (press Enter to use default [$defaultFrequency])"
                    $inputTime = Read-Host " Enter the time for the backup to run (e.g., 21:23 for 9:23 PM) (press Enter to use default [$defaultTime])"
                    $password = Read-Host " Enter a new password (press Enter to use default [$defaultPassword])"
                    $7zipPath = Read-Host " Enter 7-zip path(press Enter to use default [$defaultSevenZipPath])"

                    # Assign Default Values if User Presses Enter
                    if ([string]::IsNullOrWhiteSpace($inputBackupDir)) { $inputBackupDir = $defaultBackupDir }
                    if ([string]::IsNullOrWhiteSpace($inputSourceDir)) { $inputSourceDir = $defaultSourceDir }
                    if ([string]::IsNullOrWhiteSpace($inputFrequency)) { $inputFrequency = $defaultFrequency }
                    if ([string]::IsNullOrWhiteSpace($inputTime)) { $inputTime = $defaultTime }
                    if ([string]::IsNullOrWhiteSpace($password)) { $password = $defaultPassword }
                    if ([string]::IsNullOrWhiteSpace($7zipPath)) { $7zipPath = $defaultSevenZipPath }

                    # Assign the values to Global Variables
                    $Global:defaultSourceDir = $inputSourceDir
                    $Global:defaultBackupDir = $inputBackupDir
                    $Global:defaultFrequency = $inputFrequency
                    $Global:defaultTime = $inputTime
                    $Global:defaultPassword = $password
                    $Global:defaultSevenZipPath =$7zipPath


                    # Display the new values
                    Write-Host "`n Using values:`n" 
                    Write-Host " Source path : $Global:defaultSourceDir" -ForegroundColor Green
                    Write-Host " Backup Path : $Global:defaultBackupDir" -ForegroundColor Green
                    Write-Host " Frequency   : $Global:defaultFrequency" -ForegroundColor Green
                    Write-Host " Time        : $Global:defaultTime" -ForegroundColor Green
                    Write-Host " Password    : $Global:defaultPassword" -ForegroundColor Green
                    Write-Host " 7-zip Path  : $Global:defaultSevenZipPath" -ForegroundColor Green
                    


                    # Wait for user to press Enter before returning to the menu
                    Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                    Read-Host | Out-Null

                    }


                    #--------------load config---------------------------
                    function check-Config {
                        Write-Host "`n"
                        Write-Host " Loaded Configuration:`n"
                        Write-Host "  Script Path:        $Global:defaultScriptPath" -ForegroundColor Green
                        Write-Host "  Frequency:          $Global:defaultFrequency" -ForegroundColor Green
                        Write-Host "  Time:               $Global:defaultTime" -ForegroundColor Green
                        Write-Host "  Source Directory:   $Global:defaultSourceDir" -ForegroundColor Green
                        Write-Host "  Backup Directory:   $Global:defaultBackupDir" -ForegroundColor Green
                        Write-Host "  Password:           $Global:defaultPassword" -ForegroundColor Green
                        Write-Host "  7-Zip Path:         $Global:defaultSevenZipPath" -ForegroundColor Green
                        Write-Host "  Restore Log File:   $Global:defaultRestoreLogFilePath" -ForegroundColor Green
                    
                        # Wait for user to press Enter before returning to the menu
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    
                    #--------------------------------view scheduled tasks---------------------------------------
                    function View-ScheduledBackups {
                        Write-Host "`n Existing Scheduled Backup Tasks:" -ForegroundColor Cyan
                    
                        # Get tasks related to the backup (Filtering by "BackupTask_" prefix)
                        $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "BackupTask_*" }
                        
                        if ($tasks) {
                            $tasks | ForEach-Object {
                                $taskInfo = Get-ScheduledTaskInfo -TaskName $_.TaskName
                                Write-Host "`n Task Name:         $($_.TaskName)" -ForegroundColor Green
                                Write-Host " Status:             $($_.State)"
                                Write-Host " Next Run Time:      $($taskInfo.NextRunTime)"
                               
                            } 
                        } else {
                            Write-Host " No scheduled backup tasks found." -ForegroundColor Yellow
                        }
                    
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    #--------------------------------view scheduled tasks---------------------------------------/
                    #--------------------------------------clear existing scheduled tasks--------------------------------------
                    function Clear-ScheduledBackups {
                        Write-Host "`n Clearing All Scheduled Backup Tasks..." -ForegroundColor Red
                    
                        # Get all scheduled backup tasks matching the pattern
                        $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "BackupTask_*" }
                        
                        if ($tasks) {
                            $tasks | ForEach-Object {
                                try {
                                    Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
                                    Write-Host " Deleted Task: $($_.TaskName)" -ForegroundColor Green
                                } catch {
                                    Write-Host " Failed to delete task: $($_.TaskName) - $_" -ForegroundColor Yellow
                                }
                            }
                        } else {
                            Write-Host " No scheduled backup tasks found to delete." -ForegroundColor Yellow
                        }
                    
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    #--------------------------------------clear existing scheduled tasks--------------------------------------/

                    #---------------------------------------------backup and zip------------------------------------------   
                    function Backup-Files {
                        # Ensure backup directory exists
                        if (!(Test-Path $Global:defaultBackupDir)) {
                            New-Item -ItemType Directory -Path $Global:defaultBackupDir | Out-Null
                        }
                    
                        # Get all files recursively
                        $Files = Get-ChildItem -Path $Global:defaultSourceDir -Recurse -File
                    
                        # Clear log file
                        "" | Set-Content $defaultBackupLogFilePath
                    
                        # Process each file
                        foreach ($File in $Files) {
                            $RelativePath = $File.FullName.Replace($Global:defaultSourceDir, "").TrimStart("\")  # Maintain folder structure
                            $ZipFile = "$Global:defaultBackupDir\$($RelativePath).zip"
                    
                            # Ensure the parent directory structure exists in backup location
                            $ParentDir = Split-Path -Path $ZipFile
                            if (!(Test-Path $ParentDir)) {
                                New-Item -ItemType Directory -Path $ParentDir | Out-Null
                            }
                    
                            # Compute SHA-256 hash
                            $Hash = (Get-FileHash -Algorithm SHA256 -Path $File.FullName).Hash
                    
                            # Use 7-Zip to create a password-protected archive
                            & "$Global:defaultSevenZipPath" a -p"$Global:defaultPassword" -y -tzip "$ZipFile" "$($File.FullName)"
                    
                            # Log original file path, backup location, and hash
                            "$($File.FullName) | $ZipFile | $Hash" | Add-Content -Path $defaultBackupLogFilePath
                        }
                    
                        Write-Host "`n Backup completed successfully. Log file saved at: " -ForegroundColor Green -NoNewline
                        Write-Host "$defaultBackupLogFilePath`n" -ForegroundColor Yellow

                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null

                        
                    
                    }
                    #---------------------------------------------backup and zip------------------------------------------/   
                    #-------------------------------------------restore files-----------------------------------/
                    function Restore-Files {
                        # Check if the backup log file exists
                        if (!(Test-Path $Global:defaultBackupLogFilePath)) {
                            Write-Host "Error: Backup log file not found. No records to restore."
                            return
                        }
                    
                        # Ensure the restore directory exists
                        if (!(Test-Path $Global:defaultRestoreDir)) {
                            New-Item -ItemType Directory -Path $Global:defaultRestoreDir -Force | Out-Null
                        }
                    
                        # Ensure the restore log file directory exists
                        $RestoreLogDir = Split-Path -Path $Global:defaultRestoreLogFilePath -Parent
                        if (!(Test-Path $RestoreLogDir)) {
                            New-Item -ItemType Directory -Path $RestoreLogDir -Force | Out-Null
                        }
                    
                        # Ensure the restore log file exists or create it
                        if (!(Test-Path $Global:defaultRestoreLogFilePath)) {
                            New-Item -ItemType File -Path $Global:defaultRestoreLogFilePath -Force | Out-Null
                        }
                    
                        # Clear previous restore log
                        "" | Set-Content $Global:defaultRestoreLogFilePath -Force
                    
                        # Read backup log file line by line
                        $LogEntries = Get-Content $Global:defaultBackupLogFilePath
                    
                        foreach ($Entry in $LogEntries) {
                            $Parts = $Entry -split "\|"
                            if ($Parts.Count -ne 3) { continue }  # Skip malformed entries
                    
                            $OriginalPath = $Parts[0].Trim()
                            $ZipFile = $Parts[1].Trim()
                            $ExpectedHash = $Parts[2].Trim()
                    
                            # Ensure the backup file exists
                            if (!(Test-Path $ZipFile)) {
                                $Message = "Warning: Backup file missing - $ZipFile"
                                Write-Host $Message
                                $Message | Add-Content -Path $Global:defaultRestoreLogFilePath -Force
                                continue
                            }
                    
                            # Define restore path in the restore directory
                            $RelativePath = $OriginalPath -replace [regex]::Escape($Global:defaultSourceDir), ""
                            $RestorePath = Join-Path -Path $Global:defaultRestoreDir -ChildPath $RelativePath
                    
                            # Ensure the restore subdirectory exists
                            $RestoreDir = Split-Path -Path $RestorePath
                            if (!(Test-Path $RestoreDir)) {
                                New-Item -ItemType Directory -Path $RestoreDir -Force | Out-Null
                            }
                    
                            # Extract the file using 7-Zip
                            & "$Global:defaultSevenZipPath" x -p"$Global:defaultPassword" -y -o"$RestoreDir" "$ZipFile"
                    
                            # Verify file integrity after restoration
                            if (Test-Path $RestorePath) {
                                $RestoredHash = (Get-FileHash -Algorithm SHA256 -Path $RestorePath).Hash
                                if ($RestoredHash -eq $ExpectedHash) {
                                    $Message = "Restored and verified: $RestorePath"
                                } else {
                                    $Message = "Warning: File integrity check failed for $RestorePath"
                                }
                            } else {
                                $Message = "Error: File not found after extraction - $RestorePath"
                            }
                    
                            Write-Host $Message
                            $Message | Add-Content -Path $Global:defaultRestoreLogFilePath -Force
                        }
                    
                        Write-Host "`n File restoration completed. Log file saved at:" -ForegroundColor Green -NoNewline
                        Write-Host "$Global:defaultRestoreLogFilePath`n" -ForegroundColor Yellow
                    
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    
                    #-------------------------------------------restore files-----------------------------------/
                    #-----------------------------------------------------view log files------------------------------------------------
                    function View-LogFile {
                        # Define log file paths
                        $backupLog = "$Global:defaultBackupLogFilePath"
                        $restoreLog = "$Global:defaultRestoreLogFilePath"
                    
                        # Display menu for user selection
                        Write-Host "`n Select a log file to view:`n" -ForegroundColor Cyan
                        Write-Host " 1. Backup Log" -ForegroundColor Yellow
                        Write-Host " 2. Restore Log" -ForegroundColor Yellow
                        Write-Host " 3. Back to the menu`n" -ForegroundColor Yellow
                    
                        # Get user input
                        $choice = Read-Host "`n Enter the number of your choice"
                    
                        switch ($choice) {
                            "1" {
                                if (Test-Path $backupLog) {
                                    Write-Host "`n --- Backup Log ---`n" -ForegroundColor Green
                                    Get-Content $backupLog
                                } else {
                                    Write-Host " Backup log file not found!" -ForegroundColor Red
                                }
                            }
                            "2" {
                                if (Test-Path $restoreLog) {
                                    Write-Host "`n --- Restore Log ---`n" -ForegroundColor Green
                                    Get-Content $restoreLog
                                } else {
                                    Write-Host " Restore log file not found!" -ForegroundColor Red
                                }
                            }
                            "3" {
                                Write-Host " Exiting log viewer..." -ForegroundColor Yellow
                                return
                            }
                            default {
                                Write-Host " Invalid choice! Please enter 1, 2, or 3." -ForegroundColor Red
                            }
                        }
                    
                        # Pause before exiting
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    #-----------------------------------------------------view log files------------------------------------------------/

                    #-------------------------------------------------schedule a test task--------------------------------------------
                    function Schedule-TestTask {
                        param (
                            [string]$ScriptPath
                        )
                    
                        # Define Task Name
                        $taskName = "TestBackupTask"
                    
                        # Get Current Time and Add 1 Minute
                        $runTime = (Get-Date).AddMinutes(1).ToString("HH:mm")
                    
                        # Define the Trigger to Run Once at the Specified Time
                        $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1)
                    
                        # Define the Action
                        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
                            -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command `"& '$ScriptPath' -Mode testschedule`""
                    
                        # Register the Task
                        try {
                            Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Test backup task scheduled at $runTime"
                            Write-Host " Test Task '$taskName' has been scheduled to run at $runTime."
                            Write-Host "`n If the task scheduled correctly you will see something hilarious" -ForegroundColor Green
                        } catch {
                            Write-Error " Failed to schedule the test task: $_" -ForegroundColor Red
                        }
                        Write-Host "`n Press Enter to return to the menu..." -ForegroundColor Cyan
                        Read-Host | Out-Null
                    }
                    #-------------------------------------------------schedule a test task--------------------------------------------/









                    #-------------------------------------------------select Schedule tasks--------------------------------
                    function SelectScheduleTask {
                       
                    
                    Write-Host "`n Select a Schedule task:`n" -ForegroundColor Cyan
                    Write-Host " 1. Schedule Backup" -ForegroundColor Yellow
                    Write-Host " 2. Schedule a Test Task" -ForegroundColor Yellow
                    Write-Host " 3. Back to the menu`n" -ForegroundColor Yellow
                    $choice = Read-Host " Enter the number of your choice" 
                    # Define Task Name
                    switch ($choice) {
                        "1" {
                            Schedule-BackupTask -ScriptPath $Global:CurrentScriptFile -BackupPath $Global:defaultBackupDir -Frequency $Global:defaultFrequency -Time $Global:defaultTime
                            
                        }
                        "2" {
                            Schedule-TestTask -ScriptPath $Global:CurrentScriptFile
                            
                        }
                        "3" {
                            Write-Host "Exiting Task Scheduler..." -ForegroundColor Yellow
                            return
                        }
                        default {
                            Write-Host "Invalid choice! Please enter 1, 2, or 3." -ForegroundColor Red
                        }
                    }

                    

                }




                    #-------------------------------------------------select Schedule tasks--------------------------------/





                    Clear-Host


                    Write-Host $banner -ForegroundColor Cyan
                    Write-Host "                                   "
                    Write-Host "                                   "
                
                    Write-Host " 1. Check Configurations" -ForegroundColor yellow
                    Write-Host " 2. Change Configurations" -ForegroundColor yellow
                    Write-Host " 3. Schedule Backup" -ForegroundColor yellow
                    Write-Host " 4. View Schdeuled tasks" -ForegroundColor yellow
                    Write-Host " 5. Clear Schdeuled tasks" -ForegroundColor yellow
                    Write-Host " 6. Backup Files Now" -ForegroundColor yellow
                    Write-Host " 7. Restore Files Now" -ForegroundColor yellow
                    Write-Host " 8. View Logs" -ForegroundColor yellow
                    Write-Host " 9. Exit`n" -ForegroundColor yellow
                    
                    $choice = Read-Host " Enter your choice (1-9)" 

                    switch ($choice) {
                        "1" { check-Config }
                        "2" { change-config }
                        "3" { SelectScheduleTask}
                        "4" { View-ScheduledBackups }
                        "5" { Clear-ScheduledBackups}
                        "6" { Backup-Files}
                        "7" { Restore-Files}
                        "8" { View-LogFile}
                        "9" { Write-Host " `n Exiting...`n" -ForegroundColor Red
                        
                        exit    }
                        default { Write-Host " Invalid choice. Please enter a number between 1-9." }
                    }

   
    }

            #menu-----------------------------------------------/

}







