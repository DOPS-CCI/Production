#COMPILE EXE
#DIM ALL

#INCLUDE "WIN32API.INC"
#INCLUDE "mmfcomm.inc"

FUNCTION PBMAIN () AS LONG
    LOCAL mmfchannel AS MMFChannelType
    LOCAL pid AS DWORD
    LOCAL cmd, vol AS STRING

    pid??? = SHELL("MP3Playback.exe " + "AliciaKeyes-Fallin.mp3", 6)

    OpenMMFChannel("COMMAND", mmfchannel)

    ON ERROR GOTO ErrorHandler

    WHILE (1)
        vol = INPUTBOX$("Enter Volume: ")
        IF (vol = "-999") THEN
            cmd = "QU"

            OpenMMFChannel("COMMAND", mmfchannel)
            WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
            EXIT LOOP
        END IF

        IF (vol = "-999") THEN
            EXIT LOOP
        END IF

        cmd = vol

        OpenMMFChannel("COMMAND", mmfchannel)

        WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))

        SLEEP 5000
    WEND

    MSGBOX "out of loop"

ErrorHandler:
    MSGBOX ERROR$
    RETURN


END FUNCTION
