#COMPILE EXE
#DIM ALL

#INCLUDE "EvenOddRNGClass.inc"
#INCLUDE "DOPS_MMTimers.inc"

GLOBAL rngInt AS EvenOddRNGInterface


FUNCTION PBMAIN () AS LONG
    LOCAL vTimers AS VARIANT
    LOCAL timers AS GlobalTimers


    LET gTimers = CLASS "PowerCollection"



    DIM rngInt AS EvenOddRNGInterface
    LET rngInt = CLASS "EvenOddRNGClass"
    rngInt.PrintHeaders("ASCGeneric.ini")

    gTimers.Add("GETRESULT", vTimers)
    SetMMTimerDuration("GETRESULT", 1000)


    SetMMTimerOnOff("GETRESULT", 1)    'turn on
    setMMTimerEventPeriodic(1, 0)

    SLEEP 10000
END FUNCTION

SUB DoWorkForEachTick()
     '#DEBUG PRINT "DoWorkForEachTick"
     '#DEBUG PRINT "gTimerSeconds: " + STR$(gTimerSeconds)
END SUB

SUB DoTimerWork(itemName AS WSTRING)
    LOCAL x AS LONG

    SELECT CASE itemName
        CASE "GETRESULT"
            #DEBUG PRINT "GETRESULT"
            'rngInt.GetResult()
    END SELECT
END SUB
