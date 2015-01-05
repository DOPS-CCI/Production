#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

'#RESOURCE "GenericGESP.pbr"
#INCLUDE "win32api.inc"



#RESOURCE ICON, IDI_ICON1, "GenericGESP.ico"
#RESOURCE BITMAP, BITMAP_HIGHLIGHT, "Images\highlight.bmp"
#RESOURCE BITMAP, BITMAP_PROCEED, "Images\proceed.bmp"
#RESOURCE BITMAP, BITMAP_WAIT, "Images\wait.bmp"
#RESOURCE BITMAP, BITMAP_PDB,  "Images\PD_black.bmp"
#RESOURCE BITMAP, BITMAP_PDW, "Images\PD_white.bmp"
#RESOURCE BITMAP, BITMAP_OKBUTTON, "Images\OKButton.bmp"
#RESOURCE BITMAP, BITMAP_GRID1, "Images\grid.bmp"
#RESOURCE BITMAP, BITMAP_GRID2, "Images\grid-BGORY.bmp"
#RESOURCE BITMAP, BITMAP_GRID3, "Images\grid-GYOBR.bmp"
#RESOURCE BITMAP, BITMAP_GRID4, "Images\grid-ORGBY.bmp"
#RESOURCE BITMAP, BITMAP_GRID5, "Images\grid-RGOYB.bmp"
#RESOURCE BITMAP, BITMAP_RED, "Images\TargetRed.bmp"
#RESOURCE BITMAP, BITMAP_YELLOW, "Images\TargetYellow.bmp"
#RESOURCE BITMAP, BITMAP_ORANGE, "Images\TargetOrange.bmp"
#RESOURCE BITMAP, BITMAP_BLUE, "Images\TargetBlue.bmp"
#RESOURCE BITMAP, BITMAP_GREEN, "Images\TargetGreen.bmp"
#RESOURCE BITMAP, BITMAP_GREY, "Images\TargetGrey.bmp"
#RESOURCE WAVE,     UPBEAT_WAV, "Sounds\MusicalAccentTwinkle.wav"
#RESOURCE WAVE,     NORMAL_WAV, "Sounds\VocodSynthSwish.wav"
#RESOURCE WAVE,     PLEASEWAIT_WAV, "Sounds\PleaseWait.wav"
#RESOURCE WAVE,     ENDEXPT_WAV, "Sounds\EndExperiment.wav"
#RESOURCE WAVE,     ENDRUN_WAV, "Sounds\EndRun.wav"





%DIO_CARD_PRESENT = 0                            'NO

%IMAGE_PD = 1001
%IMAGE_BACK = 1002
%IMAGE_PROCEED = 1003
%ID_GRID = 1004
%ID_HIGHLIGHT = 1005
%ID_OK = 1009
%TEXTBOX_SUBJECTID = 1010
%TEXTBOX_NBRRUNS = 1011
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
%IDC_BUTTON_EEGSettings = 1027
%IDC_BUTTON_LongDesc = 1028
%IDC_CHECKBOX_UseRNG = 1029
%IDC_CHECKBOX_Precog = 1030
%ID_GRID2 = 1031
%IDC_9900 = 9900
%IDC_9901 = 9901
%IDC_9902 = 9902
%IDC_9903 = 9903
%IDC_9904 = 9904
%IDC_9905 = 9905
%IDC_BUTTON_Abort = 9906

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
    TargetRow AS LONG
    TargetColumn AS LONG
    Response AS LONG
    ResponseRow AS LONG
    ResponseColumn AS LONG
    NbrOfHits AS LONG
    RunCnt AS LONG
    TrialCnt AS LONG
    TrialCntTotal AS LONG
    HitMiss AS LONG
    TargetShownUpstairs AS LONG
    FeedBack AS LONG
    UseRNG AS BYTE
    Precognitive AS BYTE
    AgentInRoom AS LONG
    SubjectID AS LONG
    AgentID AS LONG
    NbrOfRuns AS LONG
    NbrOFTrials AS LONG
    ImageDuration AS LONG
    ITDelay AS LONG
    AgentDelay AS LONG
    BoardNum AS LONG
    DioCardPresent AS LONG
    GreyCode AS LONG
    DioIndex AS LONG
    TargetTime AS ASCIIZ * 19
    ResponseTime AS ASCIIZ * 19
    ElapsedTime AS ASCIIZ * 19
    CCFlag AS BYTE
    CCResponses(5) AS BYTE
    hdl AS GlobalHandles
