#PBFORMS Created
'--------------------------------------------------------------------------------
' A simple audio spectrum analyzer
'----------------------------------------------------------------------
' Opens a waveform audio device for 16-bit mono input, gets
' chunks of audio, runs a FFT on them, and displays the output in
' a little window.  It's fairly optimized for speed.  Demonstrates
' an easy and fairly fast way to do graphics double-buffering,
' audio input, FFT usage, windowing, oscilloscope, triggering, etc.
'
' This code is an adaption of VB code provided by Murphy McCauley,
' http://www.fullspectrum.com/deeth/.  It has been extensivly modified
' and has additional features. Some bugs were corrected as well. If
' you use some of this code in a commercial product, kindly give
' credit where it is due...
'----------------------------------------------------------------------

#COMPILE EXE

'--------------------------------------------------------------------------------
'   ** Includes **
'--------------------------------------------------------------------------------
'%WINAPI = 1
#PBFORMS Begin Includes
#IF NOT %DEF(%WINAPI)
    #INCLUDE "WIN32API.INC"
#ELSE
    #INCLUDE "SPECTRUM.INC"
#ENDIF
#IF NOT %DEF(%COMMCTRL_INC)
    #INCLUDE "COMMCTRL.INC"
#ENDIF
#INCLUDE "PBForms.INC"
#PBFORMS End Includes
'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------
'   ** Constants **
'--------------------------------------------------------------------------------
#PBFORMS Begin Constants
%IDD_DIALOG1        = 101
%IDC_DEVICESBOX     = 1002
%IDC_SCOPE          = 1003
%IDC_STARTBUTTON    = 1004
%IDC_SLIDER         = 1005
%IDC_CHECKBOX1      = 1006
%IDC_FRAME1         = 1007
%IDC_OPTION1        = 1008
%IDC_OPTION2        = 1009
%IDC_OPTION3        = 1010
%IDC_FRAME2         = 1011
%IDC_OPTION4        = 1017
%IDC_OPTION5        = 1018
%IDC_FRAME3         = 1019
%IDC_OPTION6        = 1020
%IDC_OPTION7        = 1021
%IDC_WINDOW         = 1022
%IDC_CHECKBOX2      = 1023
#PBFORMS End Constants

%NumBits    = 10
%NumSamples = 1024
' This number calibrates the analyzer's 0 dB reference point
%ZerodB     = 168600
'--------------------------------------------------------------------------------

GLOBAL Gain          AS LONG
GLOBAL hTrack        AS LONG
GLOBAL sr            AS LONG
GLOBAL DevHandle     AS LONG
GLOBAL hScope        AS LONG
GLOBAL ScopeDC       AS LONG
GLOBAL hdcMem        AS LONG
GLOBAL hScopeBuf     AS LONG
GLOBAL hPen          AS LONG
GLOBAL fFreeze       AS LONG
GLOBAL ScopeHeight   AS LONG
GLOBAL ScopeWidth    AS LONG
GLOBAL hDlg          AS DWORD
GLOBAL hDummy        AS DWORD
GLOBAL TwoPi         AS SINGLE
GLOBAL ReversedBits() AS LONG    ' Used to store pre-calculated values
GLOBAL Kvals()       AS SINGLE   ' Kaiser window template
GLOBAL Bvals()       AS SINGLE   ' Blackman window template
GLOBAL HMvals()      AS SINGLE   ' Hamming window template
GLOBAL HNvals()      AS SINGLE   ' Hanning window template
GLOBAL Wvals()       AS SINGLE   ' Hanning window template
GLOBAL InData()      AS INTEGER  ' Source data
GLOBAL OutData()     AS SINGLE   ' FFT data
'--------------------------------------------------------------------------------
'   ** Declarations **
'--------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS Declarations
'--------------------------------------------------------------------------------
SUB BlankScope()
   PatBlt hdcMem, 0, 0, ScopeWidth, ScopeHeight, %BLACKNESS
END SUB
'--------------------------------------------------------------------------------

FUNCTION ReverseBits(BYVAL Index AS LONG, NumBits AS LONG) AS LONG
    REGISTER I AS LONG
    LOCAL Rev AS LONG

    FOR I = 0 TO NumBits - 1
        Rev = (Rev * 2) OR (Index AND 1)
        Index = Index \ 2
    NEXT

    ReverseBits = Rev
END FUNCTION
'--------------------------------------------------------------------------------

