#COMPILE EXE
#DIM ALL

GLOBAL gNbrOfChans, gNbrOfSamps AS LONG
GLOBAL gSampleBuffer, gSample AS STRING

UNION littleEnd
    bytes(1 TO 4) AS BYTE
    nbr AS LONG
END UNION

FUNCTION PBMAIN () AS LONG
    LOCAL x, y, yPtr, bufPtr, temp AS LONG
    DIM bufArray(3, 4) AS INTEGER
    LOCAL conv AS LittleEnd

    gNbrOfChans = 4
    gNbrOfSamps = 3

    gSampleBuffer = ""
    FOR x = 1 TO gNbrOfChans * gNbrOfSamps * 3
        gSampleBuffer = gSampleBuffer + MKBYT$(x)
    NEXT x

    bufPtr = 0
    yPtr = 0
    FOR x = 1 TO gNbrOfSamps
        FOR y = 1 TO (gNbrOfChans * 3) STEP 3
            INCR yPtr
            #DEBUG PRINT "y: " + STR$(y)
            #DEBUG PRINT "yPtr: " + STR$(yPtr)
            temp = bufPtr + y
            #DEBUG PRINT "temp: " + STR$(temp)
            gSample = MID$(gSampleBuffer, temp, 3)
            #DEBUG PRINT "gSample: " + gSample
            conv.bytes(1) = CVBYT(MID$(gSample, 3, 1))
            conv.bytes(2) = CVBYT(MID$(gSample, 2, 1))
            conv.bytes(3) = CVBYT(MID$(gSample, 1, 1))
            conv.bytes(4) = 0
            bufArray(x, yPtr) = conv.nbr
        NEXT y
        yPtr = 0
        bufPtr = bufPtr + gNbrOfChans * 3
    NEXT y
    #DEBUG PRINT "====="
    FOR x = 1 TO gNbrOfSamps
        #DEBUG PRINT "row: " + STR$(x)
        FOR y = 1 TO gNbrOfChans
            #DEBUG PRINT "col: " + STR$(y)
            #DEBUG PRINT STR$(bufArray(x, y))
        NEXT y
    NEXT y

END FUNCTION

UNION WordToBytes
    num AS WORD
    arr(1 TO 2) AS BYTE
END UNION

FUNCTION SwapBytesWord(BYVAL n AS WORD) AS WORD
    LOCAL chg AS WordToBytes

    chg.num = n
    IF (chg.arr(1) = 32) THEN
        chg.arr(1) = 0
    END IF
    n = chg.num
    '#debug print "n = " + str$(n) + "arr(1): " + str$(chg.arr(1)) + " arr(2): " + str$(chg.arr(2))
    'big endian to little endian
    ROTATE LEFT n, 8
    FUNCTION = n
END FUNCTION

UNION littleEnd
    bytes(1 TO 4) AS BYTE
    nbr AS LONG
END UNION

UNION byteToStr
    str AS STRING * 36
    byteStr(18) AS INTEGER
END UNION

FUNCTION createBuffer() AS STRING
    LOCAL x, w, cnt AS LONG
    LOCAL rndNum, temp, num AS INTEGER
    LOCAL str AS STRING
    LOCAL bs AS byteToStr

    RANDOMIZE TIMER
    str = ""
    cnt = 0
    FOR w = 1 TO gNbrOfSamps
        FOR x = 1 TO gNbrOfChans
            INCR cnt
            IF (x = 1) THEN
                rndNum = RND(-32768, 32767)
                num = rndNum
                temp = SwapBytesWord(num)
            'temp = num
                bs.byteStr(cnt - 1) = temp
            ELSE
                num = 0
                temp = SwapBytesWord(num)
            'temp = num
                bs.byteStr(cnt - 1) = temp
            END IF
        NEXT x
        str = str + bs.str
    NEXT w

    'gSample = gSample + MKI$(0)
    'gSample = gSample + MKI$(0)

    'FOR x = 1 TO gNbrOfChannels + 2
    '    #debug print Str$(cvi(gSample, x))
    'next x



    FUNCTION = str

END FUNCTION
