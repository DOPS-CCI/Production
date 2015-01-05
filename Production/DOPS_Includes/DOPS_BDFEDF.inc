UNION DataSample
    sampleBytes(1 TO 3) AS BYTE
    sample AS LONG
END UNION

TYPE ChannelData
    ds AS DataSample
END TYPE




CLASS BDFEDFHeader                                       'BDF                                        EDF
    INSTANCE IDCode_1 AS ASCIIZ * 2                      'Byte 1: "255" (non ascii)                  Byte 1: "0" (ASCII)
    INSTANCE IDCode_2 AS ASCIIZ * 8                      'Bytes 2-8: "BIOSEMI"                       Bytes 2-8: " " (ASCII)
    INSTANCE LocalSubjectId AS ASCIIZ * 81               'User text input (ASCII)
    INSTANCE LocalRecordingId AS ASCIIZ * 81             'User text input (ASCII)
    INSTANCE StartDateOfRecording AS ASCIIZ * 9          'dd.mm.yy (ASCII)
    INSTANCE StartTimeOfRecording AS ASCIIZ * 9          'hh.mm.ss (ASCII)
    INSTANCE NbrOfBytesInHeader AS ASCIIZ * 9            '(ASCII)
    INSTANCE VersionOfDataFmt AS ASCIIZ * 45             '"24BIT" (ASCII)                            "BIOSEMI" (ASCII)
    INSTANCE NbrOfDataRecords AS ASCIIZ * 9              '(ASCII) "-1" if unknown
    INSTANCE DurationOfDataRecord AS ASCIIZ * 9          'e.g. "1" (ASCII) in seconds
    INSTANCE NbrOfChannels AS ASCIIZ * 5                 'e.g. "257" or "128" (ASCII)
    INSTANCE LabelsOfChannels() AS ASCIIZ * 17           'e.g. "Fp1", "Fpz", "Fp2", etc (ASCII)
    INSTANCE TransducerTypes() AS ASCIIZ * 81            'e.g. "active electrode", respiration belt" (ASCII)
    INSTANCE PhysDimOfChannels() AS ASCIIZ * 9           'e.g. "uV", Ohm" (ASCII)
    INSTANCE PhysDimMin() AS ASCIIZ * 9                  'e.g. "-262144" (ASCII)                    e.g. "-32768" (ASCII)
    INSTANCE PhysDimMax() AS ASCIIZ * 9                  'e.g. "262143" (ASCII)                     e.g. "32767" (ASCII)
    INSTANCE DigitalMin() AS ASCIIZ * 9                  'e.g. "-8388608" (ASCII)                   e.g. "-32768" (ASCII)
    INSTANCE DigitalMax() AS ASCIIZ * 9                  'e.g. "8388607" (ASCII)                    e.g. "32767" (ASCII)
    INSTANCE Prefiltering() AS ASCIIZ * 81               'e.g. "HP:DC;LP:410"                       e.g. "HP:0,16;LP:500"
    INSTANCE NumberOfSamples() AS ASCIIZ * 9             'For example "2048" (ASCII)
    INSTANCE Reserved() AS ASCIIZ * 33                   'ASCII
    INSTANCE HeaderToNbrOfChannels AS ASCIIZ * 257
    INSTANCE lNbrOfChannels, lNbrOfDataRecords, lDurationOfDataRecord AS LONG
    INSTANCE ptrToDataRecords AS LONG
    INSTANCE sFilename AS STRING
    INSTANCE chanData() AS ChannelData

    INTERFACE BDFEDFHeaderInterface
        INHERIT IUNKNOWN            ' inherit the base class

    PROPERTY GET NumberOfChannels AS LONG
        PROPERTY = lNbrOfChannels
    END PROPERTY

    PROPERTY GET NumberOfDataRecords AS LONG
        PROPERTY = lNbrOfDataRecords
    END PROPERTY

    PROPERTY GET DurationOfDataRecord AS LONG
        PROPERTY = lDurationOfDataRecord
    END PROPERTY

    METHOD ReadHeaderToNbrOfChannels(filename AS STRING)
        LOCAL x, y, rec, seekPos AS LONG
        LOCAL numberOfSamples AS LONG

        sFilename = filename

        OPEN filename FOR BINARY AS #1
        GET #1, 1, HeaderToNbrOfChannels

        IDCode_1 = MID$(HeaderToNbrOfChannels, 1, 1)
        #DEBUG PRINT "IDCode_1 " + IDCode_1

        IDCode_2 = MID$(HeaderToNbrOfChannels, 2, 8)
        #DEBUG PRINT "IDCode_2 "+ IDCode_2

        LocalSubjectID = MID$(HeaderToNbrOfChannels, 9, 80)
        #DEBUG PRINT "LocalSubjectID " + LocalSubjectID

        LocalRecordingId = MID$(HeaderToNbrOfChannels, 88, 80)
        #DEBUG PRINT "LocalRecordingId " + LocalRecordingId

        StartDateOfRecording = MID$(HeaderToNbrOfChannels, 169, 8)
        #DEBUG PRINT "StartDateOfRecording " + StartDateOfRecording

        StartTimeOfRecording = MID$(HeaderToNbrOfChannels, 177, 8)
        #DEBUG PRINT "StartTimeOfRecording " + StartTimeOfRecording

        NbrOfBytesInHeader = MID$(HeaderToNbrOfChannels, 185, 8)
        #DEBUG PRINT "NbrOfBytesInHeader " + NbrOfBytesInHeader

        VersionOfDataFmt = MID$(HeaderToNbrOfChannels, 193, 44)
        #DEBUG PRINT "VersionOfDataFmt " + VersionOfDataFmt

        NbrOfDataRecords = MID$(HeaderToNbrOfChannels, 237, 8)
        #DEBUG PRINT "NbrOfDataRecords " + NbrOfDataRecords
        lNbrOfDataRecords = VAL(NbrOfDataRecords)

        DurationOfDataRecord = MID$(HeaderToNbrOfChannels, 245, 8)
        #DEBUG PRINT "DurationOfDataRecord " + DurationOfDataRecord
        lDurationOfDataRecord = VAL(DurationOfDataRecord)

        NbrOfChannels = MID$(HeaderToNbrOfChannels, 253, 4)
        lNbrOfChannels = VAL(NbrOfChannels)
        #DEBUG PRINT "NbrOfChannels " + NbrOfChannels

        REDIM LabelsOfChannels(lNbrOfChannels)
        seekPos = 257
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, LabelsOfChannels(x)
            LabelsOfChannels(x) = LEFT$(LabelsOfChannels(x), 16)
            #DEBUG PRINT "LabelsOfChannels(" + STR$(x) + ") " + LabelsOfChannels(x)
            seekPos = seekPos + 16
        NEXT x

        REDIM TransducerTypes(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, TransducerTypes(x)
            TransducerTypes(x) = LEFT$(TransducerTypes(x), 80)
            #DEBUG PRINT "TransducerTypes(" + STR$(x) + ") " + TransducerTypes(x)
            seekPos = seekPos + 80
        NEXT x

        REDIM PhysDimOfChannels(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, PhysDimOfChannels(x)
            PhysDimOfChannels(x) = LEFT$(PhysDimOfChannels(x), 8)
            #DEBUG PRINT "PhysDimOfChannels(" + STR$(x) + ") " + PhysDimOfChannels(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM PhysDimMin(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, PhysDimMin(x)
            PhysDimMin(x) = LEFT$(PhysDimMin(x), 8)
            #DEBUG PRINT "PhysDimMin(" + STR$(x) + ") " + PhysDimMin(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM PhysDimMax(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, PhysDimMax(x)
            PhysDimMax(x) = LEFT$(PhysDimMax(x), 8)
            #DEBUG PRINT "PhysDimMax(" + STR$(x) + ") " + PhysDimMax(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM DigitalMin(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, DigitalMin(x)
            DigitalMin(x) = LEFT$(DigitalMin(x), 8)
            #DEBUG PRINT "DigitalMin(" + STR$(x) + ") " + DigitalMin(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM DigitalMax(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, DigitalMax(x)
            DigitalMax(x) = LEFT$(DigitalMax(x), 8)
            #DEBUG PRINT "DigitalMax(" + STR$(x) + ") " + DigitalMax(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM Prefiltering(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, Prefiltering(x)
            Prefiltering(x) = LEFT$(Prefiltering(x), 80)
            #DEBUG PRINT "Prefiltering(" + STR$(x) + ") " + Prefiltering(x)
            seekPos = seekPos + 80
        NEXT x

        REDIM NumberOfSamples(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, NumberOfSamples(x)
            NumberOfSamples(x) = LEFT$(NumberOfSamples(x), 8)
            #DEBUG PRINT "NumberOfSamples(" + STR$(x) + ") " + NumberOfSamples(x)
            seekPos = seekPos + 8
        NEXT x

        REDIM Reserved(lNbrOfChannels)
        FOR x = 1 TO lNbrOfChannels
            GET #1, seekPos, Reserved(x)
            Reserved(x) = LEFT$(Reserved(x), 32)
            #DEBUG PRINT "Reserved(" + STR$(x) + ") " + Reserved(x)
            seekPos = seekPos + 32
        NEXT x

        ptrToDataRecords = seekPos


'        for rec = 1 to lNbrOfDataRecords
'            FOR x = 1 TO lNbrOfChannels
'                numberOfSamples = val(NumberOfSamples(x))
'                redim chanData(lNbrOfDataRecords, lNbrOfChannels, numberOfSamples)
'                for y = 1 to numberOfSamples
'                    GET #1, seekPos, chanData(rec, x, y).ds.sample
'                    #DEBUG PRINT "Channel " + str$(x) + " Sample " + str$(y) + " 24 bit data sample " + str$(chanData(rec, x, y).ds.sample)
'                    #debug print str$(chanData(rec, x, y).ds.sampleBytes(3)) + ", " + STR$(chanData(rec, x, y).ds.sampleBytes(2)) + ", " + STR$(chanData(rec, x, y).ds.sampleBytes(1))
'                    '#DEBUG PRINT "ChannelData(" + STR$(x) + ", "  + str$(y) + ") " + str$(ChannelData(x, y))
'                    seekPos = seekPos + 3
'                next y
'            NEXT x
'        next rec

        CLOSE #1
    END METHOD

    METHOD GetDataRecord(rec AS LONG, chan AS LONG, samp AS LONG)
        LOCAL x, y, z, r, seekPos, found, numberOfSamples, temp1, temp2 AS LONG
        LOCAL ds AS DataSample




'        temp1 = ptrToDataRecords
'        found = 0
'        FOR r = 1 TO 100
'            FOR x = 1 TO 100
'                numberOfSamples = VAL(NumberOfSamples(x))
'                FOR y = 1 TO 100
'                    IF (r = rec AND x = chan AND y = samp) THEN
'                        found = 1
'                        EXIT FOR
'                    ELSE
'                        temp1 = temp1 + 3
'                    END IF
'                NEXT y
'                IF (found = 1) THEN EXIT FOR
'            NEXT x
'            IF (found = 1) THEN EXIT FOR
'        NEXT r

        seekPos =  ptrToDataRecords
        found = 0
        FOR r = 1 TO lNbrOfDataRecords
            FOR x = 1 TO lNbrOfChannels
                numberOfSamples = VAL(NumberOfSamples(x))
                FOR y = 1 TO numberOfSamples
                    IF (r = rec AND x = chan AND y = samp) THEN
                        found = 1
                        EXIT FOR
                    ELSE
                        seekPos = seekPos + 3
                    END IF
                NEXT y
                IF (found = 1) THEN EXIT FOR
            NEXT x
            IF (found = 1) THEN EXIT FOR
        NEXT r

        IF (found = 1) THEN
            OPEN sFilename FOR BINARY AS #1
            temp2 = seekPos
            GET #1, seekPos,ds.sample
            #DEBUG PRINT "Record " + STR$(rec) + " Channel " + STR$(chan) + " Sample " + STR$(samp) + " 24 bit data sample " + STR$(ds.sample)
            #DEBUG PRINT STR$(ds.sampleBytes(3)) + ", " + STR$(ds.sampleBytes(2)) + ", " + STR$(ds.sampleBytes(1))
            CLOSE #1
        END IF

    END METHOD



    END INTERFACE
END CLASS
