﻿#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <lyt>
#Include <utils>

~LShift::
	KeyWait, LShift

    if ( A_PriorKey = "LShift" && A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS() ) {
		Lyt.Set("en")
    }
return

~RShift::
	KeyWait, RShift

    if ( A_PriorKey = "RShift" && A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS() ) {
		Lyt.Set("ru")
	}
return
