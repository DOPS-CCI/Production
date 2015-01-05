%MAXQUEUE = 2000

TYPE integerQueueInfo
    queueArray(0 TO %MAXQUEUE) AS INTEGER
    front AS LONG
    rear AS LONG
END TYPE


SUB createIntegerQueue(BYREF intQueue AS integerQueueInfo)
    RESET intQueue.queueArray()
    intQueue.front = 0
    intQueue.rear = 0
END SUB


SUB enterIntegerQueue(intQueue AS integerQueueInfo, contents AS INTEGER)
    'condition for full Queue
    IF((intQueue.front = 0 AND intQueue.rear = %MAXQUEUE - 1) OR (intQueue.front = intQueue.rear + 1)) THEN
        MSGBOX "Queue is overflow."
        EXIT SUB
    END IF

    IF(intQueue.front = -1) THEN
          intQueue.front = 0
          intQueue.rear = 0
    ELSE
        IF(intQueue.rear = %MAXQUEUE-1) THEN
               intQueue.rear = 0
        ELSE
               INCR intQueue.rear
        END IF
    END IF
    intQueue.queueArray(intQueue.rear) = contents
END SUB

SUB deleteIntegerQueue(intQueue AS integerQueueInfo)
    LOCAL y AS LONG

    IF (intQueue.front = -1) THEN
        MSGBOX "q is underflow"
        EXIT SUB
    END IF

    y = intQueue.queueArray(intQueue.front)

    IF(intQueue.front = intQueue.rear) THEN
          intQueue.front = -1
          intQueue.rear = -1
    ELSE
        IF(intQueue.front = %MAXQUEUE - 1) THEN
            intQueue.front = 0
        ELSE
            INCR intQueue.front
        END IF
    END IF
END SUB

FUNCTION getIntegerQueueCount(intQueue AS integerQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(intQueue.front)
    '#DEBUG PRINT "rear: " + STR$(intQueue.rear)
    FUNCTION = intQueue.rear - intQueue.front
END FUNCTION

SUB debugDisplayIntegerQueue(intQueue AS integerQueueInfo)
    LOCAL i, j AS LONG

    IF(intQueue.front = -1 AND intQueue.rear = -1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF

    #DEBUG PRINT "elements are :"
    i = intQueue.front
    WHILE (i <> intQueue.rear)
        i = (i + 1) MOD %MAXQUEUE
        #DEBUG PRINT STR$(intQueue.queueArray(i))
    WEND
    '#DEBUG PRINT STR$(intQueue.queueArray(intQueue.rear))
END SUB

FUNCTION rmsIntegerQueue(intQueue AS integerQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS LONG

    n = getIntegerQueueCount(intQueue)
    sum = 0.0
    FOR i = 0 TO n
        sum += intQueue.queueArray(i) * intQueue.queueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION
