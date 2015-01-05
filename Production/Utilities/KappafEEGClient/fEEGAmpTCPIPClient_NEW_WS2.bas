#PBFORMS CREATED V2.01
'------------------------------------------------------------------------------
' The first line in this file is a PB/Forms metastatement.
' It should ALWAYS be the first line of the file. Other
' PB/Forms metastatements are placed at the beginning and
' end of "Named Blocks" of code that should be edited
' with PBForms only. Do not manually edit or delete these
' metastatements or PB/Forms will not be able to reread
' the file correctly.  See the PB/Forms documentation for
' more information.
' Named blocks begin like this:    #PBFORMS BEGIN ...
' Named blocks end like this:      #PBFORMS END ...
' Other PB/Forms metastatements such as:
'     #PBFORMS DECLARATIONS
' are used by PB/Forms to insert additional code.
' Feel free to make changes anywhere else in the file.
'------------------------------------------------------------------------------

#COMPILE EXE
#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE "fEEGAmpTCPIPClient_NEW.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "MSWINSCK.INC"
'#INCLUDE "WINSOCK2.INC"
#INCLUDE "ole2utils.inc"
#INCLUDE "OLECON.INC"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "ChannelInfo.INC"

%FD_READ                    = &B1
%FD_WRITE                   = &B10
%FD_ACCEPT                  = &B1000
%FD_CONNECT                 = &B10000
%FD_CLOSE                   = &B100000
%INVALID_SOCKET             = &HFFFFFFFF???

