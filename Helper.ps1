Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors
$darkBackground = [System.Drawing.Color]::FromArgb(32, 32, 32)
$darkSecondary = [System.Drawing.Color]::FromArgb(45, 45, 48)
$accentColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$textColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$buttonTextColor = [System.Drawing.Color]::White

# Define log file path
$logFilePath = Join-Path $env:TEMP "ARK4_Assistant_Debug.log"

# Create the main form with modern styling
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ark4 Assistant"
$form.Size = New-Object System.Drawing.Size(550, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = $darkBackground
$form.ForeColor = $textColor
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# Create a header panel
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Dock = "Top"
$headerPanel.Height = 60
$headerPanel.BackColor = $accentColor
$form.Controls.Add($headerPanel)

# Create header title
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "ARK-4 Assistant"
$headerLabel.AutoSize = $true
$headerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = [System.Drawing.Color]::White
$headerLabel.Location = New-Object System.Drawing.Point(20, [Math]::Floor(($headerPanel.Height - 30) / 2))
$headerLabel.TextAlign = "MiddleLeft"
$headerPanel.Controls.Add($headerLabel)

# Create main container panel
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Dock = "Fill"
$mainPanel.Padding = New-Object System.Windows.Forms.Padding(10)
$form.Controls.Add($mainPanel)

# Adjust spacing constants
$topMargin = 10
$elementSpacing = 20

# Create instructions label with modern styling
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, $topMargin)
$label.Size = New-Object System.Drawing.Size(460, 40)
$label.Text = "Please ensure your PSP is on firmware 6.60 or 6.61 before proceeding with the installation."
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$label.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($label)

# Update version info label position and styling
$versionInfoLabel = New-Object System.Windows.Forms.Label
$versionInfoLabel.Location = New-Object System.Drawing.Point(10, 140)
$versionInfoLabel.Size = New-Object System.Drawing.Size(460, 50)
$versionInfoLabel.Text = "Latest version: Checking..."
$versionInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)
$versionInfoLabel.ForeColor = $accentColor
$versionInfoLabel.BackColor = [System.Drawing.Color]::FromArgb(38, 38, 38)
$versionInfoLabel.TextAlign = "MiddleLeft"
$versionInfoLabel.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)
$mainPanel.Controls.Add($versionInfoLabel)

# Create PSP Drive selection with modern styling
$driveLabel = New-Object System.Windows.Forms.Label
$driveLabel.Location = New-Object System.Drawing.Point(10, 60)
$driveLabel.TextAlign = "MiddleLeft"
$driveLabel.Size = New-Object System.Drawing.Size(150, 25)
$driveLabel.Text = "Select PSP Drive Letter:"
$driveLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$mainPanel.Controls.Add($driveLabel)

$driveComboBox = New-Object System.Windows.Forms.ComboBox
$driveComboBox.Location = New-Object System.Drawing.Point(220, 60)
$driveComboBox.Size = New-Object System.Drawing.Size(100, 25)
$driveComboBox.BackColor = $darkSecondary
$driveComboBox.ForeColor = $textColor
$driveComboBox.FlatStyle = "Flat"
$driveComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
Get-PSDrive -PSProvider FileSystem | ForEach-Object { $driveComboBox.Items.Add($_.Root) }
$mainPanel.Controls.Add($driveComboBox)

# Create refresh button before detect button
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Location = New-Object System.Drawing.Point(330, 60)
$refreshButton.Size = New-Object System.Drawing.Size(80, 25)
$refreshButton.Text = "Refresh"
$refreshButton.FlatStyle = "Flat"
$refreshButton.BackColor = $darkSecondary
$refreshButton.ForeColor = $buttonTextColor
$refreshButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$refreshButton.FlatAppearance.BorderSize = 0
$refreshButton.Cursor = "Hand"
$refreshButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 58)
})
$refreshButton.Add_MouseLeave({
    $this.BackColor = $darkSecondary
})
$mainPanel.Controls.Add($refreshButton)

# Move detect button after refresh
$detectButton = New-Object System.Windows.Forms.Button
$detectButton.Location = New-Object System.Drawing.Point(420, 60)
$detectButton.Size = New-Object System.Drawing.Size(100, 25)
$detectButton.Text = "Detect PSP"
$detectButton.FlatStyle = "Flat"
$detectButton.BackColor = $darkSecondary
$detectButton.ForeColor = $buttonTextColor
$detectButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$detectButton.FlatAppearance.BorderSize = 0
$detectButton.Cursor = "Hand"
$detectButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 58)
})
$detectButton.Add_MouseLeave({
    $this.BackColor = $darkSecondary
})

# Function to refresh drive list
function Update-DriveList {
    $driveComboBox.Items.Clear()
    Get-PSDrive -PSProvider FileSystem | ForEach-Object { $driveComboBox.Items.Add($_.Root) }
    Add-LogEntry "Drive list refreshed"
}

# Add refresh button click handler
$refreshButton.Add_Click({
    Update-DriveList
    $progressLabel.Text = "Drive list refreshed"
})

# Add detect PSP function
$detectButton.Add_Click({
    $progressLabel.Text = "Scanning for PSP..."
    Add-LogEntry "Scanning drives for PSP..."
    
    # First refresh the drive list
    Update-DriveList
    
    $pspDrive = $null
    $drives = Get-PSDrive -PSProvider FileSystem
    
    foreach ($drive in $drives) {
        $root = $drive.Root
        # Check for PSP folder structure
        if (Test-Path "$root\PSP" -PathType Container) {
            # Verify it's likely a PSP by checking for standard folders
            $requiredFolders = @(
                "$root\PSP",
                "$root\PICTURE",
                "$root\MUSIC",
                "$root\VIDEO"
            )
            
            $isPSP = $true
            foreach ($folder in $requiredFolders) {
                if (!(Test-Path $folder -PathType Container)) {
                    $isPSP = $false
                    break
                }
            }
            
            if ($isPSP) {
                $pspDrive = $root
                break
            }
        }
    }
    
    if ($pspDrive) {
        # Select the PSP drive in the combo box
        $driveComboBox.SelectedItem = $pspDrive
        $progressLabel.Text = "PSP detected at drive $pspDrive"
        Add-LogEntry "PSP detected at drive $pspDrive"
        [System.Windows.Forms.MessageBox]::Show(
            "PSP detected at drive $pspDrive`n`nReady to install ARK-4!",
            "PSP Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    } else {
        $progressLabel.Text = "No PSP detected"
        Add-LogEntry "No PSP detected in available drives"
        [System.Windows.Forms.MessageBox]::Show(
            "Could not detect PSP drive.`n`nPlease check:`n- PSP is connected via USB`n- USB mode is enabled on PSP`n- USB cable is working",
            "PSP Not Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
})

$mainPanel.Controls.Add($detectButton)

# Create progress label first
$progressLabel = New-Object System.Windows.Forms.Label
$progressLabel.Location = New-Object System.Drawing.Point(10, 200)
$progressLabel.Size = New-Object System.Drawing.Size(460, 40)
$progressLabel.Text = "Ready to install..."
$progressLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$progressLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($progressLabel)

# Create checklist
$checklist = New-Object System.Windows.Forms.CheckedListBox
$checklist.Location = New-Object System.Drawing.Point(10, 250)
$checklist.Size = New-Object System.Drawing.Size(460, 200)
$checklist.BackColor = $darkSecondary
$checklist.ForeColor = $textColor
$checklist.BorderStyle = "None"
$checklist.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$checklist.Items.AddRange(@(
    "Download ARK-4",
    "Copy ARK_01234 folder to /PSP/SAVEDATA/",
    "Copy ARK_Loader folder to /PSP/GAME/",
    "Install temporary CFW",
    "Copy Ark_cIPL folder to /PSP/GAME/ (for permanent installation)",
    "Install permanent CFW using Ark cIPL Flasher"
))
$mainPanel.Controls.Add($checklist)

# Create button panel
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(10, 470)
$buttonPanel.Size = New-Object System.Drawing.Size(460, 40)
$buttonPanel.BackColor = $darkBackground
$mainPanel.Controls.Add($buttonPanel)

# Create start button with modern styling
$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(0, 0)
$startButton.Size = New-Object System.Drawing.Size(100, 30)
$startButton.Text = "Start"
$startButton.FlatStyle = "Flat"
$startButton.BackColor = $accentColor
$startButton.ForeColor = $buttonTextColor
$startButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$startButton.FlatAppearance.BorderSize = 0
$startButton.Cursor = "Hand"
$startButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(0, 102, 184)
})
$startButton.Add_MouseLeave({
    $this.BackColor = $accentColor
})
$buttonPanel.Controls.Add($startButton)

# Create help button with modern styling
$helpButton = New-Object System.Windows.Forms.Button
$helpButton.Location = New-Object System.Drawing.Point(110, 0)
$helpButton.Size = New-Object System.Drawing.Size(100, 30)
$helpButton.Text = "Help"
$helpButton.FlatStyle = "Flat"
$helpButton.BackColor = $darkSecondary
$helpButton.ForeColor = $buttonTextColor
$helpButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$helpButton.FlatAppearance.BorderSize = 0
$helpButton.Cursor = "Hand"
$helpButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 58)
})
$helpButton.Add_MouseLeave({
    $this.BackColor = $darkSecondary
})
$buttonPanel.Controls.Add($helpButton)

