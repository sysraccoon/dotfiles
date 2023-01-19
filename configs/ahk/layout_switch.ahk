PRESS_SENSITIVE_MS := 200
EN_DV_CODE := 0x10409
RU_CODE := 0x0419

~LShift::
	KeyWait, LShift
    if (A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS) {
        SetDefaultKeyboard(EN_DV_CODE)
    }
return

~RShift::
	KeyWait, RShift
    if (A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS) {
        SetDefaultKeyboard(RU_CODE)
    }
return

SetDefaultKeyboard(LocaleID){
	Global
	SPI_SETDEFAULTINPUTLANG := 0x005A
	SPIF_SENDWININICHANGE := 2
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(Lan%LocaleID%, 4, 0)
	NumPut(LocaleID, Lan%LocaleID%)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &Lan%LocaleID%, "UInt", SPIF_SENDWININICHANGE)
	WinGet, windows, List
	Loop %windows% {
		PostMessage 0x50, 0, %Lan%, , % "ahk_id " windows%A_Index%
	}
}
return