'------------------------------------------------------------------------------
' Equates and global variables
'
%TCP_ACCEPT = %WM_USER + 4093  ' Any value larger than %WM_USER + 500
%TCP_ECHO   = %WM_USER + 4094  ' Any value larger than %WM_USER + 500

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                =  101
%IDC_FRAME1                 =  201
%IDC_FRAME3                 =  202
%IDC_LABEL1                 = 1001
%IDC_LABEL2                 = 1002
%IDC_LABEL3                 = 1003
%IDC_LABEL4                 = 1009
%IDC_LABEL5                 = 1010
%IDC_LABEL6                 = 1011
%IDC_LABEL7                 = 1012
%IDC_LABEL8                 = 1013
%IDC_LABEL9                 = 1014
%IDC_LABEL10                = 1004
%IDC_LABEL11                = 1005
%IDC_LABEL12                = 1006
%IDC_LABEL16                = 1015
%IDC_LABEL17                = 1016
%IDC_LABEL18                = 1017
%IDC_LABEL19                = 1018
%IDC_LABEL20                = 1019
%IDC_LABEL21                = 1020
%IDC_LABEL22                = 1021
%IDC_LABEL23                = 1022
%IDC_LABEL24                = 1023
%IDC_LABEL25                = 1024
%IDC_LABEL26                = 1025
%IDC_LABEL27                = 1026
%IDC_LABEL28                = 1027
%IDC_LABEL29                = 1028
%IDC_LABEL30                = 1029
%IDC_LABEL31                = 1030
%IDC_LABEL32                = 1031
%IDC_LABEL33                = 1032
%IDC_LABEL34                = 1033
%IDC_LABEL35                = 1034
%IDC_LABEL36                = 1035
%IDC_LABEL37                = 1036
%IDC_LABEL38                = 1037
%IDC_LABEL39                = 1038
%IDC_LABEL40                = 1039
%IDC_LABEL41                = 1040
%IDC_LABEL42                = 1041
%IDC_LABEL43                = 1043
%IDC_LABEL44                = 1044
%IDC_LABEL45                = 1045
%IDC_LABEL46                = 1046
%IDC_LABEL47                = 1047
%IDC_LABEL48                = 1048
%IDC_LABEL_STATUS           = 1049
%IDC_TEXTBOX_CHAN01         = 1101
%IDC_TEXTBOX_CHAN02         = 1102
%IDC_TEXTBOX_CHAN03         = 1103
%IDC_TEXTBOX_CHAN04         = 1104
%IDC_TEXTBOX_CHAN05         = 1105
%IDC_TEXTBOX_CHAN06         = 1106
%IDC_TEXTBOX_CHAN07         = 1107
%IDC_TEXTBOX_CHAN08         = 1108
%IDC_TEXTBOX_CHAN09         = 1109
%IDC_TEXTBOX_CHAN10         = 1110
%IDC_TEXTBOX_CHAN11         = 1111
%IDC_TEXTBOX_CHAN12         = 1112
%IDC_TEXTBOX_CHAN13         = 1113
%IDC_TEXTBOX_CHAN14         = 1114
%IDC_TEXTBOX_CHAN15         = 1115
%IDC_TEXTBOX_CHAN16         = 1116
%IDC_TEXTBOX_CHAN17         = 1117
%IDC_TEXTBOX_CHAN18         = 1118
%IDC_TEXTBOX_CHAN19         = 1119
%IDC_TEXTBOX_CHAN20         = 1120
%IDC_TEXTBOX_CHAN21         = 1121
%IDC_TEXTBOX_CHAN22         = 1122
%IDC_TEXTBOX_CHAN23         = 1123
%IDC_TEXTBOX_CHAN24         = 1124
%IDC_TEXTBOX_CHAN25         = 1125
%IDC_TEXTBOX_CHAN26         = 1126
%IDC_TEXTBOX_CHAN27         = 1127
%IDC_TEXTBOX_CHAN28         = 1128
%IDC_TEXTBOX_CHAN29         = 1129
%IDC_TEXTBOX_CHAN30         = 1130
%IDC_TEXTBOX_CHAN31         = 1131
%IDC_TEXTBOX_CHAN32         = 1132
%IDC_TEXTBOX_CHAN33         = 1133
%IDC_TEXTBOX_CHAN34         = 1134
%IDC_TEXTBOX_CHAN35         = 1135
%IDC_TEXTBOX_CHAN36         = 1136
%IDC_CHECKBOX_CHAN01        = 1201
%IDC_CHECKBOX_CHAN02        = 1202
%IDC_CHECKBOX_CHAN03        = 1203
%IDC_CHECKBOX_CHAN04        = 1204
%IDC_CHECKBOX_CHAN05        = 1205
%IDC_CHECKBOX_CHAN06        = 1206
%IDC_CHECKBOX_CHAN07        = 1207
%IDC_CHECKBOX_CHAN08        = 1208
%IDC_CHECKBOX_CHAN09        = 1209
%IDC_CHECKBOX_CHAN10        = 1210
%IDC_CHECKBOX_CHAN11        = 1211
%IDC_CHECKBOX_CHAN12        = 1212
%IDC_CHECKBOX_CHAN13        = 1213
%IDC_CHECKBOX_CHAN14        = 1214
%IDC_CHECKBOX_CHAN15        = 1215
%IDC_CHECKBOX_CHAN16        = 1216
%IDC_CHECKBOX_CHAN17        = 1217
%IDC_CHECKBOX_CHAN18        = 1218
%IDC_CHECKBOX_CHAN19        = 1219
%IDC_CHECKBOX_CHAN20        = 1220
%IDC_CHECKBOX_CHAN21        = 1221
%IDC_CHECKBOX_CHAN22        = 1222
%IDC_CHECKBOX_CHAN23        = 1223
%IDC_CHECKBOX_CHAN24        = 1224
%IDC_CHECKBOX_CHAN25        = 1225
%IDC_CHECKBOX_CHAN26        = 1226
%IDC_CHECKBOX_CHAN27        = 1227
%IDC_CHECKBOX_CHAN28        = 1228
%IDC_CHECKBOX_CHAN29        = 1229
%IDC_CHECKBOX_CHAN30        = 1230
%IDC_CHECKBOX_CHAN31        = 1231
%IDC_CHECKBOX_CHAN32        = 1232
%IDC_CHECKBOX_CHAN33        = 1233
%IDC_CHECKBOX_CHAN34        = 1234
%IDC_CHECKBOX_CHAN35        = 1235
%IDC_CHECKBOX_CHAN36        = 1236
%IDC_TEXTBOX_ANALOG1        = 1301
%IDC_TEXTBOX_ANALOG2        = 1302
%IDC_TEXTBOX_DIGITAL        = 1303
%IDC_CHECKBOX_ANALOG1       = 1401
%IDC_CHECKBOX_ANALOG2       = 1402
%IDC_CHECKBOX_DIGITAL       = 1403
%IDC_CHECKBOX_SELECTALL     = 1501
%IDC_TEXTBOX_SERVER         = 1601
%IDC_TEXTBOX_PORT           = 1602
%IDC_BUTTON_CONNECT         = 1701
%IDC_BUTTON_PROCESS         = 1702
%IDC_BUTTON_CLOSE           = 1703
%IDC_COMBOBOX_CHANNELS      = 1801
%IDC_CHECKBOX_USE_ANALOG1   = 1901
%IDC_CHECKBOX_USE_ANALOG2   = 1902
%IDC_CHECKBOX_PROCESSTOFILE = 1903
%IDC_TEXTBOX_PROCESSTOFILE  = 1906
%IDC_TEXTBOX_TIMEOUT        = 1907
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL gCHNFilename AS STRING
GLOBAL gSocket, gFramesProcessed, gBytesInBuffer AS LONG
GLOBAL tlStopReceive AS LONG
GLOBAL gDataBuffer, gUnfinishedBuffer, gRecvBuffer AS STRING
GLOBAL ghPDThread AS DWORD
GLOBAL gShutDown, gRecvBufferLength AS LONG
GLOBAL gRecArray() AS STRING
GLOBAL gnSocket, gEnqueuedBuffers AS LONG

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    gRecvBufferLength = 8192

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    STATIC nPort, lResult AS LONG
    LOCAL sTemp AS STRING
    STATIC DataQueue AS IQUEUECOLLECTION

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG

        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CB.WPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_TEXTBOX_SERVER

                CASE %IDC_TEXTBOX_PORT

                CASE %IDC_BUTTON_CONNECT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        gEnqueuedBuffers = 0
                        gBytesInBuffer = 0
                        gFramesProcessed = 0
                        gUnfinishedBuffer = ""
                        ghPDThread = 0
                        gShutDown = %False

                        LET DataQueue = CLASS "QueueCollection"
                        DataQueue.clear

                         TCP OPEN PORT 999 AT "192.168.1.64" AS gnSocket  TIMEOUT 60000
                         ' Could we connect to site?

                         IF ERR THEN
                             MSGBOX "Could not connect."
                             EXIT FUNCTION
                         END IF

                        CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Connected."
                        CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
                     END IF
                CASE %IDC_BUTTON_PROCESS
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        THREAD CREATE ProcessTCPIPDataThread(1) TO lResult
                    END IF

                CASE %IDC_BUTTON_CLOSE
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg
                    END IF

                CASE %IDC_TEXTBOX_CHAN01

                CASE %IDC_CHECKBOX_CHAN01

                CASE %IDC_TEXTBOX_CHAN02

                CASE %IDC_CHECKBOX_CHAN02

                CASE %IDC_TEXTBOX_CHAN03

                CASE %IDC_CHECKBOX_CHAN03

                CASE %IDC_TEXTBOX_CHAN04

                CASE %IDC_CHECKBOX_CHAN04

                CASE %IDC_TEXTBOX_CHAN05

                CASE %IDC_CHECKBOX_CHAN05

                CASE %IDC_TEXTBOX_CHAN06

                CASE %IDC_CHECKBOX_CHAN06

                CASE %IDC_TEXTBOX_CHAN07

                CASE %IDC_CHECKBOX_CHAN07

                CASE %IDC_TEXTBOX_CHAN08

                CASE %IDC_CHECKBOX_CHAN08

                CASE %IDC_TEXTBOX_CHAN09

                CASE %IDC_CHECKBOX_CHAN09

                CASE %IDC_TEXTBOX_CHAN10

                CASE %IDC_CHECKBOX_CHAN10

                CASE %IDC_TEXTBOX_CHAN11

                CASE %IDC_CHECKBOX_CHAN11

                CASE %IDC_TEXTBOX_CHAN12

                CASE %IDC_CHECKBOX_CHAN12

                CASE %IDC_TEXTBOX_CHAN13

                CASE %IDC_CHECKBOX_CHAN13

                CASE %IDC_TEXTBOX_CHAN14

                CASE %IDC_CHECKBOX_CHAN14

                CASE %IDC_TEXTBOX_CHAN15

                CASE %IDC_CHECKBOX_CHAN15

                CASE %IDC_TEXTBOX_CHAN16

                CASE %IDC_CHECKBOX_CHAN16

                CASE %IDC_TEXTBOX_CHAN17

                CASE %IDC_CHECKBOX_CHAN17

                CASE %IDC_TEXTBOX_CHAN18

                CASE %IDC_CHECKBOX_CHAN18

                CASE %IDC_TEXTBOX_CHAN19

                CASE %IDC_CHECKBOX_CHAN19

                CASE %IDC_TEXTBOX_CHAN20

                CASE %IDC_CHECKBOX_CHAN20

                CASE %IDC_TEXTBOX_CHAN21

                CASE %IDC_CHECKBOX_CHAN21

                CASE %IDC_TEXTBOX_CHAN22

                CASE %IDC_CHECKBOX_CHAN22

                CASE %IDC_TEXTBOX_CHAN23

                CASE %IDC_CHECKBOX_CHAN23

                CASE %IDC_TEXTBOX_CHAN24

                CASE %IDC_CHECKBOX_CHAN24

                CASE %IDC_TEXTBOX_CHAN25

                CASE %IDC_CHECKBOX_CHAN25

                CASE %IDC_TEXTBOX_CHAN26

                CASE %IDC_CHECKBOX_CHAN26

                CASE %IDC_TEXTBOX_CHAN27

                CASE %IDC_CHECKBOX_CHAN27

                CASE %IDC_TEXTBOX_CHAN28

                CASE %IDC_CHECKBOX_CHAN28

                CASE %IDC_TEXTBOX_CHAN29

                CASE %IDC_CHECKBOX_CHAN29

                CASE %IDC_TEXTBOX_CHAN30

                CASE %IDC_CHECKBOX_CHAN30

                CASE %IDC_TEXTBOX_CHAN31

                CASE %IDC_CHECKBOX_CHAN31

                CASE %IDC_TEXTBOX_CHAN32

                CASE %IDC_CHECKBOX_CHAN32

                CASE %IDC_TEXTBOX_CHAN33

                CASE %IDC_CHECKBOX_CHAN33

                CASE %IDC_TEXTBOX_CHAN34

                CASE %IDC_CHECKBOX_CHAN34

                CASE %IDC_TEXTBOX_CHAN35

                CASE %IDC_CHECKBOX_CHAN35

                CASE %IDC_TEXTBOX_CHAN36

                CASE %IDC_CHECKBOX_CHAN36

                CASE %IDC_TEXTBOX_ANALOG1

                CASE %IDC_CHECKBOX_ANALOG1

                CASE %IDC_TEXTBOX_ANALOG2

                CASE %IDC_CHECKBOX_ANALOG2

                CASE %IDC_TEXTBOX_DIGITAL

                CASE %IDC_CHECKBOX_DIGITAL

                CASE %IDC_CHECKBOX_SELECTALL

                CASE %IDC_COMBOBOX_CHANNELS

                CASE %IDC_CHECKBOX_USE_ANALOG1

                CASE %IDC_CHECKBOX_USE_ANALOG2

                CASE %IDC_CHECKBOX_PROCESSTOFILE

                CASE %IDC_TEXTBOX_PROCESSTOFILE

                CASE %IDC_TEXTBOX_TIMEOUT

            END SELECT

      CASE %WM_DESTROY

    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL x AS LONG

    CONTROL SEND hDlg, %IDC_COMBOBOX_CHANNELS, %CB_SETEXTENDEDUI, %TRUE, 0

    FOR x = 1 TO 36
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_CHANNELS, STR$(x)
    NEXT x
