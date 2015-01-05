#PBFORMS CREATED V2.01
#COMPILE EXE
#DIM ALL

#RESOURCE WAVE,     THRESHOLD_HIGH, "Sounds\WindowsDing.wav"

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
'#RESOURCE "fEEGKappaClockRMSv2.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES

#INCLUDE "ChannelInfo2.INC"
#INCLUDE "DoubleQueueUsingArray.inc"
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                   =  101
%IDC_LABEL2                    = 1003   '*
%IDC_BUTTON_Connect            = 1004
%IDC_LABEL_Clock               = 1001
%IDC_LABEL_Status              = 1005
%IDC_BUTTON_Start              = 1006   '*
%IDC_LABEL_RMS                 = 1007
%IDC_CHECKBOX_Settings         = 1008
%IDC_FRAME1                    = 1009
%IDC_LABEL1                    = 1010
%IDC_TEXTBOX_MinLowerThreshold = 1011
%IDC_LABEL3                    = 1013
%IDC_TEXTBOX_MaxLowerThreshold = 1012
%IDC_LABEL4                    = 1015
%IDC_LABEL5                    = 1017
%IDC_TEXTBOX_MinUpperThreshold = 1016
%IDC_TEXTBOX_MaxUpperThreshold = 1014
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

%NUMOFCHANNELS = 20
%USEDCHANNELS = 8


GLOBAL TCPSocket AS LONG
GLOBAL hDlg AS DWORD
GLOBAL gSeconds, gMinutes, ghPDThread AS LONG
GLOBAL gSampleCnt, gThreeMinutesPassed AS LONG
GLOBAL newRMSUpdate, oldRMSUpdate AS DOUBLE
GLOBAL rmsTotals AS DOUBLE
GLOBAL gRunningRMSAVGQueue AS doubleQueueInfo
GLOBAL gRunningRmsAvg, gRmsTotalOld, gRmsAvg AS DOUBLE
GLOBAL gStatus, gRMSStatus AS STRING
GLOBAL gIPAddress AS STRING
GLOBAL gPort AS LONG
GLOBAL gChan05Scale, gChan06Scale, gChan07Scale, gChan08Scale AS DOUBLE
GLOBAL gMinThresholdUpper, gMaxThresholdUpper, gMinThresholdLower, gMaxThresholdLower AS LONG

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
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
   LOCAL lResult AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            CALL loadDefaults()

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
                ' /* Inserted by PB/Forms 10-08-2013 07:54:04
                CASE %IDC_CHECKBOX_Settings
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Settings TO lResult
                    IF (lResult = 1) THEN
                        DIALOG SET SIZE hDlg, 643, 440
                        CONTROL SET LOC hDlg, %IDC_LABEL_Status, 0, 384

                    ELSE
                        DIALOG SET SIZE hDlg, 643, 264
                        CONTROL SET LOC hDlg, %IDC_LABEL_Status, 0, 208
                    END IF

                CASE %IDC_TEXTBOX_MinLowerThreshold

                CASE %IDC_TEXTBOX_MaxLowerThreshold

                CASE %IDC_TEXTBOX_MaxUpperThreshold

                CASE %IDC_TEXTBOX_MinUpperThreshold
                ' */

                CASE %IDC_BUTTON_Connect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                        'TCP OPEN PORT 999 AT "137.54.99.106" AS TCPSocket TIMEOUT 30000
                        'TCP OPEN PORT 999 AT "192.168.1.64" AS TCPSocket TIMEOUT 30000
                        TCP OPEN PORT gPort AT gIPAddress AS TCPSocket TIMEOUT 30000
                        ' Could we connect to site?

                        IF ERR THEN
                            CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Could not connect. Error: " + ERROR$
                            CONTROL REDRAW hDlg, %IDC_LABEL_Status
                            MSGBOX "Could not connect. Error: " + ERROR$
                            EXIT FUNCTION
                        END IF

                        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Connected."
                        CONTROL REDRAW hDlg, %IDC_LABEL_Status
                        'MSGBOX "Connected."

                        THREAD CREATE ProcessTCPIPThread(1) TO ghPDThread
                    END IF
            END SELECT
            CASE %WM_DESTROY
                TCP CLOSE TCPSocket
                CALL saveDefaults()
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB processBuffer()
    LOCAL buffer AS STRING * 42
    LOCAL endBuffer AS STRING *4
    LOCAL temp AS STRING
    LOCAL nbrOfChannels, bufSize, y, x, decSampleCnt, resultVar AS LONG
    LOCAL temp(), rms() AS DOUBLE
    LOCAL rmsValue, rmsTotal, newRunningAvg, threeMinuteRmsAvg, tempDequeue AS DOUBLE
    LOCAL scaleFactor AS DOUBLE

    bufSize = %NUMOFCHANNELS * 2 + 4



    'THREAD CREATE ProcessDataThread(1) TO ghPDThread

    gSampleCnt = 0
    gThreeMinutesPassed = 0
    decSampleCnt = 0
    oldRMSUpdate = 0
    newRMSUpdate = 0

    REDIM temp(8,250) 'to hold 5 seconds of 8 channel samples
    REDIM rms(250)

    startDoubleQueue(gRunningRMSAVGQueue)


    'OPEN "c:\test_" + DATE$ + "_" + TIME$ FOR OUTPUT AS #1
    DO
        INCR gSampleCnt
        TCP RECV TCPSocket, bufSize, buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF

        CALL calcTimeElapsed()

        IF (gSampleCnt MOD 20 = 0) THEN 'work with every 20th sample (50 samples/sec)
            INCR decSampleCnt
            '#DEBUG PRINT buffer
            SELECT CASE %NUMOFCHANNELS
                CASE 20     'we will only work with the 1st 8 channels, though.
                    LOCAL ch20 AS Channel20

                     ch20.ChannelStr = buffer
                     '#debug print buffer + " len: " + str$(len(buffer))

                    '#DEBUG PRINT "decSampleCnt: " + STR$(decSampleCnt)
                    FOR x = 1 TO %USEDCHANNELS
                        SELECT CASE x
                            CASE 5
                                scaleFactor = gChan05Scale
                            CASE 6
                                scaleFactor = gChan06Scale
                            CASE 7
                                scaleFactor = gChan07Scale
                            CASE 8
                                scaleFactor = gChan08Scale
                        END SELECT
                        ch20.Channels(x) = SwapBytesWord(ch20.Channels(x)) * scaleFactor
                        '#DEBUG PRINT "chan: " + STR$(x) + " " + STR$(ch20.Channels(x))
                        temp(x, decSampleCnt) = ch20.Channels(x)
                    NEXT x
