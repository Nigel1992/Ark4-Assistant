# Add required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors
$darkBackground = "#121212"
$darkSecondary = "#333333"
$accentColor = "#4CAF50"
$textColor = "#FFFFFF"

# Define XAML
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ARK-4 Assistant" Height="580" Width="880"
        Background="#121212" WindowStartupLocation="CenterScreen">
    
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="80"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Header with PSP Icon -->
        <Grid Grid.Row="0" Margin="15,0,15,0">
            <TextBlock Text="ARK-4 Assistant" FontSize="24" FontWeight="Bold" 
                       Foreground="White" VerticalAlignment="Center" HorizontalAlignment="Left"/>
            <Image Source="https://www.shareicon.net/data/256x256/2015/10/28/142612_white_256x256.png" 
                   HorizontalAlignment="Right" VerticalAlignment="Center" Width="160" Height="80" Margin="0,0,10,0"/>
        </Grid>

        <!-- Main Content -->
        <Grid Grid.Row="1" Margin="15,0,15,0">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <!-- Drive Selection and Buttons in one row -->
            <Grid Grid.Row="0" Margin="0,0,0,2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                
                <StackPanel Grid.Column="0" Orientation="Vertical" Margin="0,0,10,0">
                    <TextBlock Text="PSP Drive Letter" FontSize="14" Foreground="White" Margin="0,0,0,2"/>
                    <ComboBox x:Name="driveComboBox" Width="120" Height="30" Padding="6,4" FontSize="13" HorizontalAlignment="Left"/>
                </StackPanel>
                
                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Bottom">
                    <Button x:Name="refreshButton" Content="Refresh Drives" Width="120" Height="30" Background="#333333" Foreground="White" Margin="0,0,5,0"/>
                    <Button x:Name="detectButton" Content="Detect PSP" Width="96" Height="30" Background="#028C53" Foreground="White" Margin="5,0,5,0"/>
                    <Button x:Name="debugButton" Content="Debug Log" Width="96" Height="30" Background="#333333" Foreground="White" Margin="5,0,0,0"/>
                </StackPanel>
            </Grid>

            <!-- Status and Progress -->
            <StackPanel Grid.Row="1" Margin="0,2,0,2">
                <TextBlock x:Name="progressLabel" Text="Ready to install..." Foreground="White" FontSize="14" Margin="0,0,0,2"/>
                <TextBlock Text="Please ensure your PSP is on firmware 6.60 or 6.61 before proceeding with the installation." 
                           Foreground="#FF9800" TextWrapping="Wrap" FontSize="14" Margin="0,0,0,2" FontWeight="SemiBold"/>
                
                <!-- Version Info Box -->
                <Border Background="#1A3450" BorderBrush="#2A5380" BorderThickness="1" CornerRadius="4" Margin="0,2,0,5" Padding="10,5">
                    <TextBlock x:Name="versionInfoLabel" Text="Latest version: Checking..." FontSize="14" 
                               Foreground="#4FC3F7" FontWeight="Bold"/>
                </Border>
                
                <ProgressBar x:Name="progressBar" Height="18" Maximum="100" Value="0"
                             Background="#333333" Foreground="#4CAF50" BorderBrush="#444" BorderThickness="1" Margin="0,0,0,2">
                    <ProgressBar.Template>
                        <ControlTemplate TargetType="ProgressBar">
                            <Border Background="#333" CornerRadius="9">
                                <Border x:Name="PART_Indicator" Background="#4CAF50" CornerRadius="9" HorizontalAlignment="Left"/>
                            </Border>
                        </ControlTemplate>
                    </ProgressBar.Template>
                </ProgressBar>
            </StackPanel>

            <!-- Log -->
            <Border Grid.Row="3" Background="#333333" BorderBrush="#444444" BorderThickness="1" 
                    Margin="0,5,0,0" MinHeight="150">
                <ScrollViewer x:Name="logScrollViewer" VerticalScrollBarVisibility="Visible" HorizontalScrollBarVisibility="Auto"
                            PanningMode="Both" CanContentScroll="False">
                    <TextBox x:Name="logBox" IsReadOnly="True" TextWrapping="Wrap"
                             Background="Transparent" Foreground="White" FontFamily="Consolas"
                             BorderThickness="0" AcceptsReturn="True" Padding="5"
                             VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Disabled"/>
                </ScrollViewer>
            </Border>
        </Grid>
        
        <!-- Footer -->
        <Grid Grid.Row="2" Margin="15,5">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <StackPanel Grid.Column="0" Orientation="Horizontal">
                <TextBlock Text="Made by Nigel1992" Foreground="#999999" VerticalAlignment="Center"/>
                <TextBlock Text=" | " Foreground="#999999" VerticalAlignment="Center" Margin="5,0"/>
                <TextBlock VerticalAlignment="Center">
                    <Hyperlink x:Name="sourceCodeLink" Foreground="#4FC3F7">
                        <TextBlock Text="SOURCE CODE" Foreground="#4FC3F7"/>
                    </Hyperlink>
                </TextBlock>
            </StackPanel>

            <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Center">
                <Button x:Name="startButton" Content="Start" Width="100" Height="28" 
                        Background="#4CAF50" Foreground="White" Margin="0,0,10,0"/>
                <Button x:Name="helpButton" Content="Help" Width="100" Height="28"
                        Background="#333333" Foreground="White" Margin="0,0,10,0"/>
                <Button x:Name="cancelButton" Content="Cancel" Width="100" Height="28"
                        Background="#333333" Foreground="White"/>
            </StackPanel>

            <StackPanel Grid.Column="2" Orientation="Horizontal" HorizontalAlignment="Right">
                <CheckBox x:Name="debugCheckbox" Content="Debug Mode" 
                         Foreground="#999999" VerticalAlignment="Center" Margin="0,0,10,0"/>
                <ComboBox x:Name="debugCFWCombo" Width="100" Margin="0,0,10,0" Visibility="Collapsed"/>
                <TextBlock x:Name="versionDateLabel" Text="Version: 2025-03-07"
                       Foreground="#999999" VerticalAlignment="Center"/>
            </StackPanel>
        </Grid>
    </Grid>
