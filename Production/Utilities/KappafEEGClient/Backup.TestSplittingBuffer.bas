#COMPILE EXE
#DIM ALL

#INCLUDE "ChannelInfo.INC"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"

GLOBAL gUnfinishedBuffer AS STRING '8192
GLOBAL gRecvBuffer AS STRING '8192
GLOBAL gRecArray() AS STRING

FUNCTION PBMAIN () AS LONG
    LOCAL x, y, nbrOfRecs, nbrOfChannels AS LONG

    gUnfinishedBuffer = ""
    FOR x = 1 TO 45
        gRecvBuffer = gRecvBuffer + CHR$(0)
    NEXT x
    gRecvBuffer = gRecvBuffer + _
                    CHR$(255) + CHR$(18) + CHR$(255) + CHR$(159) + CHR$(0) + CHR$(0) + CHR$(0) + CHR$(0) + _
                    CHR$(255) + CHR$(180) +CHR$(251) + CHR$(152) + CHR$(0) + CHR$(0) + CHR$(0) + CHR$(0) + _
                    CHR$(247) + CHR$(123) +CHR$(248) + CHR$(252) + CHR$(0) + CHR$(0) + CHR$(0) + CHR$(0)

    nbrOfRecs = parseBuffer()
    nbrOfChannels = 2

     LOCAL ch02 AS Channel02

            'INCR gFramesProcessed
            'CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            'CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch02.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch02.Channels(y) = SwapBytesWord(ch02.Channels(y))
                    'CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    'IF (lResult = 1) THEN 'checked
                    '    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch02.Channels(y))
                    '    CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    'END IF
                    #DEBUG PRINT "Channels: " + STR$(y) + ", " + STR$(ch02.Channels(y))
                NEXT y
                FOR y = nbrOfChannels + 1 TO nbrOfChannels + 2
                    #DEBUG PRINT "Extras: " + STR$(y) + ", " + STR$(ch02.Channels(y))
                NEXT y
            NEXT x


END FUNCTION

FUNCTION parseBuffer() AS LONG
    LOCAL hiBy, loBy AS BYTE
    LOCAL char AS STRING, recBuffer AS STRING, buffer AS STRING, temp AS STRING, chStr AS STRING                                                              ' VOID
    LOCAL x, y, z, cnt, bufLen, startPos, endPos, nbrOfRecs, bytesLeft, lLen, selected, lResult AS LONG
    LOCAL nbrOfChannels, nbrOfBytes AS LONG

    nbrOfChannels = 2 + 2'VAL(temp)
    nbrOfBytes = (nbrOfChannels * 2) '+ 4

    buffer = TRIM$(gUnfinishedBuffer) + TRIM$(gRecvBuffer)

    bufLen = LEN(buffer)
    FOR x = 1 TO bufLen
        char = MID$(buffer, x, 1)
        IF (char <> CHR$(0)) THEN
            cnt = x
            EXIT FOR
        END IF
    NEXT x
    IF (cnt = 0) THEN
        EXIT FUNCTION
    END IF
    temp = RIGHT$(buffer, bufLen - cnt + 1)
    bufLen = LEN(temp)

    nbrOfRecs = INT(bufLen / nbrOfBytes)
    bytesLeft = bufLen - (nbrOfRecs * nbrOfBytes)

    gUnfinishedBuffer = MID$(gRecvBuffer, nbrOfRecs * nbrOfBytes TO nbrOfRecs * nbrOfBytes + bytesLeft)
    recBuffer = TRIM$(temp)

    splitRecBufferIntoArray(recBuffer, nbrOfRecs, nbrOfChannels)

    FUNCTION = nbrOfRecs
END FUNCTION

SUB splitRecBufferIntoArray(recBuffer AS STRING, nbrOfRecs AS LONG, nbrOfChannels AS LONG)
    LOCAL startPtr, endPtr, cnt, recBufferLen  AS LONG

    REDIM gRecArray(nbrOfRecs)

    recBufferlen = LEN(recBuffer)
    cnt = 0
    startPtr = 1
    endPtr = (nbrOfChannels * 2) '+ 4    '(Number of channels x 2 bytes (short integer) per channel) + 4 bytes for extra channel and event channel
    DO
        INCR cnt
        gRecArray(cnt) = MID$(recBuffer, startPtr, endPtr) 'MID$(recBuffer, startPtr, endPtr - 4)
        startPtr = startPtr + endPtr
    LOOP UNTIL startPtr > recBufferlen

END SUB
