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
#RESOURCE "EEGSettingsScreen.pbr"
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
%IDD_DIALOG1                         =  101
%IDC_FRAME1                          = 1001
%IDC_OPTION_32Channels               = 1101
%IDC_OPTION_64Channels               = 1102
%IDC_OPTION_128Channels              = 1103
%IDC_LABEL1                          = 1005 '*
%IDC_BUTTON_OKEEG                    = 1006
%IDC_BUTTON_CancelEEG                = 1007 '*
%IDC_TEXTBOX1                        = 1008 '*
%IDC_CHECKBOX_AIB                    = 1009 '*
%IDC_LISTBOX_AIB                     = 1010
%IDC_LABEL2                          = 1011
%IDC_BUTTON_LoadAIB                  = 1012
%IDC_BUTTON_Close                    = 1013
%IDC_BUTTON_EditAIB                  = 1014
%IDC_LABEL3                          = 1015 '*
%IDC_LABEL4                          = 1017
%IDC_LABEL5                          = 1019
%IDC_LISTBOX_BipolarLeads            = 1016
%IDC_LISTBOX_AuxiliarySensors        = 1018
%IDC_BUTTON_LoadBL                   = 1023
%IDC_BUTTON_EditBL                   = 1022
%IDC_BUTTON_LoadEEG                  = 1021
%IDC_BUTTON_EditEEG                  = 1020
%IDC_BUTTON_LoadAS                   = 1025 '*
%IDC_BUTTON_EditAS                   = 1024 '*
%IDC_LISTBOX2                        = 1027 '*
%IDC_LABEL6                          = 1029
%IDC_LISTBOX_SampleRates             = 1028
%IDC_LISTBOX_EEGChannels             = 1004
%IDC_FRAME2                          = 1104
%IDC_BUTTON_LoadDefaults             = 1105
%IDC_BUTTON_SaveDefaults             = 1106
%IDC_LABEL7                          = 1108
%IDC_LISTBOX_ScreenLength            = 1107
%IDC_CHECKBOX_ConnectToActiviewTCPIP = 1109
%IDC_BUTTON1                         = 1110 '*
%IDC_BUTTON_TCPIPSettings            = 1111
%IDC_TEXTBOX5                        = 1115
%IDC_LABEL8                          = 1131
%IDC_LABEL9                          = 1132
%IDC_LABEL10                         = 1133
%IDC_LABEL11                         = 1134
%IDC_LABEL12                         = 1135
%IDC_FRAME3                          = 1136
%IDC_LABEL13                         = 1137
%IDC_FRAME4                          = 1138
%IDC_TEXTBOX_TCPServer               = 1112
%IDC_TEXTBOX_TCPPort                 = 1113
%IDC_TEXTBOX_BytesInTCPArray         = 1114
%IDC_TEXTBOX_ChannelsSentByTCP       = 1116
%IDC_TEXTBOX_TCPSamplesPerChannel    = 1117
%IDC_OPTION_TCPSubset0               = 1118
%IDC_OPTION_TCPSubset8               = 1119
%IDC_OPTION_TCPSubset16              = 1120
%IDC_OPTION_TCPSubset32              = 1121
%IDC_OPTION_TCPSubset64              = 1122
%IDC_OPTION_TCPSubset128             = 1123
%IDC_OPTION_TCPSubset160             = 1124
%IDC_OPTION_TCPSubset256             = 1125
%IDC_CHECKBOX_Add8EXElectrodes       = 1126
%IDC_CHECKBOX_Add7Sensors            = 1127
%IDC_CHECKBOX_Add9Jazz               = 1128
%IDC_CHECKBOX_Add32AIBChan           = 1129
%IDC_CHECKBOX_AddTriggerStatusChan   = 1130
%IDC_LABEL14                         = 1139
%IDC_LABEL15                         = 1140 '*
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------
%MAXPPS_SIZE = 2048

GLOBAL gActiviewFilename AS ASCIIZ * 256
GLOBAL gINIFilename AS ASCIIZ * 256
GLOBAL gEEGFilename AS ASCIIZ *256
GLOBAL gAIBFilename AS ASCIIZ *256
GLOBAL gBLFilename AS ASCIIZ *256
GLOBAL gASFilename AS ASCIIZ *256
GLOBAL gDefaultFilename AS ASCIIZ *256
GLOBAL gCurrentDirectory AS ASCIIZ *256
GLOBAL hDlg   AS DWORD
GLOBAL labels(), aibLabels() AS ASCIIZ * 6
GLOBAL gIPAddress, gActiviewConfig AS ASCIIZ *512
GLOBAL gBytesInTCPArray, gChannelsSentByTCP, gTCPSamplesPerChannel AS LONG
GLOBAL gPort, gTCPSubset, gAdd8EXElectrodes, gAdd7Sensors, gAdd9Jazz, gAdd32AIBChan, gAddTriggerStatusChan AS LONG
GLOBAL gChannelsUsed, gSubsetBytes, gTotalBytes AS LONG

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmdCnt AS LONG
    LOCAL temp AS STRING

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gActiviewFilename = COMMAND$(1)
            CASE 2
                gActiviewFilename = COMMAND$(1)
                gINIFilename = COMMAND$(2)
                'msgbox "gActiviewFilename:  " + gActiviewFilename + "  gINIFilename: " + gINIFilename
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    ELSE
        MSGBOX "No Actiview file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
    END IF


    'gActiviewFilename = "\BioSemi\" + COMMAND$
    FILECOPY  gActiviewFilename, PATHNAME$(PATH,  gActiviewFilename) + PATHNAME$(NAME,  gActiviewFilename) + ".BAK"   ' returns  "XXX"


    gBLFilename = "H:\EEGSettings2\Default.BL"
    gAIBFilename = "H:\EEGSettings2\Default.AIB"
    gEEGFilename = "H:\EEGSettings2\Default.EEG"
    gCurrentDirectory = "H:\EEGSettings2"
    'msgbox    gCurrentDirectory

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL exitCode, EEGChoice, lResult AS LONG
    LOCAL lWidth, lHeight AS LONG

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
                ' /* Inserted by PB/Forms 12-20-2013 11:28:35
                ' */

                ' /* Inserted by PB/Forms 12-20-2013 09:50:54
                CASE %IDC_TEXTBOX5

                ' /* Inserted by PB/Forms 12-20-2013 08:28:15
                CASE %IDC_TEXTBOX_TCPServer

                CASE %IDC_TEXTBOX_TCPPort

                CASE %IDC_TEXTBOX_BytesInTCPArray

                CASE %IDC_TEXTBOX_ChannelsSentByTCP

                CASE %IDC_TEXTBOX_TCPSamplesPerChannel
                CASE %IDC_OPTION_TCPSubset0, %IDC_OPTION_TCPSubset8, %IDC_OPTION_TCPSubset16, _
                        %IDC_OPTION_TCPSubset32, %IDC_OPTION_TCPSubset64, %IDC_OPTION_TCPSubset128, _
                        %IDC_OPTION_TCPSubset160, %IDC_OPTION_TCPSubset256
                    lResult = calcByteForAllChannels()
                    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
                    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))


                CASE %IDC_CHECKBOX_Add8EXElectrodes, %IDC_CHECKBOX_Add7Sensors, %IDC_CHECKBOX_Add9Jazz, _
                        %IDC_CHECKBOX_Add32AIBChan, %IDC_CHECKBOX_AddTriggerStatusChan
                    lResult = calcByteForAllChannels()
                    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
                    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
                ' */


                ' /* Inserted by PB/Forms 10-24-2013 08:49:34
                CASE %IDC_CHECKBOX_ConnectToActiviewTCPIP
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ConnectToActiviewTCPIP TO lResult
                    IF (lResult = 1) THEN
                        DIALOG GET SIZE hDlg TO lWidth, lHeight
                        DIALOG SET SIZE hDlg, 1400, lHeight
                        lResult = calcByteForAllChannels()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
                    ELSE
                        DIALOG GET SIZE hDlg TO lWidth, lHeight
                        DIALOG SET SIZE hDlg, 670, lHeight
                    END IF


                ' /* Inserted by PB/Forms 10-22-2013 11:05:20
                CASE %IDC_LISTBOX_ScreenLength
                ' */

                ' /* Inserted by PB/Forms 06-13-2013 10:42:15
                CASE %IDC_BUTTON_LoadDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       CALL LoadDefaults()
                    END IF

                CASE %IDC_BUTTON_SaveDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL SaveDefaults()
                        'CALL LoadDefaults()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 05-29-2013 08:42:21
                CASE %IDC_LISTBOX_EEGChannels
                ' */



