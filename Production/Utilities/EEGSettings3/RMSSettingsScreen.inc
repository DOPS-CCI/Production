#PBFORMS CREATED V2.01

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
'#RESOURCE "RMSSettingsScreen.pbr"
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
%IDD_DIALOG_RMS                =  101
%IDC_LABEL1902                 = 1902
%IDC_BUTTON_AddRMSChannels     = 1903
%IDC_BUTTON_RemoveRMSChannels  = 1904
%IDC_LABEL1906                 = 1906
%IDC_CHECKBOX_UseScaleFactor   = 1907
%IDC_LABEL_ScaleFactor         = 1908
%IDC_TEXTBOX_ScaleFactor       = 1909
%IDC_TEXTBOX_RMSLowerThreshold = 1910
%IDC_TEXTBOX_RMSUpperThreshold = 1912
%IDC_LISTBOX_EEGChannelsForRMS = 1905
%IDC_LISTBOX_FBEEGChannels     = 1901
%IDC_BUTTON_OK                 = 1915
%IDC_BUTTON_Cancel2            = 1916
%IDC_TEXTBOX_EEGGain           = 1917
%IDC_TEXTBOX_AIBGain           = 1919
%IDC_FRAME_ChooseGain          = 1921
%IDC_OPTION_EEGGain            = 1922
%IDC_OPTION_AIBGain            = 1923
%IDC_FRAME_Threshold           = 1924
%IDC_OPTION_UseLowerThreshold  = 1926
%IDC_OPTION_UseUpperThreshold  = 1927
%IDC_TEXTBOX_OtherGain         = 1932
%IDC_OPTION_OtherGain          = 1931
%IDC_OPTION_UseInitialValue    = 1925
%IDC_COMBOBOX_Misc             = 1933
%IDC_LABEL1934                 = 1934
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG_RMSProc()
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE SUB ShowDIALOG_RMS(hParent AS DWORD)
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

%MAXPPS_SIZE = 2048


GLOBAL gDefaultFilename AS ASCIIZ *256
GLOBAL ghRMSSettingsDlg AS DWORD
GLOBAL gChannelsUsed AS BYTE

