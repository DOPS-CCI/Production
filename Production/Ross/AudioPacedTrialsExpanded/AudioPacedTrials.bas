#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

'#RESOURCE "AudioPacedTrials.pbr"
#INCLUDE "win32api.inc"
#RESOURCE ICON,     IDI_ICON1, "AudioPacedTrials.ico"
#RESOURCE BITMAP,   BITMAP_HIGHLIGHT, "Images\highlight.bmp"
#RESOURCE BITMAP,   BITMAP_PROCEED , "Images\proceed.bmp"
#RESOURCE BITMAP,   BITMAP_WAIT , "Images\wait.bmp"
#RESOURCE BITMAP,   BITMAP_PDB , "Images\PD_black.bmp"
#RESOURCE BITMAP,   BITMAP_PDW , "Images\PD_white.bmp"
#RESOURCE BITMAP,   BITMAP_OKBUTTON , "Images\OKButton.bmp"




%DIO_CARD_PRESENT = 0                            'NO

%IMAGE_PD = 1001
%IMAGE_BACK = 1002
%IMAGE_PROCEED = 1003
%ID_GRID = 1004
%ID_HIGHLIGHT = 1005
%ID_OK = 1009
%TEXTBOX_SUBJECTID = 1010
%IDC_TEXTBOX_NbrOfRuns  = 1011
%TEXTBOX_NBRTRIALS = 1012
%TEXTBOX_DISPLAYDURATION = 1013
%TEXTBOX_ITDURATION = 1014
%CHECKBOX_DIO_PRESENT = 1015
%BUTTON_HELPEROK = 1016
%BUTTON_HELPERCANCEL = 1017
%FRAME_PHOTODIODE = 1018
%ID_CONTROLLER_OK = 1019
%ID_AGENTCARD = 1020
%TEXTBOX_AGENTID = 1021
%CHECKBOX_FEEDBACK = 1022
%ID_CONTROLLER_EXIT = 1023
%TEXTBOX_COMMENT = 1024
%ID_NOTHING = 1025
%BUTTON_HELP = 1026
%IDC_LABEL_TARGET = 1027
%IDC_BUTTON_EEGSettings = 1028
%IDC_LABEL_01 = 1091
%IDC_LABEL_02 = 1092
%IDC_LABEL_03 = 1093
%IDC_LABEL_04 = 1094
%IDC_LABEL_05 = 1095
%IDC_BUTTON_AudioChoices = 1096
%IDC_BUTTON_LongDesc = 1097
%IDC_BUTTON_Abort = 1098
%IDC_OPTION_Standard     = 1100
%IDC_OPTION_RNG          = 1101
%IDC_OPTION_TCPIPRMS     = 1102
%IDC_FRAME1 = 1103
%IDC_FRAME_RNG = 1104
%IDC_OPTION_FocusHigh = 1105
%IDC_OPTION_FocusLow = 1106

'%WAVE_FOCUS = 2000
'%WAVE_RELAX = 2001

'#RESOURCE WAVE,     WAVE_FOCUS, "Focus.WAV"
'#RESOURCE WAVE,     WAVE_RELAX, "Relax.WAV"


%ID_GLOBALTIMER = 1500


TYPE GlobalHandles
    DlgSubject AS DWORD
    DlgAgent AS DWORD
    DlgController AS DWORD
    DlgHelper AS DWORD
    DlgSubjectPhotoDiode AS DWORD
    DlgAgentPhotoDiode AS DWORD
END TYPE



TYPE GlobalVariables
    Target AS LONG
    Feedback AS LONG
    NbrOfHits AS LONG
    RunCnt AS LONG
    TrialCnt AS LONG
    TrialCntTotal AS LONG
    SubjectID AS LONG
    NbrOfRuns AS LONG
    NbrOFTrials AS LONG
    TrialLength AS LONG
    DiodeDelay AS LONG
    BoardNum AS LONG
    DioCardPresent AS LONG
    GreyCode AS LONG
    DioIndex AS LONG
    TargetTime AS ASCIIZ * 19
    ElapsedTime AS ASCIIZ * 19
    hdl AS GlobalHandles
