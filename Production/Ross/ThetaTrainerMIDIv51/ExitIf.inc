#INCLUDE THIS ONCE

#IF NOT %DEF(%ExitIfInc)
%ExitIfInc = 1

MACRO ExitIf(test, errNo, exitWhat)
    IF test THEN
        ExitLog FUNCNAME$, errNo
        EXIT exitWhat
    END IF
END MACRO
MACRO ExitS(test, errNo) = ExitIf(test, errNo, SUB)
MACRO ExitF(test, errNo) = ExitIf(test, errNo, FUNCTION)

MACRO ExitLogErr(errNo) = ExitLog(FUNCNAME$, errNo)

MACRO ExitO(test, errNo, exitWhat)
    IF test THEN
        ExitLog mClass+":"+FUNCNAME$, errNo
        EXIT exitWhat
    END IF
END MACRO
MACRO ExitP(test, errNo) = ExitO(test, errNo, PROPERTY)
MACRO ExitM(test, errNo) = ExitO(test, errNo, METHOD)

MACRO ExitLogErrO(errNo) = ExitLog mClass+":"+FUNCNAME$, errNo

SUB ExitLog(BYVAL msg AS STRING, BYVAL errNo AS LONG)
    LOCAL h AS LONG
    ERROR errNo
    msg += ":" + FORMAT$(errNo)
    #IF %DEF(%HaltOnError)
        ? msg,,"Error!"
        END
    #ENDIF
    h = FREEFILE
    TRY
        OPEN EXE.PATH$+"HLib.log" FOR APPEND AS h
        IF LOF(h) < 16000 THEN
            PRINT# h, DATE$ +", "+ TIME$ +", "+ EXE.FULL$ +", "+ msg
        END IF
    CATCH
    FINALLY
        CLOSE h
    END TRY
END SUB

#ENDIF
