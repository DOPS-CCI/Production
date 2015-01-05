#COMPILE EXE
#DIM ALL

#INCLUDE "FFTClass.inc"
FUNCTION PBMAIN () AS LONG
    LOCAL x AS LONG
    LOCAL pvr AS DOUBLE POINTER
    LOCAL pvi AS DOUBLE POINTER
    DIM vr(1 TO 16) AS DOUBLE
    DIM vi(1 TO 16) AS DOUBLE
    DIM dataArray(1 TO 16) AS DOUBLE

    DIM fftObj AS FFTInterface
    LET fftObj = CLASS "FFTClass"

    'EEGFilters.genstab(3)

    FOR x = 1 TO 16
        vr(x) = 0
    NEXT x

    vr(2) = 1.0




    pvr = VARPTR(vr(1))


    fftObj.four1(pvr, 8, -1)


    REDIM dataArray(1 TO 16) AS DOUBLE AT pvr

    FOR x = 1 TO 16 STEP 2
        #DEBUG PRINT "Real (" + STR$(x) + "): " + STR$(dataArray(x))
        #DEBUG PRINT "Imag (" + STR$(x + 1) + "): " + STR$(dataArray(x + 1))
    NEXT x

    REDIM vr(0 TO 7)
    REDIM vi(0 TO 7)


    FOR x = 0 TO 7
        vr(x) = 0
    NEXT x

    FOR x = 0 TO 7
        vi(x) = 0
    NEXT x


    vr(0) = 1.0




    pvr = VARPTR(vr(0))
    pvi = VARPTR(vi(0))



    fftObj.genstab(3)
    fftObj.fft(-1, pvr, pvi, 3)



    FOR x = 0 TO 7
        #DEBUG PRINT "Real (" + STR$(x) + "): " + STR$(vr(x))
        #DEBUG PRINT "Imag (" + STR$(x) + "): " + STR$(vi(x))
    NEXT x

END FUNCTION
