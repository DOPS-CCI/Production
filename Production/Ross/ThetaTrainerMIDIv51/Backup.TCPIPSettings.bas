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
#RESOURCE "TCPIPSettings.pbr"
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
%IDD_DIALOG1                        =  101
%IDC_LABEL1                         = 1001
%IDC_TEXTBOX_TCPServer              = 1002
%IDC_LABEL2                         = 1003
%IDC_TEXTBOX_TCPPort                = 1004
%IDC_LABEL3                         = 1005
%IDC_TEXTBOX_BytesInTCPArray        = 1006
%IDC_LABEL4                         = 1008
%IDC_TEXTBOX_ChannelsSentByTCP      = 1007
%IDC_LABEL5                         = 1010
%IDC_TEXTBOX_TCPSamplesPerChannel   = 1009
%IDC_FRAME1                         = 1013
%IDC_LISTBOX_RecvBuffer             = 1015
%IDC_LABEL6                         = 1016  '*
%IDC_LABEL7                         = 1018
%IDC_TEXTBOX_ReceiverTimeout        = 1017
%IDC_LABEL_TCPBuffer                = 1019  '*
%IDC_BUTTON_Close                   = 1020
%IDC_BUTTON_LoadDefaults            = 1023
%IDC_BUTTON_SaveDefaults            = 1024
%IDC_CHECKBOX_Settings              = 1027  '*
%IDC_LABEL8                         = 1029  '*
%IDC_TEXTBOX1                       = 1030  '*
%IDC_CHECKBOX_Add8EXElectrodes      = 1031
%IDC_CHECKBOX_Add7Sensors           = 1032
%IDC_CHECKBOX_Add9Jazz              = 1033
%IDC_CHECKBOX_Add32AIBChan          = 1034
%IDC_CHECKBOX_AddTriggerStatusChan  = 1035
%IDC_LABEL9                         = 1036  '*
%IDC_CHECKBOX_ChannelsToUse         = 1038  '*
%IDC_LISTBOX_ChannelsToUse          = 1039
%IDC_BUTTON_BiosemiCfgFile          = 1040
%IDC_LABEL10                        = 1041  '*
%IDC_LABEL11                        = 1042
%IDC_TEXTBOX_ThrottledSampleRate    = 1043
%IDC_LISTBOX_ThrottledSampleRate    = 1044
%IDC_FRAME2                         = 1045
%IDC_OPTION_TCPSubset0              = 1046
%IDC_OPTION_TCPSubset8              = 1047
%IDC_OPTION_TCPSubset16             = 1048
%IDC_OPTION_TCPSubset32             = 1049
%IDC_OPTION_TCPSubset64             = 1050
%IDC_OPTION_TCPSubset128            = 1051
%IDC_OPTION_TCPSubset160            = 1052
%IDC_OPTION_TCPSubset256            = 1053
%IDC_LABEL12                        = 1054
%IDC_LABEL13                        = 1057
%IDC_COMBOBOX_EMGChannel            = 1055
%IDC_COMBOBOX_EEGChannel            = 1056
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

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

%SAMPLE_RATE = 512

GLOBAL hDlg AS DWORD
GLOBAL gIPAddress, gActiviewConfig AS ASCIIZ *512
GLOBAL gBytesInTCPArray, gChannelsSentByTCP, gTCPSamplesPerChannel AS LONG
GLOBAL gPort, gTCPSubset, gAdd8EXElectrodes, gAdd7Sensors, gAdd9Jazz, gAdd32AIBChan, gAddTriggerStatusChan AS LONG
GLOBAL gChannelsUsed, gSubsetBytes, gTotalBytes AS LONG