GLOBAL TCPIPSettings AS TCPIPDef
GLOBAL TCPIPBuffer AS TCPIPBuf

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_RMSProc()
    LOCAL lResult AS LONG
    LOCAL temp AS STRING

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
                ' /* Inserted by PB/Forms 03-31-2014 07:14:01
                CASE %IDC_COMBOBOX_Misc
                ' */

                ' /* Inserted by PB/Forms 03-27-2014 08:07:07
                CASE %IDC_OPTION_UseInitialValue

                CASE %IDC_LISTBOX_EEGChannelsForRMS

                CASE %IDC_OPTION_OtherGain

                CASE %IDC_TEXTBOX_OtherGain
                ' */


                ' /* Inserted by PB/Forms 03-20-2014 14:59:52
                CASE %IDC_OPTION_UseInitialValue

                CASE %IDC_OPTION_UseLowerThreshold

                CASE %IDC_OPTION_UseUpperThreshold
                ' */

                ' /* Inserted by PB/Forms 03-20-2014 09:35:13
                CASE %IDC_TEXTBOX_EEGGain

                CASE %IDC_TEXTBOX_AIBGain

                CASE %IDC_OPTION_EEGGain

                CASE %IDC_OPTION_AIBGain
                ' */

                CASE %IDC_LISTBOX_FBEEGChannels

                CASE %IDC_BUTTON_AddRMSChannels
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL AddEEGChannels()
                    END IF

                CASE %IDC_BUTTON_RemoveRMSChannels
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL RemoveEEGChannels()
                    END IF


                CASE %IDC_CHECKBOX_UseScaleFactor
                    CONTROL GET CHECK ghRMSSettingsDlg, %IDC_CHECKBOX_UseScaleFactor TO lResult
                    IF (lResult = 1) THEN   'checked
                        CONTROL NORMALIZE ghRMSSettingsDlg, %IDC_LABEL_ScaleFactor
                        CONTROL NORMALIZE ghRMSSettingsDlg, %IDC_TEXTBOX_ScaleFactor
                    ELSE
                        CONTROL HIDE ghRMSSettingsDlg, %IDC_LABEL_ScaleFactor
                        CONTROL HIDE ghRMSSettingsDlg, %IDC_TEXTBOX_ScaleFactor
                    END IF

                CASE %IDC_TEXTBOX_ScaleFactor

                CASE %IDC_TEXTBOX_RMSLowerThreshold

                CASE %IDC_TEXTBOX_RMSUpperThreshold

                CASE %IDC_BUTTON_OK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CALL SaveSettings()

                        CALL FillRMSChannelsToUse()

                        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue TO lResult
                        IF (lResult = 1) THEN 'checked
                            TCPIPBuffer.UseThreshold = 1
                        END IF
                        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold TO lResult
                        IF (lResult = 1) THEN 'checked
                            TCPIPBuffer.UseThreshold = 2
                            CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSLowerThreshold TO temp
                            TCPIPBuffer.ThresholdLower = VAL(temp)
                        END IF
                        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold TO lResult
                        IF (lResult = 1) THEN 'checked
                            TCPIPBuffer.UseThreshold = 3
                            CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSUpperThreshold TO temp
                            TCPIPBuffer.ThresholdUpper = VAL(temp)
                        END IF

                        gChannelsUsed = 1
                        DIALOG END ghRMSSettingsDlg, 1

                    END IF

                CASE %IDC_BUTTON_Cancel2
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "Nothing saved."
                        gChannelsUsed = 0
                        DIALOG END ghRMSSettingsDlg, -1
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB LoadSettings()
    LOCAL x, cnt, lResult AS LONG
    LOCAL eegGain, aibGain, otherGain, upper, lower AS DOUBLE
    LOCAL chooseGain, chooseThreshold AS BYTE
    LOCAL position AS QUAD
    LOCAL temp, temp2, lbItem AS ASCIIZ * 255



    GetPrivateProfileString("CHANNELS INFO", "ChooseGain", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    chooseGain = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "EEGGain", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    eegGain = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "AIBGain", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    aibGain = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "OtherGain", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    otherGain = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "ChooseThreshold", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    chooseThreshold = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "LowerThreshold", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    lower = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "UpperThreshold", "1", temp, %MAXPPS_SIZE, gDefaultFilename)
    upper = VAL(temp)

    GetPrivateProfileString("CHANNELS INFO", "ChannelsToProcess", "1", temp, %MAXPPS_SIZE, gDefaultFilename)

    LISTBOX RESET ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS
    IF (TRIM$(temp) <> "") THEN
        cnt = PARSECOUNT(temp, ",")
        IF (cnt > 0) THEN
            FOR x = 1 TO cnt
                lbItem = PARSE$(temp, x)
                GetPrivateProfileString("CHANNELS INFO", lbItem, "1", temp2, %MAXPPS_SIZE, gDefaultFilename)
                LISTBOX ADD ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, temp2 TO lResult
                LISTBOX SET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, lResult, VAL(lbItem)
            NEXT x
        END IF
    END IF



    SELECT CASE chooseGain
        CASE 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain, 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_OtherGain, 0
        CASE 2
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain, 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_OtherGain, 0
        CASE 3
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_OtherGain, 1
    END SELECT

    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_EEGGain, STR$(eegGain)
    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_AIBGain, STR$(aibGain)
    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_OtherGain, STR$(otherGain)

    SELECT CASE chooseThreshold
        CASE 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold, 0
        CASE 2
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold, 1
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold, 0
        CASE 3
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold, 0
            CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold, 1
    END SELECT

    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSLowerThreshold, STR$(lower)
    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSUpperThreshold, STR$(upper)

END SUB

