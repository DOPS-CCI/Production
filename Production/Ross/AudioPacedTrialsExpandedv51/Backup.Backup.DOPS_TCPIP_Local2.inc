#INCLUDE ONCE "winbase.inc"

TYPE TCPIPDef
    ActiviewConfigFile AS ASCIIZ * 512
    IPAddress AS ASCIIZ * 256
    IPPort AS LONG
    TCPIPSocket AS LONG
    BytesInTCPArray AS LONG
    ChannelsSentByTCP AS LONG
    TCPSamplesPerChannel AS LONG
    TCPSubset AS LONG
    TCPSubsetStr AS ASCIIZ * 256
    Add8EXElectrodes AS LONG
    Add7Sensors AS LONG
    Add9Jazz AS LONG
    Add32AIBChan AS LONG
    AddTriggerStatusChan AS LONG
    ChannelsToUse AS LONG
    ChannelsToUseArray(999) AS ASCIIZ * 30
    ChannelsUsed AS LONG
    ChannelsUsedArray(1 TO 999) AS LONG
    SampleRate AS LONG
    ThrottledSampleRate AS LONG
    DecimatedSampleRate AS LONG
END TYPE

TYPE TCPIPBuf
    SampleCnt AS LONG
    SampleArray(1 TO 99999) AS LONG
    SampleArrayCount AS LONG
END TYPE

GLOBAL TCPIPSettings AS TCPIPDef
GLOBAL TCPIPBuffer AS TCPIPBuf
GLOBAL TCPIPCriticalSection AS Critical_Section
GLOBAL gSeconds, gMinutes, gSlidingWindowMark, gResetSampleArrayCount AS LONG
GLOBAL hDlg AS DWORD
GLOBAL RMSChannelsToUseArrayCnt AS LONG
GLOBAL RMSChannelsToUseArray() AS DOUBLE
GLOBAL gRunningRmsAvg, gRmsTotalOld, gRmsAvg, gRunningRmsAvg, gPrevAvgRMS AS DOUBLE
GLOBAL gThreeMinutesPassed AS LONG



