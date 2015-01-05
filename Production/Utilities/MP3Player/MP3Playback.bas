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
'#RESOURCE "MP3Playback.pbr"
#RESOURCE ICON,     PROGICON, "MP3Player.ICO"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

#INCLUDE "MP3Class.inc"
#INCLUDE "mmfcomm.inc"

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1                  =  101
%IDC_BUTTON_GetMP3File        = 1001
%IDC_LABEL_MP3Filename        = 1002    '*
%IDC_BUTTON_Play              = 1003
%IDC_BUTTON_Pause             = 1004
%IDC_BUTTON_Stop              = 1005
%IDC_BUTTON_Resume            = 1006
%IDC_MSCTLS_TRACKBAR32_Volume = 1007
%IDC_LABEL1                   = 1008
%IDC_LABEL2                   = 1009
%IDC_TEXTBOX_Position         = 1010
%ID_TIMER                     = 1100
%ID_TIMER02                   = 1101
%IDC_LABEL_Status             = 1102
%IDC_LABEL3                   = 1104
%IDC_TEXTBOX_Length           = 1103
%IDC_LABEL4                   = 1105    '*
%IDC_LABEL5                   = 1106
%IDC_LABEL6                   = 1108
%IDC_LISTBOX_Playlist         = 1107
%IDC_BUTTON_AddSong           = 1109
%IDC_BUTTON_DeleteSong        = 1110
%IDC_BUTTON_SavePlaylist      = 1111
%IDC_BUTTONPlayall            = 1112
%IDC_BUTTON_Shuffle            = 1113
%IDC_BUTTON_LoadPlaylist      = 1114
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

ENUM PlayFlag
    PlaySingle = 1
    PlayAll = 2
    PlayShuffle = 3
END ENUM

