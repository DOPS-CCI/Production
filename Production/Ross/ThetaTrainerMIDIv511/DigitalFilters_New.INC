
FUNCTION EMGBandpassFilter(nextValue AS DOUBLE) AS DOUBLE
    LOCAL gain AS DOUBLE
    DIM gEMGxv(0 TO 8) AS STATIC DOUBLE
    DIM gEMGyv(0 TO 8) AS STATIC DOUBLE
    'It's C, here's the EMG bandpass for frontal chan:
    gain = 8.241079214 * 10^4



    gEMGxv(0) = gEMGxv(1): gEMGxv(1) = gEMGxv(2): _
    gEMGxv(2) = gEMGxv(3): gEMGxv(3) = gEMGxv(4): _
    gEMGxv(4) = gEMGxv(5): gEMGxv(5) = gEMGxv(6): _
    gEMGxv(6) = gEMGxv(7): gEMGxv(7) = gEMGxv(8)

    gEMGxv(8) = nextValue / gain

    gEMGyv(0) = gEMGyv(1): gEMGyv(1) = gEMGyv(2): _
    gEMGyv(2) = gEMGyv(3): gEMGyv(3) = gEMGyv(4): _
    gEMGyv(4) = gEMGyv(5): gEMGyv(5) = gEMGyv(6): _
    gEMGyv(6) = gEMGyv(7): gEMGyv(7) = gEMGyv(8)
    gEMGyv(8) =   (gEMGxv(0) + gEMGxv(8)) - 4 * (gEMGxv(2) + gEMGxv(6)) _
                + 6 * gEMGxv(4) _
                 + ( -0.7254849871 * gEMGyv(0)) + (  2.0374554215 * gEMGyv(1)) _
                 + ( -5.2814110553 * gEMGyv(2)) + (  7.6150106890 * gEMGyv(3)) _
                 + ( -9.9131689306 * gEMGyv(4)) + (  8.2508914377 * gEMGyv(5)) _
                 + ( -6.2001843495 * gEMGyv(6)) + (  2.5919959335 * gEMGyv(7))
    '#DEBUG PRINT "gEMGxv(8): " + STR$(gEMGxv(8))
    '#DEBUG PRINT "gEMGyv(8): " + STR$(gEMGyv(8))
    FUNCTION = gEMGyv(8)
END FUNCTION




FUNCTION EEGBandpassFilter(nextValue AS DOUBLE) AS DOUBLE
'filtertype  =   Butterworth
'passtype    =   Bandpass
'ripple  =
'order   =   2
'samplerate  =   512
'corner1 =   3.8
'corner2 =   7.6
'#define NZEROS 4
'#define NPOLES 4
'#define GAIN   1.899633613e+03

    LOCAL gain AS DOUBLE
    DIM gEEGxv(0 TO 4) AS STATIC DOUBLE
    DIM gEEGyv(0 TO 4) AS STATIC DOUBLE

    'It's C, here's the EMG bandpass for frontal chan:
    gain =  1.899633613 * 10^3

    gEEGxv(0) = gEEGxv(1) : gEEGxv(1) = gEEGxv(2) : gEEGxv(2) = gEEGxv(3) : gEEGxv(3) = gEEGxv(4)

    gEEGxv(4) = nextValue / GAIN

    gEEGyv(0) = gEEGyv(1) : gEEGyv(1) = gEEGyv(2) : gEEGyv(2) = gEEGyv(3) : gEEGyv(3) = gEEGyv(4)

    gEEGyv(4) =   (gEEGxv(0) + gEEGxv(4)) - 2 * gEEGxv(2) _
                     + ( -0.9361785747 * gEEGyv(0)) + (  3.7981547516 * gEEGyv(1)) _
                     + ( -5.7875145485 * gEEGyv(2)) + (  3.9255200756 * gEEGyv(3))

    FUNCTION = gEEGyv(4)
END FUNCTION