SUB SaveSettings()
    LOCAL eegGain, aibGain, otherGain, upper, lower AS DOUBLE
    LOCAL chooseGain, chooseThreshold AS BYTE
    LOCAL x, lResult, lCnt, userData AS LONG
    LOCAL temp AS STRING



    CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain TO lResult
    IF (lResult = 1) THEN
        chooseGain = 1
    ELSE
        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain TO lResult
        IF (lResult = 1) THEN
            chooseGain = 2
        ELSE
            chooseGain = 3
        END IF
    END IF

    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_EEGGain TO temp
    eegGain = VAL(temp)
    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_AIBGain TO temp
    aibGain = VAL(temp)
    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_OtherGain TO temp
    otherGain = VAL(temp)


    CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue TO lResult

    IF (lResult = 1) THEN
        chooseThreshold = 1
    ELSE
        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold TO lResult
        IF (lResult = 1) THEN
            chooseThreshold = 2
        ELSE
            chooseThreshold = 3
        END IF
    END IF

    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSLowerThreshold TO temp
    lower = VAL(temp)
    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSUpperThreshold TO temp
    upper = VAL(temp)


    WritePrivateProfileString("CHANNELS INFO", "ChooseGain", STR$(chooseGain), gDefaultFilename)

    WritePrivateProfileString("CHANNELS INFO", "EEGGain", STR$(eegGain), gDefaultFilename)

    WritePrivateProfileString("CHANNELS INFO", "AIBGain", STR$(aibGain), gDefaultFilename)

    WritePrivateProfileString("CHANNELS INFO", "OtherGain", STR$(otherGain), gDefaultFilename)

    WritePrivateProfileString("CHANNELS INFO", "ChooseThreshold", STR$(chooseThreshold), gDefaultFilename)


    WritePrivateProfileString("CHANNELS INFO", "LowerThreshold", STR$(lower), gDefaultFilename)

    WritePrivateProfileString("CHANNELS INFO", "UpperThreshold", STR$(upper), gDefaultFilename)

    LISTBOX GET COUNT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS TO lCnt

    IF (lCnt > 0) THEN
        temp = ""
        FOR x = 1 TO lCnt
            LISTBOX GET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO userData
            temp = temp + TRIM$(STR$(userData)) + ","
        NEXT x
        temp = TRIM$(LEFT$(temp, LEN(temp) - 1))
    END IF

    WritePrivateProfileString("CHANNELS INFO", "ChannelsToProcess", temp + "", gDefaultFilename)


    LISTBOX GET COUNT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS TO lCnt

    IF (lCnt > 0) THEN
        temp = ""
        FOR x = 1 TO lCnt
            LISTBOX GET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO userData
            LISTBOX GET TEXT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO temp
            WritePrivateProfileString("CHANNELS INFO", STR$(userData), temp + "", gDefaultFilename)
        NEXT x
    END IF


    MSGBOX "RMS Settings saved."
END SUB

'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------
SUB EEGChannelsUsed()
    LOCAL x AS LONG

    FOR x = 1 TO TCPIPSettings.ChannelsToUse
        LISTBOX ADD ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, TCPIPSettings.ChannelsToUseArray(x)
    NEXT x
END SUB

SUB AddEEGChannels()
    LOCAL x, lResult, lCnt, lState AS LONG
    LOCAL temp AS STRING
    LOCAL EEGGain, AIBGain, OtherGain AS DOUBLE
    LOCAL Misc AS LONG

    CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain TO lResult
    IF (lResult = 1) THEN
        CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_EEGGain TO temp
        EEGGain = VAL(temp)
        AIBGain = 1
        OtherGain = 1
    ELSE
        CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain TO lResult
        IF (lResult = 1) THEN
            CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_AIBGain TO temp
            AIBGain = VAL(temp)
            EEGGain = 1
            OtherGain = 1
        ELSE
            CONTROL GET TEXT ghRMSSettingsDlg, %IDC_TEXTBOX_OtherGain TO temp
            OtherGain = VAL(temp)
            EEGGain = 1
            AIBGain = 1
        END IF
    END IF

    CONTROL GET TEXT ghRMSSettingsDlg, %IDC_COMBOBOX_Misc TO temp
    COMBOBOX GET COUNT ghRMSSettingsDlg, %IDC_COMBOBOX_Misc TO lCnt
    FOR x = 1 TO lCnt
        COMBOBOX FIND EXACT ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, x, temp TO lResult
        IF (lResult <> 0) THEN
            COMBOBOX GET USER ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, lResult TO Misc
            EXIT FOR
        END IF
    NEXT x


    LISTBOX GET COUNT ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels TO lCnt

    FOR x = 1 TO lCnt
        LISTBOX GET STATE ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, x TO lState
        IF (lState = -1) THEN   'selected
            CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_EEGGain TO lResult
            IF (lResult = 1) THEN
                temp = ""
                LISTBOX GET TEXT ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, x TO temp
                LISTBOX ADD ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, temp + ",GF=" + STR$(EEGGain) + ",MS=" + STR$(Misc) TO lResult
                LISTBOX SET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, lResult, x
            ELSE
                CONTROL GET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain TO lResult
                IF (lResult = 1) THEN
                    temp = ""
                    LISTBOX GET TEXT ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, x TO temp
                    LISTBOX ADD ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, temp + ",GF=" + STR$(AIBGain) + ",MS=" + STR$(Misc) TO lResult
                    LISTBOX SET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, lResult, x
                ELSE
                    temp = ""
                    LISTBOX GET TEXT ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, x TO temp
                    LISTBOX ADD ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, temp + ",GF=" + STR$(OtherGain) + ",MS=" + STR$(Misc) TO lResult
                    LISTBOX SET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, lResult, x
                END IF
            END IF
        END IF
    NEXT x