'                CASE %IDC_BUTTON_LoadEEG
'                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
'                        DISPLAY OPENFILE 0, , , "Choose EEG Settings file", "", CHR$("EEG Files", 0, "*.EEG", 0), "", "EEG", %OFN_SHOWHELP   TO gEEGFilename
'                        IF (gEEGFilename <> "") THEN
'                            CALL EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, 32)
'                        END IF
'                    END IF

                CASE %IDC_BUTTON_EditEEG
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        SHELL "EditSettings.exe " + gEEGFilename, 1, EXIT TO exitCode
                    END IF
                    LISTBOX RESET hDlg, %IDC_LISTBOX_EEGChannels
                    CALL EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, EEGChoice)

                CASE %IDC_BUTTON_LoadBL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Choose Bipolar Leads Settings file", gCurrentDirectory, CHR$("BL Files", 0, "*.BL", 0), "", "BL", %OFN_SHOWHELP   TO gBLFilename
                        IF (gBLFilename <> "") THEN
                            LISTBOX RESET hDlg, %IDC_LISTBOX_BipolarLeads
                            CALL BLListBox(hDlg, %IDC_LISTBOX_BipolarLeads, 32)
                        END IF
                    END IF

                CASE %IDC_BUTTON_EditBL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        SHELL "EditSettings.exe " + gBLFilename, 1, EXIT TO exitCode
                        LISTBOX RESET hDlg, %IDC_LISTBOX_BipolarLeads
                        CALL BLListBox(hDlg, %IDC_LISTBOX_BipolarLeads, 32)
                    END IF

                CASE %IDC_LISTBOX_BipolarLeads


                CASE %IDC_LISTBOX_AuxiliarySensors

                CASE %IDC_LISTBOX_SampleRates
                ' */

                ' /* Inserted by PB/Forms 05-28-2013 13:22:48
                CASE %IDC_BUTTON_EditAIB
                   SHELL "EditSettings.exe " + gAIBFilename, 1, EXIT TO exitCode
                   LISTBOX RESET hDlg, %IDC_LISTBOX_AIB
                   CALL AIBListBox(hDlg, %IDC_LISTBOX_AIB, 32)
                ' */

                ' /* Inserted by PB/Forms 05-28-2013 11:12:36
                CASE %IDC_BUTTON_LoadAIB
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DISPLAY OPENFILE 0, , , "Choose AIB Settings file", gCurrentDirectory, CHR$("AIB Files", 0, "*.AIB", 0), "", "AIB", %OFN_SHOWHELP   TO gAIBFilename
                        IF (gAIBFilename <> "") THEN
                            LISTBOX RESET hDlg, %IDC_LISTBOX_AIB
                            CALL AIBListBox(hDlg, %IDC_LISTBOX_AIB, 32)
                        END IF
                    END IF

                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "Settings not saved."
                        'WritePrivateProfileString( "Experiment Section", "ActiviewConfigUsed", "NO", gINIFilename)
                        DIALOG END CB.HNDL, 0
                    END IF
                ' */


                CASE %IDC_LISTBOX_AIB
                ' */

                CASE %IDC_OPTION_32Channels
                    EEGChoice = 32
                    LISTBOX RESET hDlg, %IDC_LISTBOX_EEGChannels
                    EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, 32)
' /* Inserted by PB/Forms 05-29-2013 08:35:48
                CASE %IDC_OPTION_64Channels
                    EEGChoice = 64
                    LISTBOX RESET hDlg, %IDC_LISTBOX_EEGChannels
                    EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, 64)
                CASE %IDC_OPTION_128Channels
                    EEGChoice = 128
                    LISTBOX RESET hDlg, %IDC_LISTBOX_EEGChannels
                    EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, 128)
                CASE %IDC_LISTBOX_EEGChannels

                CASE %IDC_BUTTON_OKEEG
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL saveTCPIPDefaults(gDefaultFilename)
                        lResult = writeToConfigFile()
                        IF (lResult <> 0) THEN
                            WritePrivateProfileString( "Experiment Section", "ActiviewConfigUsed", "YES", gINIFilename)
                            DIALOG END CB.HNDL, 0
                        END IF
                    END IF
            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------

