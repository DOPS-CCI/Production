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
#RESOURCE "fEEGAmpTCPIPClient.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE ONCE "Winuser.inc"
#INCLUDE "MSWINSCK.INC"
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
%IDC_LABEL1                 = 1001
%IDC_TEXTBOX_ServerIP       = 1002
%IDC_LABEL2                 = 1003
%IDC_TEXTBOX_ServerPort     = 1004
%IDC_LABEL3                 = 1006
%IDC_COMBOBOX_NbrOfChannels = 1005
%IDC_TEXTBOX_ChannelData    = 1008
%IDC_LABEL4                 = 1010
%IDC_LABEL_StatusLine       = 1011
%IDC_BUTTON_Stop            = 1012
%IDC_BUTTON_Close           = 1013
%IDC_FRAME1                 = 1014
%IDC_BUTTON_Connect         = 1007
%IDC_BUTTON_Receive         = 1009
%IDC_LISTBOX_ReceivedData   = 1015
%IDC_LISTBOX_Channels       = 1016
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL gCHNFilename AS STRING
GLOBAL gSocket AS LONG
GLOBAL DataQueue AS IQUEUECOLLECTION
GLOBAL tlStopReceive AS LONG
GLOBAL pTcpClient AS IMSWinsockControl
GLOBAL gDataBuffer, gUnfinishedBuffer AS ASCIIZ *8192
GLOBAL ghPDThread AS DWORD

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
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    STATIC nPort AS LONG
    LOCAL sTemp AS STRING
    STATIC pTcpClientEvents AS DMSWinsockControlEventsImpl
    GLOBAL DataQueue AS IQUEUECOLLECTION


    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
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
            FUNCTION = 1

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
                ' /* Inserted by PB/Forms 08-01-2013 10:43:56
                CASE %IDC_LISTBOX_Channels
                ' */

                ' /* Inserted by PB/Forms 07-31-2013 11:04:05
                CASE %IDC_LISTBOX_ReceivedData
                ' */

                ' /* Inserted by PB/Forms 07-26-2013 09:58:56
                CASE %IDC_BUTTON_Connect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        ' Connect to the server
                        pTcpClient.Connect

                        gUnfinishedBuffer = ""
                        ghPDThread = 0

                        LET DataQueue = CLASS "QueueCollection"
                        DataQueue.clear


                        'connectToServer()
                    END IF

                CASE %IDC_BUTTON_Receive
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
'                        LOCAL x AS LONG
'                        LOCAL hIDThread, hPDThread AS DWORD
'
'                        THREAD CREATE IncomingDataThread(x) TO hIDThread
'
'                        sleep 1000
'
'                         tlStopReceive = 1 'Receive data and process
'                        THREAD CREATE ProcessDataThread(x) TO hPDThread



                    END IF
                ' */

                CASE %IDC_TEXTBOX_ServerIP

                CASE %IDC_TEXTBOX_ServerPort

                CASE %IDC_COMBOBOX_NbrOfChannels

                CASE %IDC_TEXTBOX_ChannelData

                CASE %IDC_BUTTON_Stop
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        tlStopReceive = 0 'STOP
                    END IF

                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg
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
'------------------------------------------------------------------------------

SUB processData()
    GLOBAL DataQueue AS IQUEUECOLLECTION
    LOCAL x, queueCount AS LONG
    LOCAL vBuffer AS VARIANT
    LOCAL sBuffer AS STRING


    sBuffer = ""
    WHILE(tlStopReceive)
        SLEEP 5
        queueCount = DataQueue.count
        FOR x = 1 TO queueCount
            vBuffer = DataQueue.dequeue
            sBuffer = VARIANT$(vBuffer)
            takeApartDataBuffer(sBuffer)
        NEXT x
        'SLEEP 5
    WEND
    MSGBOX "Processing data stopped."


      'msgbox "here"

END SUB

