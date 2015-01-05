' ########################################################################################
' This example creates a TCP client that uses the port 1001.
'
' Compile TCP_Client.BAS and TCP_Server.BAS
' RUN TCP_Server.EXE - It will listen at port 1001
' RUN TCP_Client.EXE. Click the Connect button.
' Type some text in the input window of TCP_Client. It will be echoed in the output window
' of TCP_Server.
' Type some text in the input window of TCP_Server. It will be echoed in the output window
' of TCP_Client.
'
' ########################################################################################

' SED_PBWIN - Use the PBWIN compiler
#COMPILE EXE
#DIM ALL

#INCLUDE "mswinsck.inc"
#INCLUDE "ole2utils.inc"

%IDC_INPUT  = 1001
%IDC_OUTPUT = 1002

GLOBAL g_hDlg AS DWORD
GLOBAL pTcpClient AS IMSWinsockControl

' ========================================================================================
' Main
' ========================================================================================
FUNCTION WINMAIN (BYVAL hInstance AS DWORD, BYVAL hPrevInstance AS DWORD, BYVAL lpszCmdLine AS ASCIIZ PTR, BYVAL nCmdShow AS LONG) AS LONG

   LOCAL hDlg AS LONG

   DIALOG NEW 0, "Winsock TCP Chat Test - Client", 10, 70, 250, 240, %WS_OVERLAPPED OR %WS_THICKFRAME OR %WS_SYSMENU OR _
   %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_VISIBLE, %WS_EX_TOPMOST    TO hDlg
   ' For icon from resource, instead use something like, LoadIcon(hInst, "APPICON")
   DIALOG SEND hDlg, %WM_SETICON, %ICON_SMALL, LoadIcon(%NULL, BYVAL %IDI_APPLICATION)
   DIALOG SEND hDlg, %WM_SETICON, %ICON_BIG, LoadIcon(%NULL, BYVAL %IDI_APPLICATION)
   CONTROL ADD TEXTBOX, hDlg, %IDC_INPUT, "Run TCP_Server. Click conenct and then type some text. It will echoed in the Server window", 5, 5, 388, 90, _
      %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR %ES_MULTILINE, %WS_EX_CLIENTEDGE
   CONTROL ADD TEXTBOX, hDlg, %IDC_OUTPUT, "", 5, 100, 388, 90, _
      %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR %ES_MULTILINE OR %ES_READONLY, %WS_EX_CLIENTEDGE

   CONTROL ADD BUTTON, hDlg, %IDOK, "&Connect", 0, 0, 50, 14, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_FLAT
   CONTROL ADD BUTTON, hDlg, %IDCANCEL, "&Close", 0, 0, 50, 14, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_FLAT

   g_hDlg = hDlg

   DIALOG SHOW MODAL hDlg, CALL DlgProc

END FUNCTION
' ========================================================================================

