#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; disable default numpad behaviour
Numpad1::return
Numpad2::return
Numpad3::return
Numpad4::return
Numpad5::return
Numpad6::return
Numpad7::return
Numpad8::return
Numpad9::return
NumpadMult::return
NumpadDiv::return
NumpadSub::return
NumpadAdd::return

; focus specific application from task panel
Numpad0 & Numpad1::#1
Numpad0 & Numpad2::#2
Numpad0 & Numpad3::#3
Numpad0 & Numpad4::#4
Numpad0 & Numpad5::#5
Numpad0 & Numpad6::#6
Numpad0 & Numpad7::#7
Numpad0 & Numpad8::#8
Numpad0 & Numpad9::#9

Numpad0::
NumpadIns::
    Send {Space}
return

NumpadDot::
NumpadDel::
    Send {Escape}
return

NumpadEnter::Enter

; bind all generic actions to Numpad1 & x, where x other numpad key
; undo action
Numpad1 & Numpad5::^z
; redo action
Numpad1 & Numpad6::^y
; copy action
Numpad1 & Numpad2::^c
; paste action
Numpad1 & Numpad3::^v

Numpad1 & NumpadAdd::
    ID := WinActive("A")
    WinMaximize, ahk_id %ID%
return

Numpad1 & NumpadSub::
    ID := WinActive("A")
    WinRestore, ahk_id %ID%
return