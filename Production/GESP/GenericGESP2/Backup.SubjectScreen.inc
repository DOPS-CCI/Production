SUB dlgSubjectScreen()


    'DIALOG NEW pixels, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800,%WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2


    CONTROL ADD IMAGE, globals.hdl.DlgSubject, %IMAGE_PROCEED, "BITMAP_PROCEED", 538, 725, 100, 50,,,

    IF (globals.CCFlag = 1) THEN
        CONTROL ADD IMAGE, globals.hdl.DlgSubject, %ID_GRID, "BITMAP_GRID1", EXPERIMENT.Stimulus.StartPosX, EXPERIMENT.Stimulus.StartPosY, _
                            EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY
    ELSE

        CONTROL ADD IMAGEX, globals.hdl.DlgSubject, %ID_GRID, "BITMAP_GRID", 296, 60, 600, 600,,, 'CALL cbSubject1

        GRAPHIC BITMAP LOAD EXPERIMENT.Stimulus.BitmapName, EXPERIMENT.Stimulus.Rows * EXPERIMENT.Stimulus.LowerRightX, _
                            EXPERIMENT.Stimulus.LowerRightX * EXPERIMENT.Stimulus.LowerRightY TO EXPERIMENT.Stimulus.BitmapHnd
        CONTROL ADD GRAPHIC, globals.hdl.DlgSubject, %ID_GRID, "", EXPERIMENT.Stimulus.StartPosX, EXPERIMENT.Stimulus.StartPosY, _
                                EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY    ', %WS_BORDER
        GRAPHIC ATTACH globals.hdl.DlgSubject, %ID_GRID
        GRAPHIC RENDER BITMAP EXPERIMENT.Stimulus.BitmapName, (EXPERIMENT.Stimulus.UpperLeftX, EXPERIMENT.Stimulus.UpperLeftY) - _
                                (EXPERIMENT.Stimulus.SizeX, EXPERIMENT.Stimulus.SizeY)
    END IF

    CONTROL ADD IMAGEX, globals.hdl.DlgSubject, %ID_HIGHLIGHT, "BITMAP_HIGHLIGHT", EXPERIMENT.Stimulus.StartPosX, EXPERIMENT.Stimulus.StartPosY, 30, 30,,, 'CALL cbSubject1

    CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_GRID, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_HIGHLIGHT, %SW_HIDE

    globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)

    PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)

    CALL dlgAgentScreen()
    DIALOG SHOW MODELESS globals.hdl.DlgAgent, CALL cbAgentScreen

'    EnableButtons(0)
'    delayMilliSeconds(globals.ITDelay * 1.0)
'    randomDelayMilliseconds(10, 250)
'
'    GetTarget()



END SUB

CALLBACK FUNCTION cbSubjectScreen()
    SELECT CASE CB.MSG
        CASE %WM_LBUTTONDOWN
            CALL SubjectResponse(CB.LPARAM)
        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
    END SELECT
END FUNCTION

SUB EnableButtons(flag AS INTEGER)
    STATIC pt AS POINTAPI
    LOCAL x, y AS LONG

    IF (flag = 1) THEN
        'CONTROL SET IMAGEX  globals.hdl.DlgSubject, %IMAGE_BACK, "BITMAP_BACK"
        CONTROL SET IMAGE globals.hdl.DlgSubject, %IMAGE_PROCEED, "BITMAP_PROCEED"
        'SetLabelColors(flag)
        SetCursorPos(pt.x, pt.y)
        MOUSEPTR 1
    ELSE
        'CONTROL SET IMAGEX  globals.hdl.DlgSubject, %IMAGE_BACK, "BITMAP_BACK"
        CONTROL SET IMAGE globals.hdl.DlgSubject, %IMAGE_PROCEED, "BITMAP_WAIT"
        GetCursorPos(pt)
        DIALOG GET LOC globals.hdl.DlgSubject TO x, y
        SetCursorPos(x, y)
        MOUSEPTR 12
    END IF
END SUB