GLOBAL hDlg, ghThread AS DWORD
GLOBAL gMp3Filename, gPlaylistFilename AS STRING
GLOBAL gRemoteTrialsFile AS STRING
GLOBAL gHndTrackbarVolume AS DWORD
GLOBAL gVolume AS LONG
GLOBAL mp3 AS MyMP3Interface
GLOBAL mmfchannel AS MMFChannelType
GLOBAL pauseStopFlag, gPlayFlag AS BYTE
GLOBAL gPosition, gLength, gPlayAllCnt, gEndFlag AS LONG
GLOBAL gPlaylistArray() AS INTEGER

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmd AS STRING
    LOCAL result, cmdCnt AS LONG

    LET mp3 = CLASS "MyMP3Class"
    pauseStopFlag = 0

    gPlaylistFilename = ""
    gMp3Filename = ""

    cmd = COMMAND$

    IF (TRIM$(cmd) <> "") THEN

        IF (INSTR(LCASE$(cmd), ".mp3") <> 0) THEN   'single mp3 file as command line argument
            gMp3Filename = cmd
        ELSEIF (INSTR(LCASE$(cmd), ".lst") <> 0) THEN 'playlist as command line argument
            gPlaylistFilename = cmd
        END IF
        'gRemoteTrialsFile = "I:\TrialInfo.txt"

        'create a memory-mapped file to
        'communicate between ThetaTrainer
        'and the MP3 Player
        CreateMMFChannel("COMMAND", mmfchannel)

        'THREAD CREATE WorkerThread(result) TO ghThread
    END IF

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    'LET mp3 = CLASS "MyMP3Class"

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL mciReturn, uLength AS DWORD
    LOCAL  errorString AS ASCIIZ * 128
    LOCAL temp, cmd, parm, vol, seekPos AS STRING
    LOCAL swSong, resp AS STRING
    LOCAL x, cnt, lVol, lSeekPos, cmdLen AS LONG
    LOCAL lSwSong AS LONG



    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            IF (TRIM$(gMp3Filename) <> "") THEN
                SetTimer hDlg, %ID_TIMER, 1, %NULL
                SetTimer hDlg, %ID_TIMER02, 1000, %NULL
            END IF



            gPlayAllCnt = 1


            gHndTrackbarVolume = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_Volume)
            SendMessage(gHndTrackbarVolume, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 1000))  'min. & max. positions
            SendMessage(gHndTrackbarVolume, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
            gVolume = 500
            SendMessage(gHndTrackbarVolume, %TBM_SETPOS, %TRUE, gVolume)
            IF (TRIM$(gMp3Filename) <> "") THEN
                CALL ButtonPlay()
            END IF
            IF (TRIM$(gPlaylistFilename) <> "") THEN
                SetTimer hDlg, %ID_TIMER, 15, %NULL
                SetTimer hDlg, %ID_TIMER02, 1000, %NULL

                'gPlayFlag = %PlayFlag.PlaySingle

                CALL ButtonLoadPlaylist()
'                gPlayFlag = %PlayFlag.PlayAll
'                gPlayAllCnt = 1
'
'                LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt
'
'                REDIM gPlaylistArray(cnt)
'
'                FOR x = 1 TO cnt
'                    gPlaylistArray(x) = x
'                NEXT x
'
'                CALL ButtonPlayall()
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
        CASE %WM_HSCROLL
            IF (gHndTrackbarVolume = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gVolume > (1)) THEN
                            gVolume -= 1
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gVolume < (1000)) THEN
                            gVolume += 1
                        END IF
                    CASE %SB_THUMBTRACK
                        gVolume = HIWRD(CB.WPARAM)
                        'gEMGPitchSens = HIWRD(CB.WPARAM)/10
                    '    gEMGPitchSens = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
                END SELECT
                mp3.AdjustMediaLeftVolume(gVolume)
                mp3.AdjustMediaRightVolume(gVolume)
            END IF
        CASE %WM_TIMER
            SELECT CASE LOWRD(CB.WPARAM)
                CASE %ID_TIMER
                    temp = ReadMMFChannel(mmfchannel)
                    'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Command: " + temp
                    cmd = LEFT$(UCASE$(TRIM$(temp)), 2)
                    'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Command: " + cmd
                    cmdLen = LEN(temp)
                    IF (cmdLen > 2) THEN
                        parm = MID$(TEMP, 3 TO cmdLen)
                        'CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Parm: " + parm
                    END IF


                    SELECT CASE cmd
                        CASE "VO"
                           vol = parm

                           lVol = VAL(vol)
                           gVolume = lVol
                           mp3.AdjustMediaMasterVolume(lVol)
                           SendMessage(gHndTrackbarVolume, %TBM_SETPOS, %TRUE, gVolume)
                           'writePositionSemaphore(gRemoteTrialsFile, position)
                           #DEBUG PRINT "lVol: " + STR$(lVol)
                         CASE "SE"
                             seekPos = parm
                             lSeekPos = VAL(seekPos)
                             mp3.StopMedia()
                             mp3.SeekMedia(lSeekPos)
                         CASE "PL"
                             IF (TRIM$(parm) <> "") THEN
                                 seekPos = parm
                                 lSeekPos = VAL(seekPos)
                                 mp3.StopMedia()
                                 mp3.SeekMedia(lSeekPos)
                             END IF
                             mp3.PlayMedia()
                             CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + gMp3Filename
                         CASE "SW"
                             swSong = parm
                             lSwSong = VAL(swSong)
                             LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Playlist, lSwSong TO  gMp3Filename
                             LISTBOX UNSELECT hDlg, %IDC_LISTBOX_Playlist ,0
                             LISTBOX SELECT hDlg, %IDC_LISTBOX_Playlist ,lSwSong
                             CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Switched to " + gMp3Filename
                             mp3.CloseMedia()
                             mp3.IntializeMedia(gMp3Filename)
                             mp3.OpenMedia()
                         CASE "QU"
                            'KillTimer hDlg, %ID_TIMER
                            'KillTimer hDlg, %ID_TIMER02
                            'DIALOG POST hDlg, %WM_CLOSE, 0, 0
                            DIALOG END hDlg, 0
                    END SELECT
                CASE %ID_TIMER02
                    IF (pauseStopFlag = 0) THEN
                        gPosition = mp3.GetMediaPosition()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Position, SecondsToHHMMSS(gPosition / 1000)
                        gLength = mp3.GetMediaLength()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Length, SecondsToHHMMSS(gLength / 1000)

                        SELECT CASE gPlayFlag
                            CASE %PlayFlag.PlaySingle
                                IF (gPosition = gLength AND gMp3Filename <> "") THEN
                                    CONTROL SET TEXT hDlg, %IDC_LABEL_Status, gMp3Filename  + " has ended."
                                    BEEP : BEEP : BEEP
                                    KillTimer hDlg, %ID_TIMER02
                                END IF
                            CASE %PlayFlag.PlayAll
                                IF (gPosition = gLength AND gMp3Filename <> "") THEN
                                    INCR gPlayAllCnt
                                    CALL ButtonPlayall()
                                END IF
                            CASE %PlayFlag.PlayShuffle
                                IF (gPosition = gLength AND gMp3Filename <> "") THEN
                                    INCR gPlayAllCnt
                                    CALL ButtonPlayall()
                                END IF


                        END SELECT
                    END IF
            END SELECT

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                ' /* Inserted by PB/Forms 07-24-2014 10:27:36
                CASE %IDC_BUTTON_Play
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        SetTimer hDlg, %ID_TIMER02, 1000, %NULL
                        CALL ButtonPlay()
                    END IF

                CASE %IDC_BUTTONPlayall
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        gPlayFlag = %PlayFlag.PlayAll
                        gPlayAllCnt = 1

                        SetTimer hDlg, %ID_TIMER02, 1000, %NULL

                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt

                        REDIM gPlaylistArray(cnt)

                        FOR x = 1 TO cnt
                            gPlaylistArray(x) = x
                        NEXT x

                        CALL ButtonPlayall()
                    END IF

                CASE %IDC_BUTTON_Shuffle
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        gPlayFlag = %PlayFlag.PlayShuffle

                        SetTimer hDlg, %ID_TIMER02, 1000, %NULL

                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt

                        REDIM gPlaylistArray(cnt)

                        FOR x = 1 TO cnt
                            gPlaylistArray(x) = x
                        NEXT x

                        FOR x = 1 TO 7
                            CALL shuffle(gPlaylistArray(0), cnt)
                        NEXT x

                        CALL ButtonPlayall()
                    END IF

                CASE %IDC_BUTTON_LoadPlaylist
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonLoadPlaylist()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 07-24-2014 10:00:47
                CASE %IDC_MSCTLS_TRACKBAR32_Volume

                CASE %IDC_LISTBOX_Playlist

                CASE %IDC_BUTTON_AddSong
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonAddSong()
                    END IF

                CASE %IDC_BUTTON_DeleteSong
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonDeleteSong()
                    END IF

                CASE %IDC_BUTTON_SavePlaylist
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonSavePlaylist()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 06-27-2014 08:03:15
                CASE %IDC_TEXTBOX_Length
                ' */

                ' /* Inserted by PB/Forms 06-24-2014 15:22:22
                'CASE %IDC_MSCTLS_TRACKBAR32_Volume

                CASE %IDC_TEXTBOX_Position
                ' */

                CASE %IDC_BUTTON_GetMP3File
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonGetMP3File()
                    END IF



                CASE %IDC_BUTTON_Pause
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       pauseStopFlag = 1
                       CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Pausing " + gMp3Filename
                       mp3.PauseMedia()
                    END IF

                CASE %IDC_BUTTON_Stop
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        gPlayAllCnt = 0
                        pauseStopFlag = 1
                        mp3.StopMedia()
                        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Stopping " + gMp3Filename
                        CONTROL DISABLE hDlg, %IDC_BUTTON_Resume

                    END IF

                CASE %IDC_BUTTON_Resume
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        pauseStopFlag = 0
                        mp3.ResumeMedia()
                    END IF


            END SELECT
    CASE %WM_DESTROY
        KillTimer hDlg, %ID_TIMER
        KillTimer hDlg, %ID_TIMER02
        mp3.CloseMedia()
        mp3 = NOTHING
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB ButtonGetMP3File()
    DISPLAY OPENFILE 0, , , "Get MP3 File", "", "*.mp3", _
                            "", "", 0 TO gMp3Filename

    IF (TRIM$(gMp3Filename) <> "") THEN
        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Loaded " + gMp3Filename
        pauseStopFlag = 1
    END IF

