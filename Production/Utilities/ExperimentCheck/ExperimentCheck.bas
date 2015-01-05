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
'#RESOURCE "ExperimentCheck.pbr"
#RESOURCE ICON,     IDI_ICON1, "ExperimentCheck.ico"
#RESOURCE WAVE,     ENDEXPT_WAV, "EndExperiment.wav"

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
%IDD_DIALOG1           =  101
%IDC_BUTTON_Exit       = 1001
%IDC_LABEL_TrialNumber = 1002
%IDC_BUTTON_Check      = 1003
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL hDlg, ghThread   AS DWORD
GLOBAL gFilename AS STRING

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
    LOCAL result AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            CALL readTrialFile()
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
                ' /* Inserted by PB/Forms 05-01-2014 09:19:16
                CASE %IDC_BUTTON_Check
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       CALL readTrialFile()
                    END IF
                ' */

                CASE %IDC_BUTTON_Exit
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        THREAD CLOSE ghThread TO result
                        CLOSE #1
                        KILL gFilename
                        DIALOG END hDlg, 1
                    END IF

            END SELECT
    END SELECT
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

    DIALOG NEW hParent, "Experiment Check", 70, 70, 279, 198, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Exit, "Exit", 105, 165, 65, 25
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_TrialNumber, "", 30, 30, 230, 30
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Check, "Check", 105, 130, 65, 25

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial Narrow", 18, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_BUTTON_Exit, hFont1
    CONTROL SET FONT hDlg, %IDC_LABEL_TrialNumber, hFont2
    CONTROL SET FONT hDlg, %IDC_BUTTON_Check, hFont1
#PBFORMS END DIALOG
    DIALOG SET ICON hDlg, "IDI_ICON1"

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------


SUB readTrialFile()
    LOCAL result AS LONG
    LOCAL pid AS DWORD


    gFilename = "I:\TrialInfo.txt"

    result = ISFILE(gFilename)
    IF (result >= 0) THEN
        MSGBOX "Experiment hasn't started, yet. TrialFile.txt doesn't exist."
        EXIT SUB
    END IF

    pid = SHELL("C:\Program Files\Active WebCam\WebCam.exe",1)

    CONTROL DISABLE hDlg, %IDC_BUTTON_Check

    THREAD CREATE WorkerThread(result) TO ghThread

END SUB

FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG
    LOCAL temp AS STRING


    WHILE (1)
        temp = ""
        OPEN gFilename  FOR INPUT ACCESS READ LOCK SHARED  AS #1
        LINE INPUT #1, temp
        IF (TRIM$(temp) = "-999") THEN
            EXIT LOOP
        ELSE
            CONTROL SET TEXT hDlg, %IDC_LABEL_TrialNumber, "Trial # " + temp
            CONTROL REDRAW hDlg, %IDC_LABEL_TrialNumber
        END IF

        SLEEP 1000
        CLOSE #1
    WEND


    PlaySound "ENDEXPT_WAV", GetModuleHandle(BYVAL 0), %SND_RESOURCE OR %SND_ASYNC
    CLOSE #1
    MSGBOX "End of Experiment."

END FUNCTION

THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG

 FUNCTION = WorkerFunc(x)

END FUNCTION





THREAD FUNCTION MyThread (x AS LONG) AS LONG


END FUNCTION