SUB LoadDefaults()
    LOCAL x, cnt, lResult, itemValue AS LONG
    LOCAL numberOfChannels, EEGChannels, AIBChannels, AuxiliarySensors AS ASCIIZ * 256
    LOCAL BipolarLeads, SampleRates, ScreenLengths AS ASCIIZ * 256
    LOCAL lbItem, temp AS STRING

    'msgbox gCurrentDirectory
    DISPLAY OPENFILE 0, , , "Choose DEF Settings file", gCurrentDirectory, CHR$("DEF Files", 0, "*.DEF", 0), "", "DEF", %OFN_SHOWHELP   TO gDefaultFilename
    IF (gDefaultFilename <> "") THEN
        DIALOG SET TEXT hDlg, "EEG Settings - " + gDefaultFilename + " opened."
        GetPrivateProfileString("EEG Information", "NumberOfChannels", "32", numberOfChannels, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "EEGChannels", "", EEGChannels, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "AIBChannels", "", AIBChannels, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "AuxiliarySensors", "", AuxiliarySensors, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "BipolarLeads", "", BipolarLeads, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "SampleRates", "", SampleRates, %MAXPPS_SIZE, gDefaultFilename)
        GetPrivateProfileString("EEG Information", "ScreenLength", "", ScreenLengths, %MAXPPS_SIZE, gDefaultFilename)

        GetPrivateProfileString("EEG Information", "AIBChannelsFile", gAIBFilename, gAIBFilename, %MAXPPS_SIZE, gDefaultFilename)
        LISTBOX RESET hDlg, %IDC_LISTBOX_AIB
        CALL AIBListBox(hDlg, %IDC_LISTBOX_AIB, 32)
        GetPrivateProfileString("EEG Information", "BipolarLeadsFile", gBLFilename, gBLFilename, %MAXPPS_SIZE, gDefaultFilename)
        LISTBOX RESET hDlg, %IDC_LISTBOX_BipolarLeads
        CALL BLListBox(hDlg, %IDC_LISTBOX_BipolarLeads, 32)


        'set number of channels
        SELECT CASE TRIM$(numberOfChannels)
            CASE "1"
                CONTROL SET CHECK hDlg, %IDC_OPTION_32Channels, 1
                FOR x = 1 TO 32
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, x
                NEXT x
            CASE "2"
                CONTROL SET CHECK hDlg, %IDC_OPTION_32Channels, 2
                FOR x = 1 TO 64
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, x
                NEXT x
            CASE "3"
                CONTROL SET CHECK hDlg, %IDC_OPTION_32Channels, 3
                FOR x = 1 TO 128
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, x
                NEXT x
        END SELECT

        'eeg channels

        'aib channels
        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_EEGChannels, 0
        temp = EEGChannels
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    itemValue = VAL(lbItem)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, itemValue
                NEXT x
            END IF
        END IF

        'aib channels
        temp = AIBChannels
        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_AIB, 0
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    itemValue = VAL(lbItem)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_AIB, itemValue
                NEXT x
            END IF
        END IF

        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_AuxiliarySensors, 0
        'Auxiliary Sensors
        temp = AuxiliarySensors
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    itemValue = VAL(lbItem)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_AuxiliarySensors, itemValue
                NEXT x
            END IF
        END IF

        'BipolarLeads Sensors
        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_BipolarLeads, 0
        temp = BipolarLeads
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    itemValue = VAL(lbItem)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_BipolarLeads, itemValue
                NEXT x
            END IF
        END IF

        'Sample Rates
        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_SampleRates, 0
        temp = SampleRates
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_SampleRates, VAL(lbItem)
                NEXT x
            END IF
        END IF

        'Screen Lengths
        LISTBOX UNSELECT hDlg, %IDC_LISTBOX_ScreenLength, 0
        temp = ScreenLengths
        IF (TRIM$(temp) <> "") THEN
            cnt = PARSECOUNT(temp, ",")
            IF (cnt > 0) THEN
                FOR x = 1 TO cnt
                    lbItem = PARSE$(temp, x)
                    LISTBOX SELECT hDlg, %IDC_LISTBOX_ScreenLength, VAL(lbItem)
                NEXT x
            END IF
        END IF

        CALL loadTCPIPDefaults(gDefaultFilename)
        lResult = calcByteForAllChannels()
        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
    END IF
END SUB

SUB SaveDefaults()
    LOCAL x, cnt, lbState AS LONG
    LOCAL numberOfChannels, EEGChannels, AIBChannels, AuxiliarySensors AS ASCIIZ * 256
    LOCAL BipolarLeads, SampleRates, ScreenLengths AS ASCIIZ * 256
    LOCAL lbItem, temp AS STRING

    DISPLAY SAVEFILE 0, , , "Choose DEF Settings file", gCurrentDirectory, CHR$("DEF Files", 0, "*.DEF", 0), "", "DEF", %OFN_SHOWHELP   TO gDefaultFilename
    IF (gDefaultFilename <> "") THEN
        'set number of channels
        CONTROL GET CHECK hDlg, %IDC_OPTION_32Channels TO lbState
        SELECT CASE lbState
            CASE 1
                numberOfChannels = "1"      '32 channels
            CASE 2
                numberOfChannels = "2"      '64 channels
            CASE 3
                numberOfChannels = "3"      '128 channels
        END SELECT

        'eeg channels
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_EEGChannels TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_EEGChannels, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            EEGChannels = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF

        'aib channels
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_AIB TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_AIB, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            AIBChannels = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF


        'Auxiliary Sensors
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_AuxiliarySensors TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_AuxiliarySensors, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            AuxiliarySensors = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF

        'BipolarLeads Sensors
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_BipolarLeads TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_BipolarLeads, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            BipolarLeads = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF

        'Sample Rates
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_SampleRates TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_SampleRates, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            SampleRates = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF

        'Screen Length
        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ScreenLength TO cnt

        IF (cnt > 0) THEN
            temp = ""
            FOR x = 1 TO cnt
                LISTBOX GET STATE hDlg, %IDC_LISTBOX_ScreenLength, x TO lbState
                IF (lbState = -1) THEN 'selected
                    temp = temp + TRIM$(STR$(x)) + ","
                END IF
            NEXT x
            ScreenLengths = TRIM$(LEFT$(temp, LEN(temp) - 1))
        END IF



        WritePrivateProfileString("EEG Information", "NumberOfChannels", numberOfChannels, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "EEGChannels", EEGChannels, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "AIBChannels", AIBChannels, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "AuxiliarySensors", AuxiliarySensors, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "BipolarLeads", BipolarLeads, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "SampleRates", SampleRates, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "ScreenLength", SampleRates, gDefaultFilename)

        'added 8/19/2013 - FAA

        WritePrivateProfileString("EEG Information", "EEGChannelsFile", gEEGFilename, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "AIBChannelsFile", gAIBFilename, gDefaultFilename)
        WritePrivateProfileString("EEG Information", "BipolarLeadsFile", gBLFilename, gDefaultFilename)

        CALL saveTCPIPDefaults(gDefaultFilename)

        MSGBOX "Default settings saved."
    END IF
