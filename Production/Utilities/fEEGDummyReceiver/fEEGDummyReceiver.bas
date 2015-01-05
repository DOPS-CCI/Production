#PBFORMS CREATED V2.01


#COMPILE EXE
#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE "fEEGDummyReceiver.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE "WS2_32.inc"
#INCLUDE "IPAddrConversion.inc"

#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1              =  101
%IDC_FRAME1               =  201
%IDC_FRAME3               =  202
%IDC_LABEL1               = 1001
%IDC_LABEL2               = 1002
%IDC_LABEL3               = 1003
%IDC_LABEL4               = 1009
%IDC_LABEL5               = 1010
%IDC_LABEL6               = 1011
%IDC_LABEL7               = 1012
%IDC_LABEL8               = 1013
%IDC_LABEL9               = 1014
%IDC_LABEL10              = 1004
%IDC_LABEL11              = 1005
%IDC_LABEL12              = 1006
%IDC_LABEL16              = 1015
%IDC_LABEL17              = 1016
%IDC_LABEL18              = 1017
%IDC_LABEL19              = 1018
%IDC_LABEL20              = 1019
%IDC_LABEL21              = 1020
%IDC_LABEL22              = 1021
%IDC_LABEL23              = 1022
%IDC_LABEL24              = 1023
%IDC_LABEL25              = 1024
%IDC_LABEL26              = 1025
%IDC_LABEL27              = 1026
%IDC_LABEL28              = 1027
%IDC_LABEL29              = 1028
%IDC_LABEL30              = 1029
%IDC_LABEL31              = 1030
%IDC_LABEL32              = 1031
%IDC_LABEL33              = 1032
%IDC_LABEL34              = 1033
%IDC_LABEL35              = 1034
%IDC_LABEL36              = 1035
%IDC_LABEL37              = 1036
%IDC_LABEL38              = 1037
%IDC_LABEL39              = 1038
%IDC_LABEL40              = 1039
%IDC_LABEL41              = 1040
%IDC_LABEL42              = 1041
%IDC_LABEL43              = 1043
%IDC_LABEL44              = 1044
%IDC_LABEL45              = 1045
%IDC_LABEL46              = 1046
%IDC_LABEL47              = 1047
%IDC_LABEL48              = 1048
%IDC_LABEL_STATUS         = 1049
%IDC_TEXTBOX_CHAN01       = 1101
%IDC_TEXTBOX_CHAN02       = 1102
%IDC_TEXTBOX_CHAN03       = 1103
%IDC_TEXTBOX_CHAN04       = 1104
%IDC_TEXTBOX_CHAN05       = 1105
%IDC_TEXTBOX_CHAN06       = 1106
%IDC_TEXTBOX_CHAN07       = 1107
%IDC_TEXTBOX_CHAN08       = 1108
%IDC_TEXTBOX_CHAN09       = 1109
%IDC_TEXTBOX_CHAN10       = 1110
%IDC_TEXTBOX_CHAN11       = 1111
%IDC_TEXTBOX_CHAN12       = 1112
%IDC_TEXTBOX_CHAN13       = 1113
%IDC_TEXTBOX_CHAN14       = 1114
%IDC_TEXTBOX_CHAN15       = 1115
%IDC_TEXTBOX_CHAN16       = 1116
%IDC_TEXTBOX_CHAN17       = 1117
%IDC_TEXTBOX_CHAN18       = 1118
%IDC_TEXTBOX_CHAN19       = 1119
%IDC_TEXTBOX_CHAN20       = 1120
%IDC_TEXTBOX_CHAN21       = 1121
%IDC_TEXTBOX_CHAN22       = 1122
%IDC_TEXTBOX_CHAN23       = 1123
%IDC_TEXTBOX_CHAN24       = 1124
%IDC_TEXTBOX_CHAN25       = 1125
%IDC_TEXTBOX_CHAN26       = 1126
%IDC_TEXTBOX_CHAN27       = 1127
%IDC_TEXTBOX_CHAN28       = 1128
%IDC_TEXTBOX_CHAN29       = 1129
%IDC_TEXTBOX_CHAN30       = 1130
%IDC_TEXTBOX_CHAN31       = 1131
%IDC_TEXTBOX_CHAN32       = 1132
%IDC_TEXTBOX_CHAN33       = 1133
%IDC_TEXTBOX_CHAN34       = 1134
%IDC_TEXTBOX_CHAN35       = 1135
%IDC_TEXTBOX_CHAN36       = 1136
%IDC_CHECKBOX_CHAN01      = 1201
%IDC_CHECKBOX_CHAN02      = 1202
%IDC_CHECKBOX_CHAN03      = 1203
%IDC_CHECKBOX_CHAN04      = 1204
%IDC_CHECKBOX_CHAN05      = 1205
%IDC_CHECKBOX_CHAN06      = 1206
%IDC_CHECKBOX_CHAN07      = 1207
%IDC_CHECKBOX_CHAN08      = 1208
%IDC_CHECKBOX_CHAN09      = 1209
%IDC_CHECKBOX_CHAN10      = 1210
%IDC_CHECKBOX_CHAN11      = 1211
%IDC_CHECKBOX_CHAN12      = 1212
%IDC_CHECKBOX_CHAN13      = 1213
%IDC_CHECKBOX_CHAN14      = 1214
%IDC_CHECKBOX_CHAN15      = 1215
%IDC_CHECKBOX_CHAN16      = 1216
%IDC_CHECKBOX_CHAN17      = 1217
%IDC_CHECKBOX_CHAN18      = 1218
%IDC_CHECKBOX_CHAN19      = 1219
%IDC_CHECKBOX_CHAN20      = 1220
%IDC_CHECKBOX_CHAN21      = 1221
%IDC_CHECKBOX_CHAN22      = 1222
%IDC_CHECKBOX_CHAN23      = 1223
%IDC_CHECKBOX_CHAN24      = 1224
%IDC_CHECKBOX_CHAN25      = 1225
%IDC_CHECKBOX_CHAN26      = 1226
%IDC_CHECKBOX_CHAN27      = 1227
%IDC_CHECKBOX_CHAN28      = 1228
%IDC_CHECKBOX_CHAN29      = 1229
%IDC_CHECKBOX_CHAN30      = 1230
%IDC_CHECKBOX_CHAN31      = 1231
%IDC_CHECKBOX_CHAN32      = 1232
%IDC_CHECKBOX_CHAN33      = 1233
%IDC_CHECKBOX_CHAN34      = 1234
%IDC_CHECKBOX_CHAN35      = 1235
%IDC_CHECKBOX_CHAN36      = 1236

