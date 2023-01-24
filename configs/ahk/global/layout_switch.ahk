#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%

#Include <lyt>

PRESS_SENSITIVE_MS() {
	return 200
}

~LShift::
	KeyWait, LShift
	if (A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS())
	{
		Lyt.Set("en", "global")
    }
return

~RShift::
	KeyWait, RShift

	if (A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS())
	{
		Lyt.Set("ru", "global")
	}
return
