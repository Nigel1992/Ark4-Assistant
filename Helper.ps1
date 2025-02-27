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
$form.Size = New-Object System.Drawing.Size(800, 680)
$form.StartPosition = "CenterScreen"
$form.WindowState = "Normal"
$form.TopMost = $true
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
$mainPanel.Padding = New-Object System.Windows.Forms.Padding(20)
$form.Controls.Add($mainPanel)

# Adjust spacing constants
$topMargin = 10
$elementSpacing = 20

# Create instructions label with modern styling
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20, $topMargin)
$label.Size = New-Object System.Drawing.Size(740, 40)
$label.Text = "Please ensure your PSP is on firmware 6.60 or 6.61 before proceeding with the installation."
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$label.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($label)

# Update version info label position and styling
$versionInfoLabel = New-Object System.Windows.Forms.Label
$versionInfoLabel.Location = New-Object System.Drawing.Point(20, 140)
$versionInfoLabel.Size = New-Object System.Drawing.Size(740, 40)
$versionInfoLabel.Text = "Latest version: Checking..."
$versionInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)
$versionInfoLabel.ForeColor = $accentColor
$versionInfoLabel.BackColor = [System.Drawing.Color]::FromArgb(38, 38, 38)
$versionInfoLabel.TextAlign = "MiddleLeft"
$versionInfoLabel.Padding = New-Object System.Windows.Forms.Padding(15, 5, 15, 5)
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
$driveComboBox.Location = New-Object System.Drawing.Point(170, 60)
$driveComboBox.Size = New-Object System.Drawing.Size(120, 25)
$driveComboBox.BackColor = $darkSecondary
$driveComboBox.ForeColor = $textColor
$driveComboBox.FlatStyle = "Flat"
$driveComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
Get-PSDrive -PSProvider FileSystem | ForEach-Object { $driveComboBox.Items.Add($_.Root) }
$mainPanel.Controls.Add($driveComboBox)

# Create refresh button before detect button
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Location = New-Object System.Drawing.Point(300, 60)
$refreshButton.Size = New-Object System.Drawing.Size(100, 25)
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
$detectButton.Location = New-Object System.Drawing.Point(410, 60)
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

# Create function to detect CFW
function Get-PSPCFWInfo {
    param (
        [string]$pspDrive
    )
    
    # If in debug mode and debug panel is visible, return debug values
    if ($debugCheckbox.Checked -and $debugPanel.Visible) {
        Add-LogEntry "[DEBUG] Using simulated CFW values"
        return @{
            CFW = $debugCFWCombo.SelectedItem
            IsPermanent = $false
        }
    }
    
    Add-LogEntry "Checking for CFW on drive: $pspDrive"
    $cfw = "Unknown"
    
    try {
        # Check for common CFW indicators
        $indicators = @{
            # ARK-4 indicators
            "ARK-4" = @(
                "\PSP\GAME\ARK_Loader",
                "\PSP\SAVEDATA\ARK_01234",
                "\PSP\GAME\Ark_cIPL"
            )
            # PRO CFW indicators
            "PRO" = @(
                "\PSP\GAME\PRO_Update",
                "\PSP\GAME\PROUPDATE",
                "\seplugins\PRO.prx"
            )
            # LME indicators
            "LME" = @(
                "\PSP\GAME\LMEBOOT",
                "\PSP\GAME\LMEUpdater"
            )
            # ME indicators
            "ME" = @(
                "\PSP\GAME\M33_UPDATE",
                "\PSP\GAME\MEUPDATE"
            )
        }
        
        # Check each CFW type
        foreach ($cfwType in $indicators.Keys) {
            foreach ($path in $indicators[$cfwType]) {
                if (Test-Path "$pspDrive$path") {
                    $cfw = $cfwType
                    Add-LogEntry "Found $cfwType CFW indicator: $path"
                    break
                }
            }
            if ($cfw -ne "Unknown") { break }
        }
        
        # Additional checks for permanent vs temporary CFW
        $isPermanent = $false
        if ($cfw -eq "ARK-4") {
            if (Test-Path "$pspDrive\PSP\GAME\Ark_cIPL\INSTALLED.TXT") {
                $isPermanent = $true
                Add-LogEntry "Detected permanent ARK-4 installation"
            }
        }
        
        return @{
            CFW = $cfw
            IsPermanent = $isPermanent
        }
        
    } catch {
        Add-LogEntry "Error detecting CFW: $_"
        return @{
            CFW = "Error"
            IsPermanent = $false
        }
    }
}

