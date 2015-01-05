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
#RESOURCE "GenericASCHelper.pbr"
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
%IDD_DIALOG1                    =  101
%IDC_9900                       = 9900  '*
%TEXTBOX_NBRRUNS                = 9901
%IDC_9901                       = 9901  '*
%TEXTBOX_NBRTRIALS              = 9902
%IDC_9903                       = 9903
%TEXTBOX_SUBJECTID              = 9904
%IDC_9904                       = 9904  '*
%TEXTBOX_AGENTID                = 9905
%TEXTBOX_DISPLAYDURATION        = 9906
%TEXTBOX_ITDURATION             = 9907
%CHECKBOX_FEEDBACK              = 9908
%IDC_9905                       = 9905
%TEXTBOX_COMMENT                = 9909
%BUTTON_HELPEROK                = 9910
%BUTTON_HELPERCANCEL            = 9911
%BUTTON_HELP                    = 9912
%IDC_LABEL1                     = 9913
%IDC_LABEL2                     = 9916
%IDC_FRAME1                     = 9917
%IDC_LABEL3                     = 9919
%IDC_LABEL4                     = 9921
%IDC_BUTTON_GVADD               = 9923
%IDC_BUTTON_GVDELETE            = 9924
%IDC_TEXTBOX_GROUPVAR_DESC      = 9915
%IDC_TEXTBOX_GROUPVAR           = 9914
%IDC_TEXTBOX_GV_CONDITION_LEVEL = 9918
%IDC_TEXTBOX_GV_CONDITION_VALUE = 9920
%IDC_LISTBOX_GV_CONDITIONS      = 9922
%IDC_FRAME2                     = 9925  '*
%IDC_LINE1                      = 9926
%IDC_LINE2                      = 9927
%IDC_LABEL5                     = 9929
%IDC_TEXTBOX_DESCRIPTION        = 9928
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
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

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
                ' /* Inserted by PB/Forms 08-30-2011 07:50:51
                CASE %IDC_TEXTBOX_DESCRIPTION
                ' */

                ' /* Inserted by PB/Forms 08-25-2011 10:11:07
                CASE %IDC_TEXTBOX_GV_CONDITION_LEVEL

                CASE %IDC_TEXTBOX_GV_CONDITION_VALUE

                CASE %IDC_BUTTON_GVADD
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_GVADD=" + _
                            FORMAT$(%IDC_BUTTON_GVADD), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_GVDELETE
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_GVDELETE=" + _
                            FORMAT$(%IDC_BUTTON_GVDELETE), %MB_TASKMODAL
                    END IF

                CASE %IDC_TEXTBOX_GROUPVAR

                CASE %IDC_TEXTBOX_GROUPVAR_DESC

                CASE %IDC_LISTBOX_GV_CONDITIONS
                ' */

                ' /* Inserted by PB/Forms 04-22-2011 07:32:36
                CASE %TEXTBOX_NBRRUNS

                CASE %TEXTBOX_NBRTRIALS

                CASE %TEXTBOX_SUBJECTID

                CASE %TEXTBOX_AGENTID

                CASE %TEXTBOX_DISPLAYDURATION

                CASE %TEXTBOX_ITDURATION

                CASE %CHECKBOX_FEEDBACK

                CASE %TEXTBOX_COMMENT

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
                ' */


            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG
    LOCAL hDlg AS DWORD

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, hParent, "Enter parameters", 336, 234, 479, 632, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_SUBJECTID, "9999", 66, 12, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_DESCRIPTION, "", 64, 48, 384, 88, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_MULTILINE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GV_CONDITION_LEVEL, "", 72, 272, _
        192, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GV_CONDITION_VALUE, "", 72, 299, _
        56, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_GVADD, "&Add", 368, 347, 64, 32
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_GVDELETE, "&Delete", 368, 391, 64, _
        32
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_COMMENT, "", 16, 527, 448, 43
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELPEROK, "OK", 120, 599, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING
    DIALOG  SEND         hDlg, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELPERCANCEL, "Cancel", 211, 599, 75, _
        23
    CONTROL ADD BUTTON,  hDlg, %BUTTON_HELP, "?", 311, 598, 24, 24
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME1, "Set Levels of ASC Condition " + _
        "Variables", 8, 251, 448, 224
    CONTROL ADD LABEL,   hDlg, %IDC_9903, "Subject ID:", 6, 16, 60, 13
    CONTROL ADD LABEL,   hDlg, %IDC_9905, "Initial comment:", 19, 512, 80, 13
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Group Variable:", 2, 183, 80, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GROUPVAR, "ASCCondition", 88, _
        180, 192, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GROUPVAR_DESC, "The GV is used " + _
        "for generic ASC experiments.", 88, 207, 298, 24, %WS_CHILD OR _
        %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR %ES_AUTOHSCROLL OR _
        %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "Description:", 10, 210, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "Level:", 16, 275, 50, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL4, "Value:", 24, 302, 42, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_GV_CONDITIONS, , 16, 331, 320, _
        136, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LINE,    hDlg, %IDC_LINE1, "Line1", 0, 167, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LINE,    hDlg, %IDC_LINE2, "Line1", 0, 483, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL5, "Description:", 4, 52, 60, 13
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

              

              

              

              

              