%MAXPPS_SIZE = 2048

TYPE GV
    Desc AS ASCIIZ * 41
    Value AS INTEGER
END TYPE

TYPE GroupVars
    Condition AS ASCIIZ * 255
    Desc AS ASCIIZ * 255
    GVs(255) AS GV
    NbrOfGVs AS INTEGER
END TYPE

TYPE Evt
    Type AS ASCIIZ * 20
    EvtName AS ASCIIZ * 255
    Desc AS ASCIIZ * 255
    Channel AS ASCIIZ * 10
    Edge AS ASCIIZ * 10
    Location AS ASCIIZ * 10
    EvtMin AS LONG
    EvtMax AS LONG
    GroupVariables(30) AS GroupVars
    NbrOfGroupVariables AS INTEGER
END TYPE

TYPE SessionDesc
    Date AS ASCIIZ * 11
    Time AS ASCIIZ * 9
    Subject AS ASCIIZ * 5
    Agent AS ASCIIZ * 5
    Technician(10) AS ASCIIZ * 41
    NbrOfTechnician AS INTEGER
    SubjectDir AS ASCIIZ * 255
    DataDir AS ASCIIZ * 255
    INIFile AS ASCIIZ * 255
    HDRFile AS ASCIIZ * 31
    BDFFile AS ASCIIZ * 31
    EventFile AS ASCIIZ * 31
    ElectrodeFile AS ASCIIZ * 31
    Comment AS ASCIIZ *2048
END TYPE

TYPE Scrn
    x AS INTEGER
    y AS INTEGER
    xMax AS INTEGER
    yMax AS INTEGER
END TYPE

TYPE Miscellaneous
    Family AS ASCIIZ * 5
    Code AS ASCIIZ * 3
    NbrOfRuns AS INTEGER
    NbrOfTrials AS INTEGER
    NbrOfTargets AS LONG
    Feedback AS ASCIIZ * 4
    DigitalIOCard AS ASCIIZ * 4
    Delay0Min AS LONG
    Delay0Max AS LONG
    Delay1Min AS LONG
    Delay1Max AS LONG
    Delay2Min AS LONG
    Delay2Max AS LONG
    Delay3Min AS LONG
    Delay3Max AS LONG
    Delay4Min AS LONG
    Delay4Max AS LONG
    SCREEN(2) AS Scrn
    Mode AS ASCIIZ * 10
END TYPE

TYPE StimulusBMP
    BitmapName AS ASCIIZ * 255
    BitmapHnd AS  DWORD
    Rows AS INTEGER
    Columns AS INTEGER
    StartPosX AS INTEGER
    StartPosY AS INTEGER
    SizeX AS INTEGER
    SizeY AS INTEGER
    UpperLeftX AS INTEGER
    UpperLeftY AS INTEGER
    LowerRightX AS INTEGER
    LowerRightY AS INTEGER
END TYPE

TYPE ExperimentDesc
    SoftwareVersion AS ASCIIZ * 20
    Title AS ASCIIZ *255
    LongDesc AS ASCIIZ *2048
    Experimenter(10) AS ASCIIZ * 41
    NbrOfExperimenter AS INTEGER
    StatusBits AS ASCIIZ * 3
    ExpEvents(30) AS Evt
    NbrOfExpEvents AS INTEGER
    ActiviewConfig AS ASCIIZ * 255
    UseTCPIP AS INTEGER
    TCPIPSettingsFile  AS ASCIIZ * 255
    Stimulus AS StimulusBMP
    SessionDescription AS SessionDesc
    Misc AS Miscellaneous
END TYPE

TYPE ConditionsAndGVs
    Condition AS ASCIIZ * 255
    Desc AS ASCIIZ * 41
END TYPE

TYPE EventsAndGVs
    EvtName AS ASCIIZ * 255
    Index AS LONG
    GrayCode AS LONG
    ClockTime AS ASCIIZ * 20
    EventTime AS ASCIIZ * 25
    ElapsedMillis AS LONG
    GVars(255) AS ConditionsAndGVs
    NbrOfGVars AS INTEGER
END TYPE



FUNCTION ConvertToFullPath(BYVAL FileSpec AS STRING) AS STRING
    LOCAL zTmp      AS ASCIIZ * %MAX_PATH
    LOCAL Nullo     AS DWORD
    LOCAL lResult   AS LONG
    lResult = GetFullPathName(BYVAL STRPTR(FileSpec),BYVAL SIZEOF(zTmp),BYVAL VARPTR(zTmp),Nullo)
    FUNCTION = zTmp
END FUNCTION

