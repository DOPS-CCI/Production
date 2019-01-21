#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

'#RESOURCE "ASCGeneric.pbr"



#RESOURCE BITMAP,   BITMAP_PROCEEDBIOSEMI , "Images\BIOSEMIPROCEED.bmp"
#RESOURCE WAVE,     UPBEAT_WAV, "Sounds\MusicalAccentTwinkle.wav"
#RESOURCE WAVE,     NORMAL_WAV, "Sounds\VocodSynthSwish.wav"
#RESOURCE WAVE,     REST_WAV, "Sounds\Rest.wav"
#RESOURCE WAVE,     FOCUS_WAV, "Sounds\Focus.wav"
#RESOURCE WAVE,     FOCUSLOW_WAV, "Sounds\FocusLow.wav"
#RESOURCE WAVE,     FOCUSHIGH_WAV, "Sounds\FocusHigh.wav"
#RESOURCE WAVE,     UP_WAV, "Sounds\Up.wav"
#RESOURCE WAVE,     DOWN_WAV, "Sounds\Down.wav"
#RESOURCE WAVE,     PLEASEWAIT_WAV, "Sounds\PleaseWait.wav"
#RESOURCE WAVE,     ENDEXPT_WAV, "Sounds\EndExperiment.wav"
#RESOURCE WAVE,     ENDRUN_WAV, "Sounds\EndRun.wav"

'====================================================================
'NOTE:
'In the compiler options the WINAPI_II.inc needs to be before the
'WINAPI.inc
'====================================================================


%IDC_FRAME1                = 1001
%IDC_BUTTON_ENDEPOCH       = 1002
%IDC_BUTTON_SPECIALEVENT   = 1003
%IDC_TEXTBOX_SPECIAL_EVENT = 1004
%IDC_LABEL1                = 1005
%IDC_BUTTON_ENDEXPERIMENT  = 1006
%IDC_BUTTON_EVENT01        = 1007
%IDC_BUTTON_EVENT02        = 1008
%IDC_BUTTON_EVENT03        = 1009
%IDC_BUTTON_EVENT04        = 1010
%IDC_BUTTON_EVENT05        = 1011
%IDC_BUTTON_EVENT06        = 1012
%IDC_BUTTON_EVENT07        = 1013
%IDC_BUTTON_EVENT08        = 1014
%IDC_BUTTON_EVENT09        = 1015
%IDC_BUTTON_EVENT10        = 1016
%IDC_BUTTON_EVENT11        = 1017
%IDC_BUTTON_EVENT12        = 1018


%ID_OK = 2001
%IMAGE_PD = 2001
%IMAGE_BACK = 2002
%IMAGE_PROCEED = 2003
%CHECKBOX_DIO_PRESENT = 2015
%FRAME_PHOTODIODE = 2018
%ID_CONTROLLER_OK = 2019
%ID_CONTROLLER_EXIT = 2023
%IDC_BUTTON_SetConditions = 2024
%IDC_CHECKBOX_UseStartingPoint = 2025
%IDC_TEXTBOX_Offset = 2026
%IDT_TIMER01 = 2027

%TEXTBOX_SUBJECTID              = 9901
%IDC_9903                       = 9903
%IDC_9905                       = 9905
%TEXTBOX_COMMENT                = 9909
%BUTTON_HELPEROK                = 9910
%BUTTON_HELPERCANCEL            = 9911
%BUTTON_HELP                    = 9912
%IDC_LABEL_GROUP_VARIABLE       = 9913
%IDC_LABEL_DESCRIPTION          = 9916
%IDC_FRAME_SET_LEVELS           = 9917
%IDC_LABEL2                     = 9918
%IDC_LABEL3                     = 9919
%IDC_LABEL4                     = 9921
%IDC_BUTTON_GVADD               = 9923
%IDC_BUTTON_GVDELETE            = 9924
%IDC_TEXTBOX_GROUPVAR_DESC      = 9915
%IDC_TEXTBOX_GROUPVAR           = 9914
%IDC_TEXTBOX_GV_CONDITION_LEVEL = 9918
%IDC_TEXTBOX_GV_CONDITION_VALUE = 9920
%IDC_LISTBOX_GV_CONDITIONS      = 9922
%IDC_FRAME2                     = 9925  '*
%IDC_LINE3                      = 9926
%IDC_LINE4                      = 9927
%IDC_LABEL_FRAME                = 9928
%IDC_TEXTBOX_DESCRIPTION        = 9929
%IDC_LABEL5                     = 9930
%IDC_LABEL_STOPWATCH            = 9931
%IDC_CHECKBOX_speech            = 9932
%IDC_LISTBOX_SPECIALNOTES       = 9933
'%IDC_BUTTON_ADD_COMMENTS        = 9934
%IDC_BUTTON_EEGSettings         = 9935
%IDC_BUTTON_LongDesc            = 9936
%IDC_BUTTON_Abort               = 9937
%IDC_TEXTBOX_DateOfVideo        = 9938
%IDC_TEXTBOX_TimeOfVideo        = 9939
%IDC_LABEL6                     = 9940
%IDC_LABEL7                     = 9941
%IDC_LABEL_Timings              = 9942

