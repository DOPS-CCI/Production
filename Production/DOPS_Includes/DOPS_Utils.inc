#INCLUDE "Mersenne-Twister.inc"
#INCLUDE "ExptCheckList.inc"


FUNCTION GreyCode (BYVAL n AS DWORD) AS DWORD
    LOCAL temp AS DWORD
    temp = n
    SHIFT RIGHT temp, 1
    n = n XOR temp
    FUNCTION = n
END FUNCTION

FUNCTION ConfigurePorts(cardPresent AS LONG, portA AS LONG, OPTIONAL portB AS LONG) AS LONG
    LOCAL lError AS LONG
    LOCAL boardNum AS LONG

    boardNum = 0
    IF (cardPresent = 1) THEN
        IF (portA = 1) THEN
            SLEEP 1000
            lError = cbDConfigPort(boardNum, %FIRSTPORTA, %DIGITALOUT)
            IF (lError <> 0) THEN
                MSGBOX "Error on cbDConfigPortA: Error# " + STR$(lError)
                FUNCTION = -1
                EXIT FUNCTION
            END IF
        END IF
        IF (portB = 1) THEN
            SLEEP 1000
            lError = cbDConfigPort(boardNum, %FIRSTPORTB, %DIGITALOUT)
            IF (lError <> 0) THEN
                MSGBOX "Error on cbDConfigPortB: Error# " + STR$(lError)
                FUNCTION = -1
                EXIT FUNCTION
            END IF
        END IF
        FUNCTION = boardNum
    END IF
END FUNCTION

FUNCTION DIOWrite(cardPresent AS LONG, boardNum AS LONG, BYREF gCode AS DWORD) AS LONG
    LOCAL lError AS LONG
    LOCAL loValue, hiValue AS DWORD
    GLOBAL dioCardPresent AS LONG
    STATIC dioIndex AS LONG

    INCR dioIndex
    gCode = GreyCode(dioIndex)

    loValue = LO(BYTE, gCode)
    hiValue = HI(BYTE, gCode)

    IF (cardPresent = 1) THEN
      cbDOut(boardNum, %FIRSTPORTA, loValue)
      IF (lError <> 0) THEN
            MSGBOX "Error on cbDConfigPortA: Error# " + STR$(lError)
            EXIT FUNCTION
      END IF
      cbDOut(boardNum, %FIRSTPORTB, hiValue)
      IF (lError <> 0) THEN
            MSGBOX "Error on cbDConfigPortB: Error# " + STR$(lError)
            EXIT FUNCTION
      END IF
      FUNCTION = dioIndex
    END IF
END FUNCTION

SUB DIOWriteInitialize(cardPresent AS LONG, boardNum AS LONG)
    LOCAL lError AS LONG
    LOCAL gCode AS DWORD
    LOCAL loValue, hiValue AS DWORD
    GLOBAL dioCardPresent AS LONG

    gCode = 0

    loValue = LO(DWORD, gCode)
    hiValue = HI(DWORD, gCode)

    IF (cardPresent = 1) THEN
      cbDOut(boardNum, %FIRSTPORTA, loValue)
      IF (lError <> 0) THEN
            MSGBOX "Error on cbDConfigPortA: Error# " + STR$(lError)
            EXIT SUB
      END IF
      cbDOut(boardNum, %FIRSTPORTB, hiValue)
      IF (lError <> 0) THEN
            MSGBOX "Error on cbDConfigPortB: Error# " + STR$(lError)
            EXIT SUB
      END IF
    END IF
END SUB

SUB shuffle(BYREF arr AS INTEGER, BYREF numOfElems AS DWORD)
    LOCAL k, n, temp AS INTEGER
    DIM arr (numOfElems) AS INTEGER AT VARPTR(arr)

    n = numOfElems
    WHILE (n > 1)
      k = RND(0, n - 1)
      n = n - 1
      temp = arr(n)
      arr(n) = arr(k)
      arr(k) = temp
    WEND
END SUB

SUB shuffleLongs(BYREF arr AS LONG, BYREF numOfElems AS DWORD)
    LOCAL k, n, temp AS LONG
    DIM arr (numOfElems) AS LONG AT VARPTR(arr)

    n = numOfElems
    WHILE (n > 1)
      k = RND(0, n - 1)
      n = n - 1
      temp = arr(n)
      arr(n) = arr(k)
      arr(k) = temp
    WEND