FUNCTION EEGHighpassFilter(nextValue AS DOUBLE) AS DOUBLE
'filtertype  =  Butterworth
'passtype  =  Highpass
'ripple  =
'order  =  4
'samplerate  =  512
'corner1  =  6
'corner2  =
'adzero  =
'logmin  =

    LOCAL gain AS DOUBLE
    DIM gEEGHighxv(0 TO 4) AS STATIC DOUBLE
    DIM gEEGHighyv(0 TO 4) AS STATIC DOUBLE

    'It's C, here's the EMG bandpass for frontal chan:
    gain =  1.101011292 * 10^0


    gEEGHighxv(0) = gEEGHighxv(1): gEEGHighxv(1) = gEEGHighxv(2): gEEGHighxv(2) = gEEGHighxv(3): gEEGHighxv(3) = gEEGHighxv(4)
        gEEGHighxv(4) = nextValue / gain
        gEEGHighyv(0) = gEEGHighyv(1): gEEGHighyv(1) = gEEGHighyv(2): gEEGHighyv(2) = gEEGHighyv(3): gEEGHighyv(3) = gEEGHighyv(4)
        gEEGHighyv(4) =   (gEEGHighxv(0) + gEEGHighxv(4)) - 4 * (gEEGHighxv(1) + gEEGHighxv(3)) + 6 * gEEGHighxv(2) _
                     + ( -0.8249287765 * gEEGHighyv(0)) + (  3.4584200460 * gEEGHighyv(1)) _
                     + ( -5.4411317811 * gEEGHighyv(2)) + (  3.8076137668 * gEEGHighyv(3))

    FUNCTION = gEEGHighyv(4)
END FUNCTION

FUNCTION EEGLowpassFilter(nextValue AS DOUBLE) AS DOUBLE
'filtertype  =  Butterworth
'passtype  =  Lowpass
'ripple  =
'order  =  4
'samplerate  =  512
'corner1  =  8
'corner2  =
'adzero  =
'logmin  =


    LOCAL gain AS DOUBLE
    DIM gEEGLowxv(0 TO 4) AS STATIC DOUBLE
    DIM gEEGLowyv(0 TO 4) AS STATIC DOUBLE

    'It's C, here's the EMG bandpass for frontal chan:
    gain =  1.951902786 * 10^5

    gEEGLowxv(0) = gEEGLowxv(1): gEEGLowxv(1) = gEEGLowxv(2): gEEGLowxv(2) = gEEGLowxv(3): gEEGLowxv(3) = gEEGLowxv(4)
        gEEGLowxv(4) = nextValue / gain
        gEEGLowyv(0) = gEEGLowyv(1): gEEGLowyv(1) = gEEGLowyv(2): gEEGLowyv(2) = gEEGLowyv(3): gEEGLowyv(3) = gEEGLowyv(4)
        gEEGLowyv(4) =   (gEEGLowxv(0) + gEEGLowxv(4)) + 4 * (gEEGLowxv(1) + gEEGLowxv(3)) + 6 * gEEGLowxv(2) _
                     + ( -0.7736282195 * gEEGLowyv(0)) + (  3.2929432847 * gEEGLowyv(1)) _
                     + ( -5.2629037982 * gEEGLowyv(2)) + (  3.7435067617 * gEEGLowyv(3))

    FUNCTION = gEEGLowyv(4)
END FUNCTION

