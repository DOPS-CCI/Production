SUB dlgSubjectScreen()
    'DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1522, 831, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG NEW PIXELS, 0, "", EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y, 1200, 800, %WS_POPUP OR %WS_BORDER, 0 TO globals.hdl.DlgSubject
    DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2


    LOCAL hFont1, hFont2 AS DWORD

    DIALOG NEW PIXELS, 0, "Altered States of Consciousness (ASC)", 105, _
        113, 1200, 800, TO globals.hdl.DlgSubject
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01, "", 336, 104, 176, 96, , , CALL cbButtonEvent01
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT07, "", 336, 312, 176, 96, , , CALL cbButtonEvent07
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT02, "", 528, 104, 176, 96, , , CALL cbButtonEvent02
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT08, "", 528, 312, 176, 96, , , CALL cbButtonEvent08
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT03, "", 720, 104, 176, 96, , , CALL cbButtonEvent03
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT09, "", 720, 312, 176, 96, , , CALL cbButtonEvent09
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT04, "", 336, 208, 176, 96, , , CALL cbButtonEvent04
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT10, "", 336, 416, 176, 96, , , CALL cbButtonEvent10
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT05, "", 528, 208, 176, 96, , , CALL cbButtonEvent05
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT11, "", 528, 416, 176, 96, , , CALL cbButtonEvent11
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT06, "", 720, 208, 176, 96, , , CALL cbButtonEvent06
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_EVENT12, "", 720, 416, 176, 96, , , CALL cbButtonEvent12
    CONTROL ADD TEXTBOX, globals.hdl.DlgSubject, %IDC_TEXTBOX_SPECIAL_EVENT, "", 120, 608, 488, _
        96
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_SPECIALEVENT, "Special Event", 624, 609, 176, 96, , , CALL cbButtonEvent88
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_ENDEPOCH, "End of Epoch", 888, 609, 176, 96, , , CALL cbButtonEvent99
    CONTROL ADD BUTTON,  globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, "End Experiment", 520, 744, 136, 40, , , CALL cbEndExperiment
    CONTROL ADD FRAME,   globals.hdl.DlgSubject, %IDC_FRAME1, "States", 312, 72, 616, 456
    'CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_FRAME, "", 320, 96, 600, 424
    'CONTROL SET COLOR    globals.hdl.DlgSubject, %IDC_LABEL_FRAME, -1, RGB(128, 128, 192)
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL1, "Enter text for Special Event", _
        121, 584, 216, 24
    CONTROL ADD LABEL,   globals.hdl.DlgSubject, %IDC_LABEL_Timings, "", 232, 24, 760, 32

    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 14, 1, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT07, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT02, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT08, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT03, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT09, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT04, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT10, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT05, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT11, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT06, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT12, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_SPECIALEVENT, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ENDEPOCH, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_BUTTON_ENDEXPERIMENT, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_FRAME1, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL1, hFont1
    CONTROL SET FONT globals.hdl.DlgSubject, %IDC_LABEL_Timings, hFont2



#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

     'globals.hdl.DlgSubjectPhotoDiode = CreatePhotoDiodeDDialog(EXPERIMENT.Misc.Screen(1).x, EXPERIMENT.Misc.Screen(1).y)

     LOCAL x AS INTEGER
     FOR x = 0 TO 11
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, %SW_HIDE
     NEXT x

    DIALOG SET COLOR globals.hdl.DlgSubject, %RGB_BLACK, %RGB_BLANCHEDALMOND

END SUB

CALLBACK FUNCTION cbSubjectScreen()
    LOCAL temp AS STRING

    SELECT CASE CB.MSG
        CASE %WM_DESTROY

        CASE %WM_COMMAND
            IF CB.CTLMSG = %BN_CLICKED THEN
            END IF
        CASE %WM_TIMER
            SELECT CASE CB.WPARAM
                CASE %IDT_TIMER01
                    INCR globals.timerInterval
                    INCR globals.totalTime
                    temp = globals.buttonName
                    IF (gFirstTimeFlag = 1) THEN
                        CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_Timings,  "Epoch: " + STR$(globals.trialCnt) + "   Start   " + temp + _
                                    "  elapsed: " +  STR$(globals.timerInterval)  + "   Total elapsed: " + STR$(globals.totalTime)
                        'DIALOG SET TEXT globals.hdl.DlgSubject, "Epoch: " + STR$(globals.trialCnt) + "   Start   " + temp + _
                        '            "  elapsed: " +  STR$(globals.timerInterval)  + "   Total elapsed: " + STR$(globals.totalTime)

                    END IF
                    #DEBUG PRINT "%IDT_TIMER01"
            END SELECT
            'rngInt.GetResults()
    END SELECT

END FUNCTION

CALLBACK FUNCTION cbEndExperiment
    'CALL ButtonEvent99
    DIALOG END CBHNDL
END FUNCTION


CALLBACK FUNCTION cbButtonEvent01
    globals.Response = 1

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent02
    globals.Response = 2

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent03
    globals.Response = 3

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent04
    globals.Response = 4

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent05
    globals.Response = 5

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent06
    globals.Response = 6

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent07
    globals.Response = 7

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent08
    globals.Response = 8

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent09
    globals.Response = 9

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent10
    globals.Response = 10

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent11
    globals.Response = 11

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent12
    globals.Response = 12

    CALL SubjectResponse()
END FUNCTION

CALLBACK FUNCTION cbButtonEvent88
    LOCAL now AS QUAD

    'CALL ButtonEvent99

    IF (gFirstTimeFlag = 0) THEN
        IF (gUseOffset = 1) THEN
            globals.totalTime = VAL(gOffset)
        ELSE
            globals.totalTime = 0
        END IF

        globals.timerInterval = 0
        gFirstTimeFlag = 1
    END IF

    IF (gUseOffset = 1) THEN
        gMyTime.NewTime(gMyTimeType.pHour, gMyTimeType.pMinute, gMyTimeType.pSecond)
        gMyTime.AddSeconds(globals.totalTime)
    ELSE
        gMyTime.Now()
    END IF

    gMyTime.FileTime TO now

    globals.EpochInfo(globals.Response).Flag = %TRUE

    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    Globals.TargetTime = FORMAT$(globals.totalTime, "###############.000") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(2).EvtName = "SpecialEvent"
    EVENTSANDCONDITIONS(2).NbrOfGVars = 1
    EVENTSANDCONDITIONS(2).Index = globals.DioIndex
    EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(2).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(gMyTime)
    'EVENTSANDCONDITIONS(1).ElapsedMillis = gTimerTix

    CONTROL GET TEXT globals.hdl.DlgSubject, %IDC_TEXTBOX_SPECIAL_EVENT TO globals.Comment

    EVENTSANDCONDITIONS(2).GVars(0).Condition = "Comment"
    EVENTSANDCONDITIONS(2).GVars(0).Desc = LookupLegitimateGVUnknown(EVENTSANDCONDITIONS(2).EvtName, EVENTSANDCONDITIONS(2).GVars(0).Condition, globals.Comment)

    rngInt.SetCondition(EVENTSANDCONDITIONS(2).GVars(0).Desc + "")

    CALL WriteToEventFile2(2)

    globals.buttonName =  EVENTSANDCONDITIONS(2).GVars(0).Desc

    globals.trialCnt = globals.trialCnt + 1
    globals.timerInterval = 0
END FUNCTION

CALLBACK FUNCTION cbButtonEvent99
    CALL ButtonEvent99
END FUNCTION