END SUB

SUB ButtonPlay()
    LOCAL x, cnt, selCnt, selState AS LONG

    gEndFlag = 0
    gPlayFlag = %PlayFlag.PlaySingle

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt

    IF (cnt = 0) THEN
        CALL InitializeMedia()
        mp3.PlayMedia()
        CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + gMp3Filename
        mp3.AdjustMediaMasterVolume(gVolume)
        pauseStopFlag = 0
        EXIT SUB
    END IF

   LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_Playlist TO selCnt
    FOR x = 1 TO cnt
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_Playlist, x TO selState
        IF (selState <> 0) THEN
            LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Playlist, x TO  gMp3Filename
            CALL InitializeMedia()
            mp3.PlayMedia()
            CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + gMp3Filename
            mp3.AdjustMediaMasterVolume(gVolume)
            pauseStopFlag = 0
            EXIT FOR
        END IF
    NEXT x
END SUB

SUB ButtonPlayall()
    LOCAL cnt AS LONG

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt
    IF (gPlayAllCnt > cnt) THEN
        gPlayFlag = %PlayFlag.PlaySingle
        EXIT SUB
    END IF

    pauseStopFlag = 0
    LISTBOX SELECT hDlg, %IDC_LISTBOX_Playlist, gPlaylistArray(gPlayAllCnt)
    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Playlist, gPlaylistArray(gPlayAllCnt) TO  gMp3Filename
    CALL InitializeMedia()
    mp3.PlayMedia()
    CONTROL SET TEXT hDlg, %IDC_LABEL_Status, "Playing " + gMp3Filename
    mp3.AdjustMediaMasterVolume(gVolume)
    pauseStopFlag = 0
