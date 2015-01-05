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
'#RESOURCE "TestMP3Player.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "mmfcomm.inc"

GLOBAL   mmfchannel AS MMFChannelType

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                =  101
%IDC_BUTTON_GetMP3Playlist  = 1001
%IDC_BUTTON_LaunchMP3Player = 1002
%IDC_LABEL1                 = 1003
%IDC_TEXTBOX1               = 1004
%IDC_BUTTON_SendCommand     = 1005
%IDC_LABEL_MP3Playlist      = 1006
%IDC_LABEL_LastCmd          = 1007
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL gPlaylist AS STRING

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
                CASE %IDC_BUTTON_GetMP3Playlist
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonLoadPlaylist()
                    END IF

                CASE %IDC_BUTTON_LaunchMP3Player
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonLaunchMP3Player()
                    END IF

                CASE %IDC_TEXTBOX1

                CASE %IDC_BUTTON_SendCommand
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonSendCommand()
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB ButtonLoadPlaylist()
    DISPLAY OPENFILE , , , "Load your playlist", "", CHR$("Playlist", 0, "*.lst", 0), _
                "", ".lst", %OFN_EXPLORER  TO gPlaylist

    IF (TRIM$(gPlaylist) = "") THEN
        MSGBOX "No Playlist file name given."
        EXIT SUB
    END IF

    CONTROL SET TEXT hDlg, %IDC_LABEL_MP3Playlist, gPlaylist
END SUB

SUB ButtonLaunchMP3Player()
    LOCAL pid AS DWORD

    IF (TRIM$(gPlaylist) = "") THEN
        MSGBOX "No Playlist file name given."
        EXIT SUB
    END IF

    pid??? = SHELL("MP3Playback.exe " + gPlaylist, 6)
END SUB

SUB ButtonSendCommand()
    LOCAL x, cnt AS LONG
    LOCAL cmd, resp AS STRING
    LOCAL cmds() AS STRING

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX1 TO cmd
    CONTROL SET TEXT hDlg, %IDC_LABEL_LastCmd, cmd


    cnt = PARSECOUNT(cmd, ",")

    IF (cnt = 0) THEN
        OpenMMFChannel("COMMAND", mmfchannel)
        WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
    ELSE
        REDIM cmds(1 TO cnt)
        PARSE cmd, cmds(), ","
        FOR x = 1 TO cnt
            'msgbox cmds(x)
            OpenMMFChannel("COMMAND", mmfchannel)
            WriteMMFChannel(mmfChannel, STRPTR(cmds(x)), LEN(cmds(x)))
            SLEEP 30
        NEXT x
    END IF

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX1, ""

END SUB
'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Test MP3 Player", 70, 70, 293, 143, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_GetMP3Playlist, "Get MP3 " + _
        "Playlist", 15, 3, 120, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_LaunchMP3Player, "Launch MP3 " + _
        "Player", 15, 45, 120, 25
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Command:", 15, 80, 60, 20
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX1, "", 75, 78, 105, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_SendCommand, "Send Command", 15, _
        105, 120, 25, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_DEFPUSHBUTTON OR %BS_PUSHBUTTON OR %BS_CENTER OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    DIALOG  SEND         hDlg, %DM_SETDEFID, %IDC_BUTTON_SendCommand, 0
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_MP3Playlist, "", 15, 30, 275, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_LastCmd, "", 185, 80, 100, 20

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_BUTTON_GetMP3Playlist, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_LaunchMP3Player, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_SendCommand, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_MP3Playlist, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_LastCmd, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
