#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

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
    if ( A_PriorKey = "LControl" )
    {
        Send {Esc}
    }
return