END SUB

FUNCTION GetTimeWithSeconds() AS STRING
    LOCAL temp AS STRING
    LOCAL nano AS QUAD
    LOCAL secs AS DOUBLE

    temp = GetTimeWithNano()
    nano = VAL(temp)

    secs = nano / 10000000

    FUNCTION = STR$(secs, 18)

END FUNCTION

FUNCTION GetTimeWithNano() AS STRING
    LOCAL TimeStart AS QUAD

    GetSystemTimeAsFileTime BYVAL VARPTR(TimeStart)

   FUNCTION = STR$(TimeStart, 18)
END FUNCTION

FUNCTION GetTimeWithMilli() AS STRING
    LOCAL systime AS SYSTEMTIME

    GetSystemTime(systime)

    FUNCTION = TIME$ + "." + FORMAT$(systime.wMilliseconds, "0000")
END FUNCTION


FUNCTION CustomMessageBox(SCREEN AS INTEGER, TXT AS STRING, title AS STRING) AS LONG
    LOCAL hDlg AS DWORD
    LOCAL lResult AS LONG


    DIALOG FONT "arial", 18, 0, 0
    DIALOG NEW PIXELS, hDlg, title, EXPERIMENT.Misc.Screen(SCREEN).x, EXPERIMENT.Misc.Screen(SCREEN).y, 490, 330, %WS_OVERLAPPEDWINDOW, 0 TO hDlg
    DIALOG SET LOC hDlg, EXPERIMENT.Misc.Screen(SCREEN).x + (EXPERIMENT.Misc.Screen(SCREEN).xMax - 490) / 2, EXPERIMENT.Misc.Screen(SCREEN).y + (EXPERIMENT.Misc.Screen(SCREEN).yMax - 330) / 2
    CONTROL ADD LABEL, hDlg, 9910, TXT, 54, 49, 364, 240, %SS_CENTER,
    CONTROL ADD IMAGEX, hDlg, 9914, "BITMAP_OKBUTTON", 208, 284, 80, 30,,,
    DIALOG SHOW MODAL hDlg, CALL cbCustomMessageBox() TO lResult&

    FUNCTION = lResult

END FUNCTION

FUNCTION CustomMessageBox2(SCREEN AS INTEGER, TXT AS STRING, title AS STRING, fontSize AS LONG) AS LONG
    LOCAL hDlg AS DWORD
    LOCAL lResult AS LONG


    DIALOG FONT "arial", fontSize, 0, 0
    DIALOG NEW PIXELS, hDlg, title, EXPERIMENT.Misc.Screen(SCREEN).x, EXPERIMENT.Misc.Screen(SCREEN).y, 490, 330, %WS_OVERLAPPEDWINDOW, 0 TO hDlg
    DIALOG SET LOC hDlg, EXPERIMENT.Misc.Screen(SCREEN).x + (EXPERIMENT.Misc.Screen(SCREEN).xMax - 490) / 2, EXPERIMENT.Misc.Screen(SCREEN).y + (EXPERIMENT.Misc.Screen(SCREEN).yMax - 330) / 2
    CONTROL ADD LABEL, hDlg, 9910, TXT, 54, 49, 364, 240, %SS_CENTER,
    CONTROL ADD IMAGEX, hDlg, 9914, "BITMAP_OKBUTTON", 208, 284, 80, 30,,,
    DIALOG SHOW MODAL hDlg, CALL cbCustomMessageBox() TO lResult&

    FUNCTION = lResult

END FUNCTION

