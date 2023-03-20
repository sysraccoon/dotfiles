#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

Class Lyt {
	static SISO639LANGNAME            := 0x0059 ; ISO abbreviated language name, eg "EN"
	static LOCALE_SENGLANGUAGE        := 0x1001 ; Full language name, eg "English"
	static WM_INPUTLANGCHANGEREQUEST  := 0x0050
	static INPUTLANGCHANGE_FORWARD    := 0x0002
	static INPUTLANGCHANGE_BACKWARD   := 0x0004
	static KLIDsREG_PATH              := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\"
	; =========================================================================================================
	; PUBLIC METHOD Set()
	; Parameters:     arg (optional)   - (switch / forward / backward / 2-letter locale indicator name (EN) /
	;  / number of layout in system loaded layout list / language id e.g. HKL (0x04090409)). Default: switch
	;                 win (optional)   - (ahk format WinTitle / hWnd / "global"). Default: Active Window
	; Return value:   empty or description of error
	; =========================================================================================================
	Set(arg := "switch", win := "") {
		IfEqual win, 0, Return "Window not found"
		hWnd := (win = "")
						? WinExist("A")
						: ( win + 0
								? WinExist("ahk_id" win)
								: win = "global"
									? win
									: WinExist(win) )
		IfEqual hWnd, 0, Return "Window not found" ; WinExist() return 0

		if (arg = "forward") {
			Return this.ChangeCommon(, this.INPUTLANGCHANGE_FORWARD, hWnd)
		} else if (arg = "backward") {
			Return this.ChangeCommon(, this.INPUTLANGCHANGE_BACKWARD, hWnd)
		} else if (arg = "switch") {
			tmphWnd := (hWnd = "global") ? WinExist("A") : hWnd
			HKL := this.GetInputHKL(tmphWnd)
			HKL_Number := this.GetNum(,HKL)
			LytList := this.GetList()
			Loop % HKL_Number - 1 {
				If (LytList[A_Index].hkl & 0xFFFF  !=  HKL & 0xFFFF)
					Return this.ChangeCommon(LytList[A_Index].hkl,, hWnd)
			}
			Loop % LytList.MaxIndex() - HKL_Number
				If (LytList[A_Index + HKL_Number].hkl & 0xFFFF  !=  HKL & 0xFFFF)
					Return this.ChangeCommon(LytList[A_Index + HKL_Number].hkl,, hWnd)
		} else if (arg ~= "^-?[A-z]{2}") {
			invert := ((SubStr(arg, 1, 1) = "-") && (arg := SubStr(arg, 2, 2))) ? true : false
			For index, layout in this.GetList()
				if (InStr(layout.LocName, arg) ^ invert)
					Return this.ChangeCommon(layout.hkl,, hWnd)
			Return "HKL from this locale not found in system loaded layout list"
		} else if (arg > 0 && arg <= this.GetList().MaxIndex()) { ; HKL number in system loaded layout list
			Return this.ChangeCommon(this.GetList()[arg].hkl,, hWnd)
		} else if (arg > 0x400 || arg < 0) { ; HKL handle input
			For index, layout in this.GetList()
				if layout.hkl = arg
					Return this.ChangeCommon(arg,, hWnd)
			Return "This HKL not found in system loaded layout list"
		} else
			Return "Not valid input"
	}
	ChangeCommon(HKL := 0, INPUTLANGCHANGE := 0, hWnd := 0) {
		Return (hWnd = "global")
			? this.ChangeGlobal(HKL, INPUTLANGCHANGE)
			: this.ChangeWindow(HKL, INPUTLANGCHANGE, hWnd)
	}
	ChangeGlobal(HKL, INPUTLANGCHANGE) { ; in all windows
		If (INPUTLANGCHANGE != 0)
			Return "FORWARD and BACKWARD not support with global parametr."
		IfNotEqual A_DetectHiddenWindows, On, DetectHiddenWindows % (prevDHW := "Off") ? "On" : ""
		WinGet List, List
		Loop % List
			this.Change(HKL, INPUTLANGCHANGE, List%A_Index%)
		DetectHiddenWindows % prevDHW
	}
	ChangeWindow(HKL, INPUTLANGCHANGE, hWnd) {
		static hTaskBarHwnd := WinExist("ahk_class Shell_TrayWnd ahk_exe explorer.exe")
		(hWnd = hTaskBarHwnd)
		 ? this.ChangeTaskBar(HKL, INPUTLANGCHANGE, hTaskBarHwnd)
		 : this.Change(HKL, INPUTLANGCHANGE, hWnd)
	}
	ChangeTaskBar(HKL, INPUTLANGCHANGE, hTaskBarHwnd) {
		static hStartMenu, hLangBarInd, hDV2CH
		IfNotEqual A_DetectHiddenWindows, On, DetectHiddenWindows % (prevDHW := "Off") ? "On" : ""
		hStartMenu := hStartMenu  ? hStartMenu  : WinExist("ahk_classNativeHWNDHost ahk_exeexplorer.exe")
		hLangBarInd:= hLangBarInd ? hLangBarInd : WinExist("ahk_classCiceroUIWndFrame ahk_exeexplorer.exe")
		hDV2CH     := hDV2CH      ? hDV2CH      : WinExist("ahk_classDV2ControlHost ahk_exeexplorer.exe")

		this.Change(HKL, INPUTLANGCHANGE, hTaskBarHwnd)
		this.Change(HKL, INPUTLANGCHANGE, hStartMenu)
		If INPUTLANGCHANGE {
			Sleep 20
			HKL := this.GetInputHKL(hStartMenu), INPUTLANGCHANGE := 0
		}
		; to update Language bar indicator
		this.Change(HKL, INPUTLANGCHANGE, hLangBarInd)
		this.Change(HKL, INPUTLANGCHANGE, hDV2CH)
		DetectHiddenWindows % prevDHW
	}
	Change(HKL, INPUTLANGCHANGE, hWnd) {
		PostMessage, this.WM_INPUTLANGCHANGEREQUEST, % HKL ? "" : INPUTLANGCHANGE, % HKL ? HKL : "",
		, % "ahk_id" ((hWndOwn := DllCall("GetWindow", Ptr,hWnd, UInt,GW_OWNER:=4, Ptr)) ? hWndOwn : hWnd)
	}

	GetNum(win := "", HKL := 0) { ; layout Number in system loaded layout list
		HKL ? : HKL := this.GetInputHKL(win)
		If HKL {
			For index, layout in this.GetList()
				if (layout.hkl = HKL)
					Return index
		}
		Else If (KLID := this.KLID, this.KLID := "")
			For index, layout in this.GetList()
				if (layout.KLID = KLID)
					Return index
	}
	GetList() { ; List of system loaded layouts
		static aLayouts
		If IsObject(aLayouts)
			Return aLayouts
		Else {
			aLayouts := []
			Size := DllCall("GetKeyboardLayoutList", "UInt", 0, "Ptr", 0)
			VarSetCapacity(List, A_PtrSize*Size)
			Size := DllCall("GetKeyboardLayoutList", Int, Size, Str, List)
			Loop % Size {
				aLayouts[A_Index] := {}
				aLayouts[A_Index].hkl := NumGet(List, A_PtrSize*(A_Index - 1))
				aLayouts[A_Index].LocName := this.GetLocaleName(, aLayouts[A_Index].hkl)
				aLayouts[A_Index].LocFullName := this.GetLocaleName(, aLayouts[A_Index].hkl, true)
				aLayouts[A_Index].LayoutName := this.GetLayoutName(, aLayouts[A_Index].hkl)
				aLayouts[A_Index].KLID := this.GetKLIDfromHKL(aLayouts[A_Index].hkl)
			}
			Return aLayouts
		}
	}
	GetLocaleName(win := "", HKL := false, FullName := false) { ; e.g. "EN"
		HKL ? : HKL := this.GetInputHKL(win)
		If HKL
			LocID := HKL & 0xFFFF
		Else If (HKL = 0)  ;ConsoleWindow
			LocID := "0x" . SubStr(this.KLID, -3), this.KLID := ""
		Else
			Return

		LCType := FullName ? this.LOCALE_SENGLANGUAGE : this.SISO639LANGNAME
		Size := (DllCall("GetLocaleInfo", UInt, LocID, UInt, LCType, UInt, 0, UInt, 0) * 2)
		VarSetCapacity(localeSig, Size, 0)
		DllCall("GetLocaleInfo", UInt, LocID, UInt, LCType, Str, localeSig, UInt, Size)
		Return localeSig
	}
	GetLayoutName(win := "", HKL := false) { ; Layout name in OS display lang: "US", "United States-Dvorak"
		HKL ? : HKL := this.GetInputHKL(win)
		If HKL
			KLID := this.GetKLIDfromHKL(HKL)
		Else If (HKL = 0)  ;ConsoleWindow
			KLID := this.KLID, this.KLID := ""
		Else
			Return

		RegRead LayoutName, % this.KLIDsREG_PATH KLID, Layout Display Name
		DllCall("Shlwapi.dll\SHLoadIndirectString", Ptr,&LayoutName, Ptr,&LayoutName, UInt,outBufSize:=50, UInt,0)
		if !LayoutName
			RegRead LayoutName, % this.KLIDsREG_PATH KLID, Layout Text

		Return LayoutName
	}
	; Only for loaded in system layouts
	GetKLIDfromHKL(HKL) {
		VarSetCapacity(KLID, 8 * (A_IsUnicode ? 2 : 1))

		priorHKL := DllCall("GetKeyboardLayout", Ptr,DllCall("GetWindowThreadProcessId", Ptr,0, UInt,0, Ptr), Ptr)
		if !DllCall("ActivateKeyboardLayout", Ptr,HKL, UInt,0)
		|| !DllCall("GetKeyboardLayoutName", Ptr,&KLID)
			Return false
		DllCall("ActivateKeyboardLayout", Ptr,priorHKL, UInt,0)

		Return StrGet(&KLID)
	}
	; =========================================================================================================
	; PUBLIC METHOD GetInputHKL()
	; Parameters:     win (optional)   - ("" / hWnd / WinTitle). Default: "" — Active Window
	; Return value:   HKL of window / if handle incorrect, system default layout HKL return / 0 - if KLID found
	; =========================================================================================================
	GetInputHKL(win := "") {
		If win = 0
			Return,, ErrorLevel := "Window not found"
		hWnd := (win = "")
						? WinExist("A")
						: win + 0
							? WinExist("ahk_id" win)
							: WinExist(win)
		If hWnd = 0
			Return,, ErrorLevel := "Window " win " not found"

		WinGetClass class
		if (class == "ConsoleWindowClass") {
				WinGet consolePID, PID
				DllCall("AttachConsole", Ptr, consolePID)
				VarSetCapacity(KLID, 16)
				DllCall("GetConsoleKeyboardLayoutName", Str, KLID)
				DllCall("FreeConsole")
				this.KLID := KLID
				Return 0
		} else {
			; Dvorak on OSx64 0xfffffffff0020409 = -268303351   ->   0xf0020409 = 4026663945 Dvorak on OSx86
			HKL:=DllCall("GetKeyboardLayout", Ptr,DllCall("GetWindowThreadProcessId", Ptr,hWnd, UInt,0, Ptr), Ptr)
			Return HKL & ((1 << 8*A_PtrSize) - 1)
		}
	}
}

hex(n) {
	Return Format("{:#0x}", n)
}