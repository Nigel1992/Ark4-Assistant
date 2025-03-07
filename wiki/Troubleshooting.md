# Troubleshooting

This page provides solutions to common issues you might encounter when using ARK4 Helper.

## PSP Detection Issues

### PSP Not Detected

**Symptoms:**
- "No PSP detected" message
- PSP drive not appearing in the dropdown menu

**Solutions:**
1. Ensure your PSP is turned on and in USB mode
   - Go to Settings → USB Connection on your PSP
2. Try a different USB cable
   - Some cables may be charge-only and don't support data transfer
3. Try a different USB port on your computer
   - Preferably use a direct USB port, not a hub
4. Restart your PSP and computer
5. Manually select the drive letter from the dropdown menu

### Wrong Drive Detected

**Symptoms:**
- ARK4 Helper selects the wrong drive

**Solutions:**
1. Manually select the correct drive from the dropdown menu
2. Disconnect other USB storage devices to avoid confusion
3. Use the "Refresh Drives" button to update the drive list

## Installation Issues

### Download Fails

**Symptoms:**
- "Download failed" error message
- Installation stops at the download phase

**Solutions:**
1. Check your internet connection
2. Temporarily disable firewall or antivirus software
3. Try again later (GitHub might be experiencing issues)
4. Enable debug mode and check the log for specific errors

### Extraction Fails

**Symptoms:**
- Error during the extraction phase
- "Failed to extract files" message

**Solutions:**
1. Ensure you have sufficient disk space
2. Run ARK4 Helper as administrator
3. Check the debug log for specific errors
4. Try downloading the ARK-4 files manually and place them in the temp directory

### Copy to PSP Fails

**Symptoms:**
- Error during the copying phase
- "Failed to copy files to PSP" message

**Solutions:**
1. Ensure your PSP has sufficient free space
2. Check if your PSP is write-protected
3. Verify the PSP connection is stable
4. Run ARK4 Helper as administrator
5. Check for file permission issues

## PSP-Side Issues

### ARK Loader Won't Run

**Symptoms:**
- ARK Loader crashes or won't start on the PSP

**Solutions:**
1. Verify your PSP firmware is 6.60 or 6.61
2. Reinstall ARK-4 using ARK4 Helper
3. Check if your Memory Stick is corrupted
4. Try formatting your Memory Stick (backup your data first)

### cIPL Flasher Issues

**Symptoms:**
- cIPL Flasher fails or crashes

**Solutions:**
1. Ensure your PSP battery is fully charged
2. Do not interrupt the flashing process
3. If it fails repeatedly, try using temporary ARK-4 instead of permanent installation

## Application Issues

### ARK4 Helper Crashes on Start

**Symptoms:**
- Application closes immediately after opening

**Solutions:**
1. Ensure you have the required .NET Framework installed
2. Run as administrator
3. Check the debug log in your Temp folder
4. Reinstall ARK4 Helper

### UI Elements Not Displaying Correctly

**Symptoms:**
- Missing buttons or text
- UI appears broken

**Solutions:**
1. Update your graphics drivers
2. Ensure your display scaling is set to 100%
3. Try running in compatibility mode

## Debug Log Analysis

The debug log contains valuable information for troubleshooting. To access it:

1. Click the "Debug Log" button in ARK4 Helper
2. Look for error messages or warnings
3. Common error codes and their meanings:
   - `ERROR: Failed to fetch releases` - Internet connection or GitHub API issue
   - `ERROR: Failed to download` - Download problem
   - `ERROR: Failed to extract` - Extraction problem
   - `ERROR: Failed to copy` - File copy problem

## Still Having Issues?

If you're still experiencing problems:

1. Enable debug mode in ARK4 Helper
2. Capture detailed logs
3. Create a [new issue](https://github.com/Nigel1992/ARK4-Helper/issues/new?template=bug_report.yml) with your logs attached
4. Post in the [Discussions](https://github.com/Nigel1992/ARK4-Helper/discussions) section for community help