#COMPILE EXE
#DIM ALL

#INCLUDE "AraneusAlea.inc"

FUNCTION PBMAIN () AS LONG
    LOCAL arraySize AS DWORD
    LOCAL rndNbr AS BYTE
    LOCAL varArray AS VARIANT PTR
    DIM MyArray( 0 TO 50 ) AS BYTE

    initiateAleaRNG()

    arraySize = 50

    OBJECT CALL oAleaRNG.GetRandomBytes(arraySize, varArray)

    OBJECT CALL oAleaRNG.Close
END FUNCTION
