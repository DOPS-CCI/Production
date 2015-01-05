SUB dlgControllerHelperScreen()
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->

 DIALOG NEW PIXELS, 0, "Enter parameters", 336, 234, 279, 256, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "25", 128, 30, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 128, 68, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION, "1000", 128, 104, _
        100, 20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "3000", 128, 144, 100, _
        20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 32, 216, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 123, 216, 75, _
        23, , , CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 223, 215, 24, 24
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, 9901, "Number of trials:", 45, 34, 83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, 9903, "Subject ID:", 68, 72, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, 9903, "Display duration (ms):", 26, 108, _
        102, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, 9904, "Trial duration (ms):", 27, 148, _
        96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING


   DIALOG NEW PIXELS, 0, "Enter parameters", 336, 234, 279, 324, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_NBRTRIALS, "25", 128, 30, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 128, 68, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_DISPLAYDURATION, "1000", 128, 104, _
        100, 20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_ITDURATION, "3000", 128, 144, 100, _
        20, %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 72, _
        184, 128, 32, , , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", 72, _
        223, 128, 32, , , CALL cbHelperScreenLongDesc()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 24, 288, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 115, 288, 75, _
        23, , , CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 215, 287, 24, 24, , , CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9901, "Number of trials:", 45, 34, 83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9903, "Subject ID:", 68, 72, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9903, "Display duration (ms):", 26, 108, _
        102, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9904, "Trial duration (ms):", 27, 148, _
        96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
#PBFORMS END DIALOG

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
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION

CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    STATIC pt AS POINTAPI
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers

    EXPERIMENT.SessionDescription.INIFile = "Superman.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    globals.NbrOfHits = 0


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
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
        globals.ImageDuration = VAL(temp)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_ITDURATION TO temp
        WritePrivateProfileString( "Delay Section", "Delay1Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay1Max", temp, filename)
        globals.ITDelay = VAL(temp)

        CALL StartModifyExpAndTech(filename)

        CALL LoadINISettings()

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF

        globals.NbrOfRuns = EXPERIMENT.Misc.NbrOfTargets

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

        CustomMessageBox(0, "Wait until Biosemi automatically begins recording"  + $CRLF + _
            "then press OK to start the trials.", "Biosemi is Recording")
        '**********************************************************************************************


        CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12

        gTimers.Add("DETERMINERESPONSE", vTimers)
        SetMMTimerDuration("DETERMINERESPONSE", globals.ITDelay) 'every millisecond


        'set up a timer for how long subject photodiode stays on
        gTimers.Add("SUBJECTDIODE", vTimers)
        SetMMTimerDuration("SUBJECTDIODE", globals.ImageDuration)


        REDIM gRndAvg(EXPERIMENT.Misc.NbrOfTargets)
        REDIM gRndTotal(EXPERIMENT.Misc.NbrOfTargets)
        REDIM gRndCnt(EXPERIMENT.Misc.NbrOfTargets)
        REDIM gTargetFocus(EXPERIMENT.Misc.NbrOfTargets)

        '*******************************************************
        'Setting up which target to focus on. We have to loop
        'all of the targets, but they are shuffled.
        '*******************************************************
        FOR x = 0 TO EXPERIMENT.Misc.NbrOfTargets - 1
            gTargetFocus(x) = x + 1
        NEXT x

        FOR x = 1 TO 7
            CALL shuffleLongs(gTargetFocus(0), EXPERIMENT.Misc.NbrOfTargets)
        NEXT x

        '*******************************************************
        'Connect to the Alea RNG
        '*******************************************************
        IF (Experiment.Misc.Mode <> "demo") THEN
            LET oApp = NEWCOM "Araneus.Alea.1"
            OBJECT CALL oApp.Open
        END IF

        globals.RunCnt = 1
        globals.TrialCnt = 0
        globals.TrialCntTotal = 0
        globals.NbrOfHits = 0


        globals.Target = gTargetFocus(globals.RunCnt)

        SELECT CASE globals.Target
            CASE 1  'Jump
                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "FLY HIGH"

            CASE 2 'Don't Jump
                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "FLY LOW"
        END SELECT

     ' InitializeComponent()
        CALL dlgSubjectScreen()



        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
        'DIALOG HIDE globals.hdl.DlgSubject

        SetMMTimerDuration("DETERMINERESPONSE", 3000)
        SetMMTimerOnOff("DETERMINERESPONSE", 1)    'turn on
        SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

        'Start the timers
        setMMTimerEventPeriodic(1, 0)




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