%IDC_TEXTBOX_ANALOG1      = 1301
%IDC_TEXTBOX_ANALOG2      = 1302
%IDC_TEXTBOX_DIGITAL      = 1303

%IDC_CHECKBOX_ANALOG1     = 1401
%IDC_CHECKBOX_ANALOG2     = 1402
%IDC_CHECKBOX_DIGITAL     = 1403

%IDC_CHECKBOX_SELECTALL   = 1501

%IDC_TEXTBOX_SERVER       = 1601
%IDC_TEXTBOX_PORT         = 1602

%IDC_BUTTON_CONNECT       = 1701
%IDC_BUTTON_PROCESS       = 1702
%IDC_BUTTON_CLOSE         = 1703

%IDC_COMBOBOX_CHANNELS    = 1801

%IDC_CHECKBOX_USE_ANALOG1 = 1901
%IDC_CHECKBOX_USE_ANALOG2 = 1902

%IDC_CHECKBOX_PROCESSTOFILE = 1903
%IDC_TEXTBOX_PROCESSTOFILE  = 1906

%IDC_TEXTBOX_TIMEOUT        = 1907

#PBFORMS END CONSTANTS

%TCP_ACCEPT = %WM_USER + 4093  ' Any value larger than %WM_USER + 500
%TCP_ECHO   = %WM_USER + 4094  ' Any value larger than %WM_USER + 500

'------------------------------------------------------------------------------
GLOBAL hDlgfEEGDummy AS DWORD

'%BUFFERSIZE = 1024
'%BUFFERSIZE = 54

GLOBAL gChannelIndex, giBufferSize AS INTEGER
GLOBAL glBufferCharCnt, glBufferCnt AS LONG
GLOBAL glPartialBufferflag AS LONG
GLOBAL gsFinalPartialBuffer AS STRING
GLOBAL giNumberOfChannels AS INTEGER
GLOBAL Channels() AS INTEGER
GLOBAL gsProcessFileName AS STRING

