#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx

#include ..\..\KeyboardSpecificAutoHotkey\KeyboardSpecificHotkey.ahk

; KEYBD_RegisterHotkey(52, 81, 0, "Chime_Toggle_Mute")

^!y::Chime_Toggle_Mute()
^!u::Chime_Show_Meeting_Window()

Chime_Toggle_Mute() {

  ; This hotkey works on the popped out video window, so search for it
  ; immediately (it's actually better when that one is returned because it's
  ; already displaying on top of everything)
  chime_id := Chime_Get_Meeting_Window(false)

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

Chime_Show_Meeting_Window() {

  chime_id := Chime_Get_Meeting_Window()

  if (chime_id > 0) {
    WinActivate ahk_id %chime_id%
  }
}

; Retrieve id of the chime meeting window
; ignore_video - true: try to avoid returning the video window
;                Note: Will still fallback to (false) if (true) doesn't find any windows
Chime_Get_Meeting_Window(ignore_video := true) {
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

      ; if the window is titled "Video" then it is most likely the popped out Video 
      ; window, so ignore it, unless requested not to
      if (!ignore_video or (ignore_video and cur_title != "Video")) {
        return cur_id
      }
    }
  }

  ; if we couldn't find a meeting window, and we were already doing a wide search (i.e.
  ; not ignoring the video window) then we couldn't find a Chime meeting, so return
  if (!ignore_video)
    return

  ; We couldn't find a meeting window, so search again this time including the Video window
  ; This accounts for the edge case where the meeting is titled "Video"
  return Chime_Get_Meeting_Window(false)
}

