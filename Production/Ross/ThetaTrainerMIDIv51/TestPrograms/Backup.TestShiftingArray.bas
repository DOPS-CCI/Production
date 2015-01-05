#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN () AS LONG
LOCAL i AS INTEGER
DIM myarray(0 TO 5) AS INTEGER

ARRAY ASSIGN myarray() = 1, 3, 5, 7, 9

CALL shiftright( myarray(), 5)

FOR i = 0 TO 4
    #DEBUG PRINT STR$(myarray(i))
NEXT i

#DEBUG PRINT "===================="

CALL shiftright( myarray(), 4)

FOR i = 0 TO 4
    #DEBUG PRINT STR$(myarray(i))
NEXT i


END FUNCTION

SUB shiftright (myarray() AS INTEGER, sze AS INTEGER)
LOCAL i, temp AS INTEGER
LOCAL temp1 AS INTEGER

FOR i = 0 TO sze -1
    temp =  myarray(sze-1)
    myarray(sze-1) = myarray(i)
    myarray(i) = temp
NEXT i
END SUB
