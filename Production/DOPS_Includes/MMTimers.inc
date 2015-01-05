#INCLUDE "MMSystem.INC"

TYPE GlobalTimers
    StartTime AS LONG
    Duration AS LONG
    OnOff AS BYTE
END TYPE

GLOBAL gTimers AS IPOWERCOLLECTION
GLOBAL gTimerTix AS LONG


SUB TimersCounters( BYVAL uid AS LONG, BYVAL umsg AS LONG, BYVAL dwuser AS LONG, BYVAL lp1 AS LONG, BYVAL lp2 AS LONG)
    LOCAL x, itemCount AS LONG
    LOCAL itemName AS WSTRING
    LOCAL VariantVar AS VARIANT
    LOCAL timers AS GlobalTimers
    'LOCAL timers AS MyTimerInterface

    'LET timers = CLASS "MyTimerClass"

    itemCount = gTimers.Count
    FOR x = 1 TO itemCount
        gTimers.Entry(x, itemName, VariantVar)
        'let timers = VariantVar
        LET timers = VARIANT$(VariantVar)
        IF (timers.OnOff = 1) THEN
            gTimerTix = gTimerTix + 1
            'timers.Counter = timers.Counter + 1
            'timers.IncrCounter()
            'LET VariantVar = timers
            LET VariantVar = timers AS STRING
            gTimers.Replace(itemName, VariantVar)
            'DIALOG SET TEXT globals.hdl.DlgController, itemName + str$(timers.Counter)

            IF (timers.Counter = timers.Duration) THEN
                'msgbox itemName
                'DIALOG SET TEXT globals.hdl.DlgController, " "
                timers.Counter = 0
                timers.OnOff = 0
                'let VariantVar = timers
                LET VariantVar = timers AS STRING
                gTimers.Replace(itemName, VariantVar)

                CALL DoTimerWork(itemName)

                EXIT FOR
            END IF
        END IF
    NEXT x

END SUB


'********************************************************************************
'The DoTimerWork() subroutine must be declare in the main program somewhere
'********************************************************************************
