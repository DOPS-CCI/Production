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
#RESOURCE "AudioSoundChoices.pbr"
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
%IDD_DIALOG1                 =  101
%IDC_LISTBOX_AvailableSounds = 1001
%IDC_LISTBOX_TrialOrder      = 1004
%IDC_LABEL1                  = 1005
%IDC_LABEL2                  = 1006
%IDC_BUTTON_Add              = 1002
%IDC_BUTTON_Remove           = 1003
%IDC_BUTTON_Save             = 1007
%IDC_BUTTON_Cancel           = 1008
%IDC_BUTTON_ClearAll         = 1009
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

TYPE AudioStimsType
    AudioStimDesc AS ASCIIZ * 256
    AudioStimValue AS LONG
END TYPE

GLOBAL hDlg   AS DWORD
GLOBAL gINIFilename AS ASCIIZ * 256
GLOBAL gTrialOrder AS ASCIIZ * 512
GLOBAL gConditionsFile AS ASCIIZ * 512
GLOBAL gWavFiles AS ASCIIZ * 512
GLOBAL wavFiles() AS STRING
GLOBAL trialOrder() AS STRING
GLOBAL audioStims() AS AudioStimsType

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
        MSGBOX "No Actiview file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
    END IF

    GetPrivateProfileString("Stimulus section", "ConditionsFile", "", gConditionsFile, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Experiment Section", "TrialOrder", "", gTrialOrder, %MAXPPS_SIZE, gINIFilename)

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------
FUNCTION readConditionsFile() AS LONG
    LOCAL Desc, LongDesc, WavFile AS STRING
    LOCAL cnt, Value AS LONG

    OPEN gConditionsFile FOR INPUT AS #1

    INPUT #1, LongDesc

    cnt = 0
    DO
        INPUT #1, Desc, Value, WavFile
        IF (LCASE$(Desc) = "xxx" AND Value = 999) THEN
            EXIT LOOP
        END IF
        audioStims(cnt).AudioStimDesc = Desc
        audioStims(cnt).AudioStimValue = Value
        cnt = cnt + 1
    LOOP

    CLOSE #1

    FUNCTION = cnt
END FUNCTION
'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL x, y, cnt, newCnt, selected, idxPos, audioStimValue AS LONG
    LOCAL audioStimDesc, trialOrder AS STRING
    LOCAL temp AS ASCIIZ * 512


    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            REDIM wavFiles(20)
            REDIM trialOrder(20)
            REDIM audioStims(20)
            ' Initialization handler
            cnt = readConditionsFile()
            FOR x = 0 TO cnt - 1
                LISTBOX INSERT hDlg, %IDC_LISTBOX_AvailableSounds, x + 1, audioStims(x).AudioStimDesc
                LISTBOX SET USER hDlg, %IDC_LISTBOX_AvailableSounds, x + 1, audioStims(x).AudioStimValue
            NEXT x
            'PARSE gWavFiles, wavFiles(), ","
            'cnt = PARSECOUNT (gWavFiles, ",")

            PARSE gTrialOrder, trialOrder(), ","
            newCnt = PARSECOUNT (gTrialOrder, ",")
            LISTBOX RESET hDlg, %IDC_LISTBOX_TrialOrder
            FOR x = 0 TO newCnt - 2
                'LISTBOX ADD hDlg, %IDC_LISTBOX_TrialOrder, trialOrder(x) to idxPos
                FOR y = 0 TO cnt
                    IF (TRIM$(trialOrder(x)) = TRIM$(STR$(audioStims(y).AudioStimValue))) THEN
                        LISTBOX ADD hDlg, %IDC_LISTBOX_TrialOrder, audioStims(y).AudioStimDesc TO idxPos
                        LISTBOX SET USER hDlg, %IDC_LISTBOX_TrialOrder, idxPos, audioStims(y).AudioStimValue
                        EXIT FOR
                    END IF
                NEXT y
            NEXT x
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
                        LISTBOX RESET hDlg, %IDC_LISTBOX_TrialOrder
                    END IF
                ' */

                CASE %IDC_LISTBOX_AvailableSounds

                CASE %IDC_BUTTON_Add
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_AvailableSounds TO cnt
                        FOR x = 1 TO cnt
                            LISTBOX GET SELECT hDlg, %IDC_LISTBOX_AvailableSounds, x TO selected
                            IF (selected <> 0) THEN
                                LISTBOX GET TEXT hDlg, %IDC_LISTBOX_AvailableSounds, selected TO audioStimDesc
                                LISTBOX ADD hDlg, %IDC_LISTBOX_TrialOrder, audioStimDesc TO idxPos
                                LISTBOX GET USER hDlg, %IDC_LISTBOX_AvailableSounds, selected TO audioStimValue
                                LISTBOX SET USER hDlg, %IDC_LISTBOX_TrialOrder, idxPos, audioStimValue
                                EXIT FOR
                            END IF
                        NEXT x
                    END IF

                CASE %IDC_BUTTON_Remove
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_TrialOrder TO cnt
                        FOR x = 1 TO cnt
                            LISTBOX GET SELECT hDlg, %IDC_LISTBOX_TrialOrder, x TO selected
                            IF (selected <> 0) THEN
                                LISTBOX DELETE hDlg, %IDC_LISTBOX_TrialOrder, selected
                                EXIT FOR
                            END IF
                        NEXT x
                    END IF

                CASE %IDC_LISTBOX_TrialOrder

                CASE %IDC_BUTTON_Save
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        'WritePrivateProfileString("EEG Information", "NumberOfChannels", numberOfChannels, gDefaultFilename)
                        'WritePrivateProfileString("EEG Information", "EEGChannels", EEGChannels, gDefaultFilename)
                        temp = ""
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_TrialOrder TO cnt
                        FOR x = 1 TO cnt
                            LISTBOX GET USER hDlg, %IDC_LISTBOX_TrialOrder, x TO audioStimValue
                            temp = temp + STR$(audioStimValue) + ","
                        NEXT x
                        IF (temp <> "") THEN
                            WritePrivateProfileString("Experiment Section", "TrialOrder", temp, gINIFilename)
                        END IF
                        MSGBOX "Settings saved."
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

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, hParent, "Audio Paced Sounds Choices", 105, 114, 566, _
        385, TO hDlg
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_AvailableSounds, , 38, 89, 164, _
        171, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Add, ">>>", 242, 122, 74, 40
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Remove, "<<<", 242, 171, 74, 40
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_TrialOrder, , 352, 89, 166, 171, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Available Sounds", 38, 65, 142, _
        24
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "Trial Order", 352, 65, 143, 24
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Save, "Save", 195, 333, 75, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Cancel, "Cancel", 285, 333, 75, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_ClearAll, "Clear all", 375, 268, _
        97, 24

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LISTBOX_AvailableSounds, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Add, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Remove, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_TrialOrder, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Save, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Cancel, hFont1
#PBFORMS END DIALOG



    DIALOG SHOW MODELESS hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
