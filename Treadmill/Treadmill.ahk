#SingleInstance, force
#NoEnv
SetCapsLockState, Off
SetBatchLines, -1
SetMouseDelay, -1
CoordMode, Pixel, Window
CoordMode, Mouse, Window

;; Auto 
IfNotExist, %A_ScriptDir%\bin\Food
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin\Slot
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
if !FileExist("webhook.txt")
{
    FileAppend, false, Webhook.txt
}
if FileExist("webhook.txt")
{
    FileReadLine, checkweb, webhook.txt, 1
    if (checkweb = "true")
    {
        Gosub, WebhookCheck
    } else {
        FileDelete, webhook.txt
        FileAppend, false, Webhook.txt
    }
}
FileReadLine, checkhook, webhook.txt, 1
FileReadLine, url, webhook.txt, 2
FileReadLine, id, webhook.txt, 3
; New GUI

Gui, Add, Tab3 ,, Treadmill Options | Auto Log | Webhook Notification


; Treadmill Options tab
Gui, Tab, 1
Gui, Add, Text,, Stamina or Running Speed? *Required
Gui, Add, DropDownList, vTrainingChoice, Stamina|RunningSpeed
Gui, Add, Text,, Treadmill Level *Required
Gui, Add, DropDownList, vTrainingChoice1, AutoChoose|5|4|3|2|1
Gui, Add, Radio, gRecord, Auto clip?`nAutomatically Clip and check name if you are attacked

; Auto log tab
Gui, Tab, 2
Gui, Add, Checkbox, gCalculator vCall,Fatigue Calculator?`nAutomatically Calculate your fatigue to 65`%
Gui, Add, Checkbox, gAutoLogBroken,Auto Log?`nAutomatically leave game When the macro is Broken 
Gui, Add, Text,, How many times you want to do treadmill? *Only if you didn't select Fatigue Calculator
Gui, Add, Edit ,Number w100 vReptimes r1,


; Webhook Options tab
Gui, Tab, 3
FileReadLine, checkhook, webhook.txt, 1
if checkhook = false
{
    Gui, Add, Text,, Discord Webhook url 
    Gui, Add, Edit, w470 vWebhookLink r1, %url%
    Gui, Add, Text,, Discord User id, 
    Gui, Add, Edit, w470 vUserIdID r1, %id%
    Gui, add, Button, w100 h20 gSaveWebhook default, SaveWebhook
} else {
    if checkhook = true
    {
        Gui, Add, Text,, Webhook Checked
    }
}

; Show GUI

Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.
Gui, Add, Button, +default, Finished
If checkhook = true
{
    Gui, Show, w445 h200, Vivace's Macro, Treadmill Macro
}
If checkhook = false
{
    Gui, Show, w515 h200, Vivace's Macro, Treadmill Macro
}
return ;end of auto 

;; Button
GuiClose:
    ExitApp
Return
;; Tab 1
Record:
    autoclip = true
    MsgBox,4,,Please set your instant replay to F8`nIf not Macro will use f12 record
    IfMsgBox, Yes
    {
        instant = true
    } else {
        record = true
    }
Return

;; Tab 2
; Auto log lable:
AutoLogBroken:
    Autolog = true
Return
Calculator:
    Gui,Fatigue: add, Text,,How much fatigue do you have right now? ; Text 1
    Gui,Fatigue: add, edit,  w330 h20 vfatigueb r1
    Gui,Fatigue: add, Text,,What is your minimum fatigue gained per training?   ; Text 2
    Gui,Fatigue: add, edit,  w330 h20 vfatiguep r1
    Gui,Fatigue: add, Button, x220 y100 w50 h20 gACCEPT1 default, Ok
    Gui,Fatigue: add, Button, x280 y100 w50 h20 gCANCEL1, Cancel
    Gui,Fatigue: Show, w350 h130 ,Vivace's Macro
Return
ACCEPT1:
    Gui,Fatigue:Submit
    base:=fatigueb
    gain:=fatiguep
    if (base or gain) is not number
    {
        MsgBox,,Vivace's Macro,please enter only digits,3
        ExitApp
    }
    if gain = 0
    {
        MsgBox,,Vivace's Macro,Don't use 0 in this,3
        ExitApp
    }
    While cal < 65
    {
        cal:=base+gain
        base:=cal
        log++
    }
    MsgBox,,Vivace's Macro, Repeat: %log% times,4
Return
CANCEL1:
FatigueGuiClose:
    Gui,Fatigue:destroy
Return

;; Tab 3

SaveWebhook:
    Gui, Submit, NoHide
    url:=WebhookLink
    userid:=UserIdId
    FileDelete, webhook.txt
    FileAppend, true`n%url%`n%UserId%, Webhook.txt
    Goto, WebhookCheck
Return
WebhookCheck:
    FileReadLine, checkhook, webhook.txt, 1
    FileReadLine, url, webhook.txt, 2
    FileReadLine, id, webhook.txt, 3
    if checkhook = true
    {
        if (url and id != "")
        {
            Webhook = true
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("POST", url, false)
            WebRequest.SetRequestHeader("Content-Type", "application/json")
            Food=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% You are out of food!",
                    "embeds": null
                }
            )
            aFatigue=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% You have reach 65`% fatigue!",
                    "embeds": null
                }
            )
            Combat=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% You are attacked!",
                    "embeds": null
                }
            )
            Cash=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% You are out of cash!",
                    "embeds": null
                }
            )
            Level=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% You are pushed away from treadmill!",
                    "embeds": null
                }
            )
            Combatlog=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "auto log when not in combat",
                    "embeds": null
                }
            )
            Logged=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "Logged successfully",
                    "embeds": null
                }
            )
            Kicked=
            (
                {
                    "username": "i love vivace's macro",
                    "content": "%id% you got kicked from the game 😨",
                    "embeds": null
                }
            )
        } else {
            webhook = false
            FileDelete, webhook.txt
            FileAppend, false, Webhook.txt
        }
    }