END TYPE



GLOBAL globals AS GlobalVariables
GLOBAL pid AS DWORD
GLOBAL gStart, gEnd AS QUAD
GLOBAL gHelperOpened AS INTEGER
GLOBAL oApp AS IDISPATCH
GLOBAL     gRemoteTrialsFile AS STRING
'=================================================
'This flag will be used to control functionality
'when running the Color Cards protocol. This needs
'to be handled a bit differently than the other
'GESP protocols. In Color Cards, we need to change
'the subject's screen randomly so that cards
'can't be guessed by position.
'=================================================



'DECLARE SUB DoTimerWork(itemName AS WSTRING)

#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "DOPS_MMTimers.inc"
#INCLUDE "DOPS_GESP.INC"
'#include "DOPS_BDFEDF.inc"
#INCLUDE "ControllerScreen.inc"
#INCLUDE "HelperScreen.inc"
#INCLUDE "SubjectScreen.inc"
#INCLUDE "AgentScreen.inc"
#INCLUDE "BiosemiRecording.inc"

'#INCLUDE "MyTimerClass.inc"

DECLARE SUB DoNextTrial()


' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL errTrapped AS LONG
    LOCAL tempFilename  AS STRING
    LOCAL filename, temp AS ASCIIZ * 255
    LOCAL sResult AS ASCIIZ * 255


    '************************************************
    'Read values from the INI file to initialize
    'experiment variables
    '************************************************

    tempFilename = COMMAND$
    IF (TRIM$(tempFilename) = "") THEN
        MSGBOX "Please use GenericGESP filename.ini to start the program."
        RETURN
    END IF

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
        FUNCTION = errTrapped
        EXIT FUNCTION
    END IF

    gRemoteTrialsFile = "I:\TrialInfo.txt"

    '************************************************
    'Initialize Mersenne-twister
    '************************************************
    init_MT_by_array()



    EXPERIMENT.SessionDescription.INIFile = tempFilename
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

FUNCTION RNGRandomNumber(nbrOfTargets AS LONG)AS LONG
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE

    DO
        OBJECT CALL oApp.GetRandomByte() TO rndByte
        bRndByte = VARIANT#(rndByte)
    LOOP UNTIL (bRndByte >= 1 AND bRndByte <= nbrOfTargets)

    FUNCTION = bRndByte

END FUNCTION

FUNCTION GetTarget() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    #DEBUG PRINT "GetTarget()"

    LET MyTime = CLASS "PowerTime"

    IF (globals.UseRNG = 0) THEN    'don't use hardware RNG
        globals.Target = RandomNumber(EXPERIMENT.Misc.NbrOfTargets)
    ELSE
        globals.Target = RNGRandomNumber(EXPERIMENT.Misc.NbrOfTargets)
    END IF

    #DEBUG PRINT "globals.Target: " + STR$(globals.Target)

    globals.TargetRow = getRow(globals.Target, EXPERIMENT.Stimulus.Columns)
    #DEBUG PRINT "globals.TargetRow: " + STR$(globals.TargetRow)
    globals.TargetColumn = getColumn(globals.Target, EXPERIMENT.Stimulus.Columns)
    #DEBUG PRINT "globals.TargetColumn: " + STR$(globals.TargetColumn)

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)

    MyTime.Now()
    MyTime.FileTime TO now
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))



    EVENTSANDCONDITIONS(0).EvtName = "TargetSelected"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 13
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)


    'DebugLog("TargetSelected")
    'added 2/27/13 - delay between target selected
    'and display to upstairs
    'delayMilliSeconds(1000)
    'randomDelayMilliseconds(10, 100)

    'CALL DisplayToAgent()
END FUNCTION

