SUB dlgControllerHelperScreen()
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->

    'LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, 0, "Enter parameters", 336, 234, 385, 515, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_NBRRUNS, "1", 200, 24, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "25", 200, 56, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 200, 99, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_AGENTID, "", 200, 137, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION, "2000", 200, 175, _
        100, 24, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "4000", 200, 213, 100, _
        24, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD CHECKBOX, globals.hdl.DlgHelper, %CHECKBOX_FEEDBACK, "Feedback", 128, 264, _
        118, 29
    CONTROL ADD CHECKBOX, globals.hdl.DlgHelper, %IDC_CHECKBOX_UseRNG, "Use RNG", 128, 292, _
        118, 29
    CONTROL ADD CHECKBOX, globals.hdl.DlgHelper, %IDC_CHECKBOX_Precog, "Precognitive", 128, _
        320, 118, 29
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 120, _
        371, 136, 32, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", _
        120, 412, 136, 32, , CALL cbHelperScreenLongDesc()
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 72, 472, 75, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %BS_TEXT OR %BS_PUSHBUTTON OR %BS_CENTER _
        OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 163, 472, 75, _
        32, , , CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELP, "?", 263, 471, 32, 32, , , CALL cbHelperScreenHelp
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9900, "Number of runs:", 60, 27, 124, _
        25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9901, "Number of trials:", 60, 65, 124, _
        25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9902, "Subject ID:", 60, 103, 124, 25, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9903, "Agent ID:", 60, 141, 124, 25, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9904, "Display duration (ms):", 18, 179, _
        166, 25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9905, "Enforced delay (ms):", 20, 217, _
        164, 25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_NBRRUNS, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_AGENTID, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %CHECKBOX_FEEDBACK, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_CHECKBOX_UseRNG, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_CHECKBOX_Precog, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPEROK, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELP, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9900, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9901, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9902, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9903, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9904, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9905, hFont1
#PBFORMS END DIALOG


    CONTROL SET CHECK globals.hdl.DlgHelper, %CHECKBOX_FEEDBACK, 1
END SUB

CALLBACK FUNCTION cbControllerHelperScreen()
    LOCAL PS AS paintstruct
    LOCAL temp AS STRING
    LOCAL lError AS LONG

    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
            gHelperOpened = 1 'Helper screen opened
        CASE %WM_DESTROY
            gHelperOpened = 0 'Helper screen opened
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION


CALLBACK FUNCTION cbHelperScreenLongDesc() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "H:\ModifyLongDescription\ModifyLongDescription.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper


    FUNCTION = exitVar
END FUNCTION

CALLBACK FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL hr, topMost AS DWORD
    GLOBAL hRMSSettingsDlg AS DWORD
    LOCAL filename, temp AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SetWindowPos(globals.hdl.DlgHelper, %HWND_NOTOPMOST, 0, 0, 0, 0, %SWP_NOMOVE OR %SWP_NOSIZE)

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings3\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper
    FUNCTION = exitVar
END FUNCTION


CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    GLOBAL pid AS DWORD
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers

    'EXPERIMENT.SessionDescription.INIFile = "GenericGESP.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    globals.NbrOfHits = 0


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
       CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_NBRRUNS TO temp
        WritePrivateProfileString( "Experiment Section", "NumberOfRuns", temp, filename)
        globals.NbrOfRuns = VAL(temp)
        IF (globals.NbrOfRuns <= 0 OR globals.NbrOfRuns > 20) THEN
            MSGBOX "Number of runs should be a number between 1 and 20."
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

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_AGENTID TO temp
        lResult = WritePrivateProfileString( "Experiment Section", "AgentID", temp, filename)
        IF (TRIM$(temp) = "") THEN
            globals.AgentID = -1
            globals.AgentInRoom = 1
        ELSE
            globals.AgentID = VAL(temp)
            IF (globals.AgentID < 0 OR globals.AgentID > 9999) THEN
                MSGBOX "Agent ID should be a number between 1 and 9999."
                EXIT FUNCTION
            END IF

            globals.AgentInRoom = 2
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION TO temp
        WritePrivateProfileString( "Delay Section", "Delay0Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay0Max", temp, filename)
        globals.ImageDuration = VAL(temp)

        'set up a timer for how long the feedback should display

        gTimers.Add("SUBJECTFEEDBACK", vTimers)
        SetMMTimerDuration("SUBJECTFEEDBACK", VAL(temp))

        'set up a timer for how long subject photodiode stays on
        gTimers.Add("SUBJECTDIODE", vTimers)
        SetMMTimerDuration("SUBJECTDIODE", VAL(temp))

        'set up a timer for how long agent photodiode stays on
        gTimers.Add("AGENTDIODE", vTimers)
        SetMMTimerDuration("AGENTDIODE", VAL(temp))


        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_ITDURATION TO temp
        WritePrivateProfileString( "Delay Section", "Delay1Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay1Max", temp, filename)
        globals.ITDelay = VAL(temp)
        'gTimers(2).Duration = globals.ITDelay

        'Set up a timer to handle the wait/proceed
        gTimers.Add("SUBJECTWAITPROCEED", vTimers)
        SetMMTimerDuration("SUBJECTWAITPROCEED", VAL(temp))


        gTimers.Add("NEXTTRIAL", vTimers)

        'added 2/27/13 - AgentDelay of 1000 ms
        globals.AgentDelay = GetPrivateProfileint("Delay Section", "Delay2Max", 0, filename)

        CONTROL GET CHECK globals.hdl.DlgHelper, %CHECKBOX_FEEDBACK TO lTemp
        IF (lTemp = 1) THEN
            globals.Feedback = 2
            WritePrivateProfileString( "Experiment Section", "Feedback", "yes", filename)
        ELSE
            globals.Feedback = 1
            WritePrivateProfileString( "Experiment Section", "Feedback", "no", filename)
        END IF

        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_CHECKBOX_UseRNG TO lTemp
        IF (lTemp = 1) THEN
            globals.UseRNG = 1
            WritePrivateProfileString( "Experiment Section", "UseRNG", "yes", filename)
        ELSE
            globals.UseRNG = 0
            WritePrivateProfileString( "Experiment Section", "UseRNG", "no", filename)
        END IF

        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_CHECKBOX_Precog TO lTemp
        IF (lTemp = 1) THEN
            globals.Precognitive = 1
            WritePrivateProfileString( "Experiment Section", "Precognitive", "yes", filename)
        ELSE
            globals.Precognitive = 0
            WritePrivateProfileString( "Experiment Section", "Precognitive", "no", filename)
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO temp
        WritePrivateProfileString( "Experiment Section", "Comment", temp + "(" + DATE$ + " " + TIME$ + ")", filename)

        CALL StartModifyExpAndTech(filename)

        CALL LoadINISettings()

        'Initialize Grid Screen placement
        InitializeGrid(EXPERIMENT.Stimulus.Rows, EXPERIMENT.Stimulus.Columns, EXPERIMENT.Stimulus.UpperLeftX, EXPERIMENT.Stimulus.UpperLeftY, _
                    EXPERIMENT.Stimulus.LowerRightX, EXPERIMENT.Stimulus.LowerRightY)

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        'globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

        'CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)

         'CALL dlgAgentScreen()
         'DIALOG SHOW MODELESS globals.hdl.DlgAgent, CALL cbAgentScreen

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

        CustomMessageBox(0, "Please ensure the Biosemi batteries are turned on" + $CRLF + _
            "and that Macro Express Pro is running on the Biosemi machine." + $CRLF + _
            "Press OK when ready to move to the next step.", "Battery and Macro Check")

        pid = SHELL("E:\Program Files\Active WebCam\WebCam.exe", 1)

        CALL StartupActiview()

        CustomMessageBox(0, "Please wait while Biosemi is starting up." + $CRLF + _
            "Use this time to check electrode impedances." + $CRLF + _
            "Press OK when ready to start Biosemi recording.", "Start Biosemi Recording")

        CALL StartBiosemiRecord()

        CustomMessageBox(0, "Wait until Biosemi automatically begins recording" + $CRLF + _
            "then press OK to start the trials.", "Biosemi is Recording")
        '**********************************************************************************************


        CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        globals.RunCnt = 1
        globals.TrialCnt = 0
        globals.TrialCntTotal = 0

        gTimers.Add("SUBJECTWAITPROCEED", vTimers)
        SetMMTimerDuration("SUBJECTWAITPROCEED", 5000)
        SetMMTimerOnOff("SUBJECTWAITPROCEED", 1)   'turn on

        'Start the timers
        setMMTimerEventPeriodic(1, 0)


        CALL dlgSubjectScreen()

        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult

        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_GRID, %SW_SHOW

        EnableButtons(0)



        'globals.TargetShownUpstairs = 2 'No


        'DO
        '    DIALOG DOEVENTS
        '    DIALOG GET SIZE globals.hdl.DlgController TO x&, x&
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
