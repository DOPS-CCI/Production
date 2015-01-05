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


'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE "NoName.pbr"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1             =  101
%IDC_TEXTBOX_NbrOfRuns   = 1001
%TEXTBOX_NBRTRIALS       = 1002
%TEXTBOX_SUBJECTID       = 1003
%TEXTBOX_ITDURATION      = 1004
%IDC_BUTTON_AudioChoices = 1005
%IDC_BUTTON_EEGSettings  = 1006
%BUTTON_HELPEROK         = 1007
%BUTTON_HELPERCANCEL     = 1008
%BUTTON_HELP             = 1009
%IDC_LABEL_01            = 1010
%IDC_LABEL_02            = 1011
%IDC_LABEL_04            = 1012
%IDC_LABEL_05            = 1013
%IDC_BUTTON_LongDesc     = 1014
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
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
                CASE %IDC_TEXTBOX_NbrOfRuns

                CASE %TEXTBOX_NBRTRIALS

                CASE %TEXTBOX_SUBJECTID

                CASE %TEXTBOX_ITDURATION

                CASE %IDC_BUTTON_AudioChoices
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_AudioChoices=" + _
                            FORMAT$(%IDC_BUTTON_AudioChoices), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EEGSettings
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EEGSettings=" + _
                            FORMAT$(%IDC_BUTTON_EEGSettings), %MB_TASKMODAL
                    END IF

                CASE %BUTTON_HELPEROK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%BUTTON_HELPEROK=" + _
                            FORMAT$(%BUTTON_HELPEROK), %MB_TASKMODAL
                    END IF

                CASE %BUTTON_HELPERCANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%BUTTON_HELPERCANCEL=" + _
                            FORMAT$(%BUTTON_HELPERCANCEL), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_LongDesc
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_LongDesc=" + _
                            FORMAT$(%IDC_BUTTON_LongDesc), %MB_TASKMODAL
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, hParent, "Enter parameters", 336, 225, 279, 314, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_NbrOfRuns, "1", 128, 24, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_NBRTRIALS, "24", 129, 60, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_SUBJECTID, "9999", 129, 98, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_ITDURATION, "180000", 129, 136, 100, _
        20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_AudioChoices, "Audio Choices", 80, _
        208, 120, 24
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_EEGSettings, "EEG Settings", 80, _
        240, 120, 24
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELPEROK, "OK", 33, 278, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING
    DIALOG  SEND         hDlg, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELPERCANCEL, "Cancel", 124, 278, 75, _
        23
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELP, "?", 224, 277, 24, 24
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_01, "Number of trials:", 46, 64, _
        83, 13
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_02, "Subject ID:", 69, 102, 60, 13
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_04, "Trial duration (ms):", 28, _
        140, 96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_05, "Number of runs:", 45, 28, 83, _
        13
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_LongDesc, "Long Description", 80, _
        176, 120, 24
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
