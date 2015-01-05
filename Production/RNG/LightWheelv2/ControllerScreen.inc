SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Controller Screen", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 1200, 800, %DS_CENTER OR %WS_OVERLAPPEDWINDOW, 0 TO globals.hdl.DlgController
    ' Use default styles
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, 150, 25,,, CALL cbControllerOK()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, 388, 150, 25,,, CALL cbControllerExit()

    DIALOG SET ICON globals.hdl.DlgController, "GenericGESP.ico"
    CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_HIDE
END SUB

CALLBACK FUNCTION cbControllerScreen()
    LOCAL PS AS paintstruct


    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
             'SetTimer(globals.hdl.DlgController, %ID_GLOBALTIMER, 100, BYVAL %NULL)   'setting up a 10 ms timer

        'CASE %WM_TIMER

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
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN


        IF (Experiment.Misc.Mode = "demo") THEN
            filename = EXPERIMENT.SessionDescription.INIFile
            sResult = INPUTBOX$("Number of trials:", "How many trials would you like to attempt?", "25")
            WritePrivateProfileString( "Experiment Section", "NumberOfRuns", "1", filename)
            globals.NbrOfRuns = 1
            WritePrivateProfileString( "Experiment Section", "NumOfTrials", sResult, filename)
            globals.NbrOfTrials = VAL(sResult)
            lResult = WritePrivateProfileString( "Subject Section", "ID", "9999", filename)
            lResult = WritePrivateProfileString( "Experiment Section", "AgentID", "", filename)
            globals.AgentID = -1
            globals.AgentInRoom = 1
            WritePrivateProfileString( "Delay Section", "Delay0Min", "1000", filename)
            WritePrivateProfileString( "Delay Section", "Delay0Max", "1000", filename)
            globals.ImageDuration = 1000
            WritePrivateProfileString( "Delay Section", "Delay1Min", "4000", filename)
            WritePrivateProfileString( "Delay Section", "Delay1Max", "4000", filename)
            globals.ITDelay = 4000
            WritePrivateProfileString( "Experiment Section", "Feedback", "yes", filename)
            globals.Feedback = 2 'We want feedback
            WritePrivateProfileString( "Experiment Section", "Comment", "demo mode (" + DATE$ + " " + TIME$ + ")", filename)

            'set up a timer for how long subject photodiode stays on
            gTimers.Add("SUBJECTDIODE", vTimers)
            SetMMTimerDuration("SUBJECTDIODE", 1000)

            'Set up a timer to handle the wait/proceed
            gTimers.Add("DETERMINERESPONSE", vTimers)
            SetMMTimerDuration("DETERMINERESPONSE", 4000)



            CALL LoadINISettings()

            'Initialize Grid Screen placement
            'InitializeGrid(EXPERIMENT.Stimulus.Rows, EXPERIMENT.Stimulus.Columns, EXPERIMENT.Stimulus.UpperLeftX, EXPERIMENT.Stimulus.UpperLeftY, _
            '        EXPERIMENT.Stimulus.LowerRightX, EXPERIMENT.Stimulus.LowerRightY)

            CALL initializeEventFile()

            globals.DioCardPresent = 0


            CustomMessageBox(1, "Press OK to start trials.", "Start Trials")

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
                    CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "GO FAST"

                CASE 2 'Don't Jump
                    CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "GO SLOW"
            END SELECT

         ' InitializeComponent()
            CALL dlgSubjectScreen()



            DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult
            'DIALOG HIDE globals.hdl.DlgSubject

            SetMMTimerDuration("DETERMINERESPONSE", 4000)
            SetMMTimerOnOff("DETERMINERESPONSE", 1)    'turn on
            SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on

            'Start the timers
            setMMTimerEventPeriodic(1, 0)

            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
            CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

            EXIT FUNCTION
        ELSE

            IF (gHelperOpened = 0) THEN
                CALL dlgControllerHelperScreen()
                DIALOG SHOW MODAL globals.hdl.DlgHelper, CALL cbControllerHelperScreen TO hr

                CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_OK, %SW_HIDE
                CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_SHOW

                FUNCTION = 1
            ELSE
                MSGBOX "Settings window already opened."
                BringWindowToTop globals.hdl.DlgHelper
                FUNCTION = 0
            END IF
        END IF

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerExit() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL closeEventFile()

        CALL StartRenameAndMoveFiles()

        DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION
