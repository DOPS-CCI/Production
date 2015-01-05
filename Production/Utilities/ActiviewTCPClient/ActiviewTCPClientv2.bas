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
#RESOURCE "ActiviewTCPClientv2.pbr"
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
%IDD_DIALOG1                       =  101
%IDC_LABEL1                        = 1001
%IDC_TEXTBOX_TCPServer             = 1002
%IDC_LABEL2                        = 1003
%IDC_TEXTBOX_TCPPort               = 1004
%IDC_LABEL3                        = 1005
%IDC_TEXTBOX_BytesInTCPArray       = 1006
%IDC_LABEL4                        = 1008
%IDC_TEXTBOX_ChannelsSentByTCP     = 1007
%IDC_LABEL5                        = 1010
%IDC_TEXTBOX_TCPSamplesPerChannel  = 1009
%IDC_BUTTON_Connect                = 1011
%IDC_BUTTON_Disconnect             = 1012
%IDC_FRAME1                        = 1013
%IDC_CHECKBOX_Connected            = 1014
%IDC_LISTBOX_RecvBuffer            = 1015
%IDC_LABEL6                        = 1016   '*
%IDC_LABEL7                        = 1018
%IDC_TEXTBOX_ReceiverTimeout       = 1017
%IDC_LABEL_TCPBuffer               = 1019   '*
%IDC_BUTTON_Close                  = 1020   '*
%IDC_BUTTON_Process                = 1021   '*
%IDC_LABEL_Status                  = 1022
%IDC_BUTTON_LoadDefaults           = 1023
%IDC_BUTTON_SaveDefaults           = 1024
%IDC_LABEL_Clock                   = 1025
%IDC_LABEL_RMS                     = 1026
%IDC_CHECKBOX_Settings             = 1027
%IDC_COMBOBOXTCPSubset             = 1028
%IDC_LABEL8                        = 1029
%IDC_TEXTBOX1                      = 1030   '*
%IDC_CHECKBOX_Add9Jazz             = 1033
%IDC_CHECKBOX_Add7Sensors          = 1032
%IDC_CHECKBOX_Add8EXElectrodes     = 1031
%IDC_CHECKBOX_Add32AIBChan         = 1034
%IDC_CHECKBOX_AddTriggerStatusChan = 1035
%IDC_LABEL9                        = 1036   '*
%IDC_CHECKBOX_ChannelsToUse        = 1038
%IDC_LISTBOX_ChannelsToUse         = 1039
%IDC_BUTTON_BiosemiCfgFile         = 1040
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'#INCLUDE "TCPProcessing.inc"
#INCLUDE "DoubleQueueUsingArray.inc"

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

%SAMPLE_RATE = 512

