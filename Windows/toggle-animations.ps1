Param(
    [Parameter(Mandatory=$True)]
    [bool]$enableAnimations = $False
)

# https://superuser.com/questions/1246790/can-i-disable-windows-10-animations-with-a-batch-file
# https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfow

# Definitions:
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    [StructLayout(LayoutKind.Sequential)] public struct ANIMATIONINFO {
        public uint cbSize;
        public bool iMinAnimate;
    }
    public class PInvoke {
        [DllImport("user32.dll")] public static extern bool SystemParametersInfoW(uint uiAction, uint uiParam, ref ANIMATIONINFO pvParam, uint fWinIni);
    }
"@
$SPI_SETANIMATION = 0x49
$SPIF_SENDWININICHANGE = 3

# Create ANIMATIONINFO struct:
$animInfo = New-Object ANIMATIONINFO
$animInfo.cbSize = 8 # struct size in bytes
$animInfo.iMinAnimate = $enableAnimations # boolean, whether to animate minimize/restore windows

# Call WinApi function:
[PInvoke]::SystemParametersInfoW($SPI_SETANIMATION, 0, [ref]$animInfo, $SPIF_SENDWININICHANGE)