END SUB

FUNCTION EEGListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i, labCnt, aThruFCnt, lRes AS LONG
    LOCAL selectChannel32, selectChannel64, selectChannel128, selectedState AS LONG
    LOCAL temp, lab, filename AS STRING

    FOR i = %IDC_OPTION_32Channels TO %IDC_OPTION_128Channels
         CONTROL GET CHECK hDlg, i TO lRes
         IF lRes THEN EXIT FOR
    NEXT i

    lRes = i - %IDC_OPTION_32Channels + 1

    SELECT CASE lRes
        CASE 1 '32 channels
            REDIM labels(32)

            gEEGFilename = "H:\EEGSettings2\Default.EEG"
        CASE 2 '64 channels
            REDIM labels(64)
            gEEGFilename = "H:\EEGSettings2\Default64.EEG"
        CASE 3 '128 channels
            REDIM labels(128)
            gEEGFilename = "H:\EEGSettings2\Default128.EEG"
    END SELECT

    OPEN gEEGFilename FOR INPUT AS #1
    LINE INPUT #1, temp 'first line is header

    i = 0
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        INCR i
        lab  = PARSE$(temp, ",", 2)
        labels(i) = lab
        LISTBOX ADD hDlg, %IDC_LISTBOX_EEGChannels, "Chan" + TRIM$(STR$(i)) + " = " + lab
    WEND
    CLOSE #1

    SELECT CASE lRes
        CASE 1 '32 channels
            FOR i = 1 TO 32
                LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, i
            NEXT i
        CASE 2 '64 channels
            FOR i = 1 TO 64
                LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, i
            NEXT i
        CASE 3 '128 channels
            FOR i = 1 TO 128
                LISTBOX SELECT hDlg, %IDC_LISTBOX_EEGChannels, i
            NEXT i
    END SELECT


    'FOR i = 1 TO lCount
    '    LISTBOX ADD hDlg, lID, USING$("Ana#", i)
    'NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
FUNCTION AIBListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL temp, lab AS STRING

    'msgbox gAIBFilename
    OPEN gAIBFilename FOR INPUT AS #1
    LINE INPUT #1, temp 'first line is header

    i = 0
    REDIM aibLabels(32)
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        INCR i
        lab  = PARSE$(temp, ",", 2)
        aibLabels(i) = lab
        LISTBOX ADD hDlg, %IDC_LISTBOX_AIB, "Box" + TRIM$(STR$(i)) + " = " + lab
    WEND
    CLOSE #1

    'always select first 3
    'LISTBOX SELECT hDlg, %IDC_LISTBOX_AIB, 1
    'LISTBOX SELECT hDlg, %IDC_LISTBOX_AIB, 2
    'LISTBOX SELECT hDlg, %IDC_LISTBOX_AIB, 3

END FUNCTION

FUNCTION BLListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i, x AS LONG
    LOCAL temp, lab AS STRING
    LOCAL labels() AS STRING


    OPEN gBLFilename FOR INPUT AS #1
    LINE INPUT #1, temp 'first line is header

    REDIM labels(8)
    i = 0
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        INCR i
        labels(i)  = PARSE$(temp, ",", 2)
        'LISTBOX ADD hDlg, %IDC_LISTBOX_BipolarLeads, "Tou" + TRIM$(STR$(i)) + " = " + lab
    WEND
    CLOSE #1
    FOR x = 1 TO i - 1
        LISTBOX ADD hDlg, %IDC_LISTBOX_BipolarLeads, labels(x) + " - " + labels(x + 1)
    NEXT x
    LISTBOX ADD hDlg, %IDC_LISTBOX_BipolarLeads, labels(x) + " - " + labels(1)
END FUNCTION

FUNCTION ASListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "GSR1"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "GSR2"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "Erg1"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "Erg2"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "Resp"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "Plet"
    LISTBOX ADD hDlg, %IDC_LISTBOX_AuxiliarySensors, "Temp"
END FUNCTION

FUNCTION SampleRateListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LISTBOX ADD hDlg, %IDC_LISTBOX_SampleRates, "2048"
    LISTBOX ADD hDlg, %IDC_LISTBOX_SampleRates, "1024"
    LISTBOX ADD hDlg, %IDC_LISTBOX_SampleRates, "512"
    LISTBOX ADD hDlg, %IDC_LISTBOX_SampleRates, "256"
    LISTBOX ADD hDlg, %IDC_LISTBOX_SampleRates, "128"
END FUNCTION

FUNCTION ScreenLengthListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LISTBOX ADD hDlg, %IDC_LISTBOX_ScreenLength, "1"
    LISTBOX ADD hDlg, %IDC_LISTBOX_ScreenLength, "2"
    LISTBOX ADD hDlg, %IDC_LISTBOX_ScreenLength, "4"
    LISTBOX ADD hDlg, %IDC_LISTBOX_ScreenLength, "8"
    LISTBOX ADD hDlg, %IDC_LISTBOX_ScreenLength, "16"
END FUNCTION

'------------------------------------------------------------------------------