END TYPE



GLOBAL globals AS GlobalVariables
GLOBAL gRndCnt AS LONG
GLOBAL gByteCnt AS LONG
GLOBAL gSamples() AS BYTE
GLOBAL gAccumDev, gARSAccumDev AS LONG
GLOBAL gAccumNbrBits, gARSAccumNbrBits AS LONG
GLOBAL gZScore, gNewZScore, gOldZScore, gSavedZScore AS DOUBLE
GLOBAL gARSZScore, gARSNewZScore, gARSOldZScore, gARSSavedZScore AS DOUBLE
GLOBAL gFirstHit, gARSFirstHit AS BYTE
GLOBAL oApp AS IDISPATCH
GLOBAL pid AS DWORD
GLOBAL gStart, gEnd AS QUAD
GLOBAL gHelperOpened AS INTEGER
GLOBAL gIntentionFocus() AS LONG
GLOBAL gWavFiles(), gRNDFile, gARSFile AS STRING
GLOBAL gSampleCnt, gSampleSize AS LONG
GLOBAL gSampleDuration AS LONG
GLOBAL gRunningDuration AS LONG
GLOBAL gBytesPerMillisecond AS LONG
GLOBAL gStandardRNGTCPIP, gHighOrLow AS BYTE

'DECLARE SUB DoTimerWork(itemName AS WSTRING)

#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "DOPS_MMTimers.inc"
'#INCLUDE "DOPS_GESP.INC"
'#include "DOPS_BDFEDF.inc"
#INCLUDE "ControllerScreen.inc"
#INCLUDE "HelperScreen.inc"
#INCLUDE "SubjectScreen.inc"
'#INCLUDE "AgentScreen.inc"

'#INCLUDE "MyTimerClass.inc"

DECLARE SUB DoNextTrial()


' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL tempFilename  AS STRING
    LOCAL filename, temp AS ASCIIZ * 255
    LOCAL sResult AS ASCIIZ * 255
    LOCAL errTrapped AS LONG

    '************************************************
    'Read values from the INI file to initialize
    'experiment variables
    '************************************************

    'tempFilename = COMMAND$
    'IF (TRIM$(tempFilename) = "") THEN
    '    MSGBOX "Please use GenericRNG filename.ini to start the program."
    '    RETURN
    'END IF

    LET gTimers = CLASS "PowerCollection"

    TRY
        LET oApp = NEWCOM "Araneus.Alea.1"
        OBJECT CALL oApp.Open
    CATCH
        MSGBOX "Error on Opening Alea RNG. Check to see if it is plugged in (and that the drivers are installed.)"
        errTrapped = ERR
        EXIT TRY
    END TRY

    IF (errTrapped <> 0) THEN
        EXIT FUNCTION
    END IF

    gSampleDuration = 1000   ' 1 second
    gSampleSize = 50        '50 samp/sec
    REDIM gSamples(gSampleSize)

    '************************************************
    'Initialize Mersenne-twister
    '************************************************
    init_MT_by_array()

    EXPERIMENT.SessionDescription.INIFile = "AudioPacedTrials.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

    '************************************************
    'check the DIO card value - usually not set for
    'demo mode.
    '************************************************
    GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", sResult, %MAXPPS_SIZE, filename)
    IF (LTRIM$(LCASE$(sResult)) = "yes" AND EXPERIMENT.Misc.Mode <> "demo") THEN
        globals.DioCardPresent = 1
    ELSE
        globals.DioCardPresent = 0
    END IF

    '************************************************
    'It will only configure and initialize if
    'globals.DioCardPresent = 1.
    '************************************************
    globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

    CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)

    globals.NbrOfHits = 0


    CALL dlgControllerScreen()

    DIALOG SHOW MODAL globals.hdl.DlgController, CALL cbControllerScreen TO hr


        'SetWindowsPos
    'timers.KillTimer()
    killMMTimerEvent()

END FUNCTION


