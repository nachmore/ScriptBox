; Due to some issue that I can't trace back to a specific device or driver
; my thunderbolt screens do not sleep, even when the screen is locked. I have
; observed two scenarios:
;   1. Something is constantly resetting the windows idle timer (A_TimeIdle and
;      direct calls to GetLastInputInfo return essentially 0 constantly)
;   2. Idle timer ticks but the monitor remains on
;
; This script forces sleep after a configurable period of inactivity when 
; locked. Idle time is detected using A_TimeIdle with a fall back on checking to see
; if the mouse has not moved since last checked.
;
; This doesn't work if you forget to lock your machine and whatever is
; preventing sleep also prevents lock...

; Note1: the monitor will only be turned off after %monitor_sleep_interval% minutes if input 
;        has also been idle for that long. Moving the mouse etc will reset that, 
;        even if the screen remained locked.

; Note2: To reduce timer firing, the timer only fires every 2 minutes, so worst
;        case scenario is the screen locking 2 minutes later than you defined.

; Note3: Make sure that nircmd (https://www.nirsoft.net/utils/nircmd.html) is in
;        your path (or local directory) somewhere
#Persistent

; how often the script will wake up to check for idleness
timer_interval := 2 * 60 * 1000

; ms after which the monitor should be put to sleep
monitor_sleep_interval := 5 * 60 * 1000

; ms after which the computer will be put to sleep if the mouse has not moved
computer_sleep_interval := 2 * 60 * 60 * 1000

cached_mouse_x = 0
cached_mouse_y = 0
cached_mouse_updated = 0

; check every 2 minutes
SetTimer, SleepMonitorIfLockedAndIdle, %timer_interval%
return

SleepMonitorIfLockedAndIdle:

  FileAppend, %A_TimeIdlePhysical%`n, %A_Temp%\force_idle_monitor_off.log

  Process, Exist, lockapp.exe
  lock_pid := ErrorLevel

  ; https://autohotkey.com/board/topic/54422-how-to-detect-when-the-computer-is-locked-and-run-command/
  ;if (!DllCall("User32\OpenInputDesktop","int",0*0,"int",0*0,"int",0x0001L*1)) {

  if (lock_pid > 0 and not IsProcessSuspended(lock_pid)) {

    shutoff := false

    ; https://www.autohotkey.com/docs/Variables.htm#TimeIdle
    If (A_TimeIdlePhysical >= monitor_sleep_interval) {
      shutoff := true
    } else {

      MouseGetPos, cur_mouse_x, cur_mouse_y

      if (cur_mouse_x != cached_mouse_x or cur_mouse_y != cached_mouse_y) {
        cached_mouse_x = cur_mouse_x
        cached_mouse_y = cur_mouse_y

        cached_mouse_updated := A_TickCount

      }

      FileAppend, x:%cached_mouse_x% y:%cached_mouse_y% upd:%cached_mouse_updated%`n, %A_Temp%\force_idle_monitor_off.log

      if (A_TickCount - cached_mouse_updated >= monitor_sleep_interval) {
        shutoff := true
      }

      if (A_TickCount - cached_mouse_updated >= computer_sleep_interval) {
        ; request sleep ("Suspend")
        ; https://docs.microsoft.com/en-us/windows/win32/api/powrprof/nf-powrprof-setsuspendstate
        ; https://www.autohotkey.com/docs/commands/Shutdown.htm
        DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
      }
      
    }

    if (shutoff) {
      FileAppend, Forcing Screen shutoff`n, %A_Temp%\force_idle_monitor_off.log

      ; turn off monitors
      ; https://www.autohotkey.com/docs/commands/PostMessage.htm#Examples
      SendMessage, 0x112, 0xF170, 2,, Program Manager
    }
  }

  Return

IsProcessSuspended(pid) {
    For thread in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Thread WHERE ProcessHandle = " pid)
        If (thread.ThreadWaitReason != 5)
            Return False
    Return True
}  