GLOBAL hDlg AS DWORD
GLOBAL TCPSocket AS LONG
GLOBAL hDlg AS DWORD
GLOBAL ghPDThread AS LONG
GLOBAL gSample, gSampleBuffer, gStatus AS STRING
GLOBAL gIPAddress AS STRING
GLOBAL gActiviewConfig AS ASCIIZ *512
GLOBAL gPort AS LONG
GLOBAL gRunningRMSAVGQueue AS doubleQueueInfo
GLOBAL gRunningRmsAvg, gRmsTotalOld, gRmsAvg AS DOUBLE
GLOBAL gStatus, gRMSStatus AS STRING
GLOBAL gBytesInTCPArray, gChannelsSentByTCP, gTCPSamplesPerChannel AS LONG
GLOBAL gTCPSubset, gAdd8EXElectrodes, gAdd7Sensors, gAdd9Jazz, gAdd32AIBChan, gAddTriggerStatusChan AS LONG
GLOBAL gSampleCnt, gSeconds, gMinutes, gSlidingWindowMark, gChannelsUsed AS LONG
GLOBAL gSamplesForXSeconds AS LONG
GLOBAL sampleArray() AS LONG
GLOBAL selectedChannels() AS LONG


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
    LOCAL x, cnt, lResult, selectedCount, lbCount, selected AS LONG

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
                ' /* Inserted by PB/Forms 10-21-2013 11:55:38
                CASE %IDC_BUTTON_BiosemiCfgFile
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Choose your Biosemi config file", "", CHR$("Config", 0, "*.CFG", 0), _
                                            "", "CFG", %OFN_FILEMUSTEXIST  TO gActiviewConfig
                        IF (TRIM$(gActiviewConfig) = "") THEN
                            MSGBOX "No Biosemi config file chosen"
                            EXIT FUNCTION
                        END IF
                    END IF
                ' */

                ' /* Inserted by PB/Forms 10-18-2013 15:04:02
                CASE %IDC_LISTBOX_ChannelsToUse
                ' */

                ' /* Inserted by PB/Forms 10-18-2013 11:43:11
                CASE %IDC_CHECKBOX_ChannelsToUse
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ChannelsToUse TO lResult
                    IF (lResult = 1) THEN
                        CALL buildChannelsToUse()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 10-18-2013 11:39:36
                ' /* Inserted by PB/Forms 10-18-2013 09:48:04
                CASE %IDC_COMBOBOXTCPSubset

                CASE %IDC_CHECKBOX_Add8EXElectrodes

                CASE %IDC_CHECKBOX_Add7Sensors

                CASE %IDC_CHECKBOX_Add9Jazz

                CASE %IDC_CHECKBOX_Add32AIBChan

                CASE %IDC_CHECKBOX_AddTriggerStatusChan
                ' */

                ' /* Inserted by PB/Forms 10-18-2013 08:46:45
                CASE %IDC_CHECKBOX_Settings
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Settings TO lResult
                    IF (lResult = 1) THEN 'checked
                        DIALOG SET SIZE hDlg, 606, 780
                        CONTROL SET LOC hDlg, %IDC_LABEL_Status, 0, 719

                    ELSE
                        DIALOG SET SIZE hDlg, 606, 310
                        CONTROL SET LOC hDlg, %IDC_LABEL_Status, 0, 257
                    END IF

                ' */

                ' /* Inserted by PB/Forms 10-15-2013 10:54:29
                CASE %IDC_BUTTON_LoadDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL loadDefaults()
                    END IF

                CASE %IDC_BUTTON_SaveDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL saveDefaults()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 06-18-2013 09:38:13

                ' /* Inserted by PB/Forms 06-18-2013 08:55:14
                CASE %IDC_TEXTBOX_ReceiverTimeout
                ' */

                CASE %IDC_TEXTBOX_TCPServer

                CASE %IDC_TEXTBOX_TCPPort

                CASE %IDC_TEXTBOX_BytesInTCPArray

                CASE %IDC_TEXTBOX_ChannelsSentByTCP

                CASE %IDC_TEXTBOX_TCPSamplesPerChannel

                CASE %IDC_BUTTON_Connect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                       'Check to see if any channels have been selected to use in the processing
                       LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO lResult

                       IF (lResult = 0) THEN
                           MSGBOX "No channels have been selected to use. Please select the channels to use."
                           EXIT FUNCTION
                       END IF

                       'If channels have been selected - store them in array called
                       'selectedChannels that will be used when processing the TCPIP
                       'packages.
                       LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO gChannelsUsed
                       REDIM selectedChannels(gChannelsUsed)

                       LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO lbCount
                       cnt = 0
                       FOR x = 1 TO lbCount
                           LISTBOX GET STATE hDlg, %IDC_LISTBOX_ChannelsToUse, x TO selected
                           IF (selected = -1) THEN  'if selected
                               INCR cnt
                               selectedChannels(cnt) = x
                           END IF
                       NEXT x


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

                        'OPEN "c:\TestData.bin" FOR BINARY AS #1

                        THREAD CREATE ProcessTCPIPThread(1) TO ghPDThread
                    END IF

                CASE %IDC_BUTTON_Disconnect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        TCP CLOSE TCPSocket
                        'CLOSE #1
                    END IF

                CASE %IDC_CHECKBOX_Connected

                CASE %IDC_LISTBOX_RecvBuffer

            END SELECT
             CASE %WM_DESTROY
                TCP CLOSE TCPSocket
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

UNION littleEnd
    bytes(1 TO 4) AS BYTE
    nbr AS LONG
END UNION

