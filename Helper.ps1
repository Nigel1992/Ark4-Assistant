Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors
$darkBackground = [System.Drawing.Color]::FromArgb(32, 32, 32)
$darkSecondary = [System.Drawing.Color]::FromArgb(45, 45, 48)
$accentColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$textColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$buttonTextColor = [System.Drawing.Color]::White

# Create and set the application icon
$iconBase64 = @'
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
'@

# Convert Base64 to bytes and create icon
$iconBytes = [Convert]::FromBase64String($iconBase64)
$iconStream = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$iconStream.Write($iconBytes, 0, $iconBytes.Length)
$appIcon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::FromStream($iconStream)).GetHIcon())

# Define log file path
$logFilePath = Join-Path $env:TEMP "ARK4_Assistant_Debug.log"

# Create the main form with modern styling
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ark4 Assistant"
$form.Size = New-Object System.Drawing.Size(530, 620)
$form.StartPosition = "CenterScreen"
$form.WindowState = "Normal"
$form.TopMost = $false
$form.BackColor = $darkBackground
$form.ForeColor = $textColor
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# Add focus handling
$form.Add_Deactivate({
    # When the form loses focus, it should go behind other windows
    $form.TopMost = $false
})

$form.Add_Activated({
    # When the form gains focus, bring it to front but don't make it stay on top
    $form.BringToFront()
})

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
$label.Size = New-Object System.Drawing.Size(470, 40)
$label.Text = "Please ensure your PSP is on firmware 6.60 or 6.61 before proceeding with the installation."
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$label.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($label)

