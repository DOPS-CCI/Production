
SUB dlgControllerHelperScreen()
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->

    LOCAL hFont1 AS DWORD


    DIALOG NEW PIXELS, 0, "Enter parameters", 259, 225, 319, 540, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_NbrOfRuns, "1", 170, 16, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "24", 170, 56, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 170, 96, 100, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "180000", 170, 132, 100, _
        24, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS, "AIB (Feedback)", 24, _
        184, 168, 24
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_RNG, "RNG (Feedback)", 24, 248, 168, 24
    ' %WS_GROUP...
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, "Focus High", 36, 312, _
        112, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR _
        %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_FocusLow, "Focus Low", 160, 312, _
        104, 24
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", 104, _
        360, 136, 37, , CALL cbHelperScreenLongDesc()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_AudioChoices, "Audio Choices", _
        104, 405, 136, 37  , , CALL cbHelperScreenAudioChoices()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 104, _
        448, 136, 37, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 72, 496, 75, 37, _
        %WS_CHILD OR %WS_VISIBLE OR %BS_TEXT OR %BS_PUSHBUTTON OR %BS_CENTER _
        OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING , CALL cbHelperScreenOK()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 160, 496, 75, _
        37 , , CALL cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 264, 504, 24, 24, , CALL cbHelperScreenHelp()
    ' %WS_GROUP...
    CONTROL ADD OPTION,  globals.hdl.DlgHelper, %IDC_OPTION_Standard, "AP (no Feedback)", 24, _
        216, 168, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP _
        OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_01, "Number of trials per run:", 0, 56, 166, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_02, "Subject ID:", 69, 96, 97, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_04, "Trial duration (ms):", 34, _
        132, 132, 28, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL_05, "Number of runs:", 54, 16, 112, _
        28, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME1, "", 8, 168, 296, 112
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME_RNG, "RNG", 12, 296, 288, 45

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT globals.hdl.DlgHelper, -1, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_TEXTBOX_NbrOfRuns, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_OPTION_RNG, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_OPTION_FocusLow, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_AudioChoices, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPEROK, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_OPTION_Standard, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL_01, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL_02, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL_04, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL_05, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_FRAME_RNG, hFont1

    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_Standard, 1
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_FRAME_RNG
    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, 1
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
    'CONTROL DISABLE globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS



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
                    gStandardRNGTCPIP = 1 'Standard
                CASE %IDC_OPTION_RNG
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_FRAME_RNG
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
                    CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
                    gStandardRNGTCPIP = 2 'RNG
                CASE %IDC_OPTION_TCPIPRMS
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_FRAME_RNG
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh
                    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh, 0
                    CONTROL HIDE globals.hdl.DlgHelper, %IDC_OPTION_FocusLow
                    CONTROL SET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusLow, 0
                    gStandardRNGTCPIP = 3 'TCPIP/RMS
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
    ELSE
        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_RNG TO lResult
        IF (lResult = 1) THEN
            CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh TO lResult
            IF (lResult = 1) THEN
                CALL CreateFocusHighFile()
            END IF
            CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusLow TO lResult
            IF (lResult = 1) THEN
               CALL CreateFocusLowFile()
            END IF
        ELSE
            CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
            IF (lResult = 1) THEN
                CALL CreateFocusFile()
            END IF
        END IF
    END IF
    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "AudioSoundChoices.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION


CALLBACK FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL hr, topMost AS DWORD
    GLOBAL hRMSSettingsDlg AS DWORD
    LOCAL filename, temp AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    IF (gStandardRNGTCPIP = 3) THEN 'TCPIP/RMS
        WritePrivateProfileString( "Experiment Section", "ActiviewConfigUsed", "YES", EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)
    ELSE
        WritePrivateProfileString( "Experiment Section", "ActiviewConfigUsed", "NO", EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)
    END IF

    SetWindowPos(globals.hdl.DlgHelper, %HWND_NOTOPMOST, 0, 0, 0, 0, %SWP_NOMOVE OR %SWP_NOSIZE)

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings3\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL lResult, lTemp, x, y, lenTrialOrder AS LONG
    LOCAL temp, subjDir AS ASCIIZ * 255
    LOCAL filename, EEGDefaultFilename AS ASCIIZ * 255
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
        ELSE
            CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_RNG TO lResult
            IF (lResult = 1) THEN
                CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusHigh TO lResult
                IF (lResult = 1) THEN
                    CALL CreateFocusHighFile()
                END IF
                CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_FocusLow TO lResult
                IF (lResult = 1) THEN
                   CALL CreateFocusLowFile()
                END IF
            ELSE
                CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
                IF (lResult = 1) THEN
                    CALL CreateFocusFile()
                    gEEGRMSTime = INT(globals.TrialLength / 1000)  'TrialLength is in milliseconds - gEEGRMSTime needs to be in seconds
                END IF
            END IF
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

        CONTROL ENABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices

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

