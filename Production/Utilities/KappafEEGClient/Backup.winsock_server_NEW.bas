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
#RESOURCE "winsock_server_NEW.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "mswinsck.inc"
#INCLUDE "ole2utils.inc"

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1            =  101
%IDC_LABEL_Status       = 1001
%IDC_BUTTON_OpenFile    = 1002
%IDC_TEXTBOX_RecvBuffer = 1003
%IDC_BUTTON1            = 1004  '*
%IDC_BUTTON_Close       = 1005
%IDC_TEXTBOX_SendBuffer = 1006
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL pTcpServer AS IMSWinsockControl
GLOBAL hDlg AS DWORD
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
    LOCAL filename, char, tempStr AS STRING
    STATIC pTcpServerEvents AS DMSWinsockControlEventsImpl

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            ' Create a registration-free instance of the control
             pTcpServer = CreateInstanceFromDll(EXE.PATH$ & "MSWINSCK.OCX", $CLSID_Winsock, $IID_IMSWinsockControl, $RTLKEY_Winsock)
             IF ISOBJECT(pTcpServer) THEN
                ' Connect to the events fired by the control
                pTcpServerEvents = CLASS "CDMSWinsockControlEvents"
                IF ISOBJECT(pTcpServerEvents) THEN EVENTS FROM pTcpServer CALL pTcpServerEvents
                ' Set the UDP protocol
                pTcpServer.Protocol = %sckTCPProtocol
                ' Set the remote port
               pTcpServer.RemoteHost = "192.168.1.64"
                pTcpServer.LocalPort = 999
                ' Call the Listen method
                pTcpServer.Listen
            END IF
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
                ' /* Inserted by PB/Forms 08-19-2013 10:51:05
                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg
                    END IF

                CASE %IDC_TEXTBOX_SendBuffer
                 IF CB.CTLMSG = %EN_CHANGE THEN
                      ' Retrieve the text of the input window
                      CONTROL GET TEXT CB.HNDL, %IDC_TEXTBOX_SendBuffer TO tempStr
                      MSGBOX STR$(LEN(tempStr))
                      ' Send the text
                     'pTcpServer.SendData strText
               END IF
                CASE %IDC_TEXTBOX_RecvBuffer
                ' */

                CASE %IDC_BUTTON_OpenFile
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Choose file to send", "", CHR$("*.* Files", 0, "*.*", 0), "", "*", %OFN_SHOWHELP   TO filename
                        IF (filename <> "") THEN
                             OPEN filename FOR BINARY AS #1

                             TempStr$ = ""
                             WHILE ISFALSE EOF(1)
                               GET$ #1, 1024, char
                               tempStr = tempStr + char
                               pTcpServer.SendData tempStr
                               CONTROL SET TEXT hDlg, %IDC_TEXTBOX_SendBuffer, tempStr
                             WEND

                             CLOSE #1
                        END IF
                    END IF
            END SELECT
        CASE %WM_DESTROY
            ' Close the connection
             IF pTcpServer.State <> %sckClosed THEN
                pTcpServer.Close
             END IF
             ' Disconnect events
             IF ISOBJECT(pTcpServerEvents) THEN EVENTS END pTcpServerEvents
             ' Release the control
             IF ISOBJECT(pTcpServer) THEN pTcpServer = NOTHING
    END SELECT
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

    DIALOG NEW PIXELS, hParent, "Winsock Server", 105, 114, 453, 454, TO hDlg
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_Status, "", 0, 416, 448, 32
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_OpenFile, "Open File to Send", 8, _
        16, 208, 32
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_RecvBuffer, "", 8, 240, 432, 160, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %ES_LEFT OR %ES_MULTILINE OR %ES_AUTOHSCROLL OR _
        %ES_AUTOVSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Close, "Close", 232, 16, 128, 32
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_SendBuffer, "", 8, 64, 432, 160, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %ES_LEFT OR %ES_MULTILINE OR %ES_AUTOHSCROLL OR _
        %ES_AUTOVSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL_Status, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_OpenFile, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
#PBFORMS END DIALOG
     CONTROL SEND hdlg, %IDC_TEXTBOX_SendBuffer, %EM_SETLIMITTEXT, 2000000, 0 'Len(db.WholeName)
    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

CLASS CDMSWinsockControlEvents GUID$("{921B7E22-AB55-4E0F-BFAD-A09542BCE3B8}") AS EVENT

