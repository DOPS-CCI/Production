#COMPILE EXE
#DIM ALL
#INCLUDE "DigitalFilters_New.inc"
#INCLUDE "CircularQueueClass.inc"
'#INCLUDE "DoubleQueueUsingArrayEMG_Local.inc"
'#include "CircularQueue.inc"

FUNCTION PBMAIN () AS LONG
LOCAL x AS LONG
LOCAL n AS DOUBLE
DIM queue AS MyCircularQueueInterface

LET queue = CLASS "MyCircularQueue"

#DEBUG PRINT "queue.initializeQueue..."
queue.initializeQueue(10)

#DEBUG PRINT "queue.insertQueue"
FOR x = 1 TO 10
    queue.dequeue()
NEXT x

queue.displayQueue()

#DEBUG PRINT "queue.deleteQueue"
queue.dequeue()

queue.displayQueue()

#DEBUG PRINT "queue.insertQueue 11"
queue.enqueue(11.0)

queue.displayQueue()

#DEBUG PRINT "queue.deleteQueue"
queue.dequeue()

queue.displayQueue()

#DEBUG PRINT "queue.insertQueue 12"
queue.enqueue(12.0)

queue.displayQueue()

#DEBUG PRINT "queue.deleteQueue"
queue.dequeue()

queue.displayQueue()

#DEBUG PRINT "queue.insertQueue 13"
queue.enqueue(13.0)

queue.displayQueue()





'local queue as CircularBuffer
'LOCAL testQueue AS EMGDoubleQueueInfo

'EMG_startDoubleQueue(testQueue, 10)
'
'#DEBUG PRINT "enqueue..."
'for x = 1 to 10
'    EMG_doubleEnqueue(testQueue, x * 1.0)
'    #DEBUG PRINT "enqueue: " + str$(x)
'next x
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'FOR x = 1 TO 5
'    n = EMG_doubleDequeue(testQueue)
'    #debug print "dequeue n: " + str$(n)
'next x
'
'x = EMG_getDoubleQueueCount(testQueue)
'
'#debug print "getDoubleQueueCount: " + str$(x)
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'EMG_doubleEnqueue(testQueue, 11.0)
'#DEBUG PRINT "enqueue: " + STR$(11)
'EMG_doubleEnqueue(testQueue, 12.0)
'#DEBUG PRINT "enqueue: " + STR$(12)
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'x = EMG_getDoubleQueueCount(testQueue)
'#DEBUG PRINT "getDoubleQueueCount: " + STR$(x)
'
'FOR x = 1 TO 5
'    n = EMG_doubleDequeue(testQueue)
'    #DEBUG PRINT "dequeue n: " + STR$(n)
'NEXT x
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'x = EMG_getDoubleQueueCount(testQueue)
'#DEBUG PRINT "getDoubleQueueCount: " + STR$(x)
'
'
'EMG_doubleEnqueue(testQueue, 13.0)
'#DEBUG PRINT "enqueue: " + STR$(13)
'EMG_doubleEnqueue(testQueue, 14.0)
'#DEBUG PRINT "enqueue: " + STR$(14)
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'x = EMG_getDoubleQueueCount(testQueue)
'#DEBUG PRINT "getDoubleQueueCount: " + STR$(x)
'
'FOR x = 1 TO 8
'    n = EMG_doubleDequeue(testQueue)
'    #DEBUG PRINT "dequeue n: " + STR$(n)
'NEXT x
'
'EMG_debugDisplayDoubleQueue(testQueue)
'
'x = EMG_getDoubleQueueCount(testQueue)
'#DEBUG PRINT "getDoubleQueueCount: " + STR$(x)
'
'cbInit(varptr(queue), 10)
'
'for x = 1 to 10
'    cbWrite(VARPTR(queue), x * 1.0)
'next x
'
'FOR x = 1 TO 5
'    cbRead(VARPTR(queue), n)
'    #debug print "cbRead: " + str$(n)
'next x
'
'cbWrite(VARPTR(queue), 11.0)
'cbWrite(VARPTR(queue), 12.0)
'
'for x = 1 to 10
'    cbRead(VARPTR(queue), n)
'    #DEBUG PRINT "loop: " + STR$(n)
'next x






END FUNCTION

FUNCTION test() AS LONG
    DIM arr(0 TO 10) AS STATIC LONG

    arr(0) = RND(1, 10)
    arr(1) = arr(0)

    FUNCTION = arr(0)
END FUNCTION