FUNCTION I0(BYVAL x AS SINGLE) AS SINGLE
   ' Calculates modified zeroth-order Bessel function of the 1st kind.
   ' 'I-zero' function
   LOCAL ax AS SINGLE, y AS SINGLE

   ax = ABS(x)
   IF ax < 3.75 THEN
      y = (x / 3.75) ^ 2
      FUNCTION = 1 + y * (3.5156229 + y * (3.0899424 + y * (1.2067492 + y * _
                  (.2659732 + y * (.0360768 + y * (.0045813))))))
   ELSE
      y = 3.75 / ax
      FUNCTION = (EXP(ax) / SQR(ax)) * .39894228 + y * (.01328592 + y * _
                  (.0022531 + y * (-.00157565 + y * (.00916281 + y * _
                  (-.02057706 + y * (.02635537 + y * (-.01647633 + y * (.00392377))))))))
   END IF
END FUNCTION
'--------------------------------------------------------------------------------

FUNCTION Kaiser(BYVAL x AS LONG) AS SINGLE
   ' -(%NumSamples \ 2) < x < (%NumSamples \ 2)
   ' A versitile window function. Setting Alpha to
   ' the following values produces the following:
   ' 0 = Rectangular
   ' 5 = Similar to Hamming
   ' 6 = Similar to Hanning
   ' 8.6 = Almost identical to Blackman
   ' Alpha could be a parameter to this function
   LOCAL Alpha AS SINGLE

   Alpha = 10!
   ' Scale x to +/- x
   x = x - (%NumSamples \ 2)
   FUNCTION = I0(Alpha * SQR(1 - ((2 * x / %NumSamples)^2))) / I0(Alpha)
END FUNCTION
'--------------------------------------------------------------------------------

SUB InitWinTemplates()
   ' Generate window templates to save time windowing samples in FFT
   REGISTER i AS LONG
   LOCAL k1 AS LONG, k2 AS SINGLE, k3 AS SINGLE
   DIM Kvals(%NumSamples - 1), Bvals(%NumSamples - 1), HMvals(%NumSamples - 1), _
         HNvals(%NumSamples - 1), Wvals(%NumSamples - 1)

   k1 = %NumSamples \ 2 : k2 = TwoPi / %NumSamples
   FOR i = 0 TO %NumSamples - 1
      k3 = COS(k2 * (i - k1))
      Kvals(i) = Kaiser(i)
      Bvals(i) = 0.42 + 0.5 * k3 + 0.08 * COS(2 * k2 * (i - k1))
      HMvals(i) = 0.54 + 0.46 * k3
      HNvals(i) = 0.5 + 0.5 * k3
      Wvals(i) = 1 - ((2 * i - %NumSamples) / %NumSamples)^2
      SLEEP 0
   NEXT
END SUB
'--------------------------------------------------------------------------------

SUB FFT(RealIn() AS INTEGER)
   ' In this case, NumSamples isn't included (since it's always 1024).
   ' Singles are used pretty much everywhere. Considering PB's range for
   ' for singles, I don't see a problem dealing with noise levels in the
   ' -100 to -120 dB range (this is the dynamic range of the vertical axis of
   ' the 'scope window). It also saved 540uS of execution time on my system.
   ' The imaginary components could have been ignored, but including the phase
   ' provides a more stable display.
   ' The output array is global and prevents it from being reallocated, taking
   ' pressure off the heap.
   ' Windowing functions have been implemented.

   REGISTER I AS LONG
   STATIC k AS LONG, n AS LONG, j AS LONG, BlockSize AS LONG, BlockEnd AS LONG, _
          Index AS LONG, WorkBuf() AS INTEGER, k2 AS SINGLE
   STATIC DeltaAngle AS SINGLE, DeltaAr AS SINGLE, Alpha AS SINGLE, Beta AS SINGLE
   STATIC TR AS SINGLE, TI AS SINGLE, AR AS SINGLE, AI AS SINGLE, ImagOut() AS SINGLE
   DIM ImagOut(%NumSamples - 1)

   ' What amplitude envelope are we using?
   Index = SendDlgItemMessage(hDlg, %IDC_WINDOW, %CB_GETCURSEL, 0, 0)

   FOR I = 0 TO %NumSamples - 1
      ' Saved time here, by pre-calculating all these values
      j = ReversedBits(I)
      SELECT CASE Index
      CASE 0      ' Apply Blackmann window to input samples & correct for loss
         OutData(j) = Bvals(I) * RealIn(I)  * 2.381
      CASE 1      ' Hamming window
         OutData(j) = HMvals(i) * RealIn(I) * 1.852
      CASE 2      ' Hanning window
         OutData(j) = HNvals(i) * RealIn(I) * 2
      CASE 3      ' Kaiser window
         OutData(j) = Kvals(I) * RealIn(I)  * 2.559
      CASE 4      ' Welch window
         OutData(j) = Wvals(i) * RealIn(I)  * 1.499
      CASE 5      ' No windowing at all
         OutData(j) = RealIn(I)
      CASE ELSE
         EXIT SUB
      END SELECT
      ImagOut(I) = 0 'Since this array is static, gotta make sure it's clear
   NEXT

   BlockEnd = 1
   BlockSize = 2

   DO WHILE BlockSize <= %NumSamples
      DeltaAngle = TwoPi / BlockSize
      Alpha = SIN(0.5 * DeltaAngle)
      Alpha = 2! * Alpha * Alpha
      Beta = SIN(DeltaAngle)

      I = 0
      DO WHILE I < %NumSamples
         AR = 1!
         AI = 0!

         j = I
         FOR n = 0 TO BlockEnd - 1
            k = j + BlockEnd
            TR = AR * OutData(k) - AI * ImagOut(k)
            TI = AI * OutData(k) + AR * ImagOut(k)
            OutData(k) = OutData(j) - TR
            ImagOut(k) = ImagOut(j) - TI
            OutData(j) = OutData(j) + TR
            ImagOut(j) = ImagOut(j) + TI
            DeltaAr = Alpha * AR + Beta * AI
            AI = AI - (Alpha * AI - Beta * AR)
            AR = AR - DeltaAr
            INCR j
         NEXT

         I = I + BlockSize
      LOOP
      BlockEnd = BlockSize
      BlockSize = BlockSize * 2
   LOOP

   ' Calculate the magnitude
   FOR I = 0 TO (%NumSamples / 2)
      OutData(I) = SQR(OutData(I)^2 + ImagOut(I)^2) / 100
   NEXT
END SUB
'--------------------------------------------------------------------------------

SUB ScopeSweep(RealData() AS INTEGER, VIEW AS LONG)
   REGISTER X AS LONG
   LOCAL X2 AS LONG, a AS SINGLE, k AS SINGLE, k2 AS SINGLE, LastX AS LONG, LastY AS SINGLE

   CONTROL GET CHECK hDlg, %IDC_OPTION2 TO LogScale&
   CONTROL GET CHECK hDlg, %IDC_OPTION6 TO gBar&

   k = %NumSamples / (4 * LOG(%NumSamples \ 2))    ' This expression saves a divide by 2 in for/next
   k2 = ScopeHeight / LOG(%ZerodB)

   IF VIEW THEN
      D& = 1   ' Look at all 1024 samples
      LastY = RealData(0) / Gain + ScopeHeight \ 2
      k = k * 2   ' If you're crazy enough to look at source log scaled!
   ELSE
      D& = 2   ' FFT - look at 512 samples
      ' Provide an offset in Log + bar mode to align freq display
      IF gBar& AND LogScale& THEN ob& = 1
      LastY = k2 * LOG(%ZerodB / OutData(1 + ob&))
   END IF

   FOR X = 1 TO %NumSamples \ D&
      ' Check Lin/Log mode
      IF LogScale& THEN    ' Log
         ' Argument to Log cannot be zero!
         X2 = FIX(LOG(X) * k)
      ELSE
         X2 = X \ 2
      END IF

      IF VIEW THEN   ' Viewing source signal
         a = RealData(X) \ Gain + ScopeHeight \ 2
         ' Display all 1024 samples
         X2 = x2 \ 2
      ELSE
         ' Prevent Log(0) errors
         IF OutData(X + ob&) = 0 THEN OutData(X + ob&) = 1
         a =  k2 * LOG(%ZerodB / OutData(X + ob&))
      END IF

      ' Check for Bar/Line mode
      IF gBar& THEN  ' Bar
         MoveTo hdcMem, LastX, LastY
         LineTo hdcMem, X2, LastY
         MoveTo hdcMem, X2, LastY
         LineTo hdcMem, X2, a
         MoveTo hdcMem, X2, ScopeHeight   ' Comment out above for vert line only
      ELSE
         MoveTo hdcMem, LastX, LastY
      END IF
      LineTo hdcMem, X2, a
      Lastx = X2 : LastY = a
   NEXT

   'Display the double-buffer (double-buffering provides trace persistence)
   BitBlt ScopeDC, 0, 0, ScopeWidth, ScopeHeight, hdcMem, 0, 0, %SRCCOPY
END SUB
'--------------------------------------------------------------------------------

SUB GetSamples()
   'These are all static just because they can be.
   STATIC WAVE AS WaveHdr
   STATIC  junk AS DWORD, tt AS SINGLE
   REGISTER j AS LONG

   DIM InData(%NumSamples * 2 - 1)  ' Need extra 'cause triggering eats samples

'     Use this code to check timing on your system...
'     t! = timeGetTime() : INCR junk
'     tt = tt + (timeGetTime() - t!)
'     DIALOG SET TEXT hDlg, str$(ROUND(tt / junk, 3))
   DO
      ' 11KHz   22KHz   44KHz
      ' -----   -----   -----
      ' 184.2mS 122.2mS 59.6mS -->
      Wave.lpData = VARPTR(InData(0))
      Wave.dwBufferLength = %NumSamples * 4  ' Get extra 'cause triggering eats samples
      Wave.dwFlags = 0
      waveInPrepareHeader DevHandle, WAVE, LEN(WAVE)
      waveInAddBuffer DevHandle, WAVE, LEN(WAVE)   ' Begin recording

      DO
         'Just wait for the blocks to be done or the device to close
         DIALOG DOEVENTS
      LOOP UNTIL (Wave.dwFlags AND %WHDR_DONE) OR (DevHandle = %NULL)

      IF DevHandle = 0 THEN EXIT DO ' Exit if the device is closed

      waveInUnprepareHeader DevHandle, WAVE, LEN(WAVE)
      ' <--

      ' 1.86mS(!)-->
      CONTROL GET CHECK hDlg, %IDC_CHECKBOX1 TO Accum&
      CONTROL GET CHECK hDlg, %IDC_CHECKBOX2 TO View&

      ' Adaptive (+) peak detecting, zero-crossing Triggered Sweep.
      ' Works OK for most complex signals.
      ' Could have added lots of other fancy 'scope functions,
      ' but I have to let the user of this code have SOME fun!
      RESET pk%
      FOR j = 2  TO %NumSamples \ 2 - 1
         d% = InData(j)
         IF d% => 0 AND d% > pk% THEN
            ' Noise (overshoot) filter
            IF ISFALSE(Indata(j - 2) <= 0) THEN pk% = d% : m& = j
         END IF
      NEXT

      ' Got the peak, now get a zero-crossing...
      FOR j = m& TO %NumSamples - 1
         IF InData(j) <= 0 THEN m& = m& + (j - m&) : EXIT FOR
      NEXT

      ' Move our trigger point to head of buffer
      MoveMemory BYVAL VARPTR(InData(0)), BYVAL VARPTR(InData(m&)), %NumSamples * 2 + 2
      IF View& THEN  ' Viewing source signal
         CONTROL ENABLE hDlg, %IDC_SLIDER
      ELSE
         CONTROL DISABLE hDlg, %IDC_SLIDER
         FFT InData()
      END IF

      IF ISFALSE(Accum&) THEN BlankScope

      IF ISFALSE(fFreeze) THEN ScopeSweep InData(), View&
      ' <--
   LOOP WHILE DevHandle
END SUB
'--------------------------------------------------------------------------------

SUB DoReverse()
    'Pre-calculate all these values.  It's a lot faster to just read them from an
    'array than it is to calculate 1024 of them every time FFT() gets called.
    REGISTER I AS LONG

    FOR I = LBOUND(ReversedBits) TO UBOUND(ReversedBits)
        ReversedBits(I) = ReverseBits(I, %NumBits)
    NEXT
END SUB
'--------------------------------------------------------------------------------

SUB DoStop()
   waveInReset DevHandle
   waveInClose DevHandle
   RESET DevHandle
END SUB
'--------------------------------------------------------------------------------
FUNCTION x2SampNum (BYVAL x AS LONG, BYVAL SelStart AS LONG, BYVAL SelEnd AS LONG) AS LONG

   CONTROL GET CHECK hDlg, %IDC_OPTION2 TO LogScale&
   IF LogScale& THEN
      k! = %NumSamples / (4 * LOG(%NumSamples \ 2))
      SelStart = ROUND(EXP(1)^(SelStart / k!) + .5, 0)
      SelEnd = ROUND(EXP(1)^(SelEnd / k!) + .5, 0)
   ELSE
      SelStart = SelStart * 2 : SelEnd = SelEnd * 2
   END IF
   ' Return the Sample number that corresponds to given PixelNumber.
   FUNCTION = ROUND(SelStart + (x * (SelEnd - SelStart) / ScopeWidth), 0)
END FUNCTION
'--------------------------------------------------------------------------------

SUB ZoomDisplay(BYVAL SelStart AS LONG, BYVAL SelEnd AS LONG)
   LOCAL I AS LONG, Center AS LONG, k2 AS SINGLE

   ' Clear the Scope display
   PatBlt ScopeDC, 0, 0, ScopeWidth, ScopeHeight, %BLACKNESS

   ' xfer pen to scope display
   SelectObject ScopeDC, hPen

   CONTROL GET CHECK hDlg, %IDC_CHECKBOX2 TO View&
   IF View& THEN  ' Source signal
      ' 1024 samples to compress here
      SelStart = SelStart * 2 : SelEnd = SelEnd * 2
      ' Move to 1st sample position
      MoveTo ScopeDC, 0, InData(x2SampNum(I, SelStart, SelEnd)) \ Gain + ScopeHeight \ 2
      FOR I = 1 TO ScopeWidth
         LineTo ScopeDC, I, InData(x2SampNum(I, SelStart, SelEnd)) \ Gain + ScopeHeight \ 2
      NEXT 'I
   ELSE  ' FFT data
      ' Just 512 samples here
      k2 = ScopeHeight / LOG(%ZerodB)
      ' Move to 1st sample position
      MoveTo ScopeDC, 0, k2 * LOG(%ZerodB / OutData(x2SampNum(0, SelStart, SelEnd)))

      FOR I = 1 TO ScopeWidth
         LineTo ScopeDC, I, k2 * LOG(%ZerodB / OutData(x2SampNum(I, SelStart, SelEnd)))
      NEXT 'I
   END IF
   ' xfer pen back to buffer
   SelectObject hdcMem, hPen
END SUB
'--------------------------------------------------------------------------------

SUB SelRect(BYVAL pFrom AS LONG, BYVAL pTo AS LONG)
    LOCAL r AS RECT

    r.nTop = 0
    r.nBottom = ScopeHeight
    r.nLeft = pFrom
    r.nRight = pTo
    InvertRect ScopeDC, r
END SUB
'--------------------------------------------------------------------------------

SUB InitDevices()
   'Fill the DevicesBox box with all the compatible audio input devices
   'Bail if there are none.
   LOCAL Caps AS WaveInCaps, Which AS LONG

   FOR Which = 0 TO waveInGetNumDevs - 1
      ' Build a list of Input devices and add them to the 'Input Device' List Box
      waveInGetDevCaps Which, Caps, LEN(Caps)
      IF Caps.dwFormats AND %WAVE_FORMAT_1M16 THEN '16-bit mono devices
         COMBOBOX ADD hDlg, %IDC_DEVICESBOX, RTRIM$(Caps.szPname, CHR$(0))
      END IF
   NEXT
   IF SendDlgItemMessage(hDlg, %IDC_DEVICESBOX, %CB_GETCOUNT, 0, 0) = 0 THEN
      MSGBOX "You have no audio input devices!", %MB_ICONWARNING, "Warning"
      EXIT SUB
   END IF
   COMBOBOX SELECT hDlg, %IDC_DEVICESBOX, 1
END SUB
'--------------------------------------------------------------------------------

FUNCTION PBMAIN()

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'--------------------------------------------------------------------------------
'   ** CallBacks **
'--------------------------------------------------------------------------------

CALLBACK FUNCTION ShowDummyProc()
   SELECT CASE CBMSG
   CASE %WM_COMMAND
      SELECT CASE CBCTL
      CASE %IDC_OPTION3, %IDC_OPTION4, %IDC_OPTION5
         ' Clear scope buffer
         BlankScope
      END SELECT
   END SELECT
END FUNCTION
'--------------------------------------------------------------------------------

CALLBACK FUNCTION ShowDIALOG1Proc()
   SELECT CASE CBMSG
   CASE %WM_COMMAND
      SELECT CASE CBCTL
      CASE %IDC_CHECKBOX2  ' View source
         CONTROL GET CHECK hDlg, %IDC_CHECKBOX2 TO result&
         IF Result& THEN
            DIALOG POST GetDlgItem(hDlg, %IDC_OPTION1), %BM_CLICK, 0, 0
            DIALOG POST GetDlgItem(hDlg, %IDC_OPTION7), %BM_CLICK, 0, 0
            DIALOG POST GetDlgItem(hDlg, %IDC_OPTION7), %WM_KILLFOCUS, 0, 0
            DIALOG POST GetDlgItem(hDlg, %IDC_STARTBUTTON), %WM_SETFOCUS, 0, 0
         END IF

      CASE %IDC_STARTBUTTON
         IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
            STATIC WF AS WaveFormatEx
            DIM sr AS LONG

            CONTROL GET TEXT hDlg, %IDC_STARTBUTTON TO TXT$
            IF TXT$ = "&Start" THEN
               CONTROL GET CHECK hDummy, %IDC_OPTION3 TO result&
               IF result& = %True THEN sr = 11025
               CONTROL GET CHECK hDummy, %IDC_OPTION4 TO result&
               IF result& = %True THEN sr = 22050
               CONTROL GET CHECK hDummy, %IDC_OPTION5 TO result&
               IF result& = %True THEN sr = 44100
               WF.wFormatTag = %WAVE_FORMAT_PCM
               WF.nChannels = 1
               WF.nSamplesPerSec = sr
               WF.wBitsPerSample = 16
               WF.nBlockAlign = WF.nChannels * WF.wBitsPerSample \ 8
               WF.nAvgBytesPerSec = WF.nBlockAlign * WF.nSamplesPerSec

               waveInOpen DevHandle, SendDlgItemMessage(hDlg, %IDC_DEVICESBOX, %CB_GETCURSEL, 0, 0), WF, 0, 0, 0

               IF DevHandle = 0 THEN
                  MSGBOX "Wave input device didn't open!", %MB_ICONWARNING, "Warning"
                  EXIT FUNCTION
               END IF
               CALL waveInStart(DevHandle)

               CONTROL DISABLE hDummy, %IDC_FRAME2
               DIALOG DISABLE hDummy
               CONTROL DISABLE hDlg, %IDC_DEVICESBOX
               CONTROL SET TEXT hDlg, %IDC_STARTBUTTON, "&Stop"
               fFreeze = %FALSE
               GetSamples
            ELSE
               CONTROL SET TEXT hDlg, %IDC_STARTBUTTON, "&Start"
               DoStop
               CONTROL ENABLE hDummy, %IDC_FRAME2
               DIALOG ENABLE hDummy
               CONTROL ENABLE hDlg, %IDC_DEVICESBOX
            END IF
            CONTROL ENABLE hDlg, %IDC_SLIDER
         END IF

      CASE %IDC_OPTION1, %IDC_OPTION2, %IDC_OPTION6, %IDC_OPTION7, %IDC_WINDOW
         ' Clear scope buffer
         BlankScope
      END SELECT

   CASE %WM_HSCROLL
      SELECT CASE LOWRD(CBWPARAM)
      CASE %TB_ENDTRACK  ' Msg from slider
         dwMax??? = SendMessage(hTrack, %TBM_GETRANGEMAX, 0, 0)
         dwPos??? = SendMessage(hTrack, %TBM_GETPOS, 0, 0)
         'This adjusts the amplitude of the source signal display
         Gain = ((dwMax??? - dwPos??? + 1) * 6) ^ 2
         ' Clear scope buffer
         BlankScope
      END SELECT  '%TB_ENDTRACK

   CASE %WM_LBUTTONDOWN
      LOCAL p AS POINTAPI
      STATIC SelStart AS LONG, SelEnd AS LONG, LastStart AS LONG, fMouseDown AS LONG

      hWnd& = ChildWindowFromPoint(hDlg, LO(WORD, CBLPARAM), HI(WORD, CBLPARAM))
      IF hWnd& = WindowFromDC(ScopeDC) THEN  ' Mouse is in image area
         MOUSEPTR 2  ' Cursor = cross
         GetCursorPos p
         ScreenToClient hWnd&, p
         ' Compensate for border
         IF p.x < 1 THEN p.x = 1
         IF p.x > ScopeWidth THEN p.x = ScopeWidth
         SelStart = p.x
         LastStart = p.x
         fMouseDown = %TRUE
         fFreeze = %TRUE
      END IF

   CASE %WM_LBUTTONUP
      hWnd& = ChildWindowFromPoint(hDlg, LO(WORD, CBLPARAM), HI(WORD, CBLPARAM))
      IF hWnd& = WindowFromDC(ScopeDC) THEN  ' Mouse is in image area
         MOUSEPTR 2  ' Cursor = cross
         GetCursorPos p
         ScreenToClient hWnd&, p
         ' Compensate for border
         IF p.x < 1 THEN p.x = 1
         IF p.x > ScopeWidth THEN p.x = ScopeWidth
         SelEnd = p.x
         fMouseDown = %FALSE
         IF SelStart > SelEnd THEN SWAP SelStart, SelEnd
         IF SelStart <> SelEnd THEN
            ZoomDisplay SelStart, SelEnd
         ELSE
            fFreeze = %FALSE
         END IF
      END IF

   CASE %WM_MOUSEMOVE
      IF OutData(0) THEN   ' We've done a transform
         hWnd& = ChildWindowFromPoint(hDlg, LOWRD(CBLPARAM), HIWRD(CBLPARAM))
         IF hWnd& = WindowFromDC(ScopeDC) THEN  ' Mouse is in image area
            MOUSEPTR 2  ' Cursor = cross
            GetCursorPos p
            ScreenToClient hWnd&, p
            ' Compensate for border
            IF p.x < 1 THEN p.x = 1
            IF p.x > ScopeWidth THEN p.x = ScopeWidth
            IF fMouseDown THEN SelRect LastStart, p.x : LastStart = p.x : EXIT FUNCTION
            CONTROL GET CHECK hDlg, %IDC_CHECKBOX2 TO View&
            IF View& = %FALSE THEN  ' Only display freq/amplitude if viewing FFT
               CONTROL GET CHECK hDlg, %IDC_OPTION2 TO LogScale&

               IF fFreeze THEN
                  C& = x2SampNum(p.x, SelStart, SelEnd)
               ELSE
                  IF LogScale& THEN
                     x! = %NumSamples / (4 * LOG(%NumSamples \ 2))
                     C& = ROUND(EXP(1)^(p.x / x!) + .5, 0)
                  ELSE
                     c& = p.x * 2
                  END IF
               END IF
               f! = sr * c& / %NumSamples
               a! = 20 * LOG10(OutData(c&) / %ZerodB)
               DIALOG SET TEXT hDlg, FORMAT$(f!, "0.00") & "Hz, " & FORMAT$(a!, "0.00") & "dB"' & str$(p.x) & str$(c&)
            END IF
         END IF
      END IF

   CASE %WM_INITDIALOG
      DIALOG SHOW MODELESS hDummy, CALL ShowDummyProc
      ' Set default radio buttons
      CONTROL SET CHECK hDlg, %IDC_OPTION2, %TRUE
      CONTROL SET CHECK hDlg, %IDC_OPTION7, %TRUE  ' Default to line
      CONTROL SET CHECK hDummy, %IDC_OPTION5, %TRUE
      CONTROL HANDLE hDlg, %IDC_SLIDER TO hTrack
      COMBOBOX SELECT hDlg, %IDC_WINDOW, 1
      SendMessage hTrack, %TBM_SETRANGE, _
               %TRUE, _       ' redraw flag
               MAKLNG(1, 10)  ' Set min. & max. positions
      SendMessage hTrack, %TBM_SETPOS, _
               %TRUE, _       ' redraw flag
               5              ' Set current position
      PostMessage hDlg, %WM_HSCROLL, %TB_ENDTRACK, 0 'Init Gain
      DIM OutData(%NumSamples - 1)
