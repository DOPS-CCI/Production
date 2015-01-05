%MAXQUEUE = 36

TYPE doubleQueueInfo
    queueArray(1 TO %MAXQUEUE) AS DOUBLE
    front AS LONG
    rear AS LONG
END TYPE


SUB createDoubleQueue(doubleQueue AS doubleQueueInfo)
    doubleQueue.front = 0
    doubleQueue.rear = 0
END SUB


SUB enterDoubleQueue(doubleQueue AS doubleQueueInfo, contents AS DOUBLE)
    'condition for full Queue
    IF((doubleQueue.front = 0 AND doubleQueue.rear = %MAXQUEUE) OR (doubleQueue.front = doubleQueue.rear)) THEN
        MSGBOX "Queue is overflow."
        EXIT SUB
    END IF

    IF(doubleQueue.front = 0) THEN
          doubleQueue.front = 1
          doubleQueue.rear = 1
    ELSE
        IF(doubleQueue.rear = %MAXQUEUE) THEN
               doubleQueue.rear = 1
        ELSE
               INCR doubleQueue.rear
        END IF
    END IF
    doubleQueue.queueArray(doubleQueue.rear) = contents
    #DEBUG PRINT "enterDoubleQueue:front = " + STR$(doubleQueue.front)
    #DEBUG PRINT "enterDoubleQueue:rear = " + STR$(doubleQueue.rear)
END SUB

SUB deleteDoubleQueue(doubleQueue AS doubleQueueInfo)
    LOCAL y AS LONG

    IF (doubleQueue.front = 0) THEN
        MSGBOX "q is underflow"
        EXIT SUB
    END IF

    y = doubleQueue.queueArray(doubleQueue.front)

    IF(doubleQueue.front = doubleQueue.rear) THEN
          doubleQueue.front = 0
          doubleQueue.rear = 0
    ELSE
        IF(doubleQueue.front = %MAXQUEUE) THEN
            doubleQueue.front = 1
        ELSE
            INCR doubleQueue.front
        END IF
    END IF
END SUB

FUNCTION getDoubleQueueCount(doubleQueue AS doubleQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(doubleQueue.front)
    '#DEBUG PRINT "rear: " + STR$(doubleQueue.rear)
    FUNCTION = doubleQueue.rear - doubleQueue.front
END FUNCTION

SUB debugDisplayDoubleQueue(doubleQueue AS doubleQueueInfo)
    LOCAL i, j AS LONG

    IF(doubleQueue.front = 0 AND doubleQueue.rear = 0) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF
    #DEBUG PRINT "elements are :"
    FOR i= doubleQueue.front TO doubleQueue.rear STEP (i+1) MOD %MAXQUEUE
        'i = (i + 1) MOD %MAXQUEUE
        #DEBUG PRINT STR$(i) + ": " + STR$(doubleQueue.queueArray(i))
    NEXT i
    '#DEBUG PRINT STR$(doubleQueue.queueArray(doubleQueue.rear))
END SUB

FUNCTION rmsDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS LONG

    n = getDoubleQueueCount(doubleQueue)
    sum = 0.0
    FOR i = 1 TO n
        sum += doubleQueue.queueArray(i) * doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

FUNCTION meanDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS LONG

    n = getDoubleQueueCount(doubleQueue)
    sum = 0.0
    FOR i = 1 TO n
        sum += doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  sum / n
END FUNCTION
