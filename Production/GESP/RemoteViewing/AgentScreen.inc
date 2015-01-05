SUB dlgAgentScreen()
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(2).x, EXPERIMENT.Misc.Screen(2).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgAgent
    DIALOG SET LOC globals.hdl.DlgAgent, EXPERIMENT.Misc.Screen(2).x + (EXPERIMENT.Misc.Screen(2).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(2).y + (EXPERIMENT.Misc.Screen(2).yMax - 800) / 2
    'CONTROL ADD IMAGEX, globals.hdl.DlgAgent, %ID_GRID, "BITMAP_GRID", 296, 60, 600, 600,,, 'CALL cbSubject1


    'GRAPHIC BITMAP LOAD EXPERIMENT.Stimulus.BitmapName, EXPERIMENT.Stimulus.Rows * EXPERIMENT.Stimulus.LowerRightX, _
    '                    EXPERIMENT.Stimulus.LowerRightX * EXPERIMENT.Stimulus.LowerRightY TO EXPERIMENT.Stimulus.BitmapHnd
    CONTROL ADD GRAPHIC, globals.hdl.DlgAgent, %ID_GRID, "", 192, 112, 800, 600,    ', %WS_BORDER
    'GRAPHIC ATTACH globals.hdl.DlgAgent, %ID_GRID
    'GRAPHIC RENDER BITMAP EXPERIMENT.Stimulus.BitmapName, (EXPERIMENT.Stimulus.UpperLeftX, EXPERIMENT.Stimulus.UpperLeftY) - _
    '                        (EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY)



    globals.hdl.DlgAgentPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(2).x, EXPERIMENT.Misc.Screen(2).y)

    PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)

END SUB

CALLBACK FUNCTION cbAgentScreen()
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