SUB SubjectResponse(lParam AS DWORD)
    LOCAL rndJitter AS LONG
    LOCAL arrayCnt AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now, elapsedTime AS QUAD

    #DEBUG PRINT "SubjectResponse()"

    LET MyTime = CLASS "PowerTime"

    arrayCnt = FindSubjectResponseInGrid(lParam)

    IF (globals.CCFlag = 1) THEN    'handling color cards differently then the rest of GESP protocols
        arrayCnt =  globals.CCResponses(arrayCnt)
    END IF

    IF (arrayCnt > 0) THEN
        globals.Response = arrayCnt
        globals.ResponseRow = getRow(arrayCnt, EXPERIMENT.Stimulus.Columns)
        #DEBUG PRINT "globals.ResponseRow: " + STR$(globals.ResponseRow)
        globals.ResponseColumn = getColumn(arrayCnt, EXPERIMENT.Stimulus.Columns)
        #DEBUG PRINT "globals.ResponseColumn: " + STR$(globals.ResponseColumn)
        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)

        MyTime.Now()
        MyTime.FileTime TO now
        globals.ResponseTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
        EVENTSANDCONDITIONS(2).EvtName = "ResponseSelected"
        EVENTSANDCONDITIONS(2).NbrOfGVars = 13
        EVENTSANDCONDITIONS(2).Index = globals.DioIndex
        EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(2).ClockTime = globals.ResponseTime
        EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(MyTime)
        elapsedTime =  VAL(globals.ResponseTime) - VAL(globals.TargetTime)
        globals.ElapsedTime = FORMAT$((elapsedTime / 10000), "###################") 'STR$(elapsedTime / 1000)




        IF (globals.Precognitive = 1) THEN  'using Precognitive - response happens before target selected
            GetTarget()
        END IF

        'DebugLog("ResponseSelected")


       ' if target was shown to agent - now turn it off
        IF (globals.TargetShownUpstairs = 2) THEN
                PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)
                IF (globals.CCFlag = 1) THEN    'handling color cards differently then the rest of GESP protocols
                    CONTROL SET IMAGE  globals.hdl.DlgAgent, %ID_GRID2, "BITMAP_GREY"
                    CONTROL REDRAW globals.hdl.DlgAgent, %ID_GRID2
                END IF
                'DebugLog("PhotoDiodeOnOff Agent Off")
                'DebugLog("PhotoDiodeOnOff Feedback Off")
        END IF



        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
        SetMMTimerOnOff("SUBJECTDIODE", 1)     'turn on
        'DebugLog("SUBJECTDIODE On")

        IF (globals.Feedback = 2) THEN
            SetMMTimerOnOff("SUBJECTFEEDBACK", 1)   'turn on
            IF (globals.CCFlag = 1) THEN  'handling color cards differently then the rest of GESP protocols
                FeedbackColorCards(globals.Target, globals.hdl.DlgSubject)
            ELSE
                Feedback(globals.Target, globals.hdl.DlgSubject)
            END IF
            'DebugLog("SUBJECTFEEDBACK On")
        END IF

        'MyTime.Now()
        'MyTime.FileTime TO gStart

        EnableButtons(0) 'disable buttons
        'E.K. requested a 250 ms jitter be added
        'to the enforced delay (4/6/12)
        rndJitter = RandomNumber2(10, 250)
        'randomDelayMilliseconds(10, 250)
        SetMMTimerDuration("SUBJECTWAITPROCEED", globals.ITDelay + rndJitter)
        SetMMTimerOnOff("SUBJECTWAITPROCEED", 1)    'turn on

        'DebugLog("SUBJECTWAITPROCEED On")

        IF (globals.Response = globals.Target) THEN
            globals.HitMiss = 2
            globals.NbrOfHits = globals.NbrOfHits + 1
        ELSE
            globals.HitMiss = 1
        END IF

        #DEBUG PRINT "globals.RunCnt: " + STR$(globals.RunCnt)
        #DEBUG PRINT "globals.TrialCnt: " + STR$(globals.TrialCnt)
        #DEBUG PRINT "globals.TrialCntTotal: " + STR$(globals.TrialCntTotal)

        WriteOutEvents()
    END IF
END SUB



