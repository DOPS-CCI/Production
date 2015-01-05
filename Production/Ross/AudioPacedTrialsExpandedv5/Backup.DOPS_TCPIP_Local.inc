

'****************************************************************************************
'The processBuffer() function must created in calling program. It is the method that will
'process incoming TCP data from the server. A value must be passed into the
'processBuffer() method that represents the socket connection that is obtained from
'calling the connectToServer(server, port, socket) function.
'****************************************************************************************
SUB processBuffer(BYVAL TCPSocket AS LONG)
    LOCAL delayFlag, initialValueFlag, nullFlag AS BYTE
    LOCAL bufSize, decimatedSampleRate, itemCnt AS LONG
    LOCAL i, x, y, z, bufPtr, yPtr, temp2, chanCnt, selectedChannelHit AS LONG
    LOCAL selectedSampleCnt, lSample, lConvSample, EEGSelectCnt, EEGSelectedCnt AS LONG
    LOCAL fHnd, itemState, sumEEGChannels, delayCnt, total AS LONG
    LOCAL sample AS STRING * 4
    LOCAL buffer AS STRING
    LOCAL sTemp AS STRING
    LOCAL conv AS LittleEnd
    LOCAL temp() AS DOUBLE
    LOCAL EMGFilteredNbr, EEGFilteredNbr, EMGRMSValue, EEGRMSValue, fEMGConvNbr, fEEGConvNbr AS DOUBLE
    LOCAL tempAvg AS DOUBLE
    LOCAL MyTime AS IPOWERTIME
    DIM EEGFilters AS MyFiltersInterface
    LOCAL now, totalSamplesSquared AS QUAD
    LOCAL filename, subjDir AS ASCIIZ * 255
    GLOBAL gEMGRMSTime, gEEGRMSTime AS LONG
    GLOBAL gEventCnt, trialCnt AS LONG
    GLOBAL rms, avgRMS, prevAvgRMS, gEEGRMSThreshold AS DOUBLE
    GLOBAL gEEGNbrSelectedChannels, rndJitter AS LONG





    gMVS_CONV = 0.0312 'for converting to mVs


    bufSize = INT(TCPIPSettings.BytesInTCPArray / TCPIPSettings.TCPSamplesPerChannel)


    'TCPIPSettings.DecimatedSampleRate = TCPIPSettings.SampleRate / (TCPIPSettings.SampleRate/TCPIPSettings.ThrottledSampleRate)
    '#DEBUG PRINT "TCPIPSettings.DecimatedSampleRate: " + STR$(TCPIPSettings.DecimatedSampleRate)

    CALL FillChannelsToUseAndMisc()


    'MSGBOX "emgSelect: " + STR$(emgSelected) + "eegSelect: " + STR$(eegSelected)

    gResetSampleArrayCount = 0

    'initialize the arrays used by the digital filters

    LET MyTime = CLASS "PowerTime"
    LET EEGFilters = CLASS "MyFilters"



    TCPIPBuffer.SampleCnt = 0
    selectedSampleCnt = 0
    trialCnt = 0
    delayFlag = 0
    delayCnt = 0
    gRunningDuration = 0

    nullFlag = 1

    '========================================================
    'added 4/3/2014 - This flag was added to allow us to get
    'an initial RMS value before the trials actually start.
    '========================================================
    initialValueFlag = 0


    'OPEN "APT_debug.txt" FOR OUTPUT AS #2
    'OPEN "APT_debug.bin" FOR BINARY AS #3
    'LET MyTime = CLASS "PowerTime"


    '#DEBUG PRINT "Before loop..."

    DO
        TCP RECV TCPSocket, bufSize, buffer

        'PUT$ #3, buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF

        INCR TCPIPBuffer.SampleCnt

        IF (gRunDelayFlag = 1) THEN
            gRndCnt = 0
            IF (TCPIPBuffer.SampleCnt MOD 512 = 0) THEN
                '#DEBUG PRINT "buffer: " + buffer
            END IF
            GOTO labelJump
        END IF

        INCR trialCnt


        '#DEBUG PRINT "trialCnt: " + str$(trialCnt)

        '========================================================
        'added 4/3/2014 per Ross Dunseath - Ross wanted to add
        'the same RNG capability that is running in the RNG
        'part of this application (uses MM timer). We will now
        'be gathering RNG numbers in the TCPIP sampling loop.
        '========================================================
        IF (%RNG_ONOFF = 1) THEN
            'Do RNG calculations for .CSV files every second (512 samples/per second)
            IF (TCPIPBuffer.SampleCnt MOD 512 = 0) THEN
                CALL gatherRandomNumbers2()
                CALL createRNGCSVFile()
             END IF
        END IF

        bufPtr = 0
        chanCnt = 0

        FOR x = 1 TO TCPIPSettings.TCPSamplesPerChannel
            FOR y = 1 TO (TCPIPSettings.ChannelsSentByTCP * 3) STEP 3
                INCR chanCnt
                temp2 = bufPtr + y
                sample = MID$(buffer, temp2, 3)

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
                IF (delayFlag = 0) THEN
                    IF (isEEGChannelSelected(chanCnt) > 0) THEN 'If it is a select channel
                        INCR EEGSelectedCnt
                        INCR selectedSampleCnt

                        fEEGConvNbr = conv.nbr * TCPIPBuffer.ChannelsToProcessArray(x, 2) 'for converting to mVs

                        '=============================================================
                        'added per Ross Dunseath 04/24/2014 - needed a highpass
                        'filter added.
                        '=============================================================
                        EEGFilteredNbr = EEGFilters.HighpassFilter1Pole(fEEGConvNbr)
                        '#DEBUG PRINT "fEEGConvNbr: " + STR$(fEEGConvNbr)

                        'totalSamplesSquared += (fEEGConvNbr * fEEGConvNbr)
                        totalSamplesSquared += (EEGFilteredNbr * EEGFilteredNbr)

                        'PRINT #2, "TCPIPBuffer.ChannelsToProcess: "; TCPIPBuffer.ChannelsToProcess
                        'PRINT #2, "chanCnt: "; chanCnt
                        'PRINT #2, "EEGSelectedCnt: "; EEGSelectedCnt
                        'PRINT #2, "selectedSampleCnt: "; selectedSampleCnt
                        'PRINT #2, "Raw Sample: "; conv.nbr
                        'PRINT #2, "Sample: "; fEEGConvNbr
                        'PRINT #2, "Sample squared: "; fEEGConvNbr * fEEGConvNbr
                        'PRINT #2, "Total Samples squared: "; totalSamplesSquared

                        'sumEEGChannels  = conv.nbr * RMSChannelsToUseArray(chanCnt, 2)    'multiply the scale factor

                        IF (EEGSelectedCnt = TCPIPBuffer.ChannelsToProcess) THEN
                            EEGSelectedCnt = 0
                        END IF

                        IF (trialCnt MOD (512 * gEEGRMSTime) = 0 AND EEGSelectedCnt = 0) THEN      'end of trial (512 samples/sec X Trail Length (in secs)
                            'do RMS on each channel
                            'for the length of the trial

                            tempAvg = totalSamplesSquared / (512 * gEEGRMSTime)
                            'PRINT #2, "tempAvg: "; tempAvg

                            rms = SQR(tempAvg)

                            'get average RMS across channels
                            avgRMS = rms    ' / TCPIPBuffer.ChannelsToProcess

                            'PRINT #2, "RMS: "; avgRMS

                            rms = 0
                            selectedSampleCnt = 0
                            totalSamplesSquared = 0

                            '========================================================
                            'added 4/3/2014 - This flag was added to allow us to get
                            'an initial RMS value before the trials actually start.
                            '========================================================
                            IF (initialValueFlag = 1) THEN
                                DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal) + " RMS: " + STR$(avgRMS)

                                IF (globals.Target = 2) THEN 'focus
                                    SELECT CASE TCPIPBuffer.UseThreshold
                                        CASE 1  'use previous rms average
                                            IF (avgRMS > prevAvgRMS) THEN    'HIT
                                                '#DEBUG PRINT "UPBEAT AUDIO"
                                                globals.Feedback = 2
                                                PlaySound "UPBEAT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            ELSE
                                                globals.Feedback = 1
                                                PlaySound "NORMAL_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            END IF
                                        CASE 2 'use lower threshold
                                            IF (avgRMS >= TCPIPBuffer.ThresholdLower) THEN    'HIT
                                                '#DEBUG PRINT "UPBEAT AUDIO"
                                                globals.Feedback = 2
                                                PlaySound "UPBEAT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            ELSE
                                                globals.Feedback = 1
                                                PlaySound "NORMAL_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            END IF
                                        CASE 3 'use upper threshold
                                            IF (avgRMS <= TCPIPBuffer.ThresholdUpper) THEN    'HIT
                                                '#DEBUG PRINT "UPBEAT AUDIO"
                                                globals.Feedback = 2
                                                PlaySound "UPBEAT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            ELSE
                                                  globals.Feedback = 1
                                                PlaySound "NORMAL_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
                                            END IF
                                    END SELECT
                                END IF

                                '**********************************************************************************************
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

                                '**********************************************************************************************

                                prevAvgRMS = avgRMS

                                WriteOutEndTrialEvents()

                                'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)

                                EndTrial()



                                '========================================================
                            ELSE
                                '========================================================
                                'Start the trials
                                '========================================================
                                prevAvgRMS = avgRMS
                                initialValueFlag = 1

                                '========================================================
                                'added 4/3/2014 per Ross Dunseath - Ross wanted to add
                                'the same RNG capability that is running in the RNG
                                'part of this application (uses MM timer). We will now
                                'be gathering RNG numbers in the TCPIP sampling loop.
                                'reset values
                                '========================================================
                                IF (%RNG_ONOFF = 1) THEN

                                    gARSAccumNbrBits = 0
                                    gARSAccumDev = 0

                                    gAccumNbrBits = 0
                                    gAccumDev = 0
                                END IF

                                IF (globals.Target = 2) THEN 'if it's a focus target initialize
                                    gARSAccumNbrBits = 0
                                    gARSAccumDev = 0

                                    gAccumNbrBits = 0
                                    gAccumDev = 0
                                END IF

                            END IF

                            delayFlag = 1
                            rndJitter = RND(5,10)
                            gBetweenTrialFlag = 0
                            EXIT FOR
                        END IF
                    END IF
                END IF


            NEXT y
            IF (delayFlag = 1) THEN
                EXIT FOR
            END IF
            bufPtr = bufPtr + TCPIPSettings.ChannelsSentByTCP * 3

        NEXT x
        chanCnt = 0
        bufPtr = 0

        '================================================================
        '3/20/2014 adding a 5 - 15 second random delay per Ross Dunseath
        '================================================================
        IF (delayFlag = 1) THEN 'a 6 second delay
            INCR delayCnt
            IF (delayCnt = (512 * rndJitter)) THEN
                '#DEBUG PRINT "delayCnt: " + STR$(delayCnt)
                delayFlag = 0
                delayCnt = 0
                trialCnt = 0
                gBetweenTrialFlag = 1
                'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)

                MyTime.Now()

                gAIBTiming = GetPowerTimeTotalMillis(MyTime)

                IF (globals.TrialCntTotal = 1) THEN
                    gRunningDuration = 0
                END IF

                CALL StartTrial()
            END IF
        END IF

