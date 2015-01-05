DECLARE CALLBACK FUNCTION ShowDIALOGEvenOddRNGProc()
DECLARE FUNCTION ShowDIALOGEvenOddRNG(BYVAL hParent AS DWORD) AS LONG

GLOBAL rngInt AS EvenOddRNGInterface
GLOBAL hDlgHiddenRNGWindow AS DWORD

FUNCTION ShowDIALOGEvenOddRNG(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
'    LOCAL hDlg  AS DWORD

    DIALOG NEW hParent, "Dialog1", 70, 70, 201, 121, TO hDlgHiddenRNGWindow
#PBFORMS END DIALOG

    DIALOG SHOW STATE hDlgHiddenRNGWindow, %SW_HIDE
    DIALOG SHOW MODELESS hDlgHiddenRNGWindow, CALL ShowDIALOGEvenOddRNGProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION

CALLBACK FUNCTION ShowDIALOGEvenOddRNGProc()
LOCAL dur AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            dur = rngInt.GetDuration()

            rngInt.PrintHeaders()

            CALL SetTimer(hDlgHiddenRNGWindow, BYVAL &H0000FEED, dur, BYVAL %NULL)

         CASE %WM_DESTROY
            KillTimer hDlgHiddenRNGWindow, &H0000FEED
            PostQuitMessage 0

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

            END SELECT
        CASE %WM_TIMER
            #DEBUG PRINT "GETRESULT"
            rngInt.GetResults()
    END SELECT
END FUNCTION
