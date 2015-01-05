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

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG_EditSettings             =  101
%IDC_TEXTBOX_AIBSettings = 1801
%IDC_BUTTON_Save         = 1802
%IDC_BUTTON_Cancel       = 1803
%IDC_LISTBOX_Settings    = 1804
%IDC_LABEL1              = 1806
%IDC_TEXTBOX_Modify      = 1805
%IDC_BUTTON_Update       = 1807
%IDC_LABEL_EDIT2         = 1808
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
GLOBAL ghEditSettingsDlg AS DWORD
GLOBAL gEEGFilename AS ASCIIZ *256
GLOBAL gAIBFilename AS ASCIIZ *256
GLOBAL gBLFilename AS ASCIIZ *256
GLOBAL gASFilename AS ASCIIZ *256
GLOBAL gSettingsFile AS ASCIIZ * 256
GLOBAL gSettingsSaveFile AS ASCIIZ * 256
GLOBAL gExtension AS STRING
GLOBAL hDlg   AS DWORD
GLOBAL glbPosition AS LONG
GLOBAL glbText, glbText1, glbText2, gmodifiedText AS STRING

'FUNCTION PBMAIN()
'     IF TRIM$(COMMAND$) = "" THEN
'        MSGBOX "No Settings file name passed via the command line."
'        EXIT FUNCTION  ' No command-line params given, just quit
'     END IF
'
'    gSettingsFile = TRIM$(COMMAND$)
'    gExtension = PATHNAME$(EXTN,  gSettingsFile) ' returns  extension
'
'    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
'        %ICC_INTERNET_CLASSES)
'
'    ShowDIALOG1 %HWND_DESKTOP
'END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_EditSettingsProc()
    LOCAL datav AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            LoadSettingsFile()
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
                ' /* Inserted by PB/Forms 05-29-2013 11:45:18
                CASE %IDC_LISTBOX_Settings
                    IF CB.CTLMSG = %LBN_SELCHANGE  THEN
                        LISTBOX GET SELECT ghEditSettingsDlg, %IDC_LISTBOX_Settings TO glbPosition
                        LISTBOX GET TEXT ghEditSettingsDlg, %IDC_LISTBOX_Settings, glbPosition TO glbText
                        glbText1 = PARSE$(glbText, ",", 1)
                        glbText2 = PARSE$(glbText, ",", 2)
                        CONTROL SET TEXT ghEditSettingsDlg, %IDC_TEXTBOX_Modify, glbText2
                    END IF

                CASE %IDC_TEXTBOX_Modify

                CASE %IDC_BUTTON_Update
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX GET SELECT ghEditSettingsDlg, %IDC_LISTBOX_Settings TO glbPosition
                        IF (glbPosition = 0) THEN
                            MSGBOX "No item was selected."
                        ELSE
                            CONTROL GET TEXT ghEditSettingsDlg, %IDC_TEXTBOX_Modify TO gmodifiedText
                            LISTBOX SET TEXT ghEditSettingsDlg, %IDC_LISTBOX_Settings, glbPosition, glbText1 + "," +  gmodifiedText
                        END IF
                    END IF
                ' */

                CASE %IDC_TEXTBOX_AIBSettings

                CASE %IDC_BUTTON_Save
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        gExtension = PATHNAME$(EXTN,  gSettingsFile) ' returns  extension
                        IF (gExtension = ".EEG") THEN
                           gSettingsSaveFile = gSettingsFile
                           SaveSettingsFile()
                           DIALOG END CB.HNDL, 1
                        ELSE
                            DISPLAY SAVEFILE 0, , , "Save Settings", EXE.PATH$, CHR$(gExtension + " Files", 0, "*" + gExtension, 0), "", gExtension,  %OFN_OVERWRITEPROMPT TO gSettingsSaveFile
                            IF (gSettingsSaveFile <> "") THEN
                                SaveSettingsFile()
                                DIALOG END CB.HNDL, 1
                            END IF
                        END IF
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
FUNCTION ShowDIALOG_EditSettings(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_EditSettings->->
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD

    DIALOG NEW hParent, "Edit Settings file", 70, 70, 483, 430, TO ghEditSettingsDlg
    CONTROL ADD LISTBOX, ghEditSettingsDlg, %IDC_LISTBOX_Settings, , 10, 25, 265, 335, %WS_CHILD _
        OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR %LBS_NOTIFY, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, ghEditSettingsDlg, %IDC_TEXTBOX_Modify, "", 293, 70, 105, 20
    CONTROL ADD BUTTON,  ghEditSettingsDlg, %IDC_BUTTON_Update, "Update", 415, 65, 60, 25
    CONTROL ADD BUTTON,  ghEditSettingsDlg, %IDC_BUTTON_Save, "Save/Save As", 155, 390, _
        85, 25
    CONTROL ADD BUTTON,  ghEditSettingsDlg, %IDC_BUTTON_Cancel, "Cancel", 249, 391, 85, 25
    CONTROL ADD LABEL,   ghEditSettingsDlg, %IDC_LABEL1, "Modify here", 295, 55, 95, 15
    CONTROL ADD LABEL,   ghEditSettingsDlg, %IDC_LABEL_EDIT2, "Click item to modify", _
        10, 10, 250, 15

    FONT NEW "Terminal", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT ghEditSettingsDlg, %IDC_LISTBOX_Settings, hFont1
    CONTROL SET FONT ghEditSettingsDlg, %IDC_TEXTBOX_Modify, hFont2
    CONTROL SET FONT ghEditSettingsDlg, %IDC_BUTTON_Update, hFont2
    CONTROL SET FONT ghEditSettingsDlg, %IDC_BUTTON_Save, hFont3
    CONTROL SET FONT ghEditSettingsDlg, %IDC_BUTTON_Cancel, hFont3
    CONTROL SET FONT ghEditSettingsDlg, %IDC_LABEL1, hFont2
    CONTROL SET FONT ghEditSettingsDlg, %IDC_LABEL_EDIT2, hFont2
#PBFORMS END DIALOG

    DIALOG SHOW MODAL ghEditSettingsDlg, CALL ShowDIALOG_EditSettingsProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_EditSettings
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

FUNCTION SaveSettingsFile() AS LONG
    LOCAL x, lbCnt AS LONG
    LOCAL temp AS STRING

    LISTBOX GET COUNT ghEditSettingsDlg, %IDC_LISTBOX_Settings TO lbCnt

    IF (lbCnt <> 0) THEN
        OPEN gSettingsSaveFile FOR OUTPUT AS #1
        PRINT #1, "Channel,Label"
        FOR x = 1 TO lbCnt
            LISTBOX GET TEXT ghEditSettingsDlg, %IDC_LISTBOX_Settings, x TO temp
            PRINT #1, temp
        NEXT x
        CLOSE #1

        MSGBOX gSettingsSaveFile + " has been saved."
    ELSE
        MSGBOX "Nothing to save."
    END IF

END FUNCTION

FUNCTION LoadSettingsFile() AS LONG
    LOCAL temp AS STRING

    OPEN gSettingsFile FOR INPUT AS #1
    LINE INPUT #1, temp 'first line is header

    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        LISTBOX ADD ghEditSettingsDlg, %IDC_LISTBOX_Settings, temp
    WEND
    CLOSE #1
END FUNCTION
