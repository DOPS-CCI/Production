SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Controller Screen", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 1200, 800, %DS_CENTER OR %WS_OVERLAPPEDWINDOW, 0 TO globals.hdl.DlgController
    ' Use default styles
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_OK, "Set Parameters", 525, 388, 150, 25,,, CALL cbControllerOK()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %ID_CONTROLLER_EXIT, "Exit Experiment", 525, 388, 150, 25,,, CALL cbControllerExit()
    CONTROL ADD BUTTON, globals.hdl.DlgController, %IDC_BUTTON_Abort, "ABORT", 1056, 0, 144, 40,,, CALL cbControllerAbort()

    DIALOG SET ICON globals.hdl.DlgController, "ASCGeneric.ico"
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
        EXPERIMENT.SessionDescription.INIFile = "ASCMedium.ini"
        EXPERIMENT.SessionDescription.Date = DATE$
        EXPERIMENT.SessionDescription.Time = TIME$

        filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

        GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)


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
        ELSE
            IF (gHelperOpened = 0) THEN
                CALL dlgControllerHelperScreen()       'local, HelperScreen.inc
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
        KillTimer globals.hdl.DlgSubject, &H3E8

        CALL closeEventFile()

        CALL StartRenameAndMoveFiles()

        DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerAbort() AS LONG
    CALL AbortProgram()
END FUNCTION
