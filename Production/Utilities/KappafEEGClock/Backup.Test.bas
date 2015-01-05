#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN () AS LONG
    LOCAL x AS LONG
    LOCAL temp, sumSamplesForChannel AS DOUBLE

    temp = 0
    sumSamplesForChannel = 0
    FOR x = 0 TO 72000 STEP 8
        temp = (x + 1)
        sumSamplesForChannel += temp
    NEXT x

    MSGBOX "Sum: " + STR$(sumSamplesForChannel)

END FUNCTION