%SVSFlagsAsync = 1

MACRO xbox(x) = SLEEP 10

TYPE GlobalHandles
    DlgSubject AS DWORD
    DlgAgent AS DWORD
    DlgController AS DWORD
    DlgHelper AS DWORD
    DlgSubjectPhotoDiode AS DWORD
    DlgAgentPhotoDiode AS DWORD
END TYPE

TYPE Epoch
    Flag AS INTEGER
END TYPE

TYPE GlobalVariables
    Response AS LONG
    EndEpochResponse AS LONG
    Comment AS ASCIIZ * 255
    SubjectID AS LONG
    BoardNum AS LONG
    DioCardPresent AS LONG
    GreyCode AS LONG
    DioIndex AS LONG
    TargetTime AS ASCIIZ * 18
    hdl AS GlobalHandles
    EpochInfo(1 TO 12) AS Epoch
    timerInterval AS LONG
    buttonName AS ASCIIZ*20
    trialCnt AS INTEGER
    totalTime AS LONG
    fnirscode AS LONG
END TYPE

TYPE PowerTimeType
    pYear AS LONG
    pMonth AS LONG
    pDay AS LONG
    pHour AS LONG
    pMinute AS LONG
    pSecond AS LONG
END TYPE

%TRUE = 1
%FALSE = 0

GLOBAL globals AS GlobalVariables
GLOBAL gHelperOpened AS INTEGER
GLOBAL gDateOfVideo, gTimeOfVideo, gOffest AS STRING
GLOBAL gMyTime AS IPOWERTIME
GLOBAL gMyTimeType AS PowerTimeType
GLOBAL gFirstTimeFlag AS BYTE
GLOBAL gUseOffset AS BYTE
GLOBAL rngInt AS EvenOddRNGInterface


'#INCLUDE "Mersenne-Twister.inc"
#INCLUDE ONCE "SAPI.INC"
#INCLUDE "WinBase.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "ControllerScreen.inc"
#INCLUDE "HelperScreen.inc"
#INCLUDE "SubjectScreen.inc"
#INCLUDE "BiosemiRecording.inc"
#INCLUDE "EvenOddRNGClass.inc"
#INCLUDE "SoundCheck.inc"





' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL x AS LONG
    LOCAL tempFilename  AS STRING
    LOCAL filename, temp, sResult AS ASCIIZ * 255

    '************************************************
    'Read values from the INI file to initialize
    'experiment variables
    '************************************************

    EXPERIMENT.SessionDescription.INIFile = "ASCMedium.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

   'Start RNG

        LET rngInt = CLASS "EvenOddRNGClass"

        rngInt.SetDuration(1000)
        rngInt.SetSampleSize(50)
        rngInt.SetINIFilename(EXPERIMENT.SessionDescription.INIFile)

        rngInt.StartHiddenRNGWindow()
         '**********************************************************************************************



'************************************************
    'Initialize Mersenne-twister
    '************************************************
    init_MT_by_array()

    globals.timerInterval = 0
    globals.totalTime = 0
    globals.trialCnt = 0

    '****************************************************
    'initialize epoch flag - no one has pressed end epoch
    '****************************************************
    FOR x = 1 TO 12
        globals.EpochInfo(x).Flag = %FALSE
    NEXT x

     'check the DIO card
    'GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", sResult, %MAXPPS_SIZE, filename)
    'IF (LTRIM$(LCASE$(sResult)) = "yes" AND EXPERIMENT.Misc.Mode <> "demo") THEN
        'globals.DioCardPresent = 1
    'ELSE
        'globals.DioCardPresent = 0
    'END IF

    'MediumASC assumes PCDIO card is present in EXP computer
    globals.DioCardPresent = 1
    globals.BoardNum = ConfigurePorts(1, 1, 1, 1)   'DOPS_Utils.inc  configs port a, b, cl and ch  as outputs
    CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum, 1)      'DOPS_Utils.inc  inits ports a,b and cl

    LET gMyTime = CLASS "PowerTime"    'date time object
    gFirstTimeFlag = 0               '0=timer msg has not been processed yet
    globals.timerInterval = 0

    CALL dlgControllerScreen()    'local,  ControllerScreen.inc

    DIALOG SHOW MODAL globals.hdl.DlgController, CALL cbControllerScreen TO hr

    'SetWindowsPos
    CALL closeEventFile()

