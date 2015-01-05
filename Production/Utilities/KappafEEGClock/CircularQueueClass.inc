
CLASS MyCircularQueue

    INSTANCE front, rear, maxSize AS LONG
    INSTANCE arr() AS DOUBLE

    CLASS METHOD CREATE()
        ' Do initialization
        front = -1
        rear = -1
    END METHOD




 INTERFACE MyCircularQueueInterface

   INHERIT IUNKNOWN

        METHOD initializeQueue(siz AS LONG)
        ' Do initialization
        front = -1
        rear = -1
        maxSize = siz
        REDIM arr(0 TO siz)
    END METHOD


     METHOD Enqueue(value AS DOUBLE)
        IF ((front = 0 AND rear = maxSize - 1) OR (rear + 1 = front)) THEN
              MSGBOX "Circular Queue is Full "
        ELSE
            IF (rear = maxSize - 1) THEN
                rear = 0
            ELSE
                INCR rear
            END IF
            arr(rear) = value

             IF (front = -1) THEN
                front = 0
             END IF
        END IF
   END METHOD

    METHOD Dequeue() AS DOUBLE
        LOCAL k AS LONG

        IF (front = -1) THEN
            MSGBOX "Circular Queue is Empty"
        ELSE
            k = arr(front)
            IF (front = rear) THEN
               front = -1
               rear = -1
            ELSE
               IF (front = maxSize - 1) THEN
                  front = 0
               ELSE
                  INCR front
               END IF
            END IF
         END IF
         METHOD = k
    END METHOD

    METHOD displayQueue()
        LOCAL i AS LONG
        IF(front = -1) THEN
             MSGBOX "Circular Queue is Empty"
        ELSE
             IF(rear < front) THEN
                FOR i = front TO maxSize - 1
                   #DEBUG PRINT STR$(arr(i))
                NEXT i
                FOR i = 0 TO rear
                   #DEBUG PRINT STR$(arr(i))
                NEXT i
             ELSE
                FOR i = front TO rear
                   #DEBUG PRINT STR$(arr(i))
                NEXT i
             END IF
        END IF
    END METHOD

    METHOD displayFrontAndRear(fileHnd AS LONG)
        #DEBUG PRINT "displayFrontAndRear():front: " + STR$(front)
        #DEBUG PRINT "displayFrontAndRear():rear: " + STR$(rear)
    END METHOD

    METHOD mean() AS DOUBLE
        LOCAL i, n AS LONG
        LOCAL sum AS DOUBLE

        n = maxSize
        sum = 0.0
        FOR i = 0 TO n - 1
            sum += arr(i)
        NEXT i

        METHOD =  sum / n
    END METHOD

    METHOD rms() AS DOUBLE
        LOCAL i, n AS LONG
        LOCAL sum AS DOUBLE

        n = maxSize
        sum = 0.0
        FOR i = 0 TO n - 1
            sum += arr(i) * arr(i)
        NEXT i

        METHOD =  SQR(sum / n)
    END METHOD



 END INTERFACE

END CLASS
