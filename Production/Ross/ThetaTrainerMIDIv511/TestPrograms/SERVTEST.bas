#INCLUDE "WIN32API.INC"

#INCLUDE "mmfcomm.inc"

FUNCTION PBMAIN AS LONG
    LOCAL mmfchannel AS MMFChannelType

    CreateMMFChannel("Test", mmfchannel)

    DO
        SLEEP 10
        a$ = ReadMMFChannel(mmfchannel)

        IF LEN(a$) THEN
            MSGBOX a$

        END IF

    LOOP

END FUNCTION