SUB loadTCPIPDefaults(filename AS ASCIIZ * 512)
    LOCAL x, selected AS LONG
    LOCAL temp, temp2 AS ASCIIZ * 255
    LOCAL eegFilename AS ASCIIZ * 512
    DIM target(1 TO 999) AS STRING


    GetPrivateProfileString("Experiment Section", "EEGDefaultFilename", "", eegFilename, 2048, filename)
    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", TCPIPSettings.ActiviewConfigFile, 2048, eegFilename)

    IF (ISFILE(TCPIPSettings.ActiviewConfigFile) = 0) THEN
        MSGBOX "The default Biosemi config file was not found."
    END IF

    GetPrivateProfileString("OPTIONS", "SampleRate", "", temp, 2048, eegFilename)
    TCPIPSettings.SampleRate = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "ThrottledSampleRate", "", temp, 2048, eegFilename)
    TCPIPSettings.ThrottledSampleRate = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "IP", "", temp, 2048, eegFilename)
    TCPIPSettings.IPAddress = TRIM$(temp)

    GetPrivateProfileString("OPTIONS", "PORT", "", temp, 2048, eegFilename)
    TCPIPSettings.IPPort = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "BytesInTCPArray", "1", temp, 2048, eegFilename)
    TCPIPSettings.BytesInTCPArray = VAL(temp)

    GetPrivateProfileString("OPTIONS", "ChannelsSentByTCP", "1", temp, 2048, eegFilename)
    TCPIPSettings.ChannelsSentByTCP = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSamplesPerChannel", "1", temp, 2048, eegFilename)
    TCPIPSettings.TCPSamplesPerChannel = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSubset", "0", temp2, 2048, eegFilename)
    TCPIPSettings.TCPSubset = VAL(temp2)
    SELECT CASE TRIM$(temp2)
        CASE "7"
            temp = "None   (0)"
        CASE "6"
            temp = "A1-A8  (8)"
        CASE "5"
            temp = "A1-A16 (16)"
        CASE "4"
            temp = "A1-A32 (32)"
        CASE "3"
            temp = "A1-B32 (64)"
        CASE "2"
            temp = "A1-D32 (128)"
        CASE "1"
            temp = "A1-E32 (160)"
        CASE "0"
            temp = "A1-H32 (256)"
    END SELECT
    TCPIPSettings.TCPSubsetStr = temp

    GetPrivateProfileString("OPTIONS", "Add8EXElectrodes", "0", temp, 2048, eegFilename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add8EXElectrodes = 1
    ELSE
        TCPIPSettings.Add8EXElectrodes = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add7Sensors", "0", temp, 2048, eegFilename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add7Sensors = 1
    ELSE
        TCPIPSettings.Add7Sensors = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add9Jazz", "0", temp, 2048, eegFilename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add9Jazz = 1
    ELSE
        TCPIPSettings.Add9Jazz = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add32AIBChan", "0", temp, 2048, eegFilename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add32AIBChan = 1
    ELSE
        TCPIPSettings.Add32AIBChan = 0
    END IF

    GetPrivateProfileString("OPTIONS", "AddTriggerStatusChan", "0", temp, 2048, eegFilename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.AddTriggerStatusChan = 1
    ELSE
        TCPIPSettings.AddTriggerStatusChan = 0
    END IF

    CALL buildChannelsToUse()

    GetPrivateProfileString("OPTIONS", "ChannelsUsed", "", temp, 2048, eegFilename)
    TCPIPSettings.ChannelsUsed = PARSECOUNT(temp, ",") - 1
    PARSE temp, target(), ","

    IF (TCPIPSettings.ChannelsUsed > 0) THEN
        FOR x = 1 TO TCPIPSettings.ChannelsUsed
            TCPIPSettings.ChannelsUsedArray(x) = VAL(target$(x))
        NEXT x
    END IF

END SUB

SUB buildChannelsToUse()
    LOCAL cnt, idx, lResult, x, y, lPtr AS LONG
    LOCAL labl AS ASCIIZ * 256
    LOCAL temp AS ASCIIZ * 256
    LOCAL tempArray() AS ASCIIZ * 30

    idx = TCPIPSettings.TCPSubset
    SELECT CASE idx
        CASE 7
            lPtr = 0
        CASE 6
            lPtr = 8
        CASE 5
            lPtr = 16
        CASE 4
            lPtr = 32
        CASE 3
            lPtr = 64
        CASE 2
            lPtr = 128
        CASE 1
            lPtr = 160
        CASE 0
            lPtr = 256
    END SELECT

    TCPIPSettings.ChannelsToUse = lPtr
    IF (TCPIPSettings.Add8EXElectrodes = 1) THEN
        TCPIPSettings.ChannelsToUse += 8
    END IF
    IF (TCPIPSettings.Add7Sensors = 1) THEN
        TCPIPSettings.ChannelsToUse += 7
    END IF
    IF (TCPIPSettings.Add9Jazz = 1) THEN
        TCPIPSettings.ChannelsToUse += 9
    END IF
    IF (TCPIPSettings.Add32AIBChan = 1) THEN
        TCPIPSettings.ChannelsToUse += 32
    END IF

    REDIM tempArray(TCPIPSettings.ChannelsToUse)

    cnt = 0
    IF (lPtr > 0) THEN
        FOR x = 1 TO lPtr
           INCR cnt
           temp = "Chan" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, TCPIPSettings.ActiviewConfigFile)
           tempArray(cnt) = temp + "=" + labl
        NEXT x
    END IF

    IF (TCPIPSettings.Add8EXElectrodes = 1) THEN
        FOR x = 1 TO 8
            INCR cnt
           temp = "Tou" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, TCPIPSettings.ActiviewConfigFile)
           tempArray(cnt) = temp + "=" + labl
        NEXT x
    END IF

    IF (TCPIPSettings.Add7Sensors = 1) THEN
        FOR x = 1 TO 7
           INCR cnt
           temp = "Aux" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, TCPIPSettings.ActiviewConfigFile)
           tempArray(cnt) = temp + "=" + labl
        NEXT x
    END IF

    IF (TCPIPSettings.Add9Jazz = 1) THEN
        FOR x = 1 TO 9
           INCR cnt
           temp = "Jazz" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, TCPIPSettings.ActiviewConfigFile)
           tempArray(cnt) = temp + "=" + labl
        NEXT x
    END IF

    IF (TCPIPSettings.Add32AIBChan = 1) THEN
        FOR x = 1 TO 32
           INCR cnt
           temp = "Box" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, TCPIPSettings.ActiviewConfigFile)
           tempArray(cnt) = temp + "=" + labl
        NEXT x
    END IF

    FOR x = 1 TO TCPIPSettings.ChannelsToUse
        TCPIPSettings.ChannelsToUseArray(x) = tempArray(x)
    NEXT x

    'CONTROL GET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan TO lResult
    'IF (lResult = 1) THEN
    'END IF

