SUB dlgSubjectScreen()
    LOCAL hFont1, hFont2, hFont3 AS DWORD


    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800,%WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    CONTROL ADD IMAGE,      globals.hdl.DlgSubject, %IMAGE_PROCEED, "BITMAP_PROCEED", 392, 725, 360, 32
    CONTROL ADD BUTTON,     globals.hdl.DlgSubject, %IDC_BUTTON_Ready, "Press when ready to see " + _
        "target", 224, 7, 744, 57
    CONTROL ADD GRAPHIC, globals.hdl.DlgSubject, %IDC_GRAPHIC1, "", 192, 112, 800, 600, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_NOTIFY
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_Forward, ">", 1056, 360, 72, 80
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_Back, "<", 64, 360, 72, 80
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_SubjectMessage, "Click on the " + _
        "picture that you think is the Target.", 360, 72, 488, 32, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

    FONT NEW "Arial", 36, 1, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 48, 1, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial", 16, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_Ready, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_Forward, hFont2
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_Back, hFont2
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL_SubjectMessage, hFont3




    CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_GRAPHIC1, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Ready, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Forward, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Back, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_LABEL_SubjectMessage, %SW_HIDE

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
    STATIC targetCnt  AS LONG

    SELECT CASE CB.MSG
        CASE %WM_COMMAND
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_Ready
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_HIDE
                        targetCnt = 1
                        displayTargets(1)
                    END IF
                CASE %IDC_BUTTON_Back
                    DECR targetCnt
                    IF (targetCnt < 1) THEN
                        targetCnt = 1
                    END IF
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        displayTargets(targetCnt)
                    END IF
                CASE %IDC_BUTTON_Forward
                    INCR targetCnt
                    IF (targetCnt > 5) THEN
                        targetCnt = 5
                    END IF
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        displayTargets(targetCnt)
                    END IF
                CASE %IDC_GRAPHIC1
                    IF CB.CTLMSG = %STN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL SubjectResponse(targetCnt)
                    END IF
            END SELECT
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

SUB hideTargets()
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Ready, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Forward, %SW_HIDE
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Back, %SW_HIDE
END SUB

SUB displayTargets(target AS LONG)
    LOCAL hSubjectGDC, hSubjectGraphic AS DWORD

    GRAPHIC BITMAP LOAD rndTargets(target),800,600 TO hSubjectGraphic
    GRAPHIC ATTACH globals.hdl.DlgSubject, %IDC_GRAPHIC1, REDRAW
    GRAPHIC GET DC TO hSubjectGDC
    GRAPHIC COPY hSubjectGraphic, 0
    GRAPHIC REDRAW
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_GRAPHIC1, %SW_SHOW

    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Forward, %SW_SHOW
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_Back, %SW_SHOW
    CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_SubjectMessage, "Click on the " + _
        "picture that you think is the Target."
    CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_LABEL_SubjectMessage, %SW_SHOW
END SUB
