SUB dlgControllerHelperScreen()
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->


    'LOCAL hDlg  AS DWORD
    DIALOG NEW PIXELS, 0, "Enter parameters", 336, 225, 279, 452, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_NbrOfRuns, "1", 128, 24, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "24", 129, 60, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 129, 98, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "180000", 129, 136, 100, _
        20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_Standard, "Standard", 20, 191, 76, _
        24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT _
        OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_RNG, "RNG", 104, 191, 56, 24
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS, "TCPIP/RMS", 160, 191, _
        88, 24
    ' %WS_GROUP...
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, "Focus High", 48, 243, _
        72, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR _
        %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_FocusLow, "Focus Low", 132, 243, _
        72, 24
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", 72, _
        312, 120, 24, , CALL cbHelperScreenLongDesc()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_AudioChoices, "Audio Choices", 72, _
        344, 120, 24 , , CALL cbHelperScreenAudioChoices()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 72, _
        376, 120, 24, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 33, 412, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING , CALL cbHelperScreenOK()
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 124, 412, 75, _
        23, , CALL cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 224, 411, 24, 24, , CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_01, "Number of trials:", 46, 64, _
        83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_02, "Subject ID:", 69, 102, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_04, "Trial duration (ms):", 28, _
        140, 96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_05, "Number of runs:", 45, 28, 83, _
        13
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME1, "", 8, 176, 264, 48
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME_RNG, "RNG", 8, 232, 264, 40
#PBFORMS END DIALOG

    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_Standard, 1
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_FRAME_RNG
    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, 1
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
    CONTROL DISABLE globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS



END SUB

CALLBACK FUNCTION cbControllerHelperScreen()
    LOCAL PS AS paintstruct
    LOCAL temp AS STRING
    LOCAL lError, lResult AS LONG

    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
            gHelperOpened = 1 'Helper screen opened
        CASE %WM_DESTROY
            gHelperOpened = 0 'Helper screen opened
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_OPTION_Standard
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_FRAME_RNG
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
                CASE %IDC_OPTION_RNG
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_FRAME_RNG
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
                CASE %IDC_OPTION_TCPIPRMS
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_FRAME_RNG
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
                CASE %IDC_OPTION_FocusHigh
                CASE %IDC_OPTION_FocusLow
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

CALLBACK FUNCTION cbHelperScreenAudioChoices() AS LONG
    '**********************************************************************************************
    'Added per Ross Dunseath 8/6/2013 to allow multiple audio file choices.
    '**********************************************************************************************
    LOCAL exitVar, lResult AS LONG
    LOCAL filename AS ASCIIZ *256

    CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_Standard TO lResult
    IF (lResult = 1) THEN
       CALL CreateFocusFile()
    END IF
    CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh TO lResult
    IF (lResult = 1) THEN
        CALL CreateFocusHighFile()
    END IF
    CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusLow TO lResult
    IF (lResult = 1) THEN
       CALL CreateFocusLowFile()
    END IF
    CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
    IF (lResult = 1) THEN
        CALL CreateFocusFile()
    END IF

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "AudioSoundChoices.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION


CALLBACK FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL lResult, lTemp, x, y, lenTrialOrder AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    STATIC pt AS POINTAPI
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers
    LOCAL TrialOrder AS ASCIIZ * 256
    LOCAL audioOrder() AS STRING

    EXPERIMENT.SessionDescription.INIFile = "AudioPacedTrials.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

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


        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_Standard TO lResult
        IF (lResult = 1) THEN
           CALL CreateFocusFile()
        END IF
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh TO lResult
        IF (lResult = 1) THEN
            CALL CreateFocusHighFile()
        END IF
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusLow TO lResult
        IF (lResult = 1) THEN
           CALL CreateFocusLowFile()
        END IF
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
        IF (lResult = 1) THEN
            CALL CreateFocusFile()
        END IF

        CALL LoadINISettings()

        CALL readInWavFiles()

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
        EVENTSANDCONDITIONS(3).EvtName = "StartExperiment"
        EVENTSANDCONDITIONS(3).NbrOfGVars = 0
        EVENTSANDCONDITIONS(3).Index = globals.DioIndex
        EVENTSANDCONDITIONS(3).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(3).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(3).EventTime = PowerTimeDateTime(MyTime)
        EVENTSANDCONDITIONS(3).ElapsedMillis = gTimerTix
        CALL WriteToEventFile2(3)
        '**********************************************************************************************

        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12


        globals.RunCnt = 1
        globals.TrialCnt = 1
        globals.TrialCntTotal = 1

        REDIM gIntentionFocus(globals.NbrOfTrials)
        REDIM AudioOrder(20)

        GetPrivateProfileString("Experiment Section", "TrialOrder", "", TrialOrder, %MAXPPS_SIZE, filename)
        PARSE TrialOrder, AudioOrder(), ","
        lenTrialOrder = PARSECOUNT(TrialOrder, ",") - 1

        y = 0
        FOR X = 1 TO globals.NbrOfTrials


            gIntentionFocus(x) =  VAL(AudioOrder(y))
            INCR y

            IF (x MOD lenTrialOrder = 0) THEN
                y = 0
                'ITERATE FOR
            END IF

            '#DEBUG PRINT STR$(x) + ", " + STR$(gIntentionFocus(x))
        NEXT X


         '=================================================================
        'added 11/5/2013 - if RNG is checked then turn on the RNG
        'functionality.
        '=================================================================
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_RNG TO lResult
        IF (lResult = 1) THEN
            gRNDFile = LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4) + "-RNG.CSV"
            gARSFile = LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4)  + "-ANG.CSV"
            OPEN gRNDFile FOR APPEND AS #900
            OPEN gARSFile FOR APPEND AS #950
            PRINT #900, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using odd samples
            PRINT #900, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"
            PRINT #950, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using even samples
            PRINT #950, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"

            'CALL StartTrial()
            gTimers.Add("SUBJECTDIODE", vTimers)
            SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)

            gPauseFlag = %TRUE
            gTimers.Add("DELAY", vTimers)
            SetMMTimerDuration("DELAY", 5000)
            SetMMTimerOnOff("DELAY", 1)    'turn on



            gTimers.Add("GETRESULT", vTimers)
            SetMMTimerDuration("GETRESULT", 1000)

            'gTimers.Add("STARTTRIAL", vTimers)
            'SetMMTimerDuration("STARTTRIAL", 5000)

            gStandardRNGTCPIP = 2 'RNG
            gAccumNbrBits = 0
            gAccumDev = 0
            gOldZScore = 0
            gSavedZScore = 0
            gFirstHit = 1
            'SetMMTimerOnOff("GETRESULT", 1)    'turn on
            'SetMMTimerOnOff("STARTTRIAL", 1)    'turn on
            'Start the timers
            setMMTimerEventPeriodic(1, 0)
        END IF

        '=================================================================
        'If Standard is checked then do the normal audio paced trials
        'functionality.
        '=================================================================
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_Standard TO lResult
        IF (lResult = 1) THEN
            gRNDFile = ""

            gTimers.Add("DELAY", vTimers)
            SetMMTimerDuration("DELAY", 5000)

            gTimers.Add("ENDINTENTION", vTimers)
            SetMMTimerDuration("ENDINTENTION", 5000)

            gTimers.Add("SUBJECTDIODE", vTimers)
            SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)

            SetMMTimerOnOff("DELAY", 1)    'turn on

            gStandardRNGTCPIP = 1 'Standard

            'Start the timers
            setMMTimerEventPeriodic(1, 0)
        END IF

        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
        IF (lResult = 1) THEN
            gRNDFile = ""
        END IF



     ' InitializeComponent()
        CALL dlgSubjectScreen()



        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
        DIALOG HIDE globals.hdl.DlgSubject






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

SUB CreateFocusFile()
    OPEN EXE.PATH$ + "\Conditions\Intention.txt" FOR OUTPUT AS #555
    PRINT #555, "Target selected by computer."
    PRINT #555, "REST,1,Rest.wav"
    PRINT #555, "FOCUS,2,Focus.wav"
    PRINT #555, "UP,3,Up.wav"
    PRINT #555, "DOWN,4,Down.wav"
    PRINT #555, "xxx,999,"
    CLOSE #555
    gHighOrLow = 0
END SUB

SUB CreateFocusHighFile()
     OPEN EXE.PATH$ + "\Conditions\Intention.txt" FOR OUTPUT AS #555
    PRINT #555, "Target selected by computer."
    PRINT #555, "REST,1,Rest.wav"
    PRINT #555, "FOCUSHIGH,2,FocusHigh.wav"
    PRINT #555, "UP,3,Up.wav"
    PRINT #555, "DOWN,4,Down.wav"
    PRINT #555, "xxx,999,"
    CLOSE #555
    gHighOrLow = 1
END SUB

SUB CreateFocusLowFile()
     OPEN EXE.PATH$ + "\Conditions\Intention.txt" FOR OUTPUT AS #555
    PRINT #555, "Target selected by computer."
    PRINT #555, "REST,1,Rest.wav"
    PRINT #555, "FOCUSLOW,2,FocusLow.wav"
    PRINT #555, "UP,3,Up.wav"
    PRINT #555, "DOWN,4,Down.wav"
    PRINT #555, "xxx,999,"
    CLOSE #555
    gHighOrLow = 2
END SUB




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