FUNCTION PBMAIN()
    LOCAL temp AS STRING
    LOCAL cmdCnt AS LONG

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gActiviewConfig = COMMAND$(1)
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    ELSE
        MSGBOX "No Actiview file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
    END IF

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
    %ICC_INTERNET_CLASSES)


    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL x, cnt, lResult, selectedCount, lbCount, selected AS LONG
    LOCAL TCPSocket AS LONG
    LOCAL temp AS STRING

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            CALL loadDefaults()
            lResult = calcByteForAllChannels()
            CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
            CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
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
                ' /* Inserted by PB/Forms 12-19-2013 14:04:43
                CASE %IDC_OPTION_TCPSubset8

                CASE %IDC_OPTION_TCPSubset16

                CASE %IDC_OPTION_TCPSubset32

                CASE %IDC_OPTION_TCPSubset64

                CASE %IDC_OPTION_TCPSubset128

                CASE %IDC_OPTION_TCPSubset160

                CASE %IDC_OPTION_TCPSubset256

                CASE %IDC_CHECKBOX_Add7Sensors

                CASE %IDC_CHECKBOX_Add9Jazz

                CASE %IDC_CHECKBOX_Add32AIBChan

                CASE %IDC_CHECKBOX_AddTriggerStatusChan

                CASE %IDC_COMBOBOX_EMGChannel

                CASE %IDC_COMBOBOX_EEGChannel
                ' */

                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg
                        FUNCTION = 1
                    END IF
                ' */

                ' /* Inserted by PB/Forms 10-31-2013 11:03:09
                CASE %IDC_OPTION_TCPSubset0, %IDC_OPTION_TCPSubset8, %IDC_OPTION_TCPSubset16, _
                        %IDC_OPTION_TCPSubset32, %IDC_OPTION_TCPSubset64, %IDC_OPTION_TCPSubset128, _
                        %IDC_OPTION_TCPSubset160, %IDC_OPTION_TCPSubset256
                        lResult = calcByteForAllChannels()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
                ' /* Inserted by PB/Forms 10-29-2013 15:06:37
                CASE %IDC_LISTBOX_ThrottledSampleRate
                ' */

                ' /* Inserted by PB/Forms 10-25-2013 11:19:49
                CASE %IDC_TEXTBOX_ThrottledSampleRate
                ' */



                ' /* Inserted by PB/Forms 10-18-2013 15:04:02
                CASE %IDC_LISTBOX_ChannelsToUse
                ' */


                ' /* Inserted by PB/Forms 10-18-2013 11:39:36
                ' /* Inserted by PB/Forms 10-18-2013 09:48:04

                CASE %IDC_CHECKBOX_Add8EXElectrodes, %IDC_CHECKBOX_Add7Sensors, %IDC_CHECKBOX_Add9Jazz, _
                        %IDC_CHECKBOX_Add32AIBChan, %IDC_CHECKBOX_AddTriggerStatusChan
                        lResult = calcByteForAllChannels()
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, TRIM$(STR$(lResult * gTCPSamplesPerChannel))
                        CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, TRIM$(STR$(lResult / 3))
                CASE %IDC_BUTTON_LoadDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL loadDefaults()
                    END IF

                CASE %IDC_BUTTON_SaveDefaults
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL saveDefaults()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 06-18-2013 09:38:13

                ' /* Inserted by PB/Forms 06-18-2013 08:55:14
                CASE %IDC_TEXTBOX_ReceiverTimeout
                ' */

                CASE %IDC_TEXTBOX_TCPServer

                CASE %IDC_TEXTBOX_TCPPort

                CASE %IDC_TEXTBOX_BytesInTCPArray

                CASE %IDC_TEXTBOX_ChannelsSentByTCP

                CASE %IDC_TEXTBOX_TCPSamplesPerChannel


                CASE %IDC_LISTBOX_RecvBuffer

            END SELECT
            CASE %WM_DESTROY
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------


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


SUB buildChannelsToUse()
    LOCAL idx, lResult, x, y, lPtr AS LONG
    LOCAL labl AS ASCIIZ * 256
    LOCAL temp AS ASCIIZ * 256


    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset0 TO lResult
    IF (lResult = 1) THEN
        lPtr = 0
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset8 TO lResult
    IF (lResult = 1) THEN
        lPtr = 8
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset16 TO lResult
    IF (lResult = 1) THEN
        lPtr = 16
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset32 TO lResult
    IF (lResult = 1) THEN
        lPtr = 32
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset64 TO lResult
    IF (lResult = 1) THEN
        lPtr = 64
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset128 TO lResult
    IF (lResult = 1) THEN
        lPtr = 128
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset160 TO lResult
    IF (lResult = 1) THEN
        lPtr = 160
    END IF
    CONTROL GET CHECK hDlg, %IDC_OPTION_TCPSubset256 TO lResult
    IF (lResult = 1) THEN
        lPtr = 256
    END IF

    LISTBOX RESET hDlg, %IDC_LISTBOX_ChannelsToUse

    IF (lPtr > 0) THEN
        FOR x = 1 TO lPtr
           temp = "Chan" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EMGChannel, temp + "=" + labl
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EEGChannel, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add8EXElectrodes TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 8
           temp = "Tou" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EMGChannel, temp + "=" + labl
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EEGChannel, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add7Sensors TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 7
           temp = "Aux" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EMGChannel, temp + "=" + labl
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EEGChannel, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add9Jazz TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 9
           temp = "Jazz" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EMGChannel, temp + "=" + labl
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EEGChannel, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_Add32AIBChan TO lResult
    IF (lResult = 1) THEN
        FOR x = 1 TO 32
           temp = "Box" + FORMAT$(x, "###")
           GetPrivateProfileString("Labels", temp, "", labl, 2048, gActiviewConfig)
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EMGChannel, temp + "=" + labl
           COMBOBOX ADD hDlg, %IDC_COMBOBOX_EEGChannel, temp + "=" + labl
        NEXT x
    END IF

    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_AddTriggerStatusChan TO lResult
    IF (lResult = 1) THEN
    END IF

