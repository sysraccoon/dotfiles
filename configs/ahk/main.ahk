#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%/global/ctrl_as_esc.ahk
#Include %A_ScriptDir%/global/layout_switch.ahk
#Include %A_ScriptDir%/global/swap_lalt_lwin.ahk

^F1::Reload
