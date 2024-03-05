; Ctrl+H to toggle hidden files in Windows Explorer
#HotIf WinExist("ahk_exe Explorer.EXE") and WinActive("ahk_exe Explorer.EXE")
^h::
{
    ; Toggle registry entry
    HiddenVal := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
    if HiddenVal = 2
    {
        RegWrite("1", "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
    }
    else
    {
        RegWrite("2", "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
    }
    ; Refresh window
    Send "^{F5}"
}
#HotIf ; End

; Middle click paste in Windows Terminal
#HotIf WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
MButton::
{
    CoordMode("Mouse", "Client") ; mouse position relative to window
    MouseGetPos(&_, &MouseY)
    if MouseY <= 42 ; Tab pane height is 42 pixels
    {
        Send "{MButton}" ; Middle click closes tab
    }
    else ; Underneath tab pane
    {
        Send "{RButton}" ; Right click pastes clipboard
    }
}
#HotIf ; End

; Ctrl+Alt+T for Windows Terminal
^!t::
{
    LocalAppData := EnvGet("LocalAppData")
    UserProfile := EnvGet("UserProfile")
    if FileExist(LocalAppData . "\Microsoft\WindowsApps\wt.exe")
    {
        Run LocalAppData . "\Microsoft\WindowsApps\wt.exe"
    }
    else if FileExist(UserProfile . "\scoop\apps\windows-terminal\current\wt.exe")
    {
        Run UserProfile . "\scoop\apps\windows-terminal\current\wt.exe new-tab"
    }
}

; Single pressing left Windows key opens Task View,
; double pressing left Windows key opens Start Menu,
; but allow programs like AltSnap to run
;;; Sadly, this just doesn't work well.
; $LWin::
; {
;     ; Double-pressing opens the start menu:
;     if (A_PriorHotkey == "$LWin" and A_TimeSincePriorHotkey < 400)
;     {
;         SetTimer(ToggleTaskView, 0) ; disable/stop the timeout
;         ToggleStartMenu()
;         return
;     }
    
;     ; Allow programs like AltSnap to work while KeyWait is running...
;     Send "{LWin down}"

;     ; Only open task view if pressed shortly (not held down):
;     if KeyWait("LWin", "T 0.2") {
;         SetTimer(ToggleTaskView, -200) ; open Task View in 200ms, unless LWin is pressed again
;     } else {
;         KeyWait("LWin") ; If timed out, we still need to wait for the key to be released by the user.
;     }

;     ; Release key, but prevent start menu from opening, see:
;     ; https://stackoverflow.com/questions/69143107/how-to-disable-the-win-key-if-its-the-only-key-being-pressed-using-autohotkey
;     Send "{Blind}{vkE8}" 
;     Send "{LWin up}"
; }

; Make the application/menu key open the task view:
; (never really used the key before)
AppsKey::
{
    ToggleTaskView()
}

ToggleTaskView()
{
    ; Run("explorer.exe Shell:::{3080F90E-D7AD-11D9-BD98-0000947B0257}")
    Send "#{Tab}" ; LWin + Tab
}

ToggleStartMenu()
{
    Send "{LWin}" ; LWin
}

; There doesn't seem to be a better way of detecting the Task View yet:
#HotIf (WinActive("ahk_class XamlExplorerHostIslandWindow") or ; class name on Windows 11
        WinActive("ahk_class Windows.UI.Core.CoreWindow")) and ; class name on Windows 10
       (WinActive("Task View") or                              ; window text in English
        WinActive("Aktive Anwendungen"))                       ; window text in German
        ; You will have to add your language's Task View window text here... use Window Spy and open Task View to find it
        ; I'd recommend to replace the German text with the text from your language.

; Scroll up to switch to left virtual desktop if in Task View:
WheelUp::
{
    Send "^#{Left}"
    Sleep 100
}

; Scroll down to switch to left virtual desktop if in Task View:
WheelDown::
{
    Send "^#{Right}"
    Sleep 100
}
#HotIf ; end

; Implement hot corners (with cursor velocity)
CoordMode("Mouse", "Screen") ; mouse position on desktop
CursorVelocity := 0
MouseGetPos(&LastMouseX, &LastMouseY)
HOT_CORNER_CHECK_INTERVAL_MILLIS := 50 ; Time in milliseconds between checks
TOLERANCE := 5 ; Tolerance in pixels (how far away from the corner the cursor is allowed to be before triggering)
THRESHOLD_VELOCITY := 1000 ; Minimum cursor velocity in pixels per second
SetTimer(ProcessHotCorner, HOT_CORNER_CHECK_INTERVAL_MILLIS)
ProcessHotCorner()
{
    global CursorVelocity, LastMouseX, LastMouseY
    CoordMode("Mouse", "Screen") ; mouse position on desktop
    MouseGetPos(&MouseX, &MouseY)

    ; Only count velocity in direction up and left:
    if LastMouseX - MouseX >= 0 && LastMouseY - MouseY >= 0 {
        ; avg: (v₁ + v₂) / 2
        CursorVelocity := (
            CursorVelocity +
            ; c = √(a² + b²)
            Sqrt(
                Abs(MouseX - LastMouseX) ** 2 + ; a = |A_x - B_x|
                Abs(MouseY - LastMouseY) ** 2   ; b = |A_y - B_y|
            ) / (HOT_CORNER_CHECK_INTERVAL_MILLIS / 1000) ; speed = distance / time
        ) / 2
    } else {
        CursorVelocity /= 2
    }

    LastMouseX := MouseX
    LastMouseY := MouseY

    if CursorVelocity >= THRESHOLD_VELOCITY {
        for Monitor in Monitors
        {
            if Abs(MouseX - Monitor.x) <= TOLERANCE &&
               Abs(MouseY - Monitor.y) <= TOLERANCE
            {
                ToggleTaskView()
                
                ; prevent hot corner from triggering in a loop:
                CursorVelocity := 0
                Sleep HOT_CORNER_CHECK_INTERVAL_MILLIS * 2
                return
            }
        }
    }
}

; Disable dead keys
; Thanks to: https://superuser.com/a/1528879
#HotIf KeyboardLayoutName == "German"
SC029::Send "{raw}^ "   ; ^
SC00D::Send "{raw}´ "   ; ´
+SC00D::Send "{raw}`` " ; Shift+´ -> `
; To find scan codes:
; * Right-click on tray icon -> Open
; * View -> Key history and script info
#HotIf ; end

GetKeyboardLayoutName()
{
    ; Prepare buffer:
    KL_NAMELENGTH := 9 ; 8 characters + null ('\0')
    KeyboardLayoutID := ""
    VarSetStrCapacity(&KeyboardLayoutID, KL_NAMELENGTH)

    ; Call `GetKeyboardLayoutName` to get keyboard layout identifier:
    ; https://learn.microsoft.com/en-gb/windows/win32/api/winuser/nf-winuser-getkeyboardlayoutnamew
    DllCall(
        "GetKeyboardLayoutName",
        "Str", KeyboardLayoutID,
        "Int" ; returns BOOL
    )

    ; Query registry for keyboard layout:
    KeyboardLayoutName := RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\" . KeyboardLayoutID, "Layout Text")

    return KeyboardLayoutName
}

KeyboardLayoutName := GetKeyboardLayoutName()

; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nc-winuser-monitorenumproc
MONITORENUMPROC(hMonitor, hDC, pRECT, dwData)
{
    ; MONITORINFO struct; (40 Bytes)
    ; |- DWORD cbSize   ;   4 Bytes
    ; |- RECT rcMonitor ; (16 Bytes)
    ; |  |- LONG left   ;   4 Bytes
    ; |  |- LONG top    ;   4 Bytes
    ; |  |- LONG right  ;   4 Bytes
    ; |  |- LONG bottom ;   4 Bytes
    ; | RECT rcWork     ; (16 Bytes)
    ; |  |- LONG left   ;   4 Bytes
    ; |  |- LONG top    ;   4 Bytes
    ; |  |- LONG right  ;   4 Bytes
    ; |  |- LONG bottom ;   4 Bytes
    ; |- DWORD dwFlags  ;   4 Bytes
    
    ; Create a buffer and set cbSize to 40 Bytes:
    NumPut("UInt", 40, lpmi := Buffer(40, 0))

    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmonitorinfow
    DllCall(
        "GetMonitorInfo",
        "Ptr", hMonitor,
        "Ptr", lpmi,
        "Int" ; returns BOOL
    )

    ; RECT rcMonitor:
    rcMonitor_left   := NumGet(lpmi,  4, "Int")
    rcMonitor_top    := NumGet(lpmi,  8, "Int")
    rcMonitor_right  := NumGet(lpmi, 12, "Int")
    rcMonitor_bottom := NumGet(lpmi, 16, "Int")

    ; RECT rcWork (we don't need it):
    ; rcWork_left   := NumGet(lpmi, 20, "Int")
    ; rcWork_top    := NumGet(lpmi, 24, "Int")
    ; rcWork_right  := NumGet(lpmi, 28, "Int")
    ; rcWork_bottom := NumGet(lpmi, 32, "Int")

    ; Get the monitor's width and height by getting the difference in coordinates:
    width := rcMonitor_right - rcMonitor_left
    height := rcMonitor_bottom - rcMonitor_top

    Monitors := ObjFromPtrAddRef(dwData) ; Dereference object pointer (*dwData)
    Monitors.Push({
        width: width,
        height: height,
        x: rcMonitor_left,
        y: rcMonitor_top
    })

    return true
}

GetMonitors()
{
    Monitors := Array()
    MONITORENUMPROC_Address := CallbackCreate(MONITORENUMPROC) ; Pointer to our callback function (MONITORENUMPROC* address)
    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enumdisplaymonitors
    DllCall(
        "EnumDisplayMonitors",
        "Ptr", 0,
        "Ptr", 0,
        "Ptr", MONITORENUMPROC_Address,
        "Ptr", ObjPtr(Monitors),
        "Int" ; returns BOOL
    )
    CallbackFree(MONITORENUMPROC_Address)
    return Monitors
}

Monitors := GetMonitors()