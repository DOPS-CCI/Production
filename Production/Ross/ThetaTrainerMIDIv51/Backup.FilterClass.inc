
CLASS MyFilters


    CLASS METHOD CREATE()
        ' Do initialization
    END METHOD




 INTERFACE MyFiltersInterface

   INHERIT IUNKNOWN

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

 END INTERFACE

END CLASS