# Function to get uninstall instructions based on CFW type
function Get-CFWUninstallSteps {
    param (
        [string]$cfwType
    )
    
    $steps = "To prepare for ARK-4 installation:`n`n"
    
    # Common initial steps
    $commonSteps = @(
        "1. Back up all your important saves and data",
        "2. Remove your memory stick and back it up on your computer"
    )
    
    $steps += $commonSteps -join "`n"
    
    # ChronoSwitch method (primary method)
    $steps += "`n`nRecommended Method:`n"
    $steps += "1. Download ChronoSwitch: https://github.com/PSP-Archive/Chronoswitch/releases/latest/download/Chronoswitch.zip`n"
    $steps += "2. Extract the zip file`n"
    $steps += "3. Copy the CHRONOSWITCH folder to /PSP/GAME/ on your memory stick`n"
    $steps += "4. On your PSP:`n"
    $steps += "   - Go to Game menu`n"
    $steps += "   - Run ChronoSwitch`n"
    $steps += "   - Select 'Install 6.61 OFW'`n"
    $steps += "   - Follow the on-screen instructions`n"
    $steps += "   - Wait for the process to complete`n"
    $steps += "   - Your PSP will reboot to official firmware`n"
    
    # Add troubleshooting section
    $steps += "`nIf ChronoSwitch Fails:`n"
    $steps += "1. Try these steps first:`n"
    $steps += "   - Format memory stick (after backup)`n"
    $steps += "   - Try a different memory stick`n"
    $steps += "   - Remove battery for 30 seconds, then try again`n"
    $steps += "`n2. If still not working:`n"
    $steps += "   - Visit http://wololo.net/talk/viewforum.php?f=20`n"
    $steps += "   - Look for a guide specific to removing $cfwType CFW`n"
    
    # Final verification steps
    $steps += "`nOnce Completed:`n"
    $steps += "1. Go to Settings → System Information`n"
    $steps += "2. Verify you're on Official Firmware`n"
    $steps += "3. Reconnect your PSP to USB`n"
    $steps += "4. Click 'Refresh' and 'Detect PSP' in this tool`n"
    $steps += "5. Proceed with ARK-4 installation"
    
    return $steps
}

# Modify the drive combo box selection change event
$driveComboBox.Add_SelectedIndexChanged({
    if ($driveComboBox.SelectedItem) {
        $selectedDrive = $driveComboBox.SelectedItem
        Add-LogEntry "Drive selected: $selectedDrive"
        
        if (Test-Path "$selectedDrive\PSP") {
            $cfwInfo = Get-PSPCFWInfo -pspDrive $selectedDrive
            $statusMessage = "PSP detected at $selectedDrive`nCFW: $($cfwInfo.CFW)"
            if ($cfwInfo.CFW -eq "ARK-4") {
                $statusMessage += "`nInstallation: $( if ($cfwInfo.IsPermanent) { 'Permanent' } else { 'Temporary' })"
            }
            $progressLabel.Text = $statusMessage
            Add-LogEntry $statusMessage
        } else {
            $progressLabel.Text = "Selected drive does not appear to be a PSP"
            Add-LogEntry "No PSP detected at $selectedDrive"
        }
    }
})

