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

'#COMPILE EXE
'#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
'#RESOURCE "SoundCheck.pbr"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG_SoundCheck    = 7201
%IDC_BUTTON_SoundCheckOK  = 7208
%IDC_BUTTON_SoundCheckTest = 7209
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL ghDlgSoundCheck   AS DWORD

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOGSoundCheckProc()
DECLARE FUNCTION ShowDIALOGSoundCheck(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOGSoundCheckProc()
    LOCAL lResult, lCheckCnt AS LONG

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

                CASE %IDC_BUTTON_SoundCheckOK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END ghDlgSoundCheck, 1
                    END IF
                CASE %IDC_BUTTON_SoundCheckTest
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        PlaySound "FOCUS_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE 'OR %SND_ASYNC

                        PlaySound "REST_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE 'OR %SND_ASYNC

                        PlaySound "UPBEAT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE 'OR %SND_ASYNC

                        PlaySound "NORMAL_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE 'OR %SND_ASYNC
                    END IF
            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOGSoundCheck(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_SoundCheck->->
    'LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Sound Check", 70, 70, 291, 107, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR _
        %DS_MODALFRAME OR %DS_CENTER OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO ghDlgSoundCheck
    CONTROL ADD BUTTON, ghDlgSoundCheck, %IDC_BUTTON_SoundCheckOK, "OK", 150, 45, 80, 35
    CONTROL ADD BUTTON, ghDlgSoundCheck, %IDC_BUTTON_SoundCheckTest, "Test Sounds", 50, 45, _
        80, 35

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT ghDlgSoundCheck, -1, hFont1
    CONTROL SET FONT ghDlgSoundCheck, %IDC_BUTTON_SoundCheckOK, hFont1
    CONTROL SET FONT ghDlgSoundCheck, %IDC_BUTTON_SoundCheckTest, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL ghDlgSoundCheck, CALL ShowDIALOGSoundCheckProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_SoundCheck
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
