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
#RESOURCE "EEGSettingsScreen.pbr"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS 
%IDD_DIALOG1            =  101
%IDC_FRAME1             = 1001
%IDC_OPTION_32Channels  = 1002
%IDC_OPTION_128Channels = 1003
%IDC_LISTBOX1           = 1004
%IDC_LABEL1             = 1005
%IDC_BUTTON_OKEEG       = 1006
%IDC_BUTTON_CancelEEG   = 1007
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()

IF TRIM$(COMMAND$) = "" THEN

   EXIT FUNCTION  ' No command-line params given, just quit

 ELSEIF INSTR(COMMAND$, "/Q") THEN

   ' Process the /Q option

 ELSEIF INSTR(COMMAND$, "/W") THEN

   ' Process the /W option

 END IF


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
                CASE %IDC_OPTION_32Channels

                CASE %IDC_OPTION_128Channels

                CASE %IDC_LISTBOX1

                CASE %IDC_BUTTON_OKEEG
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_OKEEG=" + _
                            FORMAT$(%IDC_BUTTON_OKEEG), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_CancelEEG
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_CancelEEG=" + _
                            FORMAT$(%IDC_BUTTON_CancelEEG), %MB_TASKMODAL
                    END IF

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
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "EEG Settings", 70, 70, 202, 161, TO hDlg
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME1, "Select Channels", 5, 15, 90, 90
    ' %WS_GROUP...
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_32Channels, "32", 15, 40, 65, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_128Channels, "128", 15, 55, 65, 15
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX1, , 110, 24, 85, 81, %WS_CHILD OR _
        %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR %LBS_MULTIPLESEL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Analog Channels", 110, 10, 90, _
        15
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_OKEEG, "OK", 45, 135, 55, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_CancelEEG, "Cancel", 105, 135, 55, _
        20

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, -1, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_32Channels, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_128Channels, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_OKEEG, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_CancelEEG, hFont1
#PBFORMS END DIALOG

    SampleListBox  hDlg, %IDC_LISTBOX1, 30

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