END FUNCTION
'------------------------------------------------------------------------------



CALLBACK FUNCTION cbSelectDeselectAll()
    LOCAL x, lResult AS LONG

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_SELECTALL TO lResult
      IF (lResult = 1) THEN 'checked
           FOR x = %IDC_CHECKBOX_CHAN01 TO %IDC_CHECKBOX_CHAN36
               CONTROL SET CHECK hDlg, x, 1
               CONTROL REDRAW hDlg, x
           NEXT X

           FOR x = %IDC_CHECKBOX_ANALOG1 TO %IDC_CHECKBOX_DIGITAL
                CONTROL SET CHECK hDlg, x, 1
               CONTROL REDRAW hDlg, x
           NEXT X
        ELSE
           FOR x = %IDC_CHECKBOX_CHAN01 TO %IDC_CHECKBOX_CHAN36
               CONTROL SET CHECK hDlg, x, 0
               CONTROL REDRAW hDlg, x
           NEXT X

           FOR x = %IDC_CHECKBOX_ANALOG1 TO %IDC_CHECKBOX_DIGITAL
                CONTROL SET CHECK hDlg, x, 0
               CONTROL REDRAW hDlg, x
           NEXT X
        END IF
END FUNCTION

FUNCTION tcpSafeReceive(BYVAL hSocket AS LONG, BYVAL iBufferLen AS LONG, _
                        BYREF recBuff AS STRING) AS LONG

   'tcpSafeReceive is by Don Dickinson  - rated A+  (required)

   DIM iLeft AS LONG
   DIM sBuffer AS STRING
   recBuff = ""
   iLeft = iBufferLen
   DO
      sBuffer = SPACE$(iLeft)
      ON ERROR RESUME NEXT
      sBuffer = SPACE$(iBufferLen)
      TCP RECV hSocket, iLeft, sBuffer
      IF ERR THEN
         FUNCTION = %False
         EXIT FUNCTION
      END IF
      recBuff = recBuff + sBuffer

      IF LEN(recBuff) >= iBufferLen THEN
         EXIT DO
      END IF
      iLeft = iBufferLen - LEN(recBuff)
      SLEEP 0
   LOOP
   FUNCTION = %True