Return

;; Finish
GuiEscape:
ButtonFinished:
{
    Gui, Submit, 
    TrainingChoice:=TrainingChoice
    TrainingChoice1:=TrainingChoice1
    if (log = "")
    {
        log:=Reptimes
    } else {
        if (Reptimes = )
        {
            MsgBox,,, Vivace's Macro, you have uncompleted info.
            ExitApp
        }
    }
    if (TrainingChoice = "" )
    {
        MsgBox,,, Vivace's Macro, you have uncompleted info.
        ExitApp
    }
    if (TrainingChoice1 = "" )
    {
        MsgBox,,, Vivace's Macro, you have uncompleted info.
        ExitApp
    }
    goto, StartTreadmill
}
Return

;; Macro

;; Auto eat
Hungry: ; if you find food slot
{
    Sleep 500
    slot = 0
    Loop, 10 ;slot
    {
        Send %slot%
        Sleep 10
        ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
        If ErrorLevel = 0
        {
            goto, eat
        } else {
            slot++ ;mean all slot are empty
            if slot = 10
            {
                If Checked < 2
                {
                    goto, FindFood
                } else {
                    Broken = true
                    foodranout = true
                    Goto, Check
                }
               
            }
        }
    } 
}
Return

Eat:
{
    Loop, 
    {
        PixelSearch, x, y, 119, 144, 110, 146, 0x3A3A3A, 40, Fast
        If ErrorLevel = 0
        {
            Click, 405 620
            ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
            If ErrorLevel = 1
            {
                Slot++
                Sleep 100
                Send %slot%
                If Slot = 10
                {
                    if Checked >= 2
                    {
                        Send {BackSpace}
                        Break
                    } else {
                        Goto, FindFood
                    }
                }
            }
        } else {
            Send {BackSpace}
            StartTime2 := A_TickCount
            Loop,
            {			
                Click , 409, 296
                Click , 409, 295
            } Until A_TickCount - StartTime2 > 1500
            Break
        }
    }
}
Return

FindFood:
{
    Sendinput, {VKC0}
    MouseMove, 100, 500
    xx = 1 ;; start at slot 1 ;560 95
    MouseMove, 100, 500
    Loop,
    {
        Acc1 := A_TickCount - acc
        ImageSearch,,, 90, 190, 100, 200, *10 %A_WorkingDir%/bin/Slot/corner.bmp
        If ErrorLevel = 0
        {
            Break
        }
        If (Acc1 > 5000)
        {
            Break
        }
    }
    gosub, FindSlot
}
Return

FindFood2:
{
    Food = 1
    Loop,
    {
        ImageSearch, x, y, 90, 195, 675, 500, %A_WorkingDir%/bin/food/foodall%food%.bmp
        If ErrorLevel = 0
        {
            Gosub, MoveFood
            Break
        } else {
            food++
            if food >= 23
            {
                Send {VKC0}
                Checked++
                Goto, Hungry
            }
        }
    }
}
Return

FindSlot:
{
    SlotEmpty = 0
    Loop,
    {
        ImageSearch, xx, yy, 65, 530, 750, 585, %A_WorkingDir%/bin/Slot/bar%SlotEmpty%.bmp    
        If ErrorLevel = 0
        {
            SlotEmpty++
            Gosub, FindFood2
        } else {
            SlotEmpty++
        }
        If SlotEmpty = 10
        {
            Break
        }
    }
}
Return