'                    gStatus = FORMAT$(ch20.Channels(1), "000") + " " + FORMAT$(ch20.Channels(2), "000") + " " + _
'                                FORMAT$(ch20.Channels(3), "000") + " " + FORMAT$(ch20.Channels(4), "000") + " " + _
'                                FORMAT$(ch20.Channels(5), "000") + " " + FORMAT$(ch20.Channels(6), "000") + " " + _
'                                FORMAT$(ch20.Channels(7), "000") + " " + FORMAT$(ch20.Channels(8), "000") + " "
'                    CONTROL SET TEXT hDlg, %IDC_LABEL_Status, gStatus
'                    CONTROL REDRAW hDlg, %IDC_LABEL_Status
            END SELECT
        END IF




        IF (gSeconds MOD 5 = 0 AND gSampleCnt = 0) THEN 'every 5 seconds
            decSampleCnt = 0
            #DEBUG PRINT " "
            #DEBUG PRINT "5 seconds..."
            rmsTotal = 0
            FOR x = 1 TO %USEDCHANNELS
                FOR y = 1 TO 250
                    rms(y) = temp(x, y)
                NEXT y
                rmsValue = rmsDouble(rms(), 250)
                #DEBUG PRINT "rmsValue for channel " + STR$(x) + " = " + STR$(rmsValue)
                rmsTotal += rmsValue
            NEXT x

            #DEBUG PRINT "rmsTotal for 8 channels " + " = " + STR$(rmsTotal)

            gRmsAvg = (rmsTotal / 8)
            #DEBUG PRINT "rmsAvg for 8 channels " + " = " + STR$(gRmsAvg)

            gRunningRmsAvg += gRmsAvg - gRmsTotalOld
            #DEBUG PRINT "running total rmsAvg for 8 channels " + " = " + STR$(gRunningRmsAvg)
            gRMSStatus =  FORMAT$(gRmsAvg, "###")
            CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, gRMSStatus
            CONTROL REDRAW hDlg, %IDC_LABEL_RMS

            CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MinLowerThreshold TO temp
            gMinThresholdLower = VAL(TRIM$(temp))
            CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MaxLowerThreshold TO temp
            gMaxThresholdLower = VAL(TRIM$(temp))
            CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MinUpperThreshold TO temp
            gMinThresholdUpper = VAL(TRIM$(temp))
            CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MaxUpperThreshold TO temp
            gMaxThresholdUpper = VAL(TRIM$(temp))


            IF (gMinutes = 3) THEN
                gThreeMinutesPassed = 1
            END IF

            IF (gSeconds MOD 5 = 0 AND gThreeMinutesPassed = 1 AND gSampleCnt = 0) THEN
                #DEBUG PRINT " "
                #DEBUG PRINT "5 seconds after 3 minutes..."

                threeMinuteRmsAvg = meanDoubleQueue(gRunningRMSAVGQueue)
                #DEBUG PRINT "Moving RMS Avg (using queue): " + STR$(threeMinuteRmsAvg)
                CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, FORMAT$(threeMinuteRmsAvg, "###")
                CONTROL REDRAW hDlg, %IDC_LABEL_RMS


                'threeMinuteRmsAvg = gRunningRmsAvg / 36
                'gRmsTotalOld = gRmsAvg
                '#DEBUG PRINT "Moving RMS Avg: " + STR$(threeMinuteRmsAvg)

                'rmsTotals -= oldRMSUpdate
                'CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, FORMAT$(threeMinuteRmsAvg, "###")
                'CONTROL REDRAW hDlg, %IDC_LABEL_RMS
            END IF

            IF (gThreeMinutesPassed = 1) THEN
                tempDequeue = doubleDequeue(gRunningRMSAVGQueue)
                #DEBUG PRINT "Dequeue: " + STR$(tempDequeue)
                'debugDisplayDoubleQueue(gRunningRMSAVGQueue)
                #DEBUG PRINT "Enqueue: " + STR$(gRmsAvg)
                doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
                'debugDisplayDoubleQueue(gRunningRMSAVGQueue)
                IF (threeMinuteRmsAvg >= gMinThresholdUpper AND threeMinuteRmsAvg <= gMaxThresholdUpper) THEN
                    PlaySound "THRESHOLD_HIGH",  0, %SND_ASYNC + %SND_RESOURCE
                    'PLAY WAVE "THRESHOLD_HIGH" TO resultVar
                    'PLAY WAVE END
                END IF
                CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, FORMAT$(threeMinuteRmsAvg, "###")
                CONTROL REDRAW hDlg, %IDC_LABEL_RMS
            ELSE
                doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
            END IF
            'debugDisplayDoubleQueue(runningRMSAVGQueue)


        END IF



        '#debug print str$(gMilliCnt)



    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR
    CLOSE #1
