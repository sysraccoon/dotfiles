#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <utils>

; Bind caps lock as left control
SetCapsLockState, alwaysoff
Capslock::
    Send {LControl Down}
    KeyWait, CapsLock
    Send {LControl Up}
return

; Bind single press left control as escape
LControl::
    Send {LControl Down}
    KeyWait, LControl
    Send {LControl Up}

    if ( A_PriorKey = "LControl" && A_TimeSinceThisHotkey < PRESS_SENSITIVE_MS() ) {
        Send {Esc}
    }
return
