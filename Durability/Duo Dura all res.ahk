#SingleInstance, force
#NoEnv
#MaxThreadsPerHotkey, 2
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Window
;url:="bruh" ; use the url from Discord webhook bot
;userid:="<@12345678910>" ;example
; True, False
autorhythm = True
rhyleft = true
rhyright = true
flow = True
; do not change
Oneside = false ; start doing at left screen
ruined = False
rhythm = False
; - dialog -
; will be working on webhook soon
knock = false
nofood = false
lowhunder = false

IfNotExist, %A_ScriptDir%\bin
{
	msgbox,, file missing,Look like you didn't extract file,3
	ExitApp 
}

Resize1(WinTitle) {	
	WinGetPos,,, Width, Height, %WinTitle%
	WinMove, %WinTitle%,, (0)-(10), (0)-(10), 100, 100
}
Resize2(WinTitle) {	
	WinGetPos,,, Width, Height, %WinTitle%
	WinMove, %WinTitle%,, (0)-(-790), (0)-(10), 100, 100
}

removetooltip() {
    tooltip
}
Back:
Winactive("Roblox")
MsgBox, 262144,vivace Auto Dura,Select account for left side
IfMsgBox, Ok
{
    Resize1("Roblox")
}
Winactive("Roblox")
MsgBox, 262144,vivace Auto Dura,Select account for right side
IfMsgBox, Ok
{
    WinGet, 2, PID, A
    Resize2("Roblox")
}

MsgBox, 4,vivace Auto Dura,both side are set correctly?
IfMsgBox, No
{
    Goto, back
}
 ; 100, 500 buy dura
 ; 0, 0
 ; 800, 0
 ;ImageSearch, x, y, 15, 100, 115, 160, *10 %A_ScriptDir%\bin\fullhp.png

$F1::
; get stuff ready
CoordMode, Mouse, Screen
;; get pid
MouseMove, 100, 470
Send {MButton}
Sleep 200
WinGet, 1, PID, A
Sleep 100
MouseMove, 900, 470
Send {MButton}
Sleep 200
WinGet, 2, PID, A
CoordMode, Mouse, Window

colors := "0x444444, 0x3D3DA2"
WinActivate ahk_pid %1%
Sleep 100
Send {BackSpace}
Sleep 100
Loop, 10
{
    Click, 100, 470
}
Send {BackSpace}1
Sleep 100
if autorhythm = true
{
    if rhyleft = true
    {
        Send r
    }
}