END SUB

SUB RemoveEEGChannels()
    LOCAL x, lResult, lCnt, lState AS LONG
    LOCAL temp AS STRING

    LISTBOX GET COUNT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS TO lCnt

    FOR x = 1 TO lCnt
        LISTBOX GET STATE ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO lState
        IF (lState = -1) THEN   'selected
            LISTBOX GET USER ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO lResult
            WritePrivateProfileString("CHANNELS INFO", STR$(lResult), "", gDefaultFilename)
            LISTBOX DELETE ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x
        END IF
    NEXT x
END SUB

SUB FillRMSChannelsToUse()
    LOCAL x, lResult, lCnt, lState AS LONG
    LOCAL temp, chanInfo, miscInfo, gainInfo AS STRING
    LOCAL chan, gain, misc AS STRING

    LISTBOX GET COUNT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS TO lCnt

    'REDIM RMSChannelsToUseArray(lCnt, 2)

    TCPIPBuffer.ChannelsToProcess = lCnt

    FOR x = 1 TO lCnt
        LISTBOX GET TEXT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, x TO temp
        chanInfo = PARSE$(temp, ",", 1)
        chan = TRIM$(chanInfo)
        gainInfo = PARSE$(temp, ",", 3)
        gain = PARSE$(gainInfo, "=", 2)
        miscInfo = PARSE$(temp, ",", 4)
        misc = PARSE$(miscInfo, "=", 2)

        TCPIPBuffer.ChannelsToProcessArray(x, 1) = VAL(chan)
        TCPIPBuffer.ChannelsToProcessArray(x, 2) = VAL(gain)
        TCPIPBuffer.ChannelsToProcessArray(x, 3) = VAL(misc)
    NEXT x
END SUB

SUB LoadMiscellaneous()
    LOCAL lResult AS LONG

    COMBOBOX ADD ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, "EEG" TO lResult
    COMBOBOX SET USER ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, lResult, 1
    COMBOBOX ADD ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, "EMG" TO lResult
    COMBOBOX SET USER ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, lResult, 2
    COMBOBOX ADD ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, "AIB" TO lResult
    COMBOBOX SET USER ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, lResult, 3

    CONTROL SET TEXT ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, "EEG"
END SUB

SUB processBuffer(BYVAL TCPSocket AS LONG)
    'dummy routine not used here
