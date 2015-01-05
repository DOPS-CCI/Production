DECLARE FUNCTION malloc     CDECL LIB "msvcrt.dll"  ALIAS "malloc"  (BYVAL sz AS LONG) AS LONG
DECLARE FUNCTION calloc     CDECL LIB "msvcrt.dll"  ALIAS "calloc"  (BYVAL num AS LONG, BYVAL sz AS LONG) AS LONG
DECLARE FUNCTION realloc    CDECL LIB "msvcrt.dll"  ALIAS "realloc" (BYVAL pmem AS LONG, BYVAL sz AS LONG) AS LONG
DECLARE SUB      FREE       CDECL LIB "msvcrt.dll"  ALIAS "free"    (BYVAL pmem AS LONG)

'/* This approach adds one bit to end and start pointers */

'/* Circular buffer object */
TYPE CircularBuffer
    nbrOfElements AS INTEGER        '/* maximum number of elements           */
    startElement AS INTEGER         '/* index of oldest element              */
    endElement AS INTEGER           '/* index at which to write new element  */
    start_msb AS INTEGER
    end_msb AS INTEGER
    elems AS DOUBLE PTR             '/* vector of elements                   */
END TYPE

SUB cbInit(BYVAL cb AS CircularBuffer PTR, nbrOfElements AS INTEGER)
    LOCAL temp AS DOUBLE

    @cb.nbrOfElements  = nbrOfElements
    @cb.startElement = 0
    @cb.endElement   = 0
    @cb.start_msb = 0
    @cb.end_msb = 0
    @cb.elems = calloc(@cb.nbrOfElements, SIZEOF(temp))
END SUB

FUNCTION cbIsFull(BYVAL cb AS CircularBuffer PTR) AS INTEGER

    FUNCTION =  @cb.endElement = @cb.startElement AND @cb.end_msb <> @cb.start_msb
END FUNCTION

FUNCTION cbIsEmpty(BYREF cb AS CircularBuffer) AS INTEGER
    FUNCTION = cb.endElement = cb.startElement AND cb.end_msb = cb.start_msb
END FUNCTION

SUB cbIncr(BYVAL cb AS CircularBuffer PTR, BYREF p AS INTEGER, BYVAL msb AS INTEGER PTR)

    INCR p
    IF (p = @cb.nbrOfElements) THEN
        @msb = @msb XOR 1
        p = 0
    END IF
END SUB

SUB cbWrite(BYVAL cb AS CircularBuffer PTR, BYVAL elem AS DOUBLE PTR)
    @cb.@elems[@cb.endElement] = elem
    IF (cbIsFull(cb)) THEN       '     /* full, overwrite moves start pointer */
        cbIncr(cb, @cb.startElement, @cb.start_msb)
    END IF
    cbIncr(cb, @cb.endElement, @cb.end_msb)
END SUB

SUB cbRead(BYVAL cb AS CircularBuffer PTR, BYVAL elem AS DOUBLE PTR)
    elem = @cb.@elems[@cb.startElement]
    cbIncr(cb, @cb.startElement, @cb.start_msb)
END SUB
