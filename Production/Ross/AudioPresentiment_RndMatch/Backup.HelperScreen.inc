SUB dlgControllerHelperScreen()
    LOCAL rndTarget AS LONG
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
     DIALOG NEW PIXELS, 0, "Enter parameters", 336, 225, 279, 368, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_EXPTPICK, "1", 128, 16, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_NbrOfRuns, "1", 128, 47, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "24", 129, 83, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 129, 121, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION, "500", 129, 157, _
        100, 20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "500", 129, 197, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 80, _
        247, 120, 24, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 32, 336, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL    cbHelperScreenOK()
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 123, 336, 75, _
        23, , CALL  cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 223, 335, 24, 24, ,  CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_01, "Number of trials:", 46, 87, _
        83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_02, "Subject ID:", 69, 125, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_03, "Display duration (ms):", 27, _
        161, 102, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_04, "Trial duration (ms):", 28, _
        201, 96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_05, "Number of runs:", 45, 51, 83, _
        13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL1, "Pick (1 - 255):", 40, 16, 83, 13
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_TestAudio, "Test Audio", 80, 288, _
        120, 24, , CALL cbHelperScreenTestAudio()
#PBFORMS END DIALOG
    rndTarget = RandomNumber2(1, 255)
    CONTROL SET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_EXPTPICK, STR$(rndTarget)

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


CALLBACK FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    FUNCTION = exitVar
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL lResult, lTemp, x, y AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    STATIC pt AS POINTAPI
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers
    LOCAL targetOrder AS STRING

    EXPERIMENT.SessionDescription.INIFile = "AudioPresentiment.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_EXPTPICK TO temp
        globals.Target = VAL(temp)
        IF (globals.Target <= 0 OR globals.Target > 255) THEN
            MSGBOX "Pick should be a number between 1 and 255."
            EXIT FUNCTION
        END IF


        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_NbrOfRuns TO temp
        WritePrivateProfileString( "Experiment Section", "NumOfRuns", temp, filename)
        globals.NbrOfRuns = VAL(temp)
        IF (globals.NbrOfRuns <= 0 OR globals.NbrOfRuns > 999) THEN
            MSGBOX "Number of runs should be a number between 1 and 999."
            EXIT FUNCTION
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS TO temp
        WritePrivateProfileString( "Experiment Section", "NumOfTrials", temp, filename)
        globals.NbrOfTrials = VAL(temp)
        IF (globals.NbrOfTrials <= 0 OR globals.NbrOfTrials > 999) THEN
            MSGBOX "Number of trials should be a number between 1 and 999."
            EXIT FUNCTION
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID TO temp
        lResult = WritePrivateProfileString( "Subject Section", "ID", temp, filename)
        globals.SubjectID = VAL(temp)
        IF (globals.SubjectID < 0 OR globals.SubjectID > 9999) THEN
            MSGBOX "Subject ID should be a number between 1 and 9999."
            EXIT FUNCTION
        END IF


        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION TO temp
        WritePrivateProfileString( "Delay Section", "Delay0Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay0Max", temp, filename)
        globals.DiodeDelay = VAL(temp)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_ITDURATION TO temp
        WritePrivateProfileString( "Delay Section", "Delay1Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay1Max", temp, filename)
        globals.TrialLength = VAL(temp)

        CALL StartModifyExpAndTech(filename)

        CALL LoadINISettings()

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        'globals.NbrOfRuns = EXPERIMENT.Misc.NbrOfTargets

        'globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        'CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)


        DIALOG SHOW STATE globals.hdl.DlgHelper, %SW_HIDE

        '**********************************************************************************************
        'added 12/11/2012 FAA
        '
        'The following lines were added to add automation functions between the Experiment and
        'the Actiview application on the Biosemi PC. It is using a file semaphore system.
        'The experiment will create a file on the Biosemi machine (see StartupActiview() routine)
        'A macro written in Macro Express Pro is sitting and waiting for a file to be created (via
        'the StartupActiview() routine). This file contains information that will be written in to
        'certain fields in the Actiview program. When the file is created by this experiment, the
        'macro will run, start up Actiview, and fill in the necessary fields. The StartBiosemiRecord()
        'routine also writes a file to the Biosemi PC. This file starts up a macro that starts Actiview
        'recording. The 2 files created: MacroValues.txt and MacroValues2.txt are created on a mapped
        'network drive X: in the directories: \Semaphores\ActiviewStart and \Semaphores\BiosemiRecord
        'respectively.
        '

        pid = SHELL("E:\Program Files\Active WebCam\WebCam.exe", 1)

        CALL StartupActiview()

        CustomMessageBox(0, "Please wait while Biosemi is starting up." + $CRLF + _
            "Use this time to check electrode impedances." + $CRLF + _
            "Press OK when ready to start Biosemi recording.", "Start Biosemi Recording")

        CALL StartBiosemiRecord()

        CustomMessageBox(0, "Wait until Biosemi automatically begins recording" + $CRLF + _
            "then press OK to start the trials.", "Biosemi is Recording")
        '**********************************************************************************************


        'CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        '**********************************************************************************************
        'Adding a StartExperiment event and an EndExperiment event 6/19/2013 - FAA
        '**********************************************************************************************
        LET MyTime = CLASS "PowerTime"
        MyTime.Now()
        MyTime.FileTime TO now
           'iVPos = 200
        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
        EVENTSANDCONDITIONS(2).EvtName = "StartExperiment"
        EVENTSANDCONDITIONS(2).NbrOfGVars = 0
        EVENTSANDCONDITIONS(2).Index = globals.DioIndex
        EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(2).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(MyTime)
        CALL WriteToEventFile2(2)
        '**********************************************************************************************

        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12

        gTimers.Add("TRIALS", vTimers)
        SetMMTimerDuration("TRIALS", 5000)

        gTimers.Add("NOMATCH", vTimers)
        SetMMTimerDuration("NOMATCH", 750)

        gTimers.Add("MATCH", vTimers)
        SetMMTimerDuration("MATCH", 500)


        'gTimers.Add("SUBJECTDIODE", vTimers)
        'SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)



        globals.RunCnt = 1
        globals.TrialCnt = 1
        globals.TrialCntTotal = 1



     ' InitializeComponent()
        CALL dlgSubjectScreen()



        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
        DIALOG HIDE globals.hdl.DlgSubject

        SetMMTimerDuration("NOMATCH", 2000)
        SetMMTimerOnOff("NOMATCH", 0)    'turn off
        SetMMTimerDuration("MATCH", 500)
        SetMMTimerOnOff("MATCH", 0)    'turn off
        SetMMTimerOnOff("TRIALS", 1)    'turn on



        'Start the timers
        setMMTimerEventPeriodic(1, 0)


        'CALL StartTrial()

        'CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        'CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        'CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW


        'STATIC hThread AS DWORD
        'THREAD CREATE WorkThread(x) TO hThread???
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

CALLBACK FUNCTION cbHelperScreenTestAudio() AS LONG
    LOCAL lError AS LONG
    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        PLAY WAVE "WHITE_NOISE", SYNCH
        PLAY WAVE END
    END IF
END FUNCTION
