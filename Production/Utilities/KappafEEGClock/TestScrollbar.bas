#IF 0
    ----------------------------                      PowerBASIC v8.x
 ---|          DASoft          |------------------------------------------
    ----------------------------         CODE           DATE: 2006-02-11
    | FILE NAME  ScrollBar.bas |          by
    ----------------------------  Don Schullian, Jr.

              THIS CODE IS released into the Public Domain
       ----------------------------------------------------------
        No guarantee AS TO the viability, accuracy, OR safety OF
         use OF THIS CODE IS implied, warranted, OR guaranteed
       ----------------------------------------------------------
                         Use AT your own risk!
       ----------------------------------------------------------
                  CONTACT AUTHOR AT don@DASoftVSS.com
 -------------------------------------------------------------------------

I used THIS CODE TO test & learn the use OF scrollbars. Hope it helps.

#ENDIF

#COMPILE EXE
#COMPILER PBWIN
#INCLUDE "WIN32API.INC"

%ID_SCROLLv = 2000 ' By using a seperate callback we no longer need to
%ID_SCROLLh = 2011 ' keep the individual scrollbar ID's in any particular
%ID_SCROLL2 = 2102 ' order
'
'------------------------------------------------------------------------------
'
SUB UpdateLabel ( BYVAL hParent AS DWORD, _
                  BYVAL  CtrlID AS LONG , _
                  BYVAL tSB     AS SCROLLINFO PTR )

  DIM Flag AS LOCAL LONG
  DIM P    AS LOCAL CUX

  IF CtrlID = 0 THEN EXIT SUB

  CONTROL GET USER hParent, CtrlID, 8 TO Flag

  IF Flag THEN
      P = @tSB.nPos / @tSB.nMax
      P = MAX(P,0.01)
      P = MIN(P,1)
      CONTROL SET TEXT hParent, CtrlID, FORMAT$(P,"0%")
    ELSE
      CONTROL SET TEXT hParent, CtrlID, FORMAT$(@tSB.nPos)
  END IF

END SUB
'
'------------------------------------------------------------------------------
'
CALLBACK FUNCTION ScrollbarCallback

  DIM  Ctrl AS LOCAL LONG                                        ' CBLPARAM = handle of scrollbar
  DIM hCtrl AS LOCAL DWORD                                       ' CBLPARAM = handle of scrollbar
  DIM tSB   AS LOCAL SCROLLINFO PTR                              '
                                                                 '
  IF (CBMSG <> %WM_VSCROLL )  AND _                              '
     (CBMSG <> %WM_HSCROLL ) THEN EXIT FUNCTION                  ' not for us!
                                                                 '
  DIALOG GET USER CBLPARAM, 8 TO tSB                             ' get the UDT pointer
  SELECT CASE LOWRD(CBWPARAM)                                    ' get the hot command
    CASE %SB_LINEDOWN       : INCR @tSB.nPos                     '
    CASE %SB_PAGEDOWN       : @tSB.nPos = @tSB.nPos + @tSB.nPage '
    CASE %SB_LINEUP         : DECR @tSB.nPos                     '
    CASE %SB_PAGEUP         : @tSB.nPos = @tSB.nPos - @tSB.nPage '
    CASE %SB_THUMBPOSITION, _                                    '
         %SB_THUMBTRACK     : @tSB.nPos = HIWRD(CBWPARAM)        '
    CASE %SB_BOTTOM         : @tSB.nPos = @tSB.nMax              '
    CASE %SB_TOP            : @tSB.nPos = 1                      '
    CASE %SB_ENDSCROLL      : EXIT FUNCTION                      '
  END SELECT                                                     '
  @tSB.nPos = MAX(@tSB.nMin, @tSB.nPos)                          ' can't be less than minimum
  @tSB.nPos = MIN(@tSB.nMax, @tSB.nPos)                          ' can't be more than maximim
  DIALOG SEND CBLPARAM, %SBM_SETPOS, @tSB.nPos, %TRUE            '
  DIALOG GET USER CBLPARAM, 6 TO Ctrl                            ' get the label's handle
  UpdateLabel CBHNDL, Ctrl, tSB                                  ' do what it says
                                                                 '
  FUNCTION = 1                                                   ' send an 'I'm done' message to Windows

END FUNCTION
'
'------------------------------------------------------------------------------
'
CALLBACK FUNCTION DlgCallback

  DIM  Ctrl AS LOCAL LONG
  DIM tSB   AS LOCAL SCROLLINFO PTR

  SELECT CASE CBMSG
    CASE %WM_COMMAND : IF CBCTLMSG <> %BN_CLICKED THEN EXIT FUNCTION
                       CONTROL GET USER CBHNDL, CBCTL, 8 TO Ctrl                ' get the scrollbar's ctrlid
                       CONTROL GET USER CBHNDL, Ctrl,  8 TO tSB                 ' get the pointer to the UDT
                       CONTROL GET USER CBHNDL, CBCTL, 7 TO @tSB.nPos           ' get the pre-set value
                       CONTROL SEND CBHNDL, Ctrl, %SBM_SETPOS, @tSB.nPos, %TRUE ' set the scrollbar's new value
                       CONTROL GET USER CBHNDL, Ctrl, 6 TO Ctrl                 ' get label's CtrlID
                       UpdateLabel CBHNDL, Ctrl, tSB
  END SELECT

