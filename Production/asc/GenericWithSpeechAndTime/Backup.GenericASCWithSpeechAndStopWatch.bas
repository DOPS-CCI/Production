#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ASCGenericWithSpeechAndStopwatch.pbr"

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
END TYPE

%TRUE = 1
%FALSE = 0

GLOBAL globals AS GlobalVariables
GLOBAL gHelperOpened AS INTEGER


'#INCLUDE "Mersenne-Twister.inc"
#INCLUDE ONCE "SAPI.INC"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "ControllerScreen.inc"
#INCLUDE "HelperScreen.inc"
#INCLUDE "SubjectScreen.inc"






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

    tempFilename = COMMAND$
    IF (TRIM$(tempFilename) = "") THEN
        MSGBOX "Please use filename.ini to start the program."
        RETURN
    END IF


    '************************************************
    'Initialize Mersenne-twister
    '************************************************
    init_MT_by_array()

    EXPERIMENT.SessionDescription.INIFile = tempFilename
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

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

    CALL dlgControllerScreen()

    DIALOG SHOW MODAL globals.hdl.DlgController, CALL cbControllerScreen TO hr


        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION



SUB ButtonEvent99
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    LET MyTime = CLASS "PowerTime"

    IF (hasAStartEpochOccured() = %TRUE) THEN
        MyTime.Now()
        MyTime.FileTime TO now

        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
        globals.TargetTime = GetTimeWithSeconds()
        EVENTSANDCONDITIONS(1).EvtName = "EndEpoch"
        EVENTSANDCONDITIONS(1).NbrOfGVars = 1
        EVENTSANDCONDITIONS(1).Index = globals.DioIndex
        EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)

        EVENTSANDCONDITIONS(1).GVars(0).Condition = "ASCCondition"
        EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.EndEpochResponse)

        CALL WriteToEventFile2(1)
    END IF
END SUB

FUNCTION SubjectResponse() AS LONG
    DIM lResult AS LONG
    DIM temp AS STRING
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    LET MyTime = CLASS "PowerTime"


    'IF (hasAStartEpochOccured() = %TRUE) THEN
        CALL ButtonEvent99
    'END IF

    MyTime.Now()
    MyTime.FileTime TO now

    globals.EpochInfo(globals.Response).Flag = %TRUE

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = GetTimeWithSeconds()
    EVENTSANDCONDITIONS(0).EvtName = "StartEpoch"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 1
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(0).EventTime = PowerTimeDateTime(MyTime)

    EVENTSANDCONDITIONS(0).GVars(0).Condition = "ASCCondition"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Response)

    CALL WriteToEventFile2(0)

    globals.buttonName =  EVENTSANDCONDITIONS(0).GVars(0).Desc

    CONTROL GET CHECK globals.hdl.DlgSubject, %IDC_CHECKBOX_speech TO lResult

    KillTimer globals.hdl.DlgSubject, &H3E8
    CALL SetTimer(globals.hdl.DlgSubject, BYVAL &H3E8, 1000, BYVAL %NULL)

    globals.totalTime = globals.totalTime + globals.timerInterval
    globals.trialCnt = globals.trialCnt + 1
    globals.timerInterval = 0

   IF (TRIM$(globals.buttonName) = "SPECIAL") THEN
        CONTROL SET COLOR globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, %RGB_RED, %RGB_WHITE
        LISTBOX ADD globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, "Please make a note of this special state at Epoch: " + _
                                STR$(globals.trialCnt) + " at Total elapsed: " + STR$(globals.totalTime)
    END IF

    IF (lResult = 1 AND globals.buttonName <> "SPECIAL") THEN
        speak2("Start " + globals.buttonName)
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

'FUNCTION speak(a AS STRING) AS LONG
'  DIM oSp AS DISPATCH                                         '// flag tells us when the talking is done
'  DIM oVTxt AS VARIANT                                        '// text to speak
'  DIM oVFlg AS VARIANT                                        '// flag to pass to the speech engine
'  DIM buf AS LOCAL STRING                                     '// local working buffer
'  SET oSp = NEW DISPATCH IN "SAPI.SpVoice.1"                  '// this is the module we want to point at
'  IF ISFALSE ISOBJECT(oSp) THEN                               '// did we fail to load the requested object?
'    MSGBOX "Speech engine failed to initialize!" '// tell someone we failed
'    FUNCTION = 0                                              '// pass back our failure
'    EXIT FUNCTION                                             '// leave, we can't do anything here
'  END IF
'  IF LEN(a) > 0 THEN                                          '// only speak if we have something to say
'    oVTxt = a                                                 '// move dynamic string text into custom variable
'    oVFlg = %SVSFlagsAsync                                    '// this is what we want the engine to do (talk)
'    OBJECT CALL oSp.Speak(oVTxt, oVFlg)                       '// pass all of the info to the speecch engine
'    buf = a                                                   '// make a copy because we will modify
'    DO WHILE LEN(buf) > 0                                     '// loop while there something left in the buffer
'      DO WHILE INSTR(buf, $CRLF) > 0
'        xbox(LEFT$(buf, INSTR(buf, $CRLF) - 1))               '// show first part
'        buf = MID$(buf, INSTR(buf, $CRLF) + 2)                '// clip off first part
'      LOOP
'      IF LEN(buf) > 0 THEN                                    '// is there anything left?
'        xbox(buf)                                             '// show it
'        buf = ""                                              '// clean out the buffer
'      END IF
'    LOOP
'    DO                                                        '// Give the speech engine a chance to finish
'      SLEEP 100                                               '// let other programs have some of our CPU time
'      oVFlg = 100                                             '// set a starting point for our activity flag so we know if the following line changed it
'      OBJECT CALL oSp.WaitUntilDone(oVFlg) TO oVFlg           '// ask the speech engine if it is done yet
'    LOOP UNTIL VARIANT#(oVFlg)                                '// keep asking until we get our answer
'  ELSE                                                        '// nothing to say?
'    xbox(a)
'  END IF
'  SET oSp = NOTHING
'END FUNCTION


FUNCTION speak2(a AS STRING) AS LONG
   LOCAL pISpVoice AS ISpVoice
   LOCAL ulStreamNumber AS DWORD

   ' Create an instance of the ISpVoice interface
   pISpVoice = NEWCOM CLSID $CLSID_SpVoice
   IF ISNOTHING(pISpVoice) THEN EXIT FUNCTION

   ' Speak some text
   pISpVoice.Speak(a + "", %SPF_DEFAULT, ulStreamNumber)
   pISpVoice.WaitUntilDone(&HFFFFFFFF)

   ' Release the interface
   pISpVoice = NOTHING
END FUNCTION
