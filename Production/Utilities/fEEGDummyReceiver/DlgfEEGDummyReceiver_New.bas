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
#RESOURCE "DlgfEEGDummyReceiver_New.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS 
%IDD_DIALOG1                =  101
%IDC_FRAME1                 =  201
%IDC_FRAME3                 =  202
%IDC_LABEL1                 = 1001
%IDC_LABEL2                 = 1002
%IDC_LABEL4                 = 1009
%IDC_LABEL5                 = 1010
%IDC_LABEL6                 = 1011
%IDC_LABEL7                 = 1012
%IDC_LABEL8                 = 1013
%IDC_LABEL9                 = 1014
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
%IDC_LABEL3                 = 1802
%IDC_CHECKBOX_USE_ANALOG1   = 1901
%IDC_CHECKBOX_USE_ANALOG2   = 1902
%IDC_LABEL10                = 1903
%IDC_LABEL11                = 1904
%IDC_CHECKBOX_PROCESSTOFILE = 1903
%IDC_TEXTBOX_PROCESSTOFILE  = 1906
%IDC_LABEL12                = 1907
%IDC_TEXTBOX1               = 1908
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()

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
                ' /* Inserted by PB/Forms 06-28-2011 13:21:50
                CASE %IDC_CHECKBOX_PROCESSTOFILE

                CASE %IDC_TEXTBOX_PROCESSTOFILE
                ' */

                ' /* Inserted by PB/Forms 06-24-2011 11:52:07
                CASE %IDC_COMBOBOX_CHANNELS

                CASE %IDC_CHECKBOX_USE_ANALOG1

                CASE %IDC_CHECKBOX_USE_ANALOG2
                ' */

                ' /* Inserted by PB/Forms 06-24-2011 10:14:02
                CASE %IDC_TEXTBOX_CHAN01
                ' */

                ' /* Inserted by PB/Forms 06-24-2011 10:11:27
                CASE %IDC_TEXTBOX_CHAN02

                CASE %IDC_TEXTBOX_CHAN05
                ' */

                ' /* Inserted by PB/Forms 06-24-2011 09:46:34
                CASE %IDC_STATUSBAR1
                ' */

                ' /* Inserted by PB/Forms 06-24-2011 09:14:56
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
                ' */

                CASE %IDC_TEXTBOX_SERVER

                CASE %IDC_TEXTBOX_PORT

                CASE %IDC_BUTTON_CONNECT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_CONNECT=" + _
                            FORMAT$(%IDC_BUTTON_CONNECT), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_PROCESS
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_PROCESS=" + _
                            FORMAT$(%IDC_BUTTON_PROCESS), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_CLOSE
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_CLOSE=" + _
                            FORMAT$(%IDC_BUTTON_CLOSE), %MB_TASKMODAL
                    END IF

                CASE %IDC_TEXTBOXCHAN01

                CASE %IDC_CHECKBOX_CHAN01

                CASE %IDC_TEXTBOX1

                CASE %IDC_CHECKBOX_CHAN02

                CASE %IDC_TEXTBOX_CHAN03

                CASE %IDC_CHECKBOX_CHAN03

                CASE %IDC_TEXTBOX_CHAN04

                CASE %IDC_CHECKBOX_CHAN04

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

                CASE %IDC_TEXTBOX15

                CASE %IDC_CHECKBOX7

                CASE %IDC_TEXTBOX16

                CASE %IDC_CHECKBOX8

                CASE %IDC_TEXTBOX17

                CASE %IDC_CHECKBOX10

                CASE %IDC_TEXTBOX14

                CASE %IDC_CHECKBOX9

                CASE %IDC_TEXTBOX19

                CASE %IDC_CHECKBOX12

                CASE %IDC_TEXTBOX18

                CASE %IDC_CHECKBOX11

                CASE %IDC_TEXTBOX21

                CASE %IDC_CHECKBOX13

                CASE %IDC_TEXTBOX22

                CASE %IDC_CHECKBOX14

                CASE %IDC_TEXTBOX23

                CASE %IDC_CHECKBOX16

                CASE %IDC_TEXTBOX20

                CASE %IDC_CHECKBOX15

                CASE %IDC_TEXTBOX25

                CASE %IDC_CHECKBOX18

                CASE %IDC_TEXTBOX24

                CASE %IDC_CHECKBOX17

                CASE %IDC_TEXTBOX27

                CASE %IDC_CHECKBOX19

                CASE %IDC_TEXTBOX28

                CASE %IDC_CHECKBOX20

                CASE %IDC_TEXTBOX29

                CASE %IDC_CHECKBOX22

                CASE %IDC_TEXTBOX26

                CASE %IDC_CHECKBOX21

                CASE %IDC_TEXTBOX31

                CASE %IDC_CHECKBOX24

                CASE %IDC_TEXTBOX30

                CASE %IDC_CHECKBOX23

                CASE %IDC_TEXTBOX40

                CASE %IDC_CHECKBOX33

                CASE %IDC_TEXTBOX39

                CASE %IDC_CHECKBOX32

                CASE %IDC_TEXTBOX38

                CASE %IDC_CHECKBOX31

                CASE %IDC_TEXTBOX37

                CASE %IDC_CHECKBOX30

                CASE %IDC_TEXTBOX35

                CASE %IDC_CHECKBOX29

                CASE %IDC_TEXTBOX36

                CASE %IDC_CHECKBOX28

                CASE %IDC_TEXTBOX34

                CASE %IDC_CHECKBOX27

                CASE %IDC_TEXTBOX33

                CASE %IDC_CHECKBOX26

                CASE %IDC_TEXTBOX32

                CASE %IDC_CHECKBOX25

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, hParent, "Dialog1", 15, 114, 1298, 520, TO hDlg
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_SERVER, "10.10.11.11", 76, 56, _
        173, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_PORT, "9780", 314, 56, 172, 24
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
        "All", 945, 433, 120, 25
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
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX1, "30000", 574, 109, 66, 24

    FONT NEW "MS Sans Serif", 14, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL10, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

              

              

              

              