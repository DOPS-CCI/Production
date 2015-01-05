#COMPILE EXE
#DIM ALL



FUNCTION PBMAIN () AS LONG
    LOCAL x, y, recPos AS LONG
    LOCAL hiBy, loBy AS BYTE
    DIM  channel(1 TO 34) AS WORD

    OPEN "CH01_DATA.BIN" FOR BINARY AS #1

    recPos = 1
    FOR x = 1 TO 10000

        IF (x > 100) THEN
            channel(1) = 65535
            channel(2) = 1
            FOR y = 3 TO 32
                channel(y) = 65535
            NEXT y
            channel(33) = 0
            channel(34) = 0
        ELSE
            channel(1) = 0
            FOR y = 2 TO 32
                channel(y) = 0
            NEXT y
            channel(33) = 0
            channel(34) = 0
        END IF

        PUT #1, recPos, channel()
        recPos = recPos + 68
    NEXT x
    CLOSE #1



END FUNCTION
