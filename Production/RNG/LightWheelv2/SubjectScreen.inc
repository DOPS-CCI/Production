SUB dlgSubjectScreen()
     LOCAL hFont1 AS DWORD

    'DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1522, 831, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_TARGET, "", 418, 16, 295, 40, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD GRAPHIC, globals.hdl.DlgSubject, %IDC_Graphic, "", 0, 104, 1200, 700

    FONT NEW "Arial", 18, 1, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, hFont1

    GRAPHIC BITMAP LOAD EXPERIMENT.Stimulus.BitmapName, EXPERIMENT.Stimulus.Rows * EXPERIMENT.Stimulus.LowerRightX, _
                        EXPERIMENT.Stimulus.LowerRightX * EXPERIMENT.Stimulus.LowerRightY TO EXPERIMENT.Stimulus.BitmapHnd
    CONTROL ADD GRAPHIC, globals.hdl.DlgSubject, %ID_GRID, "", EXPERIMENT.Stimulus.StartPosX, EXPERIMENT.Stimulus.StartPosY, _
                            EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY, %WS_BORDER
    GRAPHIC ATTACH globals.hdl.DlgSubject, %ID_GRID
    GRAPHIC RENDER BITMAP EXPERIMENT.Stimulus.BitmapName, (EXPERIMENT.Stimulus.UpperLeftX, EXPERIMENT.Stimulus.UpperLeftY) - _
                            (EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY)


   'cityscape memory bitmap
   'GRAPHIC BITMAP LOAD "Images\Lightwheel2.bmp",0,0 TO ghCity

   'graphic control
   'CONTROL ADD GRAPHIC, globals.hdl.DlgSubject, %IDC_Graphic, "", 0, 104, 1200, 700
   'GRAPHIC ATTACH globals.hdl.DlgSubject, %IDC_Graphic, REDRAW
   'GRAPHIC GET DC TO ghGraphicDC
   'GRAPHIC COPY ghCity, 0

   DIALOG SET COLOR globals.hdl.DlgSubject, %RGB_BLACK, %RGB_WHITESMOKE

   globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)
END SUB

CALLBACK FUNCTION cbSubjectScreen()
    LOCAL PS AS paintstruct

    SELECT CASE CBMSG
        CASE %WM_DESTROY
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
         gTransColor = RGB(04,02,04)
         'giHPos = -260
         'giVPos = 600
         'SetTimer globals.hdl.DlgSubject, %ID_Timer, 20, BYVAL %Null
      CASE %WM_TIMER
'         GRAPHIC COPY hCity,0
'         iHPos = iHPos + 2
'         IF (highOrLow = 1) THEN
'             iHPos = iHPos + 4
'         ELSEIF (highOrLow = 2) THEN
'             iHPos = iHPos + 1
'         END IF
'         'IF (iHPos = -176) THEN
'         '    iHPos = 1200
'         IF (iHPos >= 1200 + 260) THEN
'             iHPos = -260
'         END IF
'
'         'IF (iHPos <= -371) THEN
'         '    iHPos = 1200
'         'END IF
         'TransparentBlt ghGraphicDC,giHPos,giVPos,gWidthPlane,gHeightPlane,ghPlaneDC,0,0,gWidthPlane,gHeightPlane,gTransColor
         'GRAPHIC REDRAW
        CASE %WM_PAINT
                'beginpaint(globals.hdl.DlgSubject, PS)
                'endpaint globals.hdl.DlgSubject, PS
    END SELECT
END FUNCTION