# Create cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(220, 0)
$cancelButton.Size = New-Object System.Drawing.Size(100, 30)
$cancelButton.Text = "Cancel"
$cancelButton.FlatStyle = "Flat"
$cancelButton.BackColor = $darkSecondary
$cancelButton.ForeColor = $buttonTextColor
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$cancelButton.FlatAppearance.BorderSize = 0
$cancelButton.Cursor = "Hand"
$cancelButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 58)
})
$cancelButton.Add_MouseLeave({
    $this.BackColor = $darkSecondary
})
$buttonPanel.Controls.Add($cancelButton)

# Create progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 520)
$progressBar.Size = New-Object System.Drawing.Size(460, 20)
$progressBar.Style = "Continuous"
$progressBar.BackColor = $darkSecondary
$progressBar.ForeColor = $accentColor
$mainPanel.Controls.Add($progressBar)

# Create status panel
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(10, 550)
$statusPanel.Size = New-Object System.Drawing.Size(460, 20)
$statusPanel.BackColor = $darkSecondary
$mainPanel.Controls.Add($statusPanel)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Log Output:"
$statusLabel.Location = New-Object System.Drawing.Point(0, 0)
$statusLabel.Size = New-Object System.Drawing.Size(460, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = $textColor
$statusLabel.TextAlign = "MiddleLeft"
$statusPanel.Controls.Add($statusLabel)

# Create log box
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(10, 570)
$logBox.Size = New-Object System.Drawing.Size(460, 60)
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.BackColor = $darkSecondary
$logBox.ForeColor = $textColor
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$mainPanel.Controls.Add($logBox)

# After creating the log box, add copyright label
$copyrightLabel = New-Object System.Windows.Forms.Label
$copyrightLabel.Location = New-Object System.Drawing.Point(10, 640)
$copyrightLabel.Size = New-Object System.Drawing.Size(460, 20)
$copyrightLabel.Text = "© 2024 Nigel1992 - ARK-4 Assistant"
$copyrightLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$copyrightLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)  # Subtle gray color
$copyrightLabel.TextAlign = "MiddleCenter"
$mainPanel.Controls.Add($copyrightLabel)

# Function to add log entry
function Add-LogEntry {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $message"
    
    # Append to UI log box
    $logBox.AppendText("$logEntry`r`n")
    $logBox.ScrollToCaret()
    
    # Append to log file with more details
    $detailedEntry = "[$timestamp] [${PID}] $message"
    try {
        Add-Content -Path $logFilePath -Value $detailedEntry
    } catch {
        $logBox.AppendText("[ERROR] Failed to write to log file: $_`r`n")
    }
}

