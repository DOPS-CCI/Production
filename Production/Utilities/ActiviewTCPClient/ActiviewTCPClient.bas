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
'#RESOURCE "ActiviewTCPClient.pbr"
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
%IDD_DIALOG1                      =  101
%IDC_LABEL1                       = 1001
%IDC_TEXTBOX_TCPServer            = 1002
%IDC_LABEL2                       = 1003
%IDC_TEXTBOX_TCPPort              = 1004
%IDC_LABEL3                       = 1005
%IDC_TEXTBOX_BytesInTCPArray      = 1006
%IDC_LABEL4                       = 1008
%IDC_TEXTBOX_ChannelsSentByTCP    = 1007
%IDC_LABEL5                       = 1010
%IDC_TEXTBOX_TCPSamplesPerChannel = 1009
%IDC_BUTTON_Connect               = 1011
%IDC_BUTTON_Disconnect            = 1012
%IDC_FRAME1                       = 1013
%IDC_CHECKBOX_Connected           = 1014
%IDC_LISTBOX_RecvBuffer           = 1015
%IDC_LABEL6                       = 1016    '*
%IDC_LABEL7                       = 1018
%IDC_TEXTBOX_ReceiverTimeout      = 1017
%IDC_LABEL_TCPBuffer              = 1019
%IDC_BUTTON_Close                 = 1020
%IDC_BUTTON_Process               = 1021
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

#INCLUDE "TCPProcessing.inc"

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL gnSocket AS LONG
GLOBAL gCollect AS IQUEUECOLLECTION

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
                ' /* Inserted by PB/Forms 06-18-2013 09:38:13
                CASE %IDC_BUTTON_Process
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL cbProcess()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 06-18-2013 09:28:49
                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                         DIALOG END CB.HNDL, 0
                    END IF
                ' */

                ' /* Inserted by PB/Forms 06-18-2013 08:55:14
                CASE %IDC_TEXTBOX_ReceiverTimeout
                ' */

                CASE %IDC_TEXTBOX_TCPServer

                CASE %IDC_TEXTBOX_TCPPort

                CASE %IDC_TEXTBOX_BytesInTCPArray

                CASE %IDC_TEXTBOX_ChannelsSentByTCP

                CASE %IDC_TEXTBOX_TCPSamplesPerChannel

                CASE %IDC_BUTTON_Connect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       CALL cbConnect()
                    END IF

                CASE %IDC_BUTTON_Disconnect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        TCP CLOSE gnSocket
                        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Connected, 0

                    END IF

                CASE %IDC_CHECKBOX_Connected

                CASE %IDC_LISTBOX_RecvBuffer

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG

    FOR i = 1 TO lCount
        LISTBOX ADD hDlg, lID, USING$("Test Item #", i)
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Actiview TCP Client", 281, 188, 404, 258, TO hDlg
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Actiview TCP Server IP:", 12, _
        24, 125, 15, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPServer, "137.54.99.124", 142, _
        24, 125, 15
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Port:", 282, 24, 35, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPPort, "778", 322, 24, 55, 15
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Bytes in TCP Array:", 43, 49, _
        96, 15, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_BytesInTCPArray, "", 143, 49, _
        55, 15
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, "", 144, 70, _
        55, 15
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Channels sent by TCP:", 7, 69, _
        133, 16, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, "", 144, _
        90, 55, 16
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "TCP Samples/channel:", 27, 90, _
        113, 15, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Connect, "Connect", 90, 125, 70, _
        25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Disconnect, "Disconnect", 260, _
        125, 70, 25
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "Actiview Server Information", _
        5, 5, 385, 115
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Connected, "Connected", 265, _
        90, 90, 15
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ReceiverTimeout, "60000", 310, _
        50, 55, 15
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL7, "Receiver Timeout:", 210, 50, _
        96, 15, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_TCPBuffer, "", 5, 170, 390, 20
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Close, "Close", 180, 220, 65, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Process, "Process", 175, 125, 70, _
        25

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPServer, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPPort, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_BytesInTCPArray, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Connect, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Disconnect, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Connected, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ReceiverTimeout, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL7, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_TCPBuffer, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Process, hFont1
#PBFORMS END DIALOG

    'SampleListBox  hDlg, %IDC_LISTBOX_RecvBuffer, 30

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
