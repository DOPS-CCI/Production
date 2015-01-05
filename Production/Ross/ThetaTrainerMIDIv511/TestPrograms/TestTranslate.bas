#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN () AS LONG
    LOCAL decFlag AS BYTE
    LOCAL cnt AS LONG
    LOCAL x AS DOUBLE
    LOCAL retVal, dMin1, dMax1, dMin2, dMax2, stepVal1, stepVal2 AS DOUBLE

    'retVal = translate(4, 1, 10, 1000, 2000)

    '#debug print str$(retVal)

'    dMin1 = -500
'    dMax1 = 500
'    dMin2 = 1
'    if (dMin1 > 0 and dMin1 < 1) then
'        decFlag = 1
'        stepVal1 = dMin1
'        stepVal2 = dMin2
'        dMax2 = (dMax1 / dMin1)
'    else
'        decFlag = 0
'        stepVal1 = abs(dMax1 / dMin1)
'        stepVal2 = ABS(dMax1 / dMin1)
'        dMax2 = dMax1 - dMin1
'    end if
'
'    if (decFlag = 0) then
'        cnt = 0
'        FOR x = dMin1 TO dMax1 step stepVal1
'            incr cnt
'            retVal = remapLong(x, dMin1, dMax1, dMin2, dMax2)
'            #DEBUG PRINT "cnt: " + STR$(cnt) + " x: " + STR$(x, 5) + " " + STR$(retVal, 5)
'        NEXT x
'
'        #DEBUG PRINT "================================="
'        cnt = 0
'        FOR x = dMin2 TO dMax2 step stepVal2
'            incr cnt
'            retVal = remapLong(x, dMin2, dMax2, dMin1, dMax1)
'            #DEBUG PRINT "cnt: " + str$(cnt) + " x: " + STR$(x, 5) + " " + STR$(retVal, 5)
'        NEXT x
'    else
'        cnt = 0
'        FOR x = dMin1 TO dMax1 STEP stepVal1
'            INCR cnt
'            retVal = remapDouble(x, dMin1, dMax1, dMin2, dMax2)
'            #DEBUG PRINT "cnt: " + STR$(cnt) + " x: " + STR$(x, 5) + " " + STR$(retVal, 5)
'        NEXT x
'
'        #DEBUG PRINT "================================="
'        cnt = 0
'        FOR x = dMin2 TO dMax2 STEP stepVal2
'            INCR cnt
'            retVal = remapDouble(x, dMin2, dMax2, dMin1, dMax1)
'            #DEBUG PRINT "cnt: " + STR$(cnt) + " x: " + STR$(x, 5) + " " + STR$(retVal, 5)
'        NEXT x
'    end if

