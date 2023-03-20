#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#If WinActive("ahk_exe AfterFX.exe")

; redo
Numpad1 & Numpad6::^+z

; trim layer "in point"
Numpad4 & Numpad8::![
; trim layer "out point"
Numpad4 & Numpad9::!]

Numpad6 & Numpad9::F9

; move layer below
Numpad7 & Numpad8::^[
; move layer upper
Numpad7 & Numpad9::^]

; selection tool
Numpad5 & Numpad6::v
; pen tool
Numpad5 & Numpad4::g
; shape tool
Numpad5 & Numpad3::q
; text tool
Numpad5 & Numpad9::^t
; anchor point tool
Numpad5 & Numpad7::y

#If