SUB LoadINISettings()
    GLOBAL EXPERIMENT AS ExperimentDesc
    GLOBAL EVENTSANDCONDITIONS() AS EventsAndGVs
    LOCAL x, y AS LONG
    LOCAL Value, EvtMin, EvtMax AS LONG
    LOCAL cnt AS LONG
    LOCAL scrnTemp AS INTEGER
    LOCAL temp, temp2 AS ASCIIZ * 1000
    DIM arr40(255) AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    LOCAL expType AS ASCIIZ * 3
    LOCAL tempEvtName, eventName, tempFilename AS ASCIIZ *255
    LOCAL LongDesc, Desc, Typ, Channel, Edge, Location AS STRING
    LOCAL TFile, HeaderFile AS ASCIIZ * 255
    DIM EVENTSANDCONDITIONS(20)

    ON ERROR GOTO Error01

    filename = ConvertToFullPath(EXPERIMENT.SessionDescription.INIFile)

    GetPrivateProfileString("Experiment Section", "SoftwareVersion", "", EXPERIMENT.SoftwareVersion, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Title", "",EXPERIMENT.Title , %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Description", "", EXPERIMENT.LongDesc, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Experiment", "", EXPERIMENT.Misc.Family, 255, filename)
    GetPrivateProfileString("Experiment Section", "ExperimentType", "",  EXPERIMENT.Misc.Code, 255, filename)
    GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Experimenter", "", temp, %MAXPPS_SIZE, filename)



    PARSE temp, arr40(), ","
    x = 0
    DO
        temp2 = arr40(x)
        EXPERIMENT.Experimenter(x) = arr40(x)
        x = x + 1
    LOOP UNTIL (temp2 = $NUL) OR (temp2 = "")
    EXPERIMENT.NbrOfExperimenter = x - 2


    GetPrivateProfileString("Experiment Section", "Technician", "", temp, %MAXPPS_SIZE, filename)

    PARSE temp, arr40(), ","
    x = 0
    DO
        temp2 = arr40(x)
        EXPERIMENT.SessionDescription.Technician(x) = arr40(x)
        x = x + 1
    LOOP UNTIL (temp2 = $NUL) OR (temp2 = "")
    EXPERIMENT.SessionDescription.NbrOfTechnician = x - 2

    EXPERIMENT.Misc.NbrOfRuns = GetPrivateProfileInt("Experiment Section", "NumberofRuns", 0, filename)
    'GetPrivateProfileString("Experiment Section", "TargetSensitivity", "", var, 255, filename)
    EXPERIMENT.Misc.NbrOfTrials = GetPrivateProfileInt("Experiment Section", "NumOfTrials", 0, filename)
    EXPERIMENT.Misc.nbrOfTargets = GetPrivateProfileInt("Experiment Section", "NumberofTargets", 0, filename)
    GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", EXPERIMENT.Misc.DigitalIOCard, 255, filename)
    GetPrivateProfileString("Experiment Section", "StatusBits", "", EXPERIMENT.StatusBits, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "AgentID", "", EXPERIMENT.SessionDescription.Agent, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Feedback", "", EXPERIMENT.Misc.Feedback, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "Comment", "Enter text", EXPERIMENT.SessionDescription.Comment, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "", EXPERIMENT.ActiviewConfig, %MAXPPS_SIZE, filename)
    IF (TRIM$(EXPERIMENT.ActiviewConfig) = "") THEN
        MSGBOX "No Actiview Configuration set in .INI file."
    END IF

    EXPERIMENT.UseTCPIP = GetPrivateProfileInt("Experiment Section", "UseTCPIP", 0, filename)
    GetPrivateProfileString("Experiment Section", "TCPIPSettingsFile", "", EXPERIMENT.TCPIPSettingsFile, %MAXPPS_SIZE, filename)

    scrnTemp = GetPrivateProfileInt("Display Section", "ExperimentScreen", 0, filename)

    SELECT CASE scrnTemp
        CASE 0
            EXPERIMENT.Misc.Screen(0).x = 0
            EXPERIMENT.Misc.Screen(0).y = 0
            EXPERIMENT.Misc.Screen(0).xMax = 1600
            EXPERIMENT.Misc.Screen(0).yMax = 1024
        CASE 1
            EXPERIMENT.Misc.Screen(0).x = 1600
            EXPERIMENT.Misc.Screen(0).y = 0
            EXPERIMENT.Misc.Screen(0).xMax = 1600
            EXPERIMENT.Misc.Screen(0).yMax = 1024
        CASE 2
            EXPERIMENT.Misc.Screen(0).x = 3200
            EXPERIMENT.Misc.Screen(0).y = 0
            EXPERIMENT.Misc.Screen(0).xMax = 1600
            EXPERIMENT.Misc.Screen(0).yMax = 1024
    END SELECT


    scrnTemp = GetPrivateProfileInt("Display Section", "SubjectScreen", 0, filename)
    SELECT CASE scrnTemp
        CASE 0
            EXPERIMENT.Misc.Screen(1).x = 0
            EXPERIMENT.Misc.Screen(1).y = 0
            EXPERIMENT.Misc.Screen(1).xMax = 1600
            EXPERIMENT.Misc.Screen(1).yMax = 1024
        CASE 1
            EXPERIMENT.Misc.Screen(1).x = 1600
            EXPERIMENT.Misc.Screen(1).y = 0
            EXPERIMENT.Misc.Screen(1).xMax = 1600
            EXPERIMENT.Misc.Screen(1).yMax = 1024
        CASE 2
            EXPERIMENT.Misc.Screen(1).x = 3200
            EXPERIMENT.Misc.Screen(1).y = 0
            EXPERIMENT.Misc.Screen(1).xMax = 1600
            EXPERIMENT.Misc.Screen(1).yMax = 1024
    END SELECT

    scrnTemp = GetPrivateProfileInt("Display Section", "AgentScreen", 0, filename)
    SELECT CASE scrnTemp
        CASE 0
            EXPERIMENT.Misc.Screen(2).x = 0
            EXPERIMENT.Misc.Screen(2).y = 0
            EXPERIMENT.Misc.Screen(2).xMax = 1600
            EXPERIMENT.Misc.Screen(2).yMax = 1024
        CASE 1
            EXPERIMENT.Misc.Screen(2).x = 1600
            EXPERIMENT.Misc.Screen(2).y = 0
            EXPERIMENT.Misc.Screen(2).xMax = 1600
            EXPERIMENT.Misc.Screen(2).yMax = 1024
        CASE 2
            EXPERIMENT.Misc.Screen(2).x = 3200
            EXPERIMENT.Misc.Screen(2).y = 0
            EXPERIMENT.Misc.Screen(2).xMax = 1600
            EXPERIMENT.Misc.Screen(2).yMax = 1024
    END SELECT


    GetPrivateProfileString("Subject Section", "ID", "", EXPERIMENT.SessionDescription.Subject, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Subject Section", "DataFolder", "", EXPERIMENT.SessionDescription.DataDir, %MAXPPS_SIZE, filename)
    'GetPrivateProfileString("Subject Section", "Date", "", EXPERIMENT.SessionDescription.Date, %MAXPPS_SIZE, filename)
    'GetPrivateProfileString("Subject Section", "Time", "", EXPERIMENT.SessionDescription.Time, %MAXPPS_SIZE, filename)

    'GetPrivateProfileString("Subject Section", "HeaderFile", "", var, 255, filename)
    'GetPrivateProfileString("Subject Section", "SubjectFile", "", var, 255, filename)
    'GetPrivateProfileString("Subject Section", "FileFolder", "", var, 255, filename)
    'GetPrivateProfileString("Subject Section", "BDFFile", "", EXPERIMENT.SessionDescription.BDFFile, %MAXPPS_SIZE, filename)
    'GetPrivateProfileString("Subject Section", "ElectrodeFile", "", EXPERIMENT.SessionDescription.ElectrodeFile, %MAXPPS_SIZE, filename)


    EXPERIMENT.Misc.Delay0Min = GetPrivateProfileInt("Delay Section", "Delay0Min", 0, filename)
    EXPERIMENT.Misc.Delay0Max = GetPrivateProfileint("Delay Section", "Delay0Max", 0, filename)
    EXPERIMENT.Misc.Delay1Min = GetPrivateProfileInt("Delay Section", "Delay1Min", 0, filename)
    EXPERIMENT.Misc.Delay1Max = GetPrivateProfileint("Delay Section", "Delay1Max", 0, filename)
    EXPERIMENT.Misc.Delay2Min = GetPrivateProfileInt("Delay Section", "Delay2Min", 0, filename)
    EXPERIMENT.Misc.Delay2Max = GetPrivateProfileint("Delay Section", "Delay2Max", 0, filename)
    EXPERIMENT.Misc.Delay3Min = GetPrivateProfileInt("Delay Section", "Delay3Min", 0, filename)
    EXPERIMENT.Misc.Delay3Max = GetPrivateProfileint("Delay Section", "Delay3Max", 0, filename)
    EXPERIMENT.Misc.Delay4Min = GetPrivateProfileInt("Delay Section", "Delay4Min", 0, filename)
    EXPERIMENT.Misc.Delay4Max = GetPrivateProfileint("Delay Section", "Delay4Max", 0, filename)

    GetPrivateProfileString("Stimulus Section", "BitmapName", "", EXPERIMENT.Stimulus.BitmapName, %MAXPPS_SIZE, filename)
    GetPrivateProfileString("Stimulus Section", "Rows", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.Rows = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "Columns", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.Columns = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "StartPosX", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.StartPosX = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "StartPosY", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.StartPosY = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "SizeX", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.SizeX = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "SizeY", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.SizeY = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "UpperLeftX", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.UpperLeftX = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "UpperLeftY", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.UpperLeftY = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "LowerRightX", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.LowerRightX = VAL(temp)
    GetPrivateProfileString("Stimulus Section", "LowerRightY", "", temp, %MAXPPS_SIZE, filename)
    EXPERIMENT.Stimulus.LowerRightY = VAL(temp)

    LOCAL month, day, year, hour, minute, subj, subjDir, wavFile AS STRING
    LOCAL tSubject AS INTEGER

    month = MID$(DATE$, 1, 2)
    day = MID$(DATE$, 4, 2)
    year = MID$(DATE$, 7, 4)
    hour = MID$(TIME$, 1, 2)
    minute = MID$(TIME$, 4, 2)
    tSubject = VAL(EXPERIMENT.SessionDescription.Subject)
    subjDir = FORMAT$(tSubject, "0000")

    IF (EXPERIMENT.SessionDescription.DataDir <> "") THEN
        CHDIR EXPERIMENT.SessionDescription.DataDir
    END IF

    ON ERROR GOTO 0
    MKDIR "Subject_Data"

    CHDIR "Subject_Data"

    ON ERROR GOTO 0
    MKDIR subjDir

    CHDIR subjDir

    EXPERIMENT.SessionDescription.SubjectDir = "Subject_Data\" + subjDir

    TFile = "S" + subjDir + "-" + EXPERIMENT.Misc.Code + "-" + year + month + day + "-" + hour + minute

    HeaderFile = TFile + ".HDR"
    EXPERIMENT.SessionDescription.HDRFile = HeaderFile
    EXPERIMENT.SessionDescription.BDFFile = TFile + ".BDF"
    EXPERIMENT.SessionDescription.EventFile = TFile + ".EVT"
    EXPERIMENT.SessionDescription.ElectrodeFile = TFile + ".ETR"
    WritePrivateProfileString( "Subject Section", "HeaderFile", HeaderFile, filename)
    WritePrivateProfileString( "Subject Section", "BDFFile", EXPERIMENT.SessionDescription.BDFFile, filename)
    WritePrivateProfileString( "Subject Section", "SubjectFile", EXPERIMENT.SessionDescription.EventFile, filename)
    WritePrivateProfileString( "Subject Section", "ElectrodeFile", EXPERIMENT.SessionDescription.ElectrodeFile, filename)
    WritePrivateProfileString( "Subject Section", "FileFolder", CURDIR$, filename)
    WritePrivateProfileString( "Subject Section", "Date", DATE$, filename)
    WritePrivateProfileString( "Subject Section", "Time", LEFT$(TIME$,5), filename)

    FOR x = 0 TO 12
        tempEvtName = "Event-" + FORMAT$(x + 1, "00")
        GetPrivateProfileString("Events Section", tempEvtName, "", temp, %MAXPPS_SIZE, filename)
        IF (temp <> "" AND temp <> $NUL) THEN
            PARSE temp, arr40(), ","

            temp2 = arr40(0)
            EXPERIMENT.ExpEvents(x).EvtName = temp2

            tempFileName = filename
            REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Events\" + temp2 + ".txt" IN tempFileName

            IF (ISFILE(tempFileName) = 0) THEN
                MSGBOX tempFileName + " does not exist."
                CALL ExitProcess(-1)
                EXIT SUB
            END IF


            OPEN tempFileName FOR INPUT AS #1

            INPUT #1, Desc
            EXPERIMENT.ExpEvents(x).Desc = Desc

            cnt = 0
            DO
                INPUT# #1, Typ, Channel, Edge, Location, EvtMax, EvtMin
                IF (LCASE$(Typ) = "xxx" AND Channel = "999") THEN
                    EXIT LOOP
                END IF

                EXPERIMENT.ExpEvents(x).TYPE = Typ
                EXPERIMENT.ExpEvents(x).Channel = Channel
                EXPERIMENT.ExpEvents(x).Edge = Edge
                EXPERIMENT.ExpEvents(x).Location = Location
                EXPERIMENT.ExpEvents(x).EvtMax = EvtMax
                EXPERIMENT.ExpEvents(x).EvtMin = EvtMin
                cnt = cnt + 1
            LOOP

            CLOSE #1


            y = 0
            DO
                temp2 = arr40(y + 1)
                IF (temp2 = $NUL OR temp2 = "") THEN
                    EXIT LOOP
                END IF
                EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition = temp2


                tempFileName = filename
                REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\" + temp2 + ".txt" IN tempFileName

                IF (ISFILE(tempFileName) = 0) THEN
                    MSGBOX tempFileName + " does not exist."
                    CALL ExitProcess(-1)
                    EXIT SUB
                END IF

                OPEN tempFileName FOR INPUT AS #1

                INPUT #1, LongDesc
                EXPERIMENT.ExpEvents(x).GroupVariables(y).Desc = LongDesc

                cnt = 0
                DO
                    INPUT# #1, Desc, Value, wavFile
                    IF (LCASE$(Desc) = "xxx" AND Value = 999) THEN
                        EXIT LOOP
                    END IF
                    EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(cnt).Desc = Desc
                    EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(cnt).Value = Value
                    cnt = cnt + 1
                LOOP
                EXPERIMENT.ExpEvents(x).GroupVariables(y).NbrOfGVs = cnt - 1

                CLOSE #1

                y = y + 1
            LOOP
            EXPERIMENT.ExpEvents(x).NbrOfGroupVariables  = y - 1
        ELSE
            EXPERIMENT.nbrOfExpEvents = x - 1
            EXIT FOR
        END IF
    NEXT x

    CALL createHeaderFile(HeaderFile)

    Error01:
        IF (ERR <> 0 AND ERR <> 75) THEN
            MSGBOX "Error: " + ERROR$ + " STOP the program!"
        END IF
END SUB

SUB createHeaderFile(hdrFile AS ASCIIZ *255)
    LOCAL x, y, z AS LONG
    LOCAL filename, tempFileName, temp AS STRING

    filename = EXPERIMENT.SessionDescription.INIFile
    tempFileName = filename
    REPLACE filename WITH  hdrFile IN tempFileName

    OPEN tempFileName FOR OUTPUT ACCESS WRITE AS #1

    PRINT #1, "<?xml version=" + """1.0"""+ " encoding=" + """utf-8""" + "?>"
    PRINT #1, "<Header>"
    PRINT #1, "  <ExperimentDescription>"
    PRINT #1, "    <SoftwareVersion>" + EXPERIMENT.SoftwareVersion + "</SoftwareVersion>"
    PRINT #1, "    <Title>" + EXPERIMENT.Title + "</Title>"
    PRINT #1, "    <LongDescription>" + EXPERIMENT.LongDesc + "</LongDescription>

    FOR x = 0 TO EXPERIMENT.NbrOfExperimenter
        PRINT #1, "    <Experimenter>" + EXPERIMENT.Experimenter(x) + "</Experimenter>"
    NEXT x

    PRINT #1, "    <Status>" + EXPERIMENT.StatusBits + "</Status>"
    FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
        temp = EXPERIMENT.ExpEvents(0).GroupVariables(y).Condition
        #DEBUG PRINT "temp: " +  temp
        PRINT #1, "    <GroupVar>"
        PRINT #1, "      <Name>" + EXPERIMENT.ExpEvents(0).GroupVariables(y).Condition + "</Name>"
        PRINT #1, "      <Description>" + EXPERIMENT.ExpEvents(0).GroupVariables(y).Desc + "</Description>"
        FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
            IF (TRIM$(LCASE$(EXPERIMENT.ExpEvents(0).GroupVariables(y).GVs(z).Desc)) <> "var$") THEN
                PRINT #1, "      <GV Desc=""" + EXPERIMENT.ExpEvents(0).GroupVariables(y).GVs(z).Desc + """>" + TRIM$(STR$(EXPERIMENT.ExpEvents(0).GroupVariables(y).GVs(z).Value)) + "</GV>"
            END IF
        NEXT z
        PRINT #1, "    </GroupVar>"
    NEXT y
    FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
        PRINT #1, "    <Event Type=""" + EXPERIMENT.ExpEvents(x).TYPE + """>"
        PRINT #1, "      <Name>" + EXPERIMENT.ExpEvents(x).EvtName + "</Name>"
        PRINT #1, "      <Description>" + EXPERIMENT.ExpEvents(x).Desc + "</Description>"
        IF (TRIM$(LCASE$(EXPERIMENT.ExpEvents(x).TYPE)) = "extrinsic") THEN
            PRINT #1, "      <Channel>" + EXPERIMENT.ExpEvents(x).Channel + "</Channel>"
            PRINT #1, "      <Edge>" + EXPERIMENT.ExpEvents(x).Edge + "</Edge>"
            PRINT #1, "      <Location>" + EXPERIMENT.ExpEvents(x).Location + "</Location>"
            PRINT #1, "      <Max>" + TRIM$(STR$(EXPERIMENT.ExpEvents(x).EvtMax)) + "</Max>"
            PRINT #1, "      <Min>" + TRIM$(STR$(EXPERIMENT.ExpEvents(x).EvtMin)) + "</Min>"
        END IF
        FOR y = 0 TO EXPERIMENT.ExpEvents(x).NbrOfGroupVariables
            PRINT #1, "      <GroupVar Name=""" + EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition + """/>"
        NEXT y
        PRINT #1, "    </Event>"
    NEXT x
    PRINT #1, "  </ExperimentDescription>"
    PRINT #1, "  <SessionDescription>"
    PRINT #1, "    <Date>" + EXPERIMENT.SessionDescription.Date + "</Date>"
    PRINT #1, "    <Time>" + LEFT$(EXPERIMENT.SessionDescription.Time,5) + "</Time>"
    PRINT #1, "    <Subject>" + EXPERIMENT.SessionDescription.Subject + "</Subject>"
    IF (TRIM$(EXPERIMENT.SessionDescription.Agent) <> "") THEN
        PRINT #1, "    <Agent>" + EXPERIMENT.SessionDescription.Agent + "</Agent>"
    END IF
    FOR x = 0 TO EXPERIMENT.SessionDescription.NbrOfTechnician
        PRINT #1, "    <Technician>" + EXPERIMENT.SessionDescription.Technician(x) +"</Technician>"
    NEXT x
    PRINT #1, "    <BDFFile>" + EXPERIMENT.SessionDescription.BDFFile + "</BDFFile>"
    PRINT #1, "    <EventFile>" + EXPERIMENT.SessionDescription.EventFile + "</EventFile>"
    PRINT #1, "    <ElectrodeFile>" + EXPERIMENT.SessionDescription.ElectrodeFile + "</ElectrodeFile>"
    PRINT #1, "    <Comment>" + EXPERIMENT.SessionDescription.Comment + "</Comment>"
    PRINT #1, "  </SessionDescription>"
    PRINT #1, "</Header>"

    CLOSE #1

END SUB

SUB initializeEventFile()
    LOCAL filename AS STRING

    filename = EXPERIMENT.SessionDescription.EventFile

    OPEN filename FOR OUTPUT ACCESS WRITE AS #1

    PRINT #1, "<?xml version=" + """1.0"""+ " encoding=" + """utf-8""" + "?>"
    PRINT #1, "<Events>"
    CLOSE #1
END SUB

SUB closeEventFile()
    LOCAL filename AS STRING

    filename = EXPERIMENT.SessionDescription.EventFile

    OPEN filename FOR APPEND AS #1

    PRINT #1, "</Events>"

    CLOSE #1

    ON ERROR GOTO 0

    CHDIR "..\.."
END SUB

SUB writeToEventFile()
    LOCAL x, evts AS LONG
    LOCAL day, month, year AS STRING
    LOCAL mName AS STRING
    LOCAL filename AS STRING

    filename = EXPERIMENT.SessionDescription.EventFile
    day = MID$(DATE$, 1, 2)
    month = MID$(DATE$, 4, 2)
    mName = monthName(month)
    year = MID$(DATE$, 9, 2)
    OPEN filename FOR APPEND AS #1
    FOR evts = 0 TO EXPERIMENT.nbrOfExpEvents
        PRINT #1, "  <Event Name=""" + EVENTSANDCONDITIONS(evts).EvtName + """>"
        PRINT #1, "    <Index>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).Index)) + "</Index>"
        PRINT #1, "    <GrayCode>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).GrayCode)) + "</GrayCode>"
        PRINT #1, "    <ClockTime>" + TRIM$(EVENTSANDCONDITIONS(evts).ClockTime) + "</ClockTime>"
        PRINT #1, "    <EventTime>" + TRIM$(EVENTSANDCONDITIONS(evts).EventTime) + "</EventTime>" 'added 12/11/2012 to timestamp for the video
        'PRINT #1, "    <ElapsedMillis>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).ElapsedMillis)) + "</ElapsedMillis>" 'added 8/22/2013 per Ross
        PRINT #1, "    <GroupVars>"
        IF ( EVENTSANDCONDITIONS(evts).NbrOfGVars > 0) THEN
            FOR x = 0 TO EVENTSANDCONDITIONS(evts).NbrOfGVars
                PRINT #1, "      <GV Name=""" + EVENTSANDCONDITIONS(evts).GVars(x).Condition + """>" + TRIM$(EVENTSANDCONDITIONS(evts).GVars(x).Desc) + "</GV>"
            NEXT x
        END IF
        PRINT #1, "    </GroupVars>"
        PRINT #1, "  </Event>"
    NEXT evts

    CLOSE #1
END SUB

'SUB writeToEventFileForGESP()
'    LOCAL x, evts AS LONG
'    LOCAL filename AS STRING
'
'    filename = EXPERIMENT.SessionDescription.EventFile
'
'    OPEN filename FOR APPEND AS #1
'    FOR evts = 0 TO EXPERIMENT.nbrOfExpEvents
'        IF (EVENTSANDCONDITIONS(evts).EvtName = "TargetDisplayedUpstairs" AND _
'                EVENTSANDCONDITIONS(evts).GVars(3).Condition = "AgentShownTarget" AND _
'                EVENTSANDCONDITIONS(evts).GVars(3).Desc = "No") THEN
'            ITERATE FOR
'        END IF
'        PRINT #1, "  <Event Name=""" + EVENTSANDCONDITIONS(evts).EvtName + """>"
'        PRINT #1, "    <Index>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).Index)) + "</Index>"
'        PRINT #1, "    <GrayCode>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).GrayCode)) + "</GrayCode>"
'        PRINT #1, "    <ClockTime>" + TRIM$(EVENTSANDCONDITIONS(evts).Time) + "</ClockTime>"
'        PRINT #1, "    <EventTime>" + day + " " + mName + " " + year + " " + TIME$ + "</EventTime>" 'added 12/11/2012 to timestamp for the video
'        PRINT #1, "    <GroupVars>"
'        FOR x = 0 TO EVENTSANDCONDITIONS(evts).NbrOfGVars
'            PRINT #1, "      <GV Name=""" + EVENTSANDCONDITIONS(evts).GVars(x).Condition + """>" + TRIM$(EVENTSANDCONDITIONS(evts).GVars(x).Desc) + "</GV>"
'        NEXT x
'
'        PRINT #1, "    </GroupVars>"
'        PRINT #1, "  </Event>"
'    NEXT evts
'
'    CLOSE #1
'END SUB

SUB writeToEventFile2(ind AS LONG)
    LOCAL x, evts AS LONG
    LOCAL day, month, year AS STRING
    LOCAL mName AS STRING
    LOCAL filename AS STRING

    filename = EXPERIMENT.SessionDescription.EventFile
    day = MID$(DATE$, 1, 2)
    month = MID$(DATE$, 4, 2)
    mName = monthName(month)
    year = MID$(DATE$, 9, 2)

    OPEN filename FOR APPEND AS #1
    FOR evts = ind TO ind
        PRINT #1, "  <Event Name=""" + EVENTSANDCONDITIONS(evts).EvtName + """>"
        PRINT #1, "    <Index>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).Index)) + "</Index>"
        PRINT #1, "    <GrayCode>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).GrayCode)) + "</GrayCode>"
        PRINT #1, "    <ClockTime>" + TRIM$(EVENTSANDCONDITIONS(evts).ClockTime) + "</ClockTime>"
        PRINT #1, "    <EventTime>" + TRIM$(EVENTSANDCONDITIONS(evts).EventTime) + "</EventTime>" 'added 12/11/2012 to timestamp for the video
        'PRINT #1, "    <ElapsedMillis>" + TRIM$(STR$(EVENTSANDCONDITIONS(evts).ElapsedMillis)) + "</ElapsedMillis>" 'added 8/22/2013 per Ross
        PRINT #1, "    <GroupVars>"
        IF (EVENTSANDCONDITIONS(evts).NbrOfGVars > 0) THEN
            FOR x = 0 TO EVENTSANDCONDITIONS(evts).NbrOfGVars
                IF (TRIM$(EVENTSANDCONDITIONS(evts).GVars(x).Condition) <> "") THEN
                    PRINT #1, "      <GV Name=""" + EVENTSANDCONDITIONS(evts).GVars(x).Condition + """>" + TRIM$(EVENTSANDCONDITIONS(evts).GVars(x).Desc) + "</GV>"
                END IF
            NEXT x
        END IF
        PRINT #1, "    </GroupVars>"
        PRINT #1, "  </Event>"
    NEXT evts

    CLOSE #1
END SUB

FUNCTION LookupLegitimateGV(evtName AS ASCIIZ * 255, condition AS ASCIIZ * 255, value AS LONG) AS STRING
    LOCAL x, y, z, flag AS LONG
    LOCAL result AS ASCIIZ *41
    LOCAL temp AS ASCIIZ * 255

    flag = 0
    result = ""
    FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
        temp = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)
        IF (LCASE$(evtName) = temp) THEN
             FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
                IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
                    FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
                        IF (value = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Value) THEN
                            result = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc
                            flag = 1
                            EXIT FOR
                        END IF
                    NEXT z
                    IF (flag = 1) THEN
                        EXIT FOR
                    END IF
                END IF
             NEXT y
             IF (flag = 1) THEN
                 EXIT FOR
             END IF
        END IF
    NEXT x

    IF (flag = 0) THEN
        FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
            IF (LCASE$(evtName) = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)) THEN
                 FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
                    IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
                        FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
                            IF (LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc) = "var$") THEN
                                result = STR$(value)
                                flag = 1
                                EXIT FOR
                            END IF
                        NEXT z
                        IF (flag = 1) THEN
                            EXIT FOR
                        END IF
                    END IF
                 NEXT y
                 IF (flag = 1) THEN
                     EXIT FOR
                 END IF
            END IF
        NEXT x
    END IF

    FUNCTION = result
END FUNCTION

FUNCTION LookupLegitimateGVDouble(evtName AS ASCIIZ * 255, condition AS ASCIIZ * 255, value AS DOUBLE) AS STRING
    LOCAL x, y, z, flag AS LONG
    LOCAL result AS ASCIIZ *41

    flag = 0
    result = ""
    FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
        IF (LCASE$(evtName) = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)) THEN
             FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
                IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
                    FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
                        IF (value = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Value) THEN
                            result = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc
                            flag = 1
                            EXIT FOR
                        END IF
                    NEXT z
                    IF (flag = 1) THEN
                        EXIT FOR
                    END IF
                END IF
             NEXT y
             IF (flag = 1) THEN
                 EXIT FOR
             END IF
        END IF
    NEXT x

    IF (flag = 0) THEN
        FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
            IF (LCASE$(evtName) = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)) THEN
                 FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
                    IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
                        FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
                            IF (LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc) = "var$") THEN
                                result = STR$(value)
                                flag = 1
                                EXIT FOR
                            END IF
                        NEXT z
                        IF (flag = 1) THEN
                            EXIT FOR
                        END IF
                    END IF
                 NEXT y
                 IF (flag = 1) THEN
                     EXIT FOR
                 END IF
            END IF
        NEXT x
    END IF

    FUNCTION = result
