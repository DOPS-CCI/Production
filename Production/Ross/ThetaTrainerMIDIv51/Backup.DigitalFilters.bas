
' Digital filter designed by mkfilter/mkshape/gencode   A.J. Fisher
'   Command line: /www/usr/fisher/helpers/mkfilter -Bu -Bp -o 4 -a 2.0507812500e-01 2.2460937500e-01 -l
GLOBAL gGAIN AS DOUBLE
%NZEROS = 8
%NPOLES = 8

SUB initializeFilterInfo()
    STATIC xv(), yv() AS DOUBLE
    LOCAL x AS LONG


    REDIM xv(%NZEROS + 1)
    REDIM yv(%NPOLES + 1)

    FOR x = 0 TO %NZEROS
        xv(x) = 0.0
    NEXT x

    FOR x = 0 TO %NPOLES
        yv(x) = 0.0
    NEXT x
END SUB

FUNCTION EMGBypassFilter(nextValue AS DOUBLE) AS DOUBLE
    STATIC xv(), yv() AS DOUBLE
    'It's C, here's the EMG bandpass for frontal chan:
    gGAIN = 8.241079214
    xv(0) = xv(1): xv(1) = xv(2): xv(2) = xv(3): xv(3) = xv(4): xv(4) = xv(5): xv(5) = xv(6): xv(6) = xv(7): xv(7) = xv(8)
    xv(8) = nextValue / gGAIN
    yv(0) = yv(1): yv(1) = yv(2): yv(2) = yv(3): yv(3) = yv(4): yv(4) = yv(5): yv(5) = yv(6): yv(6) = yv(7): yv(7) = yv(8)
    yv(8) =   (xv(0) + xv(8)) - 4 * (xv(2) + xv(6)) + 6 * xv(4) _
                 + ( -0.7254849871 * yv(0)) + (  1.3250889129 * yv(1)) _
                 + ( -4.0425977630 * yv(2)) + (  4.5750096358 * yv(3)) _
                 + ( -7.0861250730 * yv(4)) + (  4.9569928446 * yv(5)) _
                 + ( -4.7456371100 * yv(6)) + (  1.6857424402 * yv(7)) _
    FUNCTION = yv(8)
END FUNCTION

FUNCTION BandpassFilter(nextValue AS DOUBLE) AS DOUBLE
    STATIC xv(), yv() AS DOUBLE
    'it's a 1 to 15 Hz bandpass.
    gGAIN = 2.275263442
    xv(0) = xv(1): xv(1) = xv(2): xv(2) = xv(3): xv(3) = xv(4): xv(4) = xv(5): xv(5) = xv(6): xv(6) = xv(7): xv(7) = xv(8)
    xv(8) = nextValue / gGAIN
    yv(0) = yv(1): yv(1) = yv(2): yv(2) = yv(3): yv(3) = yv(4): yv(4) = yv(5): yv(5) = yv(6): yv(6) = yv(7): yv(7) = yv(8)
    yv(8) =   (xv(0) + xv(8)) - 4 * (xv(2) + xv(6)) + 6 * xv(4) _
                 + ( -0.6378838221 * yv(0)) + (  5.3831788088 * yv(1)) _
                 + (-19.8914814910 * yv(2)) + ( 42.0346094510 * yv(3)) _
                 + (-55.5612365280 * yv(4)) + ( 47.0387454730 * yv(5)) _
                 + (-24.9086978080 * yv(6)) + (  7.5427659157 * yv(7))
    FUNCTION = yv(8)
END FUNCTION

FUNCTION PBMAIN()

END FUNCTION