'FUNCTION remapForTrackBar(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
'    LOCAL decFlag AS BYTE
'    LOCAL retVal AS DOUBLE
'    LOCAL dMax2 AS DOUBLE
'
'    IF (dMin1 > 0 AND dMin1 < 1) THEN
'        decFlag = 1
'        dMax2 = (dMax1 / dMin1)
'    ELSE
'        decFlag = 0
'        dMax2 = dMax1 - dMin1
'    END IF
'
'    IF (decFlag = 0) THEN
'        retVal = remapLong(value, dMin1, dMax1, dMin2, dMax2)
'        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
'    ELSE
'        retVal = remapDouble(value, dMin1, dMax1, dMin2, dMax2)
'        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
'    END IF
'
'    FUNCTION = retVal
'
'
'END FUNCTION
'
'FUNCTION remapForTrackBarReverse(value AS DOUBLE, dMin1 AS DOUBLE, dMax1 AS DOUBLE, dMin2 AS DOUBLE) AS DOUBLE
'    LOCAL decFlag AS BYTE
'    LOCAL retVal AS DOUBLE
'    LOCAL dMax2 AS DOUBLE
'
'    IF (dMin1 > 0 AND dMin1 < 1) THEN
'        decFlag = 1
'        dMax2 = (dMax1 / dMin1)
'    ELSE
'        decFlag = 0
'        dMax2 = dMax1 - dMin1
'    END IF
'
'    IF (decFlag = 0) THEN
'        retVal = remapLong(value, dMin2, dMax2, dMin1, dMax1)
'        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
'    ELSE
'        retVal = remapDouble(value, dMin2, dMax2, dMin1, dMax1)
'        '#DEBUG PRINT " value: " + STR$(value, 5) + " " + STR$(retVal, 5)
'    END IF
'
'    FUNCTION = retVal
'
'
'END FUNCTION
'
'
'FUNCTION remapLong(BYVAL x AS LONG, BYVAL oMin AS LONG, BYVAL oMax AS LONG, BYVAL nMin AS LONG, BYVAL nMax AS LONG) AS LONG
'    LOCAL reverseInput, reverseOutput AS BYTE
'    LOCAL oldMin, oldMax, newMin, newMax AS LONG
'    LOCAL portion, result AS DOUBLE
'
'    '#range check
'    IF (oMin = oMax) THEN
'        MSGBOX "Warning: Zero input range"
'        FUNCTION = -99999999
'    END IF
'
'    IF (nMin = nMax) THEN
'        MSGBOX "Warning: Zero output range"
'        FUNCTION = -99999999
'    END IF
'
'    '#check reversed input range
'    reverseInput = 0
'    oldMin = MIN( oMin, oMax )
'    oldMax = MAX( oMin, oMax )
'    IF (oldMin <> oMin) THEN
'        reverseInput = 1
'    END IF
'
'    '#check reversed output range
'    reverseOutput = 0
'    newMin = MIN( nMin, nMax )
'    newMax = MAX( nMin, nMax )
'    IF (newMin <> nMin) THEN
'        reverseOutput = 1
'    END IF
'
'    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
'    IF (reverseInput = 1) THEN
'        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
'    END IF
'
'    result = portion + newMin
'    IF (reverseOutput = 1) THEN
'        result = newMax - portion
'    END IF
'
'    FUNCTION = result
'END FUNCTION
'
'FUNCTION remapDouble(BYVAL x AS DOUBLE, BYVAL oMin AS DOUBLE, BYVAL oMax AS DOUBLE, BYVAL nMin AS DOUBLE, BYVAL nMax AS DOUBLE) AS DOUBLE
'    LOCAL reverseInput, reverseOutput AS BYTE
'    LOCAL oldMin, oldMax, newMin, newMax AS DOUBLE
'    LOCAL portion, result AS DOUBLE
'
'    '#range check
'    IF (oMin = oMax) THEN
'        MSGBOX "Warning: Zero input range"
'        FUNCTION = -99999999
'    END IF
'
'    IF (nMin = nMax) THEN
'        MSGBOX "Warning: Zero output range"
'        FUNCTION = -99999999
'    END IF
'
'    '#check reversed input range
'    reverseInput = 0
'    oldMin = MIN( oMin, oMax )
'    oldMax = MAX( oMin, oMax )
'    IF (oldMin <> oMin) THEN
'        reverseInput = 1
'    END IF
'
'    '#check reversed output range
'    reverseOutput = 0
'    newMin = MIN( nMin, nMax )
'    newMax = MAX( nMin, nMax )
'    IF (newMin <> nMin) THEN
'        reverseOutput = 1
'    END IF
'
'    portion = (x - oldMin) * (newMax - newMin) / (oldMax  -oldMin)
'    IF (reverseInput = 1) THEN
'        portion = (oldMax - x) * (newMax - newMin) / (oldMax - oldMin)
'    END IF
'
'    result = portion + newMin
'    IF (reverseOutput = 1) THEN
'        result = newMax - portion
'    END IF
'
'    FUNCTION = result
'END FUNCTION