# Function to get latest ARK-4 release
function Get-LatestARKRelease {
    Add-LogEntry "Starting ARK-4 version check..."
    $progressLabel.Text = "Fetching latest ARK-4 release..."
    $apiUrl = "https://api.github.com/repos/PSP-Archive/ARK-4/releases"
    
    try {
        Add-LogEntry "Requesting data from GitHub API: $apiUrl"
        $releases = Invoke-RestMethod -Uri $apiUrl -Method Get
        Add-LogEntry "Received $(($releases | Measure-Object).Count) releases from API"
        
        # Sort releases by version number from release title
        $latestRelease = $releases | 
            Where-Object { -not $_.prerelease } |
            ForEach-Object {
                # Extract version number from release title (e.g., "ARK-4 rev163")
                $versionMatch = $_.name -match "rev(\d+)"
                $versionNum = if ($versionMatch) { [int]$matches[1] } else { 0 }
                $_ | Add-Member -NotePropertyName VersionNumber -NotePropertyValue $versionNum -PassThru
            } |
            Sort-Object -Property VersionNumber -Descending |
            Select-Object -First 1
        
        if ($latestRelease) {
            # Format the date
            $publishDate = [DateTime]::Parse($latestRelease.published_at).ToString("yyyy-MM-dd")
            
            # Update version info label using release name instead of tag
            $versionInfoLabel.Text = "Latest version: $($latestRelease.name)`nReleased: $publishDate`nSize: $([math]::Round(($latestRelease.assets[0].size / 1MB), 2)) MB"
            
            return @{
                Version = $latestRelease.name
                Assets = $latestRelease.assets
                PublishDate = $publishDate
            }
        }
    } catch {
        $errorDetails = @"
Failed to fetch releases:
Error: $($_.Exception.Message)
Type: $($_.Exception.GetType().FullName)
Stack Trace:
$($_.ScriptStackTrace)
"@
        Add-LogEntry $errorDetails
        $versionInfoLabel.Text = "Failed to fetch version info"
        [System.Windows.Forms.MessageBox]::Show("Failed to fetch latest release: $_", "Error")
        return $null
    }
}