'     FUNCTION    = %TRUE : EXIT FUNCTION

   CASE %WM_CLOSE
      IF DevHandle THEN
         CALL DoStop
         DeleteObject hPen
         ReleaseDC hScope, ScopeDC
         DeleteObject hScopeBuf
         DeleteDC hdcMem
         DIALOG END hDummy
         DestroyWindow hDlg
         FUNCTION = 0
      END IF
   END SELECT
END FUNCTION
'--------------------------------------------------------------------------------
'   ** Dialogs **
'--------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
   LOCAL lRslt AS LONG, r AS RECT, w() AS STRING

   DIM w(5)
   w(0) = "Blackmann" : w(1) = "Hamming" : w(2) = "Hanning" : w(3) = "Kaiser" : _
   w(4) = "Welch (Gaussian)" : w(5) = "Rectangular"
#PBFORMS Begin Dialog %IDD_DIALOG1->->

   DIALOG NEW hParent, "Spectrum Analyzer", %CW_USEDEFAULT, %CW_USEDEFAULT, _
      184, 158, %WS_POPUP OR %WS_BORDER _
      OR %WS_DLGFRAME OR %WS_SYSMENU OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR _
      %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
      %WS_EX_WINDOWEDGE OR %WS_EX_TOOLWINDOW OR %WS_EX_LEFT OR _
      %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg

   CONTROL ADD IMAGE, hDlg, %IDC_SCOPE, "", 5, 25, 175, 41, %WS_CHILD OR _
      %SS_BITMAP OR %SS_SUNKEN OR %SS_CENTERIMAGE OR %WS_VISIBLE, %WS_EX_CLIENTEDGE

   CONTROL ADD BUTTON, hDlg, %IDC_STARTBUTTON, "&Start", 5, 70, 50, 15

   CONTROL ADD "msctls_trackbar32", hDlg, %IDC_SLIDER, "Slider", 58, 70, 65, _
      15, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %TBS_HORZ OR %TBS_BOTTOM OR %TBS_AUTOTICKS

   CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX1, "&Accumulate", 125, 70, 55, 10

   CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX2, "&View Source", 125, 80, 55, 10
   ' Create dummy dialog to contain sample rate frame & controls.
   ' All this is done to emulate the way VB can disable a
   ' frame control, and disable messages from the controls within it.
   ' Making this the FIRST button group prevents interference w/other
   ' grouped controls. The control that follows the last of the grouped
   ' controls MUST have the %WS_GROUP style assigned.
   ' This scheme will mess things up when using PBforms. Sorry 'bout that...
   DIALOG NEW hDlg, "", 5, 95, 60, 55, %DS_CONTROL OR %WS_CHILD OR %WS_CLIPSIBLINGS, _
                        %WS_EX_CONTROLPARENT, TO hDummy 'OR %DS_MODALFRAME OR %WS_VISIBLE

