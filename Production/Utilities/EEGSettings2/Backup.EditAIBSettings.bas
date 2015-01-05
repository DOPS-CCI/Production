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
'#RESOURCE "EditAIBSettings.pbr"
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
%IDD_DIALOG1             =  101
%IDC_TEXTBOX_AIBSettings = 1001
%IDC_BUTTON_Save         = 1002
%IDC_BUTTON_Cancel       = 1003
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

GLOBAL gAIBSettingsFile AS ASCIIZ * 256
GLOBAL gAIBSettingsSaveFile AS ASCIIZ * 256
GLOBAL hDlg   AS DWORD

FUNCTION PBMAIN()
     IF TRIM$(COMMAND$) = "" THEN
        MSGBOX "No AIB Settings file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
     END IF

    gAIBSettingsFile = TRIM$(COMMAND$)

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
            LoadAIBSettingsFile()
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
                CASE %IDC_TEXTBOX_AIBSettings

                CASE %IDC_BUTTON_Save
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY SAVEFILE 0, , , "Save AIB Settings", "", CHR$("AIB Files", 0, "*.AIB", 0), "", "AIB",  %OFN_OVERWRITEPROMPT TO gAIBSettingsSaveFile
                        SaveAIBSettingsFile()
                    END IF

                CASE %IDC_BUTTON_Cancel
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                         DIALOG END CB.HNDL, 0
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

    DIALOG NEW hParent, "Edit AIB Settings file", 70, 70, 693, 430, TO hDlg
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_AIBSettings, "", 5, 5, 685, 360, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR %ES_MULTILINE _
        OR %ES_AUTOHSCROLL OR %ES_AUTOVSCROLL, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Save, "Save/Save As", 244, 390, _
        85, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Cancel, "Cancel", 338, 391, 85, 25

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, -1, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_AIBSettings, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Save, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Cancel, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

FUNCTION SaveAIBSettingsFile() AS LONG
    LOCAL temp AS STRING
    LOCAL MyString AS ISTRINGBUILDERA

    LET MyString = CLASS "StringBuilderA"

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_AIBSettings TO temp


    OPEN gAIBSettingsSaveFile FOR INPUT AS #1
    WRITE #1, temp
    CLOSE #1

    MSGBOX gAIBSettingsSaveFile + " has been saved."
END FUNCTION

FUNCTION LoadAIBSettingsFile() AS LONG
    LOCAL temp AS STRING
    LOCAL MyString AS ISTRINGBUILDERA

    LET MyString = CLASS "StringBuilderA"

    OPEN gAIBSettingsFile FOR OUTPUT AS #1
    LINE INPUT #1, temp 'first line is header

    MyString.Clear()
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        MyString.Add(temp + $CRLF)
    WEND
    CLOSE #1
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_AIBSettings, MyString.String()
END FUNCTION