# Function to download and extract ARK-4
function Install-ARK4 {
    param (
        [string]$pspDrive,
        [object]$releaseInfo
    )
    
    $tempPath = [System.IO.Path]::GetTempPath()
    $downloadPath = Join-Path $tempPath "ARK-4.zip"
    $extractPath = Join-Path $tempPath "ARK-4"
    
    # Download the release
    try {
        $progressLabel.Text = "Downloading ARK-4..."
        Add-LogEntry "Starting download of ARK-4..."
        
        $downloadUrl = $releaseInfo.Assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1 -ExpandProperty browser_download_url
        
        # Download with progress
        $webClient = New-Object System.Net.WebClient
        
        # Create script block for progress updates
        $progressHandler = {
            param($sender, $e)
            $form.Invoke([Action]{
                $progressBar.Value = $e.ProgressPercentage
                $progressLabel.Text = "Downloading: $($e.ProgressPercentage)%"
            })
        }
        
        # Create script block for completion
        $completedHandler = {
            param($sender, $e)
            $form.Invoke([Action]{
                Add-LogEntry "Download completed"
                $progressBar.Value = 100
            })
        }
        
        # Register event handlers
        Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action $progressHandler | Out-Null
        Register-ObjectEvent -InputObject $webClient -EventName DownloadFileCompleted -Action $completedHandler | Out-Null
        
        # Start download
        $webClient.DownloadFileAsync((New-Object Uri($downloadUrl)), $downloadPath)
        
        # Wait for download to complete
        while ($webClient.IsBusy) {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 100
        }
        
        # Cleanup event handlers
        Get-EventSubscriber | Where-Object { $_.SourceObject -eq $webClient } | Unregister-Event
        
        $checklist.SetItemChecked(0, $true)
        
        # Extract the archive
        $progressLabel.Text = "Extracting ARK-4..."
        Add-LogEntry "Extracting files..."
        $progressBar.Value = 0

        try {
            # First verify the download completed successfully
            if (!(Test-Path $downloadPath)) {
                throw "Download file not found"
            }
            Add-LogEntry "Verifying downloaded archive..."

            # Create extraction directory if it doesn't exist
            if (Test-Path $extractPath) {
                Remove-Item $extractPath -Recurse -Force
            }
            New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
            Add-LogEntry "Created extraction directory"
            
            # Extract with progress updates
            $shell = New-Object -ComObject Shell.Application
            $zip = $shell.NameSpace($downloadPath)
            $destination = $shell.NameSpace($extractPath)
            
            $totalItems = $zip.Items().Count
            $progressBar.Value = 20
            Add-LogEntry "Extracting $totalItems items..."
            
            # Extract all items
            $destination.CopyHere($zip.Items(), 0x14)
            
            # Wait for extraction to complete by monitoring folder contents
            $extracted = 0
            while ($extracted -lt $totalItems) {
                $extracted = (Get-ChildItem $extractPath -Recurse -File).Count
                $progress = [math]::Min(80, [math]::Round(($extracted / $totalItems) * 60) + 20)
                $progressBar.Value = $progress
                $progressLabel.Text = "Extracting: $extracted of $totalItems files..."
                Start-Sleep -Milliseconds 100
            }
            
            Add-LogEntry "Extraction completed"
            $progressBar.Value = 80
            
            # Verify extraction
            if (!(Test-Path "$extractPath\ARK_01234") -and 
                !(Test-Path "$extractPath\ARK_Loader") -and 
                !(Test-Path "$extractPath\Ark_cIPL")) {
                throw "Required folders not found in extracted content"
            }
            
            Add-LogEntry "Extraction verified successfully"
            $progressBar.Value = 90
            
            # Continue with copying files...
            
            # Copy files to PSP
            $progressLabel.Text = "Copying files to PSP..."
            Add-LogEntry "Copying files to PSP..."
            
            # Copy SAVEDATA
            if (Test-Path "$extractPath\ARK_01234") {
                Add-LogEntry "Copying ARK_01234 to SAVEDATA..."
                Copy-Item "$extractPath\ARK_01234" -Destination "$pspDrive\PSP\SAVEDATA\" -Recurse -Force
                $checklist.SetItemChecked(1, $true)
                Add-LogEntry "SAVEDATA copy complete"
            }
            
            # Copy GAME folders
            if (Test-Path "$extractPath\ARK_Loader") {
                Add-LogEntry "Copying ARK_Loader to GAME..."
                Copy-Item "$extractPath\ARK_Loader" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
                $checklist.SetItemChecked(2, $true)
                Add-LogEntry "ARK_Loader copy complete"
            }
            
            if (Test-Path "$extractPath\Ark_cIPL") {
                Add-LogEntry "Copying Ark_cIPL to GAME..."
                Copy-Item "$extractPath\Ark_cIPL" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
                $checklist.SetItemChecked(4, $true)
                Add-LogEntry "Ark_cIPL copy complete"
            }
            
            $progressBar.Value = 100
            
            # Cleanup
            Add-LogEntry "Cleaning up temporary files..."
            Remove-Item $downloadPath -Force
            Remove-Item $extractPath -Recurse -Force
            
            $progressLabel.Text = "Installation completed successfully!"
            Add-LogEntry "Installation completed successfully!"
            [System.Windows.Forms.MessageBox]::Show(
                "ARK-4 files have been copied to your PSP.

Next steps:
1. On your PSP, go to Game > Memory Stick
2. Run the ARK Loader to install temporary CFW
3. For permanent installation, run the Ark cIPL Flasher

Version installed: $($releaseInfo.Version)",
                "Installation Complete"
            )
            
        } catch {
            $progressLabel.Text = "Extraction failed!"
            Add-LogEntry "ERROR: Extraction failed - $_"
            [System.Windows.Forms.MessageBox]::Show("Failed to extract ARK-4: $_", "Error")
        }
        
    } catch {
        $progressLabel.Text = "Download failed!"
        Add-LogEntry "ERROR: Download failed - $_"
        [System.Windows.Forms.MessageBox]::Show("Failed to download ARK-4: $_", "Error")
    }
}