END SUB

SUB ButtonShuffle()

END SUB

SUB InitializeMedia()
    mp3.CloseMedia()
    mp3.IntializeMedia(gMp3Filename)
    mp3.OpenMedia()
    gPosition = mp3.GetMediaPosition()
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Position, SecondsToHHMMSS(gPosition / 1000)
    gLength = mp3.GetMediaLength()
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Length, SecondsToHHMMSS(gLength / 1000)
    CONTROL REDRAW hDlg, %IDC_TEXTBOX_Length
END SUB

SUB ButtonAddSong()
    LISTBOX ADD hDlg, %IDC_LISTBOX_Playlist, gMP3Filename
END SUB

SUB ButtonDeleteSong()
    LOCAL x, cnt, selCnt, selState AS LONG

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt

    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_Playlist TO selCnt
    FOR x = 1 TO cnt
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_Playlist, x TO selState
        IF (selState <> 0) THEN
            LISTBOX DELETE hDlg, %IDC_LISTBOX_Playlist, x
        END IF
    NEXT x
END SUB

SUB ButtonLoadPlaylist()
    LOCAL x, cnt AS LONG
    LOCAL temp, filename AS STRING


    IF (gPlaylistFilename = "") THEN
        DISPLAY OPENFILE , , , "Load your playlist", "", CHR$("Playlist", 0, "*.lst", 0), _
                "", ".lst", %OFN_EXPLORER  TO filename
        pauseStopFlag = 1
    ELSE
        filename = gPlaylistFilename
        pauseStopFlag = 0
    END IF

    IF (TRIM$(filename) = "") THEN
        MSGBOX "No Playlist file name given."
        EXIT SUB
    ELSE
        gPlaylistFilename = filename
    END IF



    LISTBOX RESET hDlg, %IDC_LISTBOX_Playlist

    OPEN filename FOR INPUT AS #111
    WHILE ISFALSE EOF(111)  ' check if at end of file
       LINE INPUT #111, temp
       LISTBOX ADD hDlg, %IDC_LISTBOX_Playlist, temp
    WEND

    CLOSE #111

    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Playlist, 1 TO  gMp3Filename

END SUB

SUB ButtonSavePlaylist()
    LOCAL x, cnt AS LONG
    LOCAL temp, filename AS STRING

    DISPLAY SAVEFILE , , , "Save your playlist", "", CHR$("Playlist", 0, "*.lst", 0), _
            "", ".lst", %OFN_EXPLORER  TO filename

    IF (TRIM$(filename) = "") THEN
        MSGBOX "No Playlist file name given."
        EXIT SUB
    END IF

    OPEN filename FOR OUTPUT AS #111

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_Playlist TO cnt
    FOR x = 1 TO cnt
        LISTBOX GET TEXT hDlg, %IDC_LISTBOX_Playlist, x TO  temp
        PRINT #111, temp
    NEXT x

    CLOSE #111

END SUB

FUNCTION SecondsToHHMMSS(position AS LONG) AS STRING
    LOCAL seconds, minutes, hours AS LONG

    hours = INT(position / 3600)
    minutes = INT(position / 60)
    seconds = position MOD 60

    FUNCTION = FORMAT$(hours, "00") + ":" + FORMAT$(minutes, "00") + ":" + FORMAT$(seconds, "00")

END FUNCTION

SUB shuffle(BYREF arr AS INTEGER, BYREF numOfElems AS DWORD)
    LOCAL k, n, temp AS INTEGER
    DIM arr (numOfElems) AS INTEGER AT VARPTR(arr)

    n = numOfElems
    WHILE (n > 1)
      k = RND(0, n - 1)
      n = n - 1
      temp = arr(n)
      arr(n) = arr(k)
      arr(k) = temp
    WEND
