GLOBAL EEGMAXQUEUESIZE AS LONG
GLOBAL EEGQueueArray() AS DOUBLE

TYPE EEGDoubleQueueInfo
    front AS LONG
    rear AS LONG
END TYPE

SUB EEG_startDoubleQueue(BYREF doubleQueue AS EEGDoubleQueueInfo, maxSize AS LONG)
    EEGMAXQUEUESIZE = maxSize

    REDIM EEGQueueArray(0 TO maxSize)
    doubleQueue.front = -1
    doubleQueue.rear = -1
END SUB

FUNCTION EEG_isDoubleQueueFull(BYREF doubleQueue AS EEGDoubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF( (doubleQueue.rear + 1) MOD EEGMAXQUEUESIZE = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

FUNCTION EEG_isDoubleQueueEmpty(BYREF doubleQueue AS EEGDoubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF(doubleQueue.rear = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

SUB EEG_doubleEnqueue(BYREF doubleQueue AS EEGDoubleQueueInfo, x AS DOUBLE)
    IF(EEG_isDoubleQueueFull(doubleQueue) = 0) THEN   'not full
        doubleQueue.rear = (doubleQueue.rear + 1) MOD EEGMAXQUEUESIZE
        EEGQueueArray(doubleQueue.rear) = x
    END IF
END SUB


FUNCTION EEG_doubleDequeue(BYREF doubleQueue AS EEGDoubleQueueInfo) AS DOUBLE
    LOCAL value AS DOUBLE

    IF(EEG_isDoubleQueueEmpty(doubleQueue) = 0) THEN
        doubleQueue.front = (doubleQueue.front + 1) MOD EEGMAXQUEUESIZE
        value =  EEGQueueArray(doubleQueue.front)
    ELSE
        value = 0
    END IF

    FUNCTION = value
END FUNCTION

FUNCTION EEG_getDoubleQueueCount(doubleQueue AS EEGDoubleQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(intQueue.front)
    '#DEBUG PRINT "rear: " + STR$(intQueue.rear)
    FUNCTION = doubleQueue.rear - doubleQueue.front
END FUNCTION

SUB EEG_debugDisplayDoubleQueue(doubleQueue AS EEGDoubleQueueInfo)
    LOCAL i, j AS LONG

    'OPEN "c:\ThetaTrainer_queue.txt" FOR OUTPUT AS #3
    IF(isDoubleQueueEmpty(doubleQueue) = 1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF
    #DEBUG PRINT "elements are :"
    FOR i= 0 TO EEGMAXQUEUESIZE - 1
        #DEBUG PRINT STR$(i) + ": " + STR$(EEGQueueArray(i))
    NEXT i
    'CLOSE #3
    '#DEBUG PRINT STR$(doubleQueue.EEGQueueArray(doubleQueue.rear))
END SUB

FUNCTION EEG_rmsDoubleQueue(doubleQueue AS EEGDoubleQueueInfo, n AS LONG) AS DOUBLE
    LOCAL i AS LONG
    LOCAL sum AS DOUBLE

    sum = 0.0
    FOR i = 0 TO n
        sum += EEGQueueArray(i) * EEGQueueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

FUNCTION EEG_meanDoubleQueue(doubleQueue AS EEGDoubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = EEGMAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += EEGQueueArray(i)
    NEXT i

    FUNCTION =  sum / n
END FUNCTION

FUNCTION EEG_sumDoubleQueue(doubleQueue AS EEGDoubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = EEGMAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += EEGQueueArray(i) ^ 2
    NEXT i

    FUNCTION =  sum
END FUNCTION

FUNCTION EEG_rmsInteger(intArray() AS LONG, arrSize AS LONG) AS DOUBLE
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