$Terminator = $CRLF

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL lHr AS LONG

    CALL dlgFEEGDummy()
    DIALOG SHOW MODAL hDlgfEEGDummy, CALL cbFEEGDummy TO lHr
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION cbFEEGDummy()
    LOCAL x, lResult AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler

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
               CASE %IDC_CHECKBOX_PROCESSTOFILE
                   CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_PROCESSTOFILE TO lResult
                   IF (lResult = 1) THEN 'checked
                       CONTROL SHOW STATE hDlgfEEGDummy, %IDC_TEXTBOX_PROCESSTOFILE, %SW_SHOW
                   ELSE
                       CONTROL SHOW STATE hDlgfEEGDummy, %IDC_TEXTBOX_PROCESSTOFILE, %SW_HIDE
                   END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

THREAD FUNCTION WorkThread(BYVAL var AS LONG) AS LONG

  FUNCTION = connectTofEEG()


END FUNCTION

CALLBACK FUNCTION cbSelectDeselectAll()
    LOCAL x, lResult AS LONG

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_SELECTALL TO lResult
      IF (lResult = 1) THEN 'checked
           FOR x = %IDC_CHECKBOX_CHAN01 TO %IDC_CHECKBOX_CHAN36
               CONTROL SET CHECK hDlgfEEGDummy, x, 1
               CONTROL REDRAW hDlgfEEGDummy, x
           NEXT X

           FOR x = %IDC_CHECKBOX_ANALOG1 TO %IDC_CHECKBOX_DIGITAL
                CONTROL SET CHECK hDlgfEEGDummy, x, 1
               CONTROL REDRAW hDlgfEEGDummy, x
           NEXT X
        ELSE
           FOR x = %IDC_CHECKBOX_CHAN01 TO %IDC_CHECKBOX_CHAN36
               CONTROL SET CHECK hDlgfEEGDummy, x, 0
               CONTROL REDRAW hDlgfEEGDummy, x
           NEXT X

           FOR x = %IDC_CHECKBOX_ANALOG1 TO %IDC_CHECKBOX_DIGITAL
                CONTROL SET CHECK hDlgfEEGDummy, x, 0
               CONTROL REDRAW hDlgfEEGDummy, x
           NEXT X
        END IF
END FUNCTION

CALLBACK FUNCTION cbConnect()
    STATIC nSocket   AS LONG
    LOCAL  sBuffer, sTimeout   AS STRING
    LOCAL sPacket AS STRING
    LOCAL sPort, sServer AS STRING
    LOCAL lPort, lineCnt, lTimeout AS LONG

    CONTROL GET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_PORT TO sPort
    lPort = VAL(sPort)

    CONTROL GET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_SERVER TO sServer

    CONTROL GET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_TIMEOUT TO sTimeout
    lTimeout = VAL(sTimeout)
    IF (lTimeout <= 0) THEN lTimeout = 10000

    TCP OPEN PORT lPort AT sServer AS nSocket  TIMEOUT lTimeout
    IF ERR THEN
        MSGBOX "Error opening port: " + STR$(ERR)
        EXIT FUNCTION
    ELSE
        sBuffer = "Connected to " + sServer + " at port: " + sPort
    END IF

    CONTROL SET TEXT hDlgfEEGDummy, %IDC_LABEL_STATUS, sBuffer
    CONTROL REDRAW hDlgfEEGDummy, %IDC_LABEL_STATUS

END FUNCTION

CALLBACK FUNCTION cbProcess()
    LOCAL x AS LONG
    STATIC hThread AS DWORD

    THREAD CREATE WorkThread(x) TO hThread???

END FUNCTION

CALLBACK FUNCTION cbCancel() AS LONG
    LOCAL lError AS LONG
    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        DIALOG END CBHNDL, 0
    END IF
