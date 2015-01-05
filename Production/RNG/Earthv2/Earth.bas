#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

'#RESOURCE RES, "Earth.res"

#RESOURCE BITMAP, BITMAP_HIGHLIGHT "Images\highlight.bmp"

#RESOURCE BITMAP, BITMAP_PROCEED "Images\proceed.bmp"
#RESOURCE BITMAP, BITMAP_WAIT "Images\wait.bmp"

#RESOURCE BITMAP, BITMAP_PDB "Images\PD_black.bmp"
#RESOURCE BITMAP, BITMAP_PDW "Images\PD_white.bmp"

#RESOURCE BITMAP, BITMAP_OKBUTTON  "Images\OKButton.bmp"
#INCLUDE "win32api.inc"

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
%IDC_LABEL_TARGET = 1027
%IDC_Graphic = 100
%IDC_9901                = 9901
%IDC_9903                = 9903
%IDC_9904                = 9904
%IDC_BUTTON_EEGSettings  = 9905
%IDC_BUTTON_LongDesc     = 9906

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
    Response AS LONG
    NbrOfHits AS LONG
    RunCnt AS LONG
    TrialCnt AS LONG
    TrialCntTotal AS LONG
    HitMiss AS LONG
    TargetShownUpstairs AS LONG
    FeedBack AS LONG
    AgentInRoom AS LONG
    SubjectID AS LONG
    RNGTotal AS LONG
    RNGCount AS LONG
    RNGAverage AS DOUBLE
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
    hdl AS GlobalHandles
END TYPE



GLOBAL globals AS GlobalVariables
GLOBAL pid AS DWORD
GLOBAL gStart, gEnd AS QUAD
GLOBAL gHelperOpened AS INTEGER
GLOBAL gRndTotal() AS LONG
GLOBAL gRndCnt() AS LONG
GLOBAL gRndAvg() AS DOUBLE
GLOBAL gTargetFocus() AS LONG
GLOBAL ghCity, ghPlane, ghPlaneDC, ghGraphicDC AS DWORD
GLOBAL gWidthPlane, gHeightPlane, giHPos, giVPos, gTransColor, gHighOrLow AS LONG
GLOBAL oApp AS IDISPATCH

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
        MSGBOX "Please use GenericRNG filename.ini to start the program."
        RETURN
    END IF

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

    LET gTimers = CLASS "PowerCollection"

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

SUB Response()
    LOCAL z AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    LET MyTime = CLASS "PowerTime"

    MyTime.Now()
    MyTime.FileTime TO now


    'FOR z = 0 TO EXPERIMENT.Misc.NbrOfTargets - 1
    '    gRndAvg(z) = gRndTotal(z) / gRndCnt(z)
    'NEXT z
    'MSGBOX STR$(gRndAvg(0)) + ", " + STR$(gRndAvg(1))

    globals.Response = findLargest(gRndAvg())
    globals.RNGTotal = gRndTotal(globals.Response - 1)
    globals.RNGCount = gRndCnt(globals.Response - 1)
    globals.RNGAverage = gRndAvg(globals.Response - 1)
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(1).EvtName = "ResponseSelected"
    EVENTSANDCONDITIONS(1).NbrOfGVars = 6
    EVENTSANDCONDITIONS(1).Index = globals.DioIndex
    EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)
    EVENTSANDCONDITIONS(1).ElapsedMillis = gTimerTix

   SELECT CASE globals.Response
    CASE 1  'FLY HIGH
        gHighOrLow = 1
    CASE 2 'FLY LOW
        gHighOrLow = 2
    END SELECT

    FOR z = 0 TO EXPERIMENT.Misc.NbrOfTargets - 1
        gRndTotal(z) = 0
        gRndCnt(z) = 0
        gRndAvg(z) = 0
    NEXT z

    'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
END SUB

