#INCLUDE "WIN32API.INC"

#INCLUDE "mmfcomm.inc"

FUNCTION PBMAIN AS LONG
    LOCAL mmfchannel AS MMFChannelType

    OpenMMFChannel("Test", mmfchannel)

    DO
        a$ = INPUTBOX$("Test")

        IF LEN(a$) THEN
            WriteMMFChannel(mmfChannel, STRPTR(a$), LEN(a$))

        END IF

    LOOP

END FUNCTION
