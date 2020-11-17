boo() {
  MsgBox "boofksdjfsdkjf"
}

#include ..\..\KeyboardSpecificAutoHotkey\KeyboardSpecificHotkey.ahk

KEYBD_ShowDebugGui()
KEYBD_RegisterHotkey(52, 81, 0, Func("boo"))
