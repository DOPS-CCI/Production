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
#RESOURCE "GenerateRandomNumbers.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#RESOURCE ICON,     RNGICO, "RNG.ICO"
'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1            =  101
%IDC_LABEL_RndNumbers   = 1001  '*
%IDC_CHECKBOX_Preview   = 1002
%IDC_BUTTON_Generate    = 1003
%IDC_BUTTON_Save        = 1004
%IDC_BUTTON_Close       = 1005
%IDC_LABEL1             = 1006
%IDC_TEXTBOX_Duration   = 1007
%IDC_TEXTBOXPreview     = 1009
%IDC_LABEL3             = 1011
%IDC_TEXTBOX_SampleSize = 1010
%IDC_LABEL4             = 1013  '*
%IDC_TEXTBOX_Filename   = 1012
%IDC_LISTBOX_Preview    = 1014
%IDC_LABEL_PreviewText  = 1008
%IDC_FRAME1             = 1015
%IDC_OPTION_Dec         = 1016
%IDC_OPTION_Hex         = 1017
%IDC_OPTION_Binary      = 1018
%IDC_FRAME2             = 1019
%IDC_OPTION_CSV         = 1020
%IDC_OPTION_Tab         = 1021
%IDC_OPTION_Bin         = 1022
%IDC_OPTION_ZScore      = 1023
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

#INCLUDE "DOPS_MMTimers.inc"

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

GLOBAL gSaveToFile AS INTEGER
GLOBAL gRndCnt AS LONG
GLOBAL oApp AS IDISPATCH
GLOBAL hDlg   AS DWORD
GLOBAL gSampleSize AS LONG
GLOBAL gSampleDuration AS LONG
GLOBAL gRunningDuration AS LONG
GLOBAL gSampleRate AS LONG
GLOBAL gSamples() AS BYTE
GLOBAL gFilename AS STRING
GLOBAL gSampleCnt AS LONG
GLOBAL gByteCnt AS LONG
GLOBAL gRndTotal AS LONG
GLOBAL gRndAvg AS DOUBLE
GLOBAL gTogglePreview AS INTEGER
GLOBAL gBytesPerMillisecond AS LONG
GLOBAL gError AS INTEGER
GLOBAL gBinaryPos AS LONG

FUNCTION PBMAIN()
    LOCAL errTrapped AS LONG

    gSaveToFile = 0 'no
    gTogglePreview = 0 'Off
    gError = 0
    gBinaryPos = 1
    LET gTimers = CLASS "PowerCollection"

    TRY
        LET oApp = NEWCOM "Araneus.Alea.1"
        OBJECT CALL oApp.Open
    CATCH
        MSGBOX "Error on Opening Alea RNG. Check to see if it is plugged in (and that the drivers are installed.)"
        errTrapped = ERR
        EXIT TRY
    END TRY

    IF (errTrapped = 0) THEN
        PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
            %ICC_INTERNET_CLASSES)

        ShowDIALOG1 %HWND_DESKTOP

        killMMTimerEvent()
    END IF
END FUNCTION
'------------------------------------------------------------------------------

SUB TogglePreviewButton()
    LOCAL buttonText AS STRING

    CONTROL GET TEXT hDlg, %IDC_BUTTON_Generate TO buttonText
    IF (INSTR(1, buttonText, "OFF")) THEN
        gTogglePreview = 0
        gSaveToFile = 0 'no save - just preview
        gByteCnt = 0
        gSampleCnt = 0
        gRndTotal = 0
        LISTBOX RESET hDlg, %IDC_LISTBOX_Preview
        StartProcess()
        IF (gError = 0) THEN
            CONTROL SET TEXT hDlg, %IDC_BUTTON_Generate, "Preview ON"
        END IF
    ELSE
        gTogglePreview = 1
        SetMMTimerOnOff("GETRESULT", 0)    'turn off
        killMMTimerEvent()
        CONTROL SET TEXT hDlg, %IDC_BUTTON_Generate, "Preview OFF"
    END IF
