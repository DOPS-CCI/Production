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
#RESOURCE "GenericHealing.pbr"
'#RESOURCE "PlayWaveAsynch.pbr"
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1 =  101
%IDC_BUTTON1 = 1001
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG

GLOBAL hDlg AS DWORD
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'#RESOURCE wave, 2001, "Sounds\Focus2.wav"



'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    PLAY WAVE COMMAND$, SYNCH TO result
    PLAY WAVE END
    'ShowDIALOG1 %HWND_DESKTOP


    'DIALOG END hDlg

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL result AS LONG
    LOCAL resData AS ASCIIZ * 127

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
             PLAY WAVE COMMAND$, SYNCH TO result
             PLAY WAVE END
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
                CASE %IDC_BUTTON1
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        'resData = resource$(STRING, %FOCUS2_ID)
                        'result = sndPlaySoundA (resData, &H1)  'once, in background

                        'MSGBOX "DONE"
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg  AS DWORD

    DIALOG NEW hParent, "Dialog1", 70, 70, 201, 121, TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON1, "Button1", 65, 95, 60, 20
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