END SUB

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
SUB ShowDIALOG_RMS(hParent   AS DWORD)
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_RMS->->
    'LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, hParent, "Choose Feedback Settings", 70, 114, 890, _
        536, %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR _
        %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT _
        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO ghRMSSettingsDlg
    ' %WS_GROUP...
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_EEGGain, "EEG Gain", 328, 87, _
        136, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR _
        %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_AIBGain, "AIB Gain", 328, 123, _
        136, 24
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_OtherGain, "Other", 328, 159, _
        136, 24
    CONTROL ADD TEXTBOX,  ghRMSSettingsDlg, %IDC_TEXTBOX_OtherGain, "1.000", 480, 159, _
        79, 32
    CONTROL ADD BUTTON,   ghRMSSettingsDlg, %IDC_BUTTON_AddRMSChannels, "Add", 416, 280, _
        75, 33
    CONTROL ADD BUTTON,   ghRMSSettingsDlg, %IDC_BUTTON_RemoveRMSChannels, "Remove", 416, _
        319, 75, 32
    ' %WS_GROUP...
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, "Previous " + _
        "Trial", 35, 416, 122, 32, %WS_CHILD OR %WS_VISIBLE OR %WS_GROUP OR _
        %WS_TABSTOP OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR %BS_LEFT OR _
        %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold, "Lower " + _
        "Threshold", 264, 416, 142, 32
    CONTROL ADD TEXTBOX,  ghRMSSettingsDlg, %IDC_TEXTBOX_RMSLowerThreshold, "1", 416, _
        416, 83, 32
    CONTROL ADD OPTION,   ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold, "Upper " + _
        "Threshold", 520, 416, 142, 32
    CONTROL ADD TEXTBOX,  ghRMSSettingsDlg, %IDC_TEXTBOX_RMSUpperThreshold, "1", 672, _
        416, 83, 33
    CONTROL ADD BUTTON,   ghRMSSettingsDlg, %IDC_BUTTON_OK, "OK", 358, 496, 75, 32
    CONTROL ADD BUTTON,   ghRMSSettingsDlg, %IDC_BUTTON_Cancel2, "Cancel", 448, 496, 75, _
        32
    CONTROL ADD TEXTBOX,  ghRMSSettingsDlg, %IDC_TEXTBOX_EEGGain, "0.0312", 480, 87, 79, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  ghRMSSettingsDlg, %IDC_TEXTBOX_AIBGain, "0.125", 480, 123, 79, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_DISABLED OR %WS_TABSTOP OR _
        %ES_LEFT OR %ES_AUTOHSCROLL, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LISTBOX,  ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, , 8, 56, 288, _
        296, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD FRAME,    ghRMSSettingsDlg, %IDC_FRAME_ChooseGain, "Choose Gain", 312, _
        54, 264, 144
    CONTROL ADD LABEL,    ghRMSSettingsDlg, %IDC_LABEL1902, "Select Channels", 8, 24, _
        178, 24
    CONTROL ADD LISTBOX,  ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, , 592, 56, _
        288, 296, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,    ghRMSSettingsDlg, %IDC_LABEL1906, "Channels selected", 592, 24, _
        142, 24
    CONTROL ADD FRAME,    ghRMSSettingsDlg, %IDC_FRAME_Threshold, "Choose Threshold", 8, _
        384, 872, 96
    CONTROL ADD COMBOBOX, ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, , 432, 216, 144, 136
    CONTROL ADD LABEL,    ghRMSSettingsDlg, %IDC_LABEL1934, "Miscellaneous", 304, 216, _
        120, 24

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_EEGGain, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_AIBGain, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_OtherGain, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_TEXTBOX_OtherGain, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_BUTTON_AddRMSChannels, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_BUTTON_RemoveRMSChannels, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_UseLowerThreshold, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSLowerThreshold, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_OPTION_UseUpperThreshold, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_TEXTBOX_RMSUpperThreshold, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_BUTTON_OK, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_BUTTON_Cancel2, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_TEXTBOX_EEGGain, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_TEXTBOX_AIBGain, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_LISTBOX_FBEEGChannels, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_FRAME_ChooseGain, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_LABEL1902, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_LABEL1906, hFont2
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_FRAME_Threshold, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_COMBOBOX_Misc, hFont1
    CONTROL SET FONT ghRMSSettingsDlg, %IDC_LABEL1934, hFont1
#PBFORMS END DIALOG

    CONTROL HIDE ghRMSSettingsDlg, %IDC_LABEL_ScaleFactor
    CONTROL HIDE ghRMSSettingsDlg, %IDC_TEXTBOX_ScaleFactor

    CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_AIBGain, 1
    CONTROL SET CHECK ghRMSSettingsDlg, %IDC_OPTION_UseInitialValue, 1

    TCPIPBuffer.UseThreshold = 1

    CALL LoadMiscellaneous()

    CALL LoadSettings()

    CALL EEGChannelsUsed()
    'SampleListBox  ghRMSSettingsDlg, %IDC_LISTBOX_EEGChannelsForRMS, 30

    DIALOG SHOW MODAL ghRMSSettingsDlg, CALL ShowDIALOG_RMSProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_RMS
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP


END SUB
'------------------------------------------------------------------------------
