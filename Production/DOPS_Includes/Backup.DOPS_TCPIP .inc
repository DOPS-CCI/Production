TYPE TCPIPDef
    ActiviewConfigFile AS ASCIIZ * 512
    IPAddress AS ASCIIZ * 256
    IPPort AS LONG
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
END TYPE

TYPE TCPIPBuf
    SampleCnt AS LONG
END TYPE

GLOBAL TCPIPSettings AS TCPIPDef
GLOBAL TCPIPBuffer AS TCPIPBuf

SUB loadTCPIPDefaults()
    LOCAL x, selected AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512
    DIM target(1 TO 999) AS STRING

    filename = "H:\EEGSettings\TCPIPSettings.ini"

    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", TCPIPSettings.ActiviewConfigFile, 2048, filename)

    IF (ISFILE(TCPIPSettings.ActiviewConfigFile) = 0) THEN
        MSGBOX "The default Biosemi config file was not found."
    END IF

    GetPrivateProfileString("OPTIONS", "SampleRate", "", temp, 2048, filename)
    TCPIPSettings.SampleRate = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "ThrottledSampleRate", "", temp, 2048, filename)
    TCPIPSettings.ThrottledSampleRate = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "IP", "", temp, 2048, filename)
    TCPIPSettings.IPAddress = TRIM$(temp)

    GetPrivateProfileString("OPTIONS", "PORT", "", temp, 2048, filename)
    TCPIPSettings.IPPort = VAL(TRIM$(temp))

    GetPrivateProfileString("OPTIONS", "BytesInTCPArray", "1", temp, 2048, filename)
    TCPIPSettings.BytesInTCPArray = VAL(temp)

    GetPrivateProfileString("OPTIONS", "ChannelsSentByTCP", "1", temp, 2048, filename)
    TCPIPSettings.ChannelsSentByTCP = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSamplesPerChannel", "1", temp, 2048, filename)
    TCPIPSettings.TCPSamplesPerChannel = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSubset", "0", temp, 2048, filename)
    TCPIPSettings.TCPSubset = VAL(temp)
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
    TCPIPSettings.TCPSubsetStr = temp

    GetPrivateProfileString("OPTIONS", "Add8EXElectrodes", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add8EXElectrodes = 1
    ELSE
        TCPIPSettings.Add8EXElectrodes = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add7Sensors", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add7Sensors = 1
    ELSE
        TCPIPSettings.Add7Sensors = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add9Jazz", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add9Jazz = 1
    ELSE
        TCPIPSettings.Add9Jazz = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add32AIBChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.Add32AIBChan = 1
    ELSE
        TCPIPSettings.Add32AIBChan = 0
    END IF

    GetPrivateProfileString("OPTIONS", "AddTriggerStatusChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        TCPIPSettings.AddTriggerStatusChan = 1
    ELSE
        TCPIPSettings.AddTriggerStatusChan = 0
    END IF

    CALL buildChannelsToUse()

    GetPrivateProfileString("OPTIONS", "ChannelsUsed", "", temp, 2048, filename)
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

    idx = TCPIPSettings.TCPSubset + 1
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

    TCPIPSettings.ChannelsToUse = lPtr + 8 + 7 + 9 + 32
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

    FUNCTION = 0
END FUNCTION

SUB disconnectFromServer(BYVAL TCPSocket AS LONG)
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
    LOCAL bufSize, newSampleRate AS LONG
    LOCAL sample AS STRING
    LOCAL buffer AS STRING

    bufSize = INT(TCPIPSettings.BytesInTCPArray / TCPIPSettings.TCPSamplesPerChannel)
    newSampleRate = TCPIPSettings.SampleRate / (TCPIPSettings.SampleRate/TCPIPSettings.ThrottledSampleRate)

    DO
        INCR TCPIPBuffer.SampleCnt
        TCP RECV TCPSocket, bufSize, buffer
        'PUT$ #1, buffer

        '#DEBUG PRINT "buffer: " + buffer

        IF ERR THEN
            MSGBOX "Error on RECV: " + ERROR$(ERR)
            EXIT SUB
        END IF


        IF (TCPIPBuffer.SampleCnt MOD newSampleRate = 0) THEN 'calculate throttled samples per second
            INCR decSampleCnt

            bufPtr = 0
            yPtr = 0
            FOR x = 1 TO TCPIPBuffer.TCPSamplesPerChannel
                FOR y = 1 TO (TCPIPBuffer.ChannelsSentByTCP * 3) STEP 3
                    INCR yPtr
                    temp = bufPtr + y
                    sample = MID$(buffer, temp, 3)

                    conv.bytes(3) = CVBYT(MID$(sample, 3, 1))
                    conv.bytes(2) = CVBYT(MID$(sample, 2, 1))
                    conv.bytes(1) = CVBYT(MID$(sample, 1, 1))
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
                bufPtr = bufPtr + TCPIPSetting.ChannelsSentByTCP * 3
            NEXT y
            #DEBUG PRINT "====="
    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR
END SUB
