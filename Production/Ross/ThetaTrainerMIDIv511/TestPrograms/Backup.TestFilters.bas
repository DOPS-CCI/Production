#COMPILE EXE
#DIM ALL

#INCLUDE "DoubleQueueUsingArray_Local.inc"
'#INCLUDE "DOPS_TCPIP_Local.inc"
#INCLUDE "CircularQueueClass.inc"
#INCLUDE "DigitalFilters_NEW.inc"
'#INCLUDE "FilterClass.inc"
'double sampleBuffer(): a reference of the buffer to be populated.
'int numFrames: the number of samples in sampleBuffer().
'double sampleRate: the device’s current sampleRate – usually 44100.0
'double frequency: the desired output frequency in Hz.

%M_PI  = 314            'M_PI is a pi macro used by many compilers

%SHRT_MAX = 1600000 '65536       'max value of a short integer

GLOBAL ioData() AS DOUBLE
GLOBAL gEMGRMSTime AS LONG

SUB generateSine(numFrames AS INTEGER, sampleRate AS DOUBLE, frequency AS DOUBLE)
    LOCAL i AS LONG
    LOCAL deltaTheta AS DOUBLE
    LOCAL theta AS DOUBLE

    theta = 0
    deltaTheta = 2 * (%M_PI / 100) * (frequency/sampleRate)

    FOR i = 0 TO numFrames
        'ioData(i) = (0.8 * %SHRT_MAX * SIN(theta))
        ioData(i) = (%SHRT_MAX * SIN(theta))
        theta += deltaTheta
        IF (theta > 2 * (%M_PI / 100)) THEN
            theta = theta - 2 * (%M_PI / 100)
        END IF
    NEXT i
END SUB

FUNCTION PBMAIN () AS LONG
LOCAL sample_rate AS DOUBLE
LOCAL desired_tone AS DOUBLE
LOCAL h, i, inNumberFrames, emgRMSInitialWindowFlag, emgRMSMovingWindowFlag AS INTEGER
LOCAL fEMGConvNbr, filteredNbr, EMGRMSValue AS DOUBLE
'LOCAL EMGRMSQueue, EEGRMSQueue AS doubleQueueInfo
LOCAL gFreq, gVol AS SINGLE
LOCAL sampleCnt, enqueueCnt, dequeueCnt AS LONG
LOCAL sampleTotalOld, sampleTotalNew, tempTotal AS DOUBLE
LOCAL RMSTotalOld, RMSTotalNew AS DOUBLE
DIM EMGRMSQueue AS MyCircularQueueInterface
DIM EEGRMSQueue AS MyCircularQueueInterface
LOCAL fHnd AS LONG


REDIM ioData(0 TO 5120)

inNumberFrames = 5120
'sample_rate = 44100.0
sample_rate = 512.0
'desired_tone = 440.0 'A440
desired_tone = 5.0 'A440

emgRMSInitialWindowFlag = 0
emgRMSMovingWindowFlag = 0
sampleCnt = 0
enqueueCnt = 0
dequeueCnt = 0
gEMGRMSTime = 1

generateSine(inNumberFrames, sample_rate, desired_tone)

'initializeEMGFilterInfo(8, 8)

'initializeEEGFilterInfo(4, 4)

LET EMGRMSQueue = CLASS "MyCircularQueue"
LET EEGRMSQueue = CLASS "MyCircularQueue"

'CALL startDoubleQueue(EMGRMSQueue, 512)

EMGRMSQueue.initializeQueue(513 * gEMGRMSTime)
'EEGRMSQueue.initializeQueue(512 * gEEGRMSTime)
fHnd = 2
'OPEN "F:\ThetaTrainer_debug.txt" FOR OUTPUT AS fHnd

enqueueCnt = 0


FOR h = 1 TO 100
    FOR i = 0 TO inNumberFrames
        INCR sampleCnt
        fEMGConvNbr = ioData(i) * 0.0312
        'fEMGConvNbr = RND(0, 10) '* 0.0312
        #DEBUG PRINT "fEMGConvNbr: " +STR$(fEMGConvNbr)
        filteredNbr = EEGHighpassFilter(fEMGConvNbr)                          'passing the converted sample to the Bandpass filter function
        #DEBUG PRINT "filteredNbr: " + STR$(filteredNbr)
        IF (emgRMSInitialWindowFlag = 0) THEN
            IF (sampleCnt MOD 512 * gEMGRMSTime <> 0) THEN      '10 seconds @ 512/samples per second
                INCR enqueueCnt
                #DEBUG PRINT "enqueue..." + STR$(enqueueCnt)
                EMGRMSQueue.Enqueue(filteredNbr)
            ELSE
                INCR enqueueCnt
                #DEBUG PRINT "enqueue..." + STR$(enqueueCnt)
                EMGRMSQueue.Enqueue(filteredNbr)

                EMGRMSValue = EMGRMSQueue.rms()
                #DEBUG PRINT "EMGRMSValue: " + STR$(EMGRMSValue)

                enqueueCnt = 0
                FOR i = 1 TO 512 * .25
                    #DEBUG PRINT "Dequeue..." + STR$(i)
                    EMGRMSQueue.Dequeue()
                NEXT i
                emgRMSInitialWindowFlag = 1
            END IF
        END IF

        IF (emgRMSInitialWindowFlag = 1) THEN
            IF (emgRMSMovingWindowFlag = 1) THEN
                IF (sampleCnt MOD (512 * .25) <> 0) THEN
                    INCR enqueueCnt
                    #DEBUG PRINT "enqueue..." + STR$(enqueueCnt)
                    EMGRMSQueue.Enqueue(filteredNbr)
                ELSE
                    INCR enqueueCnt
                    #DEBUG PRINT "enqueue..." + STR$(enqueueCnt)
                    EMGRMSQueue.Enqueue(filteredNbr)

                    EMGRMSValue = EMGRMSQueue.rms()
                    #DEBUG PRINT "EMGRMSValue: " + STR$(EMGRMSValue)

                    gFreq = EMGRMSValue

                    enqueueCnt = 0
                    FOR i = 1 TO 512 * .25
                        #DEBUG PRINT "Dequeue..." + STR$(i)
                        EMGRMSQueue.Dequeue()
                    NEXT i
                END IF
            ELSE
                emgRMSMovingWindowFlag = 1
            END IF
        END IF
    NEXT i
NEXT h

CLOSE fHnd


END FUNCTION
