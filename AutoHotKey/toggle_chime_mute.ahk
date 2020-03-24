#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx

^!y::Chime_Toggle_Mute()


Chime_Toggle_Mute() {

  chime_id := Chime_Get_Meeting_Window()

  if (chime_id > 0) {
    ; remember the currently active window
    WinGet, active_id, ID, A 

    ; jump to Chime
    WinActivate, ahk_id %chime_id%
    sleep 100

    ; Ctrl+Y == Mute
    Send {Ctrl Down}y{Ctrl Up}
    sleep 50

    ; reactive the previously active window
    WinActivate ahk_id %active_id%

  }
 
}

Chime_Get_Meeting_Window() {
  ; Since meeting title can be arbitrary we need to iterate through Chime windows
  ; Unfortunately the class id keeps changing *and* there are a number of hidden windows
  ; which AHK does not realize are hidden, so:

  ; Get all chime windows
  WinGet, chime_window_list, List, ahk_exe Chime.exe ahk_class i)Chime
; iterate through the windows
  Loop, %chime_window_list%
  {
    cur_id := chime_window_list%A_Index%

    ; get visible text - the main Chime window (the one that we don't want) will 
    ; have "Chrome Legacy Window"
    WinGetText, found_text, ahk_id %cur_id%

    ; meeting windows will always have some kind of title, while the hidden extra
    ; windows will not
    WinGetTitle, cur_title, ahk_id %cur_id%

    ; if the window has no found text (== not the main window) and does have a title
    ; (!= hidden window, so likely == meeting window)
    ; Note: This may be the webcam strip if it is popped out, but that's fine because
    ;       Ctrl+Y works fine on that window as well
    if (found_text == "" and cur_title != "") {
      return cur_id
    }
  }

  return 0
}