END SUB


SUB loadDefaults()
    LOCAL x, selected AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "TCPIPSettings.ini"

    GetPrivateProfileString("OPTIONS", "ActiviewConfig", "", gActiviewConfig, 2048, filename)

    IF (ISFILE(gActiviewConfig) = 0) THEN
        MSGBOX "The default Biosemi config file was not found."
    END IF


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
    gTCPSubset = VAL(temp) + 1
    SELECT CASE gTCPSubset
        CASE 1
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset256, 1
        CASE 2
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset160, 1
        CASE 3
            CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset128, 1
        CASE 4
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset64, 1
        CASE 5
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset32, 1
        CASE 6
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset160, 1
        CASE 7
           CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset8, 1
        CASE 8
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

    GetPrivateProfileString("OPTIONS", "ThrottledSampleRate", "0", temp, 2048, filename)
    CONTROL SET TEXT hDlg, %IDC_LISTBOX_ThrottledSampleRate, temp

    CALL buildChannelsToUse()

    GetPrivateProfileString("OPTIONS", "ChannelsUsed", "", temp, 2048, filename)
    gChannelsUsed = PARSECOUNT(temp, ",") - 1

    IF (gChannelsUsed > 0) THEN
        FOR x = 1 TO gChannelsUsed
            selected = VAL(PARSE$(temp, ",", x))
            COMBOBOX SELECT hDlg, %IDC_LISTBOX_EMGChannel, selected
            COMBOBOX SELECT hDlg, %IDC_LISTBOX_EEGChannel, selected
        NEXT x
    END IF

END SUB

SUB saveDefaults()
    LOCAL x, idx, lPtr, lResult, lbCount, cnt, selected AS LONG
    LOCAL temp AS ASCIIZ * 255
    LOCAL filename AS ASCIIZ * 512

    filename = EXE.PATH$ + "TCPIPSettings.ini"

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

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ThrottledSampleRate TO lbCount
    temp = ""
    FOR x = 1 TO lbCount
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ThrottledSampleRate, x TO selected
        IF (selected = -1) THEN  'if selected
            LISTBOX GET TEXT hDlg, %IDC_LISTBOX_ThrottledSampleRate, x TO temp
            EXIT FOR
        END IF
    NEXT x
    'REDIM selectedChannels(gChannelsUsed)
    WritePrivateProfileString("OPTIONS", "ThrottledSampleRate", TRIM$(temp), filename)

    LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO gChannelsUsed
    'REDIM selectedChannels(gChannelsUsed)

    LISTBOX GET COUNT hDlg, %IDC_LISTBOX_ChannelsToUse TO lbCount
    cnt = 0
    temp = ""
    FOR x = 1 TO lbCount
        LISTBOX GET STATE hDlg, %IDC_LISTBOX_ChannelsToUse, x TO selected
        IF (selected = -1) THEN  'if selected
            INCR cnt
            temp = temp + STR$(x) + ","
        END IF
    NEXT x

    WritePrivateProfileString("OPTIONS", "ChannelsUsed", TRIM$(temp), filename)

    MSGBOX "Defaults saved."
END SUB