SUB processBuffer()
    LOCAL buffer AS STRING
    LOCAL temp AS LONG
    LOCAL bufSize, x, y, bufPtr, yPtr, resultVar AS LONG
    LOCAL decSampleCnt, selectedChannelHit AS LONG
    LOCAL rmsValue, rmsTotal, newRunningAvg, threeMinuteRmsAvg, tempDequeue AS DOUBLE
    LOCAL temp(), rms() AS LONG
    LOCAL conv AS LittleEnd

    bufSize = INT(gBytesInTCPArray / gTCPSamplesPerChannel)

    REDIM sampleArray(gTCPSamplesPerChannel, gChannelsSentByTCP)

    gSampleCnt = 0
    decSampleCnt = 0
    gSlidingWindowMark = 0
    gSeconds = 0
    gMinutes = 0

    gSamplesForXSeconds = (%SAMPLE_RATE/10) * 5
    REDIM temp(gChannelsUsed, gSamplesForXSeconds) 'to hold 5 seconds of X channel samples
    REDIM rms(gSamplesForXSeconds)

    DO
        INCR gSampleCnt
        TCP RECV TCPSocket, bufSize, buffer
        'PUT$ #1, buffer

        '#DEBUG PRINT "buffer: " + buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF

        gSampleBuffer = buffer


        CALL calcTimeElapsed()

        IF (gSampleCnt MOD (%SAMPLE_RATE/10) = 0) THEN '512/11 ~ (50 samples/sec)
            INCR decSampleCnt

            bufPtr = 0
            yPtr = 0
            FOR x = 1 TO gTCPSamplesPerChannel
                FOR y = 1 TO (gChannelsSentByTCP * 3) STEP 3
                    INCR yPtr
                    '#DEBUG PRINT "y: " + STR$(y)
                    '#DEBUG PRINT "yPtr: " + STR$(yPtr)
                    temp = bufPtr + y
                    '#DEBUG PRINT "temp: " + STR$(temp)
                    gSample = MID$(gSampleBuffer, temp, 3)
                    '#DEBUG PRINT "gSample: " + gSample
                    conv.bytes(3) = CVBYT(MID$(gSample, 3, 1))
                    conv.bytes(2) = CVBYT(MID$(gSample, 2, 1))
                    conv.bytes(1) = CVBYT(MID$(gSample, 1, 1))
                    conv.bytes(4) = 0
                    sampleArray(x, yPtr) = conv.nbr
                    'ARRAY SCAN selectedChannels(), = yPtr, TO selectedChannelHit
'                    IF (selectedChannelHit <> 0) THEN
'                        sampleArray(x, yPtr) = conv.nbr
'                    ELSE
'                        sampleArray(x, yPtr) = 0
'                    END IF
                    #DEBUG PRINT "conv.nbr: " + STR$(conv.nbr)
                NEXT y
                yPtr = 0
                bufPtr = bufPtr + gChannelsSentByTCP * 3
            NEXT y
            #DEBUG PRINT "====="

            FOR x = 1 TO gTCPSamplesPerChannel
                yPtr = 0
                FOR y = 1 TO gChannelsSentByTCP
                    'only look at the channels that were selected
                    ARRAY SCAN selectedChannels(), = y, TO selectedChannelHit
                    IF (selectedChannelHit <> 0) THEN
                        INCR yPtr
                        temp(x, yPtr) = sampleArray(x, y)
                        #DEBUG PRINT "temp(" + STR$(x) + "," + STR$(yPtr) + "): " + STR$(temp(x, yPtr))
                    END IF
                NEXT y
            NEXT y

            IF (gSeconds MOD 5 = 0 AND gSampleCnt = 0) THEN 'every 5 seconds
                rmsTotal = 0
                FOR x = 1 TO gChannelsUsed
                    FOR y = 1 TO gSamplesForXSeconds
                        rms(y) = temp(x, y)
                    NEXT y
                    rmsValue = rmsInteger(rms(), gSamplesForXSeconds)
                    rmsTotal += rmsValue
                NEXT x

                #DEBUG PRINT "rmsTotal for " + STR$(gChannelsUsed) + " channels " + " = " + STR$(rmsTotal)

                gRmsAvg = (rmsTotal / (gChannelsUsed * 10))
                #DEBUG PRINT "rmsAvg for " + STR$(gChannelsUsed) + " channels " + " = " + STR$(gRmsAvg)

                gRunningRmsAvg += gRmsAvg - gRmsTotalOld
                #DEBUG PRINT "running total rmsAvg for " + STR$(gChannelsUsed) + " channels " + " = " + STR$(gRunningRmsAvg)
                gRMSStatus =  FORMAT$(gRmsAvg, "###")

                IF (gSlidingWindowMark <> 1) THEN
                    CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, gRMSStatus
                    CONTROL REDRAW hDlg, %IDC_LABEL_RMS
                END IF

                IF (gMinutes = 1) THEN
                    gSlidingWindowMark = 1
                END IF

                IF (gSeconds MOD 5 = 0 AND gSlidingWindowMark = 1 AND gSampleCnt = 0) THEN
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

                IF (gSlidingWindowMark = 1) THEN
                    tempDequeue = doubleDequeue(gRunningRMSAVGQueue)
                    #DEBUG PRINT "Dequeue: " + STR$(tempDequeue)
                    'debugDisplayDoubleQueue(gRunningRMSAVGQueue)
                    #DEBUG PRINT "Enqueue: " + STR$(gRmsAvg)
                    doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
                    'debugDisplayDoubleQueue(gRunningRMSAVGQueue)
                    'IF (threeMinuteRmsAvg >= gMinThresholdUpper AND threeMinuteRmsAvg <= gMaxThresholdUpper) THEN
                    '    PlaySound "THRESHOLD_HIGH",  0, %SND_ASYNC + %SND_RESOURCE
                        'PLAY WAVE "THRESHOLD_HIGH" TO resultVar
                        'PLAY WAVE END
                    'END IF
                    CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, FORMAT$(threeMinuteRmsAvg, "###")
                    CONTROL REDRAW hDlg, %IDC_LABEL_RMS
                ELSE
                    doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
                END IF
            END IF
        END IF

    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR
END SUB

FUNCTION ProcessTCPIPWorkerFunc(BYVAL x AS LONG) AS LONG

    CALL processBuffer()
    'CALL calcTimeElapsed()

END FUNCTION



THREAD FUNCTION ProcessTCPIPThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessTCPIPWorkerFunc(x)

END FUNCTION

SUB calcTimeElapsed()
    LOCAL threeMinuteRmsAvg AS DOUBLE

    IF (gSampleCnt = %SAMPLE_RATE) THEN 'gives me a millisecond
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

FUNCTION rmsInteger(intArray() AS LONG, arrSize AS LONG) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = arrSize
    sum = 0.0
    FOR i = 0 TO n
        sum += intArray(i) * intArray(i)
    NEXT i

    'FUNCTION =  sum / n
    FUNCTION =  SQR(sum / n)
END FUNCTION


SUB buildChannelsToUse()
    LOCAL idx, lResult, x, y, lPtr AS LONG
    LOCAL labl AS ASCIIZ * 256
    LOCAL temp AS ASCIIZ * 256

    COMBOBOX GET SELECT hDlg, %IDC_COMBOBOXTCPSubset TO idx
    SELECT CASE idx
        CASE 1
            lPtr = 0
        CASE 2
            lPtr = 8
        CASE 3
            lPtr = 16
        CASE 4
            lPtr = 32
        CASE 5
            lPtr = 64
        CASE 6
            lPtr = 128
        CASE 7
            lPtr = 160
        CASE 8
            lPtr = 256
    END SELECT

    LISTBOX RESET hDlg, %IDC_LISTBOX_ChannelsToUse

    IF (lPtr > 0) THEN
        FOR x = 1 TO lPtr
           temp = "Chan" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           LISTBOX ADD hDlg, %IDC_LISTBOX_ChannelsToUse, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 8
           temp = "Tou" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           LISTBOX ADD hDlg, %IDC_LISTBOX_ChannelsToUse, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 7
           temp = "Aux" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           LISTBOX ADD hDlg, %IDC_LISTBOX_ChannelsToUse, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 9
           temp = "Jazz" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           LISTBOX ADD hDlg, %IDC_LISTBOX_ChannelsToUse, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 32
           temp = "Box" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           LISTBOX ADD hDlg, %IDC_LISTBOX_ChannelsToUse, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan TO lResult
    IF (lResult = 1) THEN
    END IF

END SUB