END FUNCTION

FUNCTION LookupLegitimateGVUnknown(evtName AS ASCIIZ * 255, condition AS ASCIIZ * 255, value AS ASCIIZ * 255) AS STRING
    LOCAL x, y, z, flag AS LONG
    LOCAL result AS ASCIIZ * 255

    flag = 0
'    result = ""
'    FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
'        IF (LCASE$(evtName) = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)) THEN
'             FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
'                IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
'                    FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
'                        IF (value = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Value) THEN
'                            result = EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc
'                            flag = 1
'                            EXIT FOR
'                        END IF
'                    NEXT z
'                    IF (flag = 1) THEN
'                        EXIT FOR
'                    END IF
'                END IF
'             NEXT y
'             IF (flag = 1) THEN
'                 EXIT FOR
'             END IF
'        END IF
'    NEXT x

    IF (flag = 0) THEN
        FOR x = 0 TO EXPERIMENT.NbrOfExpEvents
            IF (LCASE$(evtName) = LCASE$(EXPERIMENT.ExpEvents(x).EvtName)) THEN
                 FOR y = 0 TO EXPERIMENT.ExpEvents(0).NbrOfGroupVariables
                    IF (LCASE$(condition) = LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).Condition)) THEN
                        FOR z = 0 TO EXPERIMENT.ExpEvents(0).GroupVariables(y).NbrOfGVs
                            IF (LCASE$(EXPERIMENT.ExpEvents(x).GroupVariables(y).GVs(z).Desc) = "var$") THEN
                                result = value
                                flag = 1
                                EXIT FOR
                            END IF
                        NEXT z
                        IF (flag = 1) THEN
                            EXIT FOR
                        END IF
                    END IF
                 NEXT y
                 IF (flag = 1) THEN
                     EXIT FOR
                 END IF
            END IF
        NEXT x
    END IF

    FUNCTION = result
END FUNCTION
