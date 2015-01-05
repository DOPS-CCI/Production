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

#RESOURCE BITMAP,   BITMAP_PROCEEDBIOSEMI , "Images\BIOSEMIPROCEED.bmp"

#RESOURCE ICON,     IDI_ICON1, "ThetaTrainer.ico"
#RESOURCE BITMAP,   BITMAP_HIGHLIGHT, "Images\highlight.bmp"
#RESOURCE BITMAP,   BITMAP_PROCEED, "Images\proceed.bmp"
#RESOURCE BITMAP,   BITMAP_WAIT, "Images\wait.bmp"
#RESOURCE BITMAP,   BITMAP_PDB, "Images\PD_black.bmp"
#RESOURCE BITMAP,   BITMAP_PDW, "Images\PD_white.bmp"
#RESOURCE BITMAP,   BITMAP_OKBUTTON, "Images\OKButton.bmp"
'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE "ThetaTrainer.pbr"
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
%IDD_DIALOG_Theta                 =  201    '*
%IDC_BUTTON_EEGSettings           = 1001
%IDC_BUTTON_Start                 = 1002
%IDC_BUTTON_OnOff                 = 1011
%IDC_SCROLLBAR_Frequency          = 1012
%IDC_SCROLLBAR_Volume             = 1013
%IDC_LABEL1                       = 1014
%IDC_LABEL2                       = 1017
%IDC_TEXTBOX_EMGChannel           = 1018    '*
%IDC_TEXTBOX_EEGChannel           = 1019    '*
%IDC_LABEL3                       = 1020    '*
%IDC_LABEL4                       = 1021    '*
%IDC_FRAME1                       = 1022
%IDC_FRAME2                       = 1023    '*
%IDC_FRAME3                       = 1024    '*
%IDC_LABEL5                       = 1025    '*
%IDC_LABEL6                       = 1026    '*
%IDC_TEXTBOX_MinFreq              = 1027    '*
%IDC_TEXTBOX_MaxFreq              = 1028    '*
%IDC_LABEL7                       = 1030    '*
%IDC_LABEL8                       = 1032    '*
%IDC_LABEL9                       = 1034    '*
%IDC_LABEL10                      = 1036    '*
%IDC_LABEL11                      = 1038    '*
%IDC_LABEL12                      = 1040    '*
%IDC_TEXTBOX_MinAmpl              = 1039    '*
%IDC_TEXTBOX_MaxAmpl              = 1037    '*
%IDC_MSCTLS_TRACKBAR32_EMGRMSTime = 1041
%IDC_LABEL13                      = 1042
%IDC_LABEL14                      = 1043
%IDC_LABEL15                      = 1044
%IDC_LABEL16                      = 1045
%IDC_LABEL17                      = 1047
%IDC_LABEL18                      = 1048
%IDC_MSCTLS_TRACKBAR32_EEGRMSTime = 1046
%IDC_LABEL19                      = 1050    '*
%IDC_LABEL20                      = 1052    '*
%IDC_LABEL_EMGRMSTime             = 1053
%IDC_LABEL_EEGRMSTime             = 1054
%IDC_LABEL21                      = 1055    '*
%IDC_TEXTBOX_InitialMinFreq       = 1051    '*
%IDC_TEXTBOX_InitialMaxFreq       = 1056    '*
%IDC_LABEL22                      = 1058    '*
%IDC_TEXTBOX_InitialMaxAmpl       = 1057    '*
%IDC_TEXTBOX_InitialMinAmpl       = 1049    '*
%IDC_LABEL23                      = 1059    '*
%IDC_LABEL24                      = 1060
%IDC_LABEL25                      = 1061    '*
%IDC_LABEL26                      = 1062
%IDC_MSCTLS_TRACKBAR32_PitchSens  = 1064
%IDC_TEXTBOX_PitchSensMin         = 1065
%IDC_TEXTBOX_PitchSensMax         = 1066
%IDC_MSCTLS_TRACKBAR32_PitchBase  = 1068
%IDC_TEXTBOX_PitchBaseMin         = 1069
%IDC_TEXTBOX_PitchBaseMax         = 1067
%IDC_TEXTBOX_VolSensMin           = 1077
%IDC_TEXTBOX_VolSensMax           = 1075
%IDC_MSCTLS_TRACKBAR32_VolSens    = 1076
%IDC_TEXTBOX_VolBaseMin           = 1073
%IDC_MSCTLS_TRACKBAR32_VolBase    = 1072
%IDC_TEXTBOX_VolBaseMax           = 1071
%IDC_LABEL_PitchSens              = 1063
%IDC_LABEL_PitchBase              = 1070
%IDC_LABEL_VolSens                = 1078
%IDC_LABEL_VolBase                = 1074
%IDC_LABEL27                      = 1081
%IDC_LABEL28                      = 1082
%IDC_TEXTBOX_EMGRMSMin            = 1080
%IDC_TEXTBOX_EMGRMSMax            = 1079
%IDC_LABEL29                      = 1084
%IDC_LABEL30                      = 1086
%IDC_TEXTBOX_EEGRMSMin            = 1085
%IDC_TEXTBOX_EEGRMSMax            = 1083
%IDC_TEXTBOX_ActualEMGRMS         = 1088
%IDC_TEXTBOX_ActualEEGRMS         = 1087
%IDC_LABEL31                      = 1089
%IDC_LABEL32                      = 1092
%IDC_TEXTBOX_FilteredEEG          = 1091
%IDC_TEXTBOX_FilteredEMG          = 1090
%IDC_LABEL33                      = 1094    '*
%IDC_TEXTBOX_Vol                  = 1095
%IDC_TEXTBOX_Pitch                = 1093
%IDC_TEXTBOX_EMGRemap             = 1096
%IDC_TEXTBOX_EEGRemap             = 1097
%IDC_COMBOBOX_GeneralMIDI         = 1098
%IDC_LABEL35                      = 1100
%IDC_TEXTBOX1                     = 1101    '*
%IDC_TEXTBOX2                     = 1102    '*
%IDC_TEXTBOX_SubjectID            = 1103
%IDC_FRAME4                       = 1104
%IDC_BUTTON_LongDesc              = 1105
%IDC_CHECKBOX_Default             = 1106
%IDC_BUTTON_End                   = 1107
%IDC_LABEL36                      = 1109
%IDC_TEXTBOX_EEGRMSThreshold      = 1108
%IDC_BUTTON_MP3File               = 1110
%IDC_LABEL_MP3File                = 1111
%IDC_LISTBOX1                     = 1112    '*
%IDC_LISTBOX_EEGChannel           = 1113
%IDC_BUTTON_Comments              = 1114
%IDC_LISTBOX_EMGChannel           = 1115
%IDD_DIALOG1                      =   -1
%IDC_LABEL_AlphaFilter            = 1117
%IDC_TEXTBOX_AlphaFilter          = 1116
%IDC_LABEL37                      = 1118
%IDC_LABEL38                      = 1119
%IDC_LABEL39                      = 1120
%IDC_LABEL40                      = 1121
%IDC_FRAME5                       = 1122
%IDC_OPTION_DefaultSound          = 1123
%IDC_OPTION_GeneralMIDI           = 1124
%IDC_OPTION_MP3File               = 1125
%IDC_LABEL_GeneralMIDI            = 1099
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------


%SAMPLE_RATE     = 22050   ' Possible values: 44100, 22050, 11025, 8000
%OUT_BUFFER_SIZE =   128   ' Size of buffers (if 16-bit, be sure that %OUT_BUFFER_SIZE/2 is an integer )
%NUM_BUF         =    48   ' Numbers of buffers
%BIT16           =     1   ' %BIT16 defined implies 16-bit, %BIT16 not defined implies 8-bit

GLOBAL PI AS DOUBLE
$AppName = "ThetaTrainer"

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

TYPE GlobalHandles
    DlgSubject AS DWORD
    DlgAgent AS DWORD
    DlgController AS DWORD
    DlgHelper AS DWORD
    DlgSubjectPhotoDiode AS DWORD
    DlgAgentPhotoDiode AS DWORD
END TYPE

TYPE GlobalVariables
    Target AS LONG
    NbrOfHits AS LONG
    RunCnt AS LONG
    TrialCnt AS LONG
    TrialCntTotal AS LONG
    SubjectID AS LONG
    NbrOfRuns AS LONG
    NbrOFTrials AS LONG
    TrialLength AS LONG
    DiodeDelay AS LONG
    BoardNum AS LONG
    DioCardPresent AS LONG
    GreyCode AS LONG
    DioIndex AS LONG
    TargetTime AS ASCIIZ * 19
    ElapsedTime AS ASCIIZ * 19
    hdl AS GlobalHandles
END TYPE

GLOBAL globals AS GlobalVariables

TYPE MIDIMessageParts
    NoteOn AS BYTE
    KeyNumber AS BYTE
    KeyVelocity AS BYTE
    unused AS BYTE
END TYPE

UNION MIDIMessage
    msgPart AS MIDIMessageParts
    message AS DWORD
END UNION



