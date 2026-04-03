[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Nigel1992)

# ARK-4 Assistant 🎮

<div align="center">

[![GitHub Release](https://img.shields.io/github/v/release/Nigel1992/Ark4-Assistant?style=flat&labelColor=121212&color=4CAF50&logo=github&logoColor=white)](https://github.com/Nigel1992/Ark4-Assistant/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat&labelColor=121212&color=4CAF50)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-%3E%3D5.1-blue?style=flat&labelColor=121212&color=4CAF50&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&labelColor=121212&color=4CAF50)](http://makeapullrequest.com)

<img src="https://github.com/user-attachments/assets/647ebc6b-0bb6-4908-b398-7933f8eff254" alt="ARK-4 Assistant Screenshot" width="800"/>

*A modern, user-friendly WPF-based GUI tool for installing ARK-4 Custom Firmware on PlayStation Portable (PSP) devices.*

[Features](#features) • [Requirements](#requirements) • [Installation](#installation--running) • [Usage](#usage) • [Contributing](#contributing) • [License](#license)

</div>

## ✨ Latest Updates

### 🎨 Major UI Framework Update
- 🔄 Migrated from Windows Forms to WPF for improved performance and modern UI
- 📱 Implemented XAML-based interface with responsive grid layout
- 🎯 Enhanced visual design with modern controls and animations
- 🔗 Added GitHub source code link in footer

### 🎭 Visual Improvements
- 🌙 Redesigned dark theme with accent colors
- 🔲 Modern button styles with hover effects
- 📊 Enhanced progress bar visualization
- 🎮 Integrated PSP icon in header area
- 📝 Improved footer layout with source code link

### ⚡ Installation Process Enhancements
- 📈 Added detailed progress tracking with status indicators
- 🔄 Improved extraction progress calculation accuracy
- ✅ Enhanced checklist system with visual status markers:
  ```
  [ .. ] In Progress
  [ ✓ ] Completed
  [ ✗ ] Error
  [ - ] Skipped
  ```
- 📢 Added real-time feedback during file operations

### 🛠️ Debug Mode Improvements
- 🔧 Streamlined debug mode interface
- 📊 Enhanced status message handling
- 🎨 Consistent text styling across all modes
- 📌 Improved version display formatting in debug mode

## 🚀 Features

<div align="center">

| Core Features | Advanced Features |
|--------------|------------------|
| 🎮 Automatic PSP Detection | 🛡️ Safe Installation |
| 🔄 Latest ARK-4 Auto-Update | 📝 Detailed Logging |
| 📊 Real-time Progress | 🔍 Debug Mode |
| 🌈 Modern Dark Theme | ⚡ Smart Version Management |
| 🔄 Auto Drive Refresh | 💾 Backup Support |

</div>

## 📋 Requirements

- 💻 Windows OS with PowerShell
- 🎮 PSP on firmware 6.60 or 6.61
- 🔌 USB cable
- 💾 Memory Stick (not required for PSP Go)
- 🌐 Internet connection

## 📥 Installation & Running

### 🚀 Option 1: Run Directly (Recommended)

```powershell
irm raw.githubusercontent.com/Nigel1992/Ark4-Assistant/main/Helper.ps1 | iex
```

<details>
<summary>📌 If PowerShell blocks the script</summary>

1. Open PowerShell as Administrator
2. Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Type 'Y' to accept
4. Try running the command again
</details>

### 📦 Option 2: Manual Download

1. Download the latest release from [GitHub](https://github.com/Nigel1992/Ark4-Assistant/releases)
2. Extract the files
3. Right-click `Helper.ps1` and select "Run with PowerShell"
4. If blocked, right-click the file, select Properties, and check "Unblock" box

## 📖 Usage

1. Connect your PSP via USB
2. Enable USB Connection mode
3. Launch ARK-4 Assistant
4. Click "Detect PSP" or select drive
5. Click "Start" to begin
6. **⚠️ IMPORTANT**: Verify firmware:
   - Settings > System Settings > System Information
   - Confirm NO custom firmware
   - Verify Official Firmware 6.60/6.61
7. Follow on-screen instructions

## 🔧 Advanced Features

<details>
<summary>🔍 Debug Mode</summary>

- Toggle debug mode for testing
- Simulate different CFW states
- Access detailed logs
- Test installation scenarios
</details>

<details>
<summary>⚠️ Error Handling</summary>

- Comprehensive error catching
- Detailed error messages
- Safe failure states
- Recovery suggestions
</details>

## ❗ Troubleshooting

<details>
<summary>PSP Not Detected</summary>

- Enable USB mode on PSP
- Try different USB port
- Check USB cable
- Use refresh button
</details>

<details>
<summary>Installation Fails</summary>

- Verify firmware (6.60/6.61)
- Check Memory Stick space
- Verify internet connection
- Review debug log
</details>

## 📝 TODO List

### High Priority
- [ ] Automatic firmware detection
- [ ] Backup creation system
- [ ] ChronoSwitch integration
- [ ] Enhanced error recovery
- [ ] Installation verification

### UI/UX
- [ ] Dark/light theme toggle
- [ ] Localization support
- [ ] Installation wizard
- [ ] Enhanced progress visuals
- [ ] Feature tooltips

[View full TODO list](TODO.md)

## 🤝 Contributing

Contributions welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

## 👥 Credits

- [ARK-4 Project](https://github.com/PSP-Archive/ARK-4)
- [ChronoSwitch](https://github.com/PSP-Archive/Chronoswitch)
- All ARK-4 contributors

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool is not affiliated with Sony or PlayStation. Use at your own risk. Always backup your data before modifying system software.

---

<div align="center">

Made with ❤️ by [Nigel1992](https://github.com/Nigel1992)

</div>

## Support This Project

Support this project! All donations go towards your chosen charity. You can pick any charity you'd like, and I will ensure the funds are sent their way. Please note that standard payment processing fees (Ko-fi & PayPal) will be deducted from the total. As a thank you, your name will be listed as a supporter/donor in this project. Feel free to email me at thedjskywalker@gmail.com for proof of the donation or to let me know which charity you've selected!
