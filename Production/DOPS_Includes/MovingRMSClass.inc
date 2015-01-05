#INCLUDE "win32api.inc"


CLASS MovingRMSClass
    INSTANCE SampleRate AS WORD
    INSTANCE InitialSampleWindowSize AS WORD
    INSTANCE MovingSampleWindowSize AS SINGLE
    INSTANCE tempArray() AS DOUBLE
    INSTANCE SampleArray() AS DOUBLE


    CLASS METHOD CREATE()
    END METHOD

    CLASS METHOD DESTROY()
    END METHOD





    INTERFACE MovingRMSInterface
        INHERIT IUNKNOWN

        METHOD SetSampleRate (sr AS WORD)
            SampleRate = sr
        END METHOD

        METHOD SetInitialSampleWindowSize(isws AS LONG)
            InitialSampleWindowSize = isws
            REDIM SampleArray(SampleRate * InitialSampleWindowSize)
            REDIM TempArray(SampleRate * InitialSampleWindowSize)
        END METHOD

        METHOD SetMovingSampleWindowSize(msws AS SINGLE)
            MovingSampleWindowSize = msws
        END METHOD

        METHOD rmsMovingWindow(sample AS DOUBLE) AS DOUBLE
            STATIC x, cnt, sampleCnt, dropOff AS LONG
            STATIC firstTimeThruFlag AS BYTE
            LOCAL total AS DWORD
            LOCAL rms AS DOUBLE




            INCR sampleCnt
            #DEBUG PRINT "sampleCnt: " + STR$(sampleCnt) + ", sample: " + STR$(sample)


            IF (firstTimeThruFlag = 0) THEN
                sampleArray(sampleCnt) = sample
                IF (sampleCnt = (SampleRate * InitialSampleWindowSize)) THEN
                    total = 0
                    FOR x = 1 TO sampleCnt
                        total = total + (sampleArray(x) * sampleArray(x))
                        #DEBUG PRINT "sampleArray(" + STR$(x) + ") " + STR$(sampleArray(x)) + " total: " + STR$(total)
                    NEXT x

                    #DEBUG PRINT "total: " + STR$(total)

                    rms = SQR(total / sampleCnt)

                    #DEBUG PRINT "rms: " + STR$(rms)

                    firstTimeThruFlag = 1
                    sampleCnt = 0
                    METHOD = rms
                    EXIT METHOD
                END IF
            ELSE
                dropOff = SampleRate * MovingSampleWindowSize
                IF (sampleCnt <= dropOff) THEN
                    tempArray(sampleCnt) = sample
                END IF
                IF (sampleCnt = dropOff) THEN
                    FOR x = dropOff + 1 TO SampleRate * InitialSampleWindowSize
                        tempArray(x) = SampleArray(x - dropOff)
                    NEXT x
                    total = 0
                    FOR x = 1 TO SampleRate * InitialSampleWindowSize
                       sampleArray(x) = tempArray(x)
                       total = total + (sampleArray(x) * sampleArray(x))
                       #DEBUG PRINT "sampleArray(" + STR$(x) + ") " + STR$(sampleArray(x)) + " total: " + STR$(total)
                    NEXT x

                    #DEBUG PRINT "total: " + STR$(total)

                    rms = SQR(total / sampleCnt)

                    #DEBUG PRINT "rms: " + STR$(rms)

                    sampleCnt = 0
                    METHOD = rms
                    EXIT METHOD
                END IF
            END IF

        END METHOD

    END INTERFACE

END CLASS