END FUNCTION

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
SUB dlgFEEGDummy()

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hFont1 AS DWORD
    LOCAL x AS LONG

    DIALOG NEW PIXELS, 0, "Dialog1", 15, 114, 1298, 520, TO hDlgfEEGDummy
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_SERVER, "10.10.11.11", 76, 56, _
        173, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_PORT, "9870", 314, 56, 172, 24
    CONTROL ADD BUTTON,   hDlgfEEGDummy, %IDC_BUTTON_CONNECT, "Connect", 968, 24, 112, _
        33, , , CALL cbConnect
    CONTROL ADD BUTTON,   hDlgfEEGDummy, %IDC_BUTTON_PROCESS, "Process", 968, 65, 112, _
        33, , , CALL cbProcess
    CONTROL ADD BUTTON,   hDlgfEEGDummy, %IDC_BUTTON_CLOSE, "Close", 968, 106, 112, 32, , , CALL cbCancel
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN01, "", 82, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN01, "", 183, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN02, "", 82, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN02, "", 183, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN03, "", 82, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN03, "", 183, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN04, "", 82, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN04, "", 183, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN05, "", 82, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN05, "", 182, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN06, "", 82, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN06, "", 182, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN07, "", 285, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN07, "", 386, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN08, "", 285, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN08, "", 386, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN09, "", 285, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN09, "", 386, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN10, "", 285, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN10, "", 386, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN11, "", 285, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN11, "", 384, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN12, "", 285, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN12, "", 384, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN13, "", 488, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN13, "", 588, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN14, "", 488, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN14, "", 588, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN15, "", 488, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN15, "", 588, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN16, "", 488, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN16, "", 588, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN17, "", 488, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN17, "", 586, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN18, "", 488, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN18, "", 586, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN19, "", 690, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN19, "", 790, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN20, "", 690, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN20, "", 790, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN21, "", 690, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN21, "", 790, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN22, "", 690, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN22, "", 790, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN23, "", 690, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN23, "", 789, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN24, "", 690, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN24, "", 789, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN25, "", 892, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN25, "", 993, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN26, "", 892, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN26, "", 993, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN27, "", 892, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN27, "", 993, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN28, "", 892, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN28, "", 993, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN29, "", 892, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN29, "", 992, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN30, "", 892, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN30, "", 992, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN31, "", 1095, 198, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN31, "", 1196, 198, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN32, "", 1095, 232, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN32, "", 1196, 232, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN33, "", 1095, 265, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN33, "", 1196, 265, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN34, "", 1095, 299, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN34, "", 1196, 299, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN35, "", 1095, 335, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN35, "", 1194, 335, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_CHAN36, "", 1095, 369, 90, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_CHAN36, "", 1194, 369, 30, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG1, "", 285, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG1, "", 384, 422, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG2, "", 488, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG2, "", 586, 422, 30, 25
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_DIGITAL, "", 690, 422, 90, 25
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_DIGITAL, "", 789, 422, 30, 25
    CONTROL ADD FRAME,    hDlgfEEGDummy, %IDC_FRAME1, "fEEG Program Streaming " + _
        "Information", 15, 16, 1095, 130
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL1, "Server:", 34, 56, 38, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL2, "Port:", 270, 56, 38, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL4, "1", 38, 198, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL5, "2", 38, 232, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL6, "4", 38, 299, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL7, "3", 38, 265, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL8, "6", 38, 369, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL9, "5", 38, 335, 37, 34, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL16, "7", 240, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL17, "8", 240, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL18, "10", 240, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL19, "9", 240, 265, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL20, "12", 240, 369, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL21, "11", 240, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL22, "13", 442, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL23, "14", 442, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL24, "16", 442, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL25, "15", 442, 265, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL26, "18", 442, 369, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL27, "17", 442, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL28, "19", 645, 198, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL29, "20", 645, 232, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL30, "22", 645, 299, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL31, "21", 645, 265, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL32, "24", 645, 369, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL33, "23", 645, 335, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL34, "25", 848, 198, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL35, "26", 848, 232, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL36, "28", 848, 299, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL37, "27", 848, 265, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL38, "30", 848, 369, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL39, "29", 848, 335, 37, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL40, "Digital Events", 615, 422, 67, _
        35, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL41, "Analog 2", 428, 422, 52, 35, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL42, "Analog 1", 225, 422, 53, 35, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlgfEEGDummy, %IDC_FRAME3, "Channels", 15, 154, 1215, 317
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL43, "36", 1050, 369, 38, 36, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL44, "35", 1050, 335, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL45, "34", 1050, 299, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL46, "33", 1050, 265, 38, 36, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL47, "32", 1050, 232, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL48, "31", 1050, 198, 38, 34, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_SELECTALL, "Select/Deselect " + _
        "All", 945, 433, 120, 25, , , CALL cbSelectDeselectAll
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL_STATUS, "", 0, 496, 1298, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD COMBOBOX, hDlgfEEGDummy, %IDC_COMBOBOX_CHANNELS, , 637, 56, 80, 72, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %CBS_DROPDOWNLIST OR %CBS_AUTOHSCROLL, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL3, "Number of Output Channels:", _
        493, 56, 144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT _
        OR %WS_EX_LTRREADING
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG1, "Analog 1", 773, _
        55, 96, 24
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG2, "Analog 2", 773, _
        79, 96, 24
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL10, "+/-", 732, 64, 32, 32
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL11, "Which Channels to View", 944, _
        416, 136, 16
    CONTROL ADD CHECKBOX, hDlgfEEGDummy, %IDC_CHECKBOX_PROCESSTOFILE, "Process to " + _
        "file", 41, 115, 104, 24
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_PROCESSTOFILE, "", 144, 112, _
        224, 24
    CONTROL ADD LABEL,    hDlgfEEGDummy, %IDC_LABEL12, "Receiver Timeout (ms):", 424, _
        112, 144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlgfEEGDummy, %IDC_TEXTBOX_TIMEOUT, "30000", 574, 109, 66, 24

    FONT NEW "MS Sans Serif", 14, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlgfEEGDummy, %IDC_LABEL10, hFont1