SUB DisplayToAgent()
    LOCAL lRnd AS LONG
    LOCAL targ, targetStr AS STRING
    LOCAL bmpName AS ASCIIZ * 255
    LOCAL MyTime AS IPOWERTIME
    LOCAL now, startFB, endFB AS QUAD

    #DEBUG PRINT "DisplayToAgent()"


    LET MyTime = CLASS "PowerTime"

    EVENTSANDCONDITIONS(1).EvtName = "TargetDisplayedUpstairs"

    lRnd = RND(1, 2)
    globals.TargetShownUpstairs = lRnd



    MyTime.Now()
    MyTime.FileTime TO now

    SELECT CASE globals.TargetShownUpstairs
        CASE 2 'show to agent
            'DebugLog("TargetDisplayedUpstairs")
            globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
            globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
            EVENTSANDCONDITIONS(1).EvtName = "TargetDisplayedUpstairs"
            EVENTSANDCONDITIONS(1).NbrOfGVars = 13
            EVENTSANDCONDITIONS(1).Index = globals.DioIndex
            EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
            EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
            EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)

            'MyTime.Now()
            'MyTime.FileTime TO startFB
            PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  1)
            IF (globals.CCFlag = 1) THEN    'handling color cards differently then the rest of GESP protocols
                SELECT CASE globals.Target
                    CASE 1
                        bmpName = "BITMAP_RED"
                    CASE 2
                        bmpName = "BITMAP_YELLOW"
                    CASE 3
                        bmpName = "BITMAP_BLUE"
                    CASE 4
                        bmpName = "BITMAP_ORANGE"
                    CASE 5
                        bmpName = "BITMAP_GREEN"
                END SELECT

                #DEBUG PRINT "bmpName: " + bmpName

                CONTROL SET IMAGE globals.hdl.DlgAgent, %ID_GRID2, bmpName
                CONTROL REDRAW globals.hdl.DlgAgent, %ID_GRID2
            ELSE
                Feedback(globals.Target, globals.hdl.DlgAgent)
            END IF
            'DebugLog("PhotoDiodeOnOff Agent On")
            'DebugLog("PhotoDiodeOnOff Feedback On")
            'MyTime.Now()
            'MyTime.FileTime TO endFB

            'msgbox str$(endFB - startFB)
            'SetTimerOnOff("AGENTDIODE", 1)
        CASE 1  'don't show to agent
           'globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
            globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
            EVENTSANDCONDITIONS(1).EvtName = "TargetDisplayedUpstairs"
            EVENTSANDCONDITIONS(1).NbrOfGVars = 13
            EVENTSANDCONDITIONS(1).Index = globals.DioIndex
            EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
            EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
            EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)

            'CONTROL SET IMGBUTTONX  globals.hdl.DlgAgent, %ID_GRID, "BITMAP_GRID"
            IF (globals.CCFlag = 1) THEN    'handling color cards differently then the rest of GESP protocols
                CONTROL SET IMAGE globals.hdl.DlgAgent, %ID_GRID2, "BITMAP_GREY"
                CONTROL REDRAW globals.hdl.DlgAgent, %ID_GRID2
            END IF

            IF (globals.CCFlag = 1) THEN    'handling color cards differently then the rest of GESP protocols
                CONTROL REDRAW globals.hdl.DlgAgent, %ID_GRID2
            ELSE
                CONTROL REDRAW globals.hdl.DlgAgent, %ID_GRID
            END IF

            PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)
            'DebugLog("PhotoDiodeOnOff Agent Off")
            'DebugLog("PhotoDiodeOnOff Feedback Off")
     END SELECT




END SUB



