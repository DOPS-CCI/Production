GLOBAL MAXQUEUESIZE AS LONG
'GLOBAL queueArray() AS DOUBLE

TYPE doubleQueueInfo
    queueArray(0 TO 10) AS DOUBLE
    front AS LONG
    rear AS LONG
END TYPE

SUB startDoubleQueue(BYREF doubleQueue AS doubleQueueInfo, maxSize AS LONG)
    MAXQUEUESIZE = maxSize

    doubleQueue.front = -1
    doubleQueue.rear = -1
END SUB

FUNCTION isDoubleQueueFull(BYVAL doubleQueue AS doubleQueueInfo) AS INTEGER
    LOCAL flag AS INTEGER

    IF( (doubleQueue.rear + 1) MOD MAXQUEUESIZE = doubleQueue.front) THEN
        flag = 1
    ELSE
        flag = 0
    END IF

    FUNCTION = flag
END FUNCTION

FUNCTION isDoubleQueueEmpty(BYVAL doubleQueue AS doubleQueueInfo) AS INTEGER
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
        doubleQueue.rear = (doubleQueue.rear + 1) MOD MAXQUEUESIZE
        doubleQueue.queueArray(doubleQueue.rear) = x
    END IF
END SUB


FUNCTION doubleDequeue(BYVAL doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL value AS DOUBLE

    IF(isDoubleQueueEmpty(doubleQueue) = 0) THEN
        doubleQueue.front = (doubleQueue.front + 1) MOD MAXQUEUESIZE
        value =  doubleQueue.queueArray(doubleQueue.front)
    ELSE
        value = 0
    END IF

    FUNCTION = value
END FUNCTION

FUNCTION getDoubleQueueCount(BYVAL doubleQueue AS doubleQueueInfo) AS LONG
    '#DEBUG PRINT "front: " + STR$(intQueue.front)
    '#DEBUG PRINT "rear: " + STR$(intQueue.rear)
    FUNCTION = doubleQueue.rear - doubleQueue.front
END FUNCTION

SUB debugDisplayDoubleQueue(BYVAL doubleQueue AS doubleQueueInfo)
    LOCAL i, j AS LONG

    'OPEN "c:\ThetaTrainer_queue.txt" FOR OUTPUT AS #3
    IF(isDoubleQueueEmpty(doubleQueue) = 1) THEN
        MSGBOX "q is empty"
        EXIT SUB
    END IF
    #DEBUG PRINT "elements are :"
    FOR i= 0 TO MAXQUEUESIZE - 1
        #DEBUG PRINT STR$(i) + ": " + STR$(doubleQueue.queueArray(i))
    NEXT i
    'CLOSE #3
    '#DEBUG PRINT STR$(doubleQueue.queueArray(doubleQueue.rear))
END SUB

FUNCTION rmsDoubleQueue(doubleQueue AS doubleQueueInfo, n AS LONG) AS DOUBLE
    LOCAL i AS LONG
    LOCAL sum AS DOUBLE

    sum = 0.0
    FOR i = 0 TO n
        sum += doubleQueue.queueArray(i) * doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  SQR(sum / n)
END FUNCTION

FUNCTION meanDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = MAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += doubleQueue.queueArray(i)
    NEXT i

    FUNCTION =  sum / n
END FUNCTION

FUNCTION sumDoubleQueue(doubleQueue AS doubleQueueInfo) AS DOUBLE
    LOCAL i, n AS LONG
    LOCAL sum AS DOUBLE

    n = MAXQUEUESIZE
    sum = 0.0
    FOR i = 0 TO n
        sum += doubleQueue.queueArray(i) ^ 2
    NEXT i

    FUNCTION =  sum
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