MoveFood:
{
    calx:=x+20
    caly:=y+5
    calxx:=xx+20
    calyy:=yy+20 ;; somehow i can make it to work
    Click %calx% %caly% Down
    Sleep 50
    Click %calxx% %calyy% Up
    Sleep 50
}
Return

AutoTreadmill:
{
    Loop,
    {
        run := A_TickCount - Treadrun
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\w.bmp
        if Errorlevel = 0
        {				
            SendInput, w ;w
        }			
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\a.bmp
        if Errorlevel = 0
        {				
            SendInput, a ;a
        }
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\s.bmp
        if Errorlevel = 0
        {				
            Sendinput, s ;s
        }			
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\d.bmp
        if Errorlevel = 0
        {				
            Sendinput, d ;d
        }
        if (run > 55000)
        {
            Click, 400, 290
            Click, 400, 291
        }
        PixelSearch ,,, 40, 130, 45, 133, 0x3A3A3A, 40, Fast
        If ErrorLevel = 0
        {				
            WaitforStamina := A_TickCount
            Loop,
            {
                run := A_TickCount - Treadrun
                if (run > 55000)
                {
                    PixelSearch ,,, 69, 130, 70, 133, 0x3A3A3A, 40, Fast
                    If ErrorLevel = 1
                    {
                        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\w.bmp
                        if Errorlevel = 0
                        {				
                            SendInput, w ;w
                        }			
                        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\a.bmp
                        if Errorlevel = 0
                        {				
                            SendInput, a ;a
                        }
                        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\s.bmp
                        if Errorlevel = 0
                        {				
                            Sendinput, s ;s
                        }			
                        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\d.bmp
                        if Errorlevel = 0
                        {				
                            Sendinput, d ;d
                        }
                    }
                    Click, 400, 290
                    Click, 400, 291
                }
            } Until A_TickCount - WaitforStamina > 9000			
        }
        Pixelsearch,,, 79, 98, 80, 99, 0x38388E, 10, Fast ; Combat Tag 
        if ErrorLevel = 0
        {
            Broken = True
            aCombat = True
            Goto, Check
        }
    } Until A_TickCount - Treadrun > 65000
}
Return

ChooseTraining:
{
    If TrainingChoice = Stamina
    {
        Loop, 10
        {
            Click , 290, 310
            Click , 290, 311
        }
    } else {
        If TrainingChoice = RunningSpeed
        {
            Loop, 10
            {
                Click , 520, 310
                Click , 520, 311
            }
        }
    }
}
Return

ChooseLevel:
{
    Sleep 200
    if TrainingChoice1 = AutoChoose
    {
        levely = 370
        levell = 5
        error = 0
        Loop,
        {
            ImageSearch,,, 390, 240, 430, 390, %A_WorkingDir%/bin/level%levell%.bmp
            If ErrorLevel = 0
            {
                MouseMove, 470 , %levely%
                MouseMove, 471 , %levely%
                Click, 10
                tooltip, choosed %levell%
                Break
            } else {
                levell--
                levely:=levely-30
                if levely <= 220
                {
                    levely = 370
                    levell = 5
                    error++
                    if error <= 50
                    {
                        Broken = true
                        alevel = true
                        goto, check
                    }
                }
            }
        }   
    }
    If TrainingChoice1 = 5
    {
        MouseMove, 470 , 370
        MouseMove, 471 , 370
        Click, 10 
    }
    If TrainingChoice1 = 4
    {
        MouseMove, 470 , 340
        MouseMove, 471 , 340
        Click, 10 
        Sleep 100
    }
    If TrainingChoice1 = 3
    {
        MouseMove, 470 , 310
        MouseMove, 471 , 310
        Click, 10 
    }
    If TrainingChoice1 = 2
    {
        MouseMove, 470 , 280
        MouseMove, 471 , 280
        Click, 10 
    }
    If TrainingChoice1 = 1
    {
        MouseMove, 470 , 250
        MouseMove, 471 , 250
        Click, 10 
    }
    Sleep 50
    MouseMove, 405, 600
}
Return

Hand:
{
    hand22 := A_TickCount
    Loop,
    {
        PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
        If ErrorLevel = 0
        {
            Loop, 20 ;Click hand
            {
                Click , 410, 355
                Click , 410, 351
            }
            Return
        } 
    } Until A_TickCount - hand22 > 3000
    Broken = True
    amoney = true
    goto, Check
}
Return