FUNCTION CustomMessageBox3(SCREEN AS INTEGER, TXT AS STRING, title AS STRING, fontSize AS LONG) AS LONG
    LOCAL hDlg AS DWORD
    LOCAL lResult AS LONG


    DIALOG FONT "arial", fontSize, 0, 0
    DIALOG NEW PIXELS, hDlg, title, EXPERIMENT.Misc.Screen(SCREEN).x, EXPERIMENT.Misc.Screen(SCREEN).y, 490, 330, %WS_OVERLAPPEDWINDOW, 0 TO hDlg
    DIALOG SET LOC hDlg, EXPERIMENT.Misc.Screen(SCREEN).x + (EXPERIMENT.Misc.Screen(SCREEN).xMax - 490) / 2, EXPERIMENT.Misc.Screen(SCREEN).y + (EXPERIMENT.Misc.Screen(SCREEN).yMax - 330) / 2
    CONTROL ADD LABEL, hDlg, 9910, TXT, 54, 49, 364, 240, %SS_CENTER,
    CONTROL ADD IMAGEX, hDlg, 9914, "BITMAP_PROCEEDBIOSEMI", 58, 284, 348, 30,,,
    DIALOG SHOW MODAL hDlg, CALL cbCustomMessageBox() TO lResult&

    FUNCTION = lResult

END FUNCTION

FUNCTION TimedMessageBox(SCREEN AS INTEGER, TXT AS STRING, title AS STRING) AS LONG
    LOCAL hDlg AS DWORD
    LOCAL lResult AS LONG


    DIALOG FONT "arial", 18, 0, 0
    DIALOG NEW PIXELS, hDlg, title, EXPERIMENT.Misc.Screen(SCREEN).x, EXPERIMENT.Misc.Screen(SCREEN).y, 490, 330, %WS_OVERLAPPEDWINDOW, 0 TO hDlg
    DIALOG SET LOC hDlg, EXPERIMENT.Misc.Screen(SCREEN).x + (EXPERIMENT.Misc.Screen(SCREEN).xMax - 490) / 2, EXPERIMENT.Misc.Screen(SCREEN).y + (EXPERIMENT.Misc.Screen(SCREEN).yMax - 330) / 2
    CONTROL ADD LABEL, hDlg, 9910, TXT, 54, 49, 364, 140, %SS_CENTER,
    'CONTROL ADD IMAGEX, hDlg, 9914, "BITMAP_OKBUTTON", 208, 224, 80, 30,,,
    DIALOG SHOW MODAL hDlg, CALL cbTimedMessageBox() TO lResult&

    FUNCTION = lResult

END FUNCTION

FUNCTION ModelessMessageBox(SCREEN AS INTEGER, TXT AS STRING, title AS STRING, BYREF hDlg AS DWORD) AS LONG
    LOCAL lResult AS LONG


    DIALOG FONT "arial", 18, 0, 0
    DIALOG NEW PIXELS, hDlg, title, EXPERIMENT.Misc.Screen(SCREEN).x, EXPERIMENT.Misc.Screen(SCREEN).y, 490, 330, %WS_OVERLAPPEDWINDOW, 0 TO hDlg
    DIALOG SET LOC hDlg, EXPERIMENT.Misc.Screen(SCREEN).x + (EXPERIMENT.Misc.Screen(SCREEN).xMax - 490) / 2, EXPERIMENT.Misc.Screen(SCREEN).y + (EXPERIMENT.Misc.Screen(SCREEN).yMax - 330) / 2
    CONTROL ADD LABEL, hDlg, 9910, TXT, 54, 49, 364, 140, %SS_CENTER,
    'CONTROL ADD IMAGEX, hDlg, 9914, "BITMAP_OKBUTTON", 208, 224, 80, 30,,,
    DIALOG SHOW MODELESS hDlg,  TO lResult&

    FUNCTION = lResult

END FUNCTION

CALLBACK FUNCTION cbCustomMessageBox() AS LONG
   SELECT CASE CB.MSG
        CASE %WM_LBUTTONUP
            CALL FindOKButton(CB.HNDL, CB.LPARAM)
        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbTimedMessageBox() AS LONG
   SELECT CASE CB.MSG
        CASE %WM_INITDIALOG
            STATIC TimerId AS LONG
            TimerId = SetTimer(CBHNDL, 1, 5000, 0) 'set a 5-second timer
        CASE %WM_LBUTTONUP
            CALL FindOKButton(CB.HNDL, CB.LPARAM)
        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
        CASE %WM_TIMER 'will be triggered when timer ticks
            IF CBWPARAM = TimerId THEN
               DIALOG END CBHNDL
            END IF
         CASE %WM_DESTROY 'kill timer on exit (important)
            IF TimerId THEN KillTimer CBHNDL, TimerId
    END SELECT