</Window>
"@

# Create window
$reader = [System.Xml.XmlNodeReader]::new($xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Script-level variable to control drive logging
$script:suppressDriveLog = $false

# Get controls
$driveComboBox = $window.FindName("driveComboBox")
$refreshButton = $window.FindName("refreshButton")
$detectButton = $window.FindName("detectButton")
$debugButton = $window.FindName("debugButton")
$progressBar = $window.FindName("progressBar")
$progressLabel = $window.FindName("progressLabel")
$logBox = $window.FindName("logBox")
$versionInfoLabel = $window.FindName("versionInfoLabel")
$startButton = $window.FindName("startButton")
$helpButton = $window.FindName("helpButton")
$cancelButton = $window.FindName("cancelButton")
$versionDateLabel = $window.FindName("versionDateLabel")
$debugCheckbox = $window.FindName("debugCheckbox")
$debugCFWCombo = $window.FindName("debugCFWCombo")
$sourceCodeLink = $window.FindName("sourceCodeLink")

# Initialize progress bar
$progressBar.Value = 0
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.IsIndeterminate = $false
$progressBar.Visibility = "Visible"

# Initialize checklist items
$checklistItems = @(
    "Downloading ARK-4 from GitHub",
    "Installing ARK_01234 to Memory Stick (/PSP/SAVEDATA/)",
    "Installing ARK_Loader to Memory Stick (/PSP/GAME/)",
    "Installing Ark_cIPL to Memory Stick (/PSP/GAME/)",
    "Ready to run ARK Loader",
    "Ready to run Ark cIPL Flasher"
)

# Remove the initial checklist display
# Add-LogEntry "=== Installation Steps ==="
# for ($i = 0; $i -lt $checklistItems.Count; $i++) {
#     Update-ChecklistItem -index $i -status "pending"
# }
# Add-LogEntry "===================="

# Initialize debug CFW combo
$debugCFWCombo.Items.Add("PRO")
$debugCFWCombo.Items.Add("LME")
$debugCFWCombo.Items.Add("ME")
$debugCFWCombo.Items.Add("ARK-4")
$debugCFWCombo.Items.Add("Unknown")
$debugCFWCombo.SelectedIndex = 0

# Define log file path
$logFilePath = Join-Path $env:TEMP "ARK4_Assistant_Debug.log"

# Function to add log entry
function Add-LogEntry {
    param(
        [string]$message,
        [switch]$NoNewLine
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMessage = "[$timestamp] $message"
    
    # Update UI log box
    $window.Dispatcher.Invoke([Action]{
        if ($logBox.Text.Length -gt 0) {
            $logBox.AppendText("`n")
        }
        $logBox.AppendText($formattedMessage)
        
        # Force scroll update
        $logScrollViewer = $window.FindName("logScrollViewer")
        if ($logScrollViewer) {
            $logBox.CaretIndex = $logBox.Text.Length
            $logScrollViewer.ScrollToBottom()
            $logScrollViewer.UpdateLayout()
            [System.Windows.Forms.Application]::DoEvents()
        }
    })
    
    # Write to log file
    try {
        Add-Content -Path $logFilePath -Value $formattedMessage
    } catch {
        $logBox.AppendText("`n[ERROR] Failed to write to log file: $_")
        $logScrollViewer = $window.FindName("logScrollViewer")
        if ($logScrollViewer) {
            $logScrollViewer.ScrollToBottom()
        }
    }
}

# Function to update checklist item
function Update-ChecklistItem {
    param (
        [int]$index,
        [string]$status,  # "pending", "done", "error", "skipped"
        [string]$additionalInfo = ""
    )
    
    $statusSymbol = switch ($status) {
        "pending" { "⋯" }
        "done"    { "✓" }
        "error"   { "✗" }
        "skipped" { "-" }
        default   { " " }
    }
    
    $message = "[$statusSymbol] Step $($index + 1): $($checklistItems[$index])"
    if ($additionalInfo) {
        $message += " $additionalInfo"
    }
    
    Add-LogEntry $message
}

# Function to update drive list
function Update-DriveList {
    $driveComboBox.Items.Clear()
    Get-PSDrive -PSProvider FileSystem | ForEach-Object { 
        $driveComboBox.Items.Add($_.Root)
    }
    Add-LogEntry "Drive list refreshed"
}

# Function to get PSP CFW info
function Get-PSPCFWInfo {
    param (
        [string]$pspDrive
    )
    
    # If in debug mode, return debug values
    if ($debugCheckbox.IsChecked) {
        $selectedCFW = $debugCFWCombo.SelectedItem
        Add-LogEntry "[DEBUG] Using simulated CFW: $selectedCFW"
        return @{
            CFW = $selectedCFW
        }
    }
    
    # Format drive path for display (remove trailing backslash)
    $displayDrive = $pspDrive.TrimEnd('\')
    $cfw = "Unknown"
    
    try {
        $indicators = @{
            "ARK-4" = @(
                "\PSP\GAME\ARK_Loader",
                "\PSP\SAVEDATA\ARK_01234",
                "\PSP\GAME\Ark_cIPL"
            )
            "PRO" = @(
                "\PSP\GAME\PRO_Update",
                "\PSP\GAME\PROUPDATE",
                "\seplugins\PRO.prx"
            )
            "LME" = @(
                "\PSP\GAME\LMEBOOT",
                "\PSP\GAME\LMEUpdater"
            )
            "ME" = @(
                "\PSP\GAME\M33_UPDATE",
                "\PSP\GAME\MEUPDATE"
            )
        }
        
        foreach ($cfwType in $indicators.Keys) {
            foreach ($path in $indicators[$cfwType]) {
                if (Test-Path "$pspDrive$path") {
                    $cfw = $cfwType
                    break
                }
            }
            if ($cfw -ne "Unknown") { break }
        }
        
        # Only log CFW detection once after we've found it
        if ($cfw -ne "Unknown") {
            Add-LogEntry "Found $cfw CFW"
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

# Function to get latest ARK-4 release
function Get-LatestARKRelease {
    Add-LogEntry "Starting ARK-4 version check..."
    $apiUrl = "https://api.github.com/repos/PSP-Archive/ARK-4/releases"
    
    try {
        $releases = Invoke-RestMethod -Uri $apiUrl -Method Get
        $latestRelease = $releases | 
            Where-Object { -not $_.prerelease } |
            ForEach-Object {
                if ($_.name -match 'Rev\s+(\d+)') {
                    $revNumber = [int]$matches[1]
                } else {
                    $revNumber = 0
                }
                $_ | Add-Member -NotePropertyName RevisionNumber -NotePropertyValue $revNumber -PassThru
            } |
            Sort-Object -Property RevisionNumber -Descending |
            Select-Object -First 1
        
        if ($latestRelease) {
            $publishDate = [DateTime]::Parse($latestRelease.published_at).ToString("yyyy-MM-dd")
            $versionInfoLabel.Text = "Latest ARK4 Stable Release: $($latestRelease.name)"
            Add-LogEntry "Latest ARK-4 version available: $($latestRelease.name) (Released: $publishDate)"
            return @{
                Version = $latestRelease.name
                Assets = $latestRelease.assets
                PublishDate = $publishDate
            }
        }
    } catch {
        Add-LogEntry "ERROR: Failed to fetch releases - $_"
        $versionInfoLabel.Text = "Failed to fetch version info"
    }
}

# Function to update progress bar
function Update-Progress {
    param (
        [double]$value
    )
    
    $window.Dispatcher.Invoke([Action]{
        Write-Host "Setting progress bar to: $value"  # Debug line
        $progressBar.Value = [Math]::Max(0, [Math]::Min(100, $value))
        
        # Update the PART_Indicator width based on the progress value
        $indicator = $progressBar.Template.FindName("PART_Indicator", $progressBar)
        if ($indicator) {
            $percentComplete = $value / 100
            $width = $progressBar.ActualWidth * $percentComplete
            $indicator.Width = $width
        }
        
        $progressBar.InvalidateVisual()
        $progressBar.UpdateLayout()
    })
}

# Function to install ARK-4
function Install-ARK4 {
    param (
        [string]$pspDrive,
        [object]$releaseInfo
    )
    
    $tempPath = [System.IO.Path]::GetTempPath()
    $downloadPath = Join-Path $tempPath "ARK-4.zip"
    $extractPath = Join-Path $tempPath "ARK-4"
    
    try {
        # Reset progress bar
        Update-Progress -value 0
        
        $progressLabel.Text = "Downloading ARK-4..."
        Add-LogEntry "Starting download of ARK-4..."
        Update-ChecklistItem -index 0 -status "pending"
        
        $downloadUrl = $releaseInfo.Assets | 
            Where-Object { $_.name -like "*.zip" } | 
            Select-Object -First 1 -ExpandProperty browser_download_url
        
        # Download with progress
        $webClient = New-Object System.Net.WebClient
        
        # Create script blocks for event handlers
        $progressScript = {
            param($sender, $e)
            $downloadProgress = [math]::Min(40, ($e.ProgressPercentage * 0.4))
            Update-Progress -value $downloadProgress
            $window.Dispatcher.Invoke([Action]{
                $progressLabel.Text = "Downloading: $($e.ProgressPercentage)%"
            })
        }
        
        $completedScript = {
            param($sender, $e)
            Update-Progress -value 40
            $window.Dispatcher.Invoke([Action]{
                Update-ChecklistItem -index 0 -status "done" -additionalInfo "(Download complete)"
                Add-LogEntry "Download completed"
            })
        }
        
        # Register event handlers
        $progressEvent = Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action $progressScript
        $completedEvent = Register-ObjectEvent -InputObject $webClient -EventName DownloadFileCompleted -Action $completedScript
        
        # Start download
        $webClient.DownloadFileAsync((New-Object Uri($downloadUrl)), $downloadPath)
        
        # Wait for download to complete
        while ($webClient.IsBusy) {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 100
        }
        
        # Cleanup event handlers
        if ($progressEvent) { Unregister-Event -SourceIdentifier $progressEvent.Name }
        if ($completedEvent) { Unregister-Event -SourceIdentifier $completedEvent.Name }
        $webClient.Dispose()
        
        # Extract phase: 40-60%
        Update-Progress -value 40
        $window.Dispatcher.Invoke([Action]{ 
            $progressLabel.Text = "Extracting files..."
        })
        Add-LogEntry "Extracting files..."
        
        # Create extraction directory
        if (Test-Path $extractPath) {
            Remove-Item $extractPath -Recurse -Force
        }
        New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
        
        # Extract files
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $extractPath)
        
        Update-Progress -value 60
        $window.Dispatcher.Invoke([Action]{ 
            $progressLabel.Text = "Copying files to PSP..."
        })
        
        # Copy SAVEDATA (60-70%)
        if (Test-Path "$extractPath\ARK_01234") {
            Update-ChecklistItem -index 1 -status "pending"
            Add-LogEntry "Copying ARK_01234 to SAVEDATA..."
            Copy-Item "$extractPath\ARK_01234" -Destination "$pspDrive\PSP\SAVEDATA\" -Recurse -Force
            Update-ChecklistItem -index 1 -status "done"
            Update-Progress -value 70
        }
        
        # Copy ARK_Loader (70-85%)
        if (Test-Path "$extractPath\ARK_Loader") {
            Update-ChecklistItem -index 2 -status "pending"
            Add-LogEntry "Copying ARK_Loader to GAME..."
            Copy-Item "$extractPath\ARK_Loader" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
            Update-ChecklistItem -index 2 -status "done"
            Update-Progress -value 85
        }
        
        # Copy Ark_cIPL (85-95%)
        if (Test-Path "$extractPath\Ark_cIPL") {
            Update-ChecklistItem -index 3 -status "pending"
            Add-LogEntry "Copying Ark_cIPL to GAME..."
            Copy-Item "$extractPath\Ark_cIPL" -Destination "$pspDrive\PSP\GAME\" -Recurse -Force
            Update-ChecklistItem -index 3 -status "done"
            Update-Progress -value 95
        }
        
        # Final steps (95-100%)
        Update-ChecklistItem -index 4 -status "pending" -additionalInfo "(Run ARK Loader on your PSP)"
        Update-ChecklistItem -index 5 -status "pending" -additionalInfo "(Run Ark cIPL Flasher on your PSP)"
        
        # Cleanup
        Remove-Item $downloadPath -Force
        Remove-Item $extractPath -Recurse -Force
        
        Update-Progress -value 100
        $window.Dispatcher.Invoke([Action]{ 
            $progressLabel.Text = "Installation completed successfully!"
        })
        Add-LogEntry "Installation completed successfully!"
        
        [System.Windows.MessageBox]::Show(
            "ARK-4 files have been copied to your PSP.`n`n" +
            "Next steps:`n" +
            "1. On your PSP, go to Game > Memory Stick`n" +
            "2. Run the ARK Loader to install temporary CFW`n" +
            "3. For permanent installation, run the Ark cIPL Flasher`n`n" +
            "Version installed: $($releaseInfo.Version)",
            "Installation Complete",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Information
        )
        
    } catch {
        Update-ChecklistItem -index 0 -status "error"
        Update-Progress -value 0
        $window.Dispatcher.Invoke([Action]{ 
            $progressLabel.Text = "Installation failed!"
        })
        Add-LogEntry "ERROR: Installation failed - $_"
        [System.Windows.MessageBox]::Show(
            "Failed to install ARK-4: $_",
            "Error",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Error
        )
    }
}

# Function to detect PSP
function Test-PSPDevice {
    param (
        [string]$drivePath
    )
    
    try {
        # Check for PSP folder structure
        $requiredFolders = @(
            "PSP",
            "PSP\GAME",
            "PSP\SAVEDATA"
        )
        
        foreach ($folder in $requiredFolders) {
            $fullPath = Join-Path $drivePath $folder
            if (-not (Test-Path $fullPath -PathType Container)) {
                return $false
            }
        }
        
        return $true
    } catch {
        Add-LogEntry "Error checking PSP device: $_"
        return $false
    }
}

# Add event handlers
$refreshButton.Add_Click({
    Update-DriveList
})

# Add drive selection handler
$driveComboBox.Add_SelectionChanged({
    if ($driveComboBox.SelectedItem) {
        $selectedDrive = $driveComboBox.SelectedItem
        $displayDrive = $selectedDrive.TrimEnd('\')
        # Only log drive selection if it's not from PSP detection
        if (-not $script:suppressDriveLog) {
            Add-LogEntry "Drive selected: $displayDrive"
        }
        
        if (Test-PSPDevice -drivePath $selectedDrive) {
            $cfwInfo = Get-PSPCFWInfo -pspDrive $selectedDrive
            $statusMessage = "PSP detected at $displayDrive | CFW: $($cfwInfo.CFW)"
            $progressLabel.Text = $statusMessage
            # Don't log PSP detection here as it will be logged by Get-PSPCFWInfo
            
            if ($cfwInfo.CFW -ne "Unknown" -and $cfwInfo.CFW -ne "ARK-4") {
                [System.Windows.MessageBox]::Show(
                    "Detected $($cfwInfo.CFW) custom firmware.`n`n" +
                    "Please remove existing CFW before installing ARK-4.`n`n" +
                    "You can use ChronoSwitch to remove the existing CFW.",
                    "Existing CFW Detected",
                    [System.Windows.MessageBoxButton]::OK,
                    [System.Windows.MessageBoxImage]::Warning
                )
            }
        } else {
            $progressLabel.Text = "Selected drive is not a PSP"
            Add-LogEntry "No PSP detected at $displayDrive"
        }
    }
})

$detectButton.Add_Click({
    Add-LogEntry "Scanning drives for PSP..."
    $progressLabel.Text = "Scanning for PSP..."
    $pspDrive = $null
    
    # Get all available drives
    $drives = Get-PSDrive -PSProvider FileSystem
    
    foreach ($drive in $drives) {
        $drivePath = $drive.Root
        Add-LogEntry "Checking drive $drivePath..."
        
        if (Test-PSPDevice -drivePath $drivePath) {
            $pspDrive = $drivePath
            # Suppress drive selection logging during PSP detection
            $script:suppressDriveLog = $true
            # Select the PSP drive in the combo box
            $driveComboBox.SelectedItem = $pspDrive
            $script:suppressDriveLog = $false
            
            # Process the detection directly here
            $cfwInfo = Get-PSPCFWInfo -pspDrive $pspDrive
            $displayDrive = $pspDrive.TrimEnd('\')
            $statusMessage = "PSP detected at $displayDrive | CFW: $($cfwInfo.CFW)"
            $progressLabel.Text = $statusMessage
            Add-LogEntry $statusMessage
            
            if ($cfwInfo.CFW -ne "Unknown" -and $cfwInfo.CFW -ne "ARK-4") {
                [System.Windows.MessageBox]::Show(
                    "Detected $($cfwInfo.CFW) custom firmware.`n`n" +
                    "Please remove existing CFW before installing ARK-4.`n`n" +
                    "You can use ChronoSwitch to remove the existing CFW.",
                    "Existing CFW Detected",
                    [System.Windows.MessageBoxButton]::OK,
                    [System.Windows.MessageBoxImage]::Warning
                )
            } else {
                [System.Windows.MessageBox]::Show(
                    "PSP detected successfully at drive $pspDrive`n" +
                    "No conflicting CFW detected. Ready to install ARK-4.",
                    "PSP Detected",
                    [System.Windows.MessageBoxButton]::OK,
                    [System.Windows.MessageBoxImage]::Information
                )
            }
            break
        }
    }
    
    if (-not $pspDrive) {
        $progressLabel.Text = "No PSP detected"
        Add-LogEntry "No PSP detected in any available drives"
        [System.Windows.MessageBox]::Show(
            "Could not detect a PSP on any drive.`n`n" +
            "Please check:`n" +
            "1. PSP is connected via USB cable`n" +
            "2. USB Mode is enabled on your PSP`n" +
            "3. The USB cable is working properly",
            "No PSP Detected",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Warning
        )
    }
})

$debugButton.Add_Click({
    if (Test-Path $logFilePath) {
        Start-Process notepad.exe $logFilePath
    } else {
        [System.Windows.MessageBox]::Show(
            "No debug log file found at:`n$logFilePath",
            "Debug Log Not Found",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Information
        )
    }
})

$startButton.Add_Click({
    if (-not $driveComboBox.SelectedItem) {
        [System.Windows.MessageBox]::Show("Please select a PSP drive first!", "Error")
        return
    }
    
    $result = [System.Windows.MessageBox]::Show(
        "IMPORTANT: Please verify your PSP's current firmware status:`n`n" +
        "1. Go to PSP's Settings > System Settings > System Information`n" +
        "2. Verify that NO custom firmware is currently installed`n" +
        "3. Confirm your PSP is on Official Firmware 6.60 or 6.61`n`n" +
        "Are you sure you want to proceed with the installation?",
        "Firmware Verification Required",
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Warning
    )
    
    if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
        $pspDrive = $driveComboBox.SelectedItem
        Add-LogEntry "Starting installation to drive: $pspDrive"
        
        # Check for existing installation
        $existingInstallation = @(
            "$pspDrive\PSP\SAVEDATA\ARK_01234",
            "$pspDrive\PSP\GAME\ARK_Loader",
            "$pspDrive\PSP\GAME\Ark_cIPL"
        ) | Where-Object { Test-Path $_ }
        
        if ($existingInstallation) {
            $result = [System.Windows.MessageBox]::Show(
                "ARK-4 appears to be already installed.`n`n" +
                "Would you like to reinstall/update?",
                "ARK-4 Already Installed",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Warning
            )
            
            if ($result -eq [System.Windows.MessageBoxResult]::No) {
                Add-LogEntry "Installation cancelled - ARK-4 already installed"
                return
            }
        }
        
        $progressBar.Value = 0
        
        # Create required directories
        @(
            "$pspDrive\PSP\SAVEDATA",
            "$pspDrive\PSP\GAME"
        ) | ForEach-Object {
            if (!(Test-Path $_)) {
                New-Item -ItemType Directory -Path $_ -Force
                Add-LogEntry "Created directory: $_"
            }
        }
        
        # Get and install latest release
        $releaseInfo = Get-LatestARKRelease
        if ($releaseInfo) {
            Install-ARK4 -pspDrive $pspDrive -releaseInfo $releaseInfo
        }
    }
})

$helpButton.Add_Click({
    [System.Windows.MessageBox]::Show(
        "This tool helps you install ARK-4 Custom Firmware on your PSP.`n`n" +
        "Requirements:`n" +
        "- PSP on firmware 6.60 or 6.61`n" +
        "- USB cable`n" +
        "- Memory Stick (unless using PSP Go)`n" +
        "- Internet connection to download ARK-4`n`n" +
        "For more help, visit the ARK-4 wiki.",
        "Help",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
})

$cancelButton.Add_Click({
    $window.Close()
})

$debugCheckbox.Add_Checked({
    $debugCFWCombo.Visibility = "Visible"
    Add-LogEntry "Debug mode enabled"
    
    # Update status message and version info for debug mode
    $selectedCFW = $debugCFWCombo.SelectedItem
    $statusMessage = "PSP detected at DEBUG`nCFW: $selectedCFW"
    $progressLabel.Text = $statusMessage
    $versionInfoLabel.Text = "Latest ARK4 Stable Release: DEBUG MODE"
    Add-LogEntry "[DEBUG] Simulating $selectedCFW CFW"
})

$debugCheckbox.Add_Unchecked({
    $debugCFWCombo.Visibility = "Collapsed"
    Add-LogEntry "Debug mode disabled"
    
    # Reset to normal mode
    $progressLabel.Text = "Ready to install..."
    $versionInfoLabel.Text = "Latest version: Checking..."
    # Refresh version info
    Get-LatestARKRelease
})

$debugCFWCombo.Add_SelectionChanged({
    if ($debugCheckbox.IsChecked) {
        # Get the current selection after it has changed
        $window.Dispatcher.Invoke({
            $selectedCFW = $debugCFWCombo.SelectedItem
            $statusMessage = "PSP detected at DEBUG`nCFW: $selectedCFW"
            $progressLabel.Text = $statusMessage
            Add-LogEntry "[DEBUG] Changed simulated CFW to: $selectedCFW"
            
            # Also update version info to maintain debug state
            $versionInfoLabel.Text = "Latest ARK4 Stable Release: DEBUG MODE ($selectedCFW)"
        })
    }
})

# Add source code link handler
$sourceCodeLink.Add_Click({
    Start-Process "https://github.com/Nigel1992/Argonv3-RPI5-LibreELEC"
})

# Initialize log file
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

# Initialize
Update-DriveList
Get-LatestARKRelease

# Show window
$window.ShowDialog() 