END SUB

FUNCTION connectToServer(BYVAL sIPAddress AS STRING, BYVAL lPort AS LONG, BYREF TCPSocket AS LONG) AS INTEGER

    TCP OPEN PORT lPort AT sIPAddress AS TCPSocket TIMEOUT 30000
    ' Could we connect to site?

    IF ERR THEN
        MSGBOX "Could not connect. Error: " + ERROR$
        FUNCTION = ERR
        EXIT FUNCTION
    END IF

    InitializeCriticalSection(TCPIPCriticalSection)

    FUNCTION = 0
END FUNCTION

SUB disconnectFromServer(BYVAL TCPSocket AS LONG)
    DeleteCriticalSection(TCPIPCriticalSection)
    TCP CLOSE TCPSocket
END SUB

SUB processServerData(BYVAL TCPSocket AS LONG)
    LOCAL hPDThread AS LONG
    THREAD CREATE ProcessTCPIPThread(TCPSocket) TO hPDThread
END SUB

FUNCTION ProcessTCPIPWorkerFunc(BYVAL TCPSocket AS LONG) AS LONG

    CALL processBuffer(TCPSocket)
    'CALL calcTimeElapsed()

END FUNCTION



THREAD FUNCTION ProcessTCPIPThread(BYVAL TCPSocket AS LONG) AS LONG

 FUNCTION = ProcessTCPIPWorkerFunc(TCPSocket)

END FUNCTION

UNION littleEnd
    bytes(1 TO 4) AS BYTE
    nbr AS LONG
END UNION

