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
    ChannelsToProcess AS LONG
    ChannelsToProcessArray(999, 3) AS DOUBLE
    UseThreshold AS BYTE
    InitialValue AS DOUBLE
    ThresholdLower AS DOUBLE
    ThresholdUpper AS DOUBLE
END TYPE

ENUM ProcessMiscellaneous
  EEG = 1
  EMG = 2
END ENUM

GLOBAL TCPIPSettings AS TCPIPDef
GLOBAL TCPIPBuffer AS TCPIPBuf
GLOBAL TCPIPCriticalSection AS Critical_Section
GLOBAL gSeconds, gMinutes, gSlidingWindowMark, gResetSampleArrayCount AS LONG
GLOBAL hDlg AS DWORD
GLOBAL gMVS_CONV AS DOUBLE
GLOBAL gINIFilename AS ASCIIZ * 512

SUB loadTCPIPDefaults(filename AS ASCIIZ * 512)
    LOCAL x, selected AS LONG
    LOCAL dwRet AS DWORD
    LOCAL temp, temp2 AS ASCIIZ * 2048
    LOCAL eegFilename AS ASCIIZ * 512
    DIM target(1 TO 999) AS STRING


    GetPrivateProfileString("Experiment Section", "EEGDefaultFilename", "", eegFilename, 2048, filename)
    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", TCPIPSettings.ActiviewConfigFile, 2048, eegFilename)

    'IF (ISFILE(TCPIPSettings.ActiviewConfigFile) = 0) THEN
    '    MSGBOX "The default Biosemi config file was not found."
    'END IF

    dwRet = GetPrivateProfileString("OPTIONS", "SampleRate", "", temp, 2048, eegFilename)
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
        'CASE "1"
        '    temp = "A1-E32 (160)"
        'CASE "0"
        '    temp = "A1-H32 (256)"
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
    SLEEP 10000

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
'calling the connectToServer(server, port, socket) function.  The following is a
'basic skeleton of processing a TCPIP buffer using Biosemi.
'****************************************************************************************
'SUB processBuffer(BYVAL TCPSocket AS LONG)
'    LOCAL buffer AS STRING
'    local x, y, bufPtr, bufSize, chanCnt as long
'
'    DO
'        TCP RECV TCPSocket, bufSize, buffer
'
'        'PUT$ #3, buffer
'
'        IF ERR THEN
'            MSGBOX "Error on RECV: " + ERROR$(ERR)
'            EXIT SUB
'        END IF
'
'        INCR TCPIPBuffer.SampleCnt
'
'
'        bufPtr = 0
'        chanCnt = 0
'
'        FOR x = 1 TO TCPIPSettings.TCPSamplesPerChannel
'            FOR y = 1 TO (TCPIPSettings.ChannelsSentByTCP * 3) STEP 3
'                INCR chanCnt
'                temp = bufPtr + y
'                sample = MID$(buffer, temp, 3)
'
'                conv.bytes(1) = CVBYT(MID$(sample, 1, 1))
'                conv.bytes(2) = CVBYT(MID$(sample, 2, 1))
'                conv.bytes(3) = CVBYT(MID$(sample, 3, 1))
'                conv.bytes(4) = 0
'
'                'do something with conv.nbr (which is the sample)
'            NEXT y
'
'            bufPtr = bufPtr + TCPIPSettings.ChannelsSentByTCP * 3
'
'        NEXT x
'        chanCnt = 0
'        bufPtr = 0
'
'
'    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR
'end sub

SUB FillChannelsToUseAndMisc()
    LOCAL x, lResult, lCnt, lState AS LONG
    LOCAL chanInfo, gainInfo, miscInfo AS STRING
    LOCAL chan, misc, gain AS STRING
    LOCAL EEGDefaultFilename, temp, temp2, lbItem AS ASCIIZ * 512


    GetPrivateProfileString("Experiment Section", "EEGDefaultFilename", "", EEGDefaultFilename, %MAXPPS_SIZE, EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)

    GetPrivateProfileString("CHANNELS INFO", "ChannelsToProcess", "1", temp, %MAXPPS_SIZE, EEGDefaultFilename)

    IF (TRIM$(temp) <> "") THEN
        lCnt = PARSECOUNT(temp, ",")
        IF (lCnt > 0) THEN
            TCPIPBuffer.ChannelsToProcess = lCnt
            'REDIM TCPIPSettings.ChannelsToUseArray(lCnt, 2)
            FOR x = 1 TO lCnt
                lbItem = PARSE$(temp, x)
                GetPrivateProfileString("CHANNELS INFO", lbItem, "1", temp2, %MAXPPS_SIZE, EEGDefaultFilename)
                chanInfo = PARSE$(temp2, ",", 1)
                chan = TRIM$(chanInfo)
                gainInfo = PARSE$(temp2, ",", 3)
                gain = PARSE$(gainInfo, "=", 2)
                miscInfo = PARSE$(temp2, ",", 4)
                misc = PARSE$(miscInfo, "=", 2)

                TCPIPBuffer.ChannelsToProcessArray(x, 1) = VAL(chan)
                TCPIPBuffer.ChannelsToProcessArray(x, 2) = VAL(gain)
                TCPIPBuffer.ChannelsToProcessArray(x, 3) = VAL(misc)
            NEXT x
        END IF
    END IF


    GetPrivateProfileString("CHANNELS INFO", "ChooseThreshold", "1", temp, %MAXPPS_SIZE, EEGDefaultFilename)
    TCPIPBuffer.UseThreshold = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "PreviousAverage", "1", temp, %MAXPPS_SIZE, EEGDefaultFilename)  'Initial Value
    TCPIPBuffer.InitialValue = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "LowerThreshold", "1", temp, %MAXPPS_SIZE, EEGDefaultFilename)
    TCPIPBuffer.ThresholdLower = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "UpperThreshold", "1", temp, %MAXPPS_SIZE, EEGDefaultFilename)
    TCPIPBuffer.ThresholdUpper = VAL(temp)
END SUB

FUNCTION isEEGChannelSelected(chanCnt AS LONG) AS BYTE
    LOCAL x AS LONG
    LOCAL flag AS BYTE

    flag = 0
    FOR x = 1 TO TCPIPBuffer.ChannelsToProcess
        IF (chanCnt = TCPIPBuffer.ChannelsToProcessArray(x, 1)) THEN
            flag = x
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag

END FUNCTION