'     retVal = remapForTrackBar(.1, .1, 5, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'
'     retVal = remapForTrackBar(5, .1, 5, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'      retVal = remapForTrackBarReverse(1, .1, 5, .1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'
'     retVal = remapForTrackBarReverse(50, .1, 5, .1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)

     FOR x = .1 TO 10 STEP .1
         retVal = remapForTrackBar(x, .1, 10, 1)
         #DEBUG PRINT STR$(x) + " retVal: " + STR$(retVal, 5)
     NEXT x

     #DEBUG PRINT "========================================"

     'retVal = remapForTrackBar(10, .1, 10, 1)
     '#DEBUG PRINT "retVal: " + STR$(retVal, 5)

     FOR x = 1 TO 100
         retVal = remapForTrackBarReverse(x, .1, 10, .1)
         #DEBUG PRINT STR$(x) + " retVal: " + STR$(retVal, 5)
     NEXT x


     'retVal = remapForTrackBarReverse(100, 10, .1, .1)
     '#DEBUG PRINT "retVal: " + STR$(retVal, 5)

'     retVal = remapForTrackBar(-500, -500, 500, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'
'     retVal = remapForTrackBar(500, -500, 500, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'      retVal = remapForTrackBarReverse(1, -500, 500, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)
'
'
'     retVal = remapForTrackBarReverse(1000, -500, 500, 1)
'     #DEBUG PRINT "retVal: " + STR$(retVal, 5)


END FUNCTION

FUNCTION remapForTrackBar(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
    LOCAL decFlag AS BYTE
    LOCAL retVal AS DOUBLE
    LOCAL dMax2 AS DOUBLE

    IF (dMin1 > 0 AND dMin1 < 1) THEN
        decFlag = 1
        dMax2 = (dMax1 / dMin1)
    ELSE
        decFlag = 0
        dMax2 = dMax1 - dMin1
    END IF

    IF (decFlag = 0) THEN
        retVal = remapLong(value, dMin1, dMax1, dMin2, dMax2)
        #DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    ELSE
        retVal = remapDouble(value, dMin1, dMax1, dMin2, dMax2)
        #DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    END IF

    FUNCTION = retVal


END FUNCTION

FUNCTION remapForTrackBarReverse(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
    LOCAL decFlag AS BYTE
    LOCAL retVal AS DOUBLE
    LOCAL dMax2 AS DOUBLE

    IF (dMin1 > 0 AND dMin1 < 1) THEN
        decFlag = 1
        dMax2 = (dMax1 / dMin1)
    ELSE
        decFlag = 0
        dMax2 = dMax1 - dMin1
    END IF

    IF (decFlag = 0) THEN
        retVal = remapLong(value, dMin2, dMax2, dMin1, dMax1)
        #DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    ELSE
        retVal = remapDouble(value, dMin2, dMax2, dMin1, dMax1)
        #DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
    END IF

    FUNCTION = retVal


END FUNCTION


FUNCTION remapLong(BYVAL x AS LONG, BYVAL oMin AS LONG, BYVAL oMax AS LONG, BYVAL nMin AS LONG, BYVAL nMax AS LONG) AS LONG
    LOCAL reverseInput, reverseOutput AS BYTE
    LOCAL oldMin, oldMax, newMin, newMax AS LONG
    LOCAL portion, result AS DOUBLE

    '#range check
    IF (oMin = oMax) THEN
        MSGBOX "Warning: Zero input range"
        FUNCTION = -99999999
    END IF

    IF (nMin = nMax) THEN
        MSGBOX "Warning: Zero output range"
        FUNCTION = -99999999
    END IF

    '#check reversed input range
    reverseInput = 0
    oldMin = MIN( oMin, oMax )
    oldMax = MAX( oMin, oMax )
    IF (oldMin <> oMin) THEN
        reverseInput = 1
    END IF

    '#check reversed output range
    reverseOutput = 0
    newMin = MIN( nMin, nMax )
    newMax = MAX( nMin, nMax )
    IF (newMin <> nMin) THEN
        reverseOutput = 1
    END IF

    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
    IF (reverseInput = 1) THEN
        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
    END IF

    result = portion + newMin
    IF (reverseOutput = 1) THEN
        result = newMax - portion
    END IF

    FUNCTION = result
END FUNCTION

FUNCTION remapDouble(BYVAL x AS DOUBLE, BYVAL oMin AS DOUBLE, BYVAL oMax AS DOUBLE, BYVAL nMin AS DOUBLE, BYVAL nMax AS DOUBLE) AS DOUBLE
    LOCAL reverseInput, reverseOutput AS BYTE
    LOCAL oldMin, oldMax, newMin, newMax AS DOUBLE
    LOCAL portion, result AS DOUBLE

    '#range check
    IF (oMin = oMax) THEN
        MSGBOX "Warning: Zero input range"
        FUNCTION = -99999999
    END IF

    IF (nMin = nMax) THEN
        MSGBOX "Warning: Zero output range"
        FUNCTION = -99999999
    END IF

    '#check reversed input range
    reverseInput = 0
    oldMin = MIN( oMin, oMax )
    oldMax = MAX( oMin, oMax )
    IF (oldMin <> oMin) THEN
        reverseInput = 1
    END IF

    '#check reversed output range
    reverseOutput = 0
    newMin = MIN( nMin, nMax )
    newMax = MAX( nMin, nMax )
    IF (newMin <> nMin) THEN
        reverseOutput = 1
    END IF

    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
    IF (reverseInput = 1) THEN
        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
    END IF

    result = portion + newMin
    IF (reverseOutput = 1) THEN
        result = newMax - portion
    END IF

    FUNCTION = result
END FUNCTION