SUB DoWorkForEachTick()
    LOCAL z AS LONG
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE


    FOR z = 0 TO EXPERIMENT.Misc.NbrOfTargets - 1
        IF (Experiment.Misc.Mode <> "demo") THEN
            OBJECT CALL oApp.GetRandomByte() TO rndByte
            bRndByte = VARIANT#(rndByte)
        ELSE
            bRndByte = RandomNumber2(1,255)
        END IF
        gRndTotal(z) = gRndTotal(z) + bRndByte
        '#debug print "gRndTotal(" + str$(z) + "): " + str$(gRndTotal(z))
        gRndCnt(z) = gRndCnt(z) + 1
        '#DEBUG PRINT "gRndCnt(" + STR$(z) + "): " + STR$(gRndCnt(z))
        gRndAvg(z) = gRndTotal(z) / gRndCnt(z)
        '#DEBUG PRINT "gRndAvg(" + STR$(z) + "): " + STR$(gRndAvg(z))
    NEXT z

    IF (gTimerTix MOD 50 = 0) THEN

        GRAPHIC COPY ghCity,0

         'iHPos = iHPos - 2
         IF (ghighOrLow = 1) THEN
             giVPos = giVPos + 1
         ELSEIF (ghighOrLow = 2) THEN
             giVPos = giVPos - 1
         END IF
         IF (giVPos = 1440) THEN
             giVPos = 0
         ELSEIF (giVPos = 0) THEN
             giVPos = 1339
         END IF

        GRAPHIC ATTACH globals.hdl.DlgSubject, %IDC_Graphic, REDRAW
         'TransparentBlt hGraphicDC,iHPos,iVPos,widthPlane,heightPlane,hPlaneDC,0,0,widthPlane,heightPlane,TransColor
         'GRAPHIC REDRAW
         DrawCircle (giVPos * 0.25, 500, 300, 300)
    END IF
END SUB

SUB StartTrial()
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL z AS LONG

     PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)

    LET MyTime = CLASS "PowerTime"

    MyTime.Now()
    MyTime.FileTime TO now
       'iVPos = 200
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(0).EvtName = "TargetSelected"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 6
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)
    EVENTSANDCONDITIONS(0).ElapsedMillis = gTimerTix

    'show trial # on the experimenter screen
    DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)


    'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)

    globals.Target = gTargetFocus(globals.RunCnt - 1)

    SELECT CASE globals.Target
        CASE 1  'Jump
            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "CLOCKWISE"

        CASE 2 'Don't Jump
            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "COUNTER-CLOCKWISE"
    END SELECT

END SUB

FUNCTION EndTrial() AS LONG
    LOCAL systime AS SYSTEMTIME
    LOCAL lDisplayToAgent, lResult AS LONG
    LOCAL dStart, dEnd AS DOUBLE


    'show trial # on the experimenter screen
    'DIALOG SET TEXT globals.hdl.DlgController, "Trial # " + STR$(globals.TrialCntTotal)

    '   CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""

    IF (globals.Response = globals.Target) THEN
        globals.HitMiss = 2 'hit
        globals.NbrOfHits = globals.NbrOfHits + 1
    ELSE
        globals.HitMiss = 1 'miss
    END IF



    IF (globals.TrialCntTotal >= (globals.NbrOfRuns * globals.NbrOfTrials)) THEN
        lResult = CustomMessageBox(1, "Would you like to see how you did?", "Show Results")
        'lResult = MSGBOX("Would you like to see how you did?", %MB_YESNO, "Show Results")
        IF (lResult = 1) THEN
            CustomMessageBox(1, displayStatisticsResults(globals.TrialCnt * globals.RunCnt, globals.NbrOfHits), "Your Results")
            'MSGBOX displayStatisticsResults(glTrialCnt, glNbrOfHits)
        END IF

        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
        SetMMTimerOnOff("DETERMINERESPONSE", 0)    'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)    'turn off
        killMMTimerEvent()

        CustomMessageBox(0,"The experiment is over.", "Experiment Ended.")


        DIALOG END globals.hdl.DlgSubject, 0

        FUNCTION = 1

        EXIT FUNCTION
    END IF

    IF ((globals.TrialCnt = globals.NbrOfTrials) AND (globals.RunCnt < globals.NbrOfRuns)) THEN
        globals.TrialCnt = 0
        globals.RunCnt = globals.RunCnt + 1


'        globals.Target = gTargetFocus(globals.RunCnt - 1)
'
'        SELECT CASE globals.Target
'            CASE 1  'Jump
'                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "GO FAST"
'
'            CASE 2 'Don't Jump
'                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "GO SLOW"
'        END SELECT
        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
        SetMMTimerOnOff("DETERMINERESPONSE", 0)    'turn off
        SetMMTimerOnOff("SUBJECTDIODE", 0)    'turn off
        killMMTimerEvent()

        CustomMessageBox(1, "The run is over. You can take a short break.", "Run Ended")
        CustomMessageBox(0,"The run is over. Subject can take a short break.", "Run Ended.")
        CustomMessageBox(0,"Run " + STR$(globals.RunCnt) + " is about to begin.", "Start Next Run")
        CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        SetMMTimerOnOff("DETERMINERESPONSE", 1)    'turn on
        SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on
        setMMTimerEventPeriodic(1, 0)
    END IF

    globals.TrialCnt = globals.TrialCnt + 1
    globals.TrialCntTotal = globals.TrialCntTotal + 1

    CALL WriteOutEvents()


     'EnableButtons(1) 'enable buttons
    FUNCTION = 0
