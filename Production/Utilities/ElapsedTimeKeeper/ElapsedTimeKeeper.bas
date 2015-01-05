#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ElapsedTimeKeeper.pbr"

'#INCLUDE "Mersenne-Twister.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"


%IDC_FRAME1                = 1001
%IDC_BUTTON_ENDEPOCH       = 1002
%IDC_BUTTON_SPECIALEVENT   = 1003
%IDC_TEXTBOX_SPECIAL_EVENT = 1004
%IDC_LABEL1                = 1005
%IDC_BUTTON_ENDEXPERIMENT  = 1006


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
%IDC_LABEL5                     = 9930
%IDC_LABEL_STOPWATCH            = 9931
%IDC_CHECKBOX_speech            = 9932
%IDC_TEXTBOX_DESCRIPTION        = 9933
%IDC_LINE1                      = 9934
%IDC_LISTBOX_SPECIALNOTES       = 9935
%IDC_BUTTON_CopyToClip          = 9936

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



' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL x AS LONG

    globals.timerInterval = 0
    globals.totalTime = 0
    globals.trialCnt = 0
    '****************************************************
    'initialize epoch flag - no one has pressed end epoch
    '****************************************************
    FOR x = 1 TO 12
        globals.EpochInfo(x).Flag = %FALSE
    NEXT x

   'Initialize Mersenne-twister
    init_MT_by_array()

    CALL dlgControllerScreen()

    DIALOG SHOW MODAL globals.hdl.DlgController, CALL cbControllerScreen TO hr


        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION

SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Controller Screen", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 1200, 800, %DS_CENTER OR %WS_OVERLAPPEDWINDOW, 0 TO globals.hdl.DlgController
    ' Use default styles
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, 150, 25,,, CALL cbControllerOK()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, 388, 150, 25,,, CALL cbControllerExit()

    DIALOG SET ICON globals.hdl.DlgController, "ElapsedTimeKeeper.ico"
    CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_HIDE
END SUB

CALLBACK FUNCTION cbControllerScreen()
    LOCAL PS AS paintstruct

    SELECT CASE CBMSG
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
                CASE %IDCANCEL
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                        DIALOG END CBHNDL, 0
                    END IF
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS

    END SELECT
END FUNCTION

CALLBACK FUNCTION cbControllerOK() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError, x, lResult AS LONG
    LOCAL sResult AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        EXPERIMENT.SessionDescription.INIFile = "ElapsedTimeKeeper.ini"
        EXPERIMENT.SessionDescription.Date = DATE$
        EXPERIMENT.SessionDescription.Time = TIME$

        filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

        GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

        'check the DIO card
        GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", sResult, %MAXPPS_SIZE, filename)
        IF (LTRIM$(LCASE$(sResult)) = "yes" AND EXPERIMENT.Misc.Mode <> "demo") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)


        IF (Experiment.Misc.Mode = "demo") THEN
            WritePrivateProfileString( "Experiment Section", "Comment", "demo mode (" + DATE$ + " " + TIME$ + ")", filename)

            CALL LoadINISettings()

            CALL initializeEventFile()

            globals.DioCardPresent = 0


            CustomMessageBox(1, "Press OK to start Altered States Run.", "Start Run")

            CALL dlgSubjectScreen()

            DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult



            CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
            CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
            CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW




            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

            EXIT FUNCTION
        END IF

        CALL dlgControllerHelperScreen()
        DIALOG SHOW MODAL globals.hdl.DlgHelper, CALL cbControllerHelperScreen TO hr

        CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerExit() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL closeEventFile()

        DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION

SUB dlgControllerHelperScreen()
         #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->

    DIALOG NEW PIXELS, 0, "Enter parameters", 336, 234, 485, 315, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 66, 12, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, "", 64, 48, 384, 88, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_MULTILINE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_COMMENT, "", 17, 201, 448, 43
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 121, 273, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING CALL cbHelperScreenOK()
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 212, 273, 75, _
        23,,, CALL cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 312, 272, 24, 24,,, CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9903, "Subject ID:", 6, 16, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9905, "Initial comment:", 20, 186, 80, 13
    CONTROL ADD LINE,    globals.hdl.DlgHelper, %IDC_LINE1, "Line1", 0, 167, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL5, "Description:", 4, 52, 60, 13

#PBFORMS END DIALOG
    CONTROL SET FOCUS globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID
END SUB

CALLBACK FUNCTION cbControllerHelperScreen()
    LOCAL PS AS paintstruct
    LOCAL temp AS STRING
    LOCAL lError AS LONG

    SELECT CASE CBMSG
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y, lbCount AS LONG
    LOCAL temp, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255
    LOCAL buttonName AS STRING

    EXPERIMENT.SessionDescription.INIFile = "ElapsedTimeKeeper.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile




    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID TO temp
        lResult = WritePrivateProfileString( "Subject Section", "ID", temp, filename)
        globals.SubjectID = VAL(temp)
        IF (globals.SubjectID < 0 OR globals.SubjectID > 9999) THEN
            MSGBOX "Subject ID should be a number between 1 and 9999."
            EXIT FUNCTION
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION TO temp
        lResult = WritePrivateProfileString( "Experiment Section", "Description", temp, filename)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO temp
        WritePrivateProfileString( "Experiment Section", "Comment", temp + "(" + DATE$ + " " + TIME$ + ")", filename)

        '*****************************************************************************
        'Write out the conditions to the conditions file.
        '*****************************************************************************
        'CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR TO temp
        tempFileName = filename
        REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\ASCCondition.txt" IN tempFileName
        'CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC TO GVDesc


        OPEN tempFileName FOR OUTPUT AS #1
        PRINT #1, "The GV is used for generic ASC experiments."

        'LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount

        'added a SPECIAL GV condition for altered states that may happen spontaneously
        'LISTBOX ADD globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, "SPECIAL," + STR$(lbCount + 1)

        'FOR x = 1 TO lbCount + 1
        '    LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x TO temp
        '    PRINT #1, temp
        'NEXT x

        PRINT #1, "ClickMe,1"
        'PRINT #1, "SpecialEvent, 88"
        'PRINT #1, "EndEpoch,99"
        PRINT #1, "xxx,999"

        CLOSE #1


        '*****************************************************************************
        CALL LoadINISettings()

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        'globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        'CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)


        DIALOG SHOW STATE globals.hdl.DlgHelper, %SW_HIDE

        CustomMessageBox(1, "Press OK to start Run.", "Start Run")

        CALL dlgSubjectScreen()



        '*****************************************************************************
        'Create buttons out the conditions in the conditions file.
        '*****************************************************************************
        'LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount

        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult



        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW




        'DO
        '    DIALOG DOEVENTS
        '    DIALOG GET SIZE ghDlgController TO x&, x&
        'LOOP WHILE x& ' When x& = 0, dialog has ended


        DIALOG END CBHNDL
    END IF
END FUNCTION


CALLBACK FUNCTION cbHelperScreenCancel() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        DIALOG END CBHNDL, 0
    END IF
END FUNCTION

CALLBACK FUNCTION cbHelperScreenHelp() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        SHELL("NOTEPAD.EXE HelpFile.txt")
    END IF
END FUNCTION

SUB dlgSubjectScreen()
    'DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1522, 831, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2
    LOCAL hFont1 AS DWORD

'=======
'DIALOG NEW PIXELS, 0, "Elapsed Timer Keeper", 112, 186, 1200, 800, _
'        TO globals.hdl.DlgSubject
    CONTROL ADD BUTTON,   globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, "End Experiment", _
        520, 744, 136, 40, , , CALL cbEndExperiment
    CONTROL ADD LABEL,    globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, "", 312, 40, 616, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, globals.hdl.DlgSubject, %IDC_CHECKBOX_speech, "Speech synthesis", _
        968, 240, 120, 24
    ' %WS_GROUP...
    CONTROL ADD LISTBOX,  globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, , 312, 112, 616, _
        608, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR _
        %WS_VSCROLL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   globals.hdl.DlgSubject, %IDC_BUTTON_CopyToClip, "Copy to clipboard", _
        944, 296, 168, 40,,, CALL cbButton_CopyToClip()
'=======
    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, hFont1
    'CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ADD_COMMENTS, hFont1
    CONTROL SET CHECK globals.hdl.DlgSubject, %IDC_CHECKBOX_speech, 1




#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

     'globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)
     DIALOG REDRAW globals.hdl.DlgSubject
END SUB

CALLBACK FUNCTION cbSubjectScreen()
    DIM temp AS STRING

    SELECT CASE CB.MSG
        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
       CASE %WM_TIMER
                INCR globals.timerInterval
                temp = globals.buttonName
                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_STOPWATCH, "Event: " + STR$(globals.trialCnt) + "   Start   " + temp + _
                            "  elapsed: " +  STR$(globals.timerInterval)  + "   Time: " + TIME$
     CASE %WM_ContextMenu
        globals.Response = 1

        CALL SubjectResponse()
    END SELECT

END FUNCTION



CALLBACK FUNCTION cbEndExperiment
'    LOCAL nbrSpclEvts AS LONG
'    LOCAL headerFile AS ASCIIZ * 255
'
'    headerFile = ConvertToFullPath(EXPERIMENT.SessionDescription.HDRFile)
'    LISTBOX GET COUNT globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES TO nbrSpclEvts
'    IF (nbrSpclEvts > 0 ) THEN
'        MSGBOX "Please add comments for the special events.", %MB_OK, "Add Special Event notes to Header file "
'        SHELL ("Y:\Utilities\ModifyHeaderComment\ModifyHeaderComment.exe " + headerFile, 1)
'    END IF
    CALL ButtonEvent99
    DIALOG END CBHNDL
END FUNCTION


CALLBACK FUNCTION cbButton_CopyToClip
    DIM x AS LONG
    DIM lbCount AS LONG
    DIM clipResult AS LONG
    DIM temp AS STRING
    DIM lbItem AS STRING

    temp = ""
    LISTBOX GET COUNT globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES TO lbCount
    FOR x = 1 TO lbCount
        LISTBOX GET TEXT globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, x TO lbItem
        temp = temp + lbItem + $CRLF
    NEXT x

    CLIPBOARD RESET, clipResult
    IF (clipResult = 0) THEN
        MSGBOX "Problem resetting the clipboard."
        FUNCTION = 0
    END IF

    CLIPBOARD SET TEXT temp, clipResult
    IF (clipResult = 0) THEN
        MSGBOX "Problem copying text to the clipboard."
        FUNCTION = 0
    END IF
END FUNCTION



CALLBACK FUNCTION cbButtonEvent99
    CALL ButtonEvent99
END FUNCTION

SUB ButtonEvent99
    IF (hasAStartEpochOccured() = %TRUE) THEN
        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
        globals.TargetTime = GetTimeWithSeconds()
        EVENTSANDCONDITIONS(1).EvtName = "EndEpoch"
        EVENTSANDCONDITIONS(1).NbrOfGVars = 0
        EVENTSANDCONDITIONS(1).Index = globals.DioIndex
        EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(1).Time = globals.TargetTime


        EVENTSANDCONDITIONS(1).GVars(0).Condition = "ASCCondition"
        EVENTSANDCONDITIONS(1).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(1).EvtName, EVENTSANDCONDITIONS(1).GVars(0).Condition, globals.EndEpochResponse)

        CALL WriteToEventFile2(1)
    END IF
END SUB

FUNCTION SubjectResponse() AS LONG
    DIM lResult AS LONG
    DIM temp AS STRING


    'IF (hasAStartEpochOccured() = %TRUE) THEN
        CALL ButtonEvent99
    'END IF

    globals.EpochInfo(globals.Response).Flag = %TRUE

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = GetTimeWithSeconds()
    EVENTSANDCONDITIONS(0).EvtName = "StartEpoch"
    EVENTSANDCONDITIONS(0).NbrOfGVars = 0
    EVENTSANDCONDITIONS(0).Index = globals.DioIndex
    EVENTSANDCONDITIONS(0).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(0).Time = globals.TargetTime

    EVENTSANDCONDITIONS(0).GVars(0).Condition = "ASCCondition"
    EVENTSANDCONDITIONS(0).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(0).EvtName, EVENTSANDCONDITIONS(0).GVars(0).Condition, globals.Response)

    CALL WriteToEventFile2(0)

    globals.buttonName =  EVENTSANDCONDITIONS(0).GVars(0).Desc

    CONTROL GET CHECK globals.hdl.DlgSubject, %IDC_CHECKBOX_speech TO lResult

    'IF (lResult = 1 AND globals.buttonName <> "SPECIAL") THEN
        'speak("Start " + globals.buttonName)
    '    speak(str$(globals.totalTime))
    'END IF

    KillTimer globals.hdl.DlgSubject, &H3E8
    CALL SetTimer(globals.hdl.DlgSubject, BYVAL &H3E8, 1000, BYVAL %NULL)

    globals.totalTime = globals.totalTime + globals.timerInterval
    globals.trialCnt = globals.trialCnt + 1
    globals.timerInterval = 0

    IF (lResult = 1 AND TRIM$(globals.buttonName) = "ClickMe") THEN
        CONTROL SET COLOR globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, %RGB_RED, %RGB_WHITE
        LISTBOX ADD globals.hdl.DlgSubject, %IDC_LISTBOX_SPECIALNOTES, "Event: " + _
                                STR$(globals.trialCnt) + " Time (mm:ss): " + RIGHT$(TIME$,5)
        speak(RIGHT$(TIME$,5))
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

FUNCTION speak(a AS STRING) AS LONG
  DIM oSp AS DISPATCH                                         '// flag tells us when the talking is done
  DIM oVTxt AS VARIANT                                        '// text to speak
  DIM oVFlg AS VARIANT                                        '// flag to pass to the speech engine
  DIM buf AS LOCAL STRING                                     '// local working buffer
  SET oSp = NEW DISPATCH IN "SAPI.SpVoice.1"                  '// this is the module we want to point at
  IF ISFALSE ISOBJECT(oSp) THEN                               '// did we fail to load the requested object?
    MSGBOX "Speech engine failed to initialize!" '// tell someone we failed
    FUNCTION = 0                                              '// pass back our failure
    EXIT FUNCTION                                             '// leave, we can't do anything here
  END IF
  IF LEN(a) > 0 THEN                                          '// only speak if we have something to say
    oVTxt = a                                                 '// move dynamic string text into custom variable
    oVFlg = %SVSFlagsAsync                                    '// this is what we want the engine to do (talk)
    OBJECT CALL oSp.Speak(oVTxt, oVFlg)                       '// pass all of the info to the speecch engine
    buf = a                                                   '// make a copy because we will modify
    DO WHILE LEN(buf) > 0                                     '// loop while there something left in the buffer
      DO WHILE INSTR(buf, $CRLF) > 0
        xbox(LEFT$(buf, INSTR(buf, $CRLF) - 1))               '// show first part
        buf = MID$(buf, INSTR(buf, $CRLF) + 2)                '// clip off first part
      LOOP
      IF LEN(buf) > 0 THEN                                    '// is there anything left?
        xbox(buf)                                             '// show it
        buf = ""                                              '// clean out the buffer
      END IF
    LOOP
    DO                                                        '// Give the speech engine a chance to finish
      SLEEP 100                                               '// let other programs have some of our CPU time
      oVFlg = 100                                             '// set a starting point for our activity flag so we know if the following line changed it
      OBJECT CALL oSp.WaitUntilDone(oVFlg) TO oVFlg           '// ask the speech engine if it is done yet
    LOOP UNTIL VARIANT#(oVFlg)                                '// keep asking until we get our answer
  ELSE                                                        '// nothing to say?
    xbox(a)
  END IF
  SET oSp = NOTHING
END FUNCTION
