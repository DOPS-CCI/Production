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
'#RESOURCE "ConditionsChoices.pbr"
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
%IDD_DIALOG_ConditionsChoices   =  101
%IDC_LABEL1                     = 1005  '*
%IDC_LABEL2                     = 1006  '*
%IDC_BUTTON_Add                 = 1002
%IDC_BUTTON_Save                = 1007
%IDC_BUTTON_Cancel              = 1008
%IDC_BUTTON_ClearAll            = 1009
%IDC_FRAME1                     = 1010
%IDC_LABEL3                     = 1011
%IDC_TEXTBOX_ASCLevel           = 1012
%IDC_LABEL4                     = 1014
%IDC_TEXTBOX_ASCValue           = 1013
%IDC_BUTTON_Delete              = 1003
%IDC_LABEL5                     = 1015
%IDC_TEXTBOX_GROUPVAR           = 1016
%IDC_LABEL6                     = 1018
%IDC_TEXTBOX_GROUPVAR_DESC      = 1017
%IDC_LISTBOX_ConditionVariables = 1004
%IDC_BUTTON_Load                = 1019
%IDC_BUTTON_Close               = 1020
%IDC_BUTTON_SaveAs              = 1021
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
%MAXPPS_SIZE = 2048


GLOBAL hDlg   AS DWORD
GLOBAL gINIFilename AS ASCIIZ * 256
GLOBAL gConditionsFile AS ASCIIZ * 512
GLOBAL gLoadCnt, gSaveCnt AS LONG

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmdCnt AS LONG
    LOCAL temp AS STRING

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gINIFilename = COMMAND$(1)
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    ELSE
        MSGBOX "No .INI name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
    END IF

    GetPrivateProfileString("Stimulus section", "ConditionsFile", "", gConditionsFile, %MAXPPS_SIZE, gINIFilename)

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL x, y, cnt, newCnt, selected, idxPos AS LONG
    LOCAL temp AS ASCIIZ * 512
    LOCAL filename, dirName AS STRING


    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            'CALL ReadConditionsFile(gConditionsFile + "")
            'LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO gLoadCnt
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
                ' /* Inserted by PB/Forms 07-31-2013 13:21:11
                CASE %IDC_BUTTON_ClearAll
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX RESET hDlg, %IDC_LISTBOX_ConditionVariables
                    END IF
                ' */


                CASE %IDC_BUTTON_Add
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonAdd()
                    END IF

                CASE %IDC_BUTTON_Delete
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       CALL ButtonDelete()
                    END IF

                CASE %IDC_BUTTON_Load
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        dirName = PATHNAME$(PATH,  gINIFilename)
                        DISPLAY OPENFILE 0, , , "Load Conditions File", dirName + "Conditions\", CHR$(".CND", 0, "*.CND", 0), _
                                        "", ".CND", %OFN_EXPLORER TO filename

                        IF (TRIM$(filename) = "") THEN
                            MSGBOX "No file chosen."
                            EXIT FUNCTION
                        END IF

                        gConditionsFile = filename
                        CALL ReadConditionsFile(filename)

                    END IF
                CASE %IDC_BUTTON_Save
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL WriteConditionsFile(gConditionsFile + "")

                        MSGBOX "Settings saved."
                    END IF

                CASE %IDC_BUTTON_SaveAs
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        dirName = PATHNAME$(PATH,  gINIFilename)
                        DISPLAY SAVEFILE 0, , , "Save Conditions File", dirName + "Conditions\", CHR$(".CND", 0, "*.CND", 0), _
                                        "", ".CND", %OFN_EXPLORER TO filename
                        IF (TRIM$(filename) = "") THEN
                            MSGBOX "No file name was entered."
                            EXIT FUNCTION
                        END IF
                        gConditionsFile = filename

                        CALL WriteConditionsFile(filename)

                        MSGBOX "Settings saved."
                    END IF

                CASE %IDC_BUTTON_Close
                     IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                         LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO cnt

                         IF (cnt = 0) THEN
                             MSGBOX "No conditions were loaded or added.
                             EXIT FUNCTION
                         END IF

                         IF (gLoadCnt <> gSaveCnt) THEN
                            CALL WriteConditionsFile(gConditionsFile + "")
                            MSGBOX "Settings changed and were saved."
                         END IF

                         IF (gLoadCnt <> cnt) THEN
                            CALL WriteConditionsFile(gConditionsFile + "")
                            MSGBOX "Settings changed and were saved."
                         END IF

                         DIALOG END hDlg
                     END IF

                CASE %IDC_BUTTON_Cancel
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "Settings not saved."
                        DIALOG END hDlg
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_ConditionsChoices->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, hParent, "Conditions Choices", 105, 114, 535, 541, TO _
        hDlg
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ASCLevel, "", 128, 176, 232, 32
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ASCValue, "", 127, 212, 232, 32
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Add, "Add", 33, 281, 74, 40
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Delete, "Delete", 33, 336, 74, 40
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_ClearAll, "Clear all", 33, 391, _
        74, 40
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Save, "Save", 392, 336, 75, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Cancel, "Cancel", 248, 488, 75, 41
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_ConditionVariables, , 127, 276, _
        232, 180, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME1, "Set Levels of ASC Condition " + _
        "Variables", 7, 124, 489, 348
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "Level:", 31, 180, 88, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL4, "Value:", 30, 216, 88, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL5, "Group Variable:", 8, 24, 112, _
        32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GROUPVAR, "ASCCondition", 128, _
        16, 232, 32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP _
        OR %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_GROUPVAR_DESC, "The GV is used " + _
        "for generic ASC experiments", 128, 50, 232, 46, %WS_CHILD OR _
        %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %ES_LEFT OR %ES_MULTILINE OR %ES_AUTOHSCROLL, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL6, "Description:", 8, 58, 112, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Load, "Load", 392, 281, 75, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Close, "Close", 152, 488, 75, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_SaveAs, "Save As", 392, 392, 75, _
        41

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ASCLevel, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ASCValue, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Add, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Delete, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_ClearAll, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Save, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Cancel, hFont2
    CONTROL SET FONT hDlg, %IDC_LISTBOX_ConditionVariables, hFont2
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_GROUPVAR, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_GROUPVAR_DESC, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL6, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Load, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_SaveAs, hFont2
#PBFORMS END DIALOG



    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_ConditionsChoices
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

