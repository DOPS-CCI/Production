'An online ScrollBar control tutorial may be found at:
'http://www.garybeene.com/power/pb-tutor-controls.htm

'Primary Code:
'Syntax:  Control Add ScrollBar, hDlg, id&, txt$, x, y, xx, yy [, [style&] [, [exstyle&]]] [[,] Call CallBack]
'Control Add ScrollBar, hDlg, 100,"", 50,50,100,20

'Compilable Example:
'The following compilable code demonstrates a dialog with a Scrollbar control.
'The Dialog CallBack response to clicking the is demonstrated.
'Controls can also have a Callback function of their own.
#COMPILE EXE
#DIM ALL
GLOBAL hDlg AS DWORD
FUNCTION PBMAIN() AS LONG
  DIALOG NEW PIXELS, 0, "Scrollbar Test",300,300,200,200, %WS_SYSMENU, 0 TO hDlg
  CONTROL ADD SCROLLBAR, hDlg, 100,"", 50,50,100,20

  SCROLLBAR SET RANGE hDlg, 100, 0, 100

  DIALOG SHOW MODAL hDlg CALL DlgProc
END FUNCTION

CALLBACK FUNCTION DlgProc() AS LONG
    LOCAL datav, LoDatav, HiDatav AS LONG
    STATIC scrollPos AS LONG
    SCROLLBAR GET RANGE hDlg, 100 TO LoDatav, HiDatav

  IF CB.MSG = %WM_HSCROLL THEN
        SELECT CASE LO(WORD, CB.WPARAM)
           CASE %SB_LINELEFT
              SCROLLBAR GET TRACKPOS hDlg, 100 TO scrollPos
              DECR scrollPos
              SCROLLBAR SET POS hDlg, 100, scrollPos
           CASE %SB_LINERIGHT
              SCROLLBAR GET TRACKPOS hDlg, 100 TO scrollPos
              INCR scrollPos
              SCROLLBAR SET POS hDlg, 100, scrollPos
           CASE %SB_THUMBTRACK     'scroll box
               'msgbox "Thumb Track"
           CASE %SB_THUMBPOSITION  'scroll box
               SCROLLBAR GET TRACKPOS hDlg, 100 TO scrollPos
               MSGBOX STR$(scrollPos)
              SCROLLBAR SET POS hDlg, 100, scrollPos



        END SELECT
  END IF
END FUNCTION

'gbs_00100