'****************************************************************************************
'The processBuffer() function must created in calling program. It is the method that will
'process incoming TCP data from the server. A value must be passed into the
'processBuffer() method that represents the socket connection that is obtained from
'calling the connectToServer(server, port, socket) function.
'****************************************************************************************
SUB processBuffer(BYVAL TCPSocket AS LONG)
    LOCAL delayFlag AS BYTE
    LOCAL bufSize, decimatedSampleRate, itemCnt AS LONG
    LOCAL i, x, y, z, bufPtr, yPtr, temp, chanCnt, selectedChannelHit AS LONG
    LOCAL emgSample, eegSample, lSample, lConvSample, EEGEventCnt, EEGSelectCnt, EEGSelectedCnt AS LONG
    LOCAL fHnd, itemState, sumEEGChannels AS LONG
    LOCAL sample AS STRING * 4
    LOCAL buffer AS STRING
    LOCAL sTemp AS STRING
    LOCAL conv AS LittleEnd
    LOCAL temp() AS LONG
    LOCAL EMGFilteredNbr, EEGFilteredNbr, EMGRMSValue, EEGRMSValue, fEMGConvNbr, fEEGConvNbr AS DOUBLE
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    DIM RunningRMSAVGQueue AS MyCircularQueueInterface
    LOCAL tempDequeue AS DOUBLE
    GLOBAL gEMGRMSTime, gEEGRMSTime AS LONG
    GLOBAL gEventCnt AS LONG
    GLOBAL rmsTotal, gEEGRMSThreshold, threeMinuteRmsAvg  AS DOUBLE
    GLOBAL gEEGNbrSelectedChannels AS LONG


    bufSize = INT(TCPIPSettings.BytesInTCPArray / TCPIPSettings.TCPSamplesPerChannel)


    'TCPIPSettings.DecimatedSampleRate = TCPIPSettings.SampleRate / (TCPIPSettings.SampleRate/TCPIPSettings.ThrottledSampleRate)
    '#DEBUG PRINT "TCPIPSettings.DecimatedSampleRate: " + STR$(TCPIPSettings.DecimatedSampleRate)



    'MSGBOX "emgSelect: " + STR$(emgSelected) + "eegSelect: " + STR$(eegSelected)

    gResetSampleArrayCount = 0

    'initialize the arrays used by the digital filters

    LET RunningRMSAVGQueue = CLASS "MyCircularQueue"
    LET MyTime = CLASS "PowerTime"

    RunningRMSAVGQueue.initializeQueue(512 * gEEGRMSTime)

    REDIM temp(RMSChannelsToUseArrayCnt)  'used to store sample totals of each channel used


    TCPIPBuffer.SampleCnt = 0
    EEGEventCnt = 0
    gPrevAvgRMS = 0
    delayFlag = 0


    'fHnd = 2
    'OPEN "c:\ThetaTrainer_debug.txt" FOR OUTPUT AS fHnd
    'LET MyTime = CLASS "PowerTime"

    PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
    CALL StartTrial()

    DO
        TCP RECV TCPSocket, bufSize, buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF

        INCR TCPIPBuffer.SampleCnt

        CALL calcTimeElapsed()


        'IF (TCPIPBuffer.SampleCnt MOD TCPIPSettings.DecimatedSampleRate = 0) THEN 'calculate throttled samples per second

            bufPtr = 0
            chanCnt = 0

                FOR x = 1 TO TCPIPSettings.TCPSamplesPerChannel
                    FOR y = 1 TO (TCPIPSettings.ChannelsSentByTCP * 3) STEP 3
                        INCR chanCnt
                        temp = bufPtr + y
                        sample = MID$(buffer, temp, 3)

                        conv.bytes(1) = CVBYT(MID$(sample, 1, 1))
                        conv.bytes(2) = CVBYT(MID$(sample, 2, 1))
                        conv.bytes(3) = CVBYT(MID$(sample, 3, 1))
                        conv.bytes(4) = 0

                        '==============================================================================================================
                        'Per Ross Dunseath 3/4/2014
                        'User selects channels from AIB list, no scale factors. At the end of a PK trial, do RMS on each channel
                        'for the length of the trial and then get average RMS across channels. Hit is determined by auto
                        '(average RMS of this trial > ave RMS of previous trial, PK or rest)
                        '==============================================================================================================

                        IF (isEEGChannelSelected(chanCnt) <> 0) THEN
                            INCR EEGSelectedCnt

                            temp(EEGSelectedCnt) += conv.nbr   'totaling the samples for each channel

                            'sumEEGChannels  = conv.nbr * RMSChannelsToUseArray(chanCnt, 2)    'multiply the scale factor

                            IF (EEGSelectedCnt = RMSChannelsToUseArrayCnt) THEN
                                EEGSelectedCnt = 0
                            END IF



                            IF (gSeconds MOD 1 = 0 AND gSampleCnt = 0) THEN 'every 1 seconds
                                '#DEBUG PRINT " "
                                '#DEBUG PRINT "1 seconds..."
                                rmsTotal = 0
                                FOR z = 1 TO RMSChannelsToUseArrayCnt
                                    rmsTotal += SQR((temp(z) * temp(z)) / (512 * 1))
                                NEXT z

                                '#DEBUG PRINT "rmsTotal for " + STR$(RMSChannelsToUseArrayCnt) + " channels " + " = " + STR$(rmsTotal)
                                gRmsAvg = rmsTotal / RMSChannelsToUseArrayCnt

                                '#DEBUG PRINT "rmsAvg for " + STR$(RMSChannelsToUseArrayCnt) + " channels " + " = " + STR$(gRmsAvg)

                                gRunningRmsAvg += gRmsAvg - gRmsTotalOld
                                '#DEBUG PRINT "running total rmsAvg for " + STR$(RMSChannelsToUseArrayCnt) + " channels " + " = " + STR$(gRunningRmsAvg)


                                IF (gMinutes = 3) THEN
                                    gThreeMinutesPassed = 1
                                END IF

                                IF (gSeconds MOD 1 = 0 AND gThreeMinutesPassed = 1 AND gSampleCnt = 0) THEN
                                    #DEBUG PRINT " "
                                    #DEBUG PRINT "1 seconds after 3 minutes..."

                                    'threeMinuteRmsAvg = meanDoubleQueue(gRunningRMSAVGQueue)
                                    threeMinuteRmsAvg = RunningRMSAVGQueue.mean()
                                    #DEBUG PRINT "Moving RMS Avg (using queue): " + STR$(threeMinuteRmsAvg)
                                END IF

                                IF (gThreeMinutesPassed = 1) THEN
                                    'tempDequeue = doubleDequeue(gRunningRMSAVGQueue)
                                    'RunningRMSAVGQueue.displayQueue()
                                    tempDequeue = RunningRMSAVGQueue.Dequeue()
                                    '#DEBUG PRINT "Dequeue: " + STR$(tempDequeue)
                                    'debugDisplayDoubleQueue(gRunningRMSAVGQueue)
                                    '#DEBUG PRINT "Enqueue: " + STR$(gRmsAvg)
                                    'doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
                                    RunningRMSAVGQueue.enqueue(gRmsAvg)
                                    'debugDisplayDoubleQueue(gRunningRMSAVGQueue)

                                    '**********************************************************************************************
                                    LET MyTime = CLASS "PowerTime"
                                    MyTime.Now()
                                    MyTime.FileTime TO now
                                       'iVPos = 200
                                    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
                                    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
                                    EVENTSANDCONDITIONS(2).EvtName = "EndTrial"
                                    EVENTSANDCONDITIONS(2).NbrOfGVars = 4
                                    EVENTSANDCONDITIONS(2).Index = globals.DioIndex
                                    EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
                                    EVENTSANDCONDITIONS(2).ClockTime = globals.TargetTime
                                    EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(MyTime)
                                    EVENTSANDCONDITIONS(2).ElapsedMillis = gTimerTix

                                    '**********************************************************************************************

                                    IF (threeMinuteRmsAvg >= gMaxThresholdLower AND threeMinuteRmsAvg <= gMaxThresholdUpper) THEN    'HIT
                                    'only play audio feedback on non-rest
                                        SELECT CASE globals.Target
                                            CASE 2 'FOCUS
                                                #DEBUG PRINT "UPBEAT AUDIO"
                                                globals.Feedback = 2
                                                SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\Sounds\MusicalAccentTwinkle.wav")
                                        END SELECT
                                    ELSE
                                        globals.Feedback = 1
                                        SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\Sounds\VocodSynthSwish.wav")
                                    END IF

                                    gPrevAvgRMS = gRmsAvg

                                    WriteOutEndTrialEvents()

                                    PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
                                    EndTrial()
                                    delayFlag = 1
                                END IF
                                'IF (threeMinuteRmsAvg >= gMinThresholdUpper AND threeMinuteRmsAvg <= gMaxThresholdUpper) THEN
                                '    PlaySound "THRESHOLD_HIGH",  0, %SND_ASYNC + %SND_RESOURCE
                                '    'PLAY WAVE "THRESHOLD_HIGH" TO resultVar
                                '    'PLAY WAVE END
                                'END IF
                                '    CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, FORMAT$(threeMinuteRmsAvg, "###")
                                '    CONTROL REDRAW hDlg, %IDC_LABEL_RMS
                                ELSE
                                    'doubleEnqueue(gRunningRMSAVGQueue, gRmsAvg)
                                    RunningRMSAVGQueue.enqueue(gRmsAvg)
                                END IF
                                'debugDisplayDoubleQueue(runningRMSAVGQueue)


                            END IF



                            IF (TCPIPBuffer.SampleCnt MOD (512 * 3) = 0 AND delayFlag = 1) THEN 'a 3 second delay
                                delayFlag = 0
                                PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
                                CALL StartTrial()
                            ELSE
                                ITERATE
                            END IF