END SUB



FUNCTION ProcessTCPIPWorkerFunc(BYVAL x AS LONG) AS LONG

    CALL processBuffer()
    'CALL calcTimeElapsed()

END FUNCTION



THREAD FUNCTION ProcessTCPIPThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessTCPIPWorkerFunc(x)

END FUNCTION

FUNCTION ProcessDataWorkerFunc(BYVAL x AS LONG) AS LONG

WHILE(1)
    CALL calcTimeElapsed()
WEND
END FUNCTION



THREAD FUNCTION ProcessDataThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessDataWorkerFunc(x)

END FUNCTION

FUNCTION rmsDouble(intArray() AS DOUBLE, arrSize AS INTEGER) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = arrSize
    sum = 0.0
    FOR i = 0 TO n
        sum += intArray(i) * intArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

SUB calcTimeElapsed()
    LOCAL threeMinuteRmsAvg AS DOUBLE

    IF (gSampleCnt = 1000) THEN 'gives me a millisecond
        gSampleCnt = 0
        INCR gSeconds
        CONTROL SET TEXT hDlg, %IDC_LABEL_Clock, FORMAT$(gMinutes, "000") + ":" + FORMAT$(gSeconds, "00")
        CONTROL REDRAW hDlg, %IDC_LABEL_Clock
    END IF
    IF (gSeconds > 59) THEN
        gSeconds = 0
        INCR gMinutes
        CONTROL SET TEXT hDlg, %IDC_LABEL_Clock, FORMAT$(gMinutes, "000") + ":" + FORMAT$(gSeconds, "00")
        CONTROL REDRAW hDlg, %IDC_LABEL_Clock
    END IF
    SLEEP 0
