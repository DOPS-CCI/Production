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
#RESOURCE "GenericASCWithSpeechAndStopWatch_DDT.pbr"
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
%IDC_FRAME1                     = 1001
%IDC_BUTTON_ENDEPOCH            = 1002
%IDC_BUTTON_SPECIALEVENT        = 1003
%IDC_TEXTBOX_SPECIAL_EVENT      = 1004
%IDC_LABEL1                     = 1005
%IDC_BUTTON_ENDEXPERIMENT       = 1006
%IDC_BUTTON_EVENT01             = 1007
%IDC_BUTTON_EVENT02             = 1008
%IDC_BUTTON_EVENT03             = 1009
%IDC_BUTTON_EVENT04             = 1010
%IDC_BUTTON_EVENT05             = 1011
%IDC_BUTTON_EVENT06             = 1012
%IDC_BUTTON_EVENT07             = 1013
%IDC_BUTTON_EVENT08             = 1014
%IDC_BUTTON_EVENT09             = 1015
%IDC_BUTTON_EVENT10             = 1016
%IDC_BUTTON_EVENT11             = 1018
%IDC_BUTTON_EVENT12             = 1017
%ID_OK                          = 2001
%IMAGE_PD                       = 2001
%IMAGE_BACK                     = 2002
%IMAGE_PROCEED                  = 2003
%CHECKBOX_DIO_PRESENT           = 2015
%FRAME_PHOTODIODE               = 2018
%ID_CONTROLLER_OK               = 2019
%ID_CONTROLLER_EXIT             = 2023
%TEXTBOX_SUBJECTID              = 9901
%IDC_9903                       = 9903
%IDC_9905                       = 9905
%TEXTBOX_COMMENT                = 9909
%BUTTON_HELPEROK                = 9910
%BUTTON_HELPERCANCEL            = 9911
%BUTTON_HELP                    = 9912
%IDC_LABEL_GROUP_VARIABLE       = 9913
%IDC_LABEL_DESCRIPTION          = 9916
%IDC_FRAME_SET_LEVELS           = 9917
%IDC_LABEL2                     = 9918
%IDC_LABEL3                     = 9919
%IDC_LABEL4                     = 9921
%IDC_BUTTON_GVADD               = 9923
%IDC_BUTTON_GVDELETE            = 9924
%IDC_TEXTBOX_GROUPVAR_DESC      = 9915
%IDC_TEXTBOX_GROUPVAR           = 9914
%IDC_TEXTBOX_GV_CONDITION_LEVEL = 9918
%IDC_TEXTBOX_GV_CONDITION_VALUE = 9920
%IDC_LISTBOX_GV_CONDITIONS      = 9922
%IDC_FRAME2                     = 9925
%IDC_LINE1                      = 9926
%IDC_LINE2                      = 9927
%IDC_LABEL_FRAME                = 9928
%IDC_TEXTBOX_DESCRIPTION        = 9929
%IDC_LABEL5                     = 9930
%IDC_LABEL_STOPWATCH            = 9931
%SVSFlagsAsync                  =    1
%TRUE                           =    1
%FALSE                          =    0
%IDD_DIALOG1                    =  101
%IDD_DIALOG2                    =  102
%IDD_DIALOG3                    =  103
%IDD_DIALOG4                    =  104
%IDC_CHECKBOX_speech            = 9932
%IDC_LABEL_NoteMessage          = 1005  '*
%IDC_LISTBOX_SPECIALNOTES       = 9933
%IDC_BUTTON_ADD_COMMENTS        = 9934
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE CALLBACK FUNCTION ShowDIALOG2Proc()
DECLARE CALLBACK FUNCTION ShowDIALOG3Proc()
DECLARE CALLBACK FUNCTION ShowDIALOG4Proc()
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
DECLARE FUNCTION ShowDIALOG2(BYVAL hParent AS DWORD) AS LONG
DECLARE FUNCTION ShowDIALOG3(BYVAL hParent AS DWORD) AS LONG
DECLARE FUNCTION ShowDIALOG4(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
    ShowDIALOG2 %HWND_DESKTOP
    ShowDIALOG3 %HWND_DESKTOP
    ShowDIALOG4 %HWND_DESKTOP
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
                CASE %ID_CONTROLLER_OK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%ID_CONTROLLER_OK=" + _
                            FORMAT$(%ID_CONTROLLER_OK), %MB_TASKMODAL
                    END IF

                CASE %ID_CONTROLLER_EXIT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%ID_CONTROLLER_EXIT=" + _
                            FORMAT$(%ID_CONTROLLER_EXIT), %MB_TASKMODAL
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG2Proc()

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
                CASE %TEXTBOX_SUBJECTID

                CASE %IDC_TEXTBOX_DESCRIPTION

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

                CASE %IDC_TEXTBOX_GROUPVAR

                CASE %IDC_TEXTBOX_GROUPVAR_DESC

                CASE %IDC_LISTBOX_GV_CONDITIONS

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG3Proc()

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

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG4Proc()

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
                ' /* Inserted by PB/Forms 04-17-2012 08:02:54
                CASE %IDC_BUTTON_ADD_COMMENTS
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_ADD_COMMENTS=" + _
                            FORMAT$(%IDC_BUTTON_ADD_COMMENTS), %MB_TASKMODAL
                    END IF
                ' */

                ' /* Inserted by PB/Forms 04-06-2012 09:33:56
                CASE %IDC_LISTBOX_SPECIALNOTES
                ' */

                CASE %IDC_BUTTON_EVENT01
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT01=" + _
                            FORMAT$(%IDC_BUTTON_EVENT01), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT07
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT07=" + _
                            FORMAT$(%IDC_BUTTON_EVENT07), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT02
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT02=" + _
                            FORMAT$(%IDC_BUTTON_EVENT02), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT08
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT08=" + _
                            FORMAT$(%IDC_BUTTON_EVENT08), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT03
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT03=" + _
                            FORMAT$(%IDC_BUTTON_EVENT03), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT09
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT09=" + _
                            FORMAT$(%IDC_BUTTON_EVENT09), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT04
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT04=" + _
                            FORMAT$(%IDC_BUTTON_EVENT04), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT10
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT10=" + _
                            FORMAT$(%IDC_BUTTON_EVENT10), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT05
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT05=" + _
                            FORMAT$(%IDC_BUTTON_EVENT05), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT11
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT11=" + _
                            FORMAT$(%IDC_BUTTON_EVENT11), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT06
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT06=" + _
                            FORMAT$(%IDC_BUTTON_EVENT06), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_EVENT12
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_EVENT12=" + _
                            FORMAT$(%IDC_BUTTON_EVENT12), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_ENDEXPERIMENT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_ENDEXPERIMENT=" + _
                            FORMAT$(%IDC_BUTTON_ENDEXPERIMENT), _
                            %MB_TASKMODAL
                    END IF

                CASE %IDC_CHECKBOX_speech

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG

    FOR i = 1 TO lCount
        LISTBOX ADD hDlg, lID, USING$("Test Item #", i)
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, hParent, "Controller Screen", 10, 10, 1200, 800, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
    CONTROL ADD BUTTON, hDlg, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, _
        150, 25
    CONTROL ADD BUTTON, hDlg, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, _
        388, 150, 25
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION ShowDIALOG2(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG2->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

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

    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
#PBFORMS END DIALOG

    SampleListBox  hDlg, %IDC_LISTBOX_GV_CONDITIONS, 30

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG2Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG2
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION ShowDIALOG3(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG3->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, hParent, "", 10, 10, 1200, 800, %WS_POPUP OR _
        %WS_BORDER OR %WS_VISIBLE OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG3Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION ShowDIALOG4(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG4->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, hParent, "Altered States of Consciousness (ASC)", 105, _
        113, 1200, 800, TO hDlg
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT01, "", 336, 104, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT07, "", 336, 312, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT02, "", 528, 104, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT08, "", 528, 312, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT03, "", 720, 104, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT09, "", 720, 312, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT04, "", 336, 208, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT10, "", 336, 416, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT05, "", 528, 208, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT11, "", 528, 416, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT06, "", 720, 208, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EVENT12, "", 720, 416, 176, 96
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ENDEXPERIMENT, "End Experiment", _
        512, 752, 136, 40
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "States", 312, 72, 616, 456
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_STOPWATCH, "", 312, 40, 616, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_speech, "Speech synthesis", _
        536, 538, 176, 24
    ' %WS_GROUP...
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_SPECIALNOTES, , 312, 584, 616, _
        136, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR _
        %WS_VSCROLL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ADD_COMMENTS, "Add Comments", _
        968, 624, 104, 40

    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 10, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT01, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT07, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT02, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT08, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT03, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT09, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT04, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT10, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT05, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT11, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT06, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EVENT12, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_ENDEXPERIMENT, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_STOPWATCH, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_speech, hFont2
    CONTROL SET FONT hDlg, %IDC_LISTBOX_SPECIALNOTES, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_ADD_COMMENTS, hFont2
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG4Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG4
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------


#PBFORMS COPY
'==============================================================================
'The following is a copy of your code before importing:
#IF 0
#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ASCGenericWithSpeechAndStopwatch.pbr"

#INCLUDE "Mersenne-Twister.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"


%IDC_FRAME1                = 1001
%IDC_BUTTON_ENDEPOCH       = 1002
%IDC_BUTTON_SPECIALEVENT   = 1003
%IDC_TEXTBOX_SPECIAL_EVENT = 1004
%IDC_LABEL1                = 1005
%IDC_BUTTON_ENDEXPERIMENT  = 1006
%IDC_BUTTON_EVENT01        = 1007
%IDC_BUTTON_EVENT02        = 1008
%IDC_BUTTON_EVENT03        = 1009
%IDC_BUTTON_EVENT04        = 1010
%IDC_BUTTON_EVENT05        = 1011
%IDC_BUTTON_EVENT06        = 1012
%IDC_BUTTON_EVENT07        = 1013
%IDC_BUTTON_EVENT08        = 1014
%IDC_BUTTON_EVENT09        = 1015
%IDC_BUTTON_EVENT10        = 1016
%IDC_BUTTON_EVENT11        = 1018
%IDC_BUTTON_EVENT12        = 1017


%ID_OK = 2001
%IMAGE_PD = 2001
%IMAGE_BACK = 2002
%IMAGE_PROCEED = 2003
%CHECKBOX_DIO_PRESENT = 2015
%FRAME_PHOTODIODE = 2018
%ID_CONTROLLER_OK = 2019
%ID_CONTROLLER_EXIT = 2023

%TEXTBOX_SUBJECTID              = 9901
%IDC_9903                       = 9903
%IDC_9905                       = 9905
%TEXTBOX_COMMENT                = 9909
%BUTTON_HELPEROK                = 9910
%BUTTON_HELPERCANCEL            = 9911
%BUTTON_HELP                    = 9912
%IDC_LABEL_GROUP_VARIABLE       = 9913
%IDC_LABEL_DESCRIPTION          = 9916
%IDC_FRAME_SET_LEVELS           = 9917
%IDC_LABEL2                     = 9918
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
%IDC_LABEL_FRAME                = 9928
%IDC_TEXTBOX_DESCRIPTION        = 9929
%IDC_LABEL5                     = 9930
%IDC_LABEL_STOPWATCH            = 9931

%SVSFlagsAsync = 1

MACRO xbox(x) = SLEEP 10

TYPE GlobalHandles
    DlgSubject AS DWORD
    DlgAgent AS DWORD
    DlgController AS DWORD
    DlgHelper AS DWORD
    DlgSubjectPhotoDiode AS DWORD
    DlgAgentPhotoDiode AS DWORD
END TYPE

TYPE Epoch
    Flag AS INTEGER
END TYPE

TYPE GlobalVariables
    Response AS LONG
    EndEpochResponse AS LONG
    Comment AS ASCIIZ * 255
    SubjectID AS LONG
    BoardNum AS LONG
    DioCardPresent AS LONG
    GreyCode AS LONG
    DioIndex AS LONG
    TargetTime AS ASCIIZ * 18
    hdl AS GlobalHandles
    EpochInfo(1 TO 12) AS Epoch
    timerInterval AS LONG
    buttonName AS ASCIIZ*20
    trialCnt AS INTEGER
    totalTime AS LONG
END TYPE

%TRUE = 1
%FALSE = 0


GLOBAL globals AS GlobalVariables



' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR %ICC_INTERNET_CLASSES)

    LOCAL hr AS DWORD
    LOCAL x AS LONG

    globals.timerInterval = 0
    globals.totalTime = 0
    globals.trialCnt = 0
    '****************************************************
    'initialize epoch flag - no one has pressed end epoch
    '****************************************************
    FOR x = 1 TO 12
        globals.EpochInfo(x).Flag = %FALSE
    NEXT x

   'Initialize Mersenne-twister
    init_MT_by_array()

    CALL dlgControllerScreen()

    DIALOG SHOW MODAL globals.hdl.DlgController, CALL cbControllerScreen TO hr


        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION

SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Controller Screen", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 1200, 800, %DS_CENTER OR %WS_OVERLAPPEDWINDOW, 0 TO globals.hdl.DlgController
    ' Use default styles
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, 150, 25,,, CALL cbControllerOK()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, 388, 150, 25,,, CALL cbControllerExit()

    DIALOG SET ICON globals.hdl.DlgController, "ASCGenericWithSpeechAndStopwatch.ico"
    CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_HIDE
END SUB

CALLBACK FUNCTION cbControllerScreen()
    LOCAL PS AS paintstruct

    SELECT CASE CB.MSG
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CB.CTL
                CASE %IDCANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END CB.HNDL, 0
                    END IF
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS

    END SELECT
END FUNCTION

CALLBACK FUNCTION cbControllerOK() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError, x, lResult AS LONG
    LOCAL sResult AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        EXPERIMENT.SessionDescription.INIFile = "ASCGenericWithSpeechAndStopwatch.ini"
        EXPERIMENT.SessionDescription.Date = DATE$
        EXPERIMENT.SessionDescription.Time = TIME$

        filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

        GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

        'check the DIO card
        GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", sResult, %MAXPPS_SIZE, filename)
        IF (LTRIM$(LCASE$(sResult)) = "yes" AND EXPERIMENT.Misc.Mode <> "demo") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)


        IF (Experiment.Misc.Mode = "demo") THEN
            WritePrivateProfileString( "Experiment Section", "Comment", "demo mode (" + DATE$ + " " + TIME$ + ")", filename)

            CALL LoadINISettings()

            CALL initializeEventFile()

            globals.DioCardPresent = 0


            CustomMessageBox(1, "Press OK to start Altered States Run.", "Start Run")

            CALL dlgSubjectScreen()

            DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult



            CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
            CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
            CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW




            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

            EXIT FUNCTION
        END IF

        CALL dlgControllerHelperScreen()
        DIALOG SHOW MODAL globals.hdl.DlgHelper, CALL cbControllerHelperScreen TO hr

        CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerExit() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL closeEventFile()

        DIALOG END CB.HNDL
        FUNCTION = 1
    END IF
END FUNCTION

SUB dlgControllerHelperScreen()
         #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    DIALOG NEW PIXELS, 0, "Enter parameters", 336, 234, 479, 632, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 66, 12, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, "", 64, 48, 384, 88, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_MULTILINE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL, "", 72, 272, _
        192, 24
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_VALUE, "", 72, 299, _
        56, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_GVADD, "&Add", 368, 347, 64, 32, , ,  CALL cbAddCondition
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_GVDELETE, "&Delete", 368, 391, 64, 32, , , CALL cbRemoveCondition
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_COMMENT, "", 16, 527, 448, 43
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 120, 599, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 211, 599, 75, 23, , ,CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 311, 598, 24, 24, , , CALL cbHelperScreenHelp
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME1, "Set Levels of ASC Condition " + _
        "Variables", 8, 251, 448, 224
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9903, "Subject ID:", 6, 16, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9905, "Initial comment:", 19, 512, 80, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL1, "Group Variable:", 2, 183, 80, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR, "ASCCondition", 88, _
        180, 192, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC, "The GV is used " + _
        "for generic ASC experiments.", 88, 207, 298, 24, %WS_CHILD OR _
        %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR %ES_AUTOHSCROLL OR _
        %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL2, "Description:", 10, 210, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL3, "Level:", 16, 275, 50, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL4, "Value:", 24, 302, 42, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LISTBOX, globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, , 16, 331, 320, _
        136, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LINE,    globals.hdl.DlgHelper, %IDC_LINE1, "Line1", 0, 167, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LINE,    globals.hdl.DlgHelper, %IDC_LINE2, "Line1", 0, 483, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL5, "Description:", 4, 52, 60, 13

#PBFORMS END DIALOG
    CONTROL SET FOCUS globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID
END SUB

CALLBACK FUNCTION cbControllerHelperScreen()
    LOCAL PS AS paintstruct
    LOCAL temp AS STRING
    LOCAL lError AS LONG

    SELECT CASE CB.MSG
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CB.CTL
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbAddCondition() AS LONG
    LOCAL condLevel, condValue AS STRING

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL TO condLevel
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_VALUE TO condValue
        LISTBOX ADD globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, condLevel + "," + condValue
        CONTROL SET FOCUS globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL
        'Highlights the text in the textbox
        CONTROL SEND globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL, %EM_SETSEL, 0, -1


        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbRemoveCondition() AS LONG
    LOCAL sel AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        LISTBOX GET SELECT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO sel
        LISTBOX DELETE globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, sel

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y, lbCount AS LONG
    LOCAL temp, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255

    EXPERIMENT.SessionDescription.INIFile = "ASCGenericWithSpeechAndStopwatch.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile




    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID TO temp
        lResult = WritePrivateProfileString( "Subject Section", "ID", temp, filename)
        globals.SubjectID = VAL(temp)
        IF (globals.SubjectID < 0 OR globals.SubjectID > 9999) THEN
            MSGBOX "Subject ID should be a number between 1 and 9999."
            EXIT FUNCTION
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION TO temp
        lResult = WritePrivateProfileString( "Experiment Section", "Description", temp, filename)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO temp
        WritePrivateProfileString( "Experiment Section", "Comment", temp + "(" + DATE$ + " " + TIME$ + ")", filename)

        '*****************************************************************************
        'Write out the conditions to the conditions file.
        '*****************************************************************************
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR TO temp
        tempFileName = filename
        REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\" + temp + ".txt" IN tempFileName
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC TO GVDesc

        OPEN tempFileName FOR OUTPUT AS #1
        PRINT #1, GVDesc

        LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount
        FOR x = 1 TO lbCount
            LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x TO temp
            PRINT #1, temp
        NEXT x

        'PRINT #1, "SpecialEvent, 88"
        'PRINT #1, "EndEpoch,99"
        PRINT #1, "xxx,999"

        CLOSE #1

        '*****************************************************************************
        CALL LoadINISettings()

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        'globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        'CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)


        DIALOG SHOW STATE globals.hdl.DlgHelper, %SW_HIDE

        CustomMessageBox(1, "Press OK to start ASC Run.", "Start Run")

        CALL dlgSubjectScreen()

        '*****************************************************************************
        'Create buttons out the conditions in the conditions file.
        '*****************************************************************************
        LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount
        FOR x = lbCount - 1 TO 0 STEP -1
            LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x + 1 TO temp
            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, LEFT$(temp, INSTR(temp, ",") - 1)
            CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, %SW_SHOW
        NEXT x

        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult



        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW




        'DO
        '    DIALOG DOEVENTS
        '    DIALOG GET SIZE ghDlgController TO x&, x&
        'LOOP WHILE x& ' When x& = 0, dialog has ended


        DIALOG END CB.HNDL
    END IF
END FUNCTION


CALLBACK FUNCTION cbHelperScreenCancel() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        DIALOG END CB.HNDL, 0
    END IF
END FUNCTION

CALLBACK FUNCTION cbHelperScreenHelp() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        SHELL("NOTEPAD.EXE HelpFile.txt")
    END IF
END FUNCTION

SUB dlgSubjectScreen()
    'DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1522, 831, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, 0, "Altered States of Consciousness (ASC)", 105, _
        113, 1200, 800, TO globals.hdl.DlgSubject
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01, "", 336, 104, 176, 96, , , CALL cbButtonEvent01
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT07, "", 336, 312, 176, 96, , , CALL cbButtonEvent07
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT02, "", 528, 104, 176, 96, , , CALL cbButtonEvent02
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT08, "", 528, 312, 176, 96, , , CALL cbButtonEvent08
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT03, "", 720, 104, 176, 96, , , CALL cbButtonEvent03
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT09, "", 720, 312, 176, 96, , , CALL cbButtonEvent09
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT04, "", 336, 208, 176, 96, , , CALL cbButtonEvent04
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT10, "", 336, 416, 176, 96, , , CALL cbButtonEvent10
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT05, "", 528, 208, 176, 96, , , CALL cbButtonEvent05
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT11, "", 528, 416, 176, 96, , , CALL cbButtonEvent11
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT06, "", 720, 208, 176, 96, , , CALL cbButtonEvent06
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT12, "", 720, 416, 176, 96, , , CALL cbButtonEvent12
    CONTROL ADD TEXTBOX, globals.hdl.DlgSubject, %IDC_TEXTBOX_SPECIAL_EVENT, "", 120, 608, 488, _
        96
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_SPECIALEVENT, "Special Event", 624, 609, 176, 96, , , CALL cbButtonEvent88
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_ENDEPOCH, "End of Epoch", 888, 609, 176, 96, , , CALL cbButtonEvent99
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, "End Experiment", 520, 744, 136, 40, , , CALL cbEndExperiment
    CONTROL ADD FRAME,   globals.hdl.DlgSubject, %IDC_FRAME1, "States", 312, 72, 616, 456
    'CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_FRAME, "", 320, 96, 600, 424
    'CONTROL SET COLOR    globals.hdl.DlgSubject, %IDC_LABEL_FRAME, -1, RGB(128, 128, 192)
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL1, "Enter text for Special Event", _
        121, 584, 216, 24
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, "", 312, 40, 616, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING

    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT07, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT02, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT08, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT03, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT09, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT04, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT10, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT05, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT11, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT06, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT12, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_SPECIALEVENT, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ENDEPOCH, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_FRAME1, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL1, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, hFont1



#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

     'globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)

     LOCAL x AS INTEGER
     FOR x = 0 TO 11
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, %SW_HIDE
     NEXT x


END SUB

CALLBACK FUNCTION cbSubjectScreen()
    DIM temp AS STRING

    SELECT CASE CB.MSG
        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
       CASE %WM_TIMER
                INCR globals.timerInterval
                temp = globals.buttonName
                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, "Count: " + STR$(globals.trialCnt) + "   Start " + temp + _
                            ": " +  STR$(globals.timerInterval)  + "   Total elapsed: " + STR$(globals.totalTime)
    END SELECT

END FUNCTION

CALLBACK FUNCTION cbEndExperiment
    CALL ButtonEvent99
    DIALOG END CB.HNDL
END FUNCTION


CALLBACK FUNCTION cbButtonEvent01
    globals.Response = 1

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent02
    globals.Response = 2

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent03
    globals.Response = 3

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent04
    globals.Response = 4

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent05
    globals.Response = 5

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent06
    globals.Response = 6

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent07
    globals.Response = 7

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent08
    globals.Response = 8

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent09
    globals.Response = 9

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent10
    globals.Response = 10

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent11
    globals.Response = 11

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent12
    globals.Response = 12

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent88
    CALL ButtonEvent99

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = GetTimeWithSeconds()
    EVENTSANDCONDITIONS(2).EvtName = "SpecialEvent"
    EVENTSANDCONDITIONS(2).NbrOfGVars = 0
    EVENTSANDCONDITIONS(2).Index = globals.DioIndex
    EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(2).Time = globals.TargetTime


    CONTROL GET TEXT globals.hdl.DlgSubject, %IDC_TEXTBOX_SPECIAL_EVENT TO globals.Comment

    EVENTSANDCONDITIONS(2).GVars(0).Condition = "Comment"
    EVENTSANDCONDITIONS(2).GVars(0).Desc = LookupLegitimateGVUnknown(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(0).Condition, globals.Comment)

     CALL WriteToEventFile2(2)
END FUNCTION

CALLBACK FUNCTION cbButtonEvent99
    CALL ButtonEvent99
END FUNCTION

SUB ButtonEvent99
    IF (hasAStartEpochOccured() = %TRUE) THEN
        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
        globals.TargetTime = GetTimeWithSeconds()
        EVENTSANDCONDITIONS(1).EvtName = "EndEpoch"
        EVENTSANDCONDITIONS(1).NbrOfGVars = 0
        EVENTSANDCONDITIONS(1).Index = globals.DioIndex
        EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(1).Time = globals.TargetTime


        EVENTSANDCONDITIONS(1).GVars(0).Condition = "ASCCondition"
        EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.EndEpochResponse)

        CALL WriteToEventFile2(1)
    END IF
END SUB

FUNCTION SubjectResponse() AS LONG
    DIM pid AS DWORD
    DIM temp AS STRING



    'IF (hasAStartEpochOccured() = %TRUE) THEN
        CALL ButtonEvent99
    'END IF

    globals.EpochInfo(globals.Response).Flag = %TRUE

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = GetTimeWithSeconds()
    EVENTSANDCONDITIONS(0).EvtName = "StartEpoch"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 0
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).Time = globals.TargetTime

    EVENTSANDCONDITIONS(0).GVars(0).Condition = "ASCCondition"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Response)

    CALL WriteToEventFile2(0)

    globals.buttonName =  EVENTSANDCONDITIONS(0).GVars(0).Desc
    speak("Start " + globals.buttonName)

    KillTimer globals.hdl.DlgSubject, &H3E8
    CALL SetTimer(globals.hdl.DlgSubject, BYVAL &H3E8, 1000, BYVAL %NULL)

    globals.totalTime = globals.totalTime + globals.timerInterval
    globals.trialCnt = globals.trialCnt + 1
    globals.timerInterval = 0

    FUNCTION = 0
