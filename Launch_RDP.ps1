param (
    [Parameter(Mandatory=$true)]
    [string]$RDPPath,

    [Parameter(ParameterSetName='Include', Mandatory=$true)]
    [int[]]$IncludeX,

    [Parameter(ParameterSetName='Omit', Mandatory=$true)]
    [int[]]$OmitX
)

# Get Windows Form Type
Add-Type -AssemblyName System.Windows.Forms

# Get all monitor info and their RDP ID
$Monitors = [System.Windows.Forms.Screen]::AllScreens | ForEach-Object -Begin { $i = 0 } -Process  {

    # Try to parse the trailing digit from DeviceName for RDPID, else fallback to index
    $RDPID = $null
    if ($_.DeviceName -match '(\d+)$') {
        try {
            $RDPID = [int]$matches[1] - 1
        } catch {
            $RDPID = $i
        }
    } else {
        $RDPID = $i
    }

    # Create PS Object
    [PSCustomObject]@{
        ID     = [array]::IndexOf([System.Windows.Forms.Screen]::AllScreens, $_)
        Device = $_.DeviceName
        RDPID  = $RDPID
        Width  = $_.Bounds.Width
        Height = $_.Bounds.Height
        X      = $_.Bounds.X
        Y      = $_.Bounds.Y
        Primary = $_.Primary
    }

    # Increment i
    $i++
}

# Sort the monitors
$Monitors = $Monitors | Sort-Object RDPID

# Apply filter depending on the parameter set
switch ($PSCmdlet.ParameterSetName) {
    'Include' {
        # Keep only monitors whose X coordinate is in $IncludeX
        $Monitors = $Monitors | Where-Object { $_.X -in $IncludeX }
    }
    'Omit' {
        # Remove monitors whose X coordinate is in $OmitX
        $Monitors = $Monitors | Where-Object { $_.X -notin $OmitX }
    }
    default {
        # Do Nothing
    }
}

# If no monitors remain, stop with an error
if (-not $Monitors -or $Monitors.Count -eq 0) {
    Write-Error "No monitors selected after applying filter. Check your IncludeX/OmitX values"
    exit 1
}

# Create joined string for the RDP file
$MonitorList = $Monitors.RDPID -join ',';

# Modify RDP File
$FileLines = Get-Content $RDPPath
$FileLines = $FileLines | Where-Object { $_ -notmatch '^selectedmonitors:s:' }
$FileLines += "selectedmonitors:s:$MonitorList"
Set-Content -Path $RDPPath -Value $FileLines -Encoding Unicode

# Launch RDP File
Start-Process "mstsc.exe" $RDPPath