END FUNCTION
'
'------------------------------------------------------------------------------
'
FUNCTION PBMAIN

  DIM hDlg   AS LOCAL DWORD
  DIM tSB(2) AS LOCAL SCROLLINFO
  DIM  TXT   AS LOCAL STRING

  DIALOG NEW 0, "SCROLLBAR Test",,, 200, 100, %WS_SYSMENU OR %WS_CAPTION TO hDlg

  CONTROL ADD BUTTON, hDlg, 1001, "Set Min", 135,  5, 50, 13
  CONTROL SET USER    hDlg, 1001, 7, 1
  CONTROL SET USER    hDlg, 1001, 8, %ID_SCROLLv

  CONTROL ADD BUTTON, hDlg, 1002, "Set Max", 135, 20, 50, 13
  CONTROL SET USER    hDlg, 1002, 7, 100
  CONTROL SET USER    hDlg, 1002, 8, %ID_SCROLLv

  CONTROL ADD BUTTON, hDlg, 1003, "Set Min",   5, 75, 50, 13
  CONTROL SET USER    hDlg, 1003, 7, 1
  CONTROL SET USER    hDlg, 1003, 8, %ID_SCROLLh

  CONTROL ADD BUTTON, hDlg, 1004, "Set Max",  60, 75, 50, 13
  CONTROL SET USER    hDlg, 1004, 7, 200
  CONTROL SET USER    hDlg, 1004, 8, %ID_SCROLLh

  CONTROL ADD LABEL , hDlg, 1005, "50%"    , 135, 35, 50, 13, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER OR %SS_CENTERIMAGE, %WS_EX_LEFT OR %WS_EX_LTRREADING
  CONTROL SET COLOR   hDlg, 1005, %BLACK, %WHITE
  CONTROL SET USER    hDlg, 1005, 8, 1

  CONTROL ADD LABEL , hDlg, 1006, "50%"    , 115, 75, 50, 13, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER OR %SS_CENTERIMAGE, %WS_EX_LEFT OR %WS_EX_LTRREADING
  CONTROL SET COLOR   hDlg, 1006, %BLACK, %WHITE
  CONTROL SET USER    hDlg, 1006, 8, 1

  CONTROL ADD LABEL , hDlg, 1007, "1"      ,   5,  5, 15, 13, %WS_CHILD OR %WS_VISIBLE OR %WS_BORDER OR %SS_CENTER OR %SS_CENTERIMAGE, %WS_EX_LEFT OR %WS_EX_LTRREADING
  CONTROL SET COLOR   hDlg, 1007, %BLACK, %WHITE

  CONTROL ADD SCROLLBAR, hDlg, %ID_SCROLLv, "", 190, 0, 11, 100, %SBS_VERT OR %SBS_RIGHTALIGN, CALL ScrollbarCallback
  tSB(0).cbSize = SIZEOF(SCROLLINFO)                                        ' size of UDT
  tSB(0).fMask  = %SIF_ALL                                                  ' Sets nPage, nPos, nMin, and nMax
  tSB(0).nMin   =   1                                                       ' 1st position
  tSB(0).nMax   = 109                                                       ' Last position + nPage - 1
  tSB(0).nPage  =  10                                                       ' size of cursor block
  tSB(0).nPos   =  50                                                       ' starting position
  CONTROL SET USER hDlg, %ID_SCROLLv, 6, 1005                               ' store label's CtrlID
  CONTROL SET USER hDlg, %ID_SCROLLv, 8, VARPTR(tSB(0))                     ' store pointer to UDT
  CONTROL SEND hDlg, %ID_SCROLLv, %SBM_SETSCROLLINFO, %TRUE, VARPTR(tSB(0)) ' initialize the scrollbar & redraw
  tSB(0).nMax  = 100                                                        ' reset the max value

  CONTROL ADD SCROLLBAR, hDlg, %ID_SCROLLh, "", 0, 90, 189, 10, %SBS_HORZ OR %SBS_BOTTOMALIGN, CALL ScrollbarCallback
  tSB(1).cbSize = SIZEOF(SCROLLINFO)
  tSB(1).fMask  = %SIF_ALL
  tSB(1).nMin   =   1
  tSB(1).nMax   = 209
  tSB(1).nPage  =  10
  tSB(1).nPos   = 100
  CONTROL SET USER hDlg, %ID_SCROLLh, 6, 1006
  CONTROL SET USER hDlg, %ID_SCROLLh, 8, VARPTR(tSB(1))
  CONTROL SEND hDlg, %ID_SCROLLh, %SBM_SETSCROLLINFO, %TRUE, VARPTR(tSB(1))
  tSB(1).nMax  = 200

  CONTROL ADD SCROLLBAR, hDlg, %ID_SCROLL2, "", 20, 5, 20, 13, %SBS_VERT, CALL ScrollbarCallback
  tSB(2).cbSize = SIZEOF(SCROLLINFO)
  tSB(2).fMask  = %SIF_ALL
  tSB(2).nMin   =   1
  tSB(2).nMax   =  15
  tSB(2).nPage  =   1
  tSB(2).nPos   =   1
  CONTROL SET USER hDlg, %ID_SCROLL2, 6, 1007
  CONTROL SET USER hDlg, %ID_SCROLL2, 8, VARPTR(tSB(2))
  CONTROL SEND hDlg, %ID_SCROLL2, %SBM_SETSCROLLINFO, %TRUE, VARPTR(tSB(2))

  DIALOG SHOW MODAL hDlg CALL DlgCallback

  TXT = "Vert Scrollbar" & STR$(tSB(0).nPos) & $CRLF & _
        "Horz Scrollbar" & STR$(tSB(1).nPos) & $CRLF & _
        "Scrollbar2"     & STR$(tSB(2).nPos)
  MSGBOX TXT, %MB_OK, "Results"

END FUNCTION
