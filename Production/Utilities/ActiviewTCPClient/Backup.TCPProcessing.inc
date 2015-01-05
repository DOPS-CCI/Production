FUNCTION cbConnect() AS LONG
    GLOBAL hDlg AS DWORD
    GLOBAL gnSocket AS LONG
    LOCAL  sBuffer, sTimeout   AS STRING
    LOCAL sPacket AS STRING
    LOCAL sPort, sServer AS STRING
    LOCAL lPort, lineCnt, lTimeout AS LONG

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPPort TO sPort
    lPort = VAL(sPort)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPServer TO sServer

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ReceiverTimeout TO sTimeout
    lTimeout = VAL(sTimeout)
    IF (lTimeout <= 0) THEN lTimeout = 10000

    TCP OPEN PORT lPort AT sServer AS gnSocket  TIMEOUT lTimeout
    IF ERR THEN
        MSGBOX "Error opening port: " + STR$(ERR)
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Connected, 0
        EXIT FUNCTION
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Connected, 1
    END IF
END FUNCTION


THREAD FUNCTION WorkThread(BYVAL y AS DWORD) AS DWORD
    CALL connectToActiview()
END FUNCTION

THREAD FUNCTION QueueThread(BYVAL y AS DWORD) AS DWORD
    CALL processQueue()
END FUNCTION


FUNCTION cbProcess() AS LONG
    LOCAL x AS LONG
    STATIC hThread, hQueueThread AS DWORD

    THREAD CREATE WorkThread(x) TO hThread???
    'THREAD CREATE QueueThread(x) TO hQueueThread???

END FUNCTION

FUNCTION processQueue() AS LONG
    LOCAL queueCnt, x AS LONG
    GLOBAL gCollect AS IQUEUECOLLECTION
    LOCAL temp AS VARIANT
    LOCAL buffer AS STRING

    queueCnt = gCollect.Count

    FOR x = 1 TO queueCnt
        temp = gCollect.DEQUEUE
        buffer = VARIANT$(temp)
        splitIntoChannels(buffer)
    NEXT x
END FUNCTION

FUNCTION connectToActiview() AS LONG
    GLOBAL gnSocket AS LONG
    GLOBAL gCollect AS IQUEUECOLLECTION
    LOCAL  sBuffer, sNumChannels, temp   AS STRING
    LOCAL sPacket AS STRING
    LOCAL sPort, sServer AS STRING
    LOCAL lPort, lError, lPartialFrame, lResult, lChannelCnt AS LONG
    LOCAL bytesInTCPArray AS LONG
    LOCAL iEmpty, x AS INTEGER

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray TO temp
    IF (TRIM$(temp) <> "") THEN
        bytesInTCPArray =VAL(temp)
    END IF
    'DIM Channels(giNumberOfChannels)

    LET gCollect = CLASS "QueueCollection"

    iEmpty = 0
    OPEN "c:\TestData.bin" FOR BINARY AS #1
    DO
        'TCP PRINT nSocket, "Hello from PowerBASIC!"
        IF (ERR) THEN
            MSGBOX "Error: " + STR$(ERR)
            EXIT FUNCTION
        END IF
        lError = tcpSafeReceive(gnSocket, bytesInTCPArray, sBuffer)
        IF (lError = %False) THEN
            'MSGBOX "Error: " + STR$(ERR)
            EXIT FUNCTION
        END IF
        IF (ERR) THEN
            MSGBOX "Error: " + STR$(ERR)
            EXIT FUNCTION
        ELSE
            PUT$ #1, sBuffer
            'CONTROL SET TEXT hDlg, %IDC_LABEL_TCPBuffer, sBuffer 'str$(val(mid$(sBuffer, 1, 1))) + " " + str$(val(MID$(sBuffer, 2, 1))) + " " + str$(val(MID$(sBuffer, 3, 1)))
            'LISTBOX ADD hDlg, %IDC_LISTBOX_RecvBuffer, sBuffer
            'control redraw hDlg, %IDC_LABEL_TCPBuffer
        END IF
    LOOP
    CLOSE #1
    FUNCTION = 1
END FUNCTION

FUNCTION findFirstNonNullCharacter(buffer AS STRING) AS LONG
    LOCAL x, lLen, lPos AS LONG
    LOCAL temp AS STRING

    temp = CHR$(0) + CHR$(0)
    lPos = 0
    lLen = LEN(buffer)
    FOR x = 1 TO lLen STEP 2
        IF (MID$(buffer, x, 2) <> temp) THEN
           lPos = x
           EXIT FOR
        END IF
    NEXT x

    FUNCTION = lPos
END FUNCTION

FUNCTION findFirstNullCharacter(buffer AS STRING) AS LONG
    LOCAL x, lLen, lPos AS LONG
    LOCAL temp AS STRING

    temp = CHR$(0) + CHR$(0)
    lPos = 0
    lLen = LEN(buffer)
    FOR x = 1 TO lLen STEP 2
        IF (MID$(buffer, x, 2) = temp) THEN
           lPos = x
           EXIT FOR
        END IF
    NEXT x

    FUNCTION = lPos
END FUNCTION