END SUB



'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD

    DIALOG NEW hParent, "MP3 Player", 70, 70, 410, 265, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_GetMP3File, "Get MP3 file", 20, _
        10, 90, 25
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Play, "Play", 145, 10, 50, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Pause, "Pause", 200, 32, 50, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Stop, "Stop", 200, 10, 50, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Resume, "Resume", 200, 54, 50, 20
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, _
        "msctls_trackbar32_1", 265, 30, 120, 20, %WS_CHILD OR %WS_VISIBLE OR _
        %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_AddSong, "Add Song", 230, 115, 64, _
        20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_DeleteSong, "Delete Song", 230, _
        138, 65, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_SavePlaylist, "Save Playlist", _
        230, 184, 64, 20
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Volume", 265, 10, 65, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL2, "Position", 1, 230, 45, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_Position, "0", 46, 225, 80, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_RIGHT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_Status, "", 1, 250, 405, 15, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_LEFT OR %SS_SUNKEN, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_Length, "0", 231, 225, 80, 20, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_RIGHT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL3, "hh:mm:ss", 131, 230, 95, 15
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL5, "hh:mm:ss", 312, 230, 95, 15
    CONTROL ADD LISTBOX, hDlg, %IDC_LISTBOX_Playlist, , 16, 110, 205, 105, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %WS_TABSTOP OR %WS_HSCROLL _
        OR %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL6, "Playlist", 16, 95, 70, 15
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTONPlayall, "Play All", 145, 32, 50, _
        20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_Shuffle, "Shuffle", 145, 54, 50, 20
    CONTROL ADD BUTTON,  hDlg, %IDC_BUTTON_LoadPlaylist, "Load Playlist", _
        230, 161, 64, 20

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial Narrow", 10, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT hDlg, -1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_GetMP3File, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Play, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Pause, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Stop, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Resume, hFont1
    CONTROL SET FONT hDlg, %IDC_MSCTLS_TRACKBAR32_Volume, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_AddSong, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_DeleteSong, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_SavePlaylist, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont2
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Position, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_Status, hFont3
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Length, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont2
    CONTROL SET FONT hDlg, %IDC_LISTBOX_Playlist, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL6, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTONPlayall, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Shuffle, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadPlaylist, hFont1
#PBFORMS END DIALOG

    DIALOG SET ICON hDlg, "PROGICON"


    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------


'
'FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG
'    LOCAL temp, cmd, vol AS STRING
'    LOCAL lVol, position AS LONG
'    GLOBAL mp3 AS MyMP3Interface
'
'    mp3.IntializeMedia(mp3Filename)
'    mp3.OpenMedia()
'    mp3.PlayMedia()
'    mp3.AdjustMediaMasterVolume(250)
'    position = mp3.GetMediaPosition()
'
'    'create a memory-mapped file to
'    'communicate between ThetaTrainer
'    'and the program
'    CreateMMFChannel("COMMAND", mmfchannel)
'
'    WHILE (1)
'        temp = ""
'
'        OPEN "C:\DOPS_Experiments\ZZZFlashdrive\MP3VolControl.txt"  FOR INPUT ACCESS READ LOCK SHARED  AS #1
'        LINE INPUT #1, temp
'        IF (TRIM$(temp) = "-999") THEN
'            EXIT LOOP
'        ELSE
'            lVol = VAL(temp)
'            gVolume = lVol
'            mp3.AdjustMediaMasterVolume(lVol)
'            position = mp3.GetMediaPosition()
'            CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Position, STR$(position)
'            'writePositionSemaphore(gRemoteTrialsFile, position)
'            #DEBUG PRINT "lVol: " + STR$(lVol)
'            'PostMessage(gHndTrackbarVolume, %SB_LINELEFT, 0, 0)
'        END IF
'
'        SLEEP 100
'        CLOSE #1
'    WEND
'
'
'    CLOSE #1
'END FUNCTION
'
'THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG
'
' FUNCTION = WorkerFunc(x)
'
'END FUNCTION
'
'SUB writePositionSemaphore(filename AS STRING, position AS LONG)
'
'    '=====================================================================
'    'added 5/1/2014 per Ross Dunseath - we're writing the trial number
'    'to a network drive. A program on another machine will be checking
'    'this file to see the experiment progress.
'    '=====================================================================
'    OPEN filename FOR OUTPUT ACCESS WRITE LOCK SHARED  AS #100
'    PRINT #100, STR$(position)
'    CLOSE #100
'END SUB