Check:
{
    ToolTip
    if WinExist("Ahk_exe RobloxPlayerBeta.exe")
    {
        WinActivate
        WinGetPos,,,W,H,A
        If ((W >= A_ScreenWidth ) & (H >= A_ScreenHeight))
        {
            Send {F11}
            Sleep 100
        }
        WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
    } else {
        MsgBox,,Vivace's Macro,Roblox not active,3
        ExitApp
    }
    If Broken = True
    {
        if aCombat = false
        {
            Gosub, CloseRoblox
        }
        if webhook = true
        {
            If foodranout = true
            {
                WebRequest.Send(Food)
            }
            If fatigue = true
            {
                WebRequest.Send(aFatigue)
            }
            If amoney = true
            {
                WebRequest.Send(Cash)
            }
            If alevel = true
            {   
                WebRequest.Send(Level)
            }
            If akicked = true
            {
                WebRequest.Send(kicked)
            }
            If aCombat = True
            {
                WebRequest.Send(Combat)
                gosub, AntiCombatLog
                Sleep 3000
                Gosub, CloseRoblox
            }
            gosub, Autoclip
        } else {
            gosub, Autoclip
            If foodranout = true
            {
                MsgBox,,Vivace's Macro,You are out of food,5
            }
            If aCombat = true
            {
                MsgBox,,Vivace's Macro,You are attacked!,5
            }
            If amoney = true
            {
                MsgBox,,Vivace's Macro,You are out of money,5
            }
            If alevel = true
            {   
                MsgBox,,Vivace's Macro,You are pushed too far away from Treadmill,5
            }
            If akicked = true
            {
                msgbox,,Vivace's Macro,You are kicked from the game 😨,5
            }
            If fatigue = true
            {
                msgbox,,Vivace's Macro,You have reach 65`% fatigue!,5
            }
        }
        ExitApp
    }
}
Return



Space::ExitApp
StartTreadmill:
Loop,
{
    ImageSearch,,, 330, 230, 485, 270, *10 %A_WorkingDir%/bin/Leave.bmp
    If ErrorLevel = 0
    {
        Send {PrintScreen}
        Broken = true
        akicked = true ;:fearful:
        goto, Check
    }
    gosub, Check
    Pixelsearch,,, 79, 98, 80, 99, 0x38388E, 10, Fast ; Combat Tag 
    if ErrorLevel = 0
    {
        Broken = True
        aCombat = True
        Goto, Check
    }
    PixelSearch ,,, 70, 144, 75, 146, 0x3A3A3A, 40, Fast ; Hungry
    If ErrorLevel = 0
    {
        Click, 410, 345 ; Leave Treadmill
        gosub, Hungry
    }
    ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/bin/Stamina.bmp
    If ErrorLevel = 0
    {
        ;; Begin Session
        Gosub, ChooseTraining
        wait := A_TickCount
        Loop,
        {
            PixelSearch,,, 339, 249, 340, 250, 0x5A5A5A,, Fast
            If ErrorLevel = 0
            {
                Break
            }
            PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
            If ErrorLevel = 0
            {
                Break
            } 
        } Until A_TickCount - wait > 3000
        PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
        If ErrorLevel = 1
        {
            gosub, ChooseLevel
        } 
        gosub, Hand
        Sleep 3000 ; 3 Second Start
        Treadrun := A_TickCount
        gosub, AutoTreadmill
        if autolog = true
        {
            gosub, AutoLog
        }
    }
}
Return

;; If something Break use Goto,

;; sub
AutoLog:
{
    Count++
    if Count = %Log%
    {
        Broken = True
        Fatigue = True
        Goto, Check
    }
}
Return

AntiCombatLog:
{
    Loop,
    {
        Pixelsearch,,, 79, 98, 80, 99, 0x38388E, 10, Fast ; Combat Tag 
        if ErrorLevel = 1
        {
            Sleep 100
            Pixelsearch,,, 79, 98, 80, 99, 0x38388E, 10, Fast ; Combat Tag 
            if ErrorLevel = 1
            {
                Break
            }
        } 
    }
}
Return
Autoclip:
{
    if autoclip = true
    {
        If record = true
        {
            Send {f12}
        }
        PixelSearch,,, 565, 90, 566 , 91, 0xFFFFFF, 10
        IF ErrorLevel = 1
        {
            Send {Tab}
        }
        x = 30
        l = 125
        MouseMove, 765, %l%
        Loop, 10
        {
            Click, WheelUp
            Sleep 100
        }
        MouseMove, 600, %l%
        MouseMove, 765, %l%
        Sleep 350
        Loop, 6
        {
            l = 125
            Loop, 5
            {
                Sleep 50
                MouseMove, 760, %l%
                MouseMove, 762, %l%
                MouseMove, 765, %l%
                Click
                Sleep 120
                l := (l + x)
            }
            Click, WheelDown
            Sleep 400
        }
        Sleep 1000
        if instant = true
        {
            Send {f8}
        } else {
            if record = true
            {
                Send {f12}
            }
        }
    }
}
Return
CloseRoblox:
{
    If Autolog = true 
    {
        Process, Close, RobloxPlayerBeta.exe
    }
}
Return