WinActivate ahk_pid %2%
Sleep 100
Send {BackSpace}
Sleep 100
Loop, 10
{
    Click, 100, 470
}
Send {BackSpace}1
Sleep 100
if autorhythm = true
{
    if rhyright = true
    {
        Send r
    }
}
Loop,
{
    CoordMode, Pixel, Screen
    ImageSearch,,, 10, 100, 260, 120, *10 %A_ScriptDir%\bin\fullhp.png ; Left windows
	If ErrorLevel = 0
    {
        WinActivate ahk_pid %1%
        Sleep 100
        Send {Backspace}2
        Sleep 100
        Click, 100, 470
        duratimer := A_TickCount
        Sleep 100
        WinActivate ahk_pid %2%
        Sleep 100
        Send {BackSpace}1
        Sleep 100
        if autorhythm = true
        {
            if rhyright = true
            {
                Send r
            }
        }
        MouseMove, 100, 470
        Loop, ;fast phase
		{
		    aa := A_TickCount - duratimer
		    if (aa > 26000)
			{
				Break
			}
		    PixelSearch,,, 130, 105, 131, 106, 0x444444, 20, Fast 
			If ErrorLevel = 0
			{
                Break
			}
            PixelSearch,,, 130, 105, 131, 106, 0x3D3DA2, 20, Fast 
			If ErrorLevel = 0
			{
                Break
            }
            Click
			Sleep 100
		}
        Loop,
        {
            aa := A_TickCount - duratimer
            if (aa > 26000)
            {
                Break
            }
            PixelSearch,,, 70, 105, 71, 106, 0x444444, 20, Fast 
            If ErrorLevel = 0
            {
                Break
            }
            PixelSearch,,, 70, 105, 71, 106, 0x3D3DA2, 20, Fast 
            If ErrorLevel = 0
            {
                Break
            }
            Click
			Sleep 250
            
        }
        Loop,
        {
            aa := A_TickCount - duratimer
            if (aa > 26000)
            {
                Break
            }
            PixelSearch,,, 28, 105, 30, 106, 0x444444, 20, Fast 
            If ErrorLevel = 0
            {
                Break
            }
            PixelSearch,,, 28, 105, 30, 106, 0x3D3DA2, 20, Fast 
            If ErrorLevel = 0
            {
                Break
            }      
            Click
			Sleep 400
        }
        WinActivate ahk_pid %1%
        Sleep 100
        Send {Backspace}2
        Sleep 100
        Click, 100, 470
        Sleep 100
        Send {Backspace}
        Loop, 10
        {
            Click, 100, 470
        }
        if autorhythm = true
        {
            if rhyleft = true
            {
                Send r
            }
        }
    }
    if Oneside = false
    {
        ImageSearch,,, 810, 100, 1060, 120, *10 %A_ScriptDir%\bin\fullhp.png ; Right windows
		If ErrorLevel = 0
		{
            WinActivate ahk_pid %2%
            Sleep 100
            Send {Backspace}2
            Sleep 100
            Click, 100, 470
            duratimer := A_TickCount
            WinActivate ahk_pid %1%
            Sleep 100
            Send {BackSpace}1
            Sleep 100
            if autorhythm = true
            {
                if rhyright = true
                {
                    Send r
                }
            }
            MouseMove, 100, 470
            Loop, ;fast phase
            {
                aa := A_TickCount - duratimer
                if (aa > 26000)
                {
                    Break
                }
                PixelSearch,,, 930, 105, 931, 106, 0x444444, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }
                PixelSearch,,, 930, 105, 931, 106, 0x3D3DA2, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }
                Click
                Sleep 100
            }
            Loop,
            {
                aa := A_TickCount - duratimer
                if (aa > 26000)
                {
                    Break
                }
                PixelSearch,,, 870, 105, 871, 106, 0x444444, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }
                PixelSearch,,, 870, 105, 871, 106, 0x3D3DA2, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }
                Click
                Sleep 250
                
            }
            Loop,
            {
                aa := A_TickCount - duratimer
                if (aa > 26000)
                {
                    Break
                }
                PixelSearch,,, 828, 105, 830, 106, 0x444444, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }
                PixelSearch,,, 828, 105, 830, 106, 0x3D3DA2, 20, Fast 
                If ErrorLevel = 0
                {
                    Break
                }      
                Click
                Sleep 400
            }

        
            WinActivate ahk_pid %2%
            Sleep 100
            Send {Backspace}2
            Sleep 100
            Click, 100, 470
            Loop, 10
            {
                Click, 100, 470
            }
            Send 1
            Sleep 100
            if autorhythm = true
            {
                if rhyright = true
                {
                    Send r
                }
            }
        }
    }
    ;; eating 

    PixelSearch , x, y, 884, 133, 885, 134, 0x3A3A3A, 40, Fast ; right screen is hungry
    If ErrorLevel = 0
    {
        WinActivate ahk_pid %2%
        Sleep 100
        Send {Backspace}34567890
        WinActivate ahk_pid %2%
        Sleep 100
        CoordMode, Pixel, Window
        time := A_TickCount
        Loop,
        {
            PixelSearch, x, y, 119, 144, 110, 146, 0x3A3A3A, 40, Fast ; full hunger
			If ErrorLevel = 1
			{
				Break
			} else {
                Click, 100, 470
                Sleep 100
                ImageSearch, x, y, 60, 515, 760, 600, *20 %A_ScriptDir%\bin\equipx.png ;if not found equiped slot /and still not full hunger
                If ErrorLevel = 1
                {
                    Sendinput, 34567890
                    aw++
                }
            }
        } Until A_TickCount - time > 60000
        CoordMode, Pixel, Screen
        Send 1
        Sleep 100
        if autorhythm = true
        Send r
    }

    PixelSearch , x, y, 84, 133, 85, 134, 0x3A3A3A, 40, Fast ; left screen is hungry
    If ErrorLevel = 0
    {
        WinActivate ahk_pid %1%
        Sleep 100
        Send {Backspace}34567890
        WinActivate ahk_pid %1%
        Sleep 100
        CoordMode, Pixel, Window
        time := A_TickCount
        Loop,
        {
            PixelSearch, x, y, 119, 144, 110, 146, 0x3A3A3A, 40, Fast ; full hunger
			If ErrorLevel = 1
			{
				Break
			} else {
                Click, 100, 470
                Sleep 100
                ImageSearch, x, y, 60, 515, 760, 600, *20 %A_ScriptDir%\bin\equipx.png ;if not found equiped slot /and still not full hunger
                If ErrorLevel = 1
                {
                    Sendinput, 34567890
                    aw++
                }
            }
        } Until A_TickCount - time > 60000
        CoordMode, Pixel, Screen
        Send 1
        Sleep 100
        if autorhythm = true
        Send r
    }
}
Return
Space::ExitApp
