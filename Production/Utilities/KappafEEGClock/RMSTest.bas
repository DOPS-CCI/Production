#COMPILE EXE
#DIM ALL

'number of channels
%NBRCHANNELS = 8
%NBRSAMPLES = 9000
%SIZE1 = 80

'RMS buffer & pointers
GLOBAL gIntSamples() AS LONG
GLOBAL gIntPtrSamples AS LONG PTR
GLOBAL gTopOfStack AS INTEGER PTR

GLOBAL gChannelNbr, gSampleCnt AS LONG

GLOBAL cosine() AS INTEGER

FUNCTION PBMAIN () AS LONG
    LOCAL v, x  AS LONG

    REDIM gIntSamples(0 TO %NBRCHANNELS * %NBRSAMPLES)

    FOR v = 1 TO 5
        FOR x = 0 TO %NBRCHANNELS * %NBRSAMPLES
            gIntSamples(x) = (v * x) + 1
        NEXT x

        CALL myRoutine()
    NEXT v

END FUNCTION

SUB myRoutine()
    LOCAL idec AS INTEGER
    LOCAL rRms() AS DOUBLE
    LOCAL rRtm() AS DOUBLE
    LOCAL sumSamplesForChannel, totalSqForChannel, average, dsqr, temp, accSquares AS DOUBLE

    REDIM rRms(%NBRCHANNELS)
    REDIM rRtm(%NBRCHANNELS)

    gIntPtrSamples = VARPTR(gIntSamples(0))
    gTopOfStack = VARPTR(gIntSamples(0)) + %NBRCHANNELS * %NBRSAMPLES

    'at the decimation points
    idec = %NBRSAMPLES MOD 20
    'IF (idec <> 0) THEN
        'IF (gIntPtrSamples >= gTopOfStack) THEN 'buffer full calc new rms value
            'isp = 0     ' string index for serial feed
            accSquares = 0
            FOR gChannelNbr = 0 TO %NBRCHANNELS
                'start with first sample
                gSampleCnt = 0

                'point to first sample for this channel
                gIntPtrSamples = VARPTR(gIntSamples(gChannelNbr))

                'zero accumulators for sum of squares and for average
                sumSamplesForChannel = 0
                totalSqForChannel = 0
                average = 0
                dsqr = 0
                temp = 0.0

                'will do for every sample
                WHILE (gSampleCnt < %NBRSAMPLES)
                    INCR gSampleCnt
                    temp = @gIntPtrSamples
                    sumSamplesForChannel += temp
                    totalSqForChannel += temp * temp
                    @gIntPtrSamples += %NBRCHANNELS
                WEND 'end while

                'MSGBOX "Sum: " + STR$(sumSamplesForChannel)
                average = sumSamplesForChannel /  %NBRSAMPLES
                'msgbox "AVG: " + str$(average)

                dsqr = totalSqForChannel/%NBRSAMPLES - average * average

                IF (dsqr < 0.0) THEN
                    dsqr = 0.0
                END IF

                accSquares += dsqr

                'range 0 to 1000
'                rRms(gChannelNbr) = SQR(dsqr)/327.68
'                msgbox "RMS: " + str$(rRms(gChannelNbr))
'
'                'rt meter feed, offset for 0 on meter
'                rRtm(gChannelNbr) = rRms(gChannelNbr) '- 6.0
            NEXT gChannelNbr

            'range 0 to 1000
             rRms(gChannelNbr) = SQR(accSquares)/327.68
             MSGBOX "RMS: " + STR$(rRms(gChannelNbr))

            'reset pointer
            gIntPtrSamples = VARPTR(gIntSamples(0))
        'END IF
'END IF
END SUB