END FUNCTION

SUB WriteOutEvents()
  'TargetSelected
    EVENTSANDCONDITIONS(0).GVars(0).Condition = "Target"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(0).GVars(1).Condition = "Response"
    EVENTSANDCONDITIONS(0).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(1).Condition, globals.Response)
    EVENTSANDCONDITIONS(0).GVars(2).Condition = "HitMiss"
    EVENTSANDCONDITIONS(0).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(2).Condition, globals.HitMiss)
    EVENTSANDCONDITIONS(0).GVars(3).Condition = "RNGTotal"
    EVENTSANDCONDITIONS(0).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(3).Condition, globals.RNGTotal)
    EVENTSANDCONDITIONS(0).GVars(4).Condition = "RNGCount"
    EVENTSANDCONDITIONS(0).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(4).Condition, globals.RNGCount)
    EVENTSANDCONDITIONS(0).GVars(5).Condition = "RunNumber"
    EVENTSANDCONDITIONS(0).GVars(5).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(5).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(0).GVars(6).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(0).GVars(6).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(6).Condition, globals.TrialCnt)

    CALL WriteToEventFile2(0)

    'ResponseSelected
   EVENTSANDCONDITIONS(1).GVars(0).Condition = "Target"
    EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.Target)
    EVENTSANDCONDITIONS(1).GVars(1).Condition = "Response"
    EVENTSANDCONDITIONS(1).GVars(1).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(1).Condition, globals.Response)
    EVENTSANDCONDITIONS(1).GVars(2).Condition = "HitMiss"
    EVENTSANDCONDITIONS(1).GVars(2).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(2).Condition, globals.HitMiss)
    EVENTSANDCONDITIONS(1).GVars(3).Condition = "RNGTotal"
    EVENTSANDCONDITIONS(1).GVars(3).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(3).Condition, globals.RNGTotal)
    EVENTSANDCONDITIONS(1).GVars(4).Condition = "RNGCount"
    EVENTSANDCONDITIONS(1).GVars(4).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(4).Condition, globals.RNGCount)
    EVENTSANDCONDITIONS(1).GVars(5).Condition = "RunNumber"
    EVENTSANDCONDITIONS(1).GVars(5).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(5).Condition, globals.RunCnt)
    EVENTSANDCONDITIONS(1).GVars(6).Condition = "TrialNumber"
    EVENTSANDCONDITIONS(1).GVars(6).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(6).Condition, globals.TrialCnt)

    CALL WriteToEventFile2(1)
END SUB


SUB DoTimerWork(itemName AS WSTRING)
    LOCAL lResult, rndJitter, subPtr AS LONG
    LOCAL x AS LONG

    SELECT CASE itemName
        CASE "DETERMINERESPONSE"
            'msgbox "here"

            CALL StartTrial()
            CALL Response()
            CALL EndTrial()
            SetMMTimerDuration("DETERMINERESPONSE", globals.ITDelay)
            SetMMTimerOnOff("DETERMINERESPONSE", 1)    'turn on
            SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

            'CALL Response()
            'CALL EndTrial()
            'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
            'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
            'CALL StartTrial()
            'msgbox "here 2"
            'SetMMTimerOnOff("DETERMINERESPONSE", 1)    'turn on
        CASE "SUBJECTDIODE"
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
            'DebugLog("SUBJECTDIODE Off")
    END SELECT
END SUB


SUB DrawCircle (angle AS SINGLE, xOffset AS LONG, yOffset AS LONG, radius AS INTEGER)
          DIM xPlot AS SINGLE
          DIM yPlot AS SINGLE     ' Current pixel being plotted.
          DIM angleRad AS SINGLE  ' Current angle in degrees & radiens.

          'FOR angle = 0 TO 360 STEP 0.5

               ' Convert degrees to radiens.
               angleRad = angle * (3.141592654 / 180)

               ' Convert polar to rectangular coordinates.
               xPlot = (radius * COS(angleRad)) + xOffset
               yPlot = (radius * SIN(angleRad)) + yOffset

               ' Check boundaries.
               IF xPlot < 0 THEN
                   xPlot = 0
               ELSEIF xPlot > 1200 THEN
                   xPlot = 1199
               END IF
               IF yPlot < 0 THEN
                   yPlot = 0
               ELSEIF yPlot > 800 THEN
                   yPlot = 799
               END IF

               ' Plot the pixel on the graphics screen.
              TransparentBlt ghGraphicDC,xPlot,yPlot,gwidthPlane,gheightPlane,ghPlaneDC,0,0,gwidthPlane,gheightPlane,gTransColor
              GRAPHIC REDRAW
          'NEXT angle!
END SUB
