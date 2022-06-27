#SingleInstance, force
#NoEnv
#MaxThreadsPerHotkey, 2
SetBatchLines, -1
SetMouseDelay, -1
SetCapsLockState, Off
CoordMode, Pixel, Window
CoordMode, Mouse, Window
url:="bruh" ; use the url from Discord webhook bot
userid:="<@userid>" ; Copy user ID from discord
webhook = false
stam = true ; for stamina detection
s = false ; use true if you too tall and using bench press 
protein = false ; use true for enable auto eat protein make protein at slot 1 to make this work
autolog = 999 ;run for the number you selected and leave
temp = 0
okkk = 0
count = 0
ruined = False
combattag = false
combattaga=
(
	{
		"username": "i love vivace's macro",
		"content": "%userid% Combat tag detected!",
		"embeds": null
	}
)
lowhunder = false
lowhundera=
(
	{
		"username": "i love vivace's macro",
		"content": "%userid% your hunger was too low!",
		"embeds": null
	}
)
pushed = false
pusheda=
(
	{
		"username": "i love vivace's macro",
		"content": "%userid% you were pushed too far away from weight!",
		"embeds": null
	}
)
cantrun = false
cantruna=
(
	{
		"username": "i love vivace's macro",
		"content": "%userid% unable to continue the weight macro!",
		"embeds": null
	}
)
autoleave=
(
	{
		"username": "i love vivace's macro",
		"content": "auto leave in 3 minutes",
		"embeds": null
	}
)

IfNotExist, %A_ScriptDir%\bin
{
	msgbox,, file missing,Look like you didn't extract file,3
	ExitApp 
}

if webhook = true
{
	if url = bruh
	{
		MsgBox, 0, Something Went Wrong, Your webhook was invalid, 3
		ExitApp
	}
	if userid = <@userid>
	{
		MsgBox, 0, Something Went Wrong, You have to put your userid after enable Webhook, 3
		ExitApp
	}
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("POST", url, false)
	WebRequest.SetRequestHeader("Content-Type", "application/json")
}

if WinExist("Roblox") {
	WinActivate
    CenterWindow("ahk_exe RobloxPlayerBeta.exe")
} else {
	tooltip, Roblox not found
	settimer, removetooltip, -3000
	Sleep 3000
	ExitApp
}
CenterWindow(WinTitle) {	
	WinGetPos,,, Width, Height, %WinTitle%
	WinMove, %WinTitle%,,,, 800, 599
}
removetooltip() {
    tooltip
}
$end::ExitApp ; for stop macro


f1::
macro_on := !macro_on
if (macro_on)
{
	Loop, ; Loop Searching for full stamina
	{
        PixelSearch , x, y, 249, 129, 250, 130, 0x3A3A3A, 40, Fast
		If ErrorLevel = 1
		{
            if protein = true
            {	
				if count = 3
				{
					count = 0
				}		
				if count = 0
				{
					Sleep 100
					ImageSearch, x, y, 380 , 450 , 430 , 465, *10 %A_ScriptDir%\bin\leave2.png
					If ErrorLevel = 0
					{
						Click, 400, 455
					}
					Sleep 100
					Send 1
					Sleep 50
					Send {Click 10}
					Sleep 8000
					Send {BackSpace}
					StartTime7 := A_TickCount
					Loop,
					{				
						Click, 400, 390
						Sleep 16
					} Until A_TickCount - StartTime7 > 2000
					temp++
					if temp = 5
					{				
						protein = false
					}		
				}
				count++
            }
            if s = true
            {
                send {s Up}{s Down}
            }
            MouseMove, 400, 541, 0
            MouseMove, 400, 540, 0
            Sleep 1200
            Loop, 7
            {
	    		Sleep 100
                ImageSearch, x, y, 370, 210, 430, 410, *20 %A_ScriptDir%\bin\w%A_Index%.png
                If ErrorLevel = 0
                {
                    MouseMove, x+1, y, 0
                    MouseMove, x, y, 0
					Click
		    		MouseMove, x-1, y, 0
                    Click, 5
                    Sleep 1200
					Loop, 20
					{
						Click , 410, 355
						Click , 410, 351
					}
					Sleep 100
					MouseMove, 400, 541, 0
                    MouseMove, 400, 540, 0
					Sleep 100
                    Break
                }
                if A_Index = 7
                {
					if webhook = true
					{
						pushed = true
                    	ruined = true
					}
                    else
					{
						MsgBox, Not detect level stopped the macro
						ExitApp
					}
                    Break
                }
            }
            if ruined = false
            {
                StartTime := A_TickCount
                Loop,
                {
                    aa := A_TickCount - StartTime
                    StartTime22 := A_TickCount
                    ImageSearch, x , y , 250 , 220 , 560 , 440, *25 %A_ScriptDir%\bin\yellow.png
                    if Errorlevel = 0
                    {
                        ;ElapsedTime := A_TickCount - StartTime22
                        MouseMove, x+5, y+5, 0
                        MouseMove, x+5, y+6, 0
                        Click, 5
                        Sleep 70
                        MouseMove, 400, 541, 0
                        MouseMove, 400, 540, 0
                        Sleep 20
                        ;tooltip, %ElapsedTime% ms
                        ;settimer, removetooltip, -300
                    }
                    If Stam = true
                    {
                        PixelSearch, x, y, 40, 132, 65, 134, 0x3A3A3A, 40, Fast
                        If ErrorLevel = 0
                        {
                            StartTime3 := A_TickCount
                            Loop,
                            {
                                Click, 400, 390
                                Click, 400, 391
                            } Until A_TickCount - StartTime3 > 5000
                        }
                    }
                    If ( aa > 58000 )
                    {
                        Click, 400, 390
                        Click, 400, 391
                    }
                } Until A_TickCount - StartTime > 70000

            }
            okkk++
            if okkk = autolog
            {
                ruined = true
                cantrun = true
            }

        }
        PixelSearch, x, y, 40, 144, 50, 146, 0x3A3A3A, 40, Fast ; too low hunger
		If ErrorLevel = 0
		{
			if webhook = true
			{
				lowhunder = true
				ruined = true
			}
			else
			{
				MsgBox,, Low hunger detected,3
				send !{f4}
				ExitApp
			}
		}
		Pixelsearch, x, y, 80, 95, 81, 96, 0x37378A, 10, Fast ; Combat Tag 
		if ErrorLevel = 0
		{
			combattag = true
			ruined = true
		}
		if ruined = true
		{
			if webhook = true
			{
				if foodranout = true
				{
					WebRequest.Send(foodranouta)
				}
				if combattag = true
				{
					WebRequest.Send(combattaga) 
				}
				if lowhunder = true
				{
					WebRequest.Send(lowhundera)
				}
				if pushed = true
				{
					WebRequest.Send(pusheda)
				}
				if cantrun = true
				{
					WebRequest.Send(cantruna)
				}
				WebRequest.Send(autoleave)
				Sleep 120000
				Send !{f4}
				;shutdown 
				Sleep 200
				ExitApp
			}
			else
			{
				Sleep 120000
				Send !{f4}
				;shutdown 
				Sleep 200
				ExitApp
			}
		}
    }
}
else
{
    ExitApp
}
Return