SUB StartTrial()
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL z, result AS LONG

    PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)


    LET MyTime = CLASS "PowerTime"

    MyTime.Now()
    MyTime.FileTime TO now
       'iVPos = 200
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(0).EvtName = "IntentionSelected"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 4
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)
    EVENTSANDCONDITIONS(0).ElapsedMillis = gTimerTix

    'IF (globals.TrialCntTotal <= (globals.NbrOfRuns * globals.NbrOfTrials)) THEN
        'show trial # on the experimenter screen
        DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)
    'end if


    'SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
    'SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

    globals.Target = gIntentionFocus(globals.TrialCnt)
    globals.Feedback = 3

    CALL WriteOutEvents()


    SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\Sounds\" + gWavFiles(globals.Target))
'    IF (globals.Target = 2) THEN
'        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, EXPERIMENT.ExpEvents(0).GroupVariables(0).GVs(0).Desc
'        SHELL("PlayWaveAsynch.exe " + "Focus2_ID")
'
'        'PLAY WAVE "Focus2_ID" TO result
'        'PLAY WAVE END
'    ELSEIF (globals.Target = 1) THEN
'        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, EXPERIMENT.ExpEvents(0).GroupVariables(0).GVs(1).Desc
'        SHELL("PlayWaveAsynch.exe " + "Relax2_ID")
'        'PLAY WAVE "Relax2_ID" TO result
'        'PLAY WAVE END
'    END IF

        'MSGBOX "done"

END SUB

FUNCTION EndTrial() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL systime AS SYSTEMTIME
    LOCAL lDisplayToAgent, lResult AS LONG
    LOCAL dStart, dEnd AS DOUBLE


    CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""





    IF (globals.TrialCntTotal >= (globals.NbrOfRuns * globals.NbrOfTrials)) THEN
        'lResult = CustomMessageBox(1, "Would you like to see how you did?", "Show Results")
        'lResult = MSGBOX("Would you like to see how you did?", %MB_YESNO, "Show Results")
        'IF (lResult = 1) THEN
        '    CustomMessageBox(1, displayStatisticsResults(globals.TrialCnt * globals.RunCnt, globals.NbrOfHits), "Your Results")
            'MSGBOX displayStatisticsResults(glTrialCnt, glNbrOfHits)
        'END IF

        DIALOG SET TEXT globals.hdl.DlgController, " "
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)

        SELECT CASE gStandardRNGTCPIP
            CASE 1  'Standard
                SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
                SetMMTimerOnOff("SUBJECTDIODE", 0)
            CASE 2  'RNG
                SetMMTimerOnOff("GETRESULT", 0)    'turn off
                SetMMTimerOnOff("DELAY", 0)    'turn off
            CASE 3
        END SELECT

        killMMTimerEvent()


        'CALL WriteOutEvents()

        '**********************************************************************************************
        'Adding a EndExperiment event and an EndExperiment event 6/19/2013 - FAA
        '**********************************************************************************************
        LET MyTime = CLASS "PowerTime"
        MyTime.Now()
        MyTime.FileTime TO now
           'iVPos = 200
        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
        EVENTSANDCONDITIONS(4).EvtName = "EndExperiment"
        EVENTSANDCONDITIONS(4).NbrOfGVars = 0
        EVENTSANDCONDITIONS(4).Index = globals.DioIndex
        EVENTSANDCONDITIONS(4).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(4).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(4).EventTime = PowerTimeDateTime(MyTime)
        EVENTSANDCONDITIONS(4).ElapsedMillis = gTimerTix
        CALL WriteToEventFile2(4)
        '**********************************************************************************************

        CustomMessageBox(0,"The experiment is over.", "Experiment Ended.")

        DIALOG END globals.hdl.DlgSubject, 0

        CLOSE #900  'RNG file
        CLOSE #950  'Alternate RNG file

        FUNCTION = 1

        EXIT FUNCTION
    END IF

    IF ((globals.TrialCnt > globals.NbrOfTrials) AND (globals.RunCnt < globals.NbrOfRuns)) THEN
        globals.TrialCnt = 1

        globals.RunCnt = globals.RunCnt + 1
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
        SELECT CASE gStandardRNGTCPIP
            CASE 1  'Standard
                SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
                SetMMTimerOnOff("SUBJECTDIODE", 0)
            CASE 2  'RNG
                SetMMTimerOnOff("GETRESULT", 0)    'turn off
                SetMMTimerOnOff("DELAY", 0)    'turn off
            CASE 3
        END SELECT

        killMMTimerEvent()

        CustomMessageBox(1, "The run is over. You can take a short break.", "Run Ended")
        CustomMessageBox(0,"The run is over. Subject can take a short break.", "Run Ended.")
        CustomMessageBox(0,"Run " + STR$(globals.RunCnt) + " is about to begin.", "Start Next Run")
        'CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        SELECT CASE gStandardRNGTCPIP
            CASE 1  'Standard
                SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
                SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on
            CASE 2  'RNG
                SetMMTimerOnOff("GETRESULT", 1)    'turn on
                SetMMTimerOnOff("DELAY", 1)    'turn on
            CASE 3
        END SELECT

        setMMTimerEventPeriodic(1, 0)

        CLOSE #900  'RNG file
        CLOSE #950  'Alternate RNG file

        EXIT FUNCTION
    END IF

    'CALL WriteOutEvents()


    globals.TrialCnt = globals.TrialCnt + 1
    globals.TrialCntTotal = globals.TrialCntTotal + 1





    'show trial # on the experimenter screen
    'DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)





     'EnableButtons(1) 'enable buttons
    FUNCTION = 0