'        CustomMessageBox(0, "1) Batteries are turned on." + $CRLF + _
'            "2) Macro Express Pro is running on Biosemi." + $CRLF + _
'            "3) S.R. Monitor is on and check volume." + $CRLF + _
'            "4) S.R. fan is on." + $CRLF + _
'            "5) S.R. lights are on. Press OK.", "Check List")
'



        '======================================================
        'added 5/13/2014 - changed a MessageBox into a dialog
        ' that the user has to check off items.
        '======================================================
        CALL ShowDIALOGExptCheckList(0)


        '======================================================
        'added 5/20/2014 - changed a MessageBox into a dialog
        ' to allow a sound check.
        '======================================================
        CALL ShowDIALOGSoundCheck(0)


        CALL StartupActiview()

        CustomMessageBox3(0, "DO NOT TOUCH BIOSEMI MOUSE!" + $CRLF + _
            "Click below when ready to start Biosemi recording.", "Start Biosemi Recording", 12)

        CALL StartBiosemiRecord()

        '======================================================
        'added 5/21/2014 - changed a MessageBox into a dialog
        ' to allow a method to sync video and BDF.
        '======================================================
        SLEEP 8000

        CALL ShowDIALOG_BiosemiRecording(0)
        '**********************************************************************************************


        'CustomMessageBox(1, "Press OK to start trials.", "Start Trials")



        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12


        globals.RunCnt = 1
        globals.TrialCnt = 1
        globals.TrialCntTotal = 1

        REDIM gIntentionFocus(globals.NbrOfTrials * globals.NbrOfRuns)
        REDIM AudioOrder(20)

        GetPrivateProfileString("Experiment Section", "TrialOrder", "", TrialOrder, %MAXPPS_SIZE, filename)
        PARSE TrialOrder, AudioOrder(), ","
        lenTrialOrder = PARSECOUNT(TrialOrder, ",") - 1

        y = 0
        FOR X = 1 TO globals.NbrOfTrials * globals.NbrOfRuns


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

            gStandardRNGTCPIP = 2 'RNG

            gSampleDuration = 1000   ' 1 second
            gSampleSize = 50        '25 samp/sec but need 50 because were doing even/odd picks
            REDIM gSamples(gSampleSize)

            gRndCnt = 0

            CALL StartExperiment()

            CONTROL DISABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices

            GetPrivateProfileString("Subject Section", "FileFolder", "", subjDir, 255, filename)


            gRNDFile = subjDir + "\" + LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4) + "-RNG.CSV"
            gARSFile = subjDir + "\" + LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4)  + "-ANG.CSV"
            OPEN gRNDFile FOR APPEND AS #900
            OPEN gARSFile FOR APPEND AS #950
            PRINT #900, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using odd samples
            PRINT #900, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"
            PRINT #950, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using even samples
            PRINT #950, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"

            'CALL StartTrial()
            'gTimers.Add("SUBJECTDIODE", vTimers)
            'SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)

            gPauseFlag = %TRUE
            gTimers.Add("DELAY", vTimers)
            SetMMTimerDuration("DELAY", 5000)
            SetMMTimerOnOff("DELAY", 1)    'turn on



            gTimers.Add("GETRESULT", vTimers)
            SetMMTimerDuration("GETRESULT", 1000)

            'gTimers.Add("STARTTRIAL", vTimers)
            'SetMMTimerDuration("STARTTRIAL", 5000)

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
            gStandardRNGTCPIP = 1 'Standard

            '**********************************************************************************************
            'added 07/14/2014 per Ross Dunseath - wanted to have the ability of generating RNG and
            'alternate RNG files no matter what option is chosen.
            '**********************************************************************************************

            'turn off using the RNG that was originally being used by the program
            'and use the rng class
            oApp = NOTHING

            LET rngInt = CLASS "EvenOddRNGClass"

            rngInt.SetDuration(1000)
            rngInt.SetSampleSize(50)
            rngInt.SetINIFilename(EXPERIMENT.SessionDescription.INIFile)

            rngInt.StartHiddenRNGWindow()
            '**********************************************************************************************

            CALL StartExperiment()

            gRNDFile = ""

            CONTROL DISABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices

            gTimers.Add("DELAY", vTimers)
            SetMMTimerDuration("DELAY", 5000)

            gTimers.Add("ENDINTENTION", vTimers)
            SetMMTimerDuration("ENDINTENTION", 5000)

            'gTimers.Add("SUBJECTDIODE", vTimers)
            'SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)

            SetMMTimerOnOff("DELAY", 1)    'turn on

            'Start the timers
            setMMTimerEventPeriodic(1, 0)
        END IF

        CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_OPTION_TCPIPRMS TO lResult
        IF (lResult = 1) THEN

            '========================================================
            'added 4/3/2014 per Ross Dunseath - Ross wanted to add
            'the same RNG capability that is running in the RNG
            'part of this application (uses MM timer). We will now
            'be gathering RNG numbers in the TCPIP sampling loop.
            '========================================================
            gRndCnt = 0

            IF (%RNG_ONOFF = 1) THEN
                gSampleDuration = 1000   ' 1 second
                gSampleSize = 50        '25 samp/sec but need 50 because were doing even/odd picks
                REDIM gSamples(gSampleSize)

                filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

                GetPrivateProfileString("Subject Section", "FileFolder", "", subjDir, 255, filename)

                gRNDFile = subjDir + "\" + LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4) + "-RNG.CSV"
                gARSFile = subjDir + "\" + LEFT$(EXPERIMENT.SessionDescription.HDRFile, LEN(EXPERIMENT.SessionDescription.HDRFile) - 4)  + "-ANG.CSV"
                #DEBUG PRINT "gRNDFile: " + gRNDFile
                #DEBUG PRINT "gARSFile: " + gARSFile

                OPEN gRNDFile FOR APPEND AS #900
                OPEN gARSFile FOR APPEND AS #950

                #DEBUG PRINT "err: " + STR$(ERR)

                PRINT #900, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using odd samples
                PRINT #900, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"
                PRINT #950, "Sample Size " +   STR$((gSampleSize * 8) / 2) +  " bits"       ' We are actually getting 50 samples, but are using even samples
                PRINT #950, "Time, Trial Sec, Bitsum-ev, Cum Z, Type"

                gAccumNbrBits = 0
                gAccumDev = 0
                gOldZScore = 0
                gSavedZScore = 0
                gFirstHit = 1
                gRunningDuration = 0

            END IF
            '========================================================

            gRunDelayFlag = 0

            gStandardRNGTCPIP = 3 'TCPIP/RMS

            CALL StartExperiment()

            CONTROL DISABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices

            gRNDFile = ""

            CALL loadTCPIPDefaults(EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)


            connectToServer(TCPIPSettings.IPAddress, TCPIPSettings.IPPort, TCPIPSettings.TCPIPSocket)

            processServerData(TCPIPSettings.TCPIPSocket)
        END IF


        'CONTROL ENABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices

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
    OPEN EXE.PATH$ + "Conditions\Intention.txt" FOR OUTPUT AS #555
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
     OPEN EXE.PATH$ + "Conditions\Intention.txt" FOR OUTPUT AS #555
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
     OPEN EXE.PATH$ + "Conditions\Intention.txt" FOR OUTPUT AS #555
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

