#NoTrayIcon
DetectHiddenWindows, On
; ========== CONFIG ==========
OCR_LANG := "eng"          ; OCR language
checkWord1 := "Negative"   ; Keyword 1
;checkWord2 := "Neutral"    ; Keyword 2

lastCount1 := -1
lastCount2 := -1

; ========== GLOBAL COUNTERS ==========
loopCount := 0
processedCount1 := 0
processedCount2 := 0

; ========== GUI ==========
Gui, Add, Text, vLoopTxt w250, Loop Count: 0
Gui, Add, Text, vProcTxt1 w250, Negative Processed: 0
Gui, Add, Text, vProcTxt2 w250, Neutral Processed: 0
Gui, Add, Button, gStartLoop w80, Start
Gui, Add, Button, gStopLoop w80, Stop
Gui, Show,, OCR Automation
return

; ---------- BUTTON HANDLERS ----------
StartLoop:
    SetTimer, MainLoop, -100  ; start immediately
return

StopLoop:
    SetTimer, MainLoop, Off
return

; ---------- MAIN LOOP ----------
MainLoop:
    loopCount++
    GuiControl,, LoopTxt, Loop Count: %loopCount%

    ; Step 1 - Reload Chrome Page
    IfWinExist, ahk_exe chrome.exe
    {
        WinActivate
        Sleep, 500
        Send, ^r
    }
    else
    {
        MsgBox, 48, Error, Chrome not found!
        return
    }

    Sleep, 25000   ; wait 25 sec for reload

    ; Step 2 - Screenshot direct capture
    tmpFile := A_Temp . "\ocr_tmp.png"
    tmpTxt  := A_Temp . "\ocr_tmp.txt"
    FileDelete, %tmpFile%
    FileDelete, %tmpTxt%

    RunWait, nircmd.exe savescreenshot "%tmpFile%",, Hide
    Sleep, 2000

    ; Step 3 - Run OCR
    RunWait, %ComSpec% /c tesseract "%tmpFile%" "%A_Temp%\ocr_tmp" -l %OCR_LANG%,, Hide

    ; wait until txt file available
    Loop, 20
    {
        if FileExist(tmpTxt)
            break
        Sleep, 500
    }

    FileRead, ocrText, %tmpTxt%

    ; Step 4 - Count keywords
    count1 := 0
    count2 := 0
    Loop, Parse, ocrText, `n, `r
    {
        StringReplace, dummy, A_LoopField, %checkWord1%,, UseErrorLevel
        count1 += ErrorLevel

        StringReplace, dummy, A_LoopField, %checkWord2%,, UseErrorLevel
        count2 += ErrorLevel
    }

    ; Step 5 - Handle "Negative"
    if (count1 > 0 && count1 != lastCount1) {
        processedCount1++
        lastCount1 := count1
        msg := checkWord1 " comment found - " count1

        Send, ^2
        Sleep, 2000
        SendInput, %msg%
        Sleep, 500
        Send, {Enter}
        Sleep, 2000
        Send, ^1
        Sleep, 2000
    }

    ; Step 6 - Handle "Neutral"
    if (count2 > 0 && count2 != lastCount2) {
        processedCount2++
        lastCount2 := count2
        msg := checkWord2 " comment found - " count2

        Send, ^2
        Sleep, 2000
        SendInput, %msg%
        Sleep, 500
        Send, {Enter}
        Sleep, 2000
        Send, ^1
        Sleep, 2000
    }

    ; Step 7 - Update GUI
    GuiControl,, ProcTxt1, Negative Processed: %processedCount1%
    GuiControl,, ProcTxt2, Neutral Processed: %processedCount2%

    ; Repeat after waiting
    Sleep, 25000
    SetTimer, MainLoop, -100
return

GuiClose:
ExitApp
