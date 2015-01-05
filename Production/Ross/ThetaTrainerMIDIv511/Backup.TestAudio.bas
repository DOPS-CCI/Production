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
#RESOURCE "TestAudio.pbr"
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
%IDC_LABEL1              = 1002
%IDC_SCROLLBAR_Frequency = 1001
%IDC_BUTTON_OnOff        = 1005
%IDC_LABEL_Frequency     = 1006
%IDC_LABEL3              = 1007
%IDC_SCROLLBAR_Volume    = 1008
%IDC_LABEL_Volume        = 1009
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

%FREQ_MIN        =    20
%FREQ_MAX        =  8000
%FREQ_STEP       =    1
%VOL_MIN        =    1
%VOL_MAX        =  65535
%VOL_STEP       =    100
%FREQ_INIT       =   221

%SAMPLE_RATE     = 22050   ' Possible values: 44100, 22050, 11025, 8000
%OUT_BUFFER_SIZE =   128   ' Size of buffers (if 16-bit, be sure that %OUT_BUFFER_SIZE/2 is an integer )
%NUM_BUF         =    48   ' Numbers of buffers
%BIT16           =     1   ' %BIT16 defined implies 16-bit, %BIT16 not defined implies 8-bit

$AppName = "PBSineWave"
GLOBAL PI AS DOUBLE

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

#IF %DEF(%BIT16)
    %BITS = 16
SUB FillBuffer(BYVAL pBuffer AS INTEGER PTR, BYVAL iFreq AS SINGLE)
    REGISTER i AS LONG
    STATIC fAngle AS DOUBLE

    FOR i = 0 TO %OUT_BUFFER_SIZE/2 - 1
        @pBuffer[i] = 30000 * SIN( fAngle )
        fAngle = fAngle + 2 * PI * iFreq / %SAMPLE_RATE
        IF fAngle > 2 * PI THEN
            fAngle = fAngle - 2 * PI
        END IF
    NEXT i
END SUB
#ELSE
    %BITS = 8
SUB FillBuffer(BYVAL pBuffer AS BYTE PTR, BYVAL iFreq AS SINGLE)

        REGISTER i AS LONG
        STATIC fAngle AS DOUBLE

        FOR i = 0 TO %OUT_BUFFER_SIZE-1
            @pBuffer[i] = 127 + 127 * SIN( fAngle )
            fAngle = fAngle + 2 * PI * iFreq / %SAMPLE_RATE
            IF fAngle > 2 * PI THEN
                fAngle = fAngle - 2 * PI
            END IF
        NEXT i

END SUB
#ENDIF

SUB FillWAVEFORMATEX(w AS WAVEFORMATEX, BYVAL nChannels AS INTEGER, BYVAL nSamplesPerSec AS LONG, BYVAL wBitsPerSample AS WORD)
    w.wFormatTag        = %WAVE_FORMAT_PCM
    w.nChannels         = nChannels
    w.nSamplesPerSec    = nSamplesPerSec
    w.nAvgBytesPerSec   = nSamplesPerSec * nChannels * wBitsPerSample / 8
    w.nBlockAlign       = nChannels * wBitsPerSample / 8
    w.wBitsPerSample    = wBitsPerSample
    w.cbSize            = 0
END SUB

SUB FillWaveHeader(w AS WAVEHDR, lpData AS DWORD, BYVAL dwBufferLength AS LONG, BYVAL dwLoops AS LONG)
    w.lpData           = lpData
    w.dwBufferLength   = dwBufferLength
    w.dwBytesRecorded  = 0
    w.dwUser           = 0
    w.dwFlags          = 0
    w.dwLoops          = dwLoops
    w.lpNext           = %NULL
    w.Reserved         = 0