END SUB

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL folder, str AS STRING
    LOCAL temp, delimiter AS STRING
    LOCAL y, z, checkState AS LONG
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers

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
                ' /* Inserted by PB/Forms 05-02-2013 07:55:08
                CASE %IDC_OPTION_Dec

                CASE %IDC_OPTION_Hex

                CASE %IDC_OPTION_Binary


                CASE %IDC_OPTION_CSV
                    CONTROL ENABLE hDlg, %IDC_OPTION_Dec
                    CONTROL ENABLE hDlg, %IDC_OPTION_Hex
                    CONTROL ENABLE hDlg, %IDC_OPTION_Binary
                    CONTROL ENABLE hDlg, %IDC_OPTION_ZScore
                CASE %IDC_OPTION_Tab
                    CONTROL ENABLE hDlg, %IDC_OPTION_Dec
                    CONTROL ENABLE hDlg, %IDC_OPTION_Hex
                    CONTROL ENABLE hDlg, %IDC_OPTION_Binary
                    CONTROL ENABLE hDlg, %IDC_OPTION_ZScore
                CASE %IDC_OPTION_Bin
                    CONTROL SET CHECK  hDlg, %IDC_OPTION_Dec, 1
                    CONTROL SET CHECK  hDlg, %IDC_OPTION_Hex, 0
                    CONTROL SET CHECK  hDlg, %IDC_OPTION_Binary, 0
                    CONTROL SET CHECK  hDlg, %IDC_OPTION_ZScore, 0
                    CONTROL DISABLE hDlg, %IDC_OPTION_Dec
                    CONTROL DISABLE hDlg, %IDC_OPTION_Hex
                    CONTROL DISABLE hDlg, %IDC_OPTION_Binary
                    CONTROL DISABLE hDlg, %IDC_OPTION_ZScore
                CASE %IDC_OPTION_ZScore

                ' */

                ' /* Inserted by PB/Forms 05-01-2013 15:49:24
                CASE %IDC_LISTBOX_Preview
                ' */

                ' /* Inserted by PB/Forms 05-01-2013 15:30:04
                CASE %IDC_TEXTBOX_Filename
                ' */

                ' /* Inserted by PB/Forms 05-01-2013 14:57:19
                CASE %IDC_TEXTBOX_SampleSize
                ' */

                ' /* Inserted by PB/Forms 05-01-2013 09:55:34
                CASE %IDC_TEXTBOX_Duration

                CASE %IDC_TEXTBOXPreview
                ' */

                CASE %IDC_CHECKBOX_Preview

                CASE %IDC_BUTTON_Generate
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                            TogglePreviewButton()
                    END IF

                CASE %IDC_BUTTON_Save
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                            gSaveToFile = 1 'yes save
                            gByteCnt = 0
                            gSampleCnt = 0
                            gRndTotal = 0

                            CONTROL GET CHECK hDlg, %IDC_OPTION_CSV TO checkState
                            IF (checkState = 1) THEN
                                delimiter = ","
                            END IF
                            CONTROL GET CHECK hDlg, %IDC_OPTION_Tab TO checkState
                            IF (checkState = 1) THEN
                                delimiter = $TAB
                            END IF
                            CONTROL GET CHECK hDlg, %IDC_OPTION_Bin TO checkState
                            IF (checkState = 1) THEN
                                delimiter = ""
                            END IF
                            IF (delimiter = ",") THEN
                                DISPLAY SAVEFILE hDlg, , , "Where do you want to save the generated numbers to (Default is C:\)?", "C:\", _
                                                    CHR$("Comma-delimited", 0, "*.CSV", 0), _
                                                    "", "CSV", %OFN_CREATEPROMPT OR %OFN_SHOWHELP TO gFilename
                            ELSEIF (delimiter = $TAB) THEN
                                DISPLAY SAVEFILE hDlg, , , "Where do you want to save the generated numbers to (Default is C:\)?", "C:\", _
                                                    CHR$("Tab-delimited", 0, "*.TXT", 0), _
                                                    "", "TXT", %OFN_CREATEPROMPT OR %OFN_SHOWHELP TO gFilename

                            ELSE
                                DISPLAY SAVEFILE hDlg, , , "Where do you want to save the generated numbers to (Default is C:\)?", "C:\", _
                                                    CHR$("Binary", 0, "*.BIN", 0), _
                                                    "", "BIN", %OFN_CREATEPROMPT OR %OFN_SHOWHELP TO gFilename
                            END IF

                            IF (gFilename = "") THEN
                                MSGBOX "Please enter a filename."
                            ELSE
                                StartProcess()
                            END IF
                    END IF
                CASE %IDC_BUTTON_Close
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
    LOCAL hFont2 AS DWORD

    DIALOG NEW hParent, "Generate Random Numbers", 70, 70, 676, 269, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    ' %WS_GROUP...
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_Dec, "Decimal", 25, 186, 80, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_Hex, "Hexadecimal", 25, 201, 80, _
        15
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_Binary, "Binary", 25, 216, 80, 15
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_ZScore, "Z-score", 25, 231, 80, 15
    ' %WS_GROUP...
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_CSV, "CSV", 160, 186, 80, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_Tab, "Tab-Delimited", 160, 201, _
        80, 15
    CONTROL ADD OPTION,  hDlg, %IDC_OPTION_Bin, "Binary", 160, 216, 80, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_SampleSize, "", 455, 180, 85, 20
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_Duration, "", 455, 205, 85, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Generate, "Preview OFF", 555, 150, _
        100, 30
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Save, "Generate and Save", 555, _
        185, 100, 30
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Close, "Close", 555, 220, 100, 30
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Duration for samples (in ms):", _
        280, 210, 175, 20, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_PreviewText, "Preview (RNG can " + _
        "sample ~ 10,000 samples/sec)", 15, 0, 355, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "Sample size (1 - 10,000):", 280, _
        185, 175, 20, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_Preview, , 15, 20, 650, 120, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME1, "Random Number Output", 10, 160, _
        125, 90
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME2, "File Format", 155, 160, 110, 85

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Terminal", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_OPTION_Dec, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_Hex, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_Binary, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_ZScore, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_CSV, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_Tab, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_Bin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_SampleSize, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Duration, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Generate, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Save, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_PreviewText, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_Preview, hFont2
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME2, hFont1
#PBFORMS END DIALOG

    DIALOG SET ICON hDlg, "RNGICO"
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_SampleSize, "25"
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Duration, "1000"
    CONTROL SET CHECK hDlg, %IDC_OPTION_ZScore, 1
    CONTROL SET CHECK hDlg, %IDC_OPTION_CSV, 1

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

