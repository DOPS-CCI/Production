#COMPILE EXE
#DIM ALL

#INCLUDE "DoubleQueueUsingArray.inc"



FUNCTION PBMAIN () AS LONG
    LOCAL x AS LONG
    LOCAL value AS DOUBLE
    LOCAL runningRMSAVGQueue AS doubleQueueInfo

    startDoubleQueue(runningRMSAVGQueue)

    FOR x = 1 TO 100
        IF (x > 10) THEN
            #DEBUG PRINT "10 or greater "
            value = doubleDequeue(runningRMSAVGQueue)
            #DEBUG PRINT "doubleDequeue: " + STR$(value)
             #DEBUG PRINT "enter "
            doubleEnqueue(runningRMSAVGQueue, x * 1.0)
        ELSE
            #DEBUG PRINT "enter "
            doubleEnqueue(runningRMSAVGQueue, x * 1.0)
        END IF
        debugDisplayDoubleQueue(runningRMSAVGQueue)
    NEXT x
END FUNCTION
