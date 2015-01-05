SUB dlgControllerHelperScreen()
    LOCAL rndTarget AS LONG
     #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
         DIALOG NEW PIXELS, 0, "Enter parameters", 336, 225, 279, 368, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %IDC_TEXTBOX_NbrOfRuns, "1", 128, 16, 100, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %TEXTBOX_NBRTRIALS, "100", 129, 52, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %TEXTBOX_SUBJECTID, "9999", 129, 90, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %TEXTBOX_DISPLAYDURATION, "1000", 129, 126, _
        100, 20, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %IDC_TEXTBOX_MinRandomDelay, "800", 128, 160, _
        100, 20, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper  , %IDC_TEXTBOX_MaxRandomDelay, "1200", 129, 197, _
        100, 20, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper  , %IDC_BUTTON_LongDesc, "Long Description", 80, _
        232, 120, 24,, CALL cbHelperScreenLongDesc()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper  , %IDC_BUTTON_EEGSettings, "EEG Settings", 80, _
        288, 120, 24, , CALL cbHelperScreenEEGSettings()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper  , %BUTTON_HELPEROK, "OK", 32, 336, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING , CALL    cbHelperScreenOK()
    DIALOG  SEND         globals.hdl.DlgHelper  , %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper  , %BUTTON_HELPERCANCEL, "Cancel", 123, 336, 75, _
        23, , CALL  cbHelperScreenCancel()
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper  , %BUTTON_HELP, "?", 223, 335, 24, 24, ,  CALL cbHelperScreenHelp()
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL_01, "Number of trials:", 46, 56, _
        83, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL_02, "Subject ID:", 69, 94, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL_03, "Display duration (ms):", 27, _
        130, 102, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL_04, "Max Random Delay:", 28, 201, _
        96, 13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL_05, "Number of runs:", 45, 20, 83, _
        13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper  , %IDC_LABEL1, "Min Random Delay:", 27, 164, 96, _
        13, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
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
            gHelperOpened = 0 'Helper screen closed
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
    LOCAL temp AS STRING

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    'temp = EXPERIMENT.ActiviewConfig + " " + filename

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)

    SHELL "H:\EEGSettings\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    LOCAL lResult, lTemp, x, y, lRndNbr AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    STATIC pt AS POINTAPI
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers
    LOCAL targetOrder AS STRING
    GLOBAL imagesToDisplay() AS LONG


    EXPERIMENT.SessionDescription.INIFile = "Oddball.ini"
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

        REDIM imagesToDisplay(globals.NbrOfTrials)

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
        globals.DisplayDuration = VAL(temp)

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_MinRandomDelay TO temp
        WritePrivateProfileString( "Delay Section", "Delay1Min", temp, filename)
        'WritePrivateProfileString( "Delay Section", "Delay1Max", temp, filename)
        globals.MinRandomDelay = VAL(temp)

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_MaxRandomDelay TO temp
        'WritePrivateProfileString( "Delay Section", "Delay1Min", temp, filename)
        WritePrivateProfileString( "Delay Section", "Delay1Max", temp, filename)
        globals.MaxRandomDelay = VAL(temp)


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
        EVENTSANDCONDITIONS(1).EvtName = "StartExperiment"
        EVENTSANDCONDITIONS(1).NbrOfGVars = 0
        EVENTSANDCONDITIONS(1).Index = globals.DioIndex
        EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
        EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
        EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)
        EVENTSANDCONDITIONS(1).ElapsedMillis = gTimerTix
        CALL WriteToEventFile2(1)
        '**********************************************************************************************

        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgController TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12


        CALL createImageDisplayArray(imagesToDisplay(0), globals.NbrOfTrials)

        CALL shuffleLongs(imagesToDisplay(0), globals.NbrOfTrials)

        'lRndNbr = RandomNumber2(globals.MinRandomDelay, globals.MaxRandomDelay)
        'globals.Target = lRndNbr

        gTimers.Add("STIMULUSPRESENTED", vTimers)

        gTimers.Add("RNDJITTER", vTimers)

        PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  1)
        SetMMTimerDuration("STIMULUSPRESENTED", globals.DisplayDuration)
        SetMMTimerOnOff("STIMULUSPRESENTED", 1)    'turn on

        setMMTimerEventPeriodic(1, 0)

        globals.RunCnt = 1
        globals.TrialCnt = 1
        globals.TrialCntTotal = 1

        prevCanary = 0
        CALL StimulusPresented()

     ' InitializeComponent()
        CALL dlgSubjectScreen()



        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
        'DIALOG HIDE globals.hdl.DlgSubject




        'Start the timers
        'setMMTimerEventPeriodic(1, 0)


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
        PlaySound "NOISE1",  0, %SND_ASYNC + %SND_RESOURCE
    END IF
END FUNCTION