END SUB
'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()

    STATIC bShutOff AS LONG, bClosing AS LONG
    STATIC hWaveOut AS LONG
    STATIC hwndScroll,vwndScroll AS LONG
    STATIC iFreq, iVol AS SINGLE
    DIM zBuffer(%NUM_BUF-1) AS STATIC ASCIIZ*(%OUT_BUFFER_SIZE+1)
    DIM WaveHeader(%NUM_BUF-1) AS STATIC WAVEHDR
    STATIC WvFormat AS WAVEFORMATEX

    LOCAL iDummy AS LONG
    LOCAL pWaveHdr AS WAVEHDR PTR
    LOCAL i, j AS LONG

    SELECT CASE CB.MSG
    CASE %WM_INITDIALOG
        SetWindowText CB.HNDL, $AppName
        CONTROL HANDLE CB.HNDL, %IDC_SCROLLBAR_Frequency TO hwndScroll
        CONTROL HANDLE CB.HNDL, %IDC_SCROLLBAR_Volume TO vwndScroll
        SetScrollRange hwndScroll, %SB_CTL, %FREQ_MIN*%FREQ_STEP, %FREQ_MAX*%FREQ_STEP, %FALSE
        SetScrollPos hwndScroll,   %SB_CTL, %FREQ_INIT*%FREQ_STEP, %TRUE
        CONTROL SET TEXT CB.HNDL, %IDC_LABEL_Frequency, FORMAT$(%FREQ_INIT)
        iFreq = %FREQ_INIT
        PI = 4 * ATN(1)
    CASE %WM_HSCROLL
        SELECT CASE LOWRD(CB.WPARAM)
        CASE %SB_LINELEFT   : iFreq = iFreq - 1 '2 ^ (-1 / 6 ) * iFreq  ' one tone
        CASE %SB_LINERIGHT  : iFreq = iFreq + 1 '2 ^ ( 1 / 6 ) * iFreq
        CASE %SB_PAGELEFT   : iFreq = iFreq / 2              ' octave
        CASE %SB_PAGERIGHT  : iFreq = iFreq * 2
        CASE %SB_THUMBTRACK : iFreq = HIWRD(CB.WPARAM)/%FREQ_STEP
        CASE %SB_TOP        : GetScrollRange hwndScroll, %SB_CTL, CLNG(iFreq*%FREQ_STEP), iDummy
        CASE %SB_BOTTOM     : GetScrollRange hwndScroll, %SB_CTL, CLNG(iFreq*%FREQ_STEP), iDummy
        END SELECT

        iFreq = MAX(%FREQ_MIN, MIN(%FREQ_MAX, iFreq))
        SetScrollPos hwndScroll, %SB_CTL, CLNG(iFreq * %FREQ_STEP), %TRUE
        CONTROL SET TEXT CB.HNDL, %IDC_LABEL_Frequency, FORMAT$(iFreq,"#.#")
    CASE %WM_VSCROLL
        SELECT CASE LOWRD(CB.WPARAM)
        CASE %SB_LINELEFT   : iVol = iVol + %VOL_STEP 'msgbox "Line left"  '2 ^ (-1 / 6 ) * iFreq  ' one tone
        CASE %SB_LINERIGHT  : iVol = iVol - %VOL_STEP 'MSGBOX "Line right" ' '2 ^ ( 1 / 6 ) * iFreq
        'CASE %SB_THUMBTRACK : iVol = HIWRD(CB.WPARAM) / %VOL_STEP
        END SELECT


        iVol = MAX(%VOL_MIN, MIN(%VOL_MAX, iVol))
        SetScrollPos vwndScroll, %SB_CTL, CLNG(iVol * %VOL_STEP), %TRUE
        CONTROL SET TEXT CB.HNDL, %IDC_LABEL_Volume, FORMAT$(iVol,"#.#")
        waveOutSetVolume hWaveOut, iVol
    CASE %WM_COMMAND
        SELECT CASE LOWRD(CB.WPARAM)
            CASE %IDC_BUTTON_OnOff
                ' If turning on the waveform, hWaveOut is NULL

                IF hWaveOut = %NULL THEN
                    ' Variable to indicate Off button pressed

                    bShutOff = %FALSE

                    ' Open waveform audio for output

                    FillWAVEFORMATEX WvFormat, 1, %SAMPLE_RATE, %BITS    ' 1=Mono

                    IF waveOutOpen(hWaveOut, %WAVE_MAPPER, WvFormat, CB.HNDL, 0, %CALLBACK_WINDOW) <> %MMSYSERR_NOERROR THEN
                        hWaveOut = %NULL
                        MessageBeep %MB_ICONEXCLAMATION
                        MSGBOX "Error opening waveform audio device!", %MB_ICONEXCLAMATION OR %MB_OK, $AppName
                        EXIT FUNCTION
                    END IF

                    ' Set up headers and prepare them

                    FOR i = 0 TO %NUM_BUF-1
                        CALL FillWAVEHeader (WaveHeader(i), VARPTR(zBuffer(i)), %OUT_BUFFER_SIZE, 1)
                        waveOutPrepareHeader hWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
                    NEXT i


                ' If turning off waveform, reset waveform audio
                ELSE

                    bShutOff = %TRUE
                    waveOutReset hWaveOut

                END IF
            CASE %IDCANCEL
                DIALOG SEND CB.HNDL, %WM_SYSCOMMAND, %SC_CLOSE, 0
        END SELECT
        ' Message generated from waveOutOpen call

    CASE %MM_WOM_OPEN
        CONTROL SET TEXT CB.HNDL, %IDC_BUTTON_OnOff, "Turn Off"

        ' Send buffers to output device

        FOR i = 0 TO %NUM_BUF-1
            FillBuffer VARPTR(zBuffer(i)), iFreq
            waveOutWrite hWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
        NEXT i

        ' Message generated when a buffer is finished

    CASE %MM_WOM_DONE
        IF bShutOff THEN
            waveOutClose hWaveOut
            EXIT FUNCTION
        END IF

        ' Fill and send out a new buffer

        pWaveHdr = CB.LPARAM
        FillBuffer @pWaveHdr.lpData, iFreq
        waveOutWrite hWaveOut, @pWaveHdr, SIZEOF(@pWaveHdr)

    CASE %MM_WOM_CLOSE
        FOR i = 0 TO %NUM_BUF-1
            waveOutUnprepareHeader hWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
        NEXT i

        hWaveOut = %NULL
        CONTROL SET TEXT CB.HNDL, %IDC_BUTTON_OnOff, "Turn On"

        IF bClosing THEN DIALOG END CB.HNDL

    CASE %WM_SYSCOMMAND
        IF CB.WPARAM = %SC_CLOSE THEN
            IF hWaveOut <> %NULL THEN
                bShutOff = %TRUE
                bClosing = %TRUE

                waveOutReset hWaveOut
            ELSE
                DIALOG END CB.HNDL
            END IF
        END IF

    END SELECT

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

    DIALOG NEW hParent, "Test Audio", 70, 70, 415, 117, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR %WS_MINIMIZEBOX OR _
        %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME _
        OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
        %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD SCROLLBAR, hDlg, %IDC_SCROLLBAR_Frequency, "", 115, 17, 275, _
        20
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL1, "Frequency", 15, 17, 85, 20
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_OnOff, "Turn On", 320, 75, 80, _
        25
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_Frequency, "", 15, 40, 90, 15
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL3, "Volume", 40, 60, 55, 20
    CONTROL ADD SCROLLBAR, hDlg, %IDC_SCROLLBAR_Volume, "", 115, 55, 25, 60, _
        %WS_CHILD OR %WS_VISIBLE OR %SBS_VERT
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_Volume, "", 20, 80, 90, 15

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_SCROLLBAR_Frequency, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_OnOff, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_Frequency, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_Volume, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