END FUNCTION

FUNCTION hasAStartEpochOccured() AS INTEGER
    LOCAL x, flag AS INTEGER

    flag = %FALSE
    FOR x = 1 TO 12
        IF (globals.EpochInfo(x).Flag = %TRUE) THEN
            globals.EndEpochResponse = x
            globals.EpochInfo(x).Flag = %FALSE
            flag = %TRUE
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag
END FUNCTION

FUNCTION speak(a AS STRING) AS LONG
  DIM oSp AS DISPATCH                                         '// flag tells us when the talking is done
  DIM oVTxt AS VARIANT                                        '// text to speak
  DIM oVFlg AS VARIANT                                        '// flag to pass to the speech engine
  DIM buf AS LOCAL STRING                                     '// local working buffer
  SET oSp = NEW DISPATCH IN "SAPI.SpVoice.1"                  '// this is the module we want to point at
  IF ISFALSE ISOBJECT(oSp) THEN                               '// did we fail to load the requested object?
    MSGBOX "Speech engine failed to initialize!" '// tell someone we failed
    FUNCTION = 0                                              '// pass back our failure
    EXIT FUNCTION                                             '// leave, we can't do anything here
  END IF
  IF LEN(a) > 0 THEN                                          '// only speak if we have something to say
    oVTxt = a                                                 '// move dynamic string text into custom variable
    oVFlg = %SVSFlagsAsync                                    '// this is what we want the engine to do (talk)
    OBJECT CALL oSp.Speak(oVTxt, oVFlg)                       '// pass all of the info to the speecch engine
    buf = a                                                   '// make a copy because we will modify
    DO WHILE LEN(buf) > 0                                     '// loop while there something left in the buffer
      DO WHILE INSTR(buf, $CRLF) > 0
        xbox(LEFT$(buf, INSTR(buf, $CRLF) - 1))               '// show first part
        buf = MID$(buf, INSTR(buf, $CRLF) + 2)                '// clip off first part
      LOOP
      IF LEN(buf) > 0 THEN                                    '// is there anything left?
        xbox(buf)                                             '// show it
        buf = ""                                              '// clean out the buffer
      END IF
    LOOP
    DO                                                        '// Give the speech engine a chance to finish
      SLEEP 100                                               '// let other programs have some of our CPU time
      oVFlg = 100                                             '// set a starting point for our activity flag so we know if the following line changed it
      OBJECT CALL oSp.WaitUntilDone(oVFlg) TO oVFlg           '// ask the speech engine if it is done yet
    LOOP UNTIL VARIANT#(oVFlg)                                '// keep asking until we get our answer
  ELSE                                                        '// nothing to say?
    xbox(a)
  END IF
  SET oSp = NOTHING
END FUNCTION

#ENDIF
'==============================================================================

                                                                                                                                 

                                   