'   CONTROL ADD FRAME, hDummy, %IDC_FRAME2, "Sample Rate", 5, 95, 60, 55, %WS_CHILD OR _
   CONTROL ADD FRAME, hDummy, %IDC_FRAME2, "Sample Rate", 0, 0, 60, 55

'   CONTROL ADD OPTION, hDummy, %IDC_OPTION3, "&11025", 120, 105, 35, 10, %WS_CHILD _
   CONTROL ADD OPTION, hDummy, %IDC_OPTION3, "&11025", 5, 10, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
      %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

'   CONTROL ADD OPTION, hDummy, %IDC_OPTION4, "&22050", 120, 120, 35, 10, %WS_CHILD _
   CONTROL ADD OPTION, hDummy, %IDC_OPTION4, "&22050", 5, 25, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR _
      %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

'   CONTROL ADD OPTION, hDummy, %IDC_OPTION5, "&44100", 120, 135, 35, 10, %WS_CHILD _
   CONTROL ADD OPTION, hDummy, %IDC_OPTION5, "&44100", 5, 40, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR _
      %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

   CONTROL ADD FRAME, hDlg, %IDC_FRAME1, "Scale", 75, 95, 50, 50

   CONTROL ADD OPTION, hDlg, %IDC_OPTION1, "&Lin", 80, 110, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
      %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

   CONTROL ADD OPTION, hDlg, %IDC_OPTION2, "Lo&g", 80, 125, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR _
      %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

   CONTROL ADD FRAME, hDlg, %IDC_FRAME3, "Type", 135, 95, 45, 50

   CONTROL ADD OPTION, hDlg, %IDC_OPTION6, "&Bar", 140, 110, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %BS_TEXT OR _
      %BS_AUTORADIOBUTTON OR %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

   CONTROL ADD OPTION, hDlg, %IDC_OPTION7, "L&ine", 140, 125, 35, 10, %WS_CHILD _
      OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR %BS_AUTORADIOBUTTON OR _
      %BS_LEFT OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING

   CONTROL ADD COMBOBOX, hDlg, %IDC_DEVICESBOX, , 5, 5, 100, 40, %WS_CHILD OR _
      %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %CBS_DROPDOWN, %WS_EX_LEFT OR _
      %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR

   CONTROL ADD COMBOBOX, hDlg, %IDC_WINDOW, w(), 119, 5, 60, 70, %WS_CHILD OR _
      %WS_VISIBLE OR %WS_GROUP OR %WS_TABSTOP OR %CBS_DROPDOWN, %WS_EX_LEFT OR _
      %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR

#PBFORMS End Dialog

   DIM ReversedBits(%NumSamples - 1)

   TwoPi = 8 * ATN(1)  ' (2 * PI)

   InitDevices
   DoReverse   ' Pre-calculate these
   InitWinTemplates  ' and these
   CONTROL SET COLOR hDlg, %IDC_SCOPE, %GREEN, %BLACK
   CONTROL HANDLE hDlg, %IDC_SCOPE TO hScope
   GetClientRect hScope, r
   ScopeHeight = r.nBottom
   ScopeWidth = r.nRight   ' It's conveniently sized to 1/4 the # of samples

   ' Create double-buffer
   ScopeDC = GetDC(hScope)
   hdcMem = CreateCompatibleDC(ScopeDC)
   hScopeBuf = CreateCompatibleBitmap(ScopeDC, ScopeWidth, ScopeHeight)
   SelectObject hdcMem, hScopeBuf

   ' Solid, one pixel lines, green color
   hPen = CreatePen(%PS_SOLID, 1, %GREEN)
   SelectObject hdcMem, hPen
   DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

   FUNCTION = lRslt
END FUNCTION
