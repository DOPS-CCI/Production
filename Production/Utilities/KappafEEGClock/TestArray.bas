#COMPILE EXE
#DIM ALL

#INCLUDE "DoubleQueueUsingArray.inc"

GLOBAL gSeconds, gMinutes AS LONG

FUNCTION PBMAIN () AS LONG
    LOCAL samples, x, y, sampleCnt, decSampleCnt, threeMinutesPassed AS INTEGER
    LOCAL temp(), rms() AS INTEGER
    LOCAL rmsValue, rmsTotal, rmsTotalOld, rmsAvg, runningRmsAvg, newRunningAvg, threeMinuteRmsAvg, tempDequeue AS DOUBLE
    LOCAL runningRMSAVGQueue AS doubleQueueInfo

    REDIM temp(8,250)
    REDIM rms(250)

    gSeconds = 0
    gMinutes = 0
    rmsTotalOld = 0
    sampleCnt = 0
    decSampleCnt = 0
    rmsTotal = 0
    threeMinutesPassed = 0

    startDoubleQueue(runningRMSAVGQueue)

    FOR samples = 1 TO 600000
        INCR sampleCnt

        '#debug print "sampleCnt: " + str$(sampleCnt)
        IF (sampleCnt = 1000) THEN 'gives me a millisecond
            sampleCnt = 0
            INCR gSeconds
        END IF

        CALL calcTimeElapsed()

        IF (sampleCnt MOD 20 = 0) THEN '50 samples a second
            INCR decSampleCnt
            '#DEBUG PRINT "decSampleCnt: " + STR$(decSampleCnt)
            FOR x = 1 TO 8
                temp(x, decSampleCnt) = RND(1,10)
            NEXT x
        END IF

        IF (gSeconds MOD 5 = 0 AND sampleCnt = 0) THEN 'every 5 seconds
            decSampleCnt = 0
            #DEBUG PRINT " "
            #DEBUG PRINT "5 seconds..."
            rmsTotal = 0
            FOR x = 1 TO 8
                FOR y = 1 TO 250
                    rms(y) = temp(x, y)
                NEXT y
                rmsValue = rmsInteger(rms(), 250)
                #DEBUG PRINT "rmsValue for channel " + STR$(x) + " = " + STR$(rmsValue)
                rmsTotal += rmsValue
            NEXT x

            #DEBUG PRINT "rmsTotal for 8 channels " + " = " + STR$(rmsTotal)

            rmsAvg = (rmsTotal / 8)
            #DEBUG PRINT "rmsAvg for 8 channels " + " = " + STR$(rmsAvg)

            runningRmsAvg += rmsAvg - rmsTotalOld
            #DEBUG PRINT "running total rmsAvg for 8 channels " + " = " + STR$(runningRmsAvg)

            IF (threeMinutesPassed = 1) THEN
                tempDequeue = doubleDequeue(runningRMSAVGQueue)
                #DEBUG PRINT "Dequeue: " + STR$(tempDequeue)
                debugDisplayDoubleQueue(runningRMSAVGQueue)
                #DEBUG PRINT "Enqueue: " + STR$(rmsAvg)
                doubleEnqueue(runningRMSAVGQueue, rmsAvg)
                debugDisplayDoubleQueue(runningRMSAVGQueue)
            ELSE
                doubleEnqueue(runningRMSAVGQueue, rmsAvg)
            END IF
            'debugDisplayDoubleQueue(runningRMSAVGQueue)


        END IF

        IF (gSeconds MOD 5 = 0 AND threeMinutesPassed = 1 AND sampleCnt = 0) THEN
            #DEBUG PRINT " "
            #DEBUG PRINT "5 seconds after 3 minutes..."

            threeMinuteRmsAvg = meanDoubleQueue(runningRMSAVGQueue)
            #DEBUG PRINT "Moving RMS Avg (using queue): " + STR$(threeMinuteRmsAvg)


            threeMinuteRmsAvg = (runningRmsAvg) / 36
            rmsTotalOld = rmsAvg
            #DEBUG PRINT "Moving RMS Avg: " + STR$(threeMinuteRmsAvg)

            'rmsTotals -= oldRMSUpdate
            'CONTROL SET TEXT hDlg, %IDC_LABEL_RMS, STR$(rmsTotals/36)
            'CONTROL REDRAW hDlg, %IDC_LABEL_Status
        END IF

        IF (gMinutes = 3) THEN
           threeMinutesPassed = 1
        END IF


'        FOR x = 1 TO 8
'            FOR y = 1 TO 250
'                #debug print "Row: " + str$(x) + " Col: " + str$(y) + " " + str$(temp(x, y))
'            NEXT x
'        NEXT y


    NEXT samples

END FUNCTION

FUNCTION rmsInteger(intArray() AS INTEGER, arrSize AS INTEGER) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS LONG

    n = arrSize
    sum = 0.0
    FOR i = 0 TO n
        sum += intArray(i) * intArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

SUB calcTimeElapsed()
    '#DEBUG PRINT "Seconds : " + STR$(gSeconds)
    IF (gSeconds > 59) THEN
        gSeconds = 0
        INCR gMinutes
        #DEBUG PRINT "Minutes : " + STR$(gMinutes)
    END IF
    SLEEP 1
    'CONTROL SET TEXT hDlg, %IDC_LABEL_Clock, FORMAT$(gMinutes, "00") + ":" + FORMAT$(gSeconds, "00")
    'CONTROL REDRAW hDlg, %IDC_LABEL_Clock
END SUB