END FUNCTION


SUB processData()
    GLOBAL DataQueue AS IQUEUECOLLECTION
    LOCAL x, queueCount AS LONG
    LOCAL vBuffer AS VARIANT
    LOCAL sBuffer AS STRING
    STATIC DataQueue AS IQUEUECOLLECTION


    sBuffer = ""
    WHILE(tlStopReceive)
        SLEEP 10
        queueCount = DataQueue.count
        FOR x = 1 TO queueCount
            'CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Dequeued buffers: " + STR$(gEnqueuedBuffers)
            'CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            vBuffer = DataQueue.dequeue
            gRecvBuffer = VARIANT$(vBuffer)
            parseBuffer()
        NEXT x
        'MSGBOX "Processing data stopped."
    WEND
    'MSGBOX "Processing data stopped."

      'msgbox "here"

END SUB

THREAD FUNCTION ProcessTCPIPDataThread(BYVAL x AS LONG) AS LONG

  FUNCTION = ProcessTCPIPDataFunc(x)

END FUNCTION

FUNCTION ProcessTCPIPDataFunc(BYVAL x AS LONG) AS LONG
    LOCAL sTemp AS STRING
    LOCAL lResult AS LONG

    DO
        'TCP RECV gnSocket, 8192, sTemp
        lResult = tcpSafeReceive(gnSocket, gRecvBufferLength, sTemp)
        IF (lResult = 0) THEN
            tlStopReceive = 0
            MSGBOX "Error: " + STR$(ERR) + " Queued buffers: " + STR$(gEnqueuedBuffers)
            EXIT FUNCTION
        ELSE
            IF LEN(sTemp) = 0 THEN
                tlStopReceive = 0
                EXIT DO
            ELSE
                INCR gEnqueuedBuffers
                CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Queued buffers: " + STR$(gEnqueuedBuffers)
                CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
                DataQueue.enqueue sTemp
            END IF



            IF (ghPDThread = 0) THEN
                tlStopReceive = 1 'Receive data and process
                THREAD CREATE ProcessDataThread(LEN(gRecvBuffer)) TO ghPDThread
            END IF
        END IF
    LOOP
