%MAXPPS_SIZE = 2048

#INCLUDE "win32api.inc"

TYPE GVStruct
    Desc AS ASCIIZ * 41
    Value AS INTEGER
END TYPE

TYPE GroupVarsStruct
    Condition AS ASCIIZ * 255
    Desc AS ASCIIZ * 255
    GVNames(20) AS ASCIIZ *255
END TYPE

'Event information - 1 to many
TYPE EventInfoStruct
    EvtName AS ASCIIZ * 255    'ex. ResponseSelected
    Type AS ASCIIZ * 20        'ex. extrinsic
    Desc AS ASCIIZ * 255       'ex. Marks when subject makes selection.
    Channel AS ASCIIZ * 10     'ex. Ana1
    Edge AS ASCIIZ * 10        'ex. rising
    Location AS ASCIIZ * 10    'ex. before
    EvtMin AS LONG             'ex. 120000
    EvtMax AS LONG             'ex. 0
    GroupVarNames(30) AS ASCIIZ * 255
END TYPE



CLASS EventInfo
    INSTANCE lResult AS LONG
    INSTANCE NumberOfEvents AS LONG
    INSTANCE MAXEVENTS AS BYTE
    INSTANCE temp AS WSTRING
    INSTANCE INIFilename AS STRING
    INSTANCE variantTemp AS VARIANT
    INSTANCE ExpEvents() AS EventInfoStruct
    INSTANCE EventsCollect AS IPOWERCOLLECTION
    INSTANCE GroupVarsCollect AS IPOWERCOLLECTION
    INSTANCE GVsCollect AS IPOWERCOLLECTION

    CLASS METHOD CREATE()
        MAXEVENTS = 12
    END METHOD


    INTERFACE EventInfoInterface
        INHERIT IDISPATCH



    METHOD SetINIFilename(file AS STRING)
        INIFilename = file
    END METHOD

    METHOD ReadInEventInfo()
        LOCAL x, cnt AS LONG
        LOCAL tempEvtName AS ASCIIZ * 255
        LOCAL filename, tempFilename  AS ASCIIZ * 255
        LOCAL temp, temp2 AS ASCIIZ * 1000
        LOCAL LongDesc, Desc, Typ, Channel, Edge, Location AS STRING
        DIM arr40(255) AS ASCIIZ * 255
        LOCAL Value, EvtMin, EvtMax AS LONG
        LOCAL VariantVar AS VARIANT


        REDIM ExpEvents(MAXEVENTS)
        filename = INIFilename

        FOR x = 0 TO MAXEVENTS
            tempEvtName = "Event-" + FORMAT$(x + 1, "00")
            GetPrivateProfileString("Events Section", tempEvtName, "", temp, %MAXPPS_SIZE, filename)
            IF (temp <> "" AND temp <> $NUL) THEN
                PARSE temp, arr40(), ","

                temp2 = arr40(0)
                ExpEvents(x).EvtName = temp2

                tempFileName = filename
                REPLACE INIFilename WITH "Events\" + temp2 + ".txt" IN tempFileName

                IF (ISFILE(tempFileName) = 0) THEN
                    MSGBOX tempFileName + " does not exist."
                    CALL ExitProcess(-1)
                    EXIT METHOD
                END IF


                OPEN tempFileName FOR INPUT AS #1

                INPUT #1, Desc
                ExpEvents(x).Desc = Desc

                cnt = 0
                DO
                    INPUT# #1, Typ, Channel, Edge, Location, EvtMax, EvtMin
                    IF (LCASE$(Typ) = "xxx" AND Channel = "999") THEN
                        EXIT LOOP
                    END IF

                    ExpEvents(x).TYPE = Typ
                    ExpEvents(x).Channel = Channel
                    ExpEvents(x).Edge = Edge
                    ExpEvents(x).Location = Location
                    ExpEvents(x).EvtMax = EvtMax
                    ExpEvents(x).EvtMin = EvtMin
                    cnt = cnt + 1
                LOOP

                CLOSE #1

                EventsCollect.ADD(ExpEvents(x).EvtName + "", ExpEvents(x)AS STRING)
            ELSE
                NumberOfEvents = cnt - 1
            EXIT FOR
            END IF
        NEXT x
    END METHOD


    END INTERFACE
 END CLASS