FUNCTION writeToConfigFile() AS LONG
    LOCAL selectChannels, selectedState, lResult, datav, lRes AS LONG
    LOCAL x, nbrOfChannels, nbrOfAnaChannels AS LONG
    LOCAL temp AS ASCIIZ * 256
    LOCAL MyString AS ISTRINGBUILDERA

    LET MyString = CLASS "StringBuilderA"

    IF (TRIM$(gDefaultFilename) = "") THEN
        MSGBOX "No default file ever loaded. Config file not updated."
        WritePrivateProfileString( "Experiment Section", "ActiviewConfigUsed", "NO", gINIFilename)
        FUNCTION = 0
        EXIT FUNCTION
    END IF

    '=================================================================
    'If we are using TCPIP in an experiment, then write it to the
    'the experiment .INI file and tell the experiment where to find
    'the TCPIP settings.
    '=================================================================
    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ConnectToActiviewTCPIP TO lResult
    IF (lResult = 1) THEN
        WritePrivateProfileString( "Experiment Section", "UseTCPIP", "1", gDefaultFilename)
        WritePrivateProfileString( "Experiment Section", "EEGDefaultFilename", gDefaultFilename, gINIFilename)
        GetPrivateProfileString("OPTIONS", "TCPSubset", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPSubset", TRIM$(temp), gActiviewFilename)  'Set the TCPSubset under TCP settings
        GetPrivateProfileString("OPTIONS", "Add8EXElectrodes", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPaddTP", TRIM$(temp), gActiviewFilename)  'Set the TCPaddTP under TCP settings
        GetPrivateProfileString("OPTIONS", "Add7Sensors", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPaddSens", TRIM$(temp), gActiviewFilename)  'Set the TCPaddTP under TCP settings
        GetPrivateProfileString("OPTIONS", "Add9Jazz", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPaddJazz", TRIM$(temp), gActiviewFilename)  'Set the TCPaddTP under TCP settings
        GetPrivateProfileString("OPTIONS", "Add32AIBChan", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPaddAnas", TRIM$(temp), gActiviewFilename)  'Set the TCPaddTP under TCP settings
        GetPrivateProfileString("OPTIONS", "AddTriggerStatusChan", "0", temp, %MAXPPS_SIZE, gDefaultFilename)
        lResult = WritePrivateProfileString( "TCP", "TCPaddTrig", TRIM$(temp), gActiviewFilename)  'Set the TCPaddTP under TCP settings
    ELSE
        WritePrivateProfileString( "Experiment Section", "UseTCPIP", "0", gINIFilename)
    END IF
    'WritePrivateProfileString( "Experiment Section", "TCPIPSettingsFile", gDefaultFilename, gINIFilename)

    '=================================================================
    'Taking care of the [Labels] section of the .cfg file
    '=================================================================

    FOR x = %IDC_OPTION_32Channels TO %IDC_OPTION_128Channels
         CONTROL GET CHECK hDlg, x TO lRes
         IF lRes THEN EXIT FOR
    NEXT x

    lRes = x - %IDC_OPTION_32Channels + 1


    SELECT CASE lRes
        CASE 1 '32 channels
            WritePrivateProfileString( "Experiment Section", "Channels", "32", gINIFilename)
            FOR x = 1 TO 32
                lResult = WritePrivateProfileString( "Labels", "Chan" + TRIM$(STR$(x)), labels(x), gActiviewFilename)  'Set the Channels to Freeform
            NEXT x
            nbrOfChannels = 32
        CASE 2 '64 channels
            WritePrivateProfileString( "Experiment Section", "Channels", "64", gINIFilename)
            FOR x = 1 TO 64
                lResult = WritePrivateProfileString( "Labels", "Chan" + TRIM$(STR$(x)), labels(x), gActiviewFilename)  'Set the Channels to Freeform
            NEXT x
            nbrOfChannels = 64
        CASE 3 '128 channels
            WritePrivateProfileString( "Experiment Section", "Channels", "128", gINIFilename)
            FOR x = 1 TO 128
                lResult = WritePrivateProfileString( "Labels", "Chan" + TRIM$(STR$(x)), labels(x), gActiviewFilename)  'Set the Channels to Freeform
            NEXT x
            nbrOfChannels = 128
    END SELECT

     FOR x = 1 TO 32
            lResult = WritePrivateProfileString( "Labels", "Box" + TRIM$(STR$(x)), aibLabels(x), gActiviewFilename)  'Set the Channels to Freeform
     NEXT x

    '=================================================================
    'Taking care of the [Selectors] section of the .cfg file
    '=================================================================
    LISTBOX GET SELECT hDlg, %IDC_LISTBOX_SampleRates TO datav

    IF (datav = 0) THEN
        MSGBOX "No sample rate was selected. Please select a sample rate."
        FUNCTION = 0
        EXIT FUNCTION
    END IF

    '=================================================================
    'Write out Sample Rate to the TCPIPSettings.ini file.
    '=================================================================
    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SampleRates ,datav TO temp


    WritePrivateProfileString( "OPTIONS", "SampleRate", TRIM$(temp), gDefaultFilename)

    '=================================================================
    'Taking care of the [Selectors] section of the .cfg file
    '=================================================================
    lResult = WritePrivateProfileString( "Selectors", "Decimation", TRIM$(STR$(datav - 1)), gActiviewFilename)  'Set the Channels to Freeform

    LISTBOX GET SELECT hDlg, %IDC_LISTBOX_ScreenLength TO datav

    IF (datav = 0) THEN
        MSGBOX "No screen length was selected. Please select a screen length."
        FUNCTION = 0
        EXIT FUNCTION
    END IF

    lResult = WritePrivateProfileString( "Selectors", "ScreenLength", TRIM$(STR$(datav - 1)), gActiviewFilename)  'Set the Channels to Freeform

    lResult = WritePrivateProfileString( "Selectors", "Channels", "14", gActiviewFilename)  'Set the Channels to Freeform
    lResult = WritePrivateProfileString( "Selectors", "TrigCode", "1", gActiviewFilename)  'Set the Trigger Format to Decimal

    '=================================================================
    'Taking care of the [Save] section of the .cfg file
    '=================================================================
    SELECT CASE lRes
        CASE 1 '32 channels
            lResult = WritePrivateProfileString( "Save", "Subset", "7", gActiviewFilename)  'Set Subset saved to 32
        CASE 2 '64 channels
            lResult = WritePrivateProfileString( "Save", "Subset", "6", gActiviewFilename)  'Set Subset saved to 128
        CASE 3 '128 channels
            lResult = WritePrivateProfileString( "Save", "Subset", "4", gActiviewFilename)  'Set Subset saved to 128
    END SELECT



    '=================================================================
    'Taking care of the [FreeChoice] section of the .cfg file
    '=================================================================
    MyString.Clear()
    FOR x = 1 TO nbrOfChannels
        MyString.Add(USING$("#", x) + "%")
    NEXT x

    FOR x = 257 TO 260   'ex1 - ex4
        MyString.Add(USING$("#", x) + "%")
    NEXT x

    lResult = WritePrivateProfileString( "FreeChoice", "MonFree", MyString.String(), gActiviewFilename)  'Setting which channels to view

    lResult = WritePrivateProfileString( "FreeChoice", "RefFree", "0%", gActiviewFilename)

    'bipolar leads

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_BipolarLeads TO nbrOfChannels
    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_BipolarLeads TO datav

    MyString.Clear()
    IF (datav > 0) THEN
        'Add 8 EX electrodes
        lResult = WritePrivateProfileString( "Save", "Touchproofs", "1", gActiviewFilename)  'Set

        FOR x = 1 TO nbrOfChannels
            LISTBOX GET STATE hDlg, %IDC_LISTBOX_BipolarLeads, x TO selectedState
            IF (selectedState = -1) THEN
                MyString.Add(USING$("#", x) + "%")
            END IF
        NEXT x
    ELSE
        'Add 8 EX electrodes
        lResult = WritePrivateProfileString( "Save", "Touchproofs", "0", gActiviewFilename)  'Set

         MyString.Add(USING$("#", 0) + "%")
    END IF

    lResult = WritePrivateProfileString( "FreeChoice", "BipFree", MyString.String(), gActiviewFilename)  'Set which Bipolar Leads to view

    lResult = WritePrivateProfileString( "FreeChoice", "AvgTrigSel", "1%", gActiviewFilename)

    lResult = WritePrivateProfileString( "FreeChoice", "MonFreeAvg1", "1%", gActiviewFilename)

    lResult = WritePrivateProfileString( "FreeChoice", "RefFreeAvg1", "2%", gActiviewFilename)

    lResult = WritePrivateProfileString( "FreeChoice", "MonFreeAvg2", "3%", gActiviewFilename)

    lResult = WritePrivateProfileString( "FreeChoice", "RefFreeAvg2", "4%", gActiviewFilename)

    'do this for auxiliary sensors

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_AuxiliarySensors TO nbrOfChannels
    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_AuxiliarySensors TO datav

    MyString.Clear()
    IF (datav > 0) THEN
        'Add Displayed sensor
        lResult = WritePrivateProfileString( "Save", "Sensors", "1", gActiviewFilename)  'Set
        FOR x = 1 TO nbrOfChannels
            LISTBOX GET STATE hDlg, %IDC_LISTBOX_AuxiliarySensors, x TO selectedState
            IF (selectedState = -1) THEN
                MyString.Add(USING$("#", x) + "%")
            END IF
        NEXT x
    ELSE
        'Add Displayed sensor
        lResult = WritePrivateProfileString( "Save", "Sensors", "0", gActiviewFilename)  'Set
        MyString.Add(USING$("#", 0) + "%")
    END IF

    lResult = WritePrivateProfileString( "FreeChoice", "AuxFree", MyString.String(), gActiviewFilename)  'Set which Auxiliary Sensors to view


    lResult = WritePrivateProfileString( "FreeChoice", "JazzFree", "1%2%3%4%5%6%7%8%9%", gActiviewFilename)

    'Analog
    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_AIB TO nbrOfAnaChannels
    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_AIB TO datav

    MyString.Clear()
    IF (datav > 0) THEN
        'Add 8 EX electrodes
        lResult = WritePrivateProfileString( "Save", "Anas", "1", gActiviewFilename)  'Set
        FOR x = 1 TO nbrOfAnaChannels
            LISTBOX GET STATE hDlg, %IDC_LISTBOX_AIB, x TO selectedState
            IF (selectedState = -1) THEN
                MyString.Add(USING$("#", x) + "%")
            END IF
        NEXT x
    ELSE
        'Add Anas
        lResult = WritePrivateProfileString( "Save", "Anas", "0", gActiviewFilename)  'Set
        MyString.Add(USING$("#", 0) + "%")
    END IF

    lResult = WritePrivateProfileString( "FreeChoice", "AnaFree", MyString.String(), gActiviewFilename)  'Set which Analog Input channels to view

    MSGBOX gActiviewFilename + " has been modified."

    FUNCTION = -1

END FUNCTION

SUB loadTCPIPDefaults(filename AS ASCIIZ * 512)
    LOCAL x, selected AS LONG
    LOCAL temp AS ASCIIZ * 255

    'msgbox "filename: " + filename

    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", gActiviewFilename, 2048, filename)

    'MSGBOX "gActiviewFilename: " + gActiviewFilename
    'IF (ISFILE(gActiviewFilename) = 0) THEN
    '    MSGBOX "The default Biosemi config file was not found."
    'END IF


    GetPrivateProfileString("OPTIONS", "IP", "", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPServer, temp
    gIPAddress = TRIM$(temp)

    GetPrivateProfileString("OPTIONS", "PORT", "", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPPort, temp
    gPort = VAL(TRIM$(temp))

    'GetPrivateProfileString("OPTIONS", "BytesInTCPArray", "1", temp, 2048, filename)
    'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, temp
    'gBytesInTCPArray = VAL(temp)

    'GetPrivateProfileString("OPTIONS", "ChannelsSentByTCP", "1", temp, 2048, filename)
    'CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, temp
    'gChannelsSentByTCP = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSamplesPerChannel", "1", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, temp
    gTCPSamplesPerChannel = VAL(temp)

    GetPrivateProfileString("OPTIONS", "TCPSubset", "0", temp, 2048, filename)
    gTCPSubset = VAL(temp)
    SELECT CASE gTCPSubset
        CASE 0
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset256, 1
        CASE 1
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset160, 1
        CASE 2
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset128, 1
        CASE 3
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset64, 1
        CASE 4
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset32, 1
        CASE 5
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset160, 1
        CASE 6
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset8, 1
        CASE 7
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset0, 1
    END SELECT

    GetPrivateProfileString("OPTIONS", "Add8EXElectrodes", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes, 1
        gAdd8EXElectrodes = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes, 0
        gAdd8EXElectrodes = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add7Sensors", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors, 1
        gAdd7Sensors = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors, 0
        gAdd7Sensors = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add9Jazz", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz, 1
        gAdd9Jazz = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz, 0
        gAdd9Jazz = 0
    END IF

    GetPrivateProfileString("OPTIONS", "Add32AIBChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan, 1
        gAdd32AIBChan = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan, 0
        gAdd32AIBChan = 0
    END IF

    GetPrivateProfileString("OPTIONS", "AddTriggerStatusChan", "0", temp, 2048, filename)
    IF (TRIM$(temp) = "1") THEN
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, 1
        gAddTriggerStatusChan = 1
    ELSE
        CONTROL SET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, 0
        gAddTriggerStatusChan = 0
    END IF

'    GetPrivateProfileString("OPTIONS", "ThrottledSampleRate", "0", temp, 2048, filename)
'    CONTROL SET TEXT hDlg, %IDC_LISTBOX_ThrottledSampleRate, temp
'
'    CALL buildChannelsToUse()
'
'    GetPrivateProfileString("OPTIONS", "ChannelsUsed", "", temp, 2048, filename)
'    gChannelsUsed = PARSECOUNT(temp, ",") - 1
'
'    IF (gChannelsUsed > 0) THEN
'        FOR x = 1 TO gChannelsUsed
'            selected = VAL(PARSE$(temp, ",", x))
'            LISTBOX SELECT hDlg, %IDC_LISTBOX_ChannelsToUse, selected
'        NEXT x
'    END IF

END SUB

SUB saveTCPIPDefaults(filename AS ASCIIZ * 512)
    LOCAL x, idx, lPtr, lResult, lbCount, cnt, selected AS LONG
    LOCAL temp AS ASCIIZ * 255


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPServer TO temp
    WritePrivateProfileString("OPTIONS", "IP", TRIM$(temp), filename)

    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPPort TO temp
    WritePrivateProfileString("OPTIONS", "Port", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray TO temp
    WritePrivateProfileString("OPTIONS", "BytesInTCPArray", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP TO temp
    WritePrivateProfileString("OPTIONS", "ChannelsSentByTCP", TRIM$(temp), filename)


    CONTROL GET TEXT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel TO temp
    WritePrivateProfileString("OPTIONS", "TCPSamplesPerChannel", TRIM$(temp), filename)

    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset0 TO lResult
    IF (lResult = 1) THEN
        lPtr = 7
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset8 TO lResult
    IF (lResult = 1) THEN
        lPtr = 6
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset16 TO lResult
    IF (lResult = 1) THEN
        lPtr = 5
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset32 TO lResult
    IF (lResult = 1) THEN
        lPtr = 4
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset64 TO lResult
    IF (lResult = 1) THEN
        lPtr = 3
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset128 TO lResult
    IF (lResult = 1) THEN
        lPtr = 2
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset160 TO lResult
    IF (lResult = 1) THEN
        lPtr = 1
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset256 TO lResult
    IF (lResult = 1) THEN
        lPtr = 0
    END IF
    WritePrivateProfileString("OPTIONS", "TCPSubset", STR$(lPtr), filename)


    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes TO lResult
    WritePrivateProfileString("OPTIONS", "Add8EXElectrodes", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors TO lResult
    WritePrivateProfileString("OPTIONS", "Add7Sensors", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz TO lResult
    WritePrivateProfileString("OPTIONS", "Add9Jazz", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan TO lResult
    WritePrivateProfileString("OPTIONS", "Add32AIBChan", STR$(lResult), filename)

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan TO lResult
    WritePrivateProfileString("OPTIONS", "AddTriggerStatusChan", STR$(lResult), filename)

'    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ThrottledSampleRate TO lbCount
'    temp = ""
'    FOR x = 1 TO lbCount
'        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ThrottledSampleRate, x TO selected
'        IF (selected = -1) THEN  'if selected
'            LISTBOX GET TEXT hDlg, %IDC_LISTBOX_ThrottledSampleRate, x TO temp
'            EXIT FOR
'        END IF
'    NEXT x
'    'REDIM selectedChannels(gChannelsUsed)
'    WritePrivateProfileString("OPTIONS", "ThrottledSampleRate", TRIM$(temp), filename)
'
'    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO gChannelsUsed
'    'REDIM selectedChannels(gChannelsUsed)
'
'    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO lbCount
'    cnt = 0
'    temp = ""
'    FOR x = 1 TO lbCount
'        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ChannelsToUse, x TO selected
'        IF (selected = -1) THEN  'if selected
'            INCR cnt
'            temp = temp + STR$(x) + ","
'        END IF
'    NEXT x
'
'    WritePrivateProfileString("OPTIONS", "ChannelsUsed", TRIM$(temp), filename)

END SUB


FUNCTION calcByteForAllChannels() AS LONG
    LOCAL x, cnt, lResult, temp, total AS LONG

    cnt = 0
    FOR x = %IDC_OPTION_TCPSubset0 TO %IDC_OPTION_TCPSubset256
        INCR cnt
        CONTROL GET CHECK hDlg, x TO lResult
        IF (lResult = 1) THEN
            SELECT CASE cnt
                CASE 1
                    temp = 0
                CASE 2
                    temp = 8
                CASE 3
                    temp = 16
                CASE 4
                    temp = 32
                CASE 5
                    temp = 64
                CASE 6
                    temp = 128
                CASE 7
                    temp = 160
                CASE 8
                    temp = 256
            END SELECT
            EXIT FOR
        END IF
    NEXT x

    cnt = 0
    total = temp
    FOR x = %IDC_CHECKBOX_Add8EXElectrodes TO %IDC_CHECKBOX_AddTriggerStatusChan
        INCR cnt
        CONTROL GET CHECK hDlg, x TO lResult
        IF (lResult = 1) THEN
            SELECT CASE cnt
                CASE 1
                    temp = 8
                CASE 2
                    temp = 7
                CASE 3
                    temp = 9
                CASE 4
                    temp = 32
                CASE 5
                    temp = 1
            END SELECT
            total = total + temp
        END IF
    NEXT x

    FUNCTION = (total * 3)
END FUNCTION

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG
    LOCAL temp AS ASCIIZ * 255

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD

    DIALOG NEW PIXELS, hParent, "EEG Settings", 16, 98, 670, 707, TO hDlg
    ' %WS_GROUP...
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_32Channels, "32", 75, 93, 97, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_64Channels, "64", 75, 122, 97, _
        24, %WS_CHILD OR %WS_VISIBLE OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR _
        %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_128Channels, "128", 75, 151, 97, _
        25, %WS_CHILD OR %WS_VISIBLE OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR _
        %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_EEGChannels, , 352, 70, 173, _
        138, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EditEEG, "Edit EEG", 532, 119, _
        90, 40
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_AIB, , 52, 265, 173, 138, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_LoadAIB, "Load AIB", 232, 289, _
        90, 41
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EditAIB, "Edit AIB", 232, 338, _
        90, 41
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_BipolarLeads, , 352, 265, 173, _
        138, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_LoadBL, "Load BL", 532, 289, 90, _
        41
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_EditBL, "Edit BL", 532, 338, 90, _
        41
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_AuxiliarySensors, , 52, 452, _
        173, 138, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_MULTIPLESEL OR %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_SampleRates, , 267, 452, 173, _
        138, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_OKEEG, "Save to CFG", 368, 666, _
        104, 33
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Close, "Close", 495, 666, 83, 33
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "EEG Channels", 52, 46, 578, 170
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "AIB Channels", 52, 240, 150, 25
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Bipolar Leads", 352, 240, 150, _
        25
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "Auxiliary Sensors", 52, 427, _
        150, 25
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL6, "Sample Rates", 267, 427, 150, _
        25
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME2, "EEG Channels to view", 30, 13, _
        630, 637
    CONTROL SET COLOR     hDlg, %IDC_FRAME2, -1, %LTGRAY
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_LoadDefaults, "Load defaults", _
        22, 666, 106, 33
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_SaveDefaults, "Save defaults", _
        142, 666, 106, 33
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_ScreenLength, , 464, 452, 174, _
        138, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL7, "Screen Length (secs)", 464, _
        427, 150, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ConnectToActiviewTCPIP, "Use " + _
        "Actiview TCPIP Server", 405, 614, 233, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPServer, "137.54.99.124", 864, 128, 281, 39
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPPort, "778", 1270, 128, 70, 39
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_BytesInTCPArray, "96", 866, 195, _
        124, 39, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX5, "60000", 1242, 196, 83, 41
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, "32", 868, 250, _
        124, 39, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, "1", 868, _
        302, 124, 42, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    ' %WS_GROUP...
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset0, "None    (0)", 713, _
        437, 168, 39, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP _
        OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset8, "A1-A8   (8)", 713, _
        476, 168, 39
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset16, "A1-A16   (16)", _
        713, 515, 168, 39
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset32, "A1-A32   (32)", _
        713, 554, 168, 39
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset64, "A1-B32   (64)", _
        917, 437, 168, 39
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset128, "A1-D32   (128)", _
        917, 476, 192, 39
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add8EXElectrodes, "Add 8 EX " + _
        "electrodes", 1172, 404, 198, 39
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add7Sensors, "Add 7 Sensors", _
        1172, 443, 198, 39
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add9Jazz, "Add 9 Jazz", 1172, _
        482, 198, 39
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add32AIBChan, "Add 32 AIB " + _
        "Chan", 1172, 521, 198, 39
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, "Add " + _
        "Trigger/Status Chan", 1172, 560, 198, 39
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL8, "Actiview TCP Server IP:", 677, _
        128, 175, 39, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL9, "Port:", 1180, 128, 78, 39, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL10, "Bytes in TCP Array:", 677, _
        195, 180, 39, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL11, "Channels sent by TCP:", 677, _
        247, 181, 42, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL12, "TCP Samples/channel:", 677, _
        302, 181, 39, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME3, "Actiview Server Information", _
        664, 92, 714, 559
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL13, "Receiver Timeout:", 1018, 196, _
        216, 41, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME4, "TCP Subset", 689, 391, 444, 247
    CONTROL SET COLOR     hDlg, %IDC_FRAME4, -1, %LTGRAY
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL14, "TCPIP Channels to transmit", _
        674, 21, 216, 32

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Terminal", 14, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont3

    CONTROL SET FONT hDlg, %IDC_OPTION_32Channels, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_64Channels, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_128Channels, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_EEGChannels, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_EditEEG, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_AIB, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadAIB, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EditAIB, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_BipolarLeads, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadBL, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_EditBL, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_AuxiliarySensors, hFont2
    CONTROL SET FONT hDlg, %IDC_LISTBOX_SampleRates, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_OKEEG, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL6, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME2, hFont3
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_SaveDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_ScreenLength, hFont2
    CONTROL SET FONT hDlg, %IDC_LABEL7, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ConnectToActiviewTCPIP, hFont3
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPServer, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPPort, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_BytesInTCPArray, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX5, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset0, hFont3
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset8, hFont3
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset16, hFont3
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset32, hFont3
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset64, hFont3
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset128, hFont3
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add8EXElectrodes, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add7Sensors, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add9Jazz, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add32AIBChan, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL8, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL9, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL10, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL11, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL12, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME3, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL13, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME4, hFont3
    CONTROL SET FONT hDlg, %IDC_LABEL14, hFont1
#PBFORMS END DIALOG

    gTCPSamplesPerChannel = 1

    CONTROL SET CHECK hDlg, %IDC_OPTION_32Channels, 1
    EEGListBox(hDlg, %IDC_LISTBOX_EEGChannels, 32)
    SampleRateListBox(hDlg, %IDC_LISTBOX_SampleRates, 5)
    LISTBOX SELECT hDlg, %IDC_LISTBOX_SampleRates, 3
    ScreenLengthListBox(hDlg, %IDC_LISTBOX_ScreenLength, 5)
    LISTBOX SELECT hDlg, %IDC_LISTBOX_ScreenLength, 3
    ASListBox(hDlg, %IDC_LISTBOX_AuxiliarySensors, 4)
    BLListBox(hDlg, %IDC_LISTBOX_BipolarLeads, 32)
    AIBListBox(hDlg, %IDC_LISTBOX_AIB, 32)

    CONTROL DISABLE hDlg, %IDC_BUTTON_TCPIPSettings

    GetPrivateProfileString("Experiment Section", "ActiviewConfigUsed", "NO", temp, 2048, gINIFilename)
    IF (UCASE$(temp) = "NO" OR UCASE$(temp) = "") THEN
        CONTROL DISABLE hDlg, %IDC_CHECKBOX_ConnectToActiviewTCPIP
    END IF

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
