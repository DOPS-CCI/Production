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
#RESOURCE "fEEGKappaClock.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES

#INCLUDE "ChannelInfo.INC"
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                =  101
%IDC_LABEL2                 = 1003
%IDC_BUTTON_Connect         = 1004
%IDC_LABEL_Clock            = 1001
%IDC_COMBOBOX_NbrOfChannels = 1002
%IDC_LABEL_Status           = 1005
%IDC_BUTTON_Start           = 1006
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL TCPSocket AS LONG
GLOBAL hDlg AS DWORD
GLOBAL gMillis, gSeconds, gMinutes, ghPDThread AS LONG
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
                ' /* Inserted by PB/Forms 08-27-2013 09:04:42
                CASE %IDC_BUTTON_Start
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                         'THREAD CREATE ProcessTCPIPThread(1) TO ghPDThread
                    END IF
                ' */

                CASE %IDC_COMBOBOX_NbrOfChannels

                CASE %IDC_BUTTON_Connect
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                        TCP OPEN PORT 9870 AT "10.10.11.11" AS TCPSocket TIMEOUT 30000
                        ' Could we connect to site?

                        IF ERR THEN
                            MSGBOX "Could not connect. Error: " + ERROR$
                            EXIT FUNCTION
                        END IF

                        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Connected."
                        CONTROL REDRAW hDlg, %IDC_LABEL_Status

                        THREAD CREATE ProcessTCPIPThread(1) TO ghPDThread
                    END IF
            END SELECT
            CASE %WM_DESTROY
                TCP CLOSE TCPSocket
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB processBuffer()
    LOCAL buffer, sNbrOfChannels AS STRING
    LOCAL nbrOfChannels, bufSize, nbrOfMillis, sampleCnt, y AS LONG


    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_NbrOfChannels TO sNbrOfChannels
    nbrOfChannels = VAL(sNbrOfChannels)
    bufSize = nbrOfChannels * 2 + 4
    nbrOfMillis = bufSize * 1000

    THREAD CREATE ProcessDataThread(1) TO ghPDThread
    sampleCnt = 0
    gMillis = 0
    'OPEN "c:\test_" + DATE$ + "_" + TIME$ FOR OUTPUT AS #1
    DO
        INCR sampleCnt
        TCP RECV TCPSocket, bufSize, buffer

        '#DEBUG PRINT buffer
        SELECT CASE nbrOfChannels
            CASE 1
                LOCAL ch01 AS Channel01

                 ch01.ChannelStr = buffer
                 FOR y = 1 TO nbrOfChannels
                     ch01.Channels(y) = SwapBytesWord(ch01.Channels(y))
                     '#DEBUG PRINT "Chan: " + STR$(y) + " " + STR$(ch01.Channels(y))
                 NEXT y
            CASE 2
                LOCAL ch02 AS Channel02

                 ch02.ChannelStr = buffer
                 FOR y = 1 TO nbrOfChannels
                     ch02.Channels(y) = SwapBytesWord(ch02.Channels(y))
                     'PRINT #1, "Chan: " + STR$(y) + " " + STR$(ch02.Channels(y))
                 NEXT y
        END SELECT


        IF (sampleCnt = 1000) THEN 'gives me a millisecond
            sampleCnt = 0
            INCR gSeconds
        END IF

        '#debug print str$(gMilliCnt)


    LOOP WHILE ISTRUE LEN(buffer) AND ISFALSE ERR
    CLOSE #1

END SUB

FUNCTION ProcessTCPIPWorkerFunc(BYVAL x AS LONG) AS LONG

    CALL processBuffer()
    'CALL calcTimeElapsed()

END FUNCTION



THREAD FUNCTION ProcessTCPIPThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessTCPIPWorkerFunc(x)

END FUNCTION

SUB calcTimeElapsed()
    IF (gSeconds > 59) THEN
        gSeconds = 0
        INCR gMinutes
    END IF
    SLEEP 0
    CONTROL SET TEXT hDlg, %IDC_LABEL_Clock, FORMAT$(gMinutes, "00") + ":" + FORMAT$(gSeconds, "00")
    CONTROL REDRAW hDlg, %IDC_LABEL_Clock
END SUB

FUNCTION ProcessDataWorkerFunc(BYVAL x AS LONG) AS LONG

WHILE(1)
    CALL calcTimeElapsed()
WEND
END FUNCTION



THREAD FUNCTION ProcessDataThread(BYVAL x AS LONG) AS LONG

 FUNCTION = ProcessDataWorkerFunc(x)

END FUNCTION

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    FOR i = 1 TO lCount
        COMBOBOX ADD hDlg, lID, USING$("##", i)
    NEXT i
    CONTROL SET TEXT hDlg, %IDC_COMBOBOX_NbrOfChannels, "1"
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
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, hParent, "fEEG Kappa Clock", 105, 114, 302, 236, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Clock, "00:00", 15, 80, 270, 123, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_NbrOfChannels, , 135, 0, 37, _
        171, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %CBS_DROPDOWN OR _
        %CBS_SORT OR %CBS_AUTOHSCROLL, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Nbr of Channels:", 0, 0, 135, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT, %WS_EX_RIGHT OR _
        %WS_EX_LTRREADING
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Connect, "Connect", 202, 0, 76, _
        32
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_Status, "", 0, 209, 296, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    'CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Start, "Start", 201, 37, 76, 32

    FONT NEW "Arial Narrow", 72, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_LABEL_Clock, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_NbrOfChannels, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Connect, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Start, hFont2
#PBFORMS END DIALOG

    SampleComboBox hDlg, %IDC_COMBOBOX_NbrOfChannels, 30

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
