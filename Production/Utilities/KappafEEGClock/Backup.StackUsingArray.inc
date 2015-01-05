TYPE stackElementT
    myLong AS LONG
END TYPE

TYPE stackT
  contents AS stackElementT PTR
  maxSize AS LONG
  top AS LONG
END TYPE

SUB StackInit(BYVAL stackP AS stackT PTR, maxSize AS LONG)
  LOCAL newContents AS stackElementT PTR

  '/* Allocate a new array to hold the contents. */

  newContents = malloc(SIZEOF(stackElementT) * maxSize)

  IF (newContents = 0) THEN
    MSGBOX "Insufficient memory to initialize stack."
    EXIT SUB  '/* Exit, returning error code. */
  END IF

  @stackP.contents = newContents
  @stackP.maxSize = maxSize
  @stackP.top = -1  '/* I.e., empty */
END SUB

SUB StackDestroy(BYVAL stackP AS stackT PTR)
  '/* Get rid of array. */
  FREE(@stackP.contents)

  @stackP.contents = 0
  @stackP.maxSize = 0
  @stackP.top = -1  '/* I.e., empty */
END SUB

SUB StackPush(BYVAL stackP AS stackT PTR, element AS stackElementT)
  IF (StackIsFull(stackP)) THEN
    MSGBOX "Can't push element on stack: stack is full."
    EXIT SUB  '/* Exit, returning error code. */
  END IF

  '/* Put information in array; update top. */
  INCR @stackP.top
  @stackP.contents = element
END SUB

FUNCTION StackPop(BYVAL stackP AS stackT PTR) AS STRING
  IF (StackIsEmpty(stackP)) THEN
    MSGBOX "Can't pop element from stack: stack is empty."
    EXIT FUNCTION  '/* Exit, returning error code. */
  END IF
  DECR @stackP.top
  FUNCTION = @stackP
END FUNCTION

FUNCTION StackIsEmpty(BYVAL stackP AS stackT PTR) AS LONG

  FUNCTION = @stackP.top < 0
END FUNCTION

FUNCTION StackIsFull(BYVAL stackP AS stackT PTR) AS LONG

  FUNCTION = @stackP.top >= @stackP.maxSize - 1
END FUNCTION