# Update version info label position and styling
$versionInfoLabel = New-Object System.Windows.Forms.Label
$versionInfoLabel.Location = New-Object System.Drawing.Point(20, 140)
$versionInfoLabel.Size = New-Object System.Drawing.Size(470, 40)
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
        
        return @{
            CFW = $cfw
        }
        
    } catch {
        Add-LogEntry "Error detecting CFW: $_"
        return @{
            CFW = "Error"
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
$progressLabel.Size = New-Object System.Drawing.Size(470, 50)
$progressLabel.Text = "Ready to install..."
$progressLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$progressLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($progressLabel)

# Create checklist
$checklist = New-Object System.Windows.Forms.CheckedListBox
$checklist.Location = New-Object System.Drawing.Point(20, 250)
$checklist.BackColor = $darkSecondary
$checklist.ForeColor = $textColor
$checklist.BorderStyle = "None"
$checklist.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$checklist.Items.Clear()

# Add items to checklist
$checklistItems = @(
    "[    ] 1. Downloading ARK-4 from GitHub...",
    "[    ] 2. Installing ARK_01234 to Memory Stick (/PSP/SAVEDATA/)",
    "[    ] 3. Installing ARK_Loader to Memory Stick (/PSP/GAME/)",
    "[    ] 4. Installing Ark_cIPL to Memory Stick (/PSP/GAME/)",
    "[    ] 5. Ready to run ARK Loader",
    "[    ] 6. Ready to run Ark cIPL Flasher"
)
$checklist.Items.AddRange($checklistItems)

# Calculate height based on items (each item is approximately 20 pixels high)
$itemHeight = 20
$totalItems = $checklist.Items.Count
$checklistHeight = $itemHeight * $totalItems
$checklist.Size = New-Object System.Drawing.Size(470, $checklistHeight)

$checklist.Enabled = $false  # Make it read-only
$mainPanel.Controls.Add($checklist)

# Function to update checklist item with status
function Update-ChecklistItem {
    param (
        [int]$index,
        [string]$status,  # "pending", "done", "error", "skipped"
        [string]$additionalInfo = ""
    )
    
    if ($checklist.InvokeRequired) {
        $checklist.Invoke([Action]{
            Update-ChecklistItem -index $index -status $status -additionalInfo $additionalInfo
        })
        return
    }
    
    $currentItem = $checklist.Items[$index].ToString()
    $newItem = switch ($status) {
        "pending" { $currentItem.Replace("[    ]", "[ .. ]") }
        "done"    { $currentItem.Replace("[    ]", "[ + ]").Replace("[ .. ]", "[ + ]") }
        "error"   { $currentItem.Replace("[    ]", "[ x ]").Replace("[ .. ]", "[ x ]") }
        "skipped" { $currentItem.Replace("[    ]", "[ - ]").Replace("[ .. ]", "[ - ]") }
        default   { $currentItem }
    }
    
    if ($additionalInfo) {
        # Remove any existing additional info (in parentheses)
        $newItem = $newItem -replace "\s*\([^)]*\)\s*$", ""
        $newItem = "$newItem $additionalInfo"
    }
    
    $checklist.Items[$index] = $newItem
    $checklist.Refresh()
}

# Create button panel
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(20, 390)
$buttonPanel.Size = New-Object System.Drawing.Size(470, 40)
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
$progressBar.Location = New-Object System.Drawing.Point(20, 440)
$progressBar.Size = New-Object System.Drawing.Size(470, 20)
$progressBar.Style = "Continuous"
$progressBar.BackColor = $darkSecondary
$progressBar.ForeColor = $accentColor
$mainPanel.Controls.Add($progressBar)

# Create status panel
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(20, 470)
$statusPanel.Size = New-Object System.Drawing.Size(470, 20)
$statusPanel.BackColor = $darkSecondary
$mainPanel.Controls.Add($statusPanel)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Log Output:"
$statusLabel.Location = New-Object System.Drawing.Point(0, 0)
$statusLabel.Size = New-Object System.Drawing.Size(470, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = $textColor
$statusLabel.TextAlign = "MiddleLeft"
$statusPanel.Controls.Add($statusLabel)

# Create log box
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(20, 490)
$logBox.Size = New-Object System.Drawing.Size(470, 60)
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.BackColor = $darkSecondary
$logBox.ForeColor = $textColor
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$mainPanel.Controls.Add($logBox)

# After creating the log box, add copyright label
$copyrightLabel = New-Object System.Windows.Forms.Label
$copyrightLabel.Location = New-Object System.Drawing.Point(20, 560)
$copyrightLabel.Size = New-Object System.Drawing.Size(200, 20)
$copyrightLabel.Text = "Made by Nigel1992"
$copyrightLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$copyrightLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$copyrightLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($copyrightLabel)

# Create debug mode checkbox with modern styling
$debugCheckbox = New-Object System.Windows.Forms.CheckBox
$debugCheckbox.Location = New-Object System.Drawing.Point(240, 560)  # Centered between copyright and version
$debugCheckbox.Size = New-Object System.Drawing.Size(110, 20)
$debugCheckbox.Text = "Debug Mode"
$debugCheckbox.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)  # Match other bottom text color
$debugCheckbox.Font = New-Object System.Drawing.Font("Segoe UI", 8)  # Match other bottom text size
$debugCheckbox.BackColor = $darkBackground
$mainPanel.Controls.Add($debugCheckbox)

# Create debug controls panel that shows only when debug is enabled
$debugPanel = New-Object System.Windows.Forms.Panel
$debugPanel.Location = New-Object System.Drawing.Point(410, 560)  # Right after debug checkbox
$debugPanel.Size = New-Object System.Drawing.Size(120, 20)  # Match height of other bottom elements
$debugPanel.BackColor = $darkBackground
$debugPanel.Visible = $false
$mainPanel.Controls.Add($debugPanel)

# Create CFW type combo box for debug
$debugCFWCombo = New-Object System.Windows.Forms.ComboBox
$debugCFWCombo.Location = New-Object System.Drawing.Point(0, -5)
$debugCFWCombo.Size = New-Object System.Drawing.Size(120, 20)
$debugCFWCombo.BackColor = $darkSecondary
$debugCFWCombo.ForeColor = $textColor
$debugCFWCombo.FlatStyle = "Flat"
$debugCFWCombo.Font = New-Object System.Drawing.Font("Segoe UI", 8)  # Match other bottom text size
$debugCFWCombo.Items.AddRange(@("PRO", "LME", "ME", "ARK-4", "Unknown"))
$debugCFWCombo.SelectedIndex = 0
$debugPanel.Controls.Add($debugCFWCombo)

# Add version info label on the right side
$versionDateLabel = New-Object System.Windows.Forms.Label
$versionDateLabel.Location = New-Object System.Drawing.Point(290, 560)
$versionDateLabel.Size = New-Object System.Drawing.Size(200, 20)
$versionDateLabel.Text = "Version Info: " + (Get-Date -Format "yyyy-MM-dd")
$versionDateLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$versionDateLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$versionDateLabel.TextAlign = "MiddleRight"
$mainPanel.Controls.Add($versionDateLabel)

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
            
            # Update version info label with white title and blue version
            $versionInfoLabel.Location = New-Object System.Drawing.Point(20, 140)
            $versionInfoLabel.Size = New-Object System.Drawing.Size(470, 30)
            $versionInfoLabel.Text = "Latest ARK4 Stable Release: " + $latestRelease.name
            $versionInfoLabel.BackColor = $darkBackground  # Remove special background
            $versionInfoLabel.Padding = New-Object System.Windows.Forms.Padding(0)  # Remove padding
            
            # Create a custom font for the entire label
            $versionInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)
            
            # Create a RichTextBox for mixed formatting
            $richTextBox = New-Object System.Windows.Forms.RichTextBox
            $richTextBox.Location = $versionInfoLabel.Location
            $richTextBox.Size = $versionInfoLabel.Size
            $richTextBox.BackColor = $darkBackground
            $richTextBox.BorderStyle = "None"
            $richTextBox.ReadOnly = $true
            $richTextBox.Font = $versionInfoLabel.Font
            
            # Add the text with different colors
            $richTextBox.Text = "Latest ARK4 Stable Release: " + $latestRelease.name
            $richTextBox.SelectionStart = 0
            $richTextBox.SelectionLength = 27  # Length of "Latest ARK4 Stable Release: "
            $richTextBox.SelectionColor = $textColor  # White color for title and colon
            $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5, [System.Drawing.FontStyle]::Underline)
            
            $richTextBox.SelectionStart = 27
            $richTextBox.SelectionLength = $richTextBox.Text.Length - 27
            $richTextBox.SelectionColor = $accentColor  # Blue color for entire version
            $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)
            
            # Replace the label with the RichTextBox
            $mainPanel.Controls.Remove($versionInfoLabel)
            $mainPanel.Controls.Add($richTextBox)
            
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
        $versionInfoLabel.Text = 'Failed to fetch version info'
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
        Update-ChecklistItem -index 0 -status "pending"
        
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
                # Force update the checklist item immediately
                Update-ChecklistItem -index 0 -status "done" -additionalInfo "(Download complete)"
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
        
        # Force update download status
        Update-ChecklistItem -index 0 -status "done" -additionalInfo "(Download complete)"
        
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
                $progress = [math]::Min(80, ([math]::Round(($extracted / $totalItems) * 60) + 20))
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
            
            # Copy files to PSP
            $progressLabel.Text = "Copying files to PSP..."
            Add-LogEntry "Copying files to PSP..."
            
            # Copy SAVEDATA
            if (Test-Path "$extractPath\ARK_01234") {
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 1 -status "pending" -additionalInfo "(Copying...)"
                })
                Add-LogEntry "Copying ARK_01234 to SAVEDATA..."
                Copy-Item "$extractPath\ARK_01234" -Destination "$pspDrive\PSP\SAVEDATA\" -Recurse -Force
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 1 -status "done" -additionalInfo "(Copy complete)"
                })
                Add-LogEntry "SAVEDATA copy complete"
            }
            
            # Copy GAME folders
            if (Test-Path "$extractPath\ARK_Loader") {
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 2 -status "pending" -additionalInfo "(Copying...)"
                })
                Add-LogEntry "Copying ARK_Loader to GAME..."
                Copy-Item "$extractPath\ARK_Loader" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 2 -status "done" -additionalInfo "(Copy complete)"
                })
                Add-LogEntry "ARK_Loader copy complete"
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 3 -status "pending" -additionalInfo "(Run ARK Loader on your PSP)"
                })
            }
            
            if (Test-Path "$extractPath\Ark_cIPL") {
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 4 -status "pending" -additionalInfo "(Copying...)"
                })
                Add-LogEntry "Copying Ark_cIPL to GAME..."
                Copy-Item "$extractPath\Ark_cIPL" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 4 -status "done" -additionalInfo "(Copy complete)"
                })
                Add-LogEntry "Ark_cIPL copy complete"
                $checklist.Invoke([Action]{
                    Update-ChecklistItem -index 5 -status "pending" -additionalInfo "(Run Ark cIPL Flasher on your PSP)"
                })
            }
            
            $progressBar.Value = 100
            
            # Cleanup
            Add-LogEntry "Cleaning up temporary files..."
            Remove-Item $downloadPath -Force
            Remove-Item $extractPath -Recurse -Force
            
            $progressLabel.Text = "Installation completed successfully!"
            Add-LogEntry "Installation completed successfully!"
            [System.Windows.Forms.MessageBox]::Show(@"
ARK-4 files have been copied to your PSP.

Next steps:
1. On your PSP, go to Game > Memory Stick
2. Run the ARK Loader to install temporary CFW
3. For permanent installation, run the Ark cIPL Flasher

Version installed: $($releaseInfo.Version)
"@,
                "Installation Complete"
            )
            
        } catch {
            Update-ChecklistItem -index 0 -status "error" -additionalInfo "(Extraction failed)"
            $progressLabel.Text = "Extraction failed!"
            Add-LogEntry "ERROR: Extraction failed - $_"
            [System.Windows.Forms.MessageBox]::Show("Failed to extract ARK-4: $_", "Error")
        }
        
    } catch {
        Update-ChecklistItem -index 0 -status "error" -additionalInfo "(Download failed)"
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

    # Show firmware verification dialog
    $confirmResult = [System.Windows.Forms.MessageBox]::Show(
        "IMPORTANT: Please verify your PSP's current firmware status:

1. Go to PSP's Settings > System Settings > System Information
2. Verify that NO custom firmware is currently installed
3. Confirm your PSP is on Official Firmware 6.60 or 6.61

Are you sure you want to proceed with the installation?

Note: Installing ARK-4 over another CFW may cause issues.",
        "Firmware Verification Required",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    
    if ($confirmResult -eq [System.Windows.Forms.DialogResult]::No) {
        Add-LogEntry "Installation cancelled by user at firmware verification step"
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

# Add debug checkbox change handler
$debugCheckbox.Add_CheckedChanged({
    $debugPanel.Visible = $debugCheckbox.Checked
    Add-LogEntry "Debug mode: $($debugCheckbox.Checked)"
    
    if ($debugCheckbox.Checked) {
        # Update status message and version info for debug mode
        $selectedCFW = $debugCFWCombo.SelectedItem
        $statusMessage = "PSP detected at DEBUG`nCFW: $selectedCFW"
        $progressLabel.Text = $statusMessage
        $versionInfoLabel.Text = "Latest ARK4 Stable Release`nVersion: DEBUG MODE"
        $versionInfoLabel.ForeColor = $textColor  # Keep white in debug mode
        $versionInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5, [System.Drawing.FontStyle]::Underline)
        Add-LogEntry "[DEBUG] Simulating $selectedCFW CFW"
    } else {
        # Reset to normal mode
        $progressLabel.Text = "Ready to install..."
        $versionInfoLabel.Text = "Latest version: Checking..."
        $versionInfoLabel.ForeColor = $accentColor  # Reset to accent color
        $versionInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)  # Reset font
        # Refresh version info
        $releaseInfo = Get-LatestARKRelease
    }
})

# Add debug CFW combo box change handler
$debugCFWCombo.Add_SelectedIndexChanged({
    if ($debugCheckbox.Checked) {
        $selectedCFW = $debugCFWCombo.SelectedItem
        $statusMessage = "PSP detected at DEBUG`nCFW: $selectedCFW"
        $progressLabel.Text = $statusMessage
        Add-LogEntry "[DEBUG] Changed simulated CFW to: $selectedCFW"
    }
})

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