END SUB

SUB loadDefaults()
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "fEEGKappaClockRMS.ini"


    GetPrivateProfileString("OPTIONS", "IP", "", temp, 2048, filename)
    gIPAddress = TRIM$(temp)
    GetPrivateProfileString("OPTIONS", "PORT", "", temp, 2048, filename)
    gPort = VAL (temp)
    GetPrivateProfileString("OPTIONS", "CHAN05SCALE", "1", temp, 2048, filename)
    gChan05Scale = VAL(temp)
    GetPrivateProfileString("OPTIONS", "CHAN05SCALE", "1", temp, 2048, filename)
    gChan05Scale = VAL(temp)
    GetPrivateProfileString("OPTIONS", "CHAN06SCALE", "1", temp, 2048, filename)
    gChan06Scale = VAL(temp)
    GetPrivateProfileString("OPTIONS", "CHAN07SCALE", "1", temp, 2048, filename)
    gChan07Scale = VAL(temp)
    GetPrivateProfileString("OPTIONS", "CHAN08SCALE", "1", temp, 2048, filename)
    gChan08Scale = VAL(temp)
    GetPrivateProfileString("OPTIONS", "MINTHRESHOLDUPPER", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_MinUpperThreshold, temp
    gMinThresholdUpper = VAL(temp)
    GetPrivateProfileString("OPTIONS", "MAXTHRESHOLDUPPER", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_MaxUpperThreshold, temp
    gMaxThresholdUpper = VAL(temp)
    GetPrivateProfileString("OPTIONS", "MINTHRESHOLDLOWER", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_MinLowerThreshold, temp
    gMinThresholdLower = VAL(temp)
    GetPrivateProfileString("OPTIONS", "MAXTHRESHOLDLOWER", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_MaxlowerThreshold, temp
    gMaxThresholdLower = VAL(temp)

END SUB

SUB saveDefaults()
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "fEEGKappaClockRMS.ini"

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MinLowerThreshold TO temp
    temp = TRIM$(temp)
    WritePrivateProfileString("OPTIONS", "MINTHRESHOLDLOWER", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MaxLowerThreshold TO temp
    temp = TRIM$(temp)
    WritePrivateProfileString("OPTIONS", "MAXTHRESHOLDLOWER", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MinUpperThreshold TO temp
    temp = TRIM$(temp)
    WritePrivateProfileString("OPTIONS", "MINTHRESHOLDUPPER", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_MaxUpperThreshold TO temp
    temp = TRIM$(temp)
    WritePrivateProfileString("OPTIONS", "MAXTHRESHOLDUPPER", temp, filename)
END SUB

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD
    LOCAL hFont4 AS DWORD

    DIALOG NEW PIXELS, hParent, "fEEG Kappa Clock", 105, 114, 643, 236, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Clock, "000:00", 320, 4, 318, 123, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL SET COLOR     hDlg, %IDC_LABEL_Clock, %WHITE, %BLACK
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Connect, "Connect", 288, 160, 76, _
        32
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Status, "", 0, 208, 632, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_RMS, "", 8, 4, 288, 123, %WS_CHILD _
        OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER OR %SS_SUNKEN, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Settings, "Settings", 528, 176, _
        104, 24
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "Additional Settings", 8, 234, _
        616, 136
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Min LowerThreshold:", 40, 261, _
        152, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_MinLowerThreshold, "", 192, 261, _
        96, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_MaxLowerThreshold, "", 192, 290, _
        96, 24
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Max LowerThreshold:", 40, 290, _
        152, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_MaxUpperThreshold, "", 464, 290, _
        96, 24
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Max UpperThreshold:", 312, 290, _
        152, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_MinUpperThreshold, "", 464, 261, _
        96, 24
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "Min UpperThreshold:", 312, 261, _
        152, 24

    FONT NEW "Arial", 72, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "", 48, 0, %ANSI_CHARSET TO hFont3
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont4

    CONTROL SET FONT hDlg, %IDC_LABEL_Clock, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Connect, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_RMS, hFont3
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Settings, hFont4
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont4
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_MinLowerThreshold, hFont4
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_MaxLowerThreshold, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont4
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_MaxUpperThreshold, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont4
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_MinUpperThreshold, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont4
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
    FONT END hFont4
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
