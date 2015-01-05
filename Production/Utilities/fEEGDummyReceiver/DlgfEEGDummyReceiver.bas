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
#RESOURCE "DlgfEEGDummyReceiver.pbr"
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
%IDD_DIALOG1             =  101
%IDC_TEXTBOX_SERVER      = 1002
%IDC_LABEL_SERVER        = 1001
%IDC_LABEL_PORT          = 1003
%IDC_TEXTBOX_PORT        = 1004
%IDC_RICHEDIT_FEED       = 1005
%IDC_BUTTON_CONNECT      = 1006
%IDC_BUTTON_CANCEL       = 1007
%IDC_BUTTON_PROCESS      = 1008
%IDC_LABEL2              = 1009
%IDC_TEXTBOX_NUMCHANNELS = 1010
%IDC_LABEL1              = 1011
%IDC_TEXTBOX_CHAN01      = 1012
%IDC_TEXTBOX_CHAN02      = 1013
%IDC_LABEL3              = 1014
%IDC_TEXTBOX_CHAN03      = 1015
%IDC_LABEL4              = 1016
%IDC_TEXTBOX_CHAN04      = 1017
%IDC_LABEL5              = 1018
%IDC_TEXTBOX_CHAN05      = 1019
%IDC_LABEL6              = 1020
%IDC_TEXTBOX_CHAN06      = 1021
%IDC_LABEL7              = 1022
%IDC_TEXTBOX_CHAN07      = 1023
%IDC_LABEL8              = 1024
%IDC_TEXTBOX_CHAN08      = 1025
%IDC_LABEL9              = 1026
%IDC_TEXTBOX_CHAN09      = 1027
%IDC_LABEL10             = 1028
%IDC_TEXTBOX_CHAN10      = 1029
%IDC_LABEL11             = 1030
%IDC_TEXTBOX_CHAN11      = 1031
%IDC_LABEL12             = 1032
%IDC_TEXTBOX_CHAN12      = 1033
%IDC_LABEL13             = 1034
%IDC_TEXTBOX_CHAN18      = 1035
%IDC_TEXTBOX_CHAN13      = 1036
%IDC_LABEL14             = 1037
%IDC_TEXTBOX_CHAN14      = 1038
%IDC_LABEL15             = 1039
%IDC_TEXTBOX_CHAN15      = 1040
%IDC_LABEL16             = 1041
%IDC_TEXTBOX_CHAN16      = 1042
%IDC_LABEL17             = 1043
%IDC_TEXTBOX_CHAN17      = 1044
%IDC_LABEL18             = 1045
%IDC_LABEL19             = 1046
%IDC_TEXTBOX_CHAN22      = 1047
%IDC_TEXTBOX_CHAN24      = 1048
%IDC_TEXTBOX_CHAN19      = 1049
%IDC_LABEL20             = 1050
%IDC_TEXTBOX_CHAN20      = 1051
%IDC_LABEL21             = 1052
%IDC_TEXTBOX_CHAN21      = 1053
%IDC_LABEL22             = 1054
%IDC_LABEL23             = 1055
%IDC_TEXTBOX_CHAN23      = 1056
%IDC_LABEL24             = 1057
%IDC_LABEL25             = 1058
%IDC_TEXTBOX_CHAN25      = 1059
%IDC_LABEL26             = 1060
%IDC_LABEL_STATUS        = 1061
%IDC_TEXTBOX_CHAN30      = 1062
%IDC_TEXTBOX_CHAN28      = 1063
%IDC_LABEL27             = 1064
%IDC_TEXTBOX_CHAN26      = 1065
%IDC_LABEL28             = 1066
%IDC_TEXTBOX_CHAN27      = 1067
%IDC_LABEL29             = 1068
%IDC_LABEL30             = 1069
%IDC_TEXTBOX_CHAN29      = 1070
%IDC_LABEL31             = 1071
%IDC_LABEL32             = 1072
%IDC_TEXTBOX_CHAN36      = 1073
%IDC_TEXTBOX_CHAN34      = 1074
%IDC_TEXTBOX_CHAN31      = 1075
%IDC_LABEL33             = 1076
%IDC_TEXTBOX_CHAN32      = 1077
%IDC_LABEL34             = 1078
%IDC_TEXTBOX_CHAN33      = 1079
%IDC_LABEL35             = 1080
%IDC_LABEL36             = 1081
%IDC_TEXTBOX_CHAN35      = 1082
%IDC_LABEL37             = 1083
%IDC_LABEL38             = 1084
%IDC_TEXTBOX_DIGITAL     = 1059
%IDC_LABEL39             = 1086
%IDC_LABEL40             = 1088
%IDC_TEXTBOX_ANALOG1     = 1085
%IDC_TEXTBOX_ANALOG2     = 1087
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
                ' /* Inserted by PB/Forms 06-22-2011 15:55:18
                CASE %IDC_TEXTBOX_ANALOG1

                CASE %IDC_TEXTBOX_ANALOG2
                ' */

                ' /* Inserted by PB/Forms 06-22-2011 15:00:56
                CASE %IDC_BUTTON_PROCESS
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_PROCESS=" + _
                            FORMAT$(%IDC_BUTTON_PROCESS), %MB_TASKMODAL
                    END IF

                CASE %IDC_TEXTBOX_NUMCHANNELS

                CASE %IDC_TEXTBOX_CHAN01

                CASE %IDC_TEXTBOX_CHAN02

                CASE %IDC_TEXTBOX_CHAN03

                CASE %IDC_TEXTBOX_CHAN04

                CASE %IDC_TEXTBOX_CHAN05

                CASE %IDC_TEXTBOX_CHAN06

                CASE %IDC_TEXTBOX_CHAN07

                CASE %IDC_TEXTBOX_CHAN08

                CASE %IDC_TEXTBOX_CHAN09

                CASE %IDC_TEXTBOX_CHAN10

                CASE %IDC_TEXTBOX_CHAN11

                CASE %IDC_TEXTBOX_CHAN12

                CASE %IDC_TEXTBOX_CHAN18

                CASE %IDC_TEXTBOX_CHAN13

                CASE %IDC_TEXTBOX_CHAN14

                CASE %IDC_TEXTBOX_CHAN15

                CASE %IDC_TEXTBOX_CHAN16

                CASE %IDC_TEXTBOX_CHAN17

                CASE %IDC_TEXTBOX_CHAN22

                CASE %IDC_TEXTBOX_CHAN24

                CASE %IDC_TEXTBOX_CHAN19

                CASE %IDC_TEXTBOX_CHAN20

                CASE %IDC_TEXTBOX_CHAN21

                CASE %IDC_TEXTBOX_CHAN23

                CASE %IDC_TEXTBOX_DIGITAL

                CASE %IDC_TEXTBOX_CHAN30

                CASE %IDC_TEXTBOX_CHAN28

                CASE %IDC_TEXTBOX_CHAN25

                CASE %IDC_TEXTBOX_CHAN26

                CASE %IDC_TEXTBOX_CHAN27

                CASE %IDC_TEXTBOX_CHAN29

                CASE %IDC_TEXTBOX_CHAN36

                CASE %IDC_TEXTBOX_CHAN34

                CASE %IDC_TEXTBOX_CHAN31

                CASE %IDC_TEXTBOX_CHAN32

                CASE %IDC_TEXTBOX_CHAN33

                CASE %IDC_TEXTBOX_CHAN35
                ' */

                CASE %IDC_TEXTBOX_SERVER

                CASE %IDC_TEXTBOX_PORT

                CASE %IDC_RICHEDIT_FEED

                CASE %IDC_BUTTON_CONNECT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_CONNECT=" + _
                            FORMAT$(%IDC_BUTTON_CONNECT), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_CANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_CANCEL=" + _
                            FORMAT$(%IDC_BUTTON_CANCEL), %MB_TASKMODAL
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG
    LOCAL hDlgfEEGDummy AS DWORD

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, hParent, "fEEG Dummy Receiver", 130, 288, 1210, 347, _
        TO hDlg
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_SERVER, "10.10.11.11", 80, 24, _
        136, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_PORT, "9870", 296, 24, 112, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_NUMCHANNELS, "26", 528, 24, 112, _
        24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_CONNECT, "Connect", 688, 24, 80, _
        32
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_PROCESS, "Process", 800, 24, 80, _
        32
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_CANCEL, "Cancel", 912, 24, 80, 32
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN01, "", 107, 114, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN02, "", 107, 144, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN03, "", 107, 173, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN04, "", 107, 202, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN05, "", 107, 231, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN06, "", 107, 260, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN07, "", 296, 118, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN08, "", 296, 147, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN09, "", 296, 176, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN10, "", 296, 205, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN11, "", 296, 234, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN12, "", 296, 263, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN13, "", 488, 119, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN14, "", 488, 148, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN15, "", 488, 177, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN16, "", 488, 206, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN17, "", 488, 235, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN18, "", 488, 264, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN19, "", 688, 121, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN20, "", 688, 150, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN21, "", 688, 179, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN22, "", 688, 208, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN23, "", 688, 237, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN24, "", 688, 266, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN25, "", 888, 121, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN26, "", 888, 150, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN27, "", 888, 179, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN28, "", 888, 208, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN29, "", 888, 237, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN30, "", 888, 266, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN31, "", 1088, 121, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN32, "", 1088, 150, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN33, "", 1088, 179, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN34, "", 1088, 208, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN35, "", 1088, 237, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_CHAN36, "", 1088, 266, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ANALOG1, "", 344, 304, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ANALOG2, "", 592, 304, 88, 24
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_DIGITAL, "", 832, 304, 88, 24
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_SERVER, "Server:", 16, 28, 56, 25, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_PORT, "Port:", 222, 29, 56, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "# Channels:", 448, 28, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Channel 1:", 32, 119, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "Channel 2:", 32, 149, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL4, "Channel 3:", 32, 178, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL5, "Channel 4:", 32, 207, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL6, "Channel 5:", 32, 236, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL7, "Channel 6:", 32, 265, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL8, "Channel 7:", 221, 123, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL9, "Channel 8:", 221, 152, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL10, "Channel 9:", 221, 181, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL11, "Channel 10:", 221, 210, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL12, "Channel 11:", 221, 239, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL13, "Channel 12:", 221, 268, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL14, "Channel 13:", 413, 124, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL15, "Channel 14:", 413, 153, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL16, "Channel 15:", 413, 182, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL17, "Channel 16:", 413, 211, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL18, "Channel 17:", 413, 240, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL19, "Channel 18:", 413, 269, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL20, "Channel 19:", 613, 126, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL21, "Channel 20:", 613, 155, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL22, "Channel 21:", 613, 184, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL23, "Channel 22:", 613, 213, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL24, "Channel 23:", 613, 242, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL25, "Channel 24:", 613, 271, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL26, "Digital Events", 757, 309, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_STATUS, "", 40, 72, 504, 24
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL27, "Channel 25:", 813, 126, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL28, "Channel 26:", 813, 155, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL29, "Channel 27:", 813, 184, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL30, "Channel 28:", 813, 213, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL31, "Channel 29:", 813, 242, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL32, "Channel 30:", 813, 271, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL33, "Channel 31:", 1013, 126, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL34, "Channel 32:", 1013, 155, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL35, "Channel 33:", 1013, 184, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL36, "Channel 34:", 1013, 213, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL37, "Channel 35:", 1013, 242, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL38, "Channel 36:", 1013, 271, 72, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL39, "Analog 1", 269, 309, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL40, "Analog 2", 517, 309, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlgfEEGDummy, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

              

              