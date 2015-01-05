
CLASS MyFilters


    CLASS METHOD CREATE()
        ' Do initialization
    END METHOD




    INTERFACE MyFiltersInterface

        INHERIT IUNKNOWN

        METHOD BandpassFilter8Pole(nextValue AS DOUBLE) AS DOUBLE
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
            METHOD = gEMGyv(8)
        END METHOD

        METHOD BandpassFilter4Pole(nextValue AS DOUBLE) AS DOUBLE
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

            METHOD = gEEGyv(4)
        END METHOD

        METHOD HighpassFilter(nextValue AS DOUBLE) AS DOUBLE
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

            METHOD = gEEGHighyv(4)
        END METHOD


        '======================================================================
        'added per Ross Dunseath on 4/24/2014 single pole highpass filter
        '======================================================================
        METHOD HighpassFilter1Pole(nextValue AS DOUBLE) AS DOUBLE

        LOCAL gain AS DOUBLE
        DIM gEEGHighxv(0 TO 1) AS STATIC DOUBLE
        DIM gEEGHighyv(0 TO 1) AS STATIC DOUBLE

            'It's C, here's the EMG bandpass for frontal chan:
            gain = 1.001533982 * 10^0

            gEEGHighxv(0) = gEEGHighxv(1)
            gEEGHighxv(1) = nextValue / gain
            gEEGHighyv(0) = gEEGHighyv(1)
            gEEGHighyv(1) =   (gEEGHighxv(1) - gEEGHighxv(0)) + (  0.9969367350 * gEEGHighyv(0))

             METHOD = gEEGHighyv(1)
        END METHOD

        METHOD LowpassFilter(nextValue AS DOUBLE) AS DOUBLE
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

            METHOD = gEEGLowyv(4)
        END METHOD

        METHOD LowpassFilter12(nextValue AS DOUBLE) AS DOUBLE
        'added 06/10/2014 - per Ross Dunseath
        'filtertype  =  Butterworth
        'passtype  =  Lowpass
        'ripple  =
        'order  =  4
        'samplerate  =  512
        'corner1  =  12
        'corner2  =
        'adzero  =
        'logmin  =


        LOCAL gain AS DOUBLE
        DIM gEEGLowxv(0 TO 4) AS STATIC DOUBLE
        DIM gEEGLowyv(0 TO 4) AS STATIC DOUBLE

            'It's C, here's the EMG bandpass for frontal chan:
            gain =   4.095076992 * 10^4


            gEEGLowxv(0) = gEEGLowxv(1): gEEGLowxv(1) = gEEGLowxv(2): gEEGLowxv(2) = gEEGLowxv(3): gEEGLowxv(3) = gEEGLowxv(4)
            gEEGLowxv(4) = nextValue / gain
            gEEGLowyv(0) = gEEGLowyv(1): gEEGLowyv(1) = gEEGLowyv(2): gEEGLowyv(2) = gEEGLowyv(3): gEEGLowyv(3) = gEEGLowyv(4)
            gEEGLowyv(4) =   (gEEGLowxv(0) + gEEGLowxv(4)) + 4 * (gEEGLowxv(1) + gEEGLowxv(3)) + 6 * gEEGLowxv(2) _
                         + ( -0.6802990418 * gEEGLowyv(0)) + (  2.9828713459 * gEEGLowyv(1)) _
                         + ( -4.9183157191 * gEEGLowyv(2)) + (  3.6153527020 * gEEGLowyv(3))
            METHOD = gEEGLowyv(4)
        END METHOD


    END INTERFACE

END CLASS
