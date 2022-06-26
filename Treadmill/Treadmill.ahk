#SingleInstance, force
#NoEnv
SetCapsLockState, Off
SetBatchLines, -1
SetMouseDelay, -1
CoordMode, Pixel, Window
CoordMode, Mouse, Window

;
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
;
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
return
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

GuiClose:
    ExitApp
Return

GuiEscape:
ButtonFinished:
    Gui, Submit, 
    if (log = "")
    {
        log:=Reptimes
    } else {
        if (Reptimes = "")
        {
            MsgBox,,, Vivace's Macro, you have uncompleted info.
            ExitApp
        }
    }
    if (TrainingChoice = "" )
    {
        MsgBox,,, Are you sure you want to exit, you have uncompleted info.
        {
            MsgBox,,, Vivace's Macro, you have uncompleted info.
            ExitApp
        }
    }
    if (vTrainingChoice1 = "" )
    {
        MsgBox,,, Are you sure you want to exit, you have uncompleted info.
        {
            MsgBox,,, Vivace's Macro, you have uncompleted info.
            ExitApp
        }
    }
    goto, StartTreadmill
Return

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
            Fatigue=
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

StartTreadmill:
ToolTip
if WinExist("Ahk_exe RobloxPlayerBeta.exe")
{
    WinActivate
    WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
}
else
{
    MsgBox,,Vivace's Macro,Roblox not active,3
    ExitApp
}
    ;start the macro
