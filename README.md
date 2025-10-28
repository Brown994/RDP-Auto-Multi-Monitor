# RDP-Auto-Multi-Monitor
PowerShell script to automatically set correct monitors in a multi-monitor setup before launching an RDP session.

This script dynamically detects connected monitors, determines their coordinates and RDP IDs, and updates a `.rdp` file’s `selectedmonitors:s:` setting based on your chosen include or omit criteria.

---

I have four monitors, but when I connect to my work PC, I prefer to only use three of those monitors. I have to launch mstsc.exe /l to get my current list of monitors and manually edit the RDP file with the correct monitors to use. This started to becoming annoying because the monitor IDs would sometimes change if my PC rebooted or went to sleep, so I created this script to modify the RDP file and launch it automatically.

## 🚀 Features

- Automatically detects all connected monitors using Windows Forms.
- Filters monitors by their X position (horizontal coordinate, but feel free to modify the script to match your own filtering criteria).
- Supports either:
  - **Include mode:** only use monitors matching specified X positions.
  - **Omit mode:** exclude monitors matching specified X positions.
- Automatically modifies the `selectedmonitors:s:` entry in a specified `.rdp` file.
- Launches the updated RDP session immediately after modification.

---

## 🖥️ Example Usage

### Use monitors located at X coordinates 0 and 1920:
.\Launch_RDP.ps1 -RDPPath "C:\Users\Brown\Desktop\Brown-PC.rdp" -IncludeX 0,1920

### Exclude the monitor located at X coordinate -1920:
.\Launch_RDP.ps1 -RDPPath "C:\Users\Brown\Desktop\Brown-PC.rdp" -OmitX -1920

### Batch File
I've also included an example .bat file that you can use to launch the script silently.