'                                    IF (EEGRMSValue > gEEGRMSThreshold) THEN
'                                        INCR EEGEventCnt
'
'                                        MyTime.Now()
'                                        MyTime.FileTime TO now
'                                        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
'                                        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
'                                        EVENTSANDCONDITIONS(0).EvtName = "ThetaMax"
'                                        EVENTSANDCONDITIONS(0).NbrOfGVars = 1
'                                        EVENTSANDCONDITIONS(0).Index = globals.DioIndex
'                                        EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
'                                        EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
'                                        EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)
'
'                                        EVENTSANDCONDITIONS(0).GVars(0).Condition = "EventNumber"
'                                        EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, EEGEventCnt)
'                                        EVENTSANDCONDITIONS(0).GVars(1).Condition = "EEGRMS"
'                                        EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, FIX(EEGRMSValue * 1000))
'
'                                        CALL WriteToEventFile2(0)
'                                    END IF
'
'
'
'                                    IF ((TCPIPBuffer.SampleCnt MOD 512) = 0) THEN       'show RMS value every second
'                                        '#DEBUG PRINT "Write to screen"
'                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_FilteredEEG, FORMAT$(EEGFilteredNbr, "00.000")
'                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ActualEEGRMS, FORMAT$(EEGRMSValue, "00.000")
'                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_EEGRemap, FORMAT$(dEEGRemap, "00000.000")
'                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Vol, FORMAT$(gVOL_MAX - gVol, "00000.000")
'                                    END IF

                            'END IF
                    NEXT y
                    bufPtr = bufPtr + TCPIPSettings.ChannelsSentByTCP * 3

                NEXT x
                chanCnt = 0
                bufPtr = 0

                'MyTime.Now()
                'MyTime.FileTime TO now
                'lEnd = now
                'PRINT #3, "TCPIPBuffer.SampleCount: " + str$(TCPIPBuffer.SampleCnt ) + " Duration: " + STR$(lEnd - lStart)
                'CALL UseTCPIPBuffer()
            'LOOP
            '================================================================
            'making sure that when the buffer is parsed - it can't be
            'accessed by another thread.
            '================================================================
            'LeaveCriticalSection(TCPIPCriticalSection)

            '#DEBUG PRINT "====="
        'END IF
    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR

    LET RunningRMSAVGQueue = NOTHING

    'CLOSE #3
    'close #1
    'CLOSE #fHnd
END SUB

FUNCTION isEEGChannelSelected(chanCnt AS LONG) AS BYTE
    LOCAL x AS LONG
    LOCAL flag AS BYTE

    flag = 0
    FOR x = 1 TO RMSChannelsToUseArrayCnt
        IF (chanCnt = RMSChannelsToUseArray(x, 1)) THEN
            flag = x
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag

END FUNCTION

SUB calcTimeElapsed()
    LOCAL threeMinuteRmsAvg AS DOUBLE

    IF (gSampleCnt = 1000) THEN 'gives me a millisecond
        gSampleCnt = 0
        INCR gSeconds
    END IF
    IF (gSeconds > 59) THEN
        gSeconds = 0
        INCR gMinutes
    END IF
    SLEEP 0
END SUB
