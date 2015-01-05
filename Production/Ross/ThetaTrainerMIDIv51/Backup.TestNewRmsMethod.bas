#COMPILE EXE
#DIM ALL

#INCLUDE "MovingRMSClass.inc"

FUNCTION PBMAIN () AS LONG
    LOCAL x, rndNbr AS LONG
    LOCAL rms AS DOUBLE
    DIM myRMS AS MovingRMSInterface

    LET myRMS = CLASS "MovingRMSClass"
    FOR x = 1 TO 2^16
        rndNbr = RND(1,1000)

        'rmsMovingWindow(sample, sampleRate, initialSampleWindow, movingSampleWindow)
        rms = myRMS.rmsMovingWindow(rndNbr * 1.0, 512, 2, .25)
        #DEBUG PRINT "RMS: " + STR$(rms)
    NEXT x


END FUNCTION
