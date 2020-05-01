; When set to auto-hide the taskbar will still force itself to the forefront when there
; is a notification. This is unacceptable when presenting where you want the tasbar hidden 
; completely

SetTitleMatchMode, 2 ;2: A window's title can contain WinTitle anywhere inside it to be a match.
Gui +LastFound

auto_hide_powerpoint := true

if (auto_hide_powerpoint) {

	hWnd := WinExist()

	; https://autohotkey.com/board/topic/19672-detect-when-a-new-window-is-opened/
	DllCall( "RegisterShellHookWindow", UInt,hWnd )

	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
	OnMessage(MsgNum, "ShellMessage")

	Return

	ShellMessage(wParam,lParam) {
		If (wParam = 1) { ;  HSHELL_WINDOWCREATED := 1
			; negative timer runs only once, but off thread, which is useful
			SetTimer, HideTaskbarIfPowerPointIsActive, -1
		} else if (wParam = 2) { ; HSHELL_WINDOWDESTROYED 
			SetTimer, UnHideTaskbarIfPowerPointIsActive, -1
		}
	}
}

UnHideTaskbarIfPowerPointIsActive:

	If WinExist("PowerPoint Slide Show - ") {
		Return
	} else {
		; perf monitoring seems to indicate that this is cheap enough to just run whenever a
		; window is destroyed. Alternatively in the future could just have a state variable
		; but this is safer (for example, if the script restarts)
		UnHideTaskbars()
	}

Return

HideTaskbarIfPowerPointIsActive:

	; TODO: there is annoying edge case where if you receive a notification while the taskbar is
	; hidden the secondary taskbar (only) we be unhidden. Needs some more testing and likely a 
	; timer check (or different message)

	If WinExist("PowerPoint Slide Show - ") {
		HideTaskbars()
	}

Return

HideTaskbars() {
		WinHide ahk_class Shell_TrayWnd
		WinHide, Start ahk_class Button ; this seems to prevent the toolbar coming back when in "auto-hide"
		WinHide ahk_class Shell_SecondaryTrayWnd
}

; this isn't Show because if the taskbar is hidden with auto-hide it will remain off screen
; "hidden" but the taskbar window state will go back to visible so that it can be show when needed
UnHideTaskbars() {
		WinShow, ahk_class Shell_TrayWnd
		WinShow, Start ahk_class Button ; doesn't seem to be needed, but just in case be nice and return to the original state :)
		WinShow, ahk_class Shell_SecondaryTrayWnd
}

^#t:: 

	UnHideTaskbars()

	return

^#h:: 

	HideTaskbars()

	return