SUB loadDefaults()
    LOCAL x, selected AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "ActiviewTCPClient_V2.ini"

    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", gActiviewConfig, 2048, filename)

    IF (ISFILE(gActiviewConfig) = 0) THEN
        MSGBOX "The default Biosemi config file was not found."
    END IF


    GetPrivateProfileString("OPTIONS", "IP", "", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPServer, temp
    gIPAddress = TRIM$(temp)

    GetPrivateProfileString("OPTIONS", "PORT", "", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPPort, temp
    gPort = VAL (temp)

    GetPrivateProfileString("OPTIONS", "BytesInTCPArray", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, temp
    gBytesInTCPArray = VAL(temp)

    GetPrivateProfileString("OPTIONS", "ChannelsSentByTCP", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, temp
    gChannelsSentByTCP = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSamplesPerChannel", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, temp
    gTCPSamplesPerChannel = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSubset", "0", temp, 2048, filename)
    gTCPSubset = VAL(temp)
    SELECT CASE TRIM$(temp)
        CASE "0"
            temp = "None   (0)"
        CASE "1"
            temp = "A1-A8  (8)"
        CASE "2"
            temp = "A1-A16 (16)"
        CASE "3"
            temp = "A1-A32 (32)"
        CASE "4"
            temp = "A1-B32 (64)"
        CASE "5"
            temp = "A1-D32 (128)"
        CASE "6"
            temp = "A1-E32 (160)"
        CASE "7"
            temp = "A1-H32 (256)"
    END SELECT
    CONTROL SET TEXT hDlg, %IDC_COMBOBOXTCPSubset, temp
    COMBOBOX SELECT hDlg, %IDC_COMBOBOXTCPSubset, gTCPSubset + 1

    GetPrivateProfileString("OPTIONS", "Add8EXElectrodes", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes, 1
        gAdd8EXElectrodes = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes, 0
        gAdd8EXElectrodes = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add7Sensors", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors, 1
        gAdd7Sensors = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors, 0
        gAdd7Sensors = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add9Jazz", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz, 1
        gAdd9Jazz = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz, 0
        gAdd9Jazz = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add32AIBChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan, 1
        gAdd32AIBChan = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan, 0
        gAdd32AIBChan = 0
    END IF

    GetPrivateProfileString("OPTIONS", "AddTriggerStatusChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, 1
        gAddTriggerStatusChan = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, 0
        gAddTriggerStatusChan = 0
    END IF

    CALL buildChannelsToUse()

    GetPrivateProfileString("OPTIONS", "ChannelsUsed", "", temp, 2048, filename)
    gChannelsUsed = PARSECOUNT(temp, ",") - 1

    IF (gChannelsUsed > 0) THEN
        FOR x = 1 TO gChannelsUsed
            selected = VAL(PARSE$(temp, ",", x))
            LISTBOX SELECT hDlg, %IDC_LISTBOX_ChannelsToUse, selected
        NEXT x
    END IF

END SUB

SUB saveDefaults()
    LOCAL x, idx, lResult, lbCount, cnt, selected AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "ActiviewTCPClient_V2.ini"

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPServer TO temp
    WritePrivateProfileString("OPTIONS", "IP", TRIM$(temp), filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPPort TO temp
    WritePrivateProfileString("OPTIONS", "Port", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray TO temp
    WritePrivateProfileString("OPTIONS", "BytesInTCPArray", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP TO temp
    WritePrivateProfileString("OPTIONS", "ChannelsSentByTCP", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel TO temp
    WritePrivateProfileString("OPTIONS", "TCPSamplesPerChannel", TRIM$(temp), filename)

    COMBOBOX GET SELECT hDlg, %IDC_COMBOBOXTCPSubset TO idx
    WritePrivateProfileString("OPTIONS", "TCPSubset", STR$(idx - 1), filename)


    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes TO lResult
    WritePrivateProfileString("OPTIONS", "Add8EXElectrodes", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors TO lResult
    WritePrivateProfileString("OPTIONS", "Add7Sensors", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz TO lResult
    WritePrivateProfileString("OPTIONS", "Add9Jazz", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan TO lResult
    WritePrivateProfileString("OPTIONS", "Add32AIBChan", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan TO lResult
    WritePrivateProfileString("OPTIONS", "AddTriggerStatusChan", STR$(lResult), filename)

    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO gChannelsUsed
    REDIM selectedChannels(gChannelsUsed)

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO lbCount
    cnt = 0
    temp = ""
    FOR x = 1 TO lbCount
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ChannelsToUse, x TO selected
        IF (selected = -1) THEN  'if selected
            INCR cnt
            temp = temp + STR$(x) + ","
        END IF
    NEXT x

    WritePrivateProfileString("OPTIONS", "ChannelsUsed", TRIM$(temp), filename)

    MSGBOX "Defaults saved."
END SUB

FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL idx AS LONG

    CONTROL SEND hDlg, %IDC_COMBOBOXTCPSubset, %CB_SETEXTENDEDUI, %TRUE, 0


    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "None   (0)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-A8  (8)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-A16 (16)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-A32 (32)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-B32 (64)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-D32 (128)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-E32 (160)" TO idx
    COMBOBOX ADD hDlg, %IDC_COMBOBOXTCPSubset, "A1-H32 (256)" TO idx

    CONTROL SET TEXT hDlg, %IDC_COMBOBOXTCPSubset, "None   (0)"
END FUNCTION

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

    DIALOG NEW PIXELS, hParent, "Actiview TCP Client", 360, 72, 606, 282, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR _
        %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_CONTEXTHELP _
        OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
        %WS_EX_CONTROLPARENT OR %WS_EX_CONTEXTHELP OR %WS_EX_TOOLWINDOW OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Connect, "Connect", 376, 168, _
        106, 41
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Disconnect, "Disconnect", 488, _
        168, 105, 41
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Settings, "Settings", 221, 224, _
        112, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPServer, "", 206, 317, 187, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPPort, "", 476, 317, 82, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_BytesInTCPArray, "", 207, 358, _
        83, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ReceiverTimeout, "60000", 458, _
        359, 82, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, "", 208, 392, _
        83, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, "", 208, _
        424, 83, 26
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_LoadDefaults, "Load Defaults", _
        176, 672, 105, 41
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_SaveDefaults, "Save Defaults", _
        296, 672, 105, 41
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Actiview TCP Server IP:", 10, _
        317, 188, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Port:", 416, 317, 52, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Bytes in TCP Array:", 57, 358, _
        144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Channels sent by TCP:", 3, 390, _
        199, 26, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "TCP Samples/channel:", 33, 424, _
        169, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "Actiview Server Information", _
        0, 286, 600, 370
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL7, "Receiver Timeout:", 308, 359, _
        144, 25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Status, "", 0, 254, 608, 25, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Clock, "000:00", 285, 8, 315, 114, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_RMS, "000", 3, 8, 270, 114, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOXTCPSubset, , 40, 497, 144, 152, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %CBS_DROPDOWN, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL8, "TCP subset:", 40, 473, 144, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add8EXElectrodes, "Add 8 EX " + _
        "electrodes", 208, 495, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add7Sensors, "Add 7 Sensors", _
        208, 519, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add9Jazz, "Add 9 Jazz", 208, _
        543, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add32AIBChan, "Add 32 AIB " + _
        "Chan", 208, 567, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, "Add " + _
        "Trigger/Status Chan", 208, 591, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ChannelsToUse, "Channels to use " + _
        "(Refresh)", 8, 128, 204, 24
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_ChannelsToUse, , 8, 152, 200, _
        88, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %WS_TABSTOP OR _
        %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_BiosemiCfgFile, "Biosemi Cfg " + _
        "file", 220, 157, 120, 64

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial", 72, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT hDlg, %IDC_BUTTON_Connect, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Disconnect, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Settings, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPServer, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPPort, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_BytesInTCPArray, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ReceiverTimeout, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_SaveDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL7, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_Status, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_Clock, hFont3
    CONTROL SET FONT hDlg, %IDC_LABEL_RMS, hFont3
    CONTROL SET FONT hDlg, %IDC_COMBOBOXTCPSubset, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL8, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add8EXElectrodes, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add7Sensors, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add9Jazz, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add32AIBChan, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ChannelsToUse, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_ChannelsToUse, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_BiosemiCfgFile, hFont1
#PBFORMS END DIALOG

    SampleComboBox  hDlg, %IDC_COMBOBOXTCPSubset, 8

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