FUNCTION NextTrial() AS LONG
    LOCAL systime AS SYSTEMTIME
    LOCAL lDisplayToAgent, lResult AS LONG
    LOCAL vTimers AS VARIANT
    LOCAL dStart, dEnd AS DOUBLE

    #DEBUG PRINT "NextTrial()"


    IF ((globals.TrialCnt * globals.RunCnt) = (globals.NbrOfRuns * globals.NbrOfTrials)) THEN
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
        PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)
        DIALOG HIDE globals.hdl.DlgSubject
        DIALOG HIDE globals.hdl.DlgAgent
        lResult = CustomMessageBox(1, "Would you like to see how you did?", "Show Results")
        'lResult = MSGBOX("Would you like to see how you did?", %MB_YESNO, "Show Results")
        IF (lResult = 1) THEN
            CustomMessageBox(1, displayStatisticsResults(globals.TrialCnt * globals.RunCnt, globals.NbrOfHits), "Your Results")
            'MSGBOX displayStatisticsResults(glTrialCnt, glNbrOfHits)
        END IF



        SetMMTimerOnOff("SUBJECTFEEDBACK", 0)   'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)   'turn off
        SetMMTimerOnOff("AGENTDIODE", 0)   'turn off
        SetMMTimerOnOff("SUBJECTWAITPROCEED", 0)   'turn off
        SetMMTimerOnOff("NEXTTRIAL", 0)    'turn off

        killMMTimerEvent()

        LET gTimers = NOTHING

        PlaySound "ENDEXPT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC

        writeTrialSemaphore(gRemoteTrialsFile, -999)

        CustomMessageBox(0,"The experiment is over.", "Experiment Ended.")


        'DIALOG END globals.hdl.DlgSubject, 0

        FUNCTION = 1

        EXIT FUNCTION
    END IF

    IF ((globals.TrialCnt = globals.NbrOfTrials) AND (globals.RunCnt < globals.NbrOfRuns)) THEN
        globals.TrialCnt = -1
        globals.RunCnt = globals.RunCnt + 1

        SetMMTimerOnOff("SUBJECTFEEDBACK", 0)   'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)   'turn off
        SetMMTimerOnOff("AGENTDIODE", 0)   'turn off
        SetMMTimerOnOff("SUBJECTWAITPROCEED", 0)   'turn off
        SetMMTimerOnOff("NEXTTRIAL", 0)    'turn off

        killMMTimerEvent()

        PlaySound "ENDRUN_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC

        'CustomMessageBox(1, "The run is over. You can take a short break.", "Run Ended")
        CustomMessageBox(0,"The run is over. Subject can take a short break.", "Run Ended.")
        CustomMessageBox(0,"Run " + STR$(globals.RunCnt) + " is about to begin.", "Start Next Run")
        CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        LET gTimers = NOTHING

        LET gTimers = CLASS "PowerCollection"


        'set up a timer for how long the feedback should display
        gTimers.Add("SUBJECTFEEDBACK", vTimers)
        SetMMTimerDuration("SUBJECTFEEDBACK", globals.ImageDuration)

        'set up a timer for how long subject photodiode stays on
        gTimers.Add("SUBJECTDIODE", vTimers)
        SetMMTimerDuration("SUBJECTDIODE", globals.ImageDuration)

        'set up a timer for how long agent photodiode stays on
        gTimers.Add("AGENTDIODE", vTimers)
        SetMMTimerDuration("AGENTDIODE", globals.ImageDuration)

        gTimers.Add("SUBJECTWAITPROCEED", vTimers)
        SetMMTimerDuration("SUBJECTWAITPROCEED", 5000)
        SetMMTimerOnOff("SUBJECTWAITPROCEED", 1)   'turn on



        gTimers.Add("NEXTTRIAL", vTimers)


        'Start the timers
        setMMTimerEventPeriodic(1, 0)

        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_GRID, %SW_SHOW

        EnableButtons(0)

    END IF


    globals.TrialCnt = globals.TrialCnt + 1
    globals.TrialCntTotal = globals.TrialCntTotal + 1

    'show trial # on the experimenter screen
    DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)
    '=====================================================================
    'added 5/1/2014 per Ross Dunseath - we're writing the trial number
    'to a network drive. A program on another machine will be checking
    'this file to see the experiment progress.
    '=====================================================================
    writeTrialSemaphore(gRemoteTrialsFile, globals.TrialCntTotal)


     'EnableButtons(1) 'enable buttons
    FUNCTION = 0
END FUNCTION