SUB ButtonAdd()
    LOCAL condLevel, condValue AS STRING

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ASCLevel TO condLevel

    IF (TRIM$(condLevel) = "") THEN
        MSGBOX "No Condition Level entered."
        EXIT SUB
    END IF

    CONTROL GET TEXT  hDlg, %IDC_TEXTBOX_ASCValue TO condValue

    IF (TRIM$(condValue) = "") THEN
        MSGBOX "No Condition Value entered."
        EXIT SUB
    END IF


    LISTBOX ADD hDlg, %IDC_LISTBOX_ConditionVariables, condLevel + "," + condValue

END SUB

SUB ButtonDelete()
    LOCAL x, lbCnt, selectedState AS LONG

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO lbCnt

    FOR x = 1 TO lbCnt
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ConditionVariables, x TO selectedState

        IF (selectedState = -1) THEN 'selected
            LISTBOX DELETE hDlg, %IDC_LISTBOX_ConditionVariables, x
        END IF
    NEXT x
END SUB

SUB ReadConditionsFile(filename AS STRING)
    LOCAL temp, temp2, cond, GVDesc AS ASCIIZ * 255
    LOCAL tempFileName AS ASCIIZ * 255
    LOCAL condCode, x AS INTEGER

    '****************************************************************************
    'Reading in the conditions and the condition codes from the
    'ASCCondition.txt file and pre-filling the listbox.
    '****************************************************************************
    LISTBOX RESET hDlg, %IDC_LISTBOX_ConditionVariables

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_GROUPVAR TO temp

    OPEN filename FOR INPUT AS #1

    INPUT #1, GVDesc
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_GROUPVAR_DESC, GVDesc

    x = 1
    DO
        INPUT #1, cond, condCode, temp2
        IF (cond = "xxx") THEN
            EXIT LOOP
        END IF
        temp = cond + "," + STR$(condCode)
        LISTBOX INSERT hDlg, %IDC_LISTBOX_ConditionVariables, x, temp
        x = x + 1
    LOOP

    CLOSE #1

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO gLoadCnt

    gSaveCnt = gLoadCnt

    CONTROL REDRAW hDlg,  %IDC_LISTBOX_ConditionVariables
END SUB

SUB WriteConditionsFile(filename AS STRING)
    LOCAL temp, temp2, cond, GVDesc AS ASCIIZ * 255
    LOCAL condCode, x, lbCount AS LONG
    LOCAL dirName AS STRING

    '*****************************************************************************
    'Write out the conditions to the conditions file.
    '*****************************************************************************

    temp = filename
    dirName = PATHNAME$(PATH, gINIFilename)

    WritePrivateProfileString("Stimulus section", "ConditionsFile", temp, gINIFilename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_GROUPVAR TO temp
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_GROUPVAR_DESC TO GVDesc

    OPEN filename FOR OUTPUT AS #1
    OPEN dirName + "Conditions\ASCCondition.txt" FOR OUTPUT AS #2

    PRINT #1, GVDesc
    PRINT #2, GVDesc

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO lbCount

    FOR x = 1 TO lbCount
        LISTBOX GET TEXT hDlg, %IDC_LISTBOX_ConditionVariables, x TO temp
        PRINT #1, temp + ","
        PRINT #2, temp + ","
    NEXT x

    'PRINT #1, "SpecialEvent, 88"
    'PRINT #1, "EndEpoch,99"
    PRINT #1, "xxx,999,"
    PRINT #2, "xxx,999,"

    CLOSE #1
    CLOSE #2

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ConditionVariables TO gSaveCnt
END SUB