INTERFACE DMSWinsockControlEventsImpl GUID$("{248DD893-BB45-11CF-9ABC-0080C7E7B78D}") AS EVENT

  INHERIT IDISPATCH

   ' =====================================================================================
   METHOD ERROR <6> ( _
     BYVAL prm_Number AS INTEGER _                      ' Number VT_I2 <Integer>
   , BYREF prm_Description AS STRING _                  ' *Description VT_BSTR
   , BYVAL prm_Scode AS LONG _                          ' Scode VT_I4 <Long>
   , BYVAL prm_Source AS STRING _                       ' Source VT_BSTR
   , BYVAL prm_HelpFile AS STRING _                     ' HelpFile VT_BSTR
   , BYVAL prm_HelpContext AS LONG _                    ' HelpContext VT_I4 <Long>
   , BYREF prm_CancelDisplay AS INTEGER _               ' *CancelDisplay VT_BOOL <Integer>
   )                                                    ' VOID

     ' *** Insert your code here ***
      SetWindowText hDlg, "Error " & FORMAT$(prm_Scode) & " - " & ACODE$(prm_Description)
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD DataArrival <0> ( _
     BYVAL prm_bytesTotal AS LONG _                     ' bytesTotal VT_I4 <Long>
   )                                                    ' VOID

     ' *** Insert your code here ***
     ' Retrieve the text received and output it in the output window
      LOCAL vData AS VARIANT
      pTcpServer.GetData vData, 8   ' %vbString = 8
      CONTROL SET TEXT hDlg, %IDC_TEXTBOX_RecvBuffer, VARIANT$(vData)
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD CONNECT <1>

     ' *** Insert your code here ***
     SetWindowText hDlg, "Connect"
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD ConnectionRequest <2> ( _
     BYVAL prm_requestID AS LONG _                      ' requestID VT_I4 <Long>
   )                                                    ' VOID

     ' *** Insert your code here ***
     ' Check if the control's State is closed. If not, close the connection
'      ' before accepting the new connection.
      IF pTcpServer.State <> %sckClosed THEN pTcpServer.Close

      ' Accept the request with the requestID parameter.
      pTcpServer.Accept prm_requestID
      SetWindowText hDlg, "ConnectionRequest - requestID: " & FORMAT$(prm_requestID)  & " IP: " + pTcpServer.RemoteHost
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD CLOSE <5>

     ' *** Insert your code here ***
     SetWindowText hDlg, "Close"
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD SendProgress <3> ( _
     BYVAL prm_bytesSent AS LONG _                      ' bytesSent VT_I4 <Long>
   , BYVAL prm_bytesRemaining AS LONG _                 ' bytesRemaining VT_I4 <Long>
   )                                                    ' VOID

     ' *** Insert your code here ***

   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD SendComplete <4>

     ' *** Insert your code here ***

   END METHOD
   ' =====================================================================================

END INTERFACE

END CLASS


' ########################################################################################
' Class CDMSWinsockControlEvents
' Interface name = DMSWinsockControlEvents
' IID = {248DD893-BB45-11CF-9ABC-0080C7E7B78D}
' Microsoft Winsock Control events
' Attributes = 4112 [&H1010] [Hidden] [Dispatchable]
' Code generated by the TypeLib Browser 4.0.13 (c) 2008 by José Roca
' Date: 18 dic 2008   Time: 01:54:58
' ########################################################################################

'CLASS CDMSWinsockControlEvents GUID$("{5DBC24EC-EEEB-4F33-BBD9-D1BEFACA501D}") AS EVENT
'
'INTERFACE DMSWinsockControlEventsImpl GUID$("{248DD893-BB45-11CF-9ABC-0080C7E7B78D}") AS EVENT
'
'  INHERIT IDispatch
'
'   ' =====================================================================================
'   METHOD Error <6> ( _
'     BYVAL Number AS INTEGER _                          ' Number VT_I2 <Integer>
'   , BYREF Description AS STRING _                      ' *Description VT_BSTR
'   , BYVAL Scode AS LONG _                              ' Scode VT_I4 <Long>
'   , BYVAL bstrSource AS STRING _                       ' Source VT_BSTR
'   , BYVAL HelpFile AS STRING _                         ' HelpFile VT_BSTR
'   , BYVAL HelpContext AS LONG _                        ' HelpContext VT_I4 <Long>
'   , BYREF CancelDisplay AS INTEGER _                   ' *CancelDisplay VT_BOOL <Integer>
'   )                                                    ' void
'
'     SetWindowText g_Hdlg, "Error " & FORMAT$(Scode) & " - " & ACODE$(Description)
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD DataArrival <0> ( _
'     BYVAL bytesTotal AS LONG _                         ' bytesTotal VT_I4 <Long>
'   )                                                    ' void
'
'      ' Retrieve the text received and output it in the output window
'      LOCAL vData AS VARIANT
'      pTcpServer.GetData vData, 8   ' %vbString = 8
'      CONTROL SET TEXT g_hDlg, %IDC_OUTPUT, VARIANT$(vData)
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD Connect <1>
'
'      SetWindowText g_Hdlg, "Connect"
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD ConnectionRequest <2> ( _
'     BYVAL requestID AS LONG _                          ' requestID VT_I4 <Long>
'   )                                                    ' void
'
'      ' Check if the control's State is closed. If not, close the connection
'      ' before accepting the new connection.
'      IF pTcpServer.State <> %sckClosed THEN pTcpServer.Close
'
'      ' Accept the request with the requestID parameter.
'      pTcpServer.Accept requestID
'      SetWindowText g_Hdlg, "ConnectionRequest - requestID: " & FORMAT$(requestID)
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD Close <5>
'
'      SetWindowText g_Hdlg, "Close"
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD SendProgress <3> ( _
'     BYVAL bytesSent AS LONG _                          ' bytesSent VT_I4 <Long>
'   , BYVAL bytesRemaining AS LONG _                     ' bytesRemaining VT_I4 <Long>
'   )                                                    ' void
'
'     ' *** Insert your code here ***
'
'   END METHOD
'   ' =====================================================================================
'
'   ' =====================================================================================
'   METHOD SendComplete <4>
'
'     ' *** Insert your code here ***
'
'   END METHOD
'   ' =====================================================================================
'
'END INTERFACE
'
'END CLASS
