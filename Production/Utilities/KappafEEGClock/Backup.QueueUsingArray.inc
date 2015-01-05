%MAXQUEUE = 2000

TYPE queueInfo
    queueArray(0 TO %MAXQUEUE) AS INTEGER
    front AS LONG
    rear AS LONG
END TYPE


SUB createQueue(longQueue AS queueInfo)
    longQueue.front = 0
    longQueue.rear = 0
END SUB


SUB enterQueue(longQueue AS queueInfo, contents AS INTEGER)
    'condition for full Queue
    IF((longQueue.front = 0 AND longQueue.rear = %MAXQUEUE - 1) OR (longQueue.front = longQueue.rear + 1)) THEN
        MSGBOX "Queue is overflow."
        EXIT SUB
    END IF

    IF(longQueue.front = -1) THEN
          longQueue.front = 0
          longQueue.rear = 0
    ELSE
        IF(longQueue.rear = %MAXQUEUE-1) THEN
               longQueue.rear = 0
        ELSE
               INCR longQueue.rear
        END IF
    END IF
    longQueue.queueArray(longQueue.rear) = contents
END SUB

SUB deleteQueue(longQueue AS queueInfo)
    LOCAL y AS LONG

    IF (longQueue.front = -1) THEN
        MSGBOX "q is underflow"
        EXIT SUB
    END IF

    y = longQueue.queueArray(longQueue.front)

    IF(longQueue.front = longQueue.rear) THEN
          longQueue.front = -1
          longQueue.rear = -1
    ELSE
        IF(longQueue.front = %MAXQUEUE - 1) THEN
            longQueue.front = 0
        ELSE
            INCR longQueue.front
        END IF
    END IF
END SUB

FUNCTION getQueueCount(longQueue AS queueInfo) AS LONG
    #DEBUG PRINT "front: " + STR$(longQueue.front)
    #DEBUG PRINT "rear: " + STR$(longQueue.rear)
    FUNCTION = longQueue.rear - longQueue.front
END FUNCTION

SUB debugDisplayQueue(longQueue AS queueInfo)
    LOCAL i, j AS LONG

    IF(longQueue.front = -1 AND longQueue.rear = -1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF

    #DEBUG PRINT "elements are :"
    i = longQueue.front
    WHILE (i <> longQueue.rear)
        i = (i + 1) MOD %MAXQUEUE
        #DEBUG PRINT STR$(longQueue.queueArray(i))
    WEND
    '#DEBUG PRINT STR$(longQueue.queueArray(longQueue.rear))
END SUB

FUNCTION rmsQueue(longQueue AS queueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS LONG

    n = getQueueCount()
    sum = 0.0
    FOR i = 0 TO n
        sum += longQueue.queueArray(i) * longQueue.queueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION
