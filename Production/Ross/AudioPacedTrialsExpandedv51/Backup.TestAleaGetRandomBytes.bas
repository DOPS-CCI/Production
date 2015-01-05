#COMPILE EXE
#DIM ALL

GLOBAL oApp AS IDISPATCH

FUNCTION PBMAIN () AS LONG
    LOCAL sampSize, numericvar AS DWORD
    LOCAL varObj AS VARIANT
    LOCAL PB_array() AS BYTE
    LOCAL errTrapped AS LONG

    TRY
        LET oApp = NEWCOM "Araneus.Alea.1"
        OBJECT CALL oApp.Open
    CATCH
        MSGBOX "Error on Opening Alea RNG. Check to see if it is plugged in (and that the drivers are installed.)" + $CRLF + _
                "Also, there may be a program running using the RNG already."
        errTrapped = ERR
        EXIT TRY
    END TRY



    sampSize = 50
    OBJECT CALL oApp.GetRandomBytes(sampSize, OUT varObj)
    numericvar = VARIANTVT(varObj)
    MSGBOX STR$(numericvar)

    LET PB_array() = varObj

END FUNCTION
