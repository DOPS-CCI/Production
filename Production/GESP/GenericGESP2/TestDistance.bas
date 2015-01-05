#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN () AS LONG
    LOCAL x, y, flag AS BYTE
    LOCAL targetRow, targetCol, responseRow, responseCol AS BYTE
    LOCAL startPos, endPos AS LONG
    LOCAL temp AS STRING

    OPEN "C:\DOPS_Experiments\Subject_Data\9999\S9999-CE-20140425-1255.EVT" FOR INPUT AS #1
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp

        IF (INSTR(temp, "TargetDisplayedUpstairs") > 0) THEN
            DO
                LINE INPUT #1, temp
            LOOP UNTIL INSTR(temp, "</Event>") > 0
            ITERATE LOOP
        END IF
        IF (INSTR(temp, "TargetSelected") > 0) THEN
            DO
                LINE INPUT #1, temp
                IF (INSTR(temp, "TargetRow") > 0) THEN
                    startPos = INSTR(temp, ">")
                    endPos = INSTR(startPos, temp, "<")
                    targetRow = VAL(MID$(temp, startPos + 1 TO endPos))
                    #DEBUG PRINT "targetRow: " + STR$(targetRow)
                ELSEIF (INSTR(temp, "TargetColumn") > 0) THEN
                    startPos = INSTR(temp, ">")
                    endPos = INSTR(startPos, temp, "<")
                    targetCol = VAL(MID$(temp, startPos + 1 TO endPos))
                    #DEBUG PRINT "targetCol: " + STR$(targetCol)
                END IF
            LOOP UNTIL INSTR(temp, "</Event>") > 0
        END IF
        IF (INSTR(temp, "ResponseSelected") > 0) THEN
            DO
                LINE INPUT #1, temp
                IF (INSTR(temp, "ResponseRow") > 0) THEN
                    startPos = INSTR(temp, ">")
                    endPos = INSTR(startPos, temp, "<")
                    responseRow = VAL(MID$(temp, startPos + 1 TO endPos))
                    #DEBUG PRINT "responseRow: " + STR$(responseRow)
                ELSEIF (INSTR(temp, "ResponseColumn") > 0) THEN
                    startPos = INSTR(temp, ">")
                    endPos = INSTR(startPos, temp, "<")
                    responseCol = VAL(MID$(temp, startPos + 1 TO endPos))
                    #DEBUG PRINT "responseCol: " + STR$(responseCol)
                    'findNeighbors(responseRow, responseCol)
                    flag = isNeighbor(targetRow, targetCol, responseRow, responseCol)
                    IF (flag = 1) THEN
                        #DEBUG PRINT "Target and response are neighbors."
                    END IF
                    IF (targetRow = responseRow) THEN
                        #DEBUG PRINT "Target and Response on same row."
                    END IF
                    IF (targetCol = responseCol) THEN
                        #DEBUG PRINT "Target and Response on same column."
                    END IF
                    IF (targetRow = responseRow AND targetCol = responseCol) THEN
                        #DEBUG PRINT "Target and Response are an exact match."
                    END IF

                END IF
            LOOP UNTIL INSTR(temp, "</Event>") > 0
        END IF


    WEND

    CLOSE #1
END FUNCTION

FUNCTION distance(x1 AS BYTE, x2 AS BYTE, y1 AS BYTE, y2 AS BYTE) AS DOUBLE
    LOCAL d AS DOUBLE

    d = SQR((x2 - x1)^2 + (y2 - y1)^2)

    FUNCTION = d
END FUNCTION

FUNCTION isNeighbor(x AS BYTE, y AS BYTE, xn AS BYTE, yn AS BYTE) AS BYTE
    LOCAL flag AS BYTE
    LOCAL d AS DOUBLE

    flag = 0

    d = distance(x, xn, y, yn)
    IF (d >= 1 AND d < 2) THEN
        flag = 1
    END IF

    FUNCTION = flag

END FUNCTION

SUB findNeighbors(responseRow AS BYTE, responseCol AS BYTE)
    LOCAL x, y, flag AS BYTE

    flag = 0
    FOR x = 1 TO 4
        FOR y = 1 TO 13
            flag = isNeighbor(x, y, responseRow, responseCol)
            IF (flag = 1) THEN
                #DEBUG PRINT STR$(x) + "," + STR$(y)
            END IF
        NEXT y
    NEXT x
END SUB