END FUNCTION

SUB WriteOutEvents()
  'TargetSelected
    EVENTSANDCONDITIONS(0).GVars(0).Condition = "Intention"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(0).GVars(1).Condition = "Feedback"
    EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, globals.Feedback)
    EVENTSANDCONDITIONS(0).GVars(2).Condition = "Milliseconds"
    EVENTSANDCONDITIONS(0).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(2).Condition, gTimerTix)
    EVENTSANDCONDITIONS(0).GVars(3).Condition = "RunNumber"
    EVENTSANDCONDITIONS(0).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(3).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(0).GVars(4).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(0).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(4).Condition, globals.TrialCnt)

    CALL WriteToEventFile2(0)
END SUB

SUB WriteOutEndTrialEvents()
  'TargetSelected
    EVENTSANDCONDITIONS(2).GVars(0).Condition = "Intention"
    EVENTSANDCONDITIONS(2).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(2).GVars(1).Condition = "Feedback"
    EVENTSANDCONDITIONS(2).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(1).Condition, globals.Feedback)
    EVENTSANDCONDITIONS(2).GVars(2).Condition = "Milliseconds"
    EVENTSANDCONDITIONS(2).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(2).Condition, gTimerTix)
    EVENTSANDCONDITIONS(2).GVars(3).Condition = "RunNumber"
    EVENTSANDCONDITIONS(2).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(3).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(2).GVars(4).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(2).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(4).Condition, globals.TrialCnt)

    CALL WriteToEventFile2(2)
END SUB

SUB DoWorkForEachTick()
    LOCAL x, sumOfBits AS LONG
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE
    LOCAL timing AS LONG

    SELECT CASE gStandardRNGTCPIP
        CASE 1  'Standard
            EXIT SUB
        CASE 2
        CASE 3
            EXIT SUB
    END SELECT

    IF (gPauseFlag = %TRUE) THEN
        EXIT SUB
    END IF


    TRY
        '**********************************************
        '10 is a scaling factor since we can get 10
        'random numbers per ms.
        '**********************************************
        timing = 10 / (gSampleSize / gSampleDuration)

        '**********************************************
        'should be able to get 10 random numbers per ms
        'or 10,000 samples per second
        '**********************************************
        FOR x = 1 TO 10
            INCR gBytesPerMillisecond
            OBJECT CALL oApp.GetRandomByte() TO rndByte
            bRndByte = VARIANT#(rndByte)
            IF (gBytesPerMillisecond MOD timing = 0) THEN
                INCR gRndCnt
                INCR gByteCnt
                'OBJECT CALL oApp.GetRandomByte() TO rndByte
                'bRndByte = VARIANT#(rndByte)
                'if (gRndCnt < gSampleSize) then
                    gSamples(gRndCnt) = bRndByte
                'end if


                'gSamples(gRndCnt) = bRndByte
                'gRndTotal = gRndTotal +  bRndByte
                'gRndAvg = gRndTotal / gByteCnt

                #DEBUG PRINT STR$(gRndCnt) + ", " + STR$(bRndByte)
            END IF
        NEXT x


    CATCH
        MSGBOX STR$(gRndCnt)
        MSGBOX "Error generating random numbers. Error: " + ERROR$ + $CRLF + "Please close the application."
        SetMMTimerOnOff("GETRESULT", 0)    'turn on
        killMMTimerEvent()
        DIALOG END globals.hdl.DlgSubject, -1
    END TRY

    '#debug print str$(gRndCnt) + ", " + str$(bRndByte)

    'MSGBOX STR$(gRndTotal(0)) + ", " + STR$(gRndCnt(0))
    'MSGBOX STR$(gRndTotal(1)) + ", " +  STR$(gRndCnt(1))