END FUNCTION

SUB FindOKButton(hdl AS DWORD, lParam AS DWORD)
     LOCAL l, lWide, high, x, y, result, xMouse, yMouse AS LONG

    'Response selected
     CONTROL GET LOC hdl, 9914 TO x, y
     CONTROL GET CLIENT hdl, 9914 TO lWide, high
     xMouse = LO(WORD, lParam)
     yMouse = HI(WORD, lParam)
     IF (xMouse >= x) AND (xMouse <= x + lWide) THEN
         IF (yMouse >= y) AND (yMouse <= y + high) THEN
            DIALOG END hdl, 1
            DIALOG FONT DEFAULT "MS Sans Serif", 8
         END IF
     END IF
END SUB


FUNCTION CreatePhotoDiodeDDialog(x AS INTEGER, y AS INTEGER) AS LONG
    IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) <> "yes") THEN
        EXIT FUNCTION
    END IF

    LOCAL hDlg AS LONG

    DIALOG NEW PIXELS, 0, "", x, y, 30, 34, %WS_POPUP OR %WS_BORDER, %WS_EX_TOPMOST TO hDlg
    CONTROL ADD IMAGE, hDlg, 9977, "BITMAP_PDB", 3, 3, 58, 31,,,

    'CONTROL SHOW STATE hDlg, 9977, %SW_HIDE
    DIALOG SHOW MODELESS hDlg

    FUNCTION = hDlg
END FUNCTION

SUB PhotoDiodeOnOff(dlg AS LONG,  flag AS INTEGER)
    IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) <> "yes") THEN
        EXIT SUB
    END IF

    IF (flag = 1) THEN
        CONTROL SET IMAGE dlg, 9977, "BITMAP_PDW"
    ELSE
        CONTROL SET IMAGE dlg, 9977, "BITMAP_PDB"
    END IF
    CONTROL REDRAW dlg, 9977
END SUB



SUB delay(milliseconds AS LONG)
    LOCAL tickCount, qDelay AS QUAD

    tickCount = GetTickCount()
    qDelay = tickCount + milliseconds
    WHILE (GetTickCount()  < qDelay)
    WEND
END SUB

SUB delaySeconds(seconds AS DOUBLE)
    LOCAL timeEllapsed AS QUAD
    LOCAL timeStart AS QUAD
    LOCAL timeDelta AS QUAD
    LOCAL timeToWait AS QUAD

    QueryPerformanceFrequency(timeDelta)
    QueryPerformanceCounter (timeStart)

    timeToWait = timeDelta * seconds

    timeEllapsed = timeStart

    WHILE(( timeEllapsed - timeStart ) < timeToWait )
        QueryPerformanceCounter(timeEllapsed)
    WEND
END SUB

SUB delayMilliSeconds(milliseconds AS DOUBLE)
    LOCAL timeEllapsed AS QUAD
    LOCAL timeStart AS QUAD
    LOCAL timeDelta AS QUAD
    LOCAL timeToWait AS QUAD

    QueryPerformanceFrequency(timeDelta)

    timeToWait = timeDelta * milliseconds/1000.0

    QueryPerformanceCounter (timeStart)

    timeEllapsed = timeStart

    WHILE( ( timeEllapsed - timeStart ) < timeToWait )
        QueryPerformanceCounter(timeEllapsed)
    WEND
END SUB

SUB delayMicroSeconds(microseconds AS DOUBLE)
    LOCAL timeEllapsed AS QUAD
    LOCAL timeStart AS QUAD
    LOCAL timeDelta AS QUAD
    LOCAL timeToWait AS QUAD

    QueryPerformanceFrequency(timeDelta)

    timeToWait = timeDelta * microseconds / 1000000.0

    QueryPerformanceCounter (timeStart)

    timeEllapsed = timeStart

    WHILE( ( timeEllapsed - timeStart ) < timeToWait )
        QueryPerformanceCounter(timeEllapsed)
    WEND
END SUB


SUB randomDelayMilliSeconds(minMs AS LONG, maxMs AS LONG)
    LOCAL tickCount, qDelay AS QUAD
    LOCAL rndNbr AS LONG

    rndNbr = RND(minMs, maxMs)
    'rndNbr = RandomNumber2(minMs, maxMs)

    delayMilliSeconds(CDBL(rndNbr))