# Modify the detect button click handler
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
        
        # Get CFW information
        $cfwInfo = Get-PSPCFWInfo -pspDrive $pspDrive
        
        # Prepare status message
        $statusMessage = "PSP detected at $pspDrive`nCFW: $($cfwInfo.CFW)"
        if ($cfwInfo.CFW -eq "ARK-4") {
            $statusMessage += "`nInstallation: $( if ($cfwInfo.IsPermanent) { 'Permanent' } else { 'Temporary' })"
        }
        
        $progressLabel.Text = $statusMessage
        Add-LogEntry $statusMessage
        
        # Show appropriate message based on CFW status
        if ($cfwInfo.CFW -ne "Unknown" -and $cfwInfo.CFW -ne "ARK-4") {
            Show-UninstallInstructions -cfwType $cfwInfo.CFW -statusMessage $statusMessage
        } else {
            # Show normal detection message for no CFW or ARK-4
            [System.Windows.Forms.MessageBox]::Show(
                "$statusMessage`n`nReady to proceed with ARK-4 installation/update!",
                "PSP Found",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            )
        }
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
$progressLabel.Location = New-Object System.Drawing.Point(20, 190)
$progressLabel.Size = New-Object System.Drawing.Size(740, 50)
$progressLabel.Text = "Ready to install..."
$progressLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$progressLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($progressLabel)

# Create checklist
$checklist = New-Object System.Windows.Forms.CheckedListBox
$checklist.Location = New-Object System.Drawing.Point(20, 250)
$checklist.Size = New-Object System.Drawing.Size(740, 200)
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
$buttonPanel.Location = New-Object System.Drawing.Point(20, 490)
$buttonPanel.Size = New-Object System.Drawing.Size(740, 40)
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
$progressBar.Location = New-Object System.Drawing.Point(20, 520)
$progressBar.Size = New-Object System.Drawing.Size(740, 20)
$progressBar.Style = "Continuous"
$progressBar.BackColor = $darkSecondary
$progressBar.ForeColor = $accentColor
$mainPanel.Controls.Add($progressBar)