SUB WriteOutEvents()

    #DEBUG PRINT "WriteOutEvents()"

    'TargetSelected
    EVENTSANDCONDITIONS(0).GVars(0).Condition = "Target"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(0).GVars(1).Condition = "TargetRow"
    EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, globals.TargetRow)
    EVENTSANDCONDITIONS(0).GVars(2).Condition = "TargetColumn"
    EVENTSANDCONDITIONS(0).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(2).Condition, globals.TargetColumn)


    EVENTSANDCONDITIONS(0).GVars(3).Condition = "Response"
    EVENTSANDCONDITIONS(0).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(3).Condition, globals.Response)
    EVENTSANDCONDITIONS(0).GVars(4).Condition = "ResponseRow"
    EVENTSANDCONDITIONS(0).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(4).Condition, globals.ResponseRow)
    EVENTSANDCONDITIONS(0).GVars(5).Condition = "ResponseColumn"
    EVENTSANDCONDITIONS(0).GVars(5).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(5).Condition, globals.ResponseColumn)

    EVENTSANDCONDITIONS(0).GVars(6).Condition = "AgentInRoom"
    EVENTSANDCONDITIONS(0).GVars(6).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(6).Condition, globals.AgentInRoom)
    EVENTSANDCONDITIONS(0).GVars(7).Condition = "TargetShownUpstairs"
    EVENTSANDCONDITIONS(0).GVars(7).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(7).Condition, globals.TargetShownUpstairs)
    EVENTSANDCONDITIONS(0).GVars(8).Condition = "Feedback"
    EVENTSANDCONDITIONS(0).GVars(8).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(8).Condition, globals.Feedback)
    EVENTSANDCONDITIONS(0).GVars(9).Condition = "HitMiss"
    EVENTSANDCONDITIONS(0).GVars(9).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(9).Condition, globals.HitMiss)
    EVENTSANDCONDITIONS(0).GVars(10).Condition = "EnforcedDelay"
    EVENTSANDCONDITIONS(0).GVars(10).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(10).Condition, EXPERIMENT.Misc.Delay1Max)
    EVENTSANDCONDITIONS(0).GVars(11).Condition = "RunNumber"
    EVENTSANDCONDITIONS(0).GVars(11).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(11).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(0).GVars(12).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(0).GVars(12).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(12).Condition, globals.TrialCnt)
    EVENTSANDCONDITIONS(0).GVars(13).Condition = "TimeToResponse"
    EVENTSANDCONDITIONS(0).GVars(13).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(13).Condition, VAL(globals.ElapsedTime))


    CALL WriteToEventFile2(0)

    'ResponseSelected
    EVENTSANDCONDITIONS(2).GVars(0).Condition = "Target"
    EVENTSANDCONDITIONS(2).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(2).GVars(1).Condition = "TargetRow"
    EVENTSANDCONDITIONS(2).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(1).Condition, globals.TargetRow)
    EVENTSANDCONDITIONS(2).GVars(2).Condition = "TargetColumn"
    EVENTSANDCONDITIONS(2).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(2).Condition, globals.TargetColumn)


    EVENTSANDCONDITIONS(2).GVars(3).Condition = "Response"
    EVENTSANDCONDITIONS(2).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(3).Condition, globals.Response)
    EVENTSANDCONDITIONS(2).GVars(4).Condition = "ResponseRow"
    EVENTSANDCONDITIONS(2).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(4).Condition, globals.ResponseRow)
    EVENTSANDCONDITIONS(2).GVars(5).Condition = "ResponseColumn"
    EVENTSANDCONDITIONS(2).GVars(5).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(5).Condition, globals.ResponseColumn)

    EVENTSANDCONDITIONS(2).GVars(6).Condition = "AgentInRoom"
    EVENTSANDCONDITIONS(2).GVars(6).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(6).Condition, globals.AgentInRoom)
    EVENTSANDCONDITIONS(2).GVars(7).Condition = "TargetShownUpstairs"
    EVENTSANDCONDITIONS(2).GVars(7).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(7).Condition, globals.TargetShownUpstairs)
    EVENTSANDCONDITIONS(2).GVars(8).Condition = "Feedback"
    EVENTSANDCONDITIONS(2).GVars(8).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(8).Condition, globals.Feedback)
    EVENTSANDCONDITIONS(2).GVars(9).Condition = "HitMiss"
    EVENTSANDCONDITIONS(2).GVars(9).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(9).Condition, globals.HitMiss)
    EVENTSANDCONDITIONS(2).GVars(10).Condition = "EnforcedDelay"
    EVENTSANDCONDITIONS(2).GVars(10).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(10).Condition, EXPERIMENT.Misc.Delay1Max)
    EVENTSANDCONDITIONS(2).GVars(11).Condition = "RunNumber"
    EVENTSANDCONDITIONS(2).GVars(11).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(11).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(2).GVars(12).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(2).GVars(12).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(12).Condition, globals.TrialCnt)
    EVENTSANDCONDITIONS(2).GVars(13).Condition = "TimeToResponse"
    EVENTSANDCONDITIONS(2).GVars(13).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(13).Condition, VAL(globals.ElapsedTime))

    CALL WriteToEventFile2(2)


    IF (globals.TargetShownUpstairs = 2) THEN
            'TargetDisplayedUpstair
        EVENTSANDCONDITIONS(1).GVars(0).Condition = "Target"
        EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.Target)
        EVENTSANDCONDITIONS(1).GVars(1).Condition = "TargetRow"
        EVENTSANDCONDITIONS(1).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(1).Condition, globals.TargetRow)
        EVENTSANDCONDITIONS(1).GVars(2).Condition = "TargetColumn"
        EVENTSANDCONDITIONS(1).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(2).Condition, globals.TargetColumn)


        EVENTSANDCONDITIONS(1).GVars(3).Condition = "Response"
        EVENTSANDCONDITIONS(1).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(3).Condition, globals.Response)
        EVENTSANDCONDITIONS(1).GVars(4).Condition = "ResponseRow"
        EVENTSANDCONDITIONS(1).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(4).Condition, globals.ResponseRow)
        EVENTSANDCONDITIONS(1).GVars(5).Condition = "ResponseColumn"
        EVENTSANDCONDITIONS(1).GVars(5).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(5).Condition, globals.ResponseColumn)

        EVENTSANDCONDITIONS(1).GVars(6).Condition = "AgentInRoom"
        EVENTSANDCONDITIONS(1).GVars(6).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(6).Condition, globals.AgentInRoom)
        EVENTSANDCONDITIONS(1).GVars(7).Condition = "TargetShownUpstairs"
        EVENTSANDCONDITIONS(1).GVars(7).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(7).Condition, globals.TargetShownUpstairs)
        EVENTSANDCONDITIONS(1).GVars(8).Condition = "Feedback"
        EVENTSANDCONDITIONS(1).GVars(8).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(8).Condition, globals.Feedback)
        EVENTSANDCONDITIONS(1).GVars(9).Condition = "HitMiss"
        EVENTSANDCONDITIONS(1).GVars(9).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(9).Condition, globals.HitMiss)
        EVENTSANDCONDITIONS(1).GVars(10).Condition = "EnforcedDelay"
        EVENTSANDCONDITIONS(1).GVars(10).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(10).Condition, EXPERIMENT.Misc.Delay1Max)
        EVENTSANDCONDITIONS(1).GVars(11).Condition = "RunNumber"
        EVENTSANDCONDITIONS(1).GVars(11).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(11).Condition, globals.RunCnt)
        EVENTSANDCONDITIONS(1).GVars(12).Condition = "TrialNumber"
        EVENTSANDCONDITIONS(1).GVars(12).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(12).Condition, globals.TrialCnt)
        EVENTSANDCONDITIONS(1).GVars(13).Condition = "TimeToResponse"
        EVENTSANDCONDITIONS(1).GVars(13).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(13).Condition, VAL(globals.ElapsedTime))
            CALL WriteToEventFile2(1)
    END IF
