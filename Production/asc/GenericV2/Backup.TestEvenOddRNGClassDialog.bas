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
#RESOURCE "TestEvenOddRNGClassDialog.pbr"
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
%IDD_DIALOG1     =  101
%IDC_BUTTON_Test = 1001
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

#INCLUDE "EvenOddRNGClass.inc"

GLOBAL rngInt AS EvenOddRNGInterface
GLOBAL hDlg   AS DWORD
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


    'killMMTimerEvent()
    KillTimer hDlg, &H0000FEED
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL dur AS LONG

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

        CASE %WM_TIMER
            #DEBUG PRINT "GETRESULT"
            rngInt.GetResult()

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_Test
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN

                        DIM rngInt AS EvenOddRNGInterface
                        LET rngInt = CLASS "EvenOddRNGClass"
                        rngInt.SetDuration(1000)
                        rngInt.SetSampleSize(50)

                        dur = rngInt.GetDuration()

                        rngInt.PrintHeaders("ASCGeneric.ini")

                        'gTimers.Add("GETRESULT", vTimers)
                        'SetMMTimerDuration("GETRESULT", 1000)


                        'SetMMTimerOnOff("GETRESULT", 1)    'turn on
                        'setMMTimerEventPeriodic(1, 0)
                         CALL SetTimer(hDlg, BYVAL &H0000FEED, dur, BYVAL %NULL)

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
    'LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Test Even/Odd RNG Class", 70, 70, 321, 225, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_CAPTION OR _
        %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX OR _
        %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT _
        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_Test, "Test", 120, 100, 90, 30

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, -1, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Test, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

SUB DoWorkForEachTick()
     '#DEBUG PRINT "DoWorkForEachTick"
     '#DEBUG PRINT "gTimerSeconds: " + STR$(gTimerSeconds)
END SUB

SUB DoTimerWork(itemName AS WSTRING)
    LOCAL x AS LONG

    SELECT CASE itemName
        CASE "GETRESULT"
            #DEBUG PRINT "GETRESULT"
            'rngInt.GetResult()
    END SELECT
END SUB