# Modify the start button click handler to check for existing installation
$startButton.Add_Click({
    if ($driveComboBox.SelectedItem -eq $null) {
        [System.Windows.Forms.MessageBox]::Show("Please select a PSP drive first!", "Error")
        return
    }

    $pspDrive = $driveComboBox.SelectedItem
    Add-LogEntry "Starting installation to drive: $pspDrive"
    
    # Check for existing ARK-4 installation folders that we will copy to
    $existingInstallation = @(
        "$pspDrive\PSP\SAVEDATA\ARK_01234",
        "$pspDrive\PSP\GAME\ARK_Loader",
        "$pspDrive\PSP\GAME\Ark_cIPL"
    )
    
    # Only check folders that we're going to copy to
    $existingFiles = $existingInstallation | Where-Object { 
        Test-Path $_ -PathType Container  # Only check if folder exists
    }
    
    if ($existingFiles.Count -gt 0) {
        Add-LogEntry "Detected existing ARK-4 installation"
        $result = [System.Windows.Forms.MessageBox]::Show(
            "ARK-4 appears to be already installed on this PSP.`n`n" + 
            "The following components were found:`n" + 
            ($existingFiles | ForEach-Object { "- $_" } | Out-String) + 
            "`nWould you like to reinstall/update ARK-4?`n" +
            "(This will overwrite the existing installation)",
            "ARK-4 Already Installed",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        
        if ($result -eq [System.Windows.Forms.DialogResult]::No) {
            Add-LogEntry "Installation cancelled - ARK-4 already installed"
            return
        }
        Add-LogEntry "User chose to reinstall/update ARK-4"
    }
    
    $progressBar.Value = 0
    
    # Create required directories
    $directories = @(
        "$pspDrive\PSP\SAVEDATA",
        "$pspDrive\PSP\GAME"
    )

    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force
            Add-LogEntry "Created directory: $dir"
        }
    }

    # Get and install latest release
    $releaseInfo = Get-LatestARKRelease
    if ($releaseInfo) {
        Add-LogEntry "Found latest release: $($releaseInfo.Version)"
        Install-ARK4 -pspDrive $pspDrive -releaseInfo $releaseInfo
    }
})

# Create help button
$helpButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "This tool helps you install ARK-4 Custom Firmware on your PSP.

Requirements:
- PSP on firmware 6.60 or 6.61
- USB cable
- Memory Stick (unless using PSP Go)
- Internet connection to download ARK-4

For more help, visit the ARK-4 wiki.",
        "Help"
    )
})

# Add cancel button click handler
$cancelButton.Add_Click({
    $form.Close()
})

# Add version check on form load
$form.Add_Shown({
    $releaseInfo = Get-LatestARKRelease
    if ($releaseInfo) {
        Add-LogEntry "Latest ARK-4 version available: $($releaseInfo.Version) (Released: $($releaseInfo.PublishDate))"
    }
})

# Add debug log button next to other buttons
$debugButton = New-Object System.Windows.Forms.Button
$debugButton.Location = New-Object System.Drawing.Point(330, 0)
$debugButton.Size = New-Object System.Drawing.Size(100, 30)
$debugButton.Text = "Debug Log"
$debugButton.FlatStyle = "Flat"
$debugButton.BackColor = $darkSecondary
$debugButton.ForeColor = $buttonTextColor
$debugButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$debugButton.FlatAppearance.BorderSize = 0
$debugButton.Cursor = "Hand"
$debugButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 58)
})
$debugButton.Add_MouseLeave({
    $this.BackColor = $darkSecondary
})
$debugButton.Add_Click({
    if (Test-Path $logFilePath) {
        Start-Process notepad.exe $logFilePath
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "No debug log file found at:`n$logFilePath",
            "Debug Log Not Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
})
$buttonPanel.Controls.Add($debugButton)

# Add at the start of the script, after Add-Type declarations
# Initialize log file with system info
$systemInfo = @"
=== ARK-4 Assistant Debug Log ===
Started: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Process ID: $PID
PowerShell Version: $($PSVersionTable.PSVersion)
OS: $([System.Environment]::OSVersion.VersionString)
Machine Name: $env:COMPUTERNAME
User: $env:USERNAME
Working Directory: $PWD
Temp Path: $env:TEMP
=================================

"@
Set-Content -Path $logFilePath -Value $systemInfo

# Add form closing event to log application exit
$form.Add_FormClosing({
    Add-LogEntry "Application closing..."
    Add-LogEntry "=== Session End ===`n"
})

# Show the form
$form.ShowDialog()