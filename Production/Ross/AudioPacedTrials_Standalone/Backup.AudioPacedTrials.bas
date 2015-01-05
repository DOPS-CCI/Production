#PBFORMS CREATED V2.01
'------------------------------------------------------------------------------
' The first line in this file is a PB/Forms metastatement.
' It should ALWAYS be the first line of the file. Other
' PB/Forms metastatements are placed at the beginning and
' end of "Named Blocks" of code that should be edited
' with PBForms only. Do not manually edit or delete these
' metastatements or PB/Forms will not be able to reread
' the file correctly.  See the PB/Forms documentation for
' more information.
' Named blocks begin like this:    #PBFORMS BEGIN ...
' Named blocks end like this:      #PBFORMS END ...
' Other PB/Forms metastatements such as:
'     #PBFORMS DECLARATIONS
' are used by PB/Forms to insert additional code.
' Feel free to make changes anywhere else in the file.
'------------------------------------------------------------------------------

#COMPILE EXE
#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
''#RESOURCE "AudioPacedTrials.pbr"



%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1      =  101
%IDC_BUTTON_Start = 1001
#PBFORMS END CONSTANTS


'------------------------------------------------------------------------------
#RESOURCE ICON,     ResID, "AudioPacedTrials.ICO"
#RESOURCE WAVE,     FOCUS_WAV, "Focus.WAV"
#RESOURCE WAVE,     REST_WAV, "Rest.WAV"
'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

#INCLUDE "DOPS_MMTimers.inc"

GLOBAL hDlg AS DWORD
GLOBAL gCmdCnt, gNbrOfTrials, gTrialCnt, gTarget, gTrialLength AS LONG
GLOBAL gIntentionFocus() AS LONG
GLOBAL gWavFiles() AS STRING
GLOBAL gTrialOrder AS ASCIIZ * 256

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmdCnt AS LONG
    LOCAL temp AS STRING

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    gCmdCnt = 0
    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        gCmdCnt = PARSECOUNT(temp, " ")
        MSGBOX STR$(gCmdCnt)

        SELECT CASE gCmdCnt
            CASE 1
                gNbrOfTrials = VAL(COMMAND$(1))
                MSGBOX STR$(gNbrOfTrials)
                gTrialLength = 30000
                gTrialOrder = "2,1,1,2,"
            CASE 2
                gNbrOfTrials = VAL(COMMAND$(1))
                gTrialLength = VAL(COMMAND$(2))
                gTrialOrder = "2,1,1,2,"
            CASE 3
                gNbrOfTrials = VAL(COMMAND$(1))
                gTrialLength = VAL(COMMAND$(2))
                gTrialOrder = COMMAND$(3)
            CASE ELSE
                gNbrOfTrials = 100
                gTrialLength = 30000     '30 seconds
                gTrialOrder = "2,1,1,2,"
        END SELECT
    'ELSE
    '    MSGBOX "No experiment .HDR file name passed via the command line."
    '    EXIT FUNCTION  ' No command-line params given, just quit
    END IF




    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler

        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CB.WPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_Start
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL StartTrials()
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB StartTrial()
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL z, result AS LONG
    LOCAL resData AS WSTRINGZ * 127

    DIALOG SET TEXT hDlg, "Trial # " + STR$(gTrialCnt)
    'end if

    gTarget = gIntentionFocus(gTrialCnt)

    SELECT CASE gTarget
        CASE 1
            PlaySound "REST_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
            'PLAY WAVE "Sounds\Rest.wav", synch TO result
            'PLAY WAVE END
        CASE 2
            PlaySound "FOCUS_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
            'PLAY WAVE "Sounds\Focus.wav", synch TO result
            'PLAY WAVE END
    END SELECT

    'SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\" + gWavFiles(gTarget))
END SUB

FUNCTION EndTrial() AS LONG

    IF (gTrialCnt > gNbrOfTrials) THEN
        DIALOG SET TEXT hDlg, "The experiment is over."

        SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
        killMMTimerEvent()

        MSGBOX "The experiment is over."

        FUNCTION = 1

        EXIT FUNCTION
    END IF


    gTrialCnt = gTrialCnt + 1

    FUNCTION = 0
END FUNCTION


SUB StartTrials()
    LOCAL x, y, lenTrialOrder AS LONG
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers
    LOCAL audioOrder() AS STRING
    GLOBAL gIntentionFocus() AS LONG

    CONTROL DISABLE hDlg, %IDC_BUTTON_Start


    LET gTimers = CLASS "PowerCollection"


    gTimers.Add("ENDINTENTION", vTimers)
    'SetMMTimerDuration("ENDINTENTION", gTrialLength)


    gTrialCnt = 1

    REDIM gIntentionFocus(gNbrOfTrials)
    REDIM AudioOrder(20)


    PARSE gTrialOrder, AudioOrder(), ","
    lenTrialOrder = PARSECOUNT(gTrialOrder, ",") - 1

    y = 0
    FOR X = 1 TO gNbrOfTrials
        gIntentionFocus(x) =  VAL(AudioOrder(y))
        INCR y

        IF (x MOD lenTrialOrder = 0) THEN
            y = 0
            'ITERATE FOR
        END IF

        #DEBUG PRINT STR$(x) + ", " + STR$(gIntentionFocus(x))
    NEXT X

    CALL readInWavFiles()

    SetMMTimerDuration("ENDINTENTION", 10000)
    SetMMTimerOnOff("ENDINTENTION", 1)    'turn on

    'Start the timers
    setMMTimerEventPeriodic(1, 0)


END SUB

SUB DoWorkForEachTick()
'DON'T NEED TO DO ANYTHING - YET
END SUB


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL lResult, rndJitter, subPtr AS LONG
    LOCAL x AS LONG

    SELECT CASE itemName
        CASE "ENDINTENTION"
            CALL StartTrial()
            CALL EndTrial()
            SetMMTimerDuration("ENDINTENTION", gTrialLength)
            SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
    END SELECT
END SUB
'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Audio Paced Trials", 70, 70, 201, 121, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Start, "Start", 65, 45, 70, 30

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, -1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Start, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

SUB readInWavFiles()
    LOCAL cnt, Value AS LONG
    LOCAL Desc, LongDesc, WavFile AS STRING

    REDIM gWavFiles(20)
'
'    OPEN EXE.PATH$ + "Intention.txt" FOR INPUT AS #1
'
'    INPUT #1, LongDesc
'
'    cnt = 0
'    DO
'        INPUT# #1, Desc, Value, WavFile
'        IF (LCASE$(Desc) = "xxx" AND Value = 999) THEN
'            EXIT LOOP
'        END IF
'        cnt = cnt + 1
'        gWavFiles(cnt) = WavFile
'    LOOP
'
'    CLOSE #1

    gWavFiles(1) = "Rest.wav"
    gWavFiles(2) = "Focus.wav"

END SUB
