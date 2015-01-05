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
'#RESOURCE "TrackbarTest.pbr"
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
%IDC_MSCTLS_TRACKBAR32_1 = 1001
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL hndTrackbar AS DWORD
GLOBAL gTrack, gTrackCur AS SINGLE

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
    GLOBAL hndTrackbar AS DWORD
    LOCAL newPos, selStart, selEnd AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler
            hndTrackbar = GetDlgItem(hDlg, %IDC_MSCTLS_TRACKBAR32_1)
            SendMessage(hndTrackbar, %TBM_SETRANGE,  %TRUE,  MAK(LONG, 1, 100))  'min. & max. positions

            SendMessage(hndTrackbar, %TBM_SETPAGESIZE,  0,  10)                  'NEW PAGE SIZE

            '%TBM_SETSEL has to do with %SB_PAGELEFT and %SB_PAGERIGHT values
            SendMessage(hndTrackbar, %TBM_SETSEL, %FALSE, MAK(LONG, 1, 10))

            SendMessage(hndTrackbar, %TBM_SETPOS, %TRUE,  1)

            SetFocus(hndTrackbar)

            gTrack = 0

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
            SELECT CASE LOWRD(CB.WPARAM)
                CASE %SB_PAGELEFT
                    'gTrack = gTrack - 10
                    '#DEBUG PRINT "%SB_PAGELEFT: " + STR$(gTrack)
                CASE %SB_PAGERIGHT
                    'gTrack = gTrack + 10
                    '#DEBUG PRINT "%SB_PAGERIGHT: " + STR$(gTrack)
                CASE %SB_THUMBTRACK
                    gTrackCur = HIWRD(CB.WPARAM)/1
                    #DEBUG PRINT "%SB_THUMBTRACK: " + STR$(gTrackCur)
            END SELECT
            'gTrackCur = gTrack
            'gTrack = MAX(1, MIN(1, gTrack))
            '#DEBUG PRINT "gTrack: " + STR$(gTrack)

            'SetScrollPos hndTrackbar, %SB_CTL, CLNG(gTrack * 1), %TRUE

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_MSCTLS_TRACKBAR32_1


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

    DIALOG NEW hParent, "Dialog1", 70, 70, 201, 121, %WS_POPUP OR %WS_BORDER _
        OR %WS_DLGFRAME OR %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX _
        OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK _
        OR %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD "msctls_trackbar32", hDlg, %IDC_MSCTLS_TRACKBAR32_1, _
        "msctls_trackbar32_1", 30, 60, 120, 30, %WS_CHILD OR %WS_VISIBLE OR _
        %TBS_HORZ OR %TBS_BOTTOM
#PBFORMS END DIALOG


    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------
