#COMPILE EXE
#DIM ALL

#INCLUDE "WIN32API.INC"
#INCLUDE "mmfcomm.inc"

GLOBAL   mmfchannel AS MMFChannelType

FUNCTION PBMAIN () AS LONG
    LOCAL pid, hThread AS DWORD
    LOCAL cmd, vol AS STRING

    'pid??? = SHELL("MP3Playback.exe " + "AliciaKeyes-Fallin.mp3", 6)
    pid??? = SHELL("MP3Playback.exe " + "C:\DOPS_Experiments\AudioStimData\StimFiles.lst", 6)

    OpenMMFChannel("COMMAND", mmfchannel)

'    THREAD CREATE WorkerThread(1) TO hThread???
'
'    msgbox "Here"
    WHILE (1)
        vol = INPUTBOX$("Enter command & parameter (ex - VO100 or SE5400): ")
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
'
'    MSGBOX "out of loop"
'
'ErrorHandler:
'    MSGBOX ERROR$
'    RETURN


END FUNCTION

FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG
    GLOBAL mmfchannel AS MMFChannelType
    LOCAL cmd, vol AS STRING


    cmd = "VO1000"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    SLEEP 5000
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "SW2"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "SE1"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "PL"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    SLEEP 5000
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "SW1"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "SE1"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    OpenMMFChannel("COMMAND", mmfchannel)
    cmd = "PL"
    WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    SLEEP 5000
END FUNCTION

THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG

 FUNCTION = WorkerFunc(x)

END FUNCTION