END FUNCTION



SUB ButtonEvent99       'end epoch button press in subjectscreen.inc
    LOCAL now AS QUAD

    IF (hasAStartEpochOccured() = %TRUE) THEN

        IF (gUseOffset = 1) THEN
            gMyTime.NewTime(gMyTimeType.pHour, gMyTimeType.pMinute, gMyTimeType.pSecond)
            gMyTime.AddSeconds(globals.totalTime)
        ELSE
            gMyTime.Now()
        END IF

        gMyTime.FileTime TO now
        globals.fnirscode = 4  'trig code for fnirs end of epoch

        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode, globals.fnirscode)
        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
        EVENTSANDCONDITIONS(1).EvtName = "EndEpoch"
        EVENTSANDCONDITIONS(1).NbrOfGVars = 1
        EVENTSANDCONDITIONS(1).Index = globals.DioIndex
        EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(gMyTime)

        EVENTSANDCONDITIONS(1).GVars(0).Condition = "ASCCondition"
        EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.EndEpochResponse)

        rngInt.SetCondition(EVENTSANDCONDITIONS(1).GVars(0).Desc + "")
        gFirstTimeFlag = 2     'signals timer callback fn in subjectscreen.inc to not increment epoch timer

        CALL WriteToEventFile2(1)
    END IF
END SUB

FUNCTION SubjectResponse() AS LONG   'process for asc button press, called from subjectscreen.inc
    DIM lResult AS LONG
    DIM temp AS STRING
    LOCAL now AS QUAD
    LOCAL x AS INTEGER

    'IF (hasAStartEpochOccured() = %TRUE) THEN
    '    CALL ButtonEvent99
    'END IF


    IF (gFirstTimeFlag = 0) THEN    'signals beginning of total elapsed time count and first epoch
        IF (gUseOffset = 1) THEN
            globals.totalTime = VAL(gOffset)
        ELSE
            globals.totalTime = 0
        END IF
    END IF

        globals.timerInterval = 0   'timer counter for this epoch
        gFirstTimeFlag = 1          'signals active incrementing of epoch timer


    IF (gUseOffset = 1) THEN
        gMyTime.NewTime(gMyTimeType.pHour, gMyTimeType.pMinute, gMyTimeType.pSecond)
        gMyTime.AddSeconds(globals.totalTime)
    ELSE
        gMyTime.Now()
    END IF

    gMyTime.FileTime TO now

    FOR x = 1 TO 12    'zero out EpochInfo flags in case no end of epoch occurred for a previous button press
        globals.EpochInfo(x).Flag = %False
    NEXT x

    globals.EpochInfo(globals.Response).Flag = %TRUE   'set EpochInfo flag for this button press

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode, globals.fnirscode)  'in DOPS_utils.inc  write to DIO and inc's greycode; fnirscode set in subjectscreen
    globals.TargetTime = FORMAT$(globals.totalTime, "###############.000") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(0).EvtName = "StartEpoch"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 1
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(gMyTime)

    EVENTSANDCONDITIONS(0).GVars(0).Condition = "ASCCondition"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Response)

    rngInt.SetCondition(EVENTSANDCONDITIONS(0).GVars(0).Desc + "")

    CALL WriteToEventFile2(0)

    globals.buttonName =  EVENTSANDCONDITIONS(0).GVars(0).Desc

    CONTROL GET CHECK globals.hdl.DlgSubject, %IDC_CHECKBOX_speech TO lResult

    globals.trialCnt = globals.trialCnt + 1


'   IF (TRIM$(globals.buttonName) = "SPECIAL") THEN
'        CONTROL SET COLOR globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, %RGB_RED, %RGB_WHITE
'        LISTBOX ADD globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, "Please make a note of this special state at Epoch: " + _
'                                STR$(globals.trialCnt) + " at Total elapsed: " + STR$(globals.totalTime)
'    END IF

    IF (lResult = 1 AND globals.buttonName <> "SPECIAL") THEN
        'speak2("Start " + globals.buttonName)
    END IF

    FUNCTION = 0
END FUNCTION

FUNCTION hasAStartEpochOccured() AS INTEGER
    LOCAL x, flag AS INTEGER

    flag = %FALSE
    FOR x = 1 TO 12
        IF (globals.EpochInfo(x).Flag = %TRUE) THEN
            globals.EndEpochResponse = x
            globals.EpochInfo(x).Flag = %FALSE
            flag = %TRUE
            EXIT FOR
        END IF
    NEXT x

    FUNCTION = flag
END FUNCTION
