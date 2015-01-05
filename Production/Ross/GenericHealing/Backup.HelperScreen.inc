SUB dlgControllerHelperScreen()
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->


    DIALOG NEW PIXELS, 0, "Enter parameters", 336, 225, 279, 314, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper , %IDC_TEXTBOX_NbrOfRuns, "1", 128, 24, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper , %TEXTBOX_NBRTRIALS, "24", 129, 60, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper , %TEXTBOX_SUBJECTID, "9999", 129, 98, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper , %TEXTBOX_DISPLAYDURATION, "2000", 129, 134, _
        100, 20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper , %TEXTBOX_ITDURATION, "180000", 129, 174, 100, _
        20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper , %IDC_BUTTON_EEGSettings, "EEG Settings", 80, _
        224, 120, 24, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper , %BUTTON_HELPEROK, "OK", 33, 278, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL    cbHelperScreenOK()
    DIALOG  SEND         globals.hdl.DlgHelper , %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper , %BUTTON_HELPERCANCEL, "Cancel", 124, 278, 75, _
        23, , CALL  cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper , %BUTTON_HELP, "?", 224, 277, 24, 24, ,  CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper , %IDC_LABEL_01, "Number of trials:", 46, 64, _
        83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper , %IDC_LABEL_02, "Subject ID:", 69, 102, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper , %IDC_LABEL_03, "Display duration (ms):", 27, _
        138, 102, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper , %IDC_LABEL_04, "Trial duration (ms):", 28, _
        178, 96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper , %IDC_LABEL_05, "Number of runs:", 45, 28, 83, _
        13
#PBFORMS END DIALOG


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


    SHELL "EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig, 1, EXIT TO exitVar

    FUNCTION = exitVar
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    STATIC pt AS POINTAPI
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers
    LOCAL targetOrder AS STRING

    EXPERIMENT.SessionDescription.INIFile = "GenericHealing.ini"
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
            "The experimenter is responsible to configure EEG settings before recording starts." + $CRLF + _
            "Press OK when ready to start Biosemi recording.", "Start Biosemi Recording")

        CALL StartBiosemiRecord()

        CustomMessageBox(0, "Press OK when Biosemi is recording." + $CRLF + _
            "You can now start the trials.", "Biosemi is Recording")
        '**********************************************************************************************


        'CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12

        gTimers.Add("ENDINTENTION", vTimers)
        SetMMTimerDuration("ENDINTENTION", globals.TrialLength)

        gTimers.Add("SUBJECTDIODE", vTimers)
        SetMMTimerDuration("SUBJECTDIODE", globals.DiodeDelay)



        globals.RunCnt = 1
        globals.TrialCnt = 1
        globals.TrialCntTotal = 1

        REDIM gIntentionFocus(globals.NbrOfTrials)
        targetOrder = "ABBABAAB"

        y = 0
        FOR X = 1 TO globals.NbrOfTrials
            INCR y

            IF (MID$(targetOrder,y, 1) = "A") THEN
                gIntentionFocus(x) =  1
            ELSEIF (MID$(targetOrder,y, 1) = "B") THEN
                gIntentionFocus(x) =  2
            END IF

            IF (x MOD 8 = 0) THEN
                y = 0
                'ITERATE FOR
            END IF

            #DEBUG PRINT STR$(x) + ", " + STR$(gIntentionFocus(x))
        NEXT X




     ' InitializeComponent()
        CALL dlgSubjectScreen()



        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
        DIALOG HIDE globals.hdl.DlgSubject

        SetMMTimerDuration("ENDINTENTION", 5000)
        SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
        SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

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
