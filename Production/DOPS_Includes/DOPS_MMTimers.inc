'#INCLUDE "MMSystem.INC"

TYPE GlobalTimers
    StartTime AS LONG
    Duration AS LONG
    OnOff AS BYTE
    subPtr AS DWORD
END TYPE

GLOBAL gTimers AS IPOWERCOLLECTION
GLOBAL gProcPtr AS WSTRING
GLOBAL hmmtimer AS LONG
GLOBAL gTimerTix, gTimerSeconds, gTimerMinutes AS LONG
GLOBAL gPauseFlag AS BYTE

DECLARE SUB TimersCounters( BYVAL uid AS LONG, BYVAL umsg AS LONG, BYVAL dwuser AS LONG, BYVAL lp1 AS LONG, BYVAL lp2 AS LONG)
DECLARE SUB SetMMTimerRoutine(cName AS WSTRING, subPtr AS LONG)
DECLARE SUB SetMMTimerOnOff(cName AS WSTRING, onOff AS LONG)
DECLARE SUB SetMMTimerDuration(cName AS WSTRING, dur AS LONG)
DECLARE SUB setMMTimerEventPeriodic(durationMs AS LONG, giveOrTakeMs AS LONG)
DECLARE SUB killMMTimerEvent()



SUB TimersCounters( BYVAL uid AS LONG, BYVAL umsg AS LONG, BYVAL dwuser AS LONG, BYVAL lp1 AS LONG, BYVAL lp2 AS LONG)
    LOCAL x, itemCount AS LONG
    LOCAL itemName AS WSTRING
    LOCAL VariantVar AS VARIANT
    LOCAL timers AS GlobalTimers

    gTimerTix = gTimerTix + 1     'ms count
    IF (gTimerTix MOD 1000 = 0) THEN
        INCR gTimerSeconds

        IF (gTimerSeconds > 59) THEN
            gTimerSeconds = 0
            INCR gTimerMinutes
        END IF
    END IF

    CALL DoWorkForEachTick()

    itemCount = gTimers.Count
    FOR x = 1 TO itemCount
        gTimers.Entry(x, itemName, VariantVar)
        LET timers = VARIANT$(BYTE, VariantVar)
        IF (timers.OnOff = 1) THEN

            IF ((gTimerTix - timers.StartTime) >= timers.Duration) THEN
                timers.StartTime = 0
                timers.OnOff = 0
                LET VariantVar = timers AS STRING
                gTimers.Replace(itemName, VariantVar)

                CALL DoTimerWork(itemName)

                EXIT FOR
            END IF
        END IF
    NEXT x

END SUB

'********************************************************************************
'The DoWorkForEachTick subroutine must be declare in the main program somewhere
'even if only as an empty subroutine. This routine will get called for each
'tick of the timer. So, keep it short.
'********************************************************************************


'********************************************************************************
'The DoTimerWork() subroutine must be declare in the main program somewhere
'It has one parameter - the timer name used by gTimers.Add(str, timer).
'Here's an example:
'SUB DoTimerWork(itemName AS WSTRING)
'    LOCAL MyTime AS IPOWERTIME
'
'    LET MyTime = CLASS "PowerTime"
'
'    SELECT CASE itemName
'        CASE "SUBJECTDIODE"
'            PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
'        CASE "SUBJECTFEEDBACK"
'            CONTROL SET IMAGEX  globals.hdl.DlgSubject, %ID_GRID, "BITMAP_GRID"
'            CONTROL REDRAW globals.hdl.DlgSubject, %ID_GRID
'        CASE "SUBJECTWAITPROCEED"
'            EnableButtons(1)
'            'MyTime.Now()
'            'MyTime.FileTime to gEnd
'            'msgbox str$(gEnd - gStart)
'        CASE "AGENTDIODE"
'            PhotoDiodeOnOff(globals.hdl.DlgAgentPhotoDiode,  0)
'    END SELECT
'END SUB
'********************************************************************************



SUB SetMMTimerOnOff(cName AS WSTRING, onOff AS LONG)
LOCAL cItem AS VARIANT
LOCAL timers AS GlobalTimers

    SLEEP 0

    cItem = gTimers.Item(cName)
    LET timers = VARIANT$(BYTE, cItem)
    timers.StartTime = gTimerTix 'sets the start time to the current ms count
    timers.OnOff = onOff
    LET cItem = timers AS STRING
    gTimers.Replace(cName, cItem)
END SUB

SUB SetMMTimerDuration(cName AS WSTRING, dur AS LONG)
LOCAL cItem AS VARIANT
LOCAL timers AS GlobalTimers

    SLEEP 0

    cItem = gTimers.Item(cName)
    LET timers = VARIANT$(BYTE, cItem)
    timers.Duration = dur
    LET cItem = timers AS STRING
    gTimers.Replace(cName, cItem)
END SUB


SUB setMMTimerEventPeriodic(durationMs AS LONG, giveOrTakeMs AS LONG)
    SLEEP 0
    gTimerSeconds = 0
    gTimerMinutes = 0

    hmmtimer = timeSetEvent ( durationMs, giveOrTakeMs, CODEPTR(TimersCounters), 0&, %time_periodic OR %time_callback_function )
END SUB

SUB killMMTimerEvent()
    timekillevent hmmtimer
END SUB
