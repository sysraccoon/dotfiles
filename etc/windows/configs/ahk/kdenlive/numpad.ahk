#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#If WinActive("ahk_exe kdenlive.exe")

; redo
Numpad1 & Numpad6::^+z

; cut clip
Numpad4 & Numpad8::+r
; cut all clips
Numpad4 & Numpad9::^+r
; ungroup clips
Numpad6 & Numpad7::^+g

#If