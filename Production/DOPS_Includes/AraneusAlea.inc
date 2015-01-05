' ------------------------------------------------------------
' Library File:      C:\Program Files\Araneus\Alea\ActiveX Control\alea.tlb
' ------------------------------------------------------------
' ProgID:            Araneus.Alea.1
' Interface Name:    AraneusAlea (Control)
'
' Interface Prefix:  Araneus
' ------------------------------------------------------------

$PROGID_AraneusAlea1 = "Araneus.Alea.1"


INTERFACE DISPATCH AraneusAlea   ' (Control)
    MEMBER CALL OPEN<&H00000001>()
    MEMBER CALL CLOSE<&H00000002>()
    MEMBER CALL GetRandomByte<&H00000003>() AS BYTE
    MEMBER CALL GetRandomBytes<&H00000004>(IN length AS DWORD<&H00000000>, OUT array AS VARIANT<&H00000001>)
    MEMBER CALL GetRandomWord<&H00000005>() AS DWORD
    MEMBER CALL GetRandomWords<&H00000006>(IN length AS DWORD<&H00000000>, OUT array AS VARIANT<&H00000001>)
    MEMBER CALL GetRandomDouble<&H00000007>() AS DOUBLE
    MEMBER CALL GetRandomDoubles<&H00000008>(IN length AS DWORD<&H00000000>, OUT array AS VARIANT<&H00000001>)
END INTERFACE

FUNCTION initiateAleaRNG() AS LONG
    GLOBAL oAleaRNG AS IDISPATCH
    LOCAL errTrapped AS LONG

    TRY
        LET oAleaRNG = NEWCOM "Araneus.Alea.1"
        OBJECT CALL oAleaRNG.Open
    CATCH
        MSGBOX "Error on Opening Alea RNG. Check to see if it is plugged in (and that the drivers are installed.)"
        errTrapped = ERR
        EXIT TRY
    END TRY

    IF (errTrapped <> 0) THEN
        FUNCTION = errTrapped
        EXIT FUNCTION
    END IF

    FUNCTION = 0
END FUNCTION

FUNCTION AleaRNGByteRange(minNum AS INTEGER, maxNum AS INTEGER) AS INTEGER
    GLOBAL oAleaRNG AS IDISPATCH
    LOCAL rndByte AS VARIANT
    LOCAL bRndByte AS BYTE

    DO
        OBJECT CALL oAleaRNG.GetRandomByte() TO rndByte
        bRndByte = VARIANT#(rndByte)
        IF (bRndByte >= minNum AND bRndByte <= maxNum) THEN
            EXIT DO
        END IF
    LOOP

    FUNCTION = bRndByte
END FUNCTION
