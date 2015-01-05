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
#RESOURCE "TestMP3Playback.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "MP3Class.inc"
'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                  =  101
%IDC_BUTTON_GetMP3File        = 1001
%IDC_LABEL_MP3Filename        = 1002
%IDC_BUTTON_Play              = 1003
%IDC_BUTTON_Pause             = 1004
%IDC_BUTTON_Stop              = 1005
%IDC_BUTTON_Resume            = 1006
%IDC_MSCTLS_TRACKBAR32_Volume = 1007
%IDC_LABEL1                   = 1008
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL mp3Filename AS STRING
GLOBAL gHndTrackbarVolume AS DWORD
GLOBAL gVolume AS LONG
GLOBAL mp3 AS MyMP3Interface

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    LET mp3 = CLASS "MyMP3Class"

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL mciReturn, uLength AS DWORD
    LOCAL  errorString AS ASCIIZ * 128


    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            gHndTrackbarVolume = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_Volume)
            SendMessage(gHndTrackbarVolume, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 1000))  'min. & max. positions
            SendMessage(gHndTrackbarVolume, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
            gVolume = 500
            SendMessage(gHndTrackbarVolume, %TBM_SETPOS, %TRUE, gVolume)


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
        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_GetMP3File
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Get MP3 File", "", "*.mp3", _
                            "", "", 0 TO mp3Filename

                        IF (TRIM$(mp3Filename) <> "") THEN
                            CONTROL SET TEXT hDlg, %IDC_LABEL_MP3Filename, mp3Filename
                            mp3.IntializeMedia(mp3Filename)
                        END IF

                    END IF

                CASE %IDC_BUTTON_Play
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        mp3.OpenMedia()
                        mp3.PlayMedia()
                        mp3.AdjustMediaMasterVolume(gVolume)
                    END IF

                CASE %IDC_BUTTON_Pause
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       mp3.PauseMedia()
                    END IF

                CASE %IDC_BUTTON_Stop
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        mp3.StopMedia()
                        mp3.CloseMedia()
                    END IF

                CASE %IDC_BUTTON_Resume
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        mp3.ResumeMedia()
                    END IF


            END SELECT
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

    DIALOG NEW hParent, "Test MP3", 70, 70, 347, 143, %WS_POPUP OR %WS_BORDER _
        OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR %WS_MINIMIZEBOX OR _
        %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME _
        OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
        %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_GetMP3File, "Get MP3 file", 20, 20, _
        90, 25
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_MP3Filename, "", 130, 20, 185, 30
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Play, "Play", 30, 75, 40, 25
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Pause, "Pause", 30, 100, 40, 25
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Stop, "Stop", 70, 75, 40, 25
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Resume, "Resume", 70, 100, 40, 25
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, _
        "msctls_trackbar32_1", 165, 85, 120, 20, %WS_CHILD OR %WS_VISIBLE OR _
        %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL1, "Volume", 165, 65, 65, 15

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_BUTTON_GetMP3File, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_MP3Filename, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Play, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Pause, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Stop, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Resume, hFont1
    CONTROL SET FONT hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