# Create status panel
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(20, 550)
$statusPanel.Size = New-Object System.Drawing.Size(740, 20)
$statusPanel.BackColor = $darkSecondary
$mainPanel.Controls.Add($statusPanel)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Log Output:"
$statusLabel.Location = New-Object System.Drawing.Point(0, 0)
$statusLabel.Size = New-Object System.Drawing.Size(740, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = $textColor
$statusLabel.TextAlign = "MiddleLeft"
$statusPanel.Controls.Add($statusLabel)

# Create log box
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(20, 570)
$logBox.Size = New-Object System.Drawing.Size(740, 60)
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.BackColor = $darkSecondary
$logBox.ForeColor = $textColor
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$mainPanel.Controls.Add($logBox)

# After creating the log box, add copyright label
$copyrightLabel = New-Object System.Windows.Forms.Label
$copyrightLabel.Location = New-Object System.Drawing.Point(20, 640)
$copyrightLabel.Size = New-Object System.Drawing.Size(200, 20)
$copyrightLabel.Text = "© 2024 Nigel1992"
$copyrightLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$copyrightLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$copyrightLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($copyrightLabel)

# Function to add log entry
function Add-LogEntry {
    param(
        [string]$message,
        [switch]$NoNewLine
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Split message into lines and format each line
    $formattedLines = @()
    $messageLines = $message -split "`n"
    foreach ($line in $messageLines) {
        if ($line -match '^\s*$') {
            $formattedLines += ""  # Keep empty lines as is
        } else {
            $formattedLines += "[$timestamp] $line"
        }
    }
    
    # Join the lines with proper line breaks
    $formattedMessage = $formattedLines -join "`r`n"
    
    # Add extra newline for certain types of messages to improve readability
    $addNewLine = -not $NoNewLine -and (
        $message -match "^(Starting|Completed|Found|Error|Debug mode:|Scanning|Requesting|Received|Latest|Drive|PSP detected|CFW:|Installation:)" -or
        $message -match "^={3,}"
    )
    
    # Append to UI log box with proper formatting
    if ($logBox.Text.Length -gt 0 -and -not $logBox.Text.EndsWith("`r`n")) {
        $logBox.AppendText("`r`n")
    }
    $logBox.AppendText($formattedMessage)
    if ($addNewLine) {
        $logBox.AppendText("`r`n")
    }
    $logBox.ScrollToCaret()
    
    # Append to log file with more details
    try {
        if ((Get-Content -Path $logFilePath -Raw).Length -gt 0) {
            Add-Content -Path $logFilePath -Value "`n$formattedMessage"
        } else {
            Add-Content -Path $logFilePath -Value $formattedMessage
        }
        if ($addNewLine) {
            Add-Content -Path $logFilePath -Value ""
        }
    } catch {
        $logBox.AppendText("`r`n[ERROR] Failed to write to log file: $_`r`n")
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
            
            # Update version info label with clearer ARK-4 reference
            $versionInfoLabel.Text = "ARK-4 Release Information`nVersion: $($latestRelease.name)`nReleased: $publishDate"
            Add-LogEntry "Latest ARK-4 version available: $($latestRelease.name) (Released: $publishDate)"
            
            # Reset progress label to ready state
            $progressLabel.Text = "Ready to install..."
            
            return @{
                Version = $latestRelease.name
                Assets = $latestRelease.assets
                PublishDate = $publishDate
            }
        } else {
            $progressLabel.Text = "No releases found"
            return $null
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
        $progressLabel.Text = "Failed to fetch latest release info"
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

# Add after the detect button but before the progress label
# Create debug mode checkbox with modern styling
$debugCheckbox = New-Object System.Windows.Forms.CheckBox
$debugCheckbox.Location = New-Object System.Drawing.Point(650, 460)
$debugCheckbox.Size = New-Object System.Drawing.Size(110, 20)
$debugCheckbox.Text = "Debug Mode"
$debugCheckbox.ForeColor = $textColor
$debugCheckbox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$debugCheckbox.BackColor = $darkBackground
$mainPanel.Controls.Add($debugCheckbox)

# Create debug controls panel that shows only when debug is enabled
$debugPanel = New-Object System.Windows.Forms.Panel
$debugPanel.Location = New-Object System.Drawing.Point(520, 455)
$debugPanel.Size = New-Object System.Drawing.Size(120, 30)
$debugPanel.BackColor = $darkBackground
$debugPanel.Visible = $false
$mainPanel.Controls.Add($debugPanel)

# Create CFW type combo box for debug
$debugCFWCombo = New-Object System.Windows.Forms.ComboBox
$debugCFWCombo.Location = New-Object System.Drawing.Point(0, 0)
$debugCFWCombo.Size = New-Object System.Drawing.Size(120, 25)
$debugCFWCombo.BackColor = $darkSecondary
$debugCFWCombo.ForeColor = $textColor
$debugCFWCombo.FlatStyle = "Flat"
$debugCFWCombo.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$debugCFWCombo.Items.AddRange(@("PRO", "LME", "ME", "ARK-4", "Unknown"))
$debugCFWCombo.SelectedIndex = 0
$debugPanel.Controls.Add($debugCFWCombo)

# Add debug checkbox change handler
$debugCheckbox.Add_CheckedChanged({
    $debugPanel.Visible = $debugCheckbox.Checked
    Add-LogEntry "Debug mode: $($debugCheckbox.Checked)"
    
    if ($debugCheckbox.Checked) {
        # Update status message only
        $selectedCFW = $debugCFWCombo.SelectedItem
        $statusMessage = "PSP detected at DEBUG`nCFW: $selectedCFW"
        if ($selectedCFW -eq "ARK-4") {
            $statusMessage += "`nInstallation: Temporary"
        }
        $progressLabel.Text = $statusMessage
        Add-LogEntry "[DEBUG] Simulating $selectedCFW CFW"
    }
})

# Function to show uninstall instructions in a custom form
function Show-UninstallInstructions {
    param (
        [string]$cfwType,
        [string]$statusMessage
    )
    
    $instructionsForm = New-Object System.Windows.Forms.Form
    $instructionsForm.Text = "Existing CFW Detected"
    $instructionsForm.Size = New-Object System.Drawing.Size(600, 500)
    $instructionsForm.StartPosition = "CenterParent"
    $instructionsForm.BackColor = $darkBackground
    $instructionsForm.ForeColor = $textColor
    $instructionsForm.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $instructionsForm.FormBorderStyle = "FixedDialog"
    $instructionsForm.MaximizeBox = $false
    
    # Status message at the top
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Location = New-Object System.Drawing.Point(20, 20)
    $statusLabel.Size = New-Object System.Drawing.Size(540, 50)
    $statusLabel.Text = $statusMessage
    $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $instructionsForm.Controls.Add($statusLabel)
    
    # Create a panel for the instructions content
    $contentPanel = New-Object System.Windows.Forms.Panel
    $contentPanel.Location = New-Object System.Drawing.Point(20, 80)
    $contentPanel.Size = New-Object System.Drawing.Size(540, 320)
    $contentPanel.AutoScroll = $true
    $instructionsForm.Controls.Add($contentPanel)
    
    # Add the instructions text
    $yPos = 0
    
    # Title
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Location = New-Object System.Drawing.Point(0, $yPos)
    $titleLabel.Size = New-Object System.Drawing.Size(520, 30)
    $titleLabel.Text = "To prepare for ARK-4 installation:"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $contentPanel.Controls.Add($titleLabel)
    $yPos += 40
    
    # Common steps
    $commonSteps = @(
        "1. Back up all your important saves and data",
        "2. Remove your memory stick and back it up on your computer"
    )
    foreach ($step in $commonSteps) {
        $stepLabel = New-Object System.Windows.Forms.Label
        $stepLabel.Location = New-Object System.Drawing.Point(0, $yPos)
        $stepLabel.Size = New-Object System.Drawing.Size(520, 20)
        $stepLabel.Text = $step
        $contentPanel.Controls.Add($stepLabel)
        $yPos += 25
    }
    
    $yPos += 10
    
    # ChronoSwitch section
    $chronoTitle = New-Object System.Windows.Forms.Label
    $chronoTitle.Location = New-Object System.Drawing.Point(0, $yPos)
    $chronoTitle.Size = New-Object System.Drawing.Size(520, 25)
    $chronoTitle.Text = "Recommended Method:"
    $chronoTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $contentPanel.Controls.Add($chronoTitle)
    $yPos += 30
    
    # ChronoSwitch download link
    $chronoLink = New-Object System.Windows.Forms.LinkLabel
    $chronoLink.Location = New-Object System.Drawing.Point(0, $yPos)
    $chronoLink.Size = New-Object System.Drawing.Size(520, 20)
    $chronoLink.Text = "1. Download ChronoSwitch"
    $chronoLink.LinkColor = $accentColor
    $chronoLink.ActiveLinkColor = [System.Drawing.Color]::FromArgb(0, 102, 184)
    $chronoLink.Add_Click({
        Start-Process "https://github.com/PSP-Archive/Chronoswitch/releases/latest/download/Chronoswitch.zip"
    })
    $contentPanel.Controls.Add($chronoLink)
    $yPos += 25
    
    # ChronoSwitch steps
    $chronoSteps = @(
        "2. Extract the zip file",
        "3. Copy the CHRONOSWITCH folder to /PSP/GAME/ on your memory stick",
        "4. On your PSP:",
        "   - Go to Game menu",
        "   - Run ChronoSwitch",
        "   - Select 'Install 6.61 OFW'",
        "   - Follow the on-screen instructions",
        "   - Wait for the process to complete",
        "   - Your PSP will reboot to official firmware"
    )
    foreach ($step in $chronoSteps) {
        $stepLabel = New-Object System.Windows.Forms.Label
        $stepLabel.Location = New-Object System.Drawing.Point(0, $yPos)
        $stepLabel.Size = New-Object System.Drawing.Size(520, 20)
        $stepLabel.Text = $step
        $contentPanel.Controls.Add($stepLabel)
        $yPos += 25
    }
    
    $yPos += 10
    
    # Troubleshooting section
    $troubleTitle = New-Object System.Windows.Forms.Label
    $troubleTitle.Location = New-Object System.Drawing.Point(0, $yPos)
    $troubleTitle.Size = New-Object System.Drawing.Size(520, 25)
    $troubleTitle.Text = "If ChronoSwitch Fails:"
    $troubleTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $contentPanel.Controls.Add($troubleTitle)
    $yPos += 30
    
    $troubleSteps = @(
        "1. Try these steps first:",
        "   - Format memory stick (after backup)",
        "   - Try a different memory stick",
        "   - Remove battery for 30 seconds, then try again"
    )
    foreach ($step in $troubleSteps) {
        $stepLabel = New-Object System.Windows.Forms.Label
        $stepLabel.Location = New-Object System.Drawing.Point(0, $yPos)
        $stepLabel.Size = New-Object System.Drawing.Size(520, 20)
        $stepLabel.Text = $step
        $contentPanel.Controls.Add($stepLabel)
        $yPos += 25
    }
    
    $yPos += 10
    
    # Forum link
    $forumLink = New-Object System.Windows.Forms.LinkLabel
    $forumLink.Location = New-Object System.Drawing.Point(0, $yPos)
    $forumLink.Size = New-Object System.Drawing.Size(520, 20)
    $forumLink.Text = "2. Visit wololo.net forums for specific $cfwType removal guide"
    $forumLink.LinkColor = $accentColor
    $forumLink.ActiveLinkColor = [System.Drawing.Color]::FromArgb(0, 102, 184)
    $forumLink.Add_Click({
        Start-Process "http://wololo.net/talk/viewforum.php?f=20"
    })
    $contentPanel.Controls.Add($forumLink)
    $yPos += 35
    
    # Final steps
    $finalTitle = New-Object System.Windows.Forms.Label
    $finalTitle.Location = New-Object System.Drawing.Point(0, $yPos)
    $finalTitle.Size = New-Object System.Drawing.Size(520, 25)
    $finalTitle.Text = "Once Completed:"
    $finalTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $contentPanel.Controls.Add($finalTitle)
    $yPos += 30
    
    $finalSteps = @(
        "1. Go to Settings → System Information",
        "2. Verify you're on Official Firmware",
        "3. Reconnect your PSP to USB",
        "4. Click 'Refresh' and 'Detect PSP' in this tool",
        "5. Proceed with ARK-4 installation"
    )
    foreach ($step in $finalSteps) {
        $stepLabel = New-Object System.Windows.Forms.Label
        $stepLabel.Location = New-Object System.Drawing.Point(0, $yPos)
        $stepLabel.Size = New-Object System.Drawing.Size(520, 20)
        $stepLabel.Text = $step
        $contentPanel.Controls.Add($stepLabel)
        $yPos += 25
    }
    
    # OK button at the bottom
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(240, 420)
    $okButton.Size = New-Object System.Drawing.Size(100, 30)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okButton.FlatStyle = "Flat"
    $okButton.BackColor = $accentColor
    $okButton.ForeColor = $buttonTextColor
    $okButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $okButton.FlatAppearance.BorderSize = 0
    $instructionsForm.Controls.Add($okButton)
    
    # Update the CFW detection handlers to use the new form
    $driveComboBox.Add_SelectedIndexChanged({
        if ($driveComboBox.SelectedItem) {
            $selectedDrive = $driveComboBox.SelectedItem
            Add-LogEntry "Drive selected: $selectedDrive"
            
            if (Test-Path "$selectedDrive\PSP") {
                $cfwInfo = Get-PSPCFWInfo -pspDrive $selectedDrive
                $statusMessage = "PSP detected at $selectedDrive`nCFW: $($cfwInfo.CFW)"
                if ($cfwInfo.CFW -eq "ARK-4") {
                    $statusMessage += "`nInstallation: $( if ($cfwInfo.IsPermanent) { 'Permanent' } else { 'Temporary' })"
                }
                $progressLabel.Text = $statusMessage
                Add-LogEntry $statusMessage
                
                if ($cfwInfo.CFW -ne "Unknown" -and $cfwInfo.CFW -ne "ARK-4") {
                    Show-UninstallInstructions -cfwType $cfwInfo.CFW -statusMessage $statusMessage
                }
            } else {
                $progressLabel.Text = "Selected drive does not appear to be a PSP"
                Add-LogEntry "No PSP detected at $selectedDrive"
            }
        }
    })
    
    $instructionsForm.ShowDialog()
}

# Show the form
$form.ShowDialog()