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

'#COMPILE EXE
'#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
'#RESOURCE "BiosemiRecording.pbr"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG_BiosemiRecording = 7301
%IDC_BUTTON_StartVideo       = 7301
%IDC_BUTTON_SyncVideo        = 7302
%IDC_LABEL1                  = 7304
%IDC_TEXTBOX_BiosemiOffset   = 7303
%IDC_LABEL2                  = 7305
%IDC_LABEL3                  = 7306
%IDC_BUTTON_StartExperiment  = 7307
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------


GLOBAL ghDlgBiosemiRecording   AS DWORD
GLOBAL glSyncVideo AS LONG

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG_BiosemiRecordingProc()
DECLARE FUNCTION ShowDIALOG_BiosemiRecording(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_BiosemiRecordingProc()
    LOCAL temp AS STRING
    LOCAL pid AS DWORD
    LOCAL MyTime AS IPOWERTIME
    LOCAL now AS QUAD


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
                CASE %IDC_BUTTON_StartVideo
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        pid = SHELL("E:\Program Files\Active WebCam\WebCam.exe", 1)
                        CONTROL ENABLE ghDlgBiosemiRecording, %IDC_BUTTON_SyncVideo


                        SLEEP 5000


                        '**********************************************************************************************
                        'Added a SyncVideo event  5/21/2014 - FAA
                        '**********************************************************************************************
                        LET MyTime = CLASS "PowerTime"

                        MyTime.Now()
                        MyTime.FileTime TO now
                           'iVPos = 200
                        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
                        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
                        EVENTSANDCONDITIONS(5).EvtName = "SyncVideo"
                        EVENTSANDCONDITIONS(5).NbrOfGVars = 0
                        EVENTSANDCONDITIONS(5).Index = globals.DioIndex
                        EVENTSANDCONDITIONS(5).GrayCode = globals.GreyCode
                        EVENTSANDCONDITIONS(5).ClockTime = globals.TargetTime
                        EVENTSANDCONDITIONS(5).EventTime = PowerTimeDateTime(MyTime)

                        EVENTSANDCONDITIONS(5).GVars(0).Condition = "VOFFSET"
                        EVENTSANDCONDITIONS(5).GVars(0).Desc = "START"

                        CALL WriteToEventFile2(5)
                    END IF

                CASE %IDC_BUTTON_SyncVideo
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CONTROL DISABLE ghDlgBiosemiRecording, %IDC_BUTTON_StartVideo

                        '**********************************************************************************************
                        'Added a SyncVideo event  5/21/2014 - FAA
                        '**********************************************************************************************
                        LET MyTime = CLASS "PowerTime"

                        MyTime.Now()
                        MyTime.FileTime TO now
                           'iVPos = 200
                        globals.DioIndex = DIOWrite(globals.DioCardPresent, globals.BoardNum, globals.GreyCode)
                        globals.TargetTime = FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))
                        EVENTSANDCONDITIONS(5).EvtName = "SyncVideo"
                        EVENTSANDCONDITIONS(5).NbrOfGVars = 0
                        EVENTSANDCONDITIONS(5).Index = globals.DioIndex
                        EVENTSANDCONDITIONS(5).GrayCode = globals.GreyCode
                        EVENTSANDCONDITIONS(5).ClockTime = globals.TargetTime
                        EVENTSANDCONDITIONS(5).EventTime = PowerTimeDateTime(MyTime)

                        EVENTSANDCONDITIONS(5).GVars(0).Condition = "VOFFSET"
                        EVENTSANDCONDITIONS(5).GVars(0).Desc = "SYNC"

                        CALL WriteToEventFile2(5)
                    END IF

                CASE %IDC_TEXTBOX_BiosemiOffset

                CASE %IDC_BUTTON_StartExperiment
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                        DIALOG END ghDlgBiosemiRecording, 1
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG_BiosemiRecording(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_BiosemiRecording->->
    'LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW hParent, "Biosemi is Recording", 70, 70, 310, 198, %WS_POPUP _
        OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_CENTER OR _
        %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO _
        ghDlgBiosemiRecording
    CONTROL ADD BUTTON, ghDlgBiosemiRecording, %IDC_BUTTON_StartVideo, "Start Video", 95, 68, _
        110, 26
    CONTROL ADD BUTTON, ghDlgBiosemiRecording, %IDC_BUTTON_SyncVideo, "Sync Video (Optional)", _
        95, 96, 110, 25
    CONTROL ADD LABEL,  ghDlgBiosemiRecording, %IDC_LABEL2, "Wait for the Biosemi voice " + _
        "notification", 30, 10, 265, 20
    CONTROL ADD LABEL,  ghDlgBiosemiRecording, %IDC_LABEL3, "before proceeding to protocol.", _
        30, 30, 265, 20
    CONTROL ADD BUTTON, ghDlgBiosemiRecording, %IDC_BUTTON_StartExperiment, "Start " + _
        "Experiment", 95, 165, 110, 26

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 16, 1, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT ghDlgBiosemiRecording, -1, hFont1
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_BUTTON_StartVideo, hFont1
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_BUTTON_SyncVideo, hFont1
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_TEXTBOX_BiosemiOffset, hFont1
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_LABEL1, hFont1
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_LABEL2, hFont2
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_LABEL3, hFont2
    CONTROL SET FONT ghDlgBiosemiRecording, %IDC_BUTTON_StartExperiment, hFont1
#PBFORMS END DIALOG

    CONTROL DISABLE ghDlgBiosemiRecording, %IDC_BUTTON_SyncVideo

    DIALOG SHOW MODAL ghDlgBiosemiRecording, CALL ShowDIALOG_BiosemiRecordingProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_BiosemiRecording
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