FUNCTION StartProcess() AS LONG
    LOCAL temp AS STRING
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers

    'set up a timer for generating random numbers

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_SampleSize TO temp

    IF (TRIM$(temp) = "") THEN
        MSGBOX "Please input a sample size."
        gError = -1
        EXIT FUNCTION
    END IF

    gSampleSize = VAL(TRIM$(temp))

    IF (gSampleSize < 1 AND gSampleSize > 10000) THEN
        MSGBOX "Sample size must be between 1 and 10,000." + $CRLF + _
                "The Araneus Alea RNG can sample about 10,000 samples/sec."
        gError = -1
        EXIT FUNCTION
    END IF

    'if (gSampleSize > 1000) then
    '    msgbox "Can only preview 1,000 samples / duration."
    '    exit function
    'end if


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_Duration TO temp

    gSampleDuration = VAL(TRIM$(temp))



    gError = 0

    'if (gSampleSize/gSampleDuration < 10.0) then
    '    msgbox "Sample size / Duration < 10."  + $CRLF + _
    '           "The Araneus Alea RNG can sample about 10,000 samples/sec."
    '    exit function
    'end if


    REDIM gSamples(gSampleSize)
    gRndCnt = 0
    gBytesPerMillisecond = 0
    gRunningDuration = 0
    KILL gFilename
    gTimers.Add("GETRESULT", vTimers)
    SetMMTimerDuration("GETRESULT", gSampleDuration)
    'Start the timers
    setMMTimerEventPeriodic(1, 0)

    SetMMTimerOnOff("GETRESULT", 1)    'turn on

    FUNCTION = 1
