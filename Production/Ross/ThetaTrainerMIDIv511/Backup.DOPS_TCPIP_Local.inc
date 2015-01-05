

'****************************************************************************************
'The processBuffer() function must created in calling program. It is the method that will
'process incoming TCP data from the server. A value must be passed into the
'processBuffer() method that represents the socket connection that is obtained from
'calling the connectToServer(server, port, socket) function.
'****************************************************************************************
SUB processBuffer(BYVAL TCPSocket AS LONG)
    LOCAL dEMGRemap, dEEGRemap, dEEGMP3Remap, temp AS DOUBLE
    LOCAL bufSize, decimatedSampleRate, itemCnt AS LONG
    LOCAL i, x, y, bufPtr, yPtr, chanCnt, selectedChannelHit AS LONG
    LOCAL emgSelected, eegSelected AS LONG
    LOCAL emgSample, eegSample, lSample, lConvSample, EEGEventCnt AS LONG
    LOCAL EEGSelectCnt, EEGSelectedCnt, EMGSelectCnt, EMGSelectedCnt AS LONG
    LOCAL fHnd, itemState, sumEEGChannels, sumEMGChannels AS LONG
    LOCAL sample AS STRING * 4
    LOCAL buffer AS STRING
    LOCAL sTemp AS STRING
    LOCAL conv AS LittleEnd
    LOCAL tempEEG() AS LONG
    LOCAL tempEMG() AS LONG
    LOCAL EMGFilteredNbr, EEGFilteredNbr, EMGRMSValue, EEGRMSValue, fEMGConvNbr, fEEGConvNbr AS DOUBLE
    LOCAL EEGAlphaRMSValue AS DOUBLE
    LOCAL EEGHighFilteredNbr, EEGLowFilteredNbr, tempSample  AS DOUBLE
    LOCAL EEGLowFiltered12Nbr, EEGHighFiltered8Nbr  AS DOUBLE
    LOCAL flag AS BYTE
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL emgInitialRMSCnt, emgMovingRMSCnt, eegInitialRMSCnt, eegMovingRMSCnt AS LONG
    LOCAL emgRMSInitialWindowFlag, emgRMSMovingWindowFlag, eegRMSInitialWindowFlag, eegRMSMovingWindowFlag AS BYTE
    DIM EMGRMSQueue AS MyCircularQueueInterface
    DIM EEGRMSQueue AS MyCircularQueueInterface
    DIM EEGAlphaRMSQueue AS MyCircularQueueInterface
    DIM EMGFilters AS MyFiltersInterface
    DIM EEGFilters AS MyFiltersInterface
    GLOBAL gEmgRMSMin, gEmgRMSMax, gEegRMSMin, gEegRMSMax AS LONG
    GLOBAL gHwndScroll, gVwndScroll, gEMGRMSTime, gEEGRMSTime AS LONG
    GLOBAL gEMGPitchSens, gEMGPitchBase, gEEGVolSens, gEEGVolBase AS DOUBLE
    GLOBAL gFreq, gVol AS SINGLE
    GLOBAL ghWaveOut AS LONG
    GLOBAL gEMGPitchSensMin, gEMGPitchSensMax, gEMGPitchBaseMin, gEMGPitchBaseMax AS DOUBLE
    GLOBAL gEEGVolSensMin, gEEGVolSensMax, gEEGVolBaseMin, gEEGVolBaseMax AS DOUBLE
    GLOBAL hwndButtonOnOff AS LONG
    GLOBAL ghMidiOut AS LONG
    GLOBAL gGeneralMIDI AS WORD
    GLOBAL gDefaultSound AS LONG
    GLOBAL gFREQ_MIN,gFREQ_MAX, gFREQ_STEP, gVOL_MIN, gVOL_MAX, gVOL_STEP, gFREQ_INIT, gPITCH_BASE_START, gVOL_BASE_START AS LONG
    GLOBAL gEventCnt AS LONG
    GLOBAL gEEGRMSThreshold AS DOUBLE
    GLOBAL gMp3Filename AS STRING
    GLOBAL gMp3 AS MyMP3Interface
    GLOBAL gEEGNbrSelectedChannels, gEMGNbrSelectedChannels AS LONG
    GLOBAL rngInt AS EvenOddRNGInterface


    bufSize = INT(TCPIPSettings.BytesInTCPArray / TCPIPSettings.TCPSamplesPerChannel)


    'TCPIPSettings.DecimatedSampleRate = TCPIPSettings.SampleRate / (TCPIPSettings.SampleRate/TCPIPSettings.ThrottledSampleRate)
    '#DEBUG PRINT "TCPIPSettings.DecimatedSampleRate: " + STR$(TCPIPSettings.DecimatedSampleRate)

    'CALL FillChannelsToUseAndMisc()


    REDIM tempEMG(gEMGNbrSelectedChannels)


    itemCnt = 0
    FOR x = 1 TO 32
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_EMGChannel, x TO itemState

        IF (itemState = -1) THEN 'selected
            INCR itemCnt
            tempEMG(itemCnt) =  x
        END IF
    NEXT x

    REDIM tempEEG(gEEGNbrSelectedChannels)

    itemCnt = 0
    FOR x = 1 TO 32
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_EEGChannel, x TO itemState

        IF (itemState = -1) THEN 'selected
            INCR itemCnt
            tempEEG(itemCnt) =  x
        END IF
    NEXT x



    'get the selected EMG and EEG channel to be processed from all the channels selected
    CONTROL GET USER hDlg, %IDC_TEXTBOX_EMGChannel, 1 TO emgSelected
    CONTROL GET USER hDlg, %IDC_TEXTBOX_EEGChannel, 1 TO eegSelected

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMin TO sTemp
    gEmgRMSMin = VAL(sTemp)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMax TO sTemp
    gEmgRMSMax = VAL(sTemp)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMin TO sTemp
    gEegRMSMin = VAL(sTemp)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMax TO sTemp
    gEegRMSMax = VAL(sTemp)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSThreshold TO sTemp
    gEEGRMSThreshold = VAL(sTemp)


    'MSGBOX "emgSelect: " + STR$(emgSelected) + "eegSelect: " + STR$(eegSelected)

    gResetSampleArrayCount = 0

    'initialize the arrays used by the digital filters

    LET EMGRMSQueue = CLASS "MyCircularQueue"
    LET EEGRMSQueue = CLASS "MyCircularQueue"
    LET EEGAlphaRMSQueue = CLASS "MyCircularQueue"
    LET EMGFilters = CLASS "MyFilters"
    LET EEGFilters = CLASS "MyFilters"
    LET MyTime = CLASS "PowerTime"

    EMGRMSQueue.initializeQueue(512 * gEMGRMSTime * gEMGNbrSelectedChannels)
    EEGRMSQueue.initializeQueue(512 * gEEGRMSTime * gEEGNbrSelectedChannels)
    EEGAlphaRMSQueue.initializeQueue(512 * gEEGRMSTime * gEEGNbrSelectedChannels)

    'EMG_startDoubleQueue(EMGRMSQueue, 512 * gEMGRMSTime)    'make the EMG queue 512 samples X the selected time (1 - 10) from the slider
    'EEG_startDoubleQueue(EEGRMSQueue, 512 * gEMGRMSTime)    'make the EEG queue 512 samples X the selected time (1 - 10) from the slider

    emgRMSInitialWindowFlag = 0
    emgRMSMovingWindowFlag = 0
    eegRMSInitialWindowFlag = 0
    eegRMSMovingWindowFlag = 0
    emgInitialRMSCnt = 0
    eegInitialRMSCnt = 0
    emgMovingRMSCnt = 0
    eegMovingRMSCnt = 0
    TCPIPBuffer.SampleCnt = 0
    EEGEventCnt = 0


    'fHnd = 2
    'OPEN "c:\ThetaTrainer_debug.txt" FOR OUTPUT AS fHnd
    'LET MyTime = CLASS "PowerTime"

    DO
        TCP RECV TCPSocket, bufSize, buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF

        INCR TCPIPBuffer.SampleCnt


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

                        '====================================================
                        'only put the channels selected to be used in the
                        'TCPIPBuffer.SampleArray() array.
                        '====================================================
                         IF (isEMGChannelSelectedLocal(chanCnt, tempEMG()) <> 0) THEN
                            INCR EMGSelectedCnt

                            emgSample = conv.nbr

                            fEMGConvNbr = emgSample * 0.0312                                   'multiplying by your conversion factor to make into
                            '#DEBUG PRINT "fEMGConvNbr: " + STR$(fEMGConvNbr)                  'microvolts commonly referred to RTI

                            EMGFilteredNbr = EMGFilters.BandpassFilter8Pole(fEMGConvNbr)                          'passing the converted sample to the Bandpass filter function
                            'EMGFilteredNbr = EMGBandpassFilter(fEMGConvNbr)
                            '#DEBUG PRINT "EMGFilteredNbr: " + STR$(EMGFilteredNbr)


                            '====================================================================
                            'This processes the initial x samples for the starting RMS window.
                            '====================================================================
                            IF (emgRMSInitialWindowFlag = 0) THEN
                                IF (TCPIPBuffer.SampleCnt MOD (512 * gEMGRMSTime) <> 0) THEN      'x seconds @ 512/samples per second
                                    EMGRMSQueue.Enqueue(EMGFilteredNbr)         'place the filtered sample on a circular queue

                                ELSE
                                    EMGRMSQueue.Enqueue(EMGFilteredNbr)         'place the filtered sample on a circular queue
                                    emgRMSInitialWindowFlag = 1

                                    IF (gDefaultSound = 1) THEN 'default sound chosen
                                        PostMessage(hwndButtonOnOff, %BM_CLICK, 0, 0)
                                    END IF

                                    'EMGRMSValue = EMGRMSQueue.rms()
                                    EMGRMSValue = EMGRMSQueue.rmsMultiChannel(512 * gEMGRMSTime * gEMGNbrSelectedChannels, 512 * gEMGRMSTime)

                                    FOR i = 1 TO 512 * .25
                                        '#DEBUG PRINT "Dequeue..." + STR$(i)
                                        EMGRMSQueue.Dequeue()
                                    NEXT i
                                END IF
                            END IF


                            '====================================================================
                            'This processes the 1/4 second worth of samples for the
                            'moving RMS window.
                            '====================================================================
                            IF (emgRMSInitialWindowFlag = 1) THEN
                                IF (emgRMSMovingWindowFlag = 1) THEN
                                    IF (TCPIPBuffer.SampleCnt MOD (512 * .25) <> 0) THEN     '512  * .25 = every quarter second
                                        EMGRMSQueue.Enqueue(EMGFilteredNbr)
                                    ELSE
                                        EMGRMSQueue.Enqueue(EMGFilteredNbr)

                                        'get RMS of the queued filtered samples
                                         'EMGRMSValue = EMGRMSQueue.rms()
                                        EMGRMSValue = EMGRMSQueue.rmsMultiChannel(512 * gEMGRMSTime * gEMGNbrSelectedChannels, 512 * gEMGRMSTime)

                                        dEMGRemap = remapDouble(EMGRMSValue, gEmgRMSMin, gEmgRMSMax, gFREQ_MIN, gFREQ_MAX)

                                        gFreq = gEMGPitchSens * dEMGRemap + gEMGPitchBase

                                        '******************************************
                                        'added 8/29/2014 - limited gFreq to
                                        'lower than 500
                                        '******************************************
                                        IF (gFreq > 500) THEN gFreq = 500
                                        '******************************************


                                        SELECT CASE gDefaultSound
                                            CASE 1
                                            CASE 2
                                                CALL ChangeMIDIPitch()
                                            CASE 3
                                        END SELECT


                                        emgMovingRMSCnt = 0
                                        FOR i = 1 TO 128
                                            EMGRMSQueue.Dequeue()                            'dequeue the latest filtered sample so we can enqueue the newest one
                                        NEXT i
                                    END IF
                                ELSE
                                    emgRMSMovingWindowFlag = 1
                                END IF
                            END IF

                            IF ((TCPIPBuffer.SampleCnt MOD 512) = 0) THEN       'show RMS value every second
                                CONTROL SET TEXT hDlg, %IDC_TEXTBOX_FilteredEMG, FORMAT$(EMGFilteredNbr, "00.000")
                                CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ActualEMGRMS, FORMAT$(EMGRMSValue, "00.000")
                                CONTROL SET TEXT hDlg, %IDC_TEXTBOX_EMGRemap, FORMAT$(dEMGRemap, "0000.000")
                                CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Pitch, FORMAT$(gFreq, "0000.000")
                                CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMin TO sTemp
                                gEmgRMSMin = VAL(sTemp)

                                CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMax TO sTemp
                                gEmgRMSMax = VAL(sTemp)

                                CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMin TO sTemp
                                gEegRMSMin = VAL(sTemp)

                                CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMax TO sTemp
                                gEegRMSMax = VAL(sTemp)

                            END IF
                        END IF

                        IF (isEEGChannelSelectedLocal(chanCnt, tempEEG()) <> 0) THEN
                            'listBOX GET STATE hDlg, %IDC_LISTBOX_EEGChannel, chanCnt TO itemState

                                INCR EEGSelectedCnt
                                eegSample = conv.nbr


                                    fEEGConvNbr = eegSample * 0.0312    'multiplying by your conversion factor to make into
                                                                        'microvolts commonly referred to RTI

                                    '#DEBUG PRINT "fEEGConvNbr: " + STR$(fEEGConvNbr)



                                    'EEGHighFilteredNbr = EEGHighpassFilter(fEEGConvNbr)
                                    EEGHighFilteredNbr = EEGFilters.HighpassFilter(fEEGConvNbr)
                                    '#DEBUG PRINT "EEGHighFilteredNbr: " + STR$(EEGHighFilteredNbr)
                                    'EEGLowFilteredNbr = EEGLowpassFilter(EEGHighFilteredNbr)
                                    '#DEBUG PRINT "EEGLowFilteredNbr: " + STR$(EEGLowFilteredNbr)
                                    EEGLowFilteredNbr = EEGFilters.LowpassFilter(EEGHighFilteredNbr)
                                    'EEGLowFilteredNbr = EEGFilters.LowpassFilter(EEGHighFilteredNbr)

                                    'EEGFilteredNbr =  EEGLowFilteredNbr 'EEGLowFilteredNbr
                                    EEGFilteredNbr = EEGLowFilteredNbr

                                    '=================================================================
                                    'added 6/10/2014 - per Ross Dunseath - wanted to display the raw
                                    'data being put through 2 filters between 8 and 12 Hz
                                    '=================================================================
                                    EEGHighFiltered8Nbr = EEGFilters.HighpassFilter8(fEEGConvNbr)
                                    EEGLowFiltered12Nbr = EEGFilters.LowpassFilter12(EEGHighFiltered8Nbr)
                                    '#DEBUG PRINT "EEGLowFiltered12Nbr: " + STR$(EEGLowFiltered12Nbr)


                                    '====================================================================
                                    'This processes the initial x samples for the starting RMS window.
                                    '====================================================================
                                    IF (eegRMSInitialWindowFlag = 0) THEN
                                        IF (TCPIPBuffer.SampleCnt MOD (512 * gEEGRMSTime) <> 0) THEN      'x seconds @ 512/samples per second
                                            EEGRMSQueue.Enqueue(EEGFilteredNbr)         'place the filtered sample on a circular queue
                                            EEGAlphaRMSQueue.Enqueue(EEGLowFiltered12Nbr)         'place the filtered sample on a circular queue
                                        ELSE
                                            EEGRMSQueue.Enqueue(EEGFilteredNbr)         'place the filtered sample on a circular queue
                                            EEGAlphaRMSQueue.Enqueue(EEGLowFiltered12Nbr)         'place the filtered sample on a circular queue

                                            'EEGRMSValue = EEGRMSQueue.rms()
                                            EEGRMSValue = EEGRMSQueue.rmsMultiChannel(512 * gEEGRMSTime * gEEGNbrSelectedChannels, 512 * gEEGRMSTime)
                                            EEGAlphaRMSValue = EEGAlphaRMSQueue.rmsMultiChannel(512 * gEEGRMSTime * gEEGNbrSelectedChannels, 512 * gEEGRMSTime)
                                            '#DEBUG PRINT "EEGRMSValue: " + STR$(EEGRMSValue)

                                            FOR i = 1 TO 512 * .25
                                                '#DEBUG PRINT "Dequeue..." + STR$(i)
                                                EEGRMSQueue.Dequeue()
                                                EEGAlphaRMSQueue.Dequeue()
                                            NEXT i

                                            eegRMSInitialWindowFlag = 1
                                        END IF
                                    END IF
        '
                                    '====================================================================
                                    'This processes the 1/4 second worth of samples for the
                                    'moving RMS window.
                                    '====================================================================
                                    IF (eegRMSInitialWindowFlag = 1) THEN
                                        IF (eegRMSMovingWindowFlag = 1) THEN
                                            IF (TCPIPBuffer.SampleCnt MOD (512 * .25)  <> 0) THEN     '512 * .25 = every quarter second
                                                EEGRMSQueue.Enqueue(EEGFilteredNbr)
                                                EEGAlphaRMSQueue.Enqueue(EEGLowFiltered12Nbr)         'place the filtered sample on a circular queue
                                            ELSE
                                                #DEBUG PRINT "RMS"
                                                EEGRMSQueue.Enqueue(EEGFilteredNbr)
                                                EEGAlphaRMSQueue.Enqueue(EEGLowFiltered12Nbr)         'place the filtered sample on a circular queue

                                                'EEGRMSValue = EEGRMSQueue.rms()
                                                EEGRMSValue = EEGRMSQueue.rmsMultiChannel(512 * gEEGRMSTime * gEEGNbrSelectedChannels, 512 * gEEGRMSTime)
                                                EEGAlphaRMSValue = EEGAlphaRMSQueue.rmsMultiChannel(512 * gEEGRMSTime * gEEGNbrSelectedChannels, 512 * gEEGRMSTime)
                                                '#DEBUG PRINT "EEGRMSValue: " + STR$(EEGRMSValue)

                                                'dEEGRemap = remapDouble(EEGRMSValue, gEegRMSMin, gEegRMSMax, gVOL_MIN, gVOL_MAX)
                                                '#debug print "remapDouble(): " + str$(dEEGRemap)
                                                dEEGRemap = VolumeControlRemap(EEGRMSValue, gEegRMSMin * 1.0, gEegRMSMax * 1.0)
                                                #DEBUG PRINT "VolumeControlRemap(): " + STR$(dEEGRemap)

                                                IF (dEEGRemap < 0) THEN
                                                    dEEGRemap = 0
                                                END IF
                                                gVol =  gEEGVolSens * dEEGRemap + gEEGVolBase


                                                IF (gVol > gVOL_MAX) THEN
                                                   gVol = gVOL_MAX
                                                END IF

                                                #DEBUG PRINT "ChangeVolume()"
                                                CALL ChangeVolume()


                                                #DEBUG PRINT "IF (EEGRMSValue > gEEGRMSThreshold) THEN  "
                                                IF (EEGRMSValue > gEEGRMSThreshold) THEN
                                                    INCR EEGEventCnt

                                                    MyTime.Now()
                                                    MyTime.FileTime TO now
                                                    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
                                                    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
                                                    EVENTSANDCONDITIONS(0).EvtName = "ThetaMax"
                                                    EVENTSANDCONDITIONS(0).NbrOfGVars = 1
                                                    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
                                                    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
                                                    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
                                                    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)

                                                    EVENTSANDCONDITIONS(0).GVars(0).Condition = "EventNumber"
                                                    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, EEGEventCnt)
                                                    EVENTSANDCONDITIONS(0).GVars(1).Condition = "EEGRMS"
                                                    EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, FIX(EEGRMSValue * 1000))

                                                    CALL WriteToEventFile2(0)

                                                    rngInt.SetCondition("EEGRMS")
                                                END IF

                                                #DEBUG PRINT "eegMovingRMSCnt = 0  "
                                                eegMovingRMSCnt = 0
                                                FOR i = 1 TO 128
                                                    EEGRMSQueue.Dequeue()                            'dequeue the latest filtered sample so we can enqueue the newest one
                                                    EEGAlphaRMSQueue.Dequeue()
                                                NEXT i
                                            END IF
                                        ELSE
                                            eegRMSMovingWindowFlag = 1
                                        END IF
                                    END IF

                                    IF ((TCPIPBuffer.SampleCnt MOD 512) = 0) THEN       'show RMS value every second
                                        #DEBUG PRINT "Write to screen"
                                        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSThreshold TO sTemp
                                        gEEGRMSThreshold = VAL(sTemp)
                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_FilteredEEG, FORMAT$(EEGFilteredNbr, "00.000")
                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ActualEEGRMS, FORMAT$(EEGRMSValue, "00.000")
                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_EEGRemap, FORMAT$(dEEGRemap, "00000.000")
                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Vol, FORMAT$(gVol, "00000.000")
                                        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMin TO sTemp
                                        gEmgRMSMin = VAL(sTemp)

                                        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMax TO sTemp
                                        gEmgRMSMax = VAL(sTemp)

                                        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMin TO sTemp
                                        gEegRMSMin = VAL(sTemp)

                                        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMax TO sTemp
                                        gEegRMSMax = VAL(sTemp)

                                        '=================================================================
                                        'added 6/10/2014 - per Ross Dunseath - wanted to display the raw
                                        'data being put through 2 filters between 8 and 12 Hz
                                        '=================================================================
                                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_AlphaFilter, FORMAT$(EEGAlphaRMSValue, "000.000")
                                    END IF
                        END IF
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

    LET EMGRMSQueue = NOTHING
    LET EEGRMSQueue = NOTHING
    LET EEGAlphaRMSQueue = NOTHING
    LET EMGFilters = NOTHING
    LET EEGFilters = NOTHING
    'CLOSE #3
    'close #1
    'CLOSE #fHnd
END SUB



FUNCTION isEMGChannelSelectedLocal(chanCnt AS LONG, temp() AS LONG) AS BYTE
    LOCAL x AS LONG
    LOCAL flag AS BYTE

    flag = 0
    FOR x = 1 TO gEMGNbrSelectedChannels
        IF (chanCnt = temp(x)) THEN
            flag = x
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag

END FUNCTION

FUNCTION isEEGChannelSelectedLocal(chanCnt AS LONG, temp() AS LONG) AS BYTE
    LOCAL x AS LONG
    LOCAL flag AS BYTE

    flag = 0
    FOR x = 1 TO gEEGNbrSelectedChannels
        IF (chanCnt = temp(x)) THEN
            flag = x
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag

END FUNCTION