END SUB

FUNCTION isNumeric(str AS ASCIIZ * 255) AS LONG
    LOCAL result AS LONG
    LOCAL temp AS STRING

    temp = str
    result = VERIFY(temp, "0123456789")
    IF (result = 0) THEN
        FUNCTION = 1
    ELSE
        MSGBOX "This must be a number."
        FUNCTION = 0
    END IF
END FUNCTION

FUNCTION Odd(num AS LONG) AS LONG
    'return 1 if odd
    IF ((num MOD 2) = 0) THEN
        FUNCTION = 0
    ELSE
        FUNCTION = 1
    END IF
END FUNCTION

FUNCTION findLargest(arrChannel() AS DOUBLE) AS INTEGER
    LOCAL location, i, n AS LONG
    LOCAL largest_so_far AS DOUBLE

    location = 0

    largest_so_far = arrChannel(0)
    n = UBOUND(arrChannel)

    i = 1
    WHILE (i < n)
        IF (arrChannel(i) > largest_so_far) THEN
            largest_so_far = arrChannel(i)
            location = i
        END IF
        i = i + 1
    WEND

    FUNCTION  = location + 1
END FUNCTION

SUB StartRenameAndMoveFiles()
    IF (Experiment.Misc.Mode <> "demo") THEN
        SHELL("H:\RenameAndMoveFiles\RenameAndCopyFiles.exe", 1)
    END IF
END SUB

SUB StartModifyExpAndTech(filename AS ASCIIZ * 255)
    IF (Experiment.Misc.Mode <> "demo") THEN
        SHELL "H:\ModifyExpAndTech\ModifyExpAndTech.exe " + filename, 1
    END IF
END SUB

