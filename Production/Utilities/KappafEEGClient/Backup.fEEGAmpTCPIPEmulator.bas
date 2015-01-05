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
'#RESOURCE "fEEGAmpTCPIPEmulator.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE ONCE "Winuser.inc"

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
%IDC_BUTTON_ChannelFile     = 1007
%IDC_TEXTBOX_ChannelData    = 1008
%IDC_BUTTON_Transmit        = 1009
%IDC_LABEL4                 = 1010
%IDC_LABEL_StatusLine       = 1011
%IDC_BUTTON_Stop            = 1012
%IDC_BUTTON_Close           = 1013
%IDC_FRAME1                 = 1014
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL gCHNFilename AS STRING
GLOBAL gServer AS LONG

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
    STATIC hEcho AS DWORD
    LOCAL sBuffer AS STRING
    LOCAL sPacket AS STRING
    LOCAL sTemp AS STRING

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            gServer = FREEFILE
            CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ServerPort TO sTemp
            nPort = VAL(sTemp)

            TCP OPEN SERVER PORT nPort AS gServer TIMEOUT 5000

            IF ERR THEN
                sBuffer = "Couldn't create socket!"
            ELSE
                TCP NOTIFY gServer, ACCEPT TO CB.HNDL AS %TCP_ACCEPT
                sBuffer = "Connected to Port " + STR$(nPort)
            END IF

             CONTROL SET TEXT hDlg, %IDC_LABEL_StatusLine, sBuffer
            'LogEvent CB.HNDL, sBuffer
            hEcho = %INVALID_SOCKET
            FUNCTION = 1

        CASE %TCP_ACCEPT
            SELECT CASE LOWRD(CB.LPARAM)
                CASE %FD_ACCEPT
                    hEcho = FREEFILE
                    TCP ACCEPT gServer AS hEcho
                    TCP NOTIFY hEcho, RECV CLOSE TO CB.HNDL AS %TCP_ECHO
                END SELECT
            FUNCTION = 1
        CASE %TCP_ECHO
            SELECT CASE LOWRD(CB.LPARAM)
                CASE %FD_READ
                    IF hEcho <> %INVALID_SOCKET THEN
                        ' Perform a receive-loop until there is no data left (ie, the end of stream)
                        sBuffer = ""
                        sPacket = ""

                        DO
                          TCP RECV hEcho, 1024, sBuffer
                          sPacket = sPacket + sBuffer
                        LOOP UNTIL sBuffer = "" OR ISTRUE EOF(hEcho) OR ISTRUE ERR

                        ' Send it back!
                        'IF LEN(sBuffer) THEN TCP SEND hEcho, sPacket + " -> Received Ok!"

                        'LogEvent CB.HNDL, $DQ + sPacket + $DQ + " (" + FORMAT$(LEN(sPacket)) + " bytes)"
                    ELSE
                        'LogEvent CB.HNDL, "* FD_READ Error!"
                    END IF

                CASE %FD_CLOSE
                    TCP CLOSE hEcho
                    hEcho = %INVALID_SOCKET

            END SELECT
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
                CASE %IDC_TEXTBOX_ServerIP

                CASE %IDC_TEXTBOX_ServerPort

                CASE %IDC_COMBOBOX_NbrOfChannels

                CASE %IDC_BUTTON_ChannelFile
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Choose Channel Settings file", "", CHR$("CHN Files", 0, "*.CHN", 0), "", "CHN", %OFN_SHOWHELP   TO gCHNFilename
                        IF (gCHNFilename <> "") THEN
                            'LISTBOX RESET hDlg, %IDC_LISTBOX_AIB
                            'CALL AIBListBox(hDlg, %IDC_LISTBOX_AIB, 32)
                        END IF
                    END IF

                CASE %IDC_TEXTBOX_ChannelData

                CASE %IDC_BUTTON_Transmit
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LOCAL x AS LONG
                        LOCAL hThread AS DWORD

                        THREAD CREATE WorkerThread(x) TO hThread
                    END IF

                CASE %IDC_BUTTON_Stop
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%IDC_BUTTON_Stop=" + _
                            FORMAT$(%IDC_BUTTON_Stop), %MB_TASKMODAL
                    END IF

                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB processChannelFile()
    LOCAL inpBuf, char, sTemp AS STRING
    LOCAL lNbrOfChans AS LONG
    LOCAL fileNbr AS LONG

    fileNbr = FREEFILE

    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_NbrOfChannels TO sTemp
    lNbrOfChans = VAL(sTemp) * 2

    OPEN gCHNFilename FOR BINARY AS fileNbr
    'CLOSE #1
    #DEBUG PRINT "here"
    WHILE ISFALSE EOF(1)
        GET$ fileNbr, 1, char
        #DEBUG PRINT char
        'IF (char <> CHR$(0)) THEN
        '    GET$ fileNbr, lNbrOfChans, inpBuf
        '    GET$ fileNbr, 1, char
            CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelData, char
            CONTROL REDRAW hDlg, %IDC_TEXTBOX_ChannelData

            TCP SEND gServer, char

'            lLen = LEN(inpBuf)
'
'            cnt = 0
'            FOR x = 1 TO lLen STEP 2
'                iTemp = CVI(inpBuf, x)
'                'MSGBOX STR$(x) + ", " + STR$(iTemp)
'                iLo = LO(BYTE, iTemp)
'                iHi = HI(BYTE, iTemp)
'                iNew = MAK(INTEGER, iHi, iLo)
'                Channels(cnt) = iNew
'                cnt = cnt + 1
'            NEXT x
        'END IF
    WEND

    SEEK fileNbr, LOF(1)



    CLOSE fileNbr
END SUB

FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG

    processChannelFile()

END FUNCTION



THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG

 FUNCTION = WorkerFunc(x)

END FUNCTION



'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    FOR i = 1 TO lCount
        COMBOBOX ADD hDlg, lID, USING$("#", i)
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

    DIALOG NEW hParent, "fEEG Amp TCPIP Emulator (Transmitter)", 70, 70, 492, _
        227, TO hDlg
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Server IP:", 20, 15, 75, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ServerIP, "192.168.1.64", 95, _
        12, 120, 20
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Port:", 20, 35, 75, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ServerPort, "999", 95, 35, 60, _
        20
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_NbrOfChannels, , 329, 13, 80, _
        77, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %CBS_DROPDOWN, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Number of channels:", 230, 15, _
        95, 20, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ChannelFile, "Choose Channel " + _
        "File", 230, 40, 110, 20
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ChannelData, "", 5, 95, 400, _
        100, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_MULTILINE OR %ES_AUTOHSCROLL OR %ES_AUTOVSCROLL, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Transmit, "Transmit", 410, 100, _
        70, 25
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Transmitted Data", 7, 79, 130, _
        15
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_StatusLine, "", 5, 205, 480, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Stop, "Stop", 410, 130, 70, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Close, "Close", 410, 160, 70, 25
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "", 5, 0, 475, 75

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ServerIP, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ServerPort, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_NbrOfChannels, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_ChannelFile, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ChannelData, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Transmit, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_StatusLine, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Stop, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
#PBFORMS END DIALOG

    SampleComboBox hDlg, %IDC_COMBOBOX_NbrOfChannels, 34

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