SUB StartExperiment()
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    LET MyTime = CLASS "PowerTime"



    '**********************************************************************************************
    'Adding a StartExperiment event and an EndExperiment event 6/19/2013 - FAA
    '**********************************************************************************************
    MyTime.Now()
    MyTime.FileTime TO now
       'iVPos = 200
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(3).EvtName = "StartExperiment"
    EVENTSANDCONDITIONS(3).NbrOfGVars = 1
    EVENTSANDCONDITIONS(3).Index = globals.DioIndex
    EVENTSANDCONDITIONS(3).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(3).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(3).EventTime = PowerTimeDateTime(MyTime)

    IF (gStandardRNGTCPIP = 3) THEN 'TCPIP feed
        MyTime.FileTime TO now
        MyTime.Now()
        gStartExperiment = GetPowerTimeTotalMillis(MyTime)
        gAIBTiming = 0

        EVENTSANDCONDITIONS(3).GVars(0).Condition = "Milliseconds"
        EVENTSANDCONDITIONS(3).GVars(0).Desc = STR$(gAIBTiming)
    ELSE
        EVENTSANDCONDITIONS(3).GVars(0).Condition = "Milliseconds"
        EVENTSANDCONDITIONS(3).GVars(0).Desc = LookupLegitimateGV(EVENTSANDCONDITIONS(3).EvtName, EVENTSANDCONDITIONS(3).GVars(0).Condition, gTimerTix)
    END IF
    CALL WriteToEventFile2(3)
    '**********************************************************************************************
END SUB