SUB StartupActiview()
    LOCAL temp, filename, etrFilename, polFilename, polhemusStr AS ASCIIZ * 255
    LOCAL lResult, polhemus AS LONG

    PlaySound "PLEASEWAIT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC

    IF (Experiment.Misc.Mode <> "demo") THEN
        CALL DeleteMacroTextFiles()

        temp = EXPERIMENT.SessionDescription.DataDir + "\" + EXPERIMENT.SessionDescription.SubjectDir + "\" + EXPERIMENT.SessionDescription.BDFFile
        WritePrivateProfileString("Save", "SavePath", temp, "\\DOPSBIOSEMI-PC\DOPS_Applications\Actiview605\Configuring\" + EXPERIMENT.ActiviewConfig)
        OPEN "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues.txt" FOR OUTPUT AS #1
        PRINT #1, EXPERIMENT.ActiviewConfig;",";
        PRINT #1, EXPERIMENT.SessionDescription.Subject + ",";
        PRINT #1, "Some kind of description.,";
        PRINT #1, temp 'EXPERIMENT.SessionDescription.BDFFile
        CLOSE #1

        FILECOPY "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues.txt", "X:\Semaphores\ActiviewStart\MacroValues.txt"

        temp = ""
        filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile
        GetPrivateProfileString("Experiment Section", "Polhemus", "", polhemusStr, %MAXPPS_SIZE, filename)
        polhemus = VAL(polhemusStr)
        SELECT CASE polhemus
            CASE 32
                polFilename = "Standard-32"
            CASE 64
                polFilename = "BioSemi-64"
            CASE 128
                polFilename = "BioSemi-128"
        END SELECT

        IF (polhemus <> 0) THEN
            etrFilename = PATHNAME$(NAME, EXPERIMENT.SessionDescription.ElectrodeFile)
            OPEN "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Polhemus\PolhemusValues.txt" FOR OUTPUT AS #1
            PRINT #1, polFilename; ",";
            PRINT #1, etrFilename
            CLOSE #1
        END IF
    END IF
END SUB

SUB StartBiosemiRecord()
    IF (Experiment.Misc.Mode <> "demo") THEN
        OPEN "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues2.txt" FOR OUTPUT AS #1
        PRINT #1, ""
        CLOSE #1

        FILECOPY "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues2.txt", "X:\Semaphores\BiosemiRecord\MacroValues2.txt"
    END IF
END SUB

SUB ShutdownMacroExpress()
    IF (Experiment.Misc.Mode <> "demo") THEN
        OPEN "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\Shutdown.txt" FOR OUTPUT AS #1
        PRINT #1, ""
        CLOSE #1

        FILECOPY "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\Shutdown.txt", "X:\Semaphores\Shutdown\Shutdown.txt"
    END IF
END SUB

SUB DeleteMacroTextFiles()
    'IF ISFILE("\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues.txt") THEN
        KILL "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues.txt"
    'END IF
    'IF ISFILE(\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\Create\MacroValues2.txt") THEN
        KILL "\\DOPSBIOSEMI-PC\Dops_Experiments\Semaphores\Create\MacroValues2.txt"
    'END IF
    'IF ISFILE("\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\ActiviewStart\MacroValues.txt") THEN
        KILL "\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\ActiviewStart\MacroValues.txt"
    'END IF
    'IF ISFILE("\\DOPSBIOSEMI-PC\DOPS_Experiments\Semaphores\BiosemiRecord\MacroValues2.txt") THEN
        KILL "\\DOPSBIOSEMI-PC\Dops_Experiments\Semaphores\BiosemiRecord\MacroValues2.txt"
    'END IF
    'IF ISFILE("\\DOPSBIOSEMI-PC\DOPS_Experiments\BDFFiles\" + EXPERIMENT.SessionDescription.BDFFile) THEN
        KILL "\\DOPSBIOSEMI-PC\DOPS_Experiments\BDFFiles\" + EXPERIMENT.SessionDescription.BDFFile
    'END IF
END SUB

FUNCTION GetPowerTimeTotalMillis(MyTime AS IPOWERTIME) AS LONG
    LOCAL millis AS LONG
    LOCAL tempDateTime AS STRING

    millis = (MyTime.Hour() * 60 * 60 * 1000) + (MyTime.Minute() * 60 * 1000) + (MyTime.Second() * 1000) + MyTime.MSecond()

    FUNCTION = millis

END FUNCTION

FUNCTION PowerTimeDateTime(MyTime AS IPOWERTIME) AS STRING
    LOCAL tempDateTime AS STRING

    tempDateTime = TRIM$(FORMAT$(MyTime.Day(), "00")) + " " + TRIM$(MID$(MyTime.MonthString(), 1, 3)) + " " + TRIM$(STR$(MyTime.Year())) + _
                                            " " + TRIM$(FORMAT$(MyTime.Hour(), "00")) + ":" + TRIM$(FORMAT$(MyTime.Minute(), "00")) + _
                                            ":" + TRIM$(FORMAT$(MyTime.Second(), "00")) + "." + TRIM$(FORMAT$(MyTime.MSecond(), "000"))
    FUNCTION = tempDateTime

END FUNCTION

FUNCTION monthName(month AS STRING) AS STRING
    LOCAL mName AS STRING

    SELECT CASE month
        CASE "01"
            mName = "Jan"
        CASE "02"
            mName = "Feb"
        CASE "03"
            mName = "Mar"
        CASE "04"
            mName = "Apr"
        CASE "05"
            mName = "May"
        CASE "06"
            mName = "Jun"
        CASE "07"
            mName = "Jul"
        CASE "08"
            mName = "Aug"
        CASE "09"
            mName = "Sep"
        CASE "10"
            mName = "Oct"
        CASE "11"
            mName = "Nov"
        CASE "12"
            mName = "Dec"
        CASE ELSE
            mName = "Unk"
    END SELECT

    FUNCTION = mName
END FUNCTION

SUB DebugLog(str AS STRING)
    LOCAL MyTime AS IPOWERTIME

    LET MyTime = CLASS "PowerTime"
    MyTime.Now()
    OPEN "debug.log" FOR APPEND AS #1
    PRINT #1, str + ": " + PowerTimeDateTime(MyTime)
    CLOSE #1
END SUB





FUNCTION RenameAndMoveFiles() AS INTEGER
    LOCAL temp, filename, headerFilename, eventFilename, bdfFilename, etrFilename AS STRING
    LOCAL currentDir AS STRING

    currentDir = CURDIR$

    filename = LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4)


    bdfFilename = "\\DOPSBIOSEMI-PC\DOPS_Experiments\BDFFiles\" + filename + ".BDF"
    etrFilename = "\\DOPSBIOSEMI-PC\DOPS_Experiments\ElectrodePositionFiles\bs64.etr"

    ON ERROR GOTO errorTrap

    CHDRIVE "E:"

    CHDIR "Experiment Data v2\Subject_Data\" + EXPERIMENT.SessionDescription.Subject

    FILECOPY currentDir + "\" + EXPERIMENT.SessionDescription.HDRFile, EXPERIMENT.SessionDescription.HDRFile
    FILECOPY currentDir + "\" + EXPERIMENT.SessionDescription.EventFile, EXPERIMENT.SessionDescription.EventFile
    FILECOPY bdfFilename, EXPERIMENT.SessionDescription.BDFFile
    FILECOPY etrFilename, EXPERIMENT.SessionDescription.ElectrodeFile
    'filecopy "C:\DOPS_Experiments\RecordFiles\

    FUNCTION = 1

    errorTrap:
        MSGBOX ERROR$
        FUNCTION = -1
