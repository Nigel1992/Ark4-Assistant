# ARK-4 Assistant

![{3C9AA799-F19E-49D6-81F6-CA680EED6770}](https://github.com/user-attachments/assets/647ebc6b-0bb6-4908-b398-7933f8eff254)


A modern, user-friendly WPF-based GUI tool for installing ARK-4 Custom Firmware on PlayStation Portable (PSP) devices.

## Latest Updates

### Major UI Framework Update
- Migrated from Windows Forms to WPF for improved performance and modern UI
- Implemented XAML-based interface with responsive grid layout
- Enhanced visual design with modern controls and animations
- Added GitHub source code link in footer

### Visual Improvements
- Redesigned dark theme with accent colors
- Modern button styles with hover effects
- Enhanced progress bar visualization
- Integrated PSP icon in header area
- Improved footer layout with source code link

### Installation Process Enhancements
- Added detailed progress tracking with status indicators
- Improved extraction progress calculation accuracy
- Enhanced checklist system with visual status markers:
  - [ .. ] In Progress
  - [ + ] Completed
  - [ x ] Error
  - [ - ] Skipped
- Added real-time feedback during file operations

### Debug Mode Improvements
- Streamlined debug mode interface
- Enhanced status message handling
- Consistent text styling across all modes
- Improved version display formatting in debug mode

## Features

- 🎮 Automatic PSP device detection
- 🔄 Automatic latest ARK-4 version detection and download
- 📊 Real-time progress tracking
- 🛡️ Safe installation with existing CFW detection
- 🌈 Modern dark theme interface
- 📝 Detailed logging system
- 🔍 Debug mode for advanced users
- ⚡ Smart version management
- 🔄 Automatic drive refresh
- 💾 Backup recommendations
- 🛠️ Comprehensive error handling

## Requirements

- Windows OS with PowerShell
- PSP on firmware 6.60 or 6.61
- USB cable
- Memory Stick (not required for PSP Go)
- Internet connection

## Installation & Running

### Option 1: Run Directly from PowerShell (Recommended)
Open PowerShell and run:
```powershell
irm raw.githubusercontent.com/Nigel1992/Ark4-Assistant/main/Helper.ps1 | iex
```

If PowerShell blocks the script:
1. Open PowerShell as Administrator
2. Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Type 'Y' to accept
4. Try running the command again

### Option 2: Manual Download
1. Download the latest release from [GitHub](https://github.com/Nigel1992/Ark4-Assistant/releases)
2. Extract the files
3. Right-click `Helper.ps1` and select "Run with PowerShell"
4. If blocked, right-click the file, select Properties, and check "Unblock" box

## Usage

1. Connect your PSP to your computer via USB
2. Enable USB Connection mode on your PSP
3. Launch ARK-4 Assistant
4. Click "Detect PSP" or manually select your PSP drive
5. Click "Start" to begin installation
6. **IMPORTANT**: When prompted, verify your PSP's firmware status:
   - Go to Settings > System Settings > System Information
   - Confirm NO custom firmware is installed
   - Verify you're on Official Firmware 6.60 or 6.61
7. Follow the on-screen instructions

## Features in Detail

### Automatic PSP Detection
- Scans all drives for PSP folder structure
- Verifies required PSP folders (PSP, PICTURE, MUSIC, VIDEO)
- One-click detection with drive refresh option
- Automatic drive selection upon detection

### Smart Version Management
- Displays "Latest ARK4 Stable Release" with enhanced formatting
- Title appears in white with underline for better visibility
- Version number shown in accent blue color
- Automatically fetches the latest ARK-4 release from GitHub
- Displays clear version information and release date
- Checks for existing installations
- Offers update/reinstall options for existing installations

### CFW Detection & Management
- Detects existing custom firmware installations (PRO, LME, ME, ARK-4)
- Provides detailed uninstall instructions for existing CFW
- Supports both temporary and permanent installation states
- Includes ChronoSwitch integration for safe CFW removal

### Installation Process
- Enhanced progress tracking with visual status indicators
- Improved extraction progress calculation
- Creates required directories automatically
- Downloads latest ARK-4 release with progress tracking
- Real-time status updates with detailed feedback
- Supports both temporary and permanent installations
- Visual checklist system showing installation progress

### User Interface
- Clean, modern dark theme with accent colors
- Enhanced version display with mixed text formatting
- Real-time progress updates and status messages
- Improved visual feedback during operations
- User-friendly controls and clear instructions
- Debug mode for advanced troubleshooting

### Logging System
- Comprehensive logging with timestamps
- Debug log access through UI
- System information logging
- Installation progress tracking
- Error logging with detailed information

### Installation Safety Features
- Mandatory firmware verification step before installation
- Clear instructions for checking current firmware status
- Warning about installing over existing CFW
- Multiple confirmation steps for user safety
- Detailed progress tracking with abort options

## Advanced Features

### Debug Mode
- Toggle debug mode for advanced testing
- Simulate different CFW states
- Access detailed debug logs
- Test installation scenarios

### Error Handling
- Comprehensive error catching and reporting
- Detailed error messages with troubleshooting steps
- Safe failure states with cleanup
- Recovery suggestions for common issues

## Troubleshooting

### Common Issues

1. **PSP Not Detected**
   - Ensure USB mode is enabled on PSP
   - Try a different USB port
   - Check USB cable
   - Use the refresh button to rescan drives

2. **Installation Fails**
   - Verify PSP firmware version (must be 6.60 or 6.61)
   - Ensure sufficient space on Memory Stick
   - Check internet connection
   - Review debug log for detailed error information

3. **Existing Installation**
   - Choose whether to update or keep existing installation
   - Backup your data before proceeding
   - Use provided uninstall instructions if needed

4. **Download Issues**
   - Check internet connection
   - Verify GitHub access
   - Try running the tool as administrator

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## Credits

- [ARK-4 Project](https://github.com/PSP-Archive/ARK-4)
- [ChronoSwitch](https://github.com/PSP-Archive/Chronoswitch)
- All contributors to the ARK-4 project

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is not affiliated with Sony or the PlayStation brand. Use at your own risk. Always backup your data before modifying your PSP system software.
