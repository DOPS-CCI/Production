SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Controller Screen", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 1200, 800, %DS_CENTER OR %WS_OVERLAPPEDWINDOW, 0 TO globals.hdl.DlgController
    ' Use default styles
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, 150, 25,,, CALL cbControllerOK()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, 388, 150, 25,,, CALL cbControllerExit()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %IDC_BUTTON_Abort, "ABORT", 1056, 0, 144, 40,,, CALL cbControllerAbort()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %IDC_BUTTON_ContinueRun, "Continue Run", 526, 416, 150, 25,,, CALL cbControllerContinueRun()
    CONTROL ADD BUTTON, globals.hdl.DlgController , %IDC_BUTTON_ControllerAudioChoices, "Audio Choices", 1056, 80, 144, 40,,, CALL cbControllerAudioChoices()

    DIALOG SET ICON globals.hdl.DlgController, "GenericHealing.ico"
    CONTROL SHOW STATE globals.hdl.DlgController, %ID_CONTROLLER_EXIT, %SW_HIDE
    CONTROL HIDE globals.hdl.DlgController, %IDC_BUTTON_ContinueRun
    CONTROL DISABLE globals.hdl.DlgController, %IDC_BUTTON_ControllerAudioChoices
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

CALLBACK FUNCTION cbControllerContinueRun() AS LONG
    LOCAL filename, subjDir AS ASCIIZ * 255

    gRunDelayFlag = 0
    CONTROL HIDE globals.hdl.DlgController, %IDC_BUTTON_ContinueRun

    gRndCnt = 0

    gRNDFile = ""

    'gSampleDuration = 1000   ' 1 second
    'gSampleSize = 25        '25 samp/sec
    'REDIM gSamples(gSampleSize)

END FUNCTION

CALLBACK FUNCTION cbControllerOK() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError, x, lResult AS LONG
    LOCAL sResult AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 255
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
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
END FUNCTION

CALLBACK FUNCTION cbControllerExit() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL closeEventFile()

        CALL StartRenameAndMoveFiles()

        CALL ShutdownMacroExpress()

        DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerAbort() AS LONG
    CALL AbortProgram()
END FUNCTION

CALLBACK FUNCTION cbControllerAudioChoices() AS LONG
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

    ExecuteLink ("AudioSoundChoicesShortcut.lnk")

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION

FUNCTION ExecuteLink(zLinkFile AS ASCIIZ * %MAX_PATH) AS DWORD

  LOCAL lpDirectory AS ASCIIZ * %MAX_PATH
  FUNCTION = ShellExecute(0, "Open", zLinkFile, $NUL, lpDirectory, %SW_SHOWNORMAL)

END FUNCTION