END FUNCTION


FUNCTION ProcessDataWorkerFunc(BYVAL x AS LONG) AS LONG

    processData()

END FUNCTION



THREAD FUNCTION ProcessDataThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessDataWorkerFunc(x)

END FUNCTION


SUB parseBuffer()
    LOCAL hiBy, loBy AS BYTE
    LOCAL char AS STRING, recBuffer AS STRING, buffer AS STRING, temp, chStr AS STRING                                                              ' VOID
    LOCAL x, y, z, cnt, bufLen, startPos, endPos, nbrOfRecs, bytesLeft, lLen, selected, lResult AS LONG
    LOCAL nbrOfChannels, nbrOfBytes AS LONG

    COMBOBOX GET TEXT hDlg, %IDC_COMBOBOX_CHANNELS TO temp
    nbrOfChannels = VAL(temp)
    nbrOfBytes = (nbrOfChannels * 2)  + (%EXTRA_CHANS * 2) '2 extra channels at 2 bytes each


    buffer = gUnfinishedBuffer + gRecvBuffer

    bufLen = LEN(buffer)
    FOR x = 1 TO bufLen
        char = MID$(buffer, x, 1)
        IF (char <> $NUL) THEN
            cnt = x
            EXIT FOR
        END IF
    NEXT x
    IF (cnt = 0) THEN
        EXIT SUB
    END IF

    temp = RIGHT$(buffer, bufLen - cnt + 1)

    bufLen = LEN(temp)
    gBytesInBuffer = gBytesInBuffer + bufLen

    nbrOfRecs = INT(bufLen / nbrOfBytes)
    bytesLeft = bufLen - (nbrOfRecs * nbrOfBytes)


    recBuffer = MID$(temp, 1 TO nbrOfRecs * nbrOfBytes)
    gUnfinishedBuffer = MID$(temp, nbrOfRecs * nbrOfBytes + 1 TO nbrOfRecs * nbrOfBytes + bytesLeft)
    splitRecBufferIntoArray(recBuffer, nbrOfRecs, nbrOfChannels)

    SELECT CASE nbrOfChannels
        CASE 1
            LOCAL ch01 AS Channel01

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch01.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch01.Channels(y) = SwapBytesWord(ch01.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch01.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch01.Channels(y))
                NEXT y
            NEXT x
        CASE 2
            LOCAL ch02 AS Channel02

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch02.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch02.Channels(y) = SwapBytesWord(ch02.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch02.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch02.Channels(y))
                NEXT y
            NEXT x
        CASE 10
            LOCAL ch10 AS Channel10

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch10.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch10.Channels(y) = SwapBytesWord(ch10.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch10.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch10.Channels(y))
                NEXT y
            NEXT x
        CASE 11
            LOCAL ch11 AS Channel11

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch11.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch11.Channels(y) = SwapBytesWord(ch11.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch11.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch11.Channels(y))
                NEXT y
            NEXT x
        CASE 12
            LOCAL ch12 AS Channel12

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch12.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch12.Channels(y) = SwapBytesWord(ch12.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch12.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch12.Channels(y))
                NEXT y
            NEXT x
        CASE 14
            LOCAL ch14 AS Channel14

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch14.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch14.Channels(y) = SwapBytesWord(ch14.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch14.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch14.Channels(y))
                NEXT y
            NEXT x
        CASE 18
            LOCAL ch18 AS Channel18

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch18.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch18.Channels(y) = SwapBytesWord(ch18.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch18.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch18.Channels(y))
                NEXT y
            NEXT x
        CASE 19
            LOCAL ch19 AS Channel19

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch19.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch19.Channels(y) = SwapBytesWord(ch19.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch19.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch19.Channels(y))
                NEXT y
            NEXT x
        CASE 20
            LOCAL ch20 AS Channel20


            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch20.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch20.Channels(y) = SwapBytesWord(ch20.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch20.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch20.Channels(y))
                NEXT y
            NEXT x
        CASE 21
            LOCAL ch21 AS Channel21

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            CONTROL REDRAW hDlg, %IDC_LABEL_STATUS
            FOR x = 1 TO nbrOfRecs
                ch21.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch21.Channels(y) = SwapBytesWord(ch21.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch21.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch21.Channels(y))
                NEXT y
            NEXT x
        CASE 32
            LOCAL ch32 AS Channel32

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            FOR x = 1 TO nbrOfRecs
                ch32.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch32.Channels(y) = SwapBytesWord(ch32.Channels(y))

                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch32.Channels(y))
                        'CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    #DEBUG PRINT "Channel (" + STR$(y) + "): " + STR$(ch32.Channels(y))
                NEXT y
            NEXT x
        CASE 33
            LOCAL ch33 AS Channel33

            INCR gFramesProcessed
            'CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            FOR x = 1 TO nbrOfRecs
                ch33.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels + 2
                    ch33.Channels(y) = SwapBytesWord(ch33.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch33.Channels(y))
                        CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                    '#DEBUG PRINT "Channel (" + STR$(y) + "): " + STR$(ch33.Channels(y))
                NEXT y
                FOR y = nbrOfChannels + 1 TO nbrOfChannels + 2
                    '#DEBUG PRINT "Channel (" + STR$(y) + "): " + STR$(ch33.Channels(y))
                NEXT y
            NEXT x
        CASE 34
            LOCAL ch34 AS Channel34

            INCR gFramesProcessed
            CONTROL SET TEXT  hDlg, %IDC_LABEL_STATUS, "Frame: " + STR$(gFramesProcessed)
            FOR x = 1 TO nbrOfRecs
                ch34.ChannelStr = gRecArray(x)
                FOR y = 1 TO nbrOfChannels
                    ch34.Channels(y) = SwapBytesWord(ch34.Channels(y))
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_CHAN01 + y - 1 TO lResult
                    IF (lResult = 1) THEN 'checked
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_CHAN01 + y - 1, STR$(ch34.Channels(y))
                        'CONTROL REDRAW hDlg, %IDC_TEXTBOX_CHAN01 + y - 1
                        'IF (gsProcessFileName <> "") THEN
                        '    PRINT #1, Channels(x); ", ";
                        'END IF
                    END IF
                NEXT y
            NEXT x
    END SELECT
    PRINT #111, " 07: Redraw"
    DIALOG REDRAW hDlg
END SUB

SUB splitRecBufferIntoArray(recBuffer AS STRING, nbrOfRecs AS LONG, nbrOfChannels AS LONG)
    LOCAL startPtr, endPtr, cnt, recBufferLen  AS LONG
    LOCAL rec AS STRING

    REDIM gRecArray(nbrOfRecs)

    recBufferlen = LEN(recBuffer)
    cnt = 0
    startPtr = 1
    endPtr = (nbrOfChannels * 2) + (%EXTRA_CHANS * 2) '2 extra channels at 2 bytes each
    DO
        INCR cnt
        IF (cnt > nbrOfRecs) THEN
            EXIT DO
        END IF
        rec = MID$(recBuffer, startPtr, endPtr) 'MID$(recBuffer, startPtr, endPtr - 4)
        IF (LEN(rec) <> endPtr) THEN
        END IF
        gRecArray(cnt) = rec
        startPtr = startPtr + endPtr
    LOOP UNTIL startPtr > recBufferlen
END SUB

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, hParent, "fEEG Client Receiver", 15, 114, 1298, 520, TO hDlg
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_SERVER, "10.10.11.11", 76, 56, _
        173, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_PORT, "9870", 314, 56, 172, 24
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_CONNECT, "Connect", 968, 24, 112, _
        33
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_PROCESS, "Process", 968, 65, 112, _
        33
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_CLOSE, "Close", 968, 106, 112, 32
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN01, "", 82, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN01, "", 183, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN02, "", 82, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN02, "", 183, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN03, "", 82, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN03, "", 183, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN04, "", 82, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN04, "", 183, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN05, "", 82, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN05, "", 182, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN06, "", 82, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN06, "", 182, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN07, "", 285, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN07, "", 386, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN08, "", 285, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN08, "", 386, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN09, "", 285, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN09, "", 386, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN10, "", 285, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN10, "", 386, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN11, "", 285, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN11, "", 384, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN12, "", 285, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN12, "", 384, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN13, "", 488, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN13, "", 588, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN14, "", 488, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN14, "", 588, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN15, "", 488, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN15, "", 588, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN16, "", 488, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN16, "", 588, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN17, "", 488, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN17, "", 586, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN18, "", 488, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN18, "", 586, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN19, "", 690, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN19, "", 790, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN20, "", 690, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN20, "", 790, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN21, "", 690, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN21, "", 790, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN22, "", 690, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN22, "", 790, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN23, "", 690, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN23, "", 789, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN24, "", 690, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN24, "", 789, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN25, "", 892, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN25, "", 993, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN26, "", 892, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN26, "", 993, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN27, "", 892, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN27, "", 993, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN28, "", 892, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN28, "", 993, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN29, "", 892, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN29, "", 992, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN30, "", 892, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN30, "", 992, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN31, "", 1095, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN31, "", 1196, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN32, "", 1095, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN32, "", 1196, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN33, "", 1095, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN33, "", 1196, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN34, "", 1095, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN34, "", 1196, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN35, "", 1095, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN35, "", 1194, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_CHAN36, "", 1095, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CHAN36, "", 1194, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ANALOG1, "", 285, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ANALOG1, "", 384, 422, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ANALOG2, "", 488, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ANALOG2, "", 586, 422, 30, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_DIGITAL, "", 690, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_DIGITAL, "", 789, 422, 30, 25
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "fEEG Program Streaming " + _
        "Information", 15, 16, 1095, 130
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Server:", 34, 56, 38, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Port:", 270, 56, 38, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "1", 38, 198, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "2", 38, 232, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL6, "4", 38, 299, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL7, "3", 38, 265, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL8, "6", 38, 369, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL9, "5", 38, 335, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL16, "7", 240, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL17, "8", 240, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL18, "10", 240, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL19, "9", 240, 265, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL20, "12", 240, 369, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL21, "11", 240, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL22, "13", 442, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL23, "14", 442, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL24, "16", 442, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL25, "15", 442, 265, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL26, "18", 442, 369, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL27, "17", 442, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL28, "19", 645, 198, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL29, "20", 645, 232, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL30, "22", 645, 299, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL31, "21", 645, 265, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL32, "24", 645, 369, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL33, "23", 645, 335, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL34, "25", 848, 198, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL35, "26", 848, 232, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL36, "28", 848, 299, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL37, "27", 848, 265, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL38, "30", 848, 369, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL39, "29", 848, 335, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL40, "Digital Events", 615, 422, 67, _
        35, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL41, "Analog 2", 428, 422, 52, 35, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL42, "Analog 1", 225, 422, 53, 35, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME3, "Channels", 15, 154, 1215, 317
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL43, "36", 1050, 369, 38, 36, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL44, "35", 1050, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL45, "34", 1050, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL46, "33", 1050, 265, 38, 36, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL47, "32", 1050, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL48, "31", 1050, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_SELECTALL, "Select/Deselect " + _
        "All", 945, 433, 120, 25, , , CALL cbSelectDeselectAll()
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_STATUS, "", 0, 496, 1298, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_CHANNELS, , 637, 56, 80, 72, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %CBS_DROPDOWNLIST OR %CBS_AUTOHSCROLL, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Number of Output Channels:", _
        493, 56, 144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT _
        OR %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_USE_ANALOG1, "Analog 1", 773, _
        55, 96, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_USE_ANALOG2, "Analog 2", 773, _
        79, 96, 24
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL10, "+/-", 732, 64, 32, 32
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL11, "Which Channels to View", 944, _
        416, 136, 16
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_PROCESSTOFILE, "Process to " + _
        "file", 41, 115, 104, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_PROCESSTOFILE, "", 144, 112, _
        224, 24
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL12, "Receiver Timeout (ms):", 424, _
        112, 144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TIMEOUT, "30000", 574, 109, 66, _
        24

    FONT NEW "MS Sans Serif", 14, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL10, hFont1
#PBFORMS END DIALOG

    SampleComboBox hDlg, %IDC_COMBOBOX_CHANNELS, 30

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