END FUNCTION

FUNCTION orderOfMagnitude(num AS DOUBLE) AS DOUBLE
    LOCAL negFlag AS BYTE
    LOCAL x, l AS LONG
    LOCAL temp AS STRING

    negFlag = 0
    temp = STR$(num)
    IF (LEFT$(temp, 1) = "-") THEN
        negFlag = 1
    temp = RIGHT$(temp, LEN(temp) - 1)
    END IF

    x = INSTR(temp, ".")
    IF (x = 0) THEN
        l = LEN(temp) - 1
    ELSE
        l = LEN(LEFT$(temp, x - 1)) - 1
    END IF

    IF (negFlag = 1) THEN
        l = l * -1
    END IF

    FUNCTION = l
END FUNCTION

FUNCTION sumBitsOfByte(sample AS BYTE) AS INTEGER
    LOCAL temp AS STRING
    LOCAL lSample AS LONG

    temp = BIN$(sample)
    lSample = VAL(MID$(temp, 1, 1)) + VAL(MID$(temp, 2, 1)) + VAL(MID$(temp, 3, 1)) + VAL(MID$(temp, 4, 1)) + _
                VAL(MID$(temp, 5, 1)) + VAL(MID$(temp, 6, 1)) + VAL(MID$(temp, 7, 1)) + VAL(MID$(temp, 8, 1))

    FUNCTION = lSample
END FUNCTION

