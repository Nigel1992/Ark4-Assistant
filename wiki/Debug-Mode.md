# Debug Mode

ARK4 Helper includes a debug mode that provides additional information and tools for troubleshooting. This page explains how to use debug mode effectively.

## Enabling Debug Mode

To enable debug mode in ARK4 Helper:

1. Launch ARK4 Helper
2. Check the "Debug Mode" checkbox in the bottom-right corner of the application
3. The debug CFW combo box will appear next to the checkbox

When debug mode is enabled:
- More detailed information is logged
- Simulated CFW detection can be used for testing
- Additional diagnostic information is displayed

## Debug CFW Selection

The debug CFW combo box allows you to simulate different CFW detection scenarios:

- **PRO**: Simulates a PSP with PRO CFW installed
- **LME**: Simulates a PSP with LME CFW installed
- **ME**: Simulates a PSP with ME CFW installed
- **ARK-4**: Simulates a PSP with ARK-4 already installed
- **Unknown**: Simulates a PSP with no CFW detected

This feature is useful for:
- Testing how the application responds to different CFW scenarios
- Developing and testing new features
- Reproducing issues reported by users

## Debug Log

The debug log contains detailed information about the application's operations. To access the debug log:

1. Click the "Debug Log" button in ARK4 Helper
2. The log file will open in Notepad

The debug log includes:
- System information
- PSP detection attempts
- Drive scanning results
- Download progress
- Extraction details
- File copy operations
- Error messages and stack traces

### Log File Location

The debug log is stored at:
```
%TEMP%\ARK4_Assistant_Debug.log
```

You can access this location by:
1. Press `Win+R` to open the Run dialog
2. Type `%TEMP%` and press Enter
3. Look for the file named `ARK4_Assistant_Debug.log`

## Using Debug Mode for Troubleshooting

Debug mode is particularly useful for troubleshooting these issues:

### PSP Detection Problems
- Enable debug mode to see detailed information about drive scanning
- The log will show which drives were checked and why they were accepted or rejected

### Installation Failures
- Debug logs provide detailed error messages during download, extraction, and file copy
- Stack traces help identify the exact point of failure

### CFW Detection Issues
- Use the debug CFW selector to test different scenarios
- The log will show the detection logic and decision process

## Reporting Issues with Debug Logs

When reporting issues on GitHub:

1. Enable debug mode
2. Reproduce the issue
3. Save the debug log
4. Attach the log file to your issue report

This provides valuable information that helps developers diagnose and fix the problem more quickly.

## Advanced Debug Features

### Command Line Arguments

ARK4 Helper supports several command line arguments for debugging:

- `/debug` - Starts the application in debug mode
- `/log=<path>` - Specifies a custom log file path
- `/simulate=<cfw>` - Simulates a specific CFW detection

Example:
```
ARK4_Helper.exe /debug /simulate=PRO
```

### Debug API

For developers contributing to ARK4 Helper, the application exposes several debug APIs:

- `Add-LogEntry` - Adds an entry to the debug log
- `Update-ChecklistItem` - Updates the status of a checklist item
- `Get-PSPCFWInfo` - Gets information about detected CFW

These APIs can be used in PowerShell scripts to extend the functionality of ARK4 Helper. 