END FUNCTION

SUB DoWorkForEachTick()
    LOCAL x AS LONG
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE
    LOCAL timing AS DOUBLE


    TRY
        '**********************************************
        '10 is a scaling factor since we can get 10
        'random numbers per ms.
        '**********************************************
        timing = 10 / (gSampleSize / gSampleDuration)

        '**********************************************
        'should be able to get 10 random numbers per ms
        'or 10,000 samples per second
        '**********************************************
        FOR x = 1 TO 10
            INCR gBytesPerMillisecond
            OBJECT CALL oApp.GetRandomByte() TO rndByte
            bRndByte = VARIANT#(rndByte)
            IF (gBytesPerMillisecond MOD timing = 0) THEN
                INCR gRndCnt
                INCR gByteCnt
                'OBJECT CALL oApp.GetRandomByte() TO rndByte
                'bRndByte = VARIANT#(rndByte)
                gSamples(gRndCnt) = bRndByte
                gRndTotal = gRndTotal +  bRndByte
                gRndAvg = gRndTotal / gByteCnt

                '#DEBUG PRINT STR$(gRndCnt) + ", " + STR$(bRndByte)
            END IF
        NEXT x


    CATCH
        MSGBOX "Error generating random numbers. Error: " + ERROR$ + $CRLF + "Please close the application."
        SetMMTimerOnOff("GETRESULT", 0)    'turn on
        killMMTimerEvent()
        DIALOG END hDlg, -1
    END TRY

    '#debug print str$(gRndCnt) + ", " + str$(bRndByte)

    'MSGBOX STR$(gRndTotal(0)) + ", " + STR$(gRndCnt(0))
    'MSGBOX STR$(gRndTotal(1)) + ", " +  STR$(gRndCnt(1))
END SUB

FUNCTION PowerTimeDateTime(MyTime AS IPOWERTIME) AS STRING
    LOCAL tempDateTime AS STRING

    tempDateTime = TRIM$(FORMAT$(MyTime.Hour(), "00")) + ":" + TRIM$(FORMAT$(MyTime.Minute(), "00")) + _
                                            ":" + TRIM$(FORMAT$(MyTime.Second(), "00")) + "." + TRIM$(FORMAT$(MyTime.MSecond(), "000"))
    FUNCTION = tempDateTime