END SUB


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL lResult, rndJitter, subPtr AS LONG



    SELECT CASE itemName
        CASE "SUBJECTDIODE"
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
            'DebugLog("SUBJECTDIODE Off")
        CASE "SUBJECTFEEDBACK"

             CONTROL REDRAW globals.hdl.DlgSubject, %ID_GRID
            'DebugLog("Feedback Off")
        CASE "SUBJECTWAITPROCEED"
             'Target Selected
             'DebugLog("SUBJECTWAITPROCEED Off")

             IF (globals.CCFlag = 1) THEN
                  CALL setColorCardsScreen()
             END IF

             IF (globals.Precognitive = 0) THEN     'no Precognitive trials
                 GetTarget()
             END IF
            'added 2/27/13 - delay between target selected
            'and display to upstairs
            'delayMilliSeconds(1000)
            'randomDelayMilliseconds(10, 100)
            rndJitter = RandomNumber2(1000, 1100)
            SetMMTimerDuration("NEXTTRIAL", rndJitter)
            SetMMTimerOnOff("NEXTTRIAL", 1)    'turn on
        CASE "AGENTDIODE"
            PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)
        CASE "NEXTTRIAL"
            IF (globals.Precognitive = 0) THEN     'Precognitive trials - no agent
                CALL DisplayToAgent()
            END IF
            SetMMTimerOnOff("NEXTTRIAL", 0)    'turn off

            EnableButtons(1)

            'DebugLog("NextTrial")

            NextTrial()
    END SELECT