labelJump:

        IF (gRunDelayFlag = 1) THEN
            IF (TCPIPBuffer.SampleCnt MOD 512 = 0) THEN
                '#DEBUG PRINT "labelJump"
                SLEEP 0
            END IF
        END IF

    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR

    'CLOSE #3
    'close #1
    'CLOSE #2
END SUB


SUB gatherRandomNumbers2()
    LOCAL x AS LONG
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE

     FOR x = 1 TO gSampleSize
        OBJECT CALL oApp.GetRandomByte() TO rndByte
        bRndByte = VARIANT#(rndByte)
        gSamples(x) = bRndByte
        SLEEP 0
     NEXT x
END SUB


SUB createRNGCSVFile()
    LOCAL lResult, rndJitter, subPtr  AS LONG
    LOCAL x, totalBits, arsTotalBits AS LONG
    LOCAL absAccumDev, sqrAccumNbrBits, zScore AS DOUBLE
    LOCAL absARSAccumDev, sqrARSAccumNbrBits, zARSScore AS DOUBLE
    LOCAL MyTime, MyTimeRNDFile, MyTimeARSFile AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL tempForFile, arsTempForFile AS STRING


    OPEN "c:\csv_debug.txt" FOR OUTPUT AS #999
    'INCR gSampleCnt

    'accumulating time in seconds
    INCR gRunningDuration
    arsTempForFile = ""

    arsTotalBits = 0
    'use odd samples for alternate stream of random number
    FOR x = 1 TO gSampleSize
        IF (Odd(x) = 1) THEN
           PRINT #999,  "gSamples(x): " + STR$(gSamples(x))
           arsTotalBits += sumBitsOfByte(gSamples(x))
        END IF
    NEXT x

    'PRINT #999,  "arsTotalBits: " + STR$(arsTotalBits)

    gARSAccumNbrBits += 200
    PRINT #999,  "gARSAccumNbrBits: " + STR$(gARSAccumNbrBits)

    gARSAccumDev = gARSAccumDev + (arsTotalBits - 100)
    PRINT #999,  "gARSAccumDev: " + STR$(gARSAccumDev)

    sqrARSAccumNbrBits = SQR(gARSAccumNbrBits)
    PRINT #999,  "sqrARSAccumNbrBits: " + STR$(sqrARSAccumNbrBits)

    zARSScore = gARSAccumDev * 1.0 / SQR((gARSAccumNbrBits * 1.0) / 4.0)
    PRINT #999,  "zARSScore: " + STR$(zARSScore)

    'arsTempForFile = TIME$ + "," + STR$(gRunningDuration) + ","  + FORMAT$(arsTotalBits, "0000") + "," + FORMAT$(zARSScore, "00.0000") + ","
    arsTempForFile = TIME$ + "," + STR$(gRunningDuration) + ","  + FORMAT$((arsTotalBits - 100), "0000") + "," + FORMAT$(zARSScore, "00.0000") + ","

    SELECT CASE globals.Target
        CASE 1 'REST
            arsTempForFile += "REST"
        CASE 2 'FOCUS
            IF (gHighOrLow = 0) THEN
               arsTempForFile += "FOCUS"
            ELSEIF (gHighOrLow = 1) THEN 'High
                arsTempForFile += "FOCUSHIGH"
            ELSE
                arsTempForFile += "FOCUSLOW"
            END IF
        CASE ELSE
           arsTempForFile += "NOTHING"
    END SELECT

    PRINT #999, "arsTempForFile: " + arsTempForFile

    IF (gBetweenTrialFlag = 0) THEN 'we are between trials
        'write nothing out
    ELSE
        IF (gARSFile <> "") THEN
            PRINT #950, arsTempForFile
        END IF
    END IF


    'gRndCnt = 0
    INCR gSampleCnt

    tempForFile = ""

    totalBits = 0
    'use even samples for deviation processing
    FOR x = 1 TO gSampleSize
        IF (Odd(x) = 0) THEN
           PRINT #999,  "gSamples(x): " + STR$(gSamples(x))
           totalBits += sumBitsOfByte(gSamples(x))
        END IF
    NEXT x


    PRINT #999,  "totalBits: " + STR$(totalBits)

    gAccumNbrBits += 200
    PRINT #999,  "gAccumNbrBits: " + STR$(gAccumNbrBits)

    gAccumDev = gAccumDev +(totalBits - 100)
    PRINT #999,  "gAccumDev: " + STR$(gAccumDev)

    sqrAccumNbrBits = SQR(gAccumNbrBits)
    PRINT #999,  "sqrAccumNbrBits: " + STR$(sqrAccumNbrBits)

    zScore = gAccumDev * 1.0 / SQR((gAccumNbrBits * 1.0) / 4.0)
    PRINT #999,  "zScore: " + STR$(zScore)

    'tempForFile = TIME$ + "," + STR$(gRunningDuration) + "," + FORMAT$(totalBits, "0000") + "," + FORMAT$(zScore, "00.0000") + ","
    tempForFile = TIME$ + "," + STR$(gRunningDuration) + "," + FORMAT$((totalBits - 100), "0000") + "," + FORMAT$(zScore, "00.0000") + ","

    SELECT CASE globals.Target
        CASE 1 'REST
            tempForFile += "REST"
        CASE 2 'FOCUS
            IF (gHighOrLow = 0) THEN
               tempForFile += "FOCUS"
            ELSEIF (gHighOrLow = 1) THEN 'High
                tempForFile += "FOCUSHIGH"
            ELSE
                tempForFile += "FOCUSLOW"
            END IF
        CASE ELSE
            tempForFile += "NOTHING"
    END SELECT

    PRINT #999, "tempForFile: " + tempForFile

    IF (gBetweenTrialFlag = 0) THEN 'we are between trials
        'write nothing out
    ELSE
        IF (gRNDFile <> "") THEN
            PRINT #900, tempForFile
        END IF
    END IF

    CLOSE #999
END SUB