FUNCTION SampleListBoxThrottled(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL idx AS LONG

    CONTROL SEND hDlg, %IDC_LISTBOX_ThrottledSampleRate, %CB_SETEXTENDEDUI, %TRUE, 0

    LISTBOX ADD hDlg, %IDC_LISTBOX_ThrottledSampleRate, "32" TO idx
    LISTBOX ADD hDlg, %IDC_LISTBOX_ThrottledSampleRate, "64" TO idx
    LISTBOX ADD hDlg, %IDC_LISTBOX_ThrottledSampleRate, "128" TO idx
    LISTBOX ADD hDlg, %IDC_LISTBOX_ThrottledSampleRate, "256" TO idx

    CONTROL SET TEXT hDlg, %IDC_LISTBOX_ThrottledSampleRate, "64"
END FUNCTION

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, hParent, "TCP/IP Settings", 230, 105, 811, 553, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR _
        %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_CONTEXTHELP _
        OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
        %WS_EX_CONTROLPARENT OR %WS_EX_CONTEXTHELP OR %WS_EX_TOOLWINDOW OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_ThrottledSampleRate, , 648, 64, _
        112, 96, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPServer, "", 215, 32, 187, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPPort, "", 485, 32, 82, 24
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_BytesInTCPArray, "", 216, 73, _
        83, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ReceiverTimeout, "60000", 467, _
        74, 82, 25
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, "", 217, 107, _
        83, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, "", 217, _
        139, 83, 26, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset0, "None    (0)", 55, _
        220, 112, 24
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset8, "A1-A8   (8)", 55, _
        244, 112, 24
    ' %WS_GROUP...
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset16, "A1-A16   (16)", 55, _
        268, 112, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP _
        OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset32, "A1-A32   (32)", 55, _
        292, 112, 24
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset64, "A1-B32   (64)", _
        191, 220, 112, 24
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset128, "A1-D32   (128)", _
        191, 244, 128, 24
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset160, "A1-E32   (160)", _
        191, 268, 128, 24
    CONTROL ADD OPTION,   hDlg, %IDC_OPTION_TCPSubset256, "A1-H32   (256)", _
        191, 292, 128, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add8EXElectrodes, "Add 8 EX " + _
        "electrodes", 360, 200, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add7Sensors, "Add 7 Sensors", _
        360, 224, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add9Jazz, "Add 9 Jazz", 360, _
        248, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_Add32AIBChan, "Add 32 AIB " + _
        "Chan", 360, 272, 200, 24
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, "Add " + _
        "Trigger/Status Chan", 360, 296, 200, 24
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_LoadDefaults, "Load Defaults", _
        216, 496, 105, 41
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_SaveDefaults, "Save Defaults", _
        328, 496, 105, 41
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "Actiview TCP Server IP:", 19, _
        32, 188, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL2, "Port:", 425, 32, 52, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL3, "Bytes in TCP Array:", 66, 73, _
        144, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL4, "Channels sent by TCP:", 12, _
        105, 199, 26, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "TCP Samples/channel:", 42, 139, _
        169, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "Actiview Server Information", _
        14, 8, 600, 344
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL7, "Receiver Timeout:", 317, 74, _
        144, 25, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL11, "Throttled Sample rate:", 624, _
        24, 160, 40
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME2, "TCP Subset", 39, 192, 296, 152
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Close, "Close", 440, 496, 105, 41
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL12, "EMG Channel:", 40, 368, 112, _
        40
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_EMGChannel, , 146, 368, 88, 96
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_EEGChannel, , 396, 368, 88, 96
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL13, "EEG Channel:", 284, 368, 112, _
        40

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_LISTBOX_ThrottledSampleRate, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPServer, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPPort, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_BytesInTCPArray, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ReceiverTimeout, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, hFont1
    CONTROL SET FONT hDlg, %IDC_TEXTBOX_TCPSamplesPerChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset0, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset8, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset16, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset32, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset64, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset128, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset160, hFont2
    CONTROL SET FONT hDlg, %IDC_OPTION_TCPSubset256, hFont2
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add8EXElectrodes, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add7Sensors, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add9Jazz, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_Add32AIBChan, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_AddTriggerStatusChan, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_LoadDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_SaveDefaults, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL2, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL3, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL4, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL7, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL11, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME2, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL12, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_EMGChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_EEGChannel, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL13, hFont1
#PBFORMS END DIALOG

    SampleListBoxThrottled  hDlg, %IDC_LISTBOX_ThrottledSampleRate, 4
    'CONTROL SET CHECK hDlg, %IDC_OPTION_TCPSubset0, 1
    gTotalBytes = 0
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_BytesInTCPArray, "0"
    CONTROL SET TEXT hDlg, %IDC_TEXTBOX_ChannelsSentByTCP, "0"

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