END SUB


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL lResult, rndJitter, subPtr  AS LONG
    LOCAL x, totalBits, arsTotalBits AS LONG
    LOCAL absAccumDev, sqrAccumNbrBits, zScore AS DOUBLE
    LOCAL absARSAccumDev, sqrARSAccumNbrBits, zARSScore AS DOUBLE
    LOCAL MyTime, MyTimeRNDFile, MyTimeARSFile AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL tempForFile, arsTempForFile AS STRING

    SELECT CASE itemName
        CASE "DELAY"
            SetMMTimerOnOff("DELAY", 0)    'turn off
            gPauseFlag = %FALSE
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
            SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on
            CALL StartTrial()
            gTimerSeconds = 0
            gTimerMinutes = 0
            SELECT CASE gStandardRNGTCPIP
                CASE 1  'Standard
                    SetMMTimerDuration("ENDINTENTION", globals.TrialLength)
                    SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
                CASE 2  'RNG
                    SetMMTimerDuration("GETRESULT", 1000)
                    SetMMTimerOnOff("GETRESULT", 1)    'turn on
                CASE 3
            END SELECT
        CASE "GETRESULT"
            'accumulating time in seconds
            INCR gRunningDuration
            arsTempForFile = ""

            arsTotalBits = 0
            'use odd samples for alternate stream of random number
            FOR x = 1 TO gSampleSize
                IF (Odd(x) = 1) THEN
                   #DEBUG PRINT "gSamples(x): " + STR$(gSamples(x))
                   arsTotalBits += sumBitsOfByte(gSamples(x))
                END IF
            NEXT x

            gARSAccumNbrBits += 200
            '#DEBUG PRINT "gAccumNbrBits: " + STR$(gAccumNbrBits)

            gARSAccumDev += (arsTotalBits - 100)
            '#DEBUG PRINT "gAccumDev: " + STR$(gAccumDev)

            absARSAccumDev = ABS(gARSAccumDev)
            '#DEBUG PRINT "absAccumDev: " + STR$(absAccumDev)

            sqrARSAccumNbrBits = SQR(gARSAccumNbrBits)
            '#DEBUG PRINT "sqrAccumNbrBits: " + STR$(sqrAccumNbrBits)

            zARSScore = ABS(gARSAccumDev) * 1.0 / SQR((gARSAccumNbrBits * 1.0) / 4.0)
            IF (absARSAccumDev > sqrARSAccumNbrBits) THEN
                '#DEBUG PRINT "zScore: " + STR$(zScore)
                IF (gARSFirstHit = 1) THEN
                    gARSOldZScore = zARSScore
                    gARSFirstHit = 0
                ELSE
                    gARSNewZScore = zARSScore
                END IF
            END IF

            '#DEBUG PRINT "gOldZScore: " + STR$(gOldZScore)
            '#DEBUG PRINT "gNewZScore: " + STR$(gNewZScore)

            IF (gARSNewZScore > gARSOldZscore) THEN
                gARSSavedZScore = gARSNewZScore
                gARSOldZScore = gARSSavedZScore
            END IF

            '#DEBUG PRINT "gSavedZScore: " + STR$(gSavedZScore)
            LET MyTimeARSFile = CLASS "PowerTime"
            MyTimeARSFile.Now()
            MyTimeARSFile.FileTime TO now

            arsTempForFile = TIME$ + "," + STR$(gRunningDuration) + ","  + FORMAT$(arsTotalBits, "0000") + "," + FORMAT$(zARSScore, "00.0000") + ","

            SELECT CASE globals.Target
                CASE 1 'REST
                    arsTempForFile += "REST"
                CASE 2 'FOCUS
                    IF (gHighOrLow = 1) THEN 'High
                        arsTempForFile += "FOCUSHIGH"
                    ELSE
                        arsTempForFile += "FOCUSLOW"
                    END IF
            END SELECT


            IF (gARSFile <> "") THEN
                PRINT #950, arsTempForFile
            END IF


            gRndCnt = 0
            INCR gSampleCnt

            tempForFile = ""

            #DEBUG PRINT STR$(gTimerMinutes) + " mins " + STR$(gTimerSeconds) + " secs"

            totalBits = 0
            'use even samples for deviation processing
            FOR x = 1 TO gSampleSize
                IF (Odd(x) = 0) THEN
                   '#debug print "gSamples(x): " + str$(gSamples(x))
                   totalBits += sumBitsOfByte(gSamples(x))
                END IF
            NEXT x


            '#DEBUG PRINT "totalBits: " + STR$(totalBits)

            gAccumNbrBits += 200
            '#DEBUG PRINT "gAccumNbrBits: " + STR$(gAccumNbrBits)

            gAccumDev += (totalBits - 100)
            '#DEBUG PRINT "gAccumDev: " + STR$(gAccumDev)

            absAccumDev = ABS(gAccumDev)
            '#DEBUG PRINT "absAccumDev: " + STR$(absAccumDev)

            sqrAccumNbrBits = SQR(gAccumNbrBits)
            '#DEBUG PRINT "sqrAccumNbrBits: " + STR$(sqrAccumNbrBits)

            zScore = ABS(gAccumDev) * 1.0 / SQR((gAccumNbrBits * 1.0) / 4.0)
            IF (absAccumDev > sqrAccumNbrBits) THEN
                '#DEBUG PRINT "zScore: " + STR$(zScore)
                IF (gFirstHit = 1) THEN
                    gOldZScore = zScore
                    gFirstHit = 0
                ELSE
                    gNewZScore = zScore
                END IF
            END IF

            '#DEBUG PRINT "gOldZScore: " + STR$(gOldZScore)
            '#DEBUG PRINT "gNewZScore: " + STR$(gNewZScore)

            IF (gNewZScore > gOldZscore) THEN
                gSavedZScore = gNewZScore
                gOldZScore = gSavedZScore
            END IF

            '#DEBUG PRINT "gSavedZScore: " + STR$(gSavedZScore)
            LET MyTimeRNDFile = CLASS "PowerTime"
            MyTimeRNDFile.Now()
            MyTimeRNDFile.FileTime TO now

            tempForFile = TIME$ + "," + STR$(gRunningDuration) + "," + FORMAT$(totalBits, "0000") + "," + FORMAT$(zScore, "00.0000") + ","
            SELECT CASE globals.Target
                CASE 1 'REST
                    tempForFile += "REST"
                CASE 2 'FOCUS
                    IF (gHighOrLow = 1) THEN 'High
                        tempForFile += "FOCUSHIGH"
                    ELSE
                        tempForFile += "FOCUSLOW"
                    END IF
            END SELECT

            IF (gRNDFile <> "") THEN
                PRINT #900, tempForFile
            END IF



            'IF (gTimerMinutes = 3) THEN 'every 60 sec/min * 3 min
            '================================================================
            '3/20/2014 changing from 3 minute fixed trial length to
            'variable length trials.
            '================================================================
            IF (gRunningDuration MOD (globals.TrialLength / 1000) = 0) THEN
                PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
                SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

                 '**********************************************************************************************
                'Adding a StartExperiment event and an EndExperiment event 6/19/2013 - FAA
                '**********************************************************************************************
                LET MyTime = CLASS "PowerTime"
                MyTime.Now()
                MyTime.FileTime TO now
                   'iVPos = 200
                globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
                globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
                EVENTSANDCONDITIONS(2).EvtName = "EndTrial"
                EVENTSANDCONDITIONS(2).NbrOfGVars = 4
                EVENTSANDCONDITIONS(2).Index = globals.DioIndex
                EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
                EVENTSANDCONDITIONS(2).ClockTime = globals.TargetTime
                EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(MyTime)
                EVENTSANDCONDITIONS(2).ElapsedMillis = gTimerTix

                '**********************************************************************************************


                SetMMTimerOnOff("GETRESULT", 0)    'turn off
                gPauseFlag = %TRUE
                SetMMTimerDuration("DELAY", 6000)
                SetMMTimerOnOff("DELAY", 1)    'turn on

                'only play audio feedback on non-rest
                SELECT CASE globals.Target
                    CASE 2 'FOCUS
                        IF (gSavedZScore = 0) THEN
                            #DEBUG PRINT "NEUTRAL AUDIO"
                            globals.Feedback = 1
                            SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\Sounds\VocodSynthSwish.wav")
                        ELSE
                            #DEBUG PRINT "UPBEAT AUDIO"
                            globals.Feedback = 2
                            SHELL("PlayWaveAsynch.exe " + EXE.PATH$ + "\Sounds\MusicalAccentTwinkle.wav")
                        END IF
                END SELECT

                WriteOutEndTrialEvents()



                CALL EndTrial()

                'CALL StartTrial()
                'SetMMTimerDuration("STARTTRIAL", 4000)
                'SetMMTimerOnOff("STARTTRIAL", 1)    'turn on

                gARSFirstHit = 1
                gARSNewZScore = 0
                gARSOldZScore = 0
                gARSSavedZScore = 0
                gARSAccumNbrBits = 0
                gARSAccumDev = 0
                gRunningDuration = 0

                gFirstHit = 1
                gNewZScore = 0
                gOldZScore = 0
                gSavedZScore = 0
                gAccumNbrBits = 0
                gAccumDev = 0
            ELSE
                SetMMTimerOnOff("GETRESULT", 1)    'turn on
            END IF
        CASE "ENDINTENTION"
            'msgbox "here"
            SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
            gPauseFlag = %TRUE

            CALL EndTrial()

            SetMMTimerDuration("DELAY", 3000)
            SetMMTimerOnOff("DELAY", 1)    'turn on
        CASE "SUBJECTDIODE"
            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
            SetMMTimerOnOff("SUBJECTDIODE", 0)    'turn off
    END SELECT
END SUB

FUNCTION PowerTimeDateTimeApp(MyTime AS IPOWERTIME) AS STRING
    'This is a version for this application
    LOCAL tempDateTime AS STRING

    tempDateTime = TRIM$(FORMAT$(MyTime.Hour(), "00")) + ":" + TRIM$(FORMAT$(MyTime.Minute(), "00")) + _
                                            ":" + TRIM$(FORMAT$(MyTime.Second(), "00")) + "." + TRIM$(FORMAT$(MyTime.MSecond(), "000"))
    FUNCTION = tempDateTime

END FUNCTION



SUB readInWavFiles()
    LOCAL cnt, Value AS LONG
    LOCAL Desc, LongDesc, WavFile AS STRING

    REDIM gWavFiles(20)

    OPEN EXE.PATH$ + "\Conditions\Intention.txt" FOR INPUT AS #1

    INPUT #1, LongDesc

    cnt = 0
    DO
        INPUT# #1, Desc, Value, WavFile
        IF (LCASE$(Desc) = "xxx" AND Value = 999) THEN
            EXIT LOOP
        END IF
        cnt = cnt + 1
        gWavFiles(cnt) = WavFile
    LOOP

    CLOSE #1
END SUB
