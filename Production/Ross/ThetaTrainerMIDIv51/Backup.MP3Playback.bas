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
#RESOURCE "MP3Playback.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "MP3Class.inc"
#INCLUDE "mmfcomm.inc"

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                  =  101
%IDC_BUTTON_GetMP3File        = 1001
%IDC_LABEL_MP3Filename        = 1002    '*
%IDC_BUTTON_Play              = 1003
%IDC_BUTTON_Pause             = 1004
%IDC_BUTTON_Stop              = 1005
%IDC_BUTTON_Resume            = 1006
%IDC_MSCTLS_TRACKBAR32_Volume = 1007
%IDC_LABEL1                   = 1008
%IDC_LABEL2                   = 1009
%IDC_TEXTBOX_Position         = 1010
%ID_TIMER                     = 1100
%ID_TIMER02                   = 1101
%IDC_LABEL_Status             = 1102
%IDC_LABEL3                   = 1104
%IDC_TEXTBOX_Length           = 1103
%IDC_LABEL4                   = 1105    '*
%IDC_LABEL5                   = 1106
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL hDlg, ghThread AS DWORD
GLOBAL mp3Filename AS STRING
GLOBAL gRemoteTrialsFile AS STRING
GLOBAL gHndTrackbarVolume AS DWORD
GLOBAL gVolume AS LONG
GLOBAL mp3 AS MyMP3Interface
GLOBAL mmfchannel AS MMFChannelType
GLOBAL pauseStopFlag AS BYTE

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmd AS STRING
    LOCAL result AS LONG

    LET mp3 = CLASS "MyMP3Class"
    pauseStopFlag = 0

    cmd = COMMAND$(1)

    IF (TRIM$(cmd) <> "") THEN

        mp3Filename = cmd
        'gRemoteTrialsFile = "I:\TrialInfo.txt"

        'create a memory-mapped file to
        'communicate between ThetaTrainer
        'and the MP3 Player
        CreateMMFChannel("COMMAND", mmfchannel)

        'THREAD CREATE WorkerThread(result) TO ghThread
    ELSE
        mp3Filename = ""
    END IF

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    'LET mp3 = CLASS "MyMP3Class"

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL mciReturn, uLength AS DWORD
    LOCAL  errorString AS ASCIIZ * 128
    LOCAL temp, cmd, parm, vol AS STRING
    LOCAL lVol, position, length, cmdLen AS LONG


    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            IF (TRIM$(mp3Filename) <> "") THEN
                SetTimer hDlg, %ID_TIMER, 15, %NULL
                SetTimer hDlg, %ID_TIMER02, 1000, %NULL
            END IF


            gHndTrackbarVolume = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_Volume)
            SendMessage(gHndTrackbarVolume, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 1000))  'min. & max. positions
            SendMessage(gHndTrackbarVolume, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
            gVolume = 500
            SendMessage(gHndTrackbarVolume, %TBM_SETPOS, %TRUE, gVolume)

            IF (TRIM$(mp3Filename) <> "") THEN
                mp3.IntializeMedia(mp3Filename)
                CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + mp3Filename
                mp3.OpenMedia()
                mp3.PlayMedia()
                mp3.AdjustMediaMasterVolume(10)
            END IF

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
        CASE %WM_HSCROLL
            IF (gHndTrackbarVolume = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gVolume > (1)) THEN
                            gVolume -= 1
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gVolume < (1000)) THEN
                            gVolume += 1
                        END IF
                    CASE %SB_THUMBTRACK
                        gVolume = HIWRD(CB.WPARAM)
                        'gEMGPitchSens = HIWRD(CB.WPARAM)/10
                    '    gEMGPitchSens = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
                END SELECT
                mp3.AdjustMediaLeftVolume(gVolume)
                mp3.AdjustMediaRightVolume(gVolume)
            END IF
        CASE %WM_TIMER
            SELECT CASE LOWRD(CB.WPARAM)
                CASE %ID_TIMER
                    temp = ReadMMFChannel(mmfchannel)
                    'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Command: " + temp
                    cmd = LEFT$(UCASE$(TRIM$(temp)), 2)
                    'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Command: " + cmd
                    cmdLen = LEN(temp)
                    IF (cmdLen > 2) THEN
                        parm = MID$(TEMP, 3 TO cmdLen)
                        'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Parm: " + parm
                    END IF


                    SELECT CASE cmd
                        CASE "VO"
                           vol = parm

                           lVol = VAL(vol)
                           gVolume = lVol
                           mp3.AdjustMediaMasterVolume(lVol)
                           PostMessage(hDlg, %WM_HSCROLL, %SB_THUMBTRACK, lVol)
                           'writePositionSemaphore(gRemoteTrialsFile, position)
                           #DEBUG PRINT "lVol: " + STR$(lVol)
                         CASE "QU"
                            'KillTimer hDlg, %ID_TIMER
                            'KillTimer hDlg, %ID_TIMER02
                            'DIALOG POST hDlg, %WM_CLOSE, 0, 0
                            DIALOG END hDlg, 0
                    END SELECT
                CASE %ID_TIMER02
                    IF (pauseStopFlag = 0) THEN
                        position = mp3.GetMediaPosition()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Position, FORMAT$((position / 1000), "000")
                        length = mp3.GetMediaLength()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Length, FORMAT$(length / (60 * 1000), "000.00")
                    END IF
            END SELECT

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                ' /* Inserted by PB/Forms 06-27-2014 08:03:15
                CASE %IDC_TEXTBOX_Length
                ' */

                ' /* Inserted by PB/Forms 06-24-2014 15:22:22
                'CASE %IDC_MSCTLS_TRACKBAR32_Volume

                CASE %IDC_TEXTBOX_Position
                ' */

                CASE %IDC_BUTTON_GetMP3File
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Get MP3 File", "", "*.mp3", _
                            "", "", 0 TO mp3Filename

                        IF (TRIM$(mp3Filename) <> "") THEN
                            CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Loaded " + mp3Filename
                            mp3.IntializeMedia(mp3Filename)
                        END IF

                    END IF

                CASE %IDC_BUTTON_Play
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        mp3.OpenMedia()
                        mp3.PlayMedia()
                        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + mp3Filename
                        mp3.AdjustMediaMasterVolume(gVolume)
                        pauseStopFlag = 0
                        SetTimer hDlg, %ID_TIMER02, 1000, %NULL
                    END IF

                CASE %IDC_BUTTON_Pause
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       pauseStopFlag = 1
                       CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Pausing " + mp3Filename
                       mp3.PauseMedia()
                    END IF

                CASE %IDC_BUTTON_Stop
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        pauseStopFlag = 1
                        mp3.StopMedia()
                        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Stopping " + mp3Filename
                        CONTROL DISABLE hDlg, %IDC_BUTTON_Resume

                    END IF

                CASE %IDC_BUTTON_Resume
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        pauseStopFlag = 0
                        mp3.ResumeMedia()
                    END IF


            END SELECT
    CASE %WM_DESTROY
        KillTimer hDlg, %ID_TIMER
        KillTimer hDlg, %ID_TIMER02
        mp3.CloseMedia()
        mp3 = NOTHING
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD

    DIALOG NEW hParent, "MP3 Player", 70, 70, 413, 169, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_GetMP3File, "Get MP3 file", 20, _
        10, 90, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Play, "Play", 145, 10, 50, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Pause, "Pause", 200, 10, 50, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Stop, "Stop", 255, 10, 50, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Resume, "Resume", 310, 10, 50, 25
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, _
        "msctls_trackbar32_1", 10, 80, 120, 20, %WS_CHILD OR %WS_VISIBLE OR _
        %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Volume", 10, 60, 65, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "Position", 5, 130, 45, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_Position, "0", 50, 125, 80, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_RIGHT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_Status, "", 5, 150, 405, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_Length, "0", 235, 125, 80, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_RIGHT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "ss", 135, 130, 95, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL5, "mm.ss", 316, 130, 95, 15

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial Narrow", 10, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT hDlg, %IDC_BUTTON_GetMP3File, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Play, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Pause, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Stop, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Resume, hFont1
    CONTROL SET FONT hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont2
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Position, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_Status, hFont3
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Length, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont2
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------