FUNCTION tcpSafeReceive(BYVAL hSocket AS LONG, BYVAL iBufferLen AS LONG, _
                        recBuff AS STRING) AS LONG

   'tcpSafeReceive is by Don Dickinson  - rated A+  (required)

   DIM iLeft AS LONG
   DIM sBuffer AS STRING
   recBuff = ""
   iLeft = iBufferLen
   DO
      sBuffer = SPACE$(iLeft)
      ON ERROR RESUME NEXT
      sBuffer = SPACE$(iBufferLen)
      TCP RECV hSocket, iLeft, sBuffer
      IF ERR THEN
         FUNCTION = %False
         EXIT FUNCTION
      END IF
      recBuff = recBuff + sBuffer
      IF LEN(recBuff) >= iBufferLen THEN
         EXIT DO
      END IF
      iLeft = iBufferLen - LEN(recBuff)
      SLEEP 1
   LOOP
   FUNCTION = %True
END FUNCTION

SUB splitIntoChannels(buffer AS STRING)
    LOCAL x, cnt, bufferSize, lResult, nbrOfBytes AS LONG
    LOCAL iTemp, iLo, iHi, iNew AS INTEGER
    LOCAL conByte AS BYTE
    LOCAL channelsSent, samplesPerChannel AS LONG
    LOCAL channelCnt AS LONG
    LOCAL sNumChannels, temp AS STRING

    '%IDC_TEXTBOX_BytesInTCPArray
    '%IDC_TEXTBOX_ChannelsSentByTCP
    '%IDC_TEXTBOX_TCPSamplesPerChannel

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP TO temp
    IF (TRIM$(temp) <> "") THEN
        channelsSent = VAL(temp)
    END IF

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel TO temp
    IF (TRIM$(temp) <> "") THEN
        samplesPerChannel = VAL(temp)
    END IF

    bufferSize = LEN(buffer)
    cnt = 0
    nbrOfBytes = 0
    temp = ""
    DO
        nbrOfBytes = nbrOfBytes + 1
        IF (nbrOfBytes MOD 3 = 0) THEN 'every three bytes
            temp = MID$(buffer, nbrOfBytes, 1) + MID$(buffer, nbrOfBytes - 1, 1) + MID$(buffer, nbrOfBytes - 2, 1) + CHR$(0)
            CONTROL SET TEXT hDlg, %IDC_LABEL_TCPBuffer, STR$(CVL(temp))
            temp = ""
        END IF
        'iLo = LO(BYTE, iTemp)
        'iHi = HI(BYTE, iTemp)
        'iNew = MAK(INTEGER, iHi, iLo)
        'MSGBOX STR$(iNew)
        'Channels(cnt) = iNew
        cnt = cnt + 1
    LOOP UNTIL nbrOfBytes >= bufferSize
END SUB

'SUB splitIntoChannels(buffer AS STRING)
'    LOCAL x, cnt, lLen, lResult AS LONG
'    LOCAL iTemp, iLo, iHi, iNew AS INTEGER
'    LOCAL channelCnt AS LONG
'    LOCAL sNumChannels AS STRING
'
'    IF (gsProcessFileName <> "") THEN
'        OPEN gsProcessFileName FOR OUTPUT AS 1
'    END IF
'
'
'    lLen = LEN(buffer)
'    'MSGBOX STR$(lLen)
'    cnt = 0
'    FOR x = 1 TO lLen STEP 2
'        iTemp = CVI(buffer, x)
'        'MSGBOX STR$(x) + ", " + STR$(iTemp)
'        iLo = LO(BYTE, iTemp)
'        iHi = HI(BYTE, iTemp)
'        iNew = MAK(INTEGER, iHi, iLo)
'        Channels(cnt) = iNew
'        cnt = cnt + 1
'    NEXT x
'
'
'    COMBOBOX GET TEXT hDlgfEEGDummy, %IDC_COMBOBOX_CHANNELS TO sNumChannels
'    channelCnt = VAL(sNumChannels)
'
'
'
'    FOR x = 0 TO channelCnt - 1
'        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_CHAN01 + x TO lResult
'        IF (lResult = 1) THEN 'checked
'            CONTROL SET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_CHAN01 + x, STR$(Channels(x))
'            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_CHAN01 + x
'            IF (gsProcessFileName <> "") THEN
'                PRINT #1, Channels(x); ", ";
'            END IF
'          END IF
'    NEXT x
'
'    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG1 TO lResult
'    IF (lResult = 1) THEN
'        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG1 TO lResult
'        IF (lResult = 1) THEN 'checked
'            CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_ANALOG1 , STR$(Channels(channelCnt))
'            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG1
'             IF (gsProcessFileName <> "") THEN
'                PRINT #1, Channels(channelCnt); ", ";
'            END IF
'        END IF
'    END IF
'
'    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG2 TO lResult
'    IF (lResult = 1) THEN
'        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG2 TO lResult
'        IF (lResult = 1) THEN 'checked
'            CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_ANALOG2 , STR$(Channels(channelCnt + 1))
'            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG2
'            IF (gsProcessFileName <> "") THEN
'                PRINT #1, Channels(channelCnt + 1); ", ";
'            END IF
'        END IF
'    END IF
'
'    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_DIGITAL TO lResult
'    IF (lResult = 1) THEN 'checked
'        CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_DIGITAL , STR$(Channels(channelCnt + 2))
'        CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_DIGITAL
'        IF (gsProcessFileName <> "") THEN
'                PRINT #1, Channels(channelCnt + 2)
'        END IF
'    END IF
'
'
'
'    'DIALOG REDRAW hDlgfEEGDummy
'
'
'    SLEEP 10
'END SUB