#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "DOPS_MMTimers.inc"
#INCLUDE "DOPS_TCPIP.inc"
#INCLUDE "DOPS_TCPIP_Local.inc"
#INCLUDE "CircularQueueClass.inc"
'#INCLUDE "DigitalFilters_NEW.inc"
#INCLUDE "FilterClass.inc"
#INCLUDE "MP3Class.inc"
#INCLUDE "BiosemiRecording.inc"
'#INCLUDE "SoundCheck.inc"
#INCLUDE "EvenOddRNGClass.inc"
#INCLUDE "mmfcomm.inc"

'GLOBAL gRunningRMSAVGQueue AS doubleQueueInfo
GLOBAL gRmsAvg AS DOUBLE
GLOBAL hDlg   AS DWORD
GLOBAL gHwndScroll,gVwndScroll, gEMGRMSTime, gEEGRMSTime AS LONG
GLOBAL gEMGPitchSens, gEMGPitchBase, gEEGVolSens, gEEGVolBase AS DOUBLE
GLOBAL gFreq, gVol AS SINGLE
GLOBAL gHndTrackbarEMGRMSTime, gHndTrackbarEEGRMSTime AS DWORD
GLOBAL gHndTrackbarEMGPitchSens, gHndTrackbarEMGPitchBase AS DWORD
GLOBAL gHndTrackbarEEGVolSens, gHndTrackbarEEGVolBase AS DWORD
GLOBAL gEMGPitchSensMin, gEMGPitchSensMax, gEMGPitchBaseMin, gEMGPitchBaseMax AS DOUBLE
GLOBAL gEEGVolSensMin, gEEGVolSensMax, gEEGVolBaseMin, gEEGVolBaseMax AS DOUBLE
GLOBAL gEmgRMSMin, gEmgRMSMax, gEegRMSMin, gEegRMSMax, gEEGNbrSelectedChannels, gEMGNbrSelectedChannels AS LONG
GLOBAL hwndButtonOnOff, gEventCnt AS LONG
GLOBAL ghWaveOut AS LONG
GLOBAL gGeneralMIDI AS WORD
GLOBAL ghMidiOut AS LONG
GLOBAL gFreqOld AS DOUBLE
GLOBAL gDefaultSound AS LONG
GLOBAL gFREQ_MIN,gFREQ_MAX, gFREQ_STEP, gVOL_MIN, gVOL_MAX, gVOL_STEP, gFREQ_INIT, gPITCH_BASE_START, gVOL_BASE_START AS LONG
GLOBAL gEEGRMSThreshold AS DOUBLE
GLOBAL gMp3Filename AS STRING
GLOBAL gMp3 AS MyMP3Interface
GLOBAL rngInt AS EvenOddRNGInterface
GLOBAL gStartFlag AS BYTE
GLOBAL mmfchannel AS MMFChannelType

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL hr AS DWORD
    LOCAL tempFilename  AS STRING
    LOCAL filename, temp AS ASCIIZ * 255
    LOCAL sResult AS ASCIIZ * 255
    GLOBAL gMp3 AS MyMP3Interface

    '************************************************
    'Read values from the INI file to initialize
    'experiment variables
    '************************************************

    'tempFilename = COMMAND$
    'IF (TRIM$(tempFilename) = "") THEN
    '    MSGBOX "Please use GenericRNG filename.ini to start the program."
    '    RETURN
    'END IF

    LET gTimers = CLASS "PowerCollection"

    '************************************************
    'Initialize Mersenne-twister
    '************************************************
    init_MT_by_array()

    EXPERIMENT.SessionDescription.INIFile = "ThetaTrainer.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile


    GetPrivateProfileString("Experiment Section", "Mode", "", EXPERIMENT.Misc.Mode, %MAXPPS_SIZE, filename)

    '************************************************
    'check the DIO card value - usually not set for
    'demo mode.
    '************************************************
    GetPrivateProfileString("Experiment Section", "DigitalIOCard", "", sResult, %MAXPPS_SIZE, filename)
    IF (LTRIM$(LCASE$(sResult)) = "yes" AND EXPERIMENT.Misc.Mode <> "demo") THEN
        globals.DioCardPresent = 1
    ELSE
        globals.DioCardPresent = 0
    END IF

    '************************************************
    'It will only configure and initialize if
    'globals.DioCardPresent = 1.
    '************************************************
    globals.BoardNum = ConfigurePorts(globals.DioCardPresent, 1, 1)

    CALL DioWriteInitialize(globals.DioCardPresent, globals.BoardNum)

    LET gMp3 = CLASS "MyMP3Class"

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP

    gMp3 = NOTHING
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



SUB LoadGeneralMIDI()
    LOCAL i AS LONG
    LOCAL temp, nbr, lab, first AS STRING

    'msgbox gAIBFilename
    OPEN "GeneralMidi.txt" FOR INPUT AS #1
    LINE INPUT #1, temp 'first line is header

    'REDIM aibLabels(32)
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        nbr  = PARSE$(temp, ",", 1)
        lab  = PARSE$(temp, ",", 2)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_GeneralMidi, lab + " = " + nbr
    WEND
    CLOSE #1

    COMBOBOX SELECT hDlg, %IDC_COMBOBOX_GeneralMidi, 1
END SUB

FUNCTION CommentsScreen() AS LONG
    LOCAL exitVar AS LONG
    LOCAL hdrFilename, iniFileName AS ASCIIZ *256
    LOCAL settings AS STRING
    LOCAL pid AS DWORD

    hdrFilename = EXPERIMENT.SessionDescription.DataDir + "\" + EXPERIMENT.SessionDescription.SubjectDir + "\" + EXPERIMENT.SessionDescription.HDRFile
    iniFilename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SaveThetaTrainerSettings()

    pid = SHELL("ModifyHeaderComment\ModifyHeaderComment.exe " + hdrFilename + " " + iniFilename, 1)
    'SHELL "ModifyHeaderComment\ModifyHeaderComment.exe " + hdrFilename + " " + iniFilename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION


SUB SaveThetaTrainerSettings()
    LOCAL x, itemState AS LONG
    LOCAL filename AS ASCIIZ *256
    LOCAL temp  AS ASCIIZ * 256
    LOCAL chan, settings AS STRING

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_GeneralMIDI TO temp
    WritePrivateProfileString( "Theta Settings", "MIDI Instrument", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_MP3File TO temp
    WritePrivateProfileString( "Theta Settings", "MP3 File", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSThreshold TO temp
    WritePrivateProfileString( "Theta Settings", "EEGRMSThreshold", temp, filename)

    temp = ""
    FOR x = 1 TO 32
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_EMGChannel, x TO itemState

        IF (itemState = -1) THEN 'selected
            LISTBOX GET TEXT hDlg,  %IDC_LISTBOX_EMGChannel, x  TO chan
            temp = temp + chan + ","
        END IF
    NEXT x
    WritePrivateProfileString( "Theta Settings", "EMGChannel", temp, filename)

    temp = ""
    FOR x = 1 TO 32
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_EEGChannel, x TO itemState

        IF (itemState = -1) THEN 'selected
            LISTBOX GET TEXT hDlg,  %IDC_LISTBOX_EEGChannel, x  TO chan
            temp = temp + chan + ","
        END IF
    NEXT x
    WritePrivateProfileString( "Theta Settings", "EEGChannel", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_EMGRMSTime TO temp
    WritePrivateProfileString( "Theta Settings", "EMGRMSTime", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_EEGRMSTime TO temp
    WritePrivateProfileString( "Theta Settings", "EEGRMSTime", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_PitchSens TO temp
    WritePrivateProfileString( "Theta Settings", "PitchSens", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_PitchBase TO temp
    WritePrivateProfileString( "Theta Settings", "PitchBase", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_VolSens TO temp
    WritePrivateProfileString( "Theta Settings", "VolSens", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_LABEL_VolBase TO temp
    WritePrivateProfileString( "Theta Settings", "VolBase", temp, filename)

    '=======================================================================
    'added 6/9/2014 per Ross Dunseath - wanted the RMS Min & Max for EEG
    'and EMG saved.
    '=======================================================================
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMin TO temp
    WritePrivateProfileString( "Theta Settings", "EEGRMSMin", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EEGRMSMax TO temp
    WritePrivateProfileString( "Theta Settings", "EEGRMSMax", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMin TO temp
    WritePrivateProfileString( "Theta Settings", "EMGRMSMin", temp, filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_EMGRMSMax TO temp
    WritePrivateProfileString( "Theta Settings", "EMGRMSMax", temp, filename)


END SUB

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL filename AS ASCIIZ * 255
    DIM zBuffer(%NUM_BUF-1) AS STATIC ASCIIZ*(%OUT_BUFFER_SIZE+1)
    DIM WaveHeader(%NUM_BUF-1) AS STATIC WAVEHDR
    LOCAL iDummy, lRange, lResult AS LONG
    LOCAL pWaveHdr AS WAVEHDR PTR
    LOCAL i, j, x, emgSelected, eegSelected AS LONG
    LOCAL temp AS ASCIIZ *256
    LOCAL dMin, dMax, dEEGRemap AS DOUBLE
    STATIC WvFormat AS WAVEFORMATEX
    GLOBAL gStartFlag AS BYTE
    STATIC bShutOff AS LONG, bClosing AS LONG
    GLOBAL hwndButtonOnOff AS LONG
    GLOBAL gHndTrackbarEMGRMSTime, gHndTrackbarEEGRMSTime AS DWORD
    GLOBAL ghWaveOut AS LONG



    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            CALL INITDIALOG(CB.HNDL)
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
            IF (gHndTrackbarEMGRMSTime = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_THUMBTRACK
                        gEMGRMSTime = HIWRD(CB.WPARAM)/1
                        CONTROL SET TEXT hDlg, %IDC_LABEL_EMGRMSTime, STR$(gEMGRMSTime) + " sec"
                END SELECT
            ELSEIF (gHndTrackbarEEGRMSTime = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_THUMBTRACK
                        gEEGRMSTime = HIWRD(CB.WPARAM)/1
                        CONTROL SET TEXT hDlg, %IDC_LABEL_EEGRMSTime, STR$(gEEGRMSTime) + " sec"
                END SELECT
            ELSEIF (gHndTrackbarEMGPitchSens = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gEMGPitchSens > (gEMGPitchSensMin)) THEN
                            gEMGPitchSens -= gEMGPitchSensMin
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gEMGPitchSens < (gEMGPitchSensMax)) THEN
                            gEMGPitchSens += gEMGPitchSensMin
                        END IF
                    CASE %SB_THUMBTRACK
                        'gEMGPitchSens = HIWRD(CB.WPARAM)/10
                        gEMGPitchSens = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
                END SELECT
                CONTROL SET TEXT hDlg, %IDC_LABEL_PitchSens, "Sensitivity " + FORMAT$(gEMGPitchSens, "00.0000")
            ELSEIF (gHndTrackbarEMGPitchBase = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gEMGPitchBase > (gEMGPitchBaseMin)) THEN
                            DECR gEMGPitchBase
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gEMGPitchBase < (gEMGPitchBaseMax)) THEN
                            INCR gEMGPitchBase
                        END IF
                    CASE %SB_THUMBTRACK
                        gEMGPitchBase = (HIWRD(CB.WPARAM)/1) '+ gEMGPitchBaseMin
                        'gEMGPitchBase = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEMGPitchBaseMin * 1.0, gEMGPitchBaseMax * 1.0, 1)
                END SELECT
                CONTROL SET TEXT hDlg, %IDC_LABEL_PitchBase, "Base " + FORMAT$(gEMGPitchBase, "0000")
            ELSEIF (gHndTrackbarEEGVolSens = CB.LPARAM) THEN
                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gEEGVolSens > gEEGVolSensMin) THEN
                            gEEGVolSens -= gEEGVolSensMin
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gEEGVolSens < gEEGVolSensMax) THEN
                            gEEGVolSens += gEEGVolSensMin
                        END IF
                    CASE %SB_THUMBTRACK
                        'gEEGVolSens = HIWRD(CB.WPARAM)/10
                        gEEGVolSens = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, gEEGVolSensMin)
                END SELECT
                CONTROL SET TEXT hDlg, %IDC_LABEL_VolSens, "Sensitivity " + FORMAT$(gEEGVolSens, "00.0000")
            ELSEIF (gHndTrackbarEEGVolBase = CB.LPARAM) THEN
                SELECT CASE LO(WORD, CB.WPARAM)
                    CASE %SB_LINELEFT
                        IF (gEEGVolBase > gEEGVolBaseMin) THEN
                            DECR gEEGVolBase
                        END IF
                    CASE %SB_LINERIGHT
                        IF (gEEGVolBase < gEEGVolBaseMax) THEN
                            INCR gEEGVolBase
                        END IF
                    CASE %SB_THUMBTRACK
                        gEEGVolBase = HI(WORD, CB.WPARAM) '+ gEEGVolBaseMin) * 10   '(HI(integer,CB.WPARAM)/1) + gEEGVolBaseMin
                        'gEEGVolBase = remapForTrackBarReverse(HIWRD(CB.WPARAM), gEEGVolBaseMin * 1.0, gEEGVolBaseMax * 1.0, 1)
                END SELECT
                CONTROL SET TEXT hDlg, %IDC_LABEL_VolBase, "Base " + FORMAT$(gEEGVolBase, "00000")
            ELSE

                SELECT CASE LOWRD(CB.WPARAM)
                    CASE %SB_LINELEFT   : gFreq = gFreq - 1 '2 ^ (-1 / 6 ) * iFreq  ' one tone
                    CASE %SB_LINERIGHT  : gFreq = gFreq + 1 '2 ^ ( 1 / 6 ) * iFreq
                    CASE %SB_PAGELEFT   : gFreq = gFreq / 2              ' octave
                    CASE %SB_PAGERIGHT  : gFreq = gFreq * 2
                    CASE %SB_THUMBTRACK : gFreq = HIWRD(CB.WPARAM)/gFREQ_STEP
                    CASE %SB_TOP        : GetScrollRange gHwndScroll, %SB_CTL, CLNG(gFreq * gFREQ_STEP), iDummy
                    CASE %SB_BOTTOM     : GetScrollRange gHwndScroll, %SB_CTL, CLNG(gFreq * gFREQ_STEP), iDummy
                END SELECT

                gFreq = MAX(gFREQ_MIN, MIN(gFREQ_MAX, gFreq))
                #DEBUG PRINT "iFreq: " + STR$(gFreq)
                SetScrollPos gHwndScroll, %SB_CTL, CLNG(gFreq * gFREQ_STEP), %TRUE
                'CONTROL SET TEXT CB.HNDL, %IDC_LABEL_Frequency, FORMAT$(iFreq,"#.#")
            END IF
        CASE %WM_VSCROLL
            SELECT CASE LOWRD(CB.WPARAM)
                CASE %SB_LINELEFT   : gVol = gVol + gVOL_STEP 'msgbox "Line left"  '2 ^ (-1 / 6 ) * iFreq  ' one tone
                CASE %SB_LINERIGHT  : gVol = gVol - gVOL_STEP 'MSGBOX "Line right" ' '2 ^ ( 1 / 6 ) * iFreq
                'CASE %SB_THUMBTRACK : iVol = HIWRD(CB.WPARAM) / %VOL_STEP
            END SELECT


            gVol = MAX(gVOL_MIN, MIN(gVOL_MAX, gVol))
            #DEBUG PRINT "iVol: " + STR$(gVol)
            SetScrollPos gVwndScroll, %SB_CTL, CLNG(gVol * gVOL_STEP), %TRUE
            'CONTROL SET TEXT CB.HNDL, %IDC_LABEL_Volume, FORMAT$(iVol,"#.#")
            'waveOutSetVolume ghWaveOut, gVol
            'CALL ChangeVolume()
        CASE %WM_COMMAND
            ' Process control notifications
             SELECT CASE LOWRD(CB.WPARAM)
                  CASE %IDC_OPTION_DefaultSound
                      CALL OptionDefaultSound()
                  CASE %IDC_OPTION_GeneralMIDI
                      CALL OptionGeneralMIDI()
                  CASE %IDC_OPTION_MP3File
                      CALL OptionMP3File()
                 CASE %IDC_LISTBOX_EMGChannel
                     IF CB.CTLMSG = %LBN_SELCHANGE THEN
                         CALL ListboxEMGChannelSELCHANGED()
                     END IF
                 CASE %IDC_LISTBOX_EEGChannel
                     IF CB.CTLMSG = %LBN_SELCHANGE THEN
                         CALL ListBoxEEGChannelSELCHANGED()
                     END IF
                CASE %IDC_BUTTON_OnOff
                    ' If turning on the waveform, hWaveOut is NULL

                    IF ghWaveOut = %NULL THEN
                        ' Variable to indicate Off button pressed

                        bShutOff = %FALSE

                        ' Open waveform audio for output

                        FillWAVEFORMATEX WvFormat, 1, %SAMPLE_RATE, %BITS    ' 1=Mono

                        IF waveOutOpen(ghWaveOut, %WAVE_MAPPER, WvFormat, CB.HNDL, 0, %CALLBACK_WINDOW) <> %MMSYSERR_NOERROR THEN
                            ghWaveOut = %NULL
                            MessageBeep %MB_ICONEXCLAMATION
                            MSGBOX "Error opening waveform audio device!", %MB_ICONEXCLAMATION OR %MB_OK, $AppName
                            EXIT FUNCTION
                        END IF

                        ' Set up headers and prepare them
                        IF (gDefaultSound = 1) THEN    'Default sound checked
                            FOR i = 0 TO %NUM_BUF-1
                                CALL FillWAVEHeader (WaveHeader(i), VARPTR(zBuffer(i)), %OUT_BUFFER_SIZE, 1)
                                waveOutPrepareHeader ghWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
                            NEXT i
                        END IF


                    ' If turning off waveform, reset waveform audio
                    ELSE

                        bShutOff = %TRUE
                        waveOutReset ghWaveOut

                    END IF
                CASE %IDCANCEL
                    DIALOG SEND CB.HNDL, %WM_SYSCOMMAND, %SC_CLOSE, 0

        ' Message generated from waveOutOpen call
                CASE %IDC_BUTTON_LongDesc
                    cbHelperScreenLongDesc()

                CASE %IDC_BUTTON_EEGSettings
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonEEGSettingsCLICKED()
                    END IF
                CASE %IDC_BUTTON_Start
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonStartCLICKED()
                    END IF

                CASE %IDC_BUTTON_End
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonEndCLICKED()
                    END IF


                CASE  %IDC_BUTTON_MP3File
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL ButtonMP3File_CLICKED()
                    END IF
                CASE %IDC_BUTTON_Comments
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CommentsScreen()
                    END IF
            END SELECT
    CASE %MM_WOM_OPEN
        CONTROL SET TEXT CB.HNDL, %IDC_BUTTON_OnOff, "Turn Off"

        ' Send buffers to output device

        FOR i = 0 TO %NUM_BUF-1
            FillBuffer VARPTR(zBuffer(i)), gFreq
            waveOutWrite ghWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
        NEXT i

        ' Message generated when a buffer is finished

    CASE %MM_WOM_DONE
        ' Fill and send out a new buffer

        pWaveHdr = CB.LPARAM
        FillBuffer @pWaveHdr.lpData, gFreq
        waveOutWrite ghWaveOut, @pWaveHdr, SIZEOF(@pWaveHdr)

    CASE %MM_WOM_CLOSE
        FOR i = 0 TO %NUM_BUF-1
            waveOutUnprepareHeader ghWaveOut, WaveHeader(i), SIZEOF(WaveHeader(i))
        NEXT i

        ghWaveOut = %NULL
        CONTROL SET TEXT CB.HNDL, %IDC_BUTTON_OnOff, "Turn On"

        IF bClosing THEN DIALOG END CB.HNDL

    CASE %WM_SYSCOMMAND
        IF CB.WPARAM = %SC_CLOSE THEN
            IF ghWaveOut <> %NULL THEN
                bShutOff = %TRUE
                bClosing = %TRUE

                waveOutReset ghWaveOut
            ELSE
                DIALOG END CB.HNDL
            END IF
        END IF
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB INITDIALOG(cbHnd AS DWORD)
    CONTROL HANDLE cbHnd, %IDC_BUTTON_OnOff TO hwndButtonOnOff
    CONTROL HANDLE cbHnd, %IDC_SCROLLBAR_Frequency TO gHwndScroll
    CONTROL HANDLE cbHnd, %IDC_SCROLLBAR_Volume TO gVwndScroll
    SetScrollRange gHwndScroll, %SB_CTL, gFREQ_MIN * gFREQ_STEP, gFREQ_MAX * gFREQ_STEP, %FALSE
    SetScrollPos gHwndScroll,   %SB_CTL, gFREQ_INIT  * gFREQ_STEP, %TRUE
    gFreq = gFREQ_INIT
    PI = 4 * ATN(1)

    CALL initialize()
END SUB

SUB OptionDefaultSound()
    CONTROL SET CHECK hDlg, %IDC_OPTION_DefaultSound, 1
    CONTROL SET CHECK hDlg, %IDC_OPTION_GeneralMIDI, 0
    CONTROL SET CHECK hDlg, %IDC_OPTION_MP3File, 0

    CONTROL HIDE hDlg, %IDC_LABEL_GeneralMIDI
    CONTROL HIDE hDlg, %IDC_COMBOBOX_GeneralMIDI
    CONTROL HIDE hDlg, %IDC_LABEL_MP3File
    CONTROL HIDE hDlg, %IDC_BUTTON_MP3File

    gDefaultSound = 1 'default sound

    gFREQ_MIN = 20
    gFREQ_MAX = 4000
    gFREQ_STEP = 1
    gVOL_MIN = 1
    gVOL_MAX = 65535
    gVOL_STEP = 100
    gFREQ_INIT = 221
    gPITCH_BASE_START = 640
    gVOL_BASE_START = 1

    gEMGRMSTime = 1
    gEEGRMSTime = 1
    gEMGPitchSens = 0.1 'remapForTrackBarReverse(1, gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
    gEMGPitchBase = 20 'gPITCH_BASE_START
    gEEGVolSens = .1 'remapForTrackBarReverse(1, gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, gEEGVolSensMin)
    gEEGVolBase = 1 'gVOL_BASE_START

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMin, STR$(gFREQ_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMax, STR$(gFREQ_MAX)

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMin, STR$(gVOL_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMax, STR$(gVOL_MAX)


END SUB

SUB OptionGeneralMIDI()
    CONTROL SET CHECK hDlg, %IDC_OPTION_DefaultSound, 0
    CONTROL SET CHECK hDlg, %IDC_OPTION_GeneralMIDI, 1
    CONTROL SET CHECK hDlg, %IDC_OPTION_MP3File, 0

    CONTROL NORMALIZE hDlg, %IDC_LABEL_GeneralMIDI
    CONTROL NORMALIZE hDlg, %IDC_COMBOBOX_GeneralMIDI
    CONTROL HIDE hDlg, %IDC_LABEL_MP3File
    CONTROL HIDE hDlg, %IDC_BUTTON_MP3File

    COMBOBOX SELECT hDlg, %IDC_COMBOBOX_GeneralMIDI, 2

    gDefaultSound = 2 'general midi

    gFREQ_MIN = 10
    gFREQ_MAX = 200
    gFREQ_STEP = 1
    gVOL_MIN = 1
    gVOL_MAX = 65535
    gVOL_STEP = 100
    gFREQ_INIT = 10
    gPITCH_BASE_START = 10
    gVOL_BASE_START = 1

    gEMGRMSTime = 1
    gEEGRMSTime = 1
    gEMGPitchSens = 0.1 'remapForTrackBarReverse(1, gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
    gEMGPitchBase = 20 'gPITCH_BASE_START
    gEEGVolSens = .1 'remapForTrackBarReverse(1, gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, gEEGVolSensMin)
    gEEGVolBase = 1 'gVOL_BASE_START

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMin, STR$(gFREQ_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMax, STR$(gFREQ_MAX)

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMin, STR$(gVOL_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMax, STR$(gVOL_MAX)

END SUB

SUB OptionMP3File()
    CONTROL SET CHECK hDlg, %IDC_OPTION_DefaultSound, 0
    CONTROL SET CHECK hDlg, %IDC_OPTION_GeneralMIDI, 0
    CONTROL SET CHECK hDlg, %IDC_OPTION_MP3File, 1

    CONTROL HIDE hDlg, %IDC_LABEL_GeneralMIDI
    CONTROL HIDE hDlg, %IDC_COMBOBOX_GeneralMIDI
    CONTROL NORMALIZE hDlg, %IDC_LABEL_MP3File
    CONTROL NORMALIZE hDlg, %IDC_BUTTON_MP3File

    gDefaultSound = 3 'mp3

    gFREQ_MIN = 10
    gFREQ_MAX = 200
    gFREQ_STEP = 1
    gVOL_MIN = 1
    gVOL_MAX = 1000
    gVOL_STEP = 10
    gFREQ_INIT = 10
    gPITCH_BASE_START = 10
    gVOL_BASE_START = 1

    gEMGRMSTime = 1
    gEEGRMSTime = 1
    gEMGPitchSens = 0.1 'remapForTrackBarReverse(1, gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, gEMGPitchSensMin)
    gEMGPitchBase = 20 'gPITCH_BASE_START
    gEEGVolSens = 0 'remapForTrackBarReverse(1, gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, gEEGVolSensMin)
    gEEGVolBase = 1 'gVOL_BASE_START
    gEMGPitchSensMin = 0
    gEMGPitchSensMax = 1
    gEEGVolSensMin = .01
    gEEGVolSensMax = 1

    'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchSensMin, str$(gEMGPitchSensMin)
    'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchSensMax, str$(gEMGPitchSensMax)

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolSensMin, STR$(gEEGVolSensMin)
    'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolSensMax, str$(gEEGVolSensMax)


    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMin, STR$(gFREQ_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMax, STR$(gFREQ_MAX)

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMin, STR$(gVOL_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMax, STR$(gVOL_MAX)


END SUB

SUB ListboxEMGChannelSELCHANGED()
    GLOBAL gStartFlag AS BYTE

     LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_EMGChannel TO gEMGNbrSelectedChannels

     INCR gStartFlag
     IF (gStartFlag = 2) THEN
         CONTROL ENABLE hDlg, %IDC_BUTTON_Start
     END IF
END SUB

SUB ListBoxEEGChannelSELCHANGED()
    GLOBAL gStartFlag AS BYTE

    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_EEGChannel TO gEEGNbrSelectedChannels
    INCR gStartFlag
    IF (gStartFlag = 2) THEN
        CONTROL ENABLE hDlg, %IDC_BUTTON_Start
    END IF
END SUB

FUNCTION copyConfigFileToBiosemi() AS LONG
    LOCAL flag AS LONG

    flag = -1
    'TRY
        'FILECOPY  "Generic.cfg", "\\DOPSBIOSEMI-PC\DOPS_Applications\Actiview605\Configuring\Generic.cfg"

         MSGBOX "\\DOPSBIOSEMI-PC\DOPS_Applications\Actiview605\Configuring\Generic.cfg has been modified."
    'CATCH
        MSGBOX "Error copy file to Biosemi: " + ERROR$
    '    flag = 0
    '    FUNCTION = flag
    'END TRY


    FUNCTION = flag
END FUNCTION

SUB ButtonEEGSettingsCLICKED()
    LOCAL x AS LONG
    LOCAL temp AS ASCIIZ *256

    CALL initialize()

    CALL cbHelperScreenEEGSettings()
    'CALL copyConfigFileToBiosemi()

    GetPrivateProfileString("Experiment Section", "ActiviewConfigUsed", "NO", temp, %MAXPPS_SIZE, EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)
    IF (UCASE$(temp) = "YES") THEN

        CALL loadTCPIPDefaults(EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)

        CALL enableScreen(1)

        COMBOBOX RESET hDlg, %IDC_LISTBOX_EMGChannel
        COMBOBOX RESET hDlg, %IDC_LISTBOX_EEGChannel

        FOR x = 1 TO TCPIPSettings.ChannelsToUse
            LISTBOX ADD hDlg, %IDC_LISTBOX_EMGChannel, TCPIPSettings.ChannelsToUseArray(x)
            LISTBOX ADD hDlg, %IDC_LISTBOX_EEGChannel, TCPIPSettings.ChannelsToUseArray(x)
        NEXT x
    ELSE
        MSGBOX "No Actiview Config file was saved. Cannot move on to next step."
    END IF
END SUB

SUB ButtonStartCLICKED()
    LOCAL lResult AS LONG
    LOCAL temp AS ASCIIZ *256
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD
    GLOBAL gMp3 AS MyMP3Interface

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_SubjectID TO temp
    lResult = WritePrivateProfileString( "Subject Section", "ID", temp, EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)
    globals.SubjectID = VAL(temp)

    IF (globals.SubjectID < 0 OR globals.SubjectID > 9999) THEN
        MSGBOX "Subject ID should be a number between 1 and 9999."
        EXIT SUB
    END IF

    IF (gDefaultSound = 3 AND TRIM$(gMp3Filename) = "") THEN
        MSGBOX "No MP3 file chosen."
        EXIT SUB
    END IF

    CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime
    CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime
    CONTROL DISABLE hDlg, %IDC_LISTBOX_EEGChannel
    CONTROL DISABLE hDlg, %IDC_LISTBOX_EMGChannel
    CONTROL DISABLE hDlg, %IDC_TEXTBOX_SubjectID
    CONTROL DISABLE hDlg, %IDC_BUTTON_EEGSettings
    CONTROL DISABLE hDlg, %IDC_BUTTON_LongDesc
    CONTROL DISABLE hDlg, %IDC_CHECKBOX_Default
    CONTROL DISABLE hDlg, %IDC_BUTTON_MP3File

    '==================================================================================
    'Added 7/15/2014 - if MP3 file is used - there is no need for pitch control
    '==================================================================================
    IF (gDefaultSound = 3) THEN
        CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_PitchSens
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchSensMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchSensMax
        CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_PitchBase
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchBaseMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchBaseMax
    END IF

    CALL StartModifyExpAndTech(EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile)

    CALL LoadINISettings()

    CALL initializeEventFile()

    '**********************************************************************************************
    'added 06/09/2014 per Ross Dunseath - wanted to have the ability of generating RNG and
    'alternate RNG files like those used in the Audio Paced Trials program.
    '**********************************************************************************************

    LET rngInt = CLASS "EvenOddRNGClass"

    rngInt.SetDuration(1000)
    rngInt.SetSampleSize(50)
    rngInt.SetINIFilename(EXPERIMENT.SessionDescription.INIFile)

    rngInt.StartHiddenRNGWindow()
     '**********************************************************************************************

    '======================================================
    'added 6/9/2014 - changed a MessageBox into a dialog
    ' that the user has to check off items.
    '======================================================
    CALL ShowDIALOGExptCheckList(0)


    '======================================================
    'added 6/9/2014 - changed a MessageBox into a dialog
    ' to allow a sound check.
    '======================================================
    'CALL ShowDIALOGSoundCheck(0)


    CALL StartupActiview()

    CustomMessageBox3(0, "DO NOT TOUCH BIOSEMI MOUSE!" + $CRLF + _
        "Click below when ready to start Biosemi recording.", "Start Biosemi Recording", 12)

    CALL StartBiosemiRecord()

    '======================================================
    'added 6/9/2014 - changed a MessageBox into a dialog
    ' to allow a method to sync video and BDF.
    '======================================================
    SLEEP 8000

    CALL ShowDIALOG_BiosemiRecording(0)


    CONTROL ENABLE hDlg, %IDC_BUTTON_End
    CONTROL ENABLE hDlg, %IDC_BUTTON_Comments
    CONTROL ENABLE hDlg, %IDC_BUTTON_End

    gEventCnt = 0
    '**********************************************************************************************
    'Start Experiment event
    '**********************************************************************************************
    LET MyTime = CLASS "PowerTime"
    MyTime.Now()
    MyTime.FileTime TO now
       'iVPos = 200
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(1).EvtName = "StartExperiment"
    EVENTSANDCONDITIONS(1).NbrOfGVars = 0
    EVENTSANDCONDITIONS(1).Index = globals.DioIndex
    EVENTSANDCONDITIONS(1).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(1).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(1).EventTime = PowerTimeDateTime(MyTime)
    EVENTSANDCONDITIONS(1).ElapsedMillis = gTimerTix
    CALL WriteToEventFile2(1)
    '**********************************************************************************************

    connectToServer(TCPIPSettings.IPAddress, TCPIPSettings.IPPort, TCPIPSettings.TCPIPSocket)

    processServerData(TCPIPSettings.TCPIPSocket)

    SELECT CASE gDefaultSound
        CASE 1 'default sound
            PostMessage(hwndButtonOnOff, %BM_CLICK, 0, 0)
        CASE 2 'midi chosen
            IF (NOT midiOutOpen(ghMidiOut, -1, 0, 0, 0))  THEN
                gFreq = 10
                CALL ChangeMIDIPitch()
                gVol = 65000
                CALL ChangeVolume()
            ELSE
                MSGBOX "MIDI not opened."
                'EXIT SUB
            END IF
        CASE 3 'mp3 chosen
            'gMp3.OpenMedia()
            'gMp3.PlayMedia()
            'gMp3.AdjustMediaMasterVolume(250)
            LOCAL pid AS DWORD
            pid??? = SHELL("H:\MP3Player\MP3Playback.exe " + gMp3Filename, 6)
    END SELECT
END SUB

SUB ButtonEndCLICKED()
    LOCAL cmd AS STRING
    GLOBAL gMp3 AS MyMP3Interface
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD

    '**********************************************************************************************
    'Adding a StartExperiment event and an EndExperiment event 6/19/2013 - FAA
    '**********************************************************************************************
    LET MyTime = CLASS "PowerTime"
    MyTime.Now()
    MyTime.FileTime TO now
       'iVPos = 200
    globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
    globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
    EVENTSANDCONDITIONS(2).EvtName = "EndExperiment"
    EVENTSANDCONDITIONS(2).NbrOfGVars = 0
    EVENTSANDCONDITIONS(2).Index = globals.DioIndex
    EVENTSANDCONDITIONS(2).GrayCode = globals.GreyCode
    EVENTSANDCONDITIONS(2).ClockTime = globals.TargetTime
    EVENTSANDCONDITIONS(2).EventTime = PowerTimeDateTime(MyTime)
    EVENTSANDCONDITIONS(2).ElapsedMillis = gTimerTix
    CALL WriteToEventFile2(2)
    '**********************************************************************************************

    CALL closeEventFile()

    'If there is an MP3 file chosen
     IF (gDefaultSound = 3) THEN    'Mp3 File
        'SHELL ("TaskKill /IM TestMP3Playback.exe /F", 0)
        cmd = "QU"
        'create a memory-mapped file to
        'communicate between ThetaTrainer
        'and the MP3 Player
        OpenMMFChannel("COMMAND", mmfchannel)
        WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
        'gMp3.StopMedia()
        'gMp3.CloseMedia()
        'gMp3 = nothing
    END IF

    CALL StartRenameAndMoveFiles()

    CALL ShutdownMacroExpress()
    DIALOG END hDlg, 1
END SUB

SUB ButtonMP3File_CLICKED()
    LOCAL filename, tempFilename, tempPath AS STRING

    DISPLAY OPENFILE 0, , , "Get MP3 File", "C:\DOPS_Experiments\AudioStimData", CHR$("MP3", 0, "*.MP3", 0), _
                            "", "MP3", 0 TO gMp3Filename

    '=======================================================================
    'added 7/15/2014 - if there spaces in the file name don't allow it.
    '=======================================================================
    tempPath = PATHNAME$(PATH,  gMp3Filename) ' returns  "C:\PB\"
    IF (INSTR(TRIM$(tempPath), " ") <> 0) THEN
        MSGBOX "Cannot have spaces in directory name."
        EXIT SUB
    END IF
    filename = PATHNAME$(NAMEX, gMp3Filename) ' returns  "XXX.TXT"
    IF (INSTR(TRIM$(filename), " ") <> 0) THEN
        tempFilename = REMOVE$(filename, " ")
        MSGBOX "Cannot have spaces in MP3 file name." + $CRLF + _
                "The file name will be stripped of its spaces and renamed to " + tempFilename
        tempPath = PATHNAME$(PATH,  gMp3Filename) ' returns  "C:\PB\"
        FILECOPY gMp3Filename, tempPath + tempFilename
        gMp3Filename = tempPath + tempFilename
        'EXIT SUB
    END IF
    'If there is an MP3 file chosen
    IF (TRIM$(gMp3Filename) <> "") THEN
        CONTROL SET TEXT hDlg, %IDC_LABEL_MP3File, PATHNAME$(NAMEX,  gMp3Filename)
        'LET gMp3 = CLASS "MyMP3Class"
        'gMp3.IntializeMedia(gMp3Filename)
    ELSE
        MSGBOX "No MP3 File chosen."
    END IF

END SUB

SUB initialize()
    LOCAL filename AS ASCIIZ * 255
    LOCAL temp AS ASCIIZ *256
    LOCAL dMin, dMax AS DOUBLE

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

      ' Initialization handler
    gHndTrackbarEMGRMSTime = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime)
    SendMessage(gHndTrackbarEMGRMSTime, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 10))  'min. & max. positions
    SendMessage(gHndTrackbarEMGRMSTime, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    SendMessage(gHndTrackbarEMGRMSTime, %TBM_SETSEL, %FALSE, MAK(LONG, 1, 10))
    SendMessage(gHndTrackbarEMGRMSTime, %TBM_SETPOS, %TRUE,  1)

      ' Initialization handler
    gHndTrackbarEEGRMSTime = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime)
    SendMessage(gHndTrackbarEEGRMSTime, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 10))  'min. & max. positions
    SendMessage(gHndTrackbarEEGRMSTime, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    SendMessage(gHndTrackbarEEGRMSTime, %TBM_SETSEL, %FALSE, MAK(LONG, 1, 10))
    SendMessage(gHndTrackbarEEGRMSTime, %TBM_SETPOS, %TRUE,  1)

      ' Initialization handler
    gHndTrackbarEMGPitchSens = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_PitchSens)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_PitchSensMin TO temp
    gEMGPitchSensMin = VAL(temp)
    'gEMGPitchSensMin = VAL(temp) * 10
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_PitchSensMax TO temp
    gEMGPitchSensMax = VAL(temp)
    'gEMGPitchSensMax = VAL(temp) * 10

    dMin = remapForTrackBar(gEMGPitchSensMin * 1.0, gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, 1)
    dMax = remapForTrackBar(gEMGPitchSensMax * 1.0, gEMGPitchSensMin * 1.0, gEMGPitchSensMax * 1.0, 1)


    'SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETRANGE,  %TRUE,  MAK(LONG, gEMGPitchSensMin, gEMGPitchSensMax))  'min. & max. positions
    SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETRANGE,  %TRUE,  MAK(LONG, dMin, dMax))  'min. & max. positions
    SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    'SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETSEL, %FALSE, MAK(LONG, gEMGPitchSensMin, gEMGPitchSensMax))
    SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETSEL, %FALSE, MAK(LONG, dMin, dMax))
    SendMessage(gHndTrackbarEMGPitchSens, %TBM_SETPOS, %TRUE,  1)

      ' Initialization handler
    gHndTrackbarEMGPitchBase = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_PitchBase)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMin TO temp
    gEMGPitchBaseMin = VAL(temp)
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMax TO temp
    gEMGPitchBaseMax = VAL(temp)

    'dMin = remapForTrackBar(gEMGPitchBaseMin * 1.0, gEMGPitchBaseMin * 1.0, gEMGPitchBaseMax * 1.0, 1)
    'dMax = remapForTrackBar(gEMGPitchBaseMax * 1.0, gEMGPitchBaseMin * 1.0, gEMGPitchBaseMax * 1.0, 1)

    SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, (gEMGPitchBaseMax - gEMGPitchBaseMin)))  'min. & max. positions
    'SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETRANGE,  %TRUE,  MAK(LONG, dMin, dMax))  'min. & max. positions
    SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, (gEMGPitchBaseMax - gEMGPitchBaseMin)))  'min. & max. positions
    SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETSEL, %FALSE, MAK(LONG, 1, (gEMGPitchBaseMax - gEMGPitchBaseMin)))
    'SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETSEL, %FALSE, MAK(LONG, dMin, dMax))
    SendMessage(gHndTrackbarEMGPitchBase, %TBM_SETPOS, %TRUE,  gPITCH_BASE_START)

      ' Initialization handler
    gHndTrackbarEEGVolSens = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_VolSens)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_VolSensMin TO temp
    'gEEGVolSensMin = VAL(temp) * 10
    gEEGVolSensMin = VAL(temp)
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_VolSensMax TO temp
    'gEEGVolSensMax = VAL(temp) * 10
    gEEGVolSensMax = VAL(temp)

    dMin = remapForTrackBar(gEEGVolSensMin * 1.0, gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, 1)
    dMax = remapForTrackBar(gEEGVolSensMax * 1.0, gEEGVolSensMin * 1.0, gEEGVolSensMax * 1.0, 1)

    'SendMessage(gHndTrackbarEEGVolSens, %TBM_SETRANGE,  %TRUE,  MAK(LONG, gEEGVolSensMin, gEEGVolSensMax))  'min. & max. positions
    SendMessage(gHndTrackbarEEGVolSens, %TBM_SETRANGE,  %TRUE,  MAK(LONG, dMin, dMax))  'min. & max. positions
    SendMessage(gHndTrackbarEEGVolSens, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    'SendMessage(gHndTrackbarEEGVolSens, %TBM_SETSEL, %FALSE, MAK(LONG, gEEGVolSensMin, gEEGVolSensMax))
    SendMessage(gHndTrackbarEEGVolSens, %TBM_SETSEL, %FALSE, MAK(LONG, dMin, dMax))
    SendMessage(gHndTrackbarEEGVolSens, %TBM_SETPOS, %TRUE,  1)

      ' Initialization handler
    gHndTrackbarEEGVolBase = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_VolBase)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_VolBaseMin TO temp
    'gEEGVolBaseMin = VAL(temp) / 10
    gEEGVolBaseMin = VAL(temp)
    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_VolBaseMax TO temp
    'gEEGVolBaseMax = VAL(temp) / 10
    gEEGVolBaseMax = VAL(temp)

    'dMin = remapForTrackBar(gEEGVolBaseMin * 1.0, gEEGVolBaseMin * 1.0, gEEGVolBaseMax * 1.0, 1)
    'dMax = remapForTrackBar(gEEGVolBaseMax * 1.0, gEEGVolBaseMin * 1.0, gEEGVolBaseMax * 1.0, 1)

    'SendMessage(gHndTrackbarEEGVolBase, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, (gEEGVolBaseMax - gEEGVolBaseMin  ))  'min. & max. positions
    'SendMessage(gHndTrackbarEEGVolBase, %TBM_SETRANGE,  %TRUE,  MAK(LONG, dMin, dMax))  'min. & max. positions
    SendMessage(gHndTrackbarEEGVolBase, %TBM_SETRANGEMIN,  %TRUE,  gEEGVolBaseMin)  'min. & max. positions
    SendMessage(gHndTrackbarEEGVolBase, %TBM_SETRANGEMAX,  %TRUE,  gEEGVolBaseMax)  'min. & max. positions
    SendMessage(gHndTrackbarEEGVolBase, %TBM_SETPAGESIZE,  0,  1)                  'NEW PAGE SIZE
    '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
    SendMessage(gHndTrackbarEEGVolBase, %TBM_SETSEL, %FALSE, MAK(LONG, 1, gEEGVolBaseMin ))
    'SendMessage(gHndTrackbarEEGVolBase, %TBM_SETSEL, %FALSE, MAK(LONG, dMin, dMax))
    SendMessage(gHndTrackbarEEGVolBase, %TBM_SETPOS, %TRUE,  gVOL_BASE_START)



    CONTROL SET TEXT hDlg, %IDC_LABEL_EMGRMSTime, STR$(gEMGRMSTime) + " sec"
    CONTROL SET TEXT hDlg, %IDC_LABEL_EEGRMSTime, STR$(gEEGRMSTime) + " sec"
    CONTROL SET TEXT hDlg, %IDC_LABEL_PitchSens, "Sensitivity " + FORMAT$(gEMGPitchSens, "00.0000")
    CONTROL SET TEXT hDlg, %IDC_LABEL_PitchBase, "Base " + FORMAT$(gEMGPitchBase, "0000")
    CONTROL SET TEXT hDlg, %IDC_LABEL_VolSens, "Sensitivity " + FORMAT$(gEEGVolSens, "00.0000")
    CONTROL SET TEXT hDlg, %IDC_LABEL_VolBase, "Base " + FORMAT$(gEEGVolBase, "00000")
END SUB

FUNCTION cbHelperScreenLongDesc() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "H:\ModifyLongDescription\ModifyLongDescription.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION

FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings3\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    IF (ERR <> 0) THEN
        MSGBOX "Error trying to open EEG screen: " + ERROR$
    ELSE
        BringWindowToTop globals.hdl.DlgHelper

    END IF

    FUNCTION = exitVar
END FUNCTION
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

    DIALOG NEW PIXELS, hParent, "Theta Trainer", 105, 116, 1014, 830, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR _
        %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT _
        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_SubjectID, "9999", 130, 32, _
        120, 32
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_LongDesc, "Long Description", _
        40, 80, 144, 32
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_EEGSettings, "EEG Settings", 40, _
        120, 144, 32
    ' %WS_GROUP...
    CONTROL ADD OPTION,    hDlg, %IDC_OPTION_DefaultSound, "Default Sound", _
        368, 56, 184, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR _
        %WS_TABSTOP OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR _
        %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,    hDlg, %IDC_OPTION_GeneralMIDI, "General MIDI", _
        368, 80, 184, 24
    CONTROL ADD OPTION,    hDlg, %IDC_OPTION_MP3File, "MP3 File", 368, 104, _
        184, 24
    CONTROL ADD COMBOBOX,  hDlg, %IDC_COMBOBOX_GeneralMIDI, , 720, 40, 232, _
        160, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %CBS_DROPDOWN OR %CBS_DISABLENOSCROLL, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_MP3File, "MP3 file to play", _
        608, 96, 144, 32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EEGRMSThreshold, "4.000", 503, _
        160, 89, 32
    CONTROL ADD LISTBOX,   hDlg, %IDC_LISTBOX_EMGChannel, , 152, 256, 144, _
        96, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %WS_TABSTOP OR _
        %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LISTBOX,   hDlg, %IDC_LISTBOX_EEGChannel, , 696, 248, 144, _
        96, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %WS_TABSTOP OR _
        %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EMGRMSMin, ".15", 117, 396, 56, _
        32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EMGRMSMax, "10", 279, 396, 56, _
        32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EEGRMSMin, ".3", 646, 396, 56, _
        32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EEGRMSMax, "15", 800, 396, 56, _
        32
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime, _
        "", 112, 490, 152, 32, %WS_CHILD OR %WS_VISIBLE OR %TBS_HORZ OR _
        %TBS_BOTTOM
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime, _
        "", 640, 490, 152, 32, %WS_CHILD OR %WS_VISIBLE OR %TBS_HORZ OR _
        %TBS_BOTTOM
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_PitchSensMin, ".1", 48, 636, _
        56, 32
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_PitchSens, _
        "msctls_trackbar32_1", 104, 636, 192, 32, %WS_CHILD OR %WS_VISIBLE _
        OR %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_PitchSensMax, "10", 296, 636, _
        56, 32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_PitchBaseMin, "10", 47, 715, _
        56, 32
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_PitchBase, _
        "msctls_trackbar32_1", 103, 715, 192, 32, %WS_CHILD OR %WS_VISIBLE _
        OR %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_PitchBaseMax, "200", 295, 715, _
        56, 32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_VolSensMin, ".1", 569, 633, 56, _
        32
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_VolSens, _
        "msctls_trackbar32_1", 625, 633, 192, 32, %WS_CHILD OR %WS_VISIBLE _
        OR %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_VolSensMax, "5", 817, 633, 63, _
        32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_VolBaseMin, "0", 568, 712, 56, _
        32
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_VolBase, _
        "msctls_trackbar32_1", 624, 712, 192, 32, %WS_CHILD OR %WS_VISIBLE _
        OR %TBS_HORZ OR %TBS_BOTTOM
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_VolBaseMax, "65535", 816, 712, _
        64, 32
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_Start, "Start", 360, 784, 127, _
        40
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_End, "End", 512, 784, 127, 40
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_OnOff, "Turn On", 1096, 8, 128, _
        41
    CONTROL ADD SCROLLBAR, hDlg, %IDC_SCROLLBAR_Frequency, "", 1128, 56, 60, _
        25
    CONTROL ADD SCROLLBAR, hDlg, %IDC_SCROLLBAR_Volume, "", 1144, 80, 23, 57, _
        %WS_CHILD OR %WS_VISIBLE OR %SBS_VERT
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL1, "EMG Channel:", 32, 258, 120, _
        32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL2, "EEG Channel:", 570, 250, 120, _
        32
    CONTROL ADD FRAME,     hDlg, %IDC_FRAME1, "Channels to be processed", 16, _
        232, 984, 528
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL13, "1", 72, 490, 40, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL14, "10", 264, 490, 40, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL15, "EMG RMS Time Constant", 72, _
        449, 232, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL16, "10", 792, 490, 40, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL17, "1", 592, 490, 40, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL18, "EEG RMS Time Constant", 592, _
        449, 232, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_EMGRMSTime, "1 sec", 304, 490, _
        104, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_EEGRMSTime, "1 sec", 832, 490, _
        104, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL24, "Pitch", 164, 548, 112, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL26, "Volume", 684, 550, 112, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_PitchSens, "Sensitivity", 48, _
        600, 184, 32
    CONTROL SET COLOR      hDlg, %IDC_LABEL_PitchSens, -1, RGB(255, 128, 128)
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_PitchBase, "Base", 47, 679, 184, _
        32
    CONTROL SET COLOR      hDlg, %IDC_LABEL_PitchBase, -1, RGB(255, 128, 128)
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_VolBase, "Base", 568, 676, 184, _
        32
    CONTROL SET COLOR      hDlg, %IDC_LABEL_VolBase, -1, RGB(128, 128, 255)
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_VolSens, "Sensitivity", 569, 597, _
        184, 32
    CONTROL SET COLOR      hDlg, %IDC_LABEL_VolSens, -1, RGB(128, 128, 255)
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL27, "RMS Min", 37, 396, 75, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL28, "RMS Max", 342, 396, 75, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL29, "RMS Max", 864, 396, 80, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL30, "RMS Min", 568, 396, 72, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_ActualEEGRMS, "", 714, 396, 73, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_ActualEMGRMS, "", 188, 396, 73, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL31, "Filtered EMG", 85, 360, 97, _
        32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_FilteredEMG, "", 188, 360, 73, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_FilteredEEG, "", 714, 360, 73, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL32, "Filtered EEG", 612, 360, 97, _
        32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_Pitch, "", 376, 712, 120, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_LEFT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_Vol, "", 888, 712, 104, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR %ES_LEFT _
        OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EMGRemap, "", 376, 636, 120, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_EEGRemap, "", 888, 634, 104, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_GeneralMIDI, "General MIDI:", _
        612, 40, 100, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT _
        OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL35, "Subject ID:", 26, 35, 97, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,     hDlg, %IDC_FRAME4, "Experiment Paremeters", 16, 5, _
        976, 195
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL36, "EEG RMS Threshold:", 330, _
        164, 168, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_MP3File, "", 608, 128, 376, 56
    CONTROL ADD BUTTON,    hDlg, %IDC_BUTTON_Comments, "Comments", 40, 160, _
        144, 32
    CONTROL ADD TEXTBOX,   hDlg, %IDC_TEXTBOX_AlphaFilter, "", 888, 360, 97, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL_AlphaFilter, "Alpha", 810, 360, _
        70, 32, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL37, "Volume", 888, 680, 97, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL38, "Remap Volume", 880, 600, 112, _
        32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL39, "Pitch", 376, 680, 97, 32
    CONTROL ADD LABEL,     hDlg, %IDC_LABEL40, "Remap Pitch", 376, 600, 136, _
        32
    CONTROL ADD FRAME,     hDlg, %IDC_FRAME5, "Choose Sound Output", 336, 24, _
        248, 112

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial", 16, 1, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT hDlg, %IDC_TEXTBOX_SubjectID, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_LongDesc, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EEGSettings, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_DefaultSound, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_GeneralMIDI, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_MP3File, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_GeneralMIDI, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_MP3File, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EEGRMSThreshold, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_EMGChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_EEGChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EMGRMSMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EMGRMSMax, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EEGRMSMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EEGRMSMax, hFont1
    CONTROL SET FONT hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime, hFont2
    CONTROL SET FONT hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime, hFont2
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_PitchSensMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_PitchSensMax, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_PitchBaseMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_PitchBaseMax, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_VolSensMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_VolSensMax, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_VolBaseMin, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_VolBaseMax, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Start, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_End, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_OnOff, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont2
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL13, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL14, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL15, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL16, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL17, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL18, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_EMGRMSTime, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_EEGRMSTime, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL24, hFont3
    CONTROL SET FONT hDlg, %IDC_LABEL26, hFont3
    CONTROL SET FONT hDlg, %IDC_LABEL_PitchSens, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_PitchBase, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_VolBase, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_VolSens, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL27, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL28, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL29, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL30, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ActualEEGRMS, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ActualEMGRMS, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL31, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_FilteredEMG, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_FilteredEEG, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL32, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Pitch, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_Vol, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EMGRemap, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_EEGRemap, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_GeneralMIDI, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL35, hFont2
    CONTROL SET FONT hDlg, %IDC_FRAME4, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL36, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL_MP3File, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Comments, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_AlphaFilter, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_AlphaFilter, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL37, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL38, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL39, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL40, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME5, hFont1
#PBFORMS END DIALOG

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMin, STR$(gFREQ_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_PitchBaseMax, STR$(gFREQ_MAX)

    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMin, STR$(gVOL_MIN)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_VolBaseMax, STR$(gVOL_MAX)

    CONTROL DISABLE hDlg, %IDC_BUTTON_End

    CALL OptionGeneralMIDI()


    CALL enableScreen(0)

    CALL LoadGeneralMIDI()


    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

SUB enableScreen(flag AS BYTE)
    IF (flag = 1) THEN
        CONTROL ENABLE hDlg, %IDC_LISTBOX_EMGChannel
        CONTROL ENABLE hDlg, %IDC_LISTBOX_EEGChannel
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_EMGRMSMin
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_EMGRMSMax
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_EEGRMSMin
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_EEGRMSMax
        CONTROL ENABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime
        CONTROL ENABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime
        CONTROL ENABLE hDlg, %IDC_BUTTON_OnOff
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_PitchSensMin
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_PitchSensMax
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_PitchBaseMax
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_PitchBaseMin
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_VolBaseMax
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_VolBaseMin
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_VolSensMax
        CONTROL ENABLE hDlg, %IDC_TEXTBOX_VolSensMin
    ELSE
        CONTROL DISABLE hDlg, %IDC_LISTBOX_EMGChannel
        CONTROL DISABLE hDlg, %IDC_LISTBOX_EEGChannel
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_EMGRMSMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_EMGRMSMax
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_EEGRMSMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_EEGRMSMax
        CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EMGRMSTime
        CONTROL DISABLE hDlg, %IDC_MSCTLS_TRACKBAR32_EEGRMSTime
        CONTROL DISABLE hDlg, %IDC_BUTTON_OnOff
        CONTROL DISABLE hDlg, %IDC_BUTTON_Start
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchSensMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchSensMax
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchBaseMax
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_PitchBaseMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_VolBaseMax
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_VolBaseMin
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_VolSensMax
        CONTROL DISABLE hDlg, %IDC_TEXTBOX_VolSensMin
        CONTROL DISABLE hDlg, %IDC_BUTTON_Comments
    END IF
END SUB

SUB DoWorkForEachTick()
END SUB

SUB DoTimerWork(itemName AS WSTRING)
'    LOCAL lResult, rndJitter, subPtr AS LONG
'    LOCAL x AS LONG
'
'    SELECT CASE itemName
'        CASE "GETRMSVALUE"
'            CALL DoRMSCalculations()
'            '#DEBUG PRINT "GETRMSVALUE: "
'            'SetMMTimerDuration("GETRMSVALUE", 5000)
'            'SetMMTimerOnOff("GETRMSVALUE", 1)    'turn on
'        CASE "ENDINTENTION"
'            'msgbox "here"
'            'CALL StartTrial()
'            'CALL EndTrial()
'            'SetMMTimerDuration("ENDINTENTION", globals.TrialLength)
'            'SetMMTimerOnOff("ENDINTENTION", 1)    'turn on
'            'SetMMTimerOnOff("SUBJECTDIODE", 1)    'turn on
'
'            'msgbox "here 2"
'
'        CASE "SUBJECTDIODE"
'            'CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_LABEL_TARGET, ""
'            'PhotoDiodeOnOff(globals.hdl.DlgSubjectPhotoDiode,  0)
'    END SELECT
END SUB

SUB UseTCPIPBuffer()
    'do the work for each sample here.
'    LOCAL x AS LONG
'    SLEEP 0
'    FOR x = 1 TO TCPIPSettings.ChannelsUsed
'        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_Chan01 + (x - 1), STR$(TCPIPBuffer.SampleArray(x))
'    NEXT x
END SUB

SUB ChangeVolume()
    GLOBAL ghWaveOut AS LONG
    GLOBAL gVol AS SINGLE
    GLOBAL gMp3 AS MyMP3Interface
    LOCAL lVol AS LONG
    LOCAL cmd AS STRING

    #DEBUG PRINT "gVol: " + STR$(gVol)

    SELECT CASE gDefaultSound
        CASE 1, 2
            #DEBUG PRINT "1,2: "
            waveOutSetVolume ghWaveOut, MAK(DWORD, LO(WORD, gVol), HI(WORD, gVol))
        CASE 3 'MP3
            #DEBUG PRINT "3: "
            lVol = gVol
            'gMp3.AdjustMediaMasterVolume(lVol)
            'gMp3.AdjustMediaRightVolume(lVol)
            'gMp3.AdjustMediaLeftVolume(lVol)
            cmd = "VO" + STR$(lVol)
            'create a memory-mapped file to
            'communicate between ThetaTrainer
            'and the MP3 Player
            OpenMMFChannel("COMMAND", mmfchannel)
            WriteMMFChannel(mmfChannel, STRPTR(cmd), LEN(cmd))
            'writeVolumeSemaphore("C:\DOPS_Experiments\ZZZFlashdrive\MP3VolControl.txt", lVol)

    END SELECT
END SUB

'SUB writeVolumeSemaphore(filename AS STRING, vol AS LONG)
'        OPEN filename FOR OUTPUT ACCESS WRITE LOCK SHARED  AS #100
'        PRINT #100, STR$(vol)
'        CLOSE #100
'END SUB


SUB ChangeMIDIPitch()
    LOCAL note AS MIDIMessage
    LOCAL temp AS STRING
    LOCAL lResult AS LONG
    STATIC dFreq, freq AS DOUBLE
    GLOBAL gFreq AS SINGLE
    GLOBAL gGeneralMIDI AS WORD
    GLOBAL  ghMidiOut AS LONG
    GLOBAL gFreqOld AS DOUBLE

    note.msgPart.NoteOn = 128
    note.msgPart.KeyNumber = gFreqOld
    note.msgPart.KeyVelocity = 100
    note.msgPart.unused = 0



        'midiOutShortMsg(hMidiOut, NoteC)
    midiOutShortMsg(ghMidiOut, note.message)

    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_GeneralMidi TO temp

    gGeneralMIDI = VAL(PARSE$(temp, "=", 2))

    'If there is no MIDI instrument chosen
    'then don't try to change the pitch
    IF (gGeneralMIDI = -1) THEN
        EXIT SUB
    END IF


    midiOutShortMsg(ghMidiOut, (256 * gGeneralMIDI) + 192) '19 - rock organ voice

    dFreq = gFreq /5.0
    '#DEBUG PRINT "dFreq: " + STR$(dFreq)
    freq = 440 * 2^((dFreq - 58)/12)
    'freq = 12 * LOG2(n/440) + 69
    'freq = 2^((n-69)/12) * (440)
    'freq = Round((log(n)-log(440.0))/log(2.0)*12+69, 0)


    note.msgPart.NoteOn = 144
    note.msgPart.KeyNumber = freq
    note.msgPart.KeyVelocity = 100
    note.msgPart.unused = 0



        'midiOutShortMsg(hMidiOut, NoteC)
    lResult = midiOutShortMsg(ghMidiOut, note.message)

    SELECT CASE (lResult)
        CASE %MMSYSERR_NOERROR
        CASE %MIDIERR_BADOPENMODE
            MSGBOX "The application sent a message without a status byte to a stream handle."
        CASE %MIDIERR_NOTREADY
            MSGBOX "The hardware is busy with other data."
        CASE %MMSYSERR_INVALHANDLE
            MSGBOX "The specified device handle is invalid."
    END SELECT

    ' SLEEP 250
    gFreqOld = freq
END SUB



FUNCTION VolumeControlRemap(x AS DOUBLE, minx AS DOUBLE, maxx AS DOUBLE) AS SINGLE
    LOCAL vol AS DOUBLE

    SELECT CASE gDefaultSound
        CASE 1, 2
            vol = (2^16 - 1) * LOG10((10 * maxx - 10 * minx)/(9 * x + maxx - 10 * minx))
        CASE 3
            vol = (2^10 - 24) * LOG10((10 * maxx - 10 * minx)/(9 * x + maxx - 10 * minx))
    END SELECT

    FUNCTION = vol
END FUNCTION