#PBFORMS END DIALOG

    FOR x = 1 TO 36
        COMBOBOX ADD hDlgfEEGDummy, %IDC_COMBOBOX_CHANNELS, STR$(x)
    NEXT x

    CONTROL SHOW STATE hDlgfEEGDummy, %IDC_TEXTBOX_PROCESSTOFILE, %SW_HIDE


#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

END SUB
'------------------------------------------------------------------------------



FUNCTION connectTofEEG() AS LONG
    STATIC nSocket    AS LONG
    LOCAL  sBuffer, sNumChannels   AS STRING
    LOCAL sPacket AS STRING
    LOCAL sPort, sServer AS STRING
    LOCAL lPort, lError, lPartialFrame, lResult, lChannelCnt AS LONG
    LOCAL iEmpty, x AS INTEGER

    gsProcessFileName = ""
    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_PROCESSTOFILE TO lResult
    IF (lResult = 1) THEN
        CONTROL GET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_PROCESSTOFILE TO gsProcessFileName
    END IF

    COMBOBOX GET TEXT hDlgfEEGDummy, %IDC_COMBOBOX_CHANNELS TO sNumChannels

    lChannelCnt = VAL(sNumChannels)

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG1 TO lResult
    IF (lResult = 1) THEN
        lChannelCnt = lChannelCnt + 1
    END IF

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG2 TO lResult
    IF (lResult = 1) THEN
        lChannelCnt = lChannelCnt + 1
    END IF


    giNumberOfChannels = lChannelCnt + 1

    giBufferSize = giNumberOfChannels * 2

    DIM Channels(giNumberOfChannels)



    'CALL dumpDataStream
    'EXIT FUNCTION

    'CALL BinaryIO
    'EXIT FUNCTION


    iEmpty = 0
    DO
        'TCP PRINT nSocket, "Hello from PowerBASIC!"
        IF (ERR) THEN
            MSGBOX "Error: " + STR$(ERR)
            EXIT FUNCTION
        END IF
        lError = tcpSafeReceive(nSocket, giBufferSize, sBuffer)
        IF (ERR) THEN
            MSGBOX "Error: " + STR$(ERR)
            EXIT FUNCTION
        ELSE
            splitIntoChannels(sBuffer)
'             glBufferCnt = glBufferCnt + 1
'                '======================================
'                'find start of real data in buffer
'                '======================================
'               IF (iEmpty = 0) THEN
'                   x = findFirstNonNullCharacter (sBuffer)
'
'                   IF (x = 0) THEN  'Empty buffer
'                       iEmpty = 0
'                       ITERATE
'                   ELSE
'                       iEmpty = 1
'                   END IF
'                END IF
'
'               lPartialFrame = processBuffer2(x, sBuffer)
'               IF (lPartialFrame = 1) THEN
'                   x = 1
'                   ITERATE
'               END IF
        END IF
    LOOP

    FUNCTION = 1
