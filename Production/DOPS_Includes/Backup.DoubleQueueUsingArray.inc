%MAXQUEUE = 12

TYPE doubleQueueInfo
    queueArray(0 TO %MAXQUEUE) AS DOUBLE
    front AS LONG
    rear AS LONG
END TYPE

SUB startDoubleQueue(BYREF doubleQueue AS doubleQueueInfo)
    doubleQueue.front = -1
    doubleQueue.rear = -1
END SUB

FUNCTION isDoubleQueueFull(BYREF doubleQueue AS doubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF( (doubleQueue.rear + 1) MOD %MAXQUEUE = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

FUNCTION isDoubleQueueEmpty(BYREF doubleQueue AS doubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF(doubleQueue.rear = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

SUB doubleEnqueue(BYREF doubleQueue AS doubleQueueInfo, x AS DOUBLE)
    IF(isDoubleQueueFull(doubleQueue) = 0) THEN   'not full
        doubleQueue.rear = (doubleQueue.rear + 1) MOD %MAXQUEUE
        doubleQueue.queueArray(doubleQueue.rear) = x
    END IF
END SUB


FUNCTION doubleDequeue(BYREF doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL value AS DOUBLE

    IF(isDoubleQueueEmpty(doubleQueue) = 0) THEN
        doubleQueue.front = (doubleQueue.front + 1) MOD %MAXQUEUE
        value =  doubleQueue.queueArray(doubleQueue.front)
    ELSE
        value = 0
    END IF

    FUNCTION = value
END FUNCTION

FUNCTION getDoubleQueueCount(doubleQueue AS doubleQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(intQueue.front)
    '#DEBUG PRINT "rear: " + STR$(intQueue.rear)
    FUNCTION = doubleQueue.rear - doubleQueue.front
END FUNCTION

SUB debugDisplayDoubleQueue(doubleQueue AS doubleQueueInfo)
    LOCAL i, j AS LONG

    IF(isDoubleQueueEmpty(doubleQueue) = 1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF
    #DEBUG PRINT "elements are :"
    FOR i= 0 TO %MAXQUEUE - 1
        #DEBUG PRINT STR$(i) + ": " + STR$(doubleQueue.queueArray(i))
    NEXT i
    '#DEBUG PRINT STR$(doubleQueue.queueArray(doubleQueue.rear))
END SUB

FUNCTION rmsDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = %MAXQUEUE
    sum = 0.0
    FOR i = 0 TO n
        sum += doubleQueue.queueArray(i) * doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

FUNCTION meanDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = %MAXQUEUE
    sum = 0.0
    FOR i = 0 TO n
        sum += doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  sum / n
END FUNCTION

FUNCTION rmsInteger(intArray() AS LONG, arrSize AS LONG) AS DOUBLE
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