Sleep 1000
Loop,
{
    ImageSearch,,, 330, 230, 485, 270, *10 %A_WorkingDir%/bin/Leave.bmp
    If ErrorLevel = 0
    {
        Send {PrintScreen}
        If Webhook = true
        {
            Broken = true
            akicked = true ;:fearful:
            if instant = true
            {
                Send {f8}
            }
            Break
        } else {
            Pause
        }
    }
    PixelSearch,,, 249, 129, 250, 130, 0x3A3A3A, 40, Fast
    If ErrorLevel = 1
    {	
        If TrainingChoice = Stamina
        {
            Loop, 10
            {
                Click , 290, 310
                Click , 290, 311
            }
        }
        If TrainingChoice = RunningSpeed
        {
            Loop, 10
            {
                Click , 520, 310
                Click , 520, 311
            }
        }
        wait := A_TickCount
        Loop,
        {
            ImageSearch,,, 380, 450, 430, 470, %A_WorkingDir%/bin/lea.bmp
            If ErrorLevel = 0
            {
                Sleep 10
                Break
            }
        } Until A_TickCount - wait > 3000
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
                    Sleep 100
                    Break
                } else {
                    levell--
                    levely:=levely-30
                    if levely <= 220
                    {
                        levely = 370
                        level = 5
                        error++
                        if error <= 50
                        {
                            If Webhook = true
                            {
                            Broken = true
                            alevel = true
                            Click, 410, 345
                            Sleep 500
                            Break
                        } else {
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
                            If autolog = true
                            {
                                Process, Close, RobloxPlayerBeta.exe
                            }
                                MsgBox, Level not found
                                ExitApp
                            }
                        }
                    }
                }
            }   
        } else {
            If TrainingChoice1 = 5
            {
                MouseMove, 470 , 370
                MouseMove, 471 , 370
                Click, 10 
                Sleep 100
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
                Sleep 100
            }
            If TrainingChoice1 = 2
            {
                MouseMove, 470 , 280
                MouseMove, 471 , 280
                Click, 10 
                Sleep 100
            }
            If TrainingChoice1 = 1
            {
                MouseMove, 470 , 250
                MouseMove, 471 , 250
                Click, 10 
                Sleep 100
            }
        }
    }
    If Broken = true
    {
        Break
    }
    MouseMove, 405, 600
    hand := A_TickCount
    Loop,
    {
        hand2 := A_TickCount - hand
        Sleep 50
        ImageSearch,,, 390, 330, 430, 370, %A_WorkingDir%/bin/hand.bmp
        If ErrorLevel = 0
        {
            Break
        }
        if (hand2 > 5000)
        {
            If Webhook = true
            {
                Broken = true
                amoney = true
                Click, 410, 345
                Sleep 500
                Break
            } else {
                If autolog = true
                {
                    Process, Close, RobloxPlayerBeta.exe
                }
                MsgBox, Money ranout
                ExitApp
            }
        }
    }
    If Broken = true
    {
        Break
    }
    Loop, 20 ;Click hand
    {
        Click , 410, 355
        Click , 410, 351
    }
    Sleep 3000
    Treadrun := A_TickCount
    Loop,
    {
        run := A_TickCount - Treadrun
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\w.bmp
        if Errorlevel = 0
        {				
            Send {vk57} ;w
        }			
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\a.bmp
        if Errorlevel = 0
        {				
            Send {vk41} ;a
        }
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\s.bmp
        if Errorlevel = 0
        {				
            Send {vk53} ;s
        }			
        ImageSearch,,, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\d.bmp
        if Errorlevel = 0
        {				
            Send {vk44} ;d
        }
        if (run > 57000)
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
                if (run > 57000)
                {
                    Click, 400, 290
                    Click, 400, 291
                }
            } Until A_TickCount - WaitforStamina > 9000			
        }
    } Until A_TickCount - Treadrun > 65000
    if autolog = true
    {
        Count++
        if Count = %Log%
        {
            If Webhook = true
            {
                Broken = true
                a65 = true
                Break
            } else {
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
                If autolog = true
                {
                    Process, Close, RobloxPlayerBeta.exe
                }
                MsgBox, Fatigue Reached 65`%
                ExitApp
            }
        }
    }
    ; check for food
    Pixelsearch,,, 80, 95, 81, 96, 0x37378A, 10, Fast ; Combat Tag 
    if ErrorLevel = 0
    {
        If Webhook = true
        {
            Broken = true
            aCombat = true
            Break
        } else {
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
            If autolog = true
            {
                Process, Close, RobloxPlayerBeta.exe
            }
            MsgBox, Combat tag 
            ExitApp
        }
    }   
    PixelSearch ,,, 70, 144, 75, 146, 0x3A3A3A, 40, Fast ; Hungry
    If ErrorLevel = 0
    {
        ; Auto eat
        Click, 410, 345
        Sleep 500
        aw = 0
        slot = 0
        Loop, 11 ;slot
        {
            Send %slot%
            Sleep 10
            ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
            If ErrorLevel = 0
            {
                Inventory = false
                Break
            } else {
                slot++
                if slot = 11
                {
                    Inventory = true
                }
            }
        } 
        If Inventory = true
        {
            Slotbar = 0
            Send {VKC0}
            MouseMove, 80, 50
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
            Loop,
            {
                ImageSearch, xx, yy, 65, 530, 750, 585, %A_WorkingDir%/bin/Slot/bar%Slotbar%.bmp
                If ErrorLevel = 0
                {
                    food = 1
                    Loop,
                    {
                        ImageSearch, x, y, 90, 195, 675, 500, %A_WorkingDir%/bin/food/foodall%food%.bmp
                        If ErrorLevel = 0
                        {
                            calx:=x+20
                            caly:=y+5
                            calxx:=xx+20
                            calyy:=yy+20 ;; somehow i can make it to work
                            error = 0
                            Click %calx% %caly% Down
                            Sleep 30
                            Click %calxx% %calyy% Up
                            Sleep 10
                            slotfound = true
                            slotbar++
                            Break
                        } else {
                            food++
                            if food >= 23
                            {
                                food = 1
                                error++
                                if error >= 10
                                {
                                    If Webhook = true
                                    {
                                        Broken = true
                                        anofood = true
                                        Break
                                    } else {
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
                                        If autolog = true
                                        {
                                            Process, Close, RobloxPlayerBeta.exe
                                        }
                                        MsgBox, No food Left
                                        ExitApp
                                    }
                                }
                            }
                        }
                        if slotfound = true
                        {
                            slotfound = false
                            Break
                        }
                    }
                } else {
                    Slotbat++ 
                    If Slotbar >= 10
                    {
                        Inventory = false
                    }
                }
                If Inventory = false
                {
                        Break
                }
            }
            Send {VKC0}
            slot = 0
            Loop, 11
            {
                Send %slot%
                Sleep 10
                ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
                If ErrorLevel = 0
                {
                    Break
                } else {
                    slot++
                    if slot = 11
                    {
                        Inventory = true
                    }
                }
            } 
        }

        time := A_TickCount
        Loop, ; Eating part
        {
            Click, 405 320
            Sleep 100
            Pixelsearch, x, y, 80, 95, 81, 96, 0x37378A, 10, Fast
            if ErrorLevel = 0
            {
                aCombat = true
                Broken = true
                Break
            }
            PixelSearch, x, y, 119, 144, 110, 146, 0x3A3A3A, 40, Fast ; full hunger
            If ErrorLevel = 1
            {
                Break
            }
            ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
            If ErrorLevel = 1
            {
                slot = 0
                Loop, 11
                {
                    Send %slot% 
                    Sleep 10
                    ImageSearch,,, 65, 525, 705, 545, *10 %A_WorkingDir%/bin/Slot/%slot%.bmp
                    If ErrorLevel = 0
                    {
                        Break
                    } else {
                        slot++
                        if slot = 11
                        {
                            Inventory = true
                            Break
                        }
                    }
                } 
            }
        } Until A_TickCount - time > 60000
        Send {BackSpace}
        StartTime2 := A_TickCount
        Loop,
        {			
        Click , 409, 296
        Click , 409, 295
        } Until A_TickCount - StartTime2 > 1500
    }
}
ImageSearch,,, 330, 230, 485, 270, *10 %A_WorkingDir%/bin/Leave.bmp
If ErrorLevel = 0
{
    Send {PrintScreen}
    If Webhook = true
    {
        Broken = true
        akicked = true ;:fearful:
        if instant = true
        {
            Send {f8}
        }
    } else {
        Pause
    }
}

If aCombat  = true
{
    if webhook = true
    {
        WebRequest.Send(Combat)
        Pixelsearch,,, 80, 95, 81, 96, 0x37378A, 10, Fast ; Combat Tag 
        if ErrorLevel = 0
        {
            WebRequest.Send(Combatlog)
        }
    }
    Send {PrintScreen}
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
        Sleep 350
        Loop, 36
        {
            MouseMove, 765, %l%
            l := (l + x)
            If A_Index = 14
            {
                MouseMove, 805, 140
                Click, Down
                MouseMove, 805, 250
                Click, Up
                Sleep 200
                l = 125
            }
            If A_Index = 28
            {
                MouseMove, 805, 250
                Click, Down
                MouseMove, 805, 350
                Click, Up
                Sleep 200
                l = 125
            }
            Sleep 70
        }
        Sleep 1000
        if instant = true
        {
                Send {f8}
        }
        if record = true
        {
                Send {f12}
        }
    } 
}
if webhook = true
{
    If anofood = true
    {
        WebRequest.Send(Food)
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
}

Sleep 10000
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

If autolog = true
{
    Process, Close, RobloxPlayerBeta.exe
    If webhook = true
    {
        WebRequest.Send(Logged)
    }
}

Sleep 100
ExitApp
Return


Space::ExitApp