'
'FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG
'    LOCAL temp, cmd, vol AS STRING
'    LOCAL lVol, position AS LONG
'    GLOBAL mp3 AS MyMP3Interface
'
'    mp3.IntializeMedia(mp3Filename)
'    mp3.OpenMedia()
'    mp3.PlayMedia()
'    mp3.AdjustMediaMasterVolume(250)
'    position = mp3.GetMediaPosition()
'
'    'create a memory-mapped file to
'    'communicate between ThetaTrainer
'    'and the program
'    CreateMMFChannel("COMMAND", mmfchannel)
'
'    WHILE (1)
'        temp = ""
'
'        OPEN "C:\DOPS_Experiments\ZZZFlashdrive\MP3VolControl.txt"  FOR INPUT ACCESS READ LOCK SHARED  AS #1
'        LINE INPUT #1, temp
'        IF (TRIM$(temp) = "-999") THEN
'            EXIT LOOP
'        ELSE
'            lVol = VAL(temp)
'            gVolume = lVol
'            mp3.AdjustMediaMasterVolume(lVol)
'            position = mp3.GetMediaPosition()
'            CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Position, STR$(position)
'            'writePositionSemaphore(gRemoteTrialsFile, position)
'            #DEBUG PRINT "lVol: " + STR$(lVol)
'            'PostMessage(gHndTrackbarVolume, %SB_LINELEFT, 0, 0)
'        END IF
'
'        SLEEP 100
'        CLOSE #1
'    WEND
'
'
'    CLOSE #1
'END FUNCTION
'
'THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG
'
' FUNCTION = WorkerFunc(x)
'
'END FUNCTION
'
'SUB writePositionSemaphore(filename AS STRING, position AS LONG)
'
'    '=====================================================================
'    'added 5/1/2014 per Ross Dunseath - we're writing the trial number
'    'to a network drive. A program on another machine will be checking
'    'this file to see the experiment progress.
'    '=====================================================================
'    OPEN filename FOR OUTPUT ACCESS WRITE LOCK SHARED  AS #100
'    PRINT #100, STR$(position)
'    CLOSE #100
'END SUB
