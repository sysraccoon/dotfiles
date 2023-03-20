#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#If WinActive("ahk_exe firefox.exe")

Numpad5 & Numpad6::SendInput {Right 9}

#If