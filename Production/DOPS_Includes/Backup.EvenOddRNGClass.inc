#INCLUDE "win32api.inc"
#INCLUDE "HiddenRNGWindow.inc"

CLASS EvenOddRNGClass
    INSTANCE RNDFile, ARSFile AS STRING
    INSTANCE INIFilename AS ascii * 512
    INSTANCE hRNDFile, hARSFile AS LONG
    INSTANCE SampleDuration AS LONG
    INSTANCE SampleSize AS LONG
    INSTANCE Samples() AS BYTE
    INSTANCE ARSAccumNbrBits AS LONG
    INSTANCE ARSAccumDev AS DOUBLE
    INSTANCE ARSFirstHit AS BYTE
    INSTANCE ARSOldZScore AS DOUBLE
    INSTANCE ARSNewZScore AS DOUBLE
    INSTANCE ARSSavedZScore AS DOUBLE
    INSTANCE RunningDuration AS LONG
    INSTANCE RNGAccumNbrBits AS LONG
    INSTANCE RNGFirstHit AS BYTE
    INSTANCE RNGNewZScore AS DOUBLE
    INSTANCE RNGOldZScore AS DOUBLE
    INSTANCE RNGSavedZScore AS DOUBLE
    INSTANCE RNGAccumDev AS DOUBLE
    INSTANCE oApp AS IDISPATCH
    INSTANCE Condition AS STRING

    CLASS METHOD CREATE()
        LOCAL errTrapped AS LONG

        ' Do initialization
        TRY
            LET oApp = NEWCOM "Araneus.Alea.1"
            OBJECT CALL oApp.Open
        CATCH
            MSGBOX "Error on Opening Alea RNG. Check to see if it is plugged in (and that the drivers are installed.)" + $CRLF + _
                    "Also, there may be a program running using the RNG already."
            errTrapped = ERR
            EXIT TRY
        END TRY

        IF (errTrapped <> 0) THEN
            EXIT METHOD
        END IF
        hRNDFile = 900
        hARSFile = 950
        SampleSize = 50        '25 samp/sec but need 50 because were doing even/odd picks
        REDIM Samples(SampleSize)
        SampleDuration = 1000   ' 1 second
        ARSFirstHit = 1
        ARSNewZScore = 0
        ARSOldZScore = 0
        ARSSavedZScore = 0
        ARSAccumNbrBits = 0
        ARSAccumDev = 0
        RunningDuration = 0

        RNGFirstHit = 1
        RNGNewZScore = 0
        RNGOldZScore = 0
        RNGSavedZScore = 0
        RNGAccumNbrBits = 0
        RNGAccumDev = 0

        Condition = "NONE"
    END METHOD

    CLASS METHOD DESTROY()

       ' Do cleanup
       DIALOG SEND hDlgHiddenRNGWindow, %WM_SYSCOMMAND, %SC_CLOSE, 0
    END METHOD





    INTERFACE EvenOddRNGInterface
        INHERIT IUNKNOWN

        METHOD SetSampleSize(sampSize AS LONG)
            SampleSize = sampSize
            REDIM Samples(SampleSize)
        END METHOD

        METHOD SetDuration(dur AS LONG)
            SampleDuration = dur
        END METHOD

        METHOD SetCondition(cond AS STRING)
            Condition = cond
        END METHOD

        METHOD GetDuration() AS LONG
            METHOD = SampleDuration
        END METHOD

        METHOD SetINIFilename(filename AS ASCIIZ * 412)
            INIFilename = filename
        END METHOD

        METHOD ResetGetResults()
            ARSFirstHit = 1
            ARSNewZScore = 0
            ARSOldZScore = 0
            ARSSavedZScore = 0
            ARSAccumNbrBits = 0
            ARSAccumDev = 0
            RunningDuration = 0

            RNGFirstHit = 1
            RNGNewZScore = 0
            RNGOldZScore = 0
            RNGSavedZScore = 0
            RNGAccumNbrBits = 0
            RNGAccumDev = 0
            Condition = "NONE"
        END METHOD

        METHOD PrintHeaders()
            LOCAL filename, headerFile AS ASCIIZ * 512
            LOCAL subjDir AS ASCIIZ * 512

            IF (TRIM$(INIFilename) = "") THEN
                MSGBOX ".INI filename was not set."
                EXIT METHOD
            END IF

            filename = EXE.PATH$ + INIFilename
            GetPrivateProfileString("Subject Section", "FileFolder", "", subjDir, 512, filename)

            GetPrivateProfileString("Subject Section", "HeaderFile", "", headerFile, 512, filename)

            RNDFile = subjDir + "\" + LEFT$(headerFile, LEN(headerFile) - 4) + "-RNG.CSV"
            ARSFile = subjDir + "\" + LEFT$(headerFile, LEN(headerFile) - 4)  + "-ANG.CSV"
            OPEN RNDFile FOR APPEND AS hRNDFile
            OPEN ARSFile FOR APPEND AS hARSFile
            PRINT #hRNDFile, "Sample Size " +   STR$((SampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using odd samples
            PRINT #hRNDFile, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"
            PRINT #hARSFile, "Sample Size " +   STR$((SampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using even samples
            PRINT #hARSFile, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"

        END METHOD

        METHOD sumBitsOfByte(sample AS BYTE) AS INTEGER
            LOCAL temp AS STRING
            LOCAL lSample AS LONG

            temp = BIN$(sample)
            lSample = VAL(MID$(temp, 1, 1)) + VAL(MID$(temp, 2, 1)) + VAL(MID$(temp, 3, 1)) + VAL(MID$(temp, 4, 1)) + _
                        VAL(MID$(temp, 5, 1)) + VAL(MID$(temp, 6, 1)) + VAL(MID$(temp, 7, 1)) + VAL(MID$(temp, 8, 1))

            METHOD = lSample
        END METHOD

        METHOD Odd(num AS LONG) AS LONG
            'return 1 if odd
            IF ((num MOD 2) = 0) THEN
                METHOD = 0
            ELSE
                METHOD = 1
            END IF
        END METHOD

        METHOD GetSamples()
            LOCAL rndByte AS VARIANT
            LOCAL bRndByte AS BYTE
            LOCAL x AS LONG

            FOR x = 1 TO SampleSize
                OBJECT CALL oApp.GetRandomByte() TO rndByte
                bRndByte = VARIANT#(rndByte)
                Samples(x) = bRndByte
            NEXT x
        END METHOD

        METHOD GetResults()
            LOCAL lResult, rndJitter, subPtr  AS LONG
            LOCAL x, totalBits, arsTotalBits AS LONG
            LOCAL absAccumDev, sqrAccumNbrBits, zScore AS DOUBLE
            LOCAL absARSAccumDev, sqrARSAccumNbrBits, zARSScore AS DOUBLE
            LOCAL MyTime, MyTimeRNDFile, MyTimeARSFile AS IPOWERTIME
            LOCAL now AS QUAD
            LOCAL tempForFile, arsTempForFile AS STRING
            GLOBAL gTimerTix AS LONG

            ME.GetSamples()

            'accumulating time in seconds
            INCR RunningDuration

            '==================================================
            'Doing the work for the Alternate RNG Stream file.
            '==================================================
            arsTempForFile = ""

            arsTotalBits = 0
            'use odd samples for alternate stream of random number
            FOR x = 1 TO SampleSize
                IF (ME.Odd(x) = 1) THEN
                   '#DEBUG PRINT "Samples(x): " + STR$(Samples(x))
                   arsTotalBits += ME.sumBitsOfByte(Samples(x))
                END IF
            NEXT x

            ARSAccumNbrBits += 200
            '#DEBUG PRINT "gAccumNbrBits: " + STR$(gAccumNbrBits)

            ARSAccumDev += (arsTotalBits - 100)
            '#DEBUG PRINT "gAccumDev: " + STR$(gAccumDev)

            absARSAccumDev = ABS(ARSAccumDev)
            '#DEBUG PRINT "absAccumDev: " + STR$(absAccumDev)

            sqrARSAccumNbrBits = SQR(ARSAccumNbrBits)
            '#DEBUG PRINT "sqrAccumNbrBits: " + STR$(sqrAccumNbrBits)

            zARSScore = absARSAccumDev * 1.0 / SQR((ARSAccumNbrBits * 1.0) / 4.0)
            IF (absARSAccumDev > sqrARSAccumNbrBits) THEN
                '#DEBUG PRINT "zScore: " + STR$(zScore)
                IF (ARSFirstHit = 1) THEN
                    ARSOldZScore = zARSScore
                    ARSFirstHit = 0
                ELSE
                    ARSNewZScore = zARSScore
                END IF
            END IF

            '#DEBUG PRINT "gOldZScore: " + STR$(gOldZScore)
            '#DEBUG PRINT "gNewZScore: " + STR$(gNewZScore)

            IF (ARSNewZScore > ARSOldZScore) THEN
                ARSSavedZScore = ARSNewZScore
                ARSOldZScore = ARSSavedZScore
            END IF

            '#DEBUG PRINT "gSavedZScore: " + STR$(gSavedZScore)
            LET MyTimeARSFile = CLASS "PowerTime"
            MyTimeARSFile.Now()
            MyTimeARSFile.FileTime TO now

            arsTempForFile = TIME$ + "," + STR$(RunningDuration) + ","  + FORMAT$(arsTotalBits, "0000") + "," + FORMAT$(zARSScore, "00.0000") + ","

            arsTempForFile += Condition
