GLOBAL EMGMAXQUEUESIZE AS LONG
GLOBAL EMGQueueArray() AS DOUBLE

TYPE EMGDoubleQueueInfo
    front AS LONG
    rear AS LONG
END TYPE

SUB EMG_startDoubleQueue(BYREF doubleQueue AS EMGDoubleQueueInfo, maxSize AS LONG)
    EMGMAXQUEUESIZE = maxSize

    REDIM EMGQueueArray(0 TO maxSize)
    doubleQueue.front = -1
    doubleQueue.rear = -1
END SUB

FUNCTION EMG_isDoubleQueueFull(BYREF doubleQueue AS EMGDoubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF( (doubleQueue.rear + 1) MOD EMGMAXQUEUESIZE = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

FUNCTION EMG_isDoubleQueueEmpty(BYREF doubleQueue AS EMGDoubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF(doubleQueue.rear = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

SUB EMG_doubleEnqueue(BYREF doubleQueue AS EMGDoubleQueueInfo, x AS DOUBLE)
    IF(EEG_isDoubleQueueFull(doubleQueue) = 0) THEN   'not full
        doubleQueue.rear = (doubleQueue.rear + 1) MOD EMGMAXQUEUESIZE
        EMGQueueArray(doubleQueue.rear) = x
    END IF
END SUB


FUNCTION EMG_doubleDequeue(BYREF doubleQueue AS EMGDoubleQueueInfo) AS DOUBLE
    LOCAL value AS DOUBLE

    IF(EMG_isDoubleQueueEmpty(doubleQueue) = 0) THEN
        doubleQueue.front = (doubleQueue.front + 1) MOD EMGMAXQUEUESIZE
        value =  EMGQueueArray(doubleQueue.front)
    ELSE
        value = 0
    END IF

    FUNCTION = value
END FUNCTION

FUNCTION EMG_getDoubleQueueCount(doubleQueue AS EMGDoubleQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(intQueue.front)
    '#DEBUG PRINT "rear: " + STR$(intQueue.rear)
    FUNCTION = doubleQueue.rear - doubleQueue.front
END FUNCTION

SUB EMG_debugDisplayDoubleQueue(doubleQueue AS EMGDoubleQueueInfo)
    LOCAL i, j AS LONG

    'OPEN "c:\ThetaTrainer_queue.txt" FOR OUTPUT AS #3
    IF(EMG_isDoubleQueueEmpty(doubleQueue) = 1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF
    #DEBUG PRINT "elements are :"
    FOR i= 0 TO EMGMAXQUEUESIZE - 1
        #DEBUG PRINT STR$(i) + ": " + STR$(EMGQueueArray(i))
    NEXT i
    'CLOSE #3
    '#DEBUG PRINT STR$(doubleQueue.EMGQueueArray(doubleQueue.rear))
END SUB

FUNCTION EMG_rmsDoubleQueue(doubleQueue AS EMGDoubleQueueInfo, n AS LONG) AS DOUBLE
    LOCAL i AS LONG
    LOCAL sum AS DOUBLE

    sum = 0.0
    FOR i = 0 TO n
        sum += EMGQueueArray(i) * EMGQueueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

FUNCTION EMG_meanDoubleQueue(doubleQueue AS EMGDoubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = EMGMAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += EMGQueueArray(i)
    NEXT i

    FUNCTION =  sum / n
END FUNCTION

FUNCTION EMG_sumDoubleQueue(doubleQueue AS EMGDoubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = EMGMAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += EMGQueueArray(i) ^ 2
    NEXT i

    FUNCTION =  sum
END FUNCTION

FUNCTION EMG_rmsInteger(intArray() AS LONG, arrSize AS LONG) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = arrSize
    sum = 0.0
    FOR i = 0 TO n
        sum += intArray(i) * intArray(i)
    NEXT i

    'FUNCTION =  sum / n
    FUNCTION =  SQR(sum / n)
END FUNCTION
