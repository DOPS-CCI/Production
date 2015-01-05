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
'#RESOURCE "ExptCheckList.pbr"
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
%IDD_DIALOG_ExptCheckList =  7101
%IDC_CHECKBOX_Batteries   = 7102
%IDC_CHECKBOX_Macro       = 7103
%IDC_CHECKBOX_SRMonitor   = 7104
%IDC_CHECKBOX_SRFan       = 7105
%IDC_CHECKBOX_SRLights    = 7106
%IDC_CHECKBOX_Temperature = 7107
%IDC_BUTTON_EXPTOK            = 7108
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL ghDlgExptCheckList   AS DWORD

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOGExptCheckListProc()
DECLARE FUNCTION ShowDIALOGExptCheckList(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOGExptCheckListProc()
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
                CASE %IDC_CHECKBOX_Batteries

                CASE %IDC_CHECKBOX_Macro

                CASE %IDC_CHECKBOX_SRMonitor

                CASE %IDC_CHECKBOX_SRFan

                CASE %IDC_CHECKBOX_SRLights

                CASE %IDC_CHECKBOX_Temperature

                CASE %IDC_BUTTON_EXPTOK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        lCheckCnt = 0
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_Batteries TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_Macro TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_SRMonitor TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_SRFan TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_SRLights TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF
                        CONTROL GET CHECK ghDlgExptCheckList, %IDC_CHECKBOX_Temperature TO lResult
                        IF (lResult = 1) THEN
                            INCR lCheckCnt
                        END IF

                        IF (lCheckCnt = 6) THEN
                            DIALOG END ghDlgExptCheckList, 1
                        ELSE
                            MSGBOX "Not all the items have been checked."
                        END IF
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOGExptCheckList(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_ExptCheckList->->
    GLOBAL ghDlgExptCheckList   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW hParent, "Experiment Startup Checklist", 70, 70, 396, 275, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_CENTER OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT _
        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO ghDlgExptCheckList
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_Batteries, "Batteries are " + _
        "turned on.", 20, 40, 220, 25
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_Macro, "Macro Express Pro is " + _
        "running on Biosemi computer.", 20, 65, 355, 25
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_SRMonitor, "Shielded Room " + _
        "monitor is on and volume is up.", 20, 90, 355, 25
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_SRFan, "Shielded Room fan is " + _
        "on.", 20, 115, 355, 25
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_SRLights, "Shielded Room lights " + _
        "are on.", 20, 140, 355, 25
    CONTROL ADD CHECKBOX, ghDlgExptCheckList, %IDC_CHECKBOX_Temperature, "Temperature is no " + _
        "higher than 74.", 20, 165, 355, 25
    CONTROL ADD BUTTON,   ghDlgExptCheckList, %IDC_BUTTON_EXPTOK, "OK", 155, 220, 80, 35

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 14, 1, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT ghDlgExptCheckList, -1, hFont1
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_Batteries, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_Macro, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_SRMonitor, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_SRFan, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_SRLights, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_CHECKBOX_Temperature, hFont2
    CONTROL SET FONT ghDlgExptCheckList, %IDC_BUTTON_EXPTOK, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL ghDlgExptCheckList, CALL ShowDIALOGExptCheckListProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_ExptCheckList
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