END FUNCTION


SUB BinaryIO
  ' The file is opened for binary I/O. Data is
  ' read 'using GET$. SEEK explicitly moves the
  ' file pointer to 'the end of file, and the
  ' same data is written back to 'the file.
  LOCAL char, tempStr, buffer, str, midStr AS STRING
  LOCAL x, chrCount, iEmpty, nulFound AS INTEGER
  LOCAL lPartialFrame AS LONG

  'OPEN "OPEN_INT.txt" FOR OUTPUT AS #2
  'OPEN "open2.dta" FOR BINARY AS #1
   OPEN "OPEN_34_Channels.txt" FOR BINARY AS #1

  TempStr$ = ""
  chrCount = 0
  glBufferCharCnt = 0
  glBufferCnt = 0
  gChannelIndex = 0

  glPartialBufferFlag = 0
  WHILE ISFALSE EOF(1)
    GET$ #1, 1, char
    chrCount = chrCount + 1
    glBufferCharCnt = glBufferCharCnt + 1

    tempStr = tempStr + char
    IF (chrCount = 1024) THEN
        glBufferCnt = glBufferCnt + 1
        '======================================
        'find start of real data in buffer
        '======================================
       IF (iEmpty = 0) THEN
           x = findFirstNonNullCharacter (tempStr)

           IF (x = 0) THEN  'Empty buffer
               iEmpty = 0
               chrCount = 0
               tempStr = ""
               ITERATE
           ELSE
               nulFound = findFirstNullCharacter (tempStr)
               'IF (nulFound <> iFrameSize) THEN
               '    x = nulFound + 4
               'END IF
               iEmpty = 1
           END IF
        END IF

       'lPartialFrame = processBuffer(x, iFrameSize, tempStr)
       lPartialFrame = processBuffer2(x, tempStr)
       IF (lPartialFrame = 1) THEN
           x = 1
           chrCount = 0
           tempStr = ""
           ITERATE
       END IF
    END IF
  WEND

  SEEK #1, LOF(1)

  CLOSE 1
  'CLOSE #2
END SUB  ' end procedure BinaryIO

FUNCTION findFirstNonNullCharacter(buffer AS STRING) AS LONG
    LOCAL x, lLen, lPos AS LONG
    LOCAL temp AS STRING

    temp = CHR$(0) + CHR$(0)
    lPos = 0
    lLen = LEN(buffer)
    FOR x = 1 TO lLen STEP 2
        IF (MID$(buffer, x, 2) <> temp) THEN
           lPos = x
           EXIT FOR
        END IF
    NEXT x

    FUNCTION = lPos
END FUNCTION

FUNCTION findFirstNullCharacter(buffer AS STRING) AS LONG
    LOCAL x, lLen, lPos AS LONG
    LOCAL temp AS STRING

    temp = CHR$(0) + CHR$(0)
    lPos = 0
    lLen = LEN(buffer)
    FOR x = 1 TO lLen STEP 2
        IF (MID$(buffer, x, 2) = temp) THEN
           lPos = x
           EXIT FOR
        END IF
    NEXT x

    FUNCTION = lPos
END FUNCTION


FUNCTION  processBuffer2(startPos AS INTEGER, buffer AS STRING) AS LONG
    LOCAL lenFrame, lenTempBuffer AS LONG
    LOCAL RecLen, x  AS LONG
    LOCAL sFrame, tempBuffer AS STRING

    RecLen = giNumberOfChannels * 2

    IF (giBufferSize - startPos < RecLen) THEN
        gsFinalPartialBuffer = MID$(tempBuffer, startPos, giBufferSize - startPos)
        glPartialBufferFlag = 1
        FUNCTION = glPartialBufferFlag
    END IF

    IF (glPartialBufferFlag = 1) THEN
        tempBuffer = gsFinalPartialBuffer + buffer

        DO
            lenTempBuffer = LEN(tempBuffer)
            sFrame = MID$(tempBuffer, startPos, RecLen)

            IF (LEN(sFrame) < RecLen) THEN
                glPartialBufferFlag = 1
                gsFinalPartialBuffer = RIGHT$(tempBuffer, giBufferSize - lenTempBuffer)
                EXIT
            END IF


            splitIntoChannels(sFrame)
            tempBuffer = RIGHT$(tempBuffer, lenTempBuffer - RecLen)
        LOOP
    ELSE
        tempBuffer = buffer

        DO
            lenTempBuffer = LEN(tempBuffer)
            sFrame = MID$(tempBuffer, startPos, RecLen)

            IF (LEN(sFrame) < RecLen) THEN
                glPartialBufferFlag = 1
                gsFinalPartialBuffer = RIGHT$(tempBuffer, LEN(sFrame))
                EXIT
            END IF

            splitIntoChannels(sFrame)
            tempBuffer = RIGHT$(tempBuffer, lenTempBuffer - RecLen)
        LOOP
    END IF

    FUNCTION =  glPartialBufferFlag

