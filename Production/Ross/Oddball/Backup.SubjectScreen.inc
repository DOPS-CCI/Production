SUB dlgSubjectScreen()
     LOCAL hFont1 AS DWORD

    'DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1522, 831, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2

    CONTROL ADD IMAGE, globals.hdl.DlgSubject, %IDC_IMAGE_Beagle, "BITMAP_BEAGLE", 288, 152, 600, 450, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_BITMAP OR %SS_CENTERIMAGE
    CONTROL ADD IMAGE, globals.hdl.DlgSubject, %IDC_IMAGE_Canary, "BITMAP_CANARY", 288, 152, 600, 450, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_BITMAP OR %SS_CENTERIMAGE
    CONTROL ADD IMAGE, globals.hdl.DlgSubject, %IDC_IMAGE_Blank, "BITMAP_BLANK", 288, 152, 600, 450, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_BITMAP OR %SS_CENTERIMAGE

    FONT NEW "Arial", 24, 1, %ANSI_CHARSET TO hFont1

    CONTROL HIDE globals.hdl.DlgSubject, %IDC_IMAGE_Beagle
    CONTROL HIDE globals.hdl.DlgSubject, %IDC_IMAGE_Canary
    CONTROL HIDE globals.hdl.DlgSubject, %IDC_IMAGE_Blank

   DIALOG SET COLOR globals.hdl.DlgSubject, %RGB_BLACK, %RGB_BLACK


    globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)
END SUB

CALLBACK FUNCTION cbSubjectScreen()
    LOCAL PS AS paintstruct

    SELECT CASE CBMSG
        CASE %WM_DESTROY
            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
            DIALOG END lobals.hdl.DlgSubjectPhotoDiode
            'KillTimer globals.hdl.DlgSubject, %ID_Timer
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
                CASE %IDCANCEL
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                        DIALOG END CBHNDL, 0
                    END IF
            END SELECT
      CASE %WM_INITDIALOG
      CASE %WM_TIMER
        CASE %WM_PAINT
                'beginpaint(globals.hdl.DlgSubject, PS)
                'endpaint globals.hdl.DlgSubject, PS
    END SELECT
END FUNCTION
