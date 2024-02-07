; Script to toggle window chrome, including removing the status bar from powerpoint
; windowed presentations (useful for sharing the window in a conf call instead of having to
; present full screen)

#SingleInstance, force

; Ctrl + Shift
^+q::

  WS_CAPTION := 0xC00000

  ; retrieve current style
  WinGet, win_style, Style, A

  ; flip title bar
  flipped_style := (win_style ^ WS_CAPTION)

  ; are we about to reshow the chrome?
  reshow := (flipped_style & WS_CAPTION) == WS_CAPTION

  WinSet, Style, %flipped_style% , A

  ; Note: When not presenting this will actually hide the ribbon of Powerpoint
  ;       we could work around this by using ControlGet - instead, work around it
  ;       by only calling this when presenting :)
    if reshow = 1
  {
    Control, Show,, NetUIHWND1, A
  }
  else
  {
    Control, Hide,, NetUIHWND1, A
  }

return

; https://community.sdl.com/product-groups/translationproductivity/f/autohotkey/14973/moving-any-window-with-alt-mouse
; Ctrl + Shift + Alt
^+!LButton::
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState = 0  ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U  ; Button has been released, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, off
        return
    }
    
    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
    {
        SetTimer, EWD_WatchMouse, off
        WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
        return
    }
    
    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse:
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
    EWD_MouseStartY := EWD_MouseY
return

