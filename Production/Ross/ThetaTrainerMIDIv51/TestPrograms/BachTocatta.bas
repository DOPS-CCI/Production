' ========================================================================================
' BACHTOCC.BAS
' This program is a translation/adaptation of BACHTOCC.C -- Bach Toccata in D Minor
' (First Bar) © Charles Petzold, 1998, described and analysed in Chapter 22 of the book
' Programming Windows, 5th Edition.
' Plays the first measure of the toccata section of J. S. Bach's famous Toccata and Fugue
' in D Minor for organ.
' ========================================================================================

#COMPILE EXE
#DIM ALL
#INCLUDE ONCE "windows.inc"

TYPE NOTESEQ_STRUCT
   iDur AS LONG
   iNote(0 TO 1) AS LONG
END TYPE

%ID_TIMER = 1

' ========================================================================================
' Main
' ========================================================================================
FUNCTION WINMAIN (BYVAL hInstance AS DWORD, BYVAL hPrevInstance AS DWORD, _
                  BYVAL pszCmdLine AS WSTRINGZ PTR, BYVAL iCmdShow AS LONG) AS LONG

   LOCAL hwnd      AS DWORD
   LOCAL szAppName AS ASCIIZ * 256
   LOCAL wcex      AS WNDCLASSEX
   LOCAL szCaption AS ASCIIZ * 256

   szAppName          = "BachTocc"
   wcex.cbSize        = SIZEOF(wcex)
   wcex.style         = %CS_HREDRAW OR %CS_VREDRAW
   wcex.lpfnWndProc   = CODEPTR(WndProc)
   wcex.cbClsExtra    = 0
   wcex.cbWndExtra    = 0
   wcex.hInstance     = hInstance
   wcex.hIcon         = LoadIcon(%NULL, BYVAL %IDI_APPLICATION)
   wcex.hCursor       = LoadCursor(%NULL, BYVAL %IDC_ARROW)
   wcex.hbrBackground = GetStockObject(%WHITE_BRUSH)
   wcex.lpszMenuName  = %NULL
   wcex.lpszClassName = VARPTR(szAppName)

   IF ISFALSE RegisterClassEx(wcex) THEN
      FUNCTION = %TRUE
      EXIT FUNCTION
   END IF

   szCaption = "Bach Toccata in D Minor (First Bar)"
   hwnd = CreateWindowEx(%WS_EX_CONTROLPARENT, _   ' extended style
                         szAppName, _              ' window class name
                         szCaption, _              ' window caption
                         %WS_OVERLAPPEDWINDOW, _   ' window style
                         %CW_USEDEFAULT, _         ' initial x position
                         %CW_USEDEFAULT, _         ' initial y position
                         %CW_USEDEFAULT, _         ' initial x size
                         %CW_USEDEFAULT, _         ' initial y size
                         %NULL, _                  ' parent window handle
                         %NULL, _                  ' window menu handle
                         hInstance, _              ' program instance handle
                         BYVAL %NULL)              ' creation parameters

   ShowWindow hwnd, iCmdShow
   UpdateWindow hwnd

   LOCAL uMsg AS tagMsg
   WHILE GetMessage(uMsg, %NULL, 0, 0)
      TranslateMessage uMsg
      DispatchMessage uMsg
   WEND

   FUNCTION = uMsg.wParam

END FUNCTION
' ========================================================================================

' ========================================================================================
FUNCTION MidiOutMessage_ (BYVAL hMidi AS DWORD, BYVAL iStatus AS LONG, BYVAL iChannel AS LONG, _
                                BYVAL iData1 AS LONG, BYVAL iData2 AS LONG) AS DWORD

   LOCAL dwMessage AS DWORD

   SHIFT LEFT iData1, 8
   SHIFT LEFT iData2, 16
   dwMessage = iStatus OR iChannel OR iData1 OR iData2

   FUNCTION = midiOutShortMsg(hMidi, dwMessage)

END FUNCTION
' ========================================================================================

