param (
    [Parameter(Mandatory=$true)][string]$FolderPath
)

$WshShell = New-Object -comObject WScript.Shell
function create-shortcut([string]$LnkPath, [string]$TargetPath, [string]$Arguments="") {
    $Shortcut = $WshShell.CreateShortcut($LnkPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Arguments = $Arguments
    $Shortcut.Save()
}

# Resolve relative path:
$FolderPath = (Resolve-Path -Path $FolderPath)

# Create directory:
New-Item -Path $FolderPath -ItemType Directory -Force

# Create special folder (aka. "GodMode"):
New-Item -Path "$FolderPath\Alle Aufgaben.{ED7BA470-8E54-465E-825C-99712043E01C}" -ItemType Directory -Force

# Create shortcuts
create-shortcut "$FolderPath\Persönlicher Ordner.lnk" "$Home"
create-shortcut "$FolderPath\Dieser PC.lnk" "C:\Windows\explorer.exe" "Shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
create-shortcut "$FolderPath\Papierkorb.lnk" "C:\Windows\explorer.exe" "Shell:::{645FF040-5081-101B-9F08-00AA002F954E}"
create-shortcut "$FolderPath\Autostart (Alle Nutzer).lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
create-shortcut "$FolderPath\Autostart (Angemeldeter Nutzer).lnk" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
create-shortcut "$FolderPath\Benutzerkonten.lnk" "C:\Windows\System32\Netplwiz.exe"
create-shortcut "$FolderPath\Systemsteuerung.lnk" "C:\Windows\System32\control.exe"
create-shortcut "$FolderPath\Geräte und Drucker.lnk" "C:\Windows\explorer.exe" "Shell:::{A8A91A66-3A7D-4424-8D24-04E180695C7A}"
create-shortcut "$FolderPath\Lokale Benutzer und Gruppen.lnk" "C:\Windows\System32\lusrmgr.msc"
create-shortcut "$FolderPath\Lokale Gruppenrichtlinien.lnk" "C:\Windows\System32\gpedit.msc"
create-shortcut "$FolderPath\Maus.lnk" "C:\Windows\System32\main.cpl"
create-shortcut "$FolderPath\Programme (Alle Nutzer).lnk" "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
create-shortcut "$FolderPath\Programme (Angemeldeter Nutzer).lnk" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
create-shortcut "$FolderPath\Sound.lnk" "C:\Windows\System32\mmsys.cpl"
create-shortcut "$FolderPath\Systemsteuerung.lnk" "C:\Windows\System32\control.exe"
create-shortcut "$FolderPath\Textdienste und Eingabesprachen.lnk" "C:\Windows\System32\rundll32.exe" "Shell32.dll,Control_RunDLL input.dll,,{C07337D3-DB2C-4D0B-9A93-B722A6C106E2}"
create-shortcut "$FolderPath\Themes.lnk" "C:\Windows\Resources\Themes"
create-shortcut "$FolderPath\Umgebungsvariablen.lnk" "C:\Windows\System32\rundll32.exe" "sysdm.cpl,EditEnvironmentVariables"
create-shortcut "$FolderPath\Leistungsoptionen.lnk" "C:\Windows\System32\SystemPropertiesPerformance.exe"
create-shortcut "$FolderPath\Energieeinstellungen.lnk" "C:\Windows\explorer.exe" "Shell:::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}" # Power Options
create-shortcut "$FolderPath\Desktopsymboleinstellungen.lnk" "C:\Windows\System32\control.exe" "desk.cpl,,0"
create-shortcut "$FolderPath\Programme und Features.lnk" "C:\Windows\System32\appwiz.cpl" # Programs and Features
create-shortcut "$FolderPath\Internetoptionen.lnk" "C:\Windows\System32\inetcpl.cpl" # Internet Options
create-shortcut "$FolderPath\Netzwerkverbindungen.lnk" "C:\Windows\explorer.exe" "Shell:::{7007ACC7-3202-11D1-AAD2-00805FC1270E}" # Network Connections
create-shortcut "$FolderPath\Region.lnk" "C:\Windows\explorer.exe" "Shell:::{62D8ED13-C9D0-4CE8-A914-47DD628FB1B0}" # Region
create-shortcut "$FolderPath\Datum und Uhrzeit.lnk" "C:\Windows\explorer.exe" "Shell:::{E2E7934B-DCE5-43C4-9576-7FE4F75E7480}" # Date and Time
create-shortcut "$FolderPath\Systemeigenschaften.lnk" "C:\Windows\System32\sysdm.cpl" # System Properties
create-shortcut "$FolderPath\Einrastfunktion einrichten (Sticky Keys).lnk" "C:\Windows\explorer.exe" "Shell:::{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageStickyKeysSettings" # Setup Sticky Keys
create-shortcut "$FolderPath\Geräte-Manager.lnk" "C:\Windows\System32\devmgmt.msc" # Device Manager
create-shortcut "$FolderPath\Datenträgerverwaltung.lnk" "C:\Windows\System32\diskmgmt.msc" # Disk Management
create-shortcut "$FolderPath\Windows Defender Firewall.lnk" "C:\Windows\System32\Firewall.cpl"
create-shortcut "$FolderPath\Windows Defender Firewall mit erweiterter Sicherheit.lnk" "C:\Windows\system32\WF.msc" # Windows Defender Firewall with Advanced Security
create-shortcut "$FolderPath\Windows-Features.lnk" "C:\Windows\System32\OptionalFeatures.exe" # Windows Features

# More shell CLSIDs: https://www.tenforums.com/tutorials/3123-clsid-key-guid-shortcuts-list-windows-10-a.html
