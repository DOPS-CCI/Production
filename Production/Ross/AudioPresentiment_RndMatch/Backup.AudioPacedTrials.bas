#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "AudioPacedTrials.pbr"
#INCLUDE "win32api.inc"




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

%WAVE_FOCUS = 2000
%WAVE_RELAX = 2001

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
GLOBAL pid AS DWORD
GLOBAL gStart, gEnd AS QUAD
GLOBAL gIntentionFocus() AS LONG

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


SUB DoWorkForEachTick()
'DON'T NEED TO DO ANYTHING - YET
END SUB

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
    EVENTSANDCONDITIONS(0).NbrOfGVars = 2
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)

    'show trial # on the experimenter screen
    DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)

    'SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
    'SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

    globals.Target = gIntentionFocus(globals.TrialCnt)

    'result = sndPlaySoundA ("Sounds\Focus.wav", &H1)  'once, in background
    'iReturn = sndPlaySound(SoundFile, &H0)  'once, wait until done
    'iReturn = sndPlaySound(SoundFile, &H8)  'play continuously
    'iReturn = sndPlaySound(vbNullString, False) 'stop playing sound

    IF (globals.Target = 2) THEN
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, EXPERIMENT.ExpEvents(0).GroupVariables(0).GVs(0).Desc
        SHELL("PlayWaveAsynch.exe " + "Focus2_ID")

        'PLAY WAVE "Focus2_ID" TO result
        'PLAY WAVE END
    ELSEIF (globals.Target = 1) THEN
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, EXPERIMENT.ExpEvents(0).GroupVariables(0).GVs(1).Desc
        SHELL("PlayWaveAsynch.exe " + "Relax2_ID")
        'PLAY WAVE "Relax2_ID" TO result
        'PLAY WAVE END
    END IF

        'MSGBOX "done"

END SUB

FUNCTION EndTrial() AS LONG
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

        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)

        SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)
        killMMTimerEvent()


        CALL WriteOutEvents()

        CustomMessageBox(0,"The experiment is over.", "Experiment Ended.")

        DIALOG END globals.hdl.DlgSubject, 0

        FUNCTION = 1

        EXIT FUNCTION
    END IF

    IF ((globals.TrialCnt = globals.NbrOfTrials) AND (globals.RunCnt < globals.NbrOfRuns)) THEN
        globals.TrialCnt = 1

        globals.RunCnt = globals.RunCnt + 1
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
        SetMMTimerOnOff("ENDINTENTION", 0)    'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)    'turn off
        killMMTimerEvent()

        CustomMessageBox(1, "The run is over. You can take a short break.", "Run Ended")
        CustomMessageBox(0,"The run is over. Subject can take a short break.", "Run Ended.")
        CustomMessageBox(0,"Run " + STR$(globals.RunCnt) + " is about to begin.", "Start Next Run")
        'CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
        SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on
        setMMTimerEventPeriodic(1, 0)
        EXIT FUNCTION
    END IF

     CALL WriteOutEvents()


    globals.TrialCnt = globals.TrialCnt + 1
    globals.TrialCntTotal = globals.TrialCntTotal + 1





    'show trial # on the experimenter screen
    DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)





     'EnableButtons(1) 'enable buttons
    FUNCTION = 0
END FUNCTION

SUB WriteOutEvents()
  'TargetSelected
    EVENTSANDCONDITIONS(0).GVars(0).Condition = "Intention"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(0).GVars(1).Condition = "RunNumber"
    EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(0).GVars(2).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(0).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(2).Condition, globals.TrialCnt)

    CALL WriteToEventFile2(0)
END SUB


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL lResult, rndJitter, subPtr AS LONG
    LOCAL x AS LONG

    SELECT CASE itemName
        CASE "ENDINTENTION"
            'msgbox "here"
            CALL StartTrial()
            CALL EndTrial()
            SetMMTimerDuration("ENDINTENTION", globals.TrialLength)
            SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
            SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

            'msgbox "here 2"

        CASE "SUBJECTDIODE"
            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
    END SELECT
END SUB
