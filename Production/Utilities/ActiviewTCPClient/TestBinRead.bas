#COMPILE EXE
#DIM ALL

UNION littleEnd
    bytes(1 TO 4) AS BYTE
    nbr AS LONG
END UNION

FUNCTION PBMAIN () AS LONG
    LOCAL str, temp AS STRING
    LOCAL lPtr AS LONG
    LOCAL conv AS LittleEnd


    OPEN "E:\PowerBasicClassicWindows10\Projects\Utilities\ActiviewTCPClient\TestData.bin" FOR BINARY AS #1
    lPtr = 1
    WHILE ISFALSE EOF(1)
        SEEK #1, lPtr
        GET$ #1, 3, str
        lPtr = lPtr + 192
        conv.bytes(3) = CVBYT(MID$(str, 3, 1))
        conv.bytes(2) = CVBYT(MID$(str, 2, 1))
        conv.bytes(1) = CVBYT(MID$(str, 1, 1))
        conv.bytes(4) = 0
        temp = MID$(str, 3, 1) + MID$(str, 2, 1) + MID$(str, 1, 1) + ""
        #DEBUG PRINT STR$(conv.nbr)
        '#debug print mkl$(val(temp))
    WEND


    CLOSE #1

END FUNCTION