'            SELECT CASE globals.Target
'                CASE 1 'REST
'                    arsTempForFile += "REST"
'                CASE 2 'FOCUS
'                    IF (gHighOrLow = 1) THEN 'High
'                        arsTempForFile += "FOCUSHIGH"
'                    ELSE
'                        arsTempForFile += "FOCUSLOW"
'                    END IF
'                CASE ELSE
'                   arsTempForFile += "FOCUS"
'            END SELECT


            IF (ARSFile <> "") THEN
                PRINT #hARSFile, arsTempForFile
            END IF

            '==================================================
            'Doing the work for the RNG Stream file.
            '==================================================


            'gRndCnt = 0
            'INCR gSampleCnt

            tempForFile = ""

            '#DEBUG PRINT STR$(RunningDuration) + " dur " + STR$(gTimerMinutes) + " mins " + STR$(gTimerSeconds) + " secs"

            totalBits = 0
            'use even samples for deviation processing
            FOR x = 1 TO SampleSize
                IF (ME.Odd(x) = 0) THEN
                   '#debug print "Samples(x): " + str$(Samples(x))
                   totalBits += ME.sumBitsOfByte(Samples(x))
                END IF
            NEXT x


            '#DEBUG PRINT "totalBits: " + STR$(totalBits)

            RNGAccumNbrBits += 200
            '#DEBUG PRINT "RNGAccumNbrBits: " + STR$(RNGAccumNbrBits)

            RNGAccumDev += (totalBits - 100)
            '#DEBUG PRINT "RNGAccumDev: " + STR$(RNGAccumDev)

            absAccumDev = ABS(RNGAccumDev)
            '#DEBUG PRINT "absAccumDev: " + STR$(absAccumDev)

            sqrAccumNbrBits = SQR(RNGAccumNbrBits)
            '#DEBUG PRINT "sqrAccumNbrBits: " + STR$(sqrAccumNbrBits)

            zScore = absAccumDev * 1.0 / SQR((RNGAccumNbrBits * 1.0) / 4.0)
            IF (absAccumDev > sqrAccumNbrBits) THEN
                '#DEBUG PRINT "zScore: " + STR$(zScore)
                IF (RNGFirstHit = 1) THEN
                    RNGOldZScore = zScore
                    RNGFirstHit = 0
                ELSE
                    RNGNewZScore = zScore
                END IF
            END IF

            '#DEBUG PRINT "RNGOldZScore: " + STR$(RNGOldZScore)
            '#DEBUG PRINT "RNGNewZScore: " + STR$(RNGNewZScore)

            IF (RNGNewZScore > RNGOldZScore) THEN
                RNGSavedZScore = RNGNewZScore
                RNGOldZScore = RNGSavedZScore
            END IF

            '#DEBUG PRINT "RNGSavedZScore: " + STR$(RNGSavedZScore)
            LET MyTimeRNDFile = CLASS "PowerTime"
            MyTimeRNDFile.Now()
            MyTimeRNDFile.FileTime TO now

            tempForFile = TIME$ + "," + STR$(RunningDuration) + "," + FORMAT$(totalBits, "0000") + "," + FORMAT$(zScore, "00.0000") + ","

            tempForFile += Condition

'            SELECT CASE globals.Target
'                CASE 1 'REST
'                    tempForFile += "REST"
'                CASE 2 'FOCUS
'                    IF (gHighOrLow = 1) THEN 'High
'                        tempForFile += "FOCUSHIGH"
'                    ELSE
'                        tempForFile += "FOCUSLOW"
'                    END IF
'                CASE ELSE
'                    tempForFile += "FOCUS"
'            END SELECT

            IF (RNDFile <> "") THEN
                PRINT #hRNDFile, tempForFile
            END IF
        END METHOD

        METHOD StartHiddenRNGWindow()
            ShowDIALOGEvenOddRNG %HWND_DESKTOP
        END METHOD

    END INTERFACE

END CLASS