END FUNCTION


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL x, checkState, position AS LONG
    LOCAL temp, delimiter, numberFormat, binSample AS STRING
    LOCAL MyTime AS IPOWERTIME
    LOCAL MyString AS ISTRINGBUILDERA
    LOCAL now AS QUAD
    LOCAL zN, zTotal AS LONG
    LOCAL zScore, zEv AS DOUBLE
    LOCAL zStd AS EXTENDED


    LET MyTime = CLASS "PowerTime"
    LET MyString = CLASS "StringBuilderA"

    SELECT CASE itemName
        CASE "GETRESULT"
            gRndCnt = 0
            gBytesPerMillisecond = 0
            INCR gSampleCnt

            MyTime.Now()
            MyTime.FileTime TO now

            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_CSV TO checkState
            IF (checkState = 1) THEN
                delimiter = ","
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_Tab TO checkState
            IF (checkState = 1) THEN
                delimiter = $TAB
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_Bin TO checkState
            IF (checkState = 1) THEN
                delimiter = ""
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_Dec TO checkState
            IF (checkState = 1) THEN
                numberFormat = "DEC"
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_Hex TO checkState
            IF (checkState = 1) THEN
                numberFormat = "HEX"
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_Binary TO checkState
            IF (checkState = 1) THEN
                numberFormat = "BIN"
            END IF
            checkState = 0
            CONTROL GET CHECK hDlg, %IDC_OPTION_ZScore TO checkState
            IF (checkState = 1) THEN
                numberFormat = "ZSCORE"
            END IF


            CONTROL SET TEXT hDlg, %IDC_LABEL_PreviewText, "Sample # " + FORMAT$(gSampleCnt, "0########") + "    Running average: " + FORMAT$(gRndAvg, "0000.00000")
            INCR gRunningDuration
            IF (gSaveToFile = 1) THEN
                IF (delimiter = "," OR delimiter = $TAB) THEN
                    OPEN gFilename FOR APPEND AS #1
                    IF (gSampleDuration MOD 1000 = 0) THEN
                        PRINT #1, TIME$; ",";
                    ELSE
                        PRINT #1, PowerTimeDateTime(MyTime); ",";
                    END IF
                    PRINT #1, gRunningDuration; ",";
                    IF (numberFormat<> "ZSCORE") THEN
                        zTotal = 0
                        FOR x = 1 TO gSampleSize
                           zTotal =  zTotal + sumBitsOfByte(gSamples(x))
                        NEXT x
                        PRINT #1, zTotal; delimiter;
                        FOR x = 1 TO gSampleSize - 1
                            SELECT CASE numberFormat
                                CASE "DEC"
                                    PRINT #1, DEC$(gSamples(x), 3); delimiter;
                                CASE "HEX"
                                    PRINT #1, HEX$(gSamples(x), 2); delimiter;
                                CASE "BIN"
                                    PRINT #1, BIN$(gSamples(x), 8); delimiter;
                            END SELECT
                        NEXT x
                        SELECT CASE numberFormat
                            CASE "DEC"
                                PRINT #1, DEC$(gSamples(gSampleSize), 3)
                            CASE "HEX"
                                PRINT #1, HEX$(gSamples(gSampleSize), 2)
                            CASE "BIN"
                                PRINT #1, BIN$(gSamples(gSampleSize), 8)
                        END SELECT
                    ELSE
                        'Added 7/22/13 per Ross Dunseath
                        'Calculate Z as follows:
                        '
                        'Z = (X-ev)/sd,  where X = sum of bits in the sample, ev = expected value, sd = standard deviation.
                        '
                        'ev = 0.5*n, where n = total bits/sample (25*8 = 200 in our default of 8 bytes/sample)
                        'sd = sqrt(n*0.25)
                        '
                        'Also, for time stamping there should be a second col with elapsed time from the start of the RNG.
                        'So col 1 is time in hh:mm:ss, col 2 is elapsed time in secs, and col 3 is Z scores, or the 25 raw bytes in col 3 - 28,
                        'depending on user choice.
                        'Default output is time, elapsed time, Z.  Default sampling is 25 bytes each second.
                        zTotal = 0
                        FOR x = 1 TO gSampleSize
                           zTotal =  zTotal + sumBitsOfByte(gSamples(x))
                        NEXT x
                        zN = gSampleSize * 8 '(8 bit samples)
                        zEv = 0.5 * zN
                        zStd = SQR(zN * 0.25)
                        zScore = (zTotal - zEv)/zStd
                        PRINT #1, FORMAT$(zTotal, "0000");",";
                        PRINT #1, FORMAT$(zScore, "0000.00000")
                    END IF
                    CLOSE #1
                ELSE
                    OPEN gFilename FOR BINARY AS #1

                    PUT #1, gBinaryPos, gSamples()
                    gBinaryPos = SEEK(#1)

                    CLOSE #1
                END IF
            END IF
            IF (gSaveToFile = 0) THEN
                IF (delimiter = "," OR delimiter = $TAB) THEN
                    MyString.Clear()
                    IF (numberFormat <> "ZSCORE") THEN
                        zTotal = 0
                        FOR x = 1 TO gSampleSize
                           zTotal =  zTotal + sumBitsOfByte(gSamples(x))
                        NEXT x
                        MyString.Add(DEC$(zTotal,4))
                        MyString.Add(delimiter)
                        FOR x = 1 TO gSampleSize - 1
                            SELECT CASE numberFormat
                                CASE "DEC"
                                    MyString.Add(DEC$(gSamples(x), 3))
                                    MyString.Add(delimiter)
                                CASE "HEX"
                                    MyString.Add(HEX$(gSamples(x), 2))
                                    MyString.Add(delimiter)
                                CASE "BIN"
                                    MyString.Add(BIN$(gSamples(x), 8))
                                    MyString.Add(delimiter)
                            END SELECT
                        NEXT x
                        SELECT CASE numberFormat
                            CASE "DEC"
                                MyString.Add(DEC$(gSamples(gSampleSize), 3))
                                'temp = temp + DEC$(gSamples(gSampleSize), 3)
                            CASE "HEX"
                                MyString.Add(HEX$(gSamples(gSampleSize), 2))
                            CASE "BIN"
                                MyString.Add(BIN$(gSamples(gSampleSize), 8))
                        END SELECT
                    ELSE
                        'Added 7/22/13 per Ross Dunseath
                        'Calculate Z as follows:
                        '
                        'Z = (X-ev)/sd,  where X = sum of bits in the sample, ev = expected value, sd = standard deviation.
                        '
                        'ev = 0.5*n, where n = total bits/sample (25*8 = 200 in our default of 8 bytes/sample)
                        'sd = sqrt(n*0.25)
                        '
                        'Also, for time stamping there should be a second col with elapsed time from the start of the RNG.
                        'So col 1 is time in hh:mm:ss, col 2 is elapsed time in secs, and col 3 is Z scores, or the 25 raw bytes in col 3 - 28,
                        'depending on user choice.
                        'Default output is time, elapsed time, Z.  Default sampling is 25 bytes each second.
                        zTotal = 0
                        FOR x = 1 TO gSampleSize
                           zTotal =  zTotal + sumBitsOfByte(gSamples(x))
                        NEXT x
                        zN = gSampleSize * 8
                        zEv = 0.5 * zN
                        zStd = SQR(zN * 0.25)
                        zScore = (zTotal - zEv)/zStd
                        MyString.Add(FORMAT$(zTotal, "0000"))
                        MyString.Add(delimiter)
                        MyString.Add(FORMAT$(zScore, "0000.00000"))
                    END IF
                    IF (gSampleDuration MOD 1000 = 0) THEN
                        LISTBOX ADD hDlg, %IDC_LISTBOX_Preview, TIME$ + "," + STR$(gRunningDuration) + "," + MyString.String()
                    ELSE
                        LISTBOX ADD hDlg, %IDC_LISTBOX_Preview, PowerTimeDateTime(MyTime) + "," + STR$(gRunningDuration) +","  + MyString.String()
                    END IF
                 ELSE
                    LISTBOX RESET  hDlg, %IDC_LISTBOX_Preview
                    LISTBOX INSERT hDlg, %IDC_LISTBOX_Preview, 1, "No preview on binary mode."
                END IF
                'DIALOG REDRAW hDlg
            END IF

            SetMMTimerOnOff("GETRESULT", 1)    'turn on
    END SELECT
END SUB


FUNCTION sumBitsOfByte(sample AS BYTE) AS INTEGER
    LOCAL temp AS STRING
    LOCAL lSample AS LONG

    temp = BIN$(sample)
    lSample = VAL(MID$(temp, 1, 1)) + VAL(MID$(temp, 2, 1)) + VAL(MID$(temp, 3, 1)) + VAL(MID$(temp, 4, 1)) + _
                VAL(MID$(temp, 5, 1)) + VAL(MID$(temp, 6, 1)) + VAL(MID$(temp, 7, 1)) + VAL(MID$(temp, 8, 1))

    FUNCTION = lSample
END FUNCTION