END SUB

SUB setColorCardsScreen()
    LOCAL rndNbr AS BYTE
    LOCAL bmpName AS ASCIIZ * 255
    '===========================================================
    'added 4/28/2014 - This is specifically for the Color Cards
    'experiments so we randomize the color card grid that the
    'subject makes his choice from.
    '===========================================================
    rndNbr = RandomNumber(6)
    #DEBUG PRINT "rndNbr: " + STR$(rndNbr)

    SELECT CASE rndNbr
        CASE 1
            bmpName = "BITMAP_GRID1"
            globals.CCResponses(1) = 1 : globals.CCResponses(2) = 2 : globals.CCResponses(3) = 3 : _
                globals.CCResponses(4) = 4 : globals.CCResponses(5) = 5
        CASE 2
            bmpName = "BITMAP_GRID2"
            globals.CCResponses(1) = 3 : globals.CCResponses(2) = 5 : globals.CCResponses(3) = 4 : _
                globals.CCResponses(4) = 1 : globals.CCResponses(5) = 2
        CASE 3
            bmpName = "BITMAP_GRID3"
            globals.CCResponses(1) = 5 : globals.CCResponses(2) = 2 : globals.CCResponses(3) = 4 : _
                globals.CCResponses(4) = 3 : globals.CCResponses(5) = 1
        CASE 4
            bmpName = "BITMAP_GRID4"
            globals.CCResponses(1) = 4 : globals.CCResponses(2) = 1 : globals.CCResponses(3) = 5 : _
                globals.CCResponses(4) = 3 : globals.CCResponses(5) = 2
        CASE 5
            bmpName = "BITMAP_GRID5"
            globals.CCResponses(1) = 1 : globals.CCResponses(2) = 5 : globals.CCResponses(3) = 4 : _
                globals.CCResponses(4) = 2 : globals.CCResponses(5) = 3
        CASE 6
            bmpName = "BITMAP_GRID6"
            globals.CCResponses(1) = 2 : globals.CCResponses(2) = 4 : globals.CCResponses(3) = 5 : _
                globals.CCResponses(4) = 1 : globals.CCResponses(5) = 3
    END SELECT

    #DEBUG PRINT "bmpName: " + bmpName

    CONTROL SET IMAGE globals.hdl.DlgSubject, %ID_GRID, bmpName

END SUB

SUB FeedbackColorCards(targ_resp AS LONG, targScrn_respScrn AS DWORD)
    LOCAL l, m, xMax, ymax, xStart, yStart, xMouse, yMouse AS LONG
    LOCAL xTempMin, xTempMax, yTempMin, yTempMax, found, arrayCnt AS LONG
    LOCAL targetStr, targ AS STRING
    LOCAL rndNbr AS BYTE

    CONTROL GET LOC targScrn_respScrn, %ID_GRID TO xStart, yStart
    CONTROL GET CLIENT targScrn_respScrn, %ID_GRID TO xMax, yMax



    '#DEBUG PRINT "Feedback"
    '#DEBUG PRINT "LOC: " + STR$(xStart) + ", " + STR$(yStart)
    '#DEBUG PRINT "CLIENT: " + STR$(xMax) + ", " + STR$(yMax)

    FOR l = 1 TO EXPERIMENT.Misc.NbrOfTargets

        IF (targ_resp = globals.CCResponses(l)) THEN
             CONTROL SET LOC targScrn_respScrn, %ID_HIGHLIGHT, Grid(l).UpperLeftX + xStart, Grid(l).UpperLeftY + yStart
             CONTROL SHOW STATE targScrn_respScrn, %ID_HIGHLIGHT, %SW_SHOW
             #DEBUG PRINT STR$(Grid(l).Position) + " feedback: " +STR$(Grid(l).UpperLeftY) + ", " + STR$(Grid(l).LowerRightY)
             #DEBUG PRINT "l: " +STR$(l)
             EXIT FOR
        END IF
    NEXT l

    CONTROL REDRAW targScrn_respScrn, %ID_GRID
    CONTROL REDRAW targScrn_respScrn, %ID_HIGHLIGHT
END SUB