FUNCTION remapForTrackBar(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
    LOCAL decFlag AS BYTE
    LOCAL retVal AS DOUBLE
    LOCAL dMax2 AS DOUBLE

    IF (dMin1 > 0 AND dMin1 < 1) THEN
        decFlag = 1
        dMax2 = (dMax1 / dMin1)
    ELSE
        decFlag = 0
        dMax2 = dMax1 - dMin1
    END IF

    IF (decFlag = 0) THEN
        retVal = remapLong(value, dMin1, dMax1, dMin2, dMax2)
        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    ELSE
        retVal = remapDouble(value, dMin1, dMax1, dMin2, dMax2)
        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    END IF

    FUNCTION = retVal


END FUNCTION

FUNCTION remapForTrackBarReverse(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
    LOCAL decFlag AS BYTE
    LOCAL retVal AS DOUBLE
    LOCAL dMax2 AS DOUBLE

    IF (dMin1 > 0 AND dMin1 < 1) THEN
        decFlag = 1
        dMax2 = (dMax1 / dMin1)
    ELSE
        decFlag = 0
        dMax2 = dMax1 - dMin1
    END IF

    IF (decFlag = 0) THEN
        retVal = remapLong(value, dMin2, dMax2, dMin1, dMax1)
        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    ELSE
        retVal = remapDouble(value, dMin2, dMax2, dMin1, dMax1)
        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    END IF

    FUNCTION = retVal


END FUNCTION


FUNCTION remapLong(BYVAL x AS LONG, BYVAL oMin AS LONG, BYVAL oMax AS LONG, BYVAL nMin AS LONG, BYVAL nMax AS LONG) AS LONG
    LOCAL reverseInput, reverseOutput AS BYTE
    LOCAL oldMin, oldMax, newMin, newMax AS LONG
    LOCAL portion, result AS DOUBLE

    '#range check
    IF (oMin = oMax) THEN
        MSGBOX "Warning: Zero input range"
        FUNCTION = -99999999
    END IF

    IF (nMin = nMax) THEN
        MSGBOX "Warning: Zero output range"
        FUNCTION = -99999999
    END IF

    '#check reversed input range
    reverseInput = 0
    oldMin = MIN( oMin, oMax )
    oldMax = MAX( oMin, oMax )
    IF (oldMin <> oMin) THEN
        reverseInput = 1
    END IF

    '#check reversed output range
    reverseOutput = 0
    newMin = MIN( nMin, nMax )
    newMax = MAX( nMin, nMax )
    IF (newMin <> nMin) THEN
        reverseOutput = 1
    END IF

    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
    IF (reverseInput = 1) THEN
        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
    END IF

    result = portion + newMin
    IF (reverseOutput = 1) THEN
        result = newMax - portion
    END IF

    FUNCTION = result
END FUNCTION

FUNCTION remapDouble(BYVAL x AS DOUBLE, BYVAL oMin AS DOUBLE, BYVAL oMax AS DOUBLE, BYVAL nMin AS DOUBLE, BYVAL nMax AS DOUBLE) AS DOUBLE
    LOCAL reverseInput, reverseOutput AS BYTE
    LOCAL oldMin, oldMax, newMin, newMax AS DOUBLE
    LOCAL portion, result AS DOUBLE

    '#range check
    IF (oMin = oMax) THEN
        MSGBOX "Warning: Zero input range"
        FUNCTION = -99999999
    END IF

    IF (nMin = nMax) THEN
        MSGBOX "Warning: Zero output range"
        FUNCTION = -99999999
    END IF

    '#check reversed input range
    reverseInput = 0
    oldMin = MIN( oMin, oMax )
    oldMax = MAX( oMin, oMax )
    IF (oldMin <> oMin) THEN
        reverseInput = 1
    END IF

    '#check reversed output range
    reverseOutput = 0
    newMin = MIN( nMin, nMax )
    newMax = MAX( nMin, nMax )
    IF (newMin <> nMin) THEN
        reverseOutput = 1
    END IF

    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
    IF (reverseInput = 1) THEN
        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
    END IF

    result = portion + newMin
    IF (reverseOutput = 1) THEN
        result = newMax - portion
    END IF

    FUNCTION = result
END FUNCTION

FUNCTION SetTopMostWindow(hwnd AS DWORD, Topmost AS BYTE) AS BYTE
    LOCAL result AS BYTE

    IF (Topmost = 1) THEN 'Make the window topmost
        result = SetWindowPos(hwnd, %HWND_TOPMOST, 0, 0, 0, 0, %SWP_NOMOVE OR %SWP_NOSIZE)
    ELSE
        result = SetWindowPos(hwnd, %HWND_NOTOPMOST, 0, 0, 0, 0, %SWP_NOMOVE OR %SWP_NOSIZE)
    END IF

    FUNCTION = result
END FUNCTION

SUB writeTrialSemaphore(filename AS STRING, trialNbr AS LONG)

    '=====================================================================
        'added 5/1/2014 per Ross Dunseath - we're writing the trial number
        'to a network drive. A program on another machine will be checking
        'this file to see the experiment progress.
        '=====================================================================
        OPEN filename FOR OUTPUT ACCESS WRITE LOCK SHARED  AS #100
        PRINT #100, STR$(trialNbr)
        CLOSE #100
END SUB

SUB AbortProgram()
    LOCAL temp AS STRING

    OPEN "C:\DOPS_Experiments\ZZZFlashdrive\KillTask.bat" FOR OUTPUT AS #777

    PRINT #777, "TaskKill /IM " + EXE.NAME$ + ".exe /F"
    PRINT #777, "TaskKill /IM EEGSettingsScreen.exe /F"

    CLOSE #777

    temp = "C:\DOPS_Experiments\ZZZFlashdrive\KillTask.bat"

    SHELL temp, 1
END SUB