' ========================================================================================
' Main Dialog procedure
' ========================================================================================
CALLBACK FUNCTION DlgProc() AS LONG

   LOCAL  rc               AS RECT
   LOCAL  hr               AS LONG
   LOCAL  strText          AS STRING
   STATIC pTcpClientEvents AS DMSWinsockControlEventsImpl

   SELECT CASE CB.MSG

      CASE %WM_INITDIALOG
         ' Create a registration-free instance of the control
         pTcpClient = CreateInstanceFromDll(EXE.PATH$ & "MSWINSCK.OCX", $CLSID_Winsock, $IID_IMSWinsockControl, $RTLKEY_Winsock)
         IF ISOBJECT(pTcpClient) THEN
            ' Connect to the events fired by the control
            pTcpClientEvents = CLASS "CDMSWinsockControlEvents"
            IF ISOBJECT(pTcpClientEvents) THEN EVENTS FROM pTcpClient CALL pTcpClientEvents
            ' Set the UDP protocol
            pTcpClient.Protocol = %sckTCPProtocol
            ' Set the remote host using the Local IP address
            pTcpClient.RemoteHost = pTcpClient.LocalIP '"192.168.1.66"
            ' Set the remote port
            pTcpClient.RemotePort = 999 '1001
         END IF

      CASE %WM_SIZE
         IF CB.WPARAM <> %SIZE_MINIMIZED THEN
            GetClientRect CB.HNDL, rc
            MoveWindow GetDlgItem(CB.HNDL, %IDC_INPUT), 10, 10, (rc.nRight - rc.nLeft) - 20, ((rc.nBottom - rc.nTop) \ 2) - 40, %TRUE
            MoveWindow GetDlgItem(CB.HNDL, %IDC_OUTPUT), 10, ((rc.nBottom - rc.nTop) \ 2) - 20, (rc.nRight - rc.nLeft) - 20, ((rc.nBottom - rc.nTop) \ 2) - 40, %TRUE
            MoveWindow GetDlgItem(CB.HNDL, %IDOK), (rc.nRight - rc.nLeft) - 185, (rc.nBottom - rc.nTop) - 35, 75, 23, %TRUE
            MoveWindow GetDlgItem(CB.HNDL, %IDCANCEL), (rc.nRight - rc.nLeft) - 95, (rc.nBottom - rc.nTop) - 35, 75, 23, %TRUE
         END IF

      CASE %WM_COMMAND
         SELECT CASE CB.CTL
            CASE %IDOK
               IF CB.CTLMSG = %BN_CLICKED THEN
                  ' Connect to the server
                  pTcpClient.Connect
               END IF
            CASE %IDCANCEL
               IF CB.CTLMSG = %BN_CLICKED THEN DIALOG END CB.HNDL, 0
            CASE %IDC_INPUT
               IF CB.CTLMSG = %EN_CHANGE THEN
                  ' Retrieve the text of the input window
                  CONTROL GET TEXT CB.HNDL, %IDC_INPUT TO strText
                  ' Send the text
                  IF pTcpClient.State = %sckConnected THEN
                     pTcpClient.SendData strText
                  END IF

               END IF
         END SELECT

      CASE %WM_DESTROY
         ' Close the connection
         IF pTcpClient.State <> %sckClosed THEN
            pTcpClient.Close
         END IF
         ' Disconnect events
         IF ISOBJECT(pTcpClientEvents) THEN EVENTS END pTcpClientEvents
         ' Release the control
         IF ISOBJECT(pTcpClient) THEN pTcpClient = NOTHING

   END SELECT

END FUNCTION
' ========================================================================================


' ########################################################################################
' Class CDMSWinsockControlEvents
' Interface name = DMSWinsockControlEvents
' IID = {248DD893-BB45-11CF-9ABC-0080C7E7B78D}
' Microsoft Winsock Control events
' Attributes = 4112 [&H1010] [Hidden] [Dispatchable]
' Code generated by the TypeLib Browser 4.0.13 (c) 2008 by Jos� Roca
' Date: 18 dic 2008   Time: 01:54:58
' ########################################################################################

'CLASS CDMSWinsockControlEvents GUID$("{5DBC24EC-EEEB-4F33-BBD9-D1BEFACA501D}") AS EVENT
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
     CONTROL SET TEXT  hDlg, %IDC_LABEL_StatusLine, "Error " & FORMAT$(prm_Scode) & " - " & ACODE$(prm_Description)
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD DataArrival <0> ( _
     BYVAL prm_bytesTotal AS LONG _                     ' bytesTotal VT_I4 <Long>
   )                                                    ' VOID

     ' *** Insert your code here ***
     ' Retrieve the text received and output it in the output window
      LOCAL vData AS VARIANT
      pTcpClient.GetData vData, 8   ' %vbString = 8
      temp = gDataBuffer
        DataQueue.enqueue temp

        IF (ghPDThread = 0) THEN
            tlStopReceive = 1 'Receive data and process
            THREAD CREATE ProcessDataThread(prm_bytesTotal) TO ghPDThread
        END IF
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD CONNECT <1>

     ' *** Insert your code here ***
       CONTROL SET TEXT hDlg, %IDC_LABEL_StatusLine, "Connected"
   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD ConnectionRequest <2> ( _
     BYVAL prm_requestID AS LONG _                      ' requestID VT_I4 <Long>
   )                                                    ' VOID

     ' *** Insert your code here ***

   END METHOD
   ' =====================================================================================

   ' =====================================================================================
   METHOD CLOSE <5>

     ' *** Insert your code here ***
     CONTROL SET TEXT hDlg, %IDC_LABEL_StatusLine, "Close"
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
'      pTcpClient.GetData vData, 8   ' %vbString = 8
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
'     ' *** Insert your code here ***
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