SUB takeApartDataBuffer(buf AS STRING)
    LOCAL hiBy, loBy AS BYTE
    LOCAL buffer, char, recBuffer, temp, chStr AS STRING                                                              ' VOID
    DIM arr(1000) AS ASCIIZ * 70
    LOCAL x, y, z, cnt, bufLen, startPos, endPos, nbrOfRecs, bytesLeft, lLen, selected AS LONG
    LOCAL nbrOfChannels, nbrOfBytes AS INTEGER
    LOCAL Itemp, iNew AS WORD
    'DIM  channels(1 TO 35) AS WORD


    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Channels TO cnt
    FOR x = 1 TO cnt
        LISTBOX GET SELECT hDlg, %IDC_LISTBOX_Channels, x TO selected
        IF (selected <> 0) THEN
            LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Channels, selected TO temp
            EXIT FOR
        END IF
    NEXT x
    nbrOfChannels = VAL(temp)
    nbrOfBytes = (VAL(temp) * 2) + 4

    buffer = gUnfinishedBuffer + buf

    bufLen = LEN(buffer)
    FOR x = 1 TO bufLen
        char = MID$(buffer, x, 1)
        IF (char <> " " OR char = CHR$(255)) THEN
            cnt = x
            EXIT FOR
        END IF
    NEXT x
    IF (cnt = 0) THEN
        EXIT SUB
    END IF
    buffer = RIGHT$(buffer, bufLen - cnt + 1)
    bufLen = LEN(buffer)

    nbrOfRecs = INT(bufLen / nbrOfBytes)
    bytesLeft = bufLen - (nbrOfRecs * nbrOfBytes)

    gUnfinishedBuffer = MID$(buffer, nbrOfRecs * nbrOfBytes TO nbrOfRecs * nbrOfBytes + bytesLeft)

    SELECT CASE nbrOfChannels
        CASE 1
            LOCAL ch01 AS Channel01

            PARSE buffer, arr(), "    "
            cnt = PARSECOUNT(buffer, "    ")
            FOR x = 0 TO cnt - 1
                ch01.ChannelStr = arr(x)
                FOR y = 1 TO nbrOfChannels
                    ch01.Channels(y) = SwapBytesWord(ch01.Channels(y))
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch01.Channels(y))
                    LISTBOX DELETE hDlg, %IDC_LISTBOX_ReceivedData, y
                    LISTBOX INSERT hDlg, %IDC_LISTBOX_ReceivedData, y, "Channel: " + STR$(y) + " = " + STR$(ch01.Channels(y))
                NEXT y
            NEXT x
        CASE 2
            LOCAL ch02 AS Channel02

            PARSE buffer, arr(), "    "
            cnt = PARSECOUNT(buffer, "    ")
            FOR x = 0 TO cnt - 1
                ch02.ChannelStr = arr(x)
                FOR y = 1 TO nbrOfChannels
                    ch02.Channels(y) = SwapBytesWord(ch02.Channels(y))
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch01.Channels(y))
                    LISTBOX DELETE hDlg, %IDC_LISTBOX_ReceivedData, y
                    LISTBOX INSERT hDlg, %IDC_LISTBOX_ReceivedData, y, "Channel: " + STR$(y) + " = " + STR$(ch02.Channels(y))
                NEXT y
            NEXT x
        CASE 32
            LOCAL ch32 AS Channel32

            PARSE buffer, arr(), "    "
            cnt = PARSECOUNT(buffer, "    ")
            FOR x = 0 TO cnt - 1
                ch32.ChannelStr = arr(x)
                FOR y = 1 TO nbrOfChannels
                    ch32.Channels(y) = SwapBytesWord(ch32.Channels(y))
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch32.Channels(y))
                    LISTBOX DELETE hDlg, %IDC_LISTBOX_ReceivedData, y
                    LISTBOX INSERT hDlg, %IDC_LISTBOX_ReceivedData, y, "Channel: " + STR$(y) + " = " + STR$(ch32.Channels(y))
                NEXT y
            NEXT x
        CASE 33
            LOCAL ch33 AS Channel33

            PARSE buffer, arr(), "    "
            cnt = PARSECOUNT(buffer, "    ")
            FOR x = 0 TO cnt - 1
                ch33.ChannelStr = arr(x)
                FOR y = 1 TO nbrOfChannels
                    ch33.Channels(y) = SwapBytesWord(ch33.Channels(y))
                    #DEBUG PRINT "Channel: " + STR$(y) + ", " + STR$(ch33.Channels(y))
                    LISTBOX DELETE hDlg, %IDC_LISTBOX_ReceivedData, y
                    LISTBOX INSERT hDlg, %IDC_LISTBOX_ReceivedData, y, "Channel: " + STR$(y) + " = " + STR$(ch33.Channels(y))
                NEXT y
            NEXT x
    END SELECT


    'gUnfinishedBuffer = arr(cnt)
END SUB



FUNCTION ProcessDataWorkerFunc(BYVAL x AS LONG) AS LONG

    processData()

END FUNCTION



THREAD FUNCTION ProcessDataThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessDataWorkerFunc(x)

END FUNCTION

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION ChannelsListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG

    CONTROL SEND hDlg, %IDC_LISTBOX_Channels, %CB_SETEXTENDEDUI, %TRUE, 0

    FOR i = 1 TO lCount
        LISTBOX ADD hDlg, %IDC_LISTBOX_Channels, USING$("#", i)
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, hParent, "fEEG Amp TCPIP Client (Receiver)", 105, 114, _
        738, 694, TO hDlg
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Server IP:", 16, 24, 76, 33, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ServerIP, "192.168.1.64", 92, 20, _
        180, 32
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "Port:", 46, 57, 46, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_ServerPort, "999", 92, 57, 90, 32
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "Number of channels:", 315, 15, _
        143, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Connect, "Connect", 510, 49, 165, _
        32
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL4, "Received Data", 10, 128, 196, 25
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_StatusLine, "", 8, 666, 720, 25, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Stop, "Stop", 615, 211, 105, 41
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Close, "Close", 615, 260, 105, 41
    CONTROL ADD FRAME,   hDlg, %IDC_FRAME1, "", 8, 0, 712, 122
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_ReceivedData, , 15, 154, 585, 504
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_Channels, , 315, 41, 120, 79, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ServerIP, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ServerPort, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Connect, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_StatusLine, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Stop, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
#PBFORMS END DIALOG

    ChannelsListBox hDlg, %IDC_LISTBOX_Channels, 34

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------



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
   )
    LOCAL vData AS VARIANT
    LOCAL temp AS STRING

    ' *** Insert your code here ***
    ' Retrieve the text received and output it in the output window


    pTcpClient.GetData vData, 8   ' %vbString = 8
    gDataBuffer =  VARIANT$(vData)
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

              