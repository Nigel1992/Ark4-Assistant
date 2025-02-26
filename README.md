# ARK-4 Assistant

<p align="center">
  <img src="screenshots/main.png" alt="ARK-4 Assistant Interface" width="600"/>
</p>

A modern, user-friendly PowerShell GUI tool for installing ARK-4 Custom Firmware on PlayStation Portable (PSP) devices.

## Features

- 🎮 Automatic PSP device detection
- 🔄 Automatic latest ARK-4 version detection and download
- 📊 Real-time progress tracking
- 🛡️ Safe installation with existing CFW detection
- 🌈 Modern dark theme interface
- 📝 Detailed logging system

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
irm raw.githubusercontent.com/M4cs/PSP-ARK4-Assistant/main/Helper.ps1 | iex
```

If PowerShell blocks the script:
1. Open PowerShell as Administrator
2. Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Type 'Y' to accept
4. Try running the command again

### Option 2: Manual Download
1. Download the latest release
2. Extract the files
3. Right-click `Helper.ps1` and select "Run with PowerShell"
4. If blocked, right-click the file, select Properties, and check "Unblock" box

## Usage

1. Connect your PSP to your computer via USB
2. Enable USB Connection mode on your PSP
3. Launch ARK-4 Assistant
4. Click "Detect PSP" or manually select your PSP drive
5. Click "Start" to begin installation
6. Follow the on-screen instructions

## Features in Detail

### Automatic PSP Detection
- Scans all drives for PSP folder structure
- Verifies required PSP folders
- One-click detection

### Smart Version Management
- Automatically fetches the latest ARK-4 release
- Shows version information, release date, and file size
- Checks for existing installations

### Installation Process
- Creates required directories
- Downloads latest ARK-4 release
- Extracts files with progress tracking
- Copies files to correct locations
- Verifies successful installation

### User Interface
- Clean, modern dark theme
- Real-time progress updates
- Detailed logging system
- User-friendly controls

## Troubleshooting

### Common Issues

1. **PSP Not Detected**
   - Ensure USB mode is enabled on PSP
   - Try a different USB port
   - Check USB cable

2. **Installation Fails**
   - Verify PSP firmware version (must be 6.60 or 6.61)
   - Ensure sufficient space on Memory Stick
   - Check internet connection

3. **Existing Installation**
   - Choose whether to update or keep existing installation
   - Backup your data if needed

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

- [ARK-4 Project](https://github.com/PSP-Archive/ARK-4)
- All contributors to the ARK-4 project

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is not affiliated with Sony or the PlayStation brand. Use at your own risk.
