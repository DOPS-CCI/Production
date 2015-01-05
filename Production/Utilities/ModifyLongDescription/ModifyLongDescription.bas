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
#RESOURCE "ModifyLongDescription.pbr"
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
%TEXTBOX_COMMENT = 1000
%ID_OPEN         = 1001 '*
%ID_SAVE         = 1002
%ID_CANCEL       = 1003
%IDD_DIALOG1     =  101
%IDC_9000        = 9000
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

%MAXPPS_SIZE = 2048

GLOBAL gFilename AS ASCIIZ * 256
GLOBAL hDlg   AS DWORD

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL hr AS DWORD
    LOCAL cmdCnt AS LONG
    LOCAL temp AS STRING

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gFilename = COMMAND$(1)
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    ELSE
        MSGBOX "No experiment .INI file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
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
    LOCAL temp AS ASCIIZ * 2048

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            'GetPrivateProfileString("EEG Information", "NumberOfChannels", "32", numberOfChannels, %MAXPPS_SIZE, gDefaultFilename)
            GetPrivateProfileString("Experiment Section", "Description", "Put description here.", temp, %MAXPPS_SIZE, gFilename)
            CONTROL SET TEXT hDlg, %TEXTBOX_COMMENT, temp
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
                CASE %TEXTBOX_COMMENT

                CASE %ID_SAVE
                    CONTROL GET TEXT hDlg, %TEXTBOX_COMMENT TO temp
                    WritePrivateProfileString("Experiment Section", "Description", temp, gFilename)
                    MSGBOX "Long Description saved."
                    DIALOG END hDlg, 1
                CASE %ID_CANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "Long Description not saved."
                        DIALOG END hDlg, 0
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

    DIALOG NEW PIXELS, hParent, "Modify Header Long Description", 235, 191, _
        522, 171, %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_VISIBLE OR _
        %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO _
        hDlg
    CONTROL ADD LABEL,   hDlg, %IDC_9000, "Long Description below (can be one long line):", 8, _
        8, 440, 25
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_COMMENT, "", 8, 32, 503, 64, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_HSCROLL OR %WS_VSCROLL OR %ES_LEFT _
        OR %ES_AUTOHSCROLL OR %ES_AUTOVSCROLL, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %ID_SAVE, "Save", 160, 120, 75, 33
    CONTROL ADD BUTTON,  hDlg, %ID_CANCEL, "Cancel", 261, 120, 75, 33

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_9000, hFont1
    CONTROL SET FONT hDlg, %TEXTBOX_COMMENT, hFont1
    CONTROL SET FONT hDlg, %ID_SAVE, hFont1
    CONTROL SET FONT hDlg, %ID_CANCEL, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
