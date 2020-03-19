; toggle the active window to always be on top

info_icon = 0x1
no_sound_notification = 0x10
tray_options := info_icon + no_sound_notification

alwaysOnTopStyle = 0x8

; https://www.autohotkey.com/docs/Hotkeys.htm
^!Space::  

WinSet AlwaysOnTop, Toggle, A

; retrieve the window style
WinGet, exStyle, ExStyle, A

If (exStyle & alwaysOnTopStyle)
  always_on_top = Always On Top: Enabled
Else
  always_on_top = Always On Top: Disabled

WinGetTitle active_title, A

TrayTip, %always_on_top%, %active_title% , 0, %tray_options%