' ========================================================================================
' Main dialog callback.
' ========================================================================================
FUNCTION WndProc (BYVAL hwnd AS DWORD, BYVAL uMsg AS DWORD, BYVAL wParam AS DWORD, BYVAL lParam AS LONG) AS LONG

   DIM noteseq(19) AS STATIC NOTESEQ_STRUCT
   STATIC hMidiOut AS DWORD
   STATIC iIndex   AS LONG
   LOCAL  i        AS LONG

   SELECT CASE uMsg

      CASE %WM_CREATE
         noteseq( 0).iDur =  110 : noteseq( 0).iNote(0) = 69 : noteseq( 0).iNote(1) = 81
         noteseq( 1).iDur =  110 : noteseq( 1).iNote(0) = 67 : noteseq( 1).iNote(1) = 79
         noteseq( 2).iDur =  990 : noteseq( 2).iNote(0) = 69 : noteseq( 2).iNote(1) = 81
         noteseq( 3).iDur =  220 : noteseq( 3).iNote(0) = -1 : noteseq( 3).iNote(1) = -1

         noteseq( 4).iDur =  110 : noteseq( 4).iNote(0) = 67 : noteseq( 4).iNote(1) = 79
         noteseq( 5).iDur =  110 : noteseq( 5).iNote(0) = 65 : noteseq( 5).iNote(1) = 77
         noteseq( 6).iDur =  110 : noteseq( 6).iNote(0) = 64 : noteseq( 6).iNote(1) = 76
         noteseq( 7).iDur =  110 : noteseq( 7).iNote(0) = 62 : noteseq( 7).iNote(1) = 74

         noteseq( 8).iDur =  220 : noteseq( 8).iNote(0) = 61 : noteseq( 8).iNote(1) = 73
         noteseq( 9).iDur =  440 : noteseq( 9).iNote(0) = 62 : noteseq( 9).iNote(1) = 74
         noteseq(10).iDur = 1980 : noteseq(10).iNote(0) = -1 : noteseq(10).iNote(1) = -1
         noteseq(11).iDur =  110 : noteseq(11).iNote(0) = 57 : noteseq(11).iNote(1) = 69

         noteseq(12).iDur =  110 : noteseq(12).iNote(0) = 55 : noteseq(12).iNote(1) = 67
         noteseq(13).iDur =  990 : noteseq(13).iNote(0) = 57 : noteseq(13).iNote(1) = 69
         noteseq(14).iDur =  220 : noteseq(14).iNote(0) = -1 : noteseq(14).iNote(1) = -1
         noteseq(15).iDur =  220 : noteseq(15).iNote(0) = 52 : noteseq(15).iNote(1) = 64

         noteseq(16).iDur =  220 : noteseq(16).iNote(0) = 53 : noteseq(16).iNote(1) = 65
         noteseq(17).iDur =  220 : noteseq(17).iNote(0) = 49 : noteseq(17).iNote(1) = 61
         noteseq(18).iDur =  440 : noteseq(18).iNote(0) = 50 : noteseq(18).iNote(1) = 62
         noteseq(19).iDur = 1980 : noteseq(19).iNote(0) = -1 : noteseq(19).iNote(1) = -1

         ' Open MIDIMAPPER device
         IF midiOutOpen(hMidiOut, %MIDIMAPPER, 0, 0, 0) <> %MMSYSERR_NOERROR THEN
            MessageBeep %MB_ICONEXCLAMATION
            MessageBox hwnd, "Cannot open MIDI output device!", _
                       "BachTocc", %MB_ICONEXCLAMATION OR %MB_OK
            FUNCTION = -1
            EXIT FUNCTION
         END IF
         ' Send Program Change messages for "Church Organ"
         MidiOutMessage_ hMidiOut, &HC0,  0, 19, 0
         MidiOutMessage_ hMidiOut, &HC0, 12, 19, 0
         SetTimer hwnd, %ID_TIMER, 1000, %NULL
         EXIT FUNCTION

      CASE %WM_KEYDOWN
         SELECT CASE LO(WORD, wParam)
            CASE %VK_ESCAPE
               SendMessage hwnd, %WM_CLOSE, 0, 0
               EXIT FUNCTION
         END SELECT

      CASE %WM_TIMER
         ' Loop for 2-note polyphony
         FOR i = 0 TO 1
            ' Note Off messages for previous note
            IF iIndex <> 0 THEN
               IF noteseq(iIndex - 1).iNote(i) <> -1 THEN
                  MidiOutMessage_ hMidiOut, &H80,  0, _
                                  noteseq(iIndex - 1).iNote(i), 0
                  MidiOutMessage_ hMidiOut, &H80, 12, _
                                  noteseq(iIndex - 1).iNote(i), 0
               END IF
            END IF
            ' Note On messages for new note
            IF iIndex < 19 THEN
               IF noteseq(iIndex).iNote(i) <> -1 THEN
                  MidiOutMessage_ hMidiOut, &H90,  0, _
                                  noteseq(iIndex).iNote(i), 127
                  MidiOutMessage_ hMidiOut, &H90, 12, _
                                  noteseq(iIndex).iNote(i), 127
               END IF
            END IF
         NEXT
         IF iIndex < 19 THEN
            SetTimer hwnd, %ID_TIMER, noteseq(iIndex).iDur - 1, %NULL
            iIndex = iIndex + 1
         ELSE
            KillTimer hwnd, %ID_TIMER
            DestroyWindow hwnd
         END IF
         EXIT FUNCTION

      CASE %WM_DESTROY
         midiOutReset hMidiOut
         midiOutClose hMidiOut
         PostQuitMessage 0
         EXIT FUNCTION

   END SELECT

   FUNCTION = DefWindowProc(hwnd, uMsg, wParam, lParam)

END FUNCTION
' ========================================================================================
