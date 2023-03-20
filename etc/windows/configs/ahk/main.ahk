#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; notify about launch/reload main script
TrayTip AHK dotfiles, Launched/Reloaded

; automatically add to autostart
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\dotfiles_ahk.lnk

; restart script
^F1::Reload

; global modules
#Include %A_ScriptDir%/global/ctrl_as_esc.ahk
#Include %A_ScriptDir%/global/layout_switch.ahk
#Include %A_ScriptDir%/global/numpad.ahk
#Include %A_ScriptDir%/global/swap_lalt_lwin.ahk

; firefox specific modules
#Include %A_ScriptDir%/firefox/numpad.ahk

; after effects specific modules
#Include %A_ScriptDir%/after_effects/numpad.ahk

; kdenlive specific modules
#Include %A_ScriptDir%/kdenlive/numpad.ahk