END FUNCTION

FUNCTION getString(str AS STRING, startPos AS LONG, endPos AS LONG) AS STRING
    LOCAL temp AS STRING

    temp = MID$(str, startPos, (endPos - startPos) + 1)

    FUNCTION = temp
END FUNCTION

SUB splitIntoChannels(buffer AS STRING)
    LOCAL x, cnt, lLen, lResult AS LONG
    LOCAL iTemp, iLo, iHi, iNew AS INTEGER
    LOCAL channelCnt AS LONG
    LOCAL sNumChannels AS STRING

    IF (gsProcessFileName <> "") THEN
        OPEN gsProcessFileName FOR OUTPUT AS 1
    END IF


    lLen = LEN(buffer)
    'MSGBOX STR$(lLen)
    cnt = 0
    FOR x = 1 TO lLen STEP 2
        iTemp = CVI(buffer, x)
        'MSGBOX STR$(x) + ", " + STR$(iTemp)
        iLo = LO(BYTE, iTemp)
        iHi = HI(BYTE, iTemp)
        iNew = MAK(INTEGER, iHi, iLo)
        Channels(cnt) = iNew
        cnt = cnt + 1
    NEXT x


    COMBOBOX GET TEXT hDlgfEEGDummy, %IDC_COMBOBOX_CHANNELS TO sNumChannels
    channelCnt = VAL(sNumChannels)



    FOR x = 0 TO channelCnt - 1
        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_CHAN01 + x TO lResult
        IF (lResult = 1) THEN 'checked
            CONTROL SET TEXT hDlgfEEGDummy, %IDC_TEXTBOX_CHAN01 + x, STR$(Channels(x))
            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_CHAN01 + x
            IF (gsProcessFileName <> "") THEN
                PRINT #1, Channels(x); ", ";
            END IF
          END IF
    NEXT x

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG1 TO lResult
    IF (lResult = 1) THEN
        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG1 TO lResult
        IF (lResult = 1) THEN 'checked
            CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_ANALOG1 , STR$(Channels(channelCnt))
            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG1
             IF (gsProcessFileName <> "") THEN
                PRINT #1, Channels(channelCnt); ", ";
            END IF
        END IF
    END IF

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_USE_ANALOG2 TO lResult
    IF (lResult = 1) THEN
        CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_ANALOG2 TO lResult
        IF (lResult = 1) THEN 'checked
            CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_ANALOG2 , STR$(Channels(channelCnt + 1))
            CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_ANALOG2
            IF (gsProcessFileName <> "") THEN
                PRINT #1, Channels(channelCnt + 1); ", ";
            END IF
        END IF
    END IF

    CONTROL GET CHECK hDlgfEEGDummy, %IDC_CHECKBOX_DIGITAL TO lResult
    IF (lResult = 1) THEN 'checked
        CONTROL SET TEXT hDlgfEEGDummy,%IDC_TEXTBOX_DIGITAL , STR$(Channels(channelCnt + 2))
        CONTROL REDRAW hDlgfEEGDummy, %IDC_TEXTBOX_DIGITAL
        IF (gsProcessFileName <> "") THEN
                PRINT #1, Channels(channelCnt + 2)
        END IF
    END IF



    'DIALOG REDRAW hDlgfEEGDummy


    SLEEP 10
END SUB

FUNCTION tcpSafeReceive(BYVAL hSocket AS LONG, BYVAL iBufferLen AS LONG, _
                        recBuff AS STRING) AS LONG

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
      SLEEP 1
   LOOP
   FUNCTION = %True
END FUNCTION
