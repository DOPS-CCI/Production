' Program1.BAS
' Demonstration of using a worker thread in GUI program, with screen updating and abort function
' Author: Michael Mattias Racine WI
' Date  : November 24 2007
' Compiler: PB/Windows 8.03
' Use/Distribution: Placed in public domain by author 11/24/07
' ----------------------------------------------------------------------------------------------------
' Comments. "Processing" the file for this demo means simply reading each record
'           and periodically reporting the number of records read. In Real Life
'           you'd be doing something else. For demonstration purposes:
'           1. The file is completely 'processed' %NUMBER_CYCLES times before the thread
'              function is deemed to have "completed processing"
'           2. When the file is small, it's just too fast to actually get a feel for what's going on
'              unless the SLEEP 5 is included in the 'read' (LINE INPUT #) loop
'           3. Look Ma, no GLOBALs!
'           4. Look Ma, no polling a flag variable!
' ---------------------------------------------------------------------------------------------------

#COMPILE  EXE
#DEBUG    ERROR ON
#REGISTER NONE
#DIM      ALL
#TOOLS    OFF
'=====[Windows API Header Files] ============================
'  If you don't need all of the functionality supported by these APIs
'  (and who does?), you can selectively turn off various modules by putting
'  the following constants in your program BEFORE you #include "win32api.inc":
'
'  %NOGDI = 1     ' no GDI (Graphics Device Interface) functions
'  %NOMMIDS = 1   ' no Multimedia ID definitions

%NOMMIDS = 1
#INCLUDE "WIN32API.INC"
#INCLUDE "COMDLG32.INC"    ' for OpenFileDialog
' Get message from GetLastError as string

FUNCTION SystemErrorMessageText (BYVAL ECode AS LONG) AS STRING
  LOCAL Buffer AS ASCIIZ * 255
  FormatMessage %FORMAT_MESSAGE_FROM_SYSTEM, BYVAL %NULL, ECode, %NULL, buffer, SIZEOF(buffer), BYVAL %NULL
  FUNCTION = FORMAT$(ECode, "##### ") & Buffer
END FUNCTION

'==[End Windows API Header Files]============================

' --------------------------
'  CONTROLS ON MAIN SCREEN
' --------------------------

%ID_TIMER            = 101      ' will be continuously updated whilst running
%ID_DATETIME         = 102

%ID_FILENAME         = 105     ' pick the file to be 'processed'
%ID_FILENAME_BROWSE  = 106

%ID_START            = 111
%ID_ABORT            = 112

%ID_Progress         =  115     ' text control telling us what worker thread is doing.


%DLG_STYLE           = %WS_VISIBLE OR %WS_SYSMENU OR %WS_MINIMIZEBOX OR %WS_MAXIMIZEBOX

' DIALOG SET USER slots
%DSU_HWND         = 1      ' handle to main dialog
%DSU_HTHREAD      = 2      ' if true, it's an open handle to an executing worker thread
%DSU_HEVENTREADY  = 3      '
%DSU_FILENAME_PTR = 4


$EVENT_ABORT      = "Abort_Worker_Thread_Event"
%NUMBER_CYCLES    =  10    ' number of times the target file will be 'processed' before thread
                           ' function ends if worker thread not aborted.
%PROGRESS_MODULO  =  50    ' update screen every this many records


MACRO   m_CreateThreadReadyEvent  =   CreateEvent (BYVAL %NULL, BYVAL %TRUE, BYVAL %FALSE, BYVAL %NULL)
' private window message:
%PWM_THREAD_FUNCTION_COMPLETED = %WM_USER + 1    ' posted to main window on completion. lPAram= Aborted (True/False)


' -----------------------------------------------------
'                 PROGRAM ENTRY POINT
' -----------------------------------------------------
FUNCTION WINMAIN (BYVAL hInstance     AS LONG, _
                  BYVAL hPrevInstance AS LONG, _
                  BYVAL lpCmdLine     AS ASCIIZ PTR, _
                  BYVAL iCmdShow      AS LONG) AS LONG

  LOCAL hDlg AS LONG

  DIALOG NEW  %NULL, "Worker Thread With Abort Demo", 10,10, 300,200, %DLG_STYLE TO hDlg

  CONTROL ADD LABEL,  hDlg, %ID_DATETIME, "", 200, 10, 90, 12

  CONTROL ADD TEXTBOX, hDlg, %ID_FILENAME, "",  10, 24, 220,12
  CONTROL ADD BUTTON,  hDlg, %ID_FILENAME_BROWSE, "&Browse", 241, 24, 40, 14

  CONTROL ADD BUTTON, hDLg, %ID_START, "&Start", 10, 40, 40, 14
  CONTROL ADD BUTTON, hDlg, %ID_ABORT, "&Abort", 10, 56, 40, 14

  CONTROL ADD LABEL,  hDlg, %ID_PROGRESS, "Nothing Happening", 10, 80, 280, 48


  DIALOG SHOW MODAL hDlg, CALL DlgProc



END FUNCTION  ' WinMain

' ----------------------------------------------------------------
' Helper Function to abort the designated worker Thread function.
' Should never be called unless a worker thread is running
' ----------------------------------------------------------------
FUNCTION AbortWorkerThread (BYVAL hWnd AS LONG, BYVAL hThread AS LONG ) AS LONG

   LOCAL hEvent AS LONG, szEvent AS ASCIIZ * 128
   LOCAL bInherit AS LONG
   LOCAL iWait    AS LONG

   ' get handle to abort event so we can signal it
   szEvent = $EVENT_ABORT
   bInherit = %FALSE     ' we will not be passing this handle to any other process

   hEvent = OpenEVent (%EVENT_ALL_ACCESS, bINherit, szEvent)

   ' OpenEvent will fail if the event does not exist; but that means the worker thread is not running;
   ' meaning either this function was called when it shouldn't have been; OR.... the thread function
   ' ended 'normally' between the time the abort command is issued and "now."
   ' However, waiting on the thread handle is safe, since that handle cannot be closed yet.

   IF ISTRUE hEvent THEN
       SetEvent hEvent
   END IF

  ' wait for the thread function to end (which it may have even before we got here):
   iWait   = WaitForSingleObject (hThread, %INFINITE)

   ' close our handle to abort event (clean up)
   ' The thread handle is closed in DlgProc when this function returns
   CloseHandle hEvent

END FUNCTION


'----------------------------------
'    MAIN WINDOW PROCESSOR
'----------------------------------

CALLBACK FUNCTION DlgPRoc () AS LONG
 LOCAL sText AS STRING
 LOCAL hThread AS LONG, hEventReady AS LONG
 LOCAL iRet AS LONG


 SELECT CASE AS LONG CBMSG


     CASE %WM_INITDIALOG
         ' disable Abort button, Start button waiting for file to be selected
         CONTROL DISABLE  CBHNDL, %ID_START
         CONTROL DISABLE  CBHNDL, %ID_ABORT

         ' set up a timer so we can see that the screen is always updating
         ' one second (1000 millisecond) update period. We don't need the return value
         SetTimer CBHNDL, %ID_TIMER, 1& * 1000&, BYVAL %NULL

     CASE %WM_TIMER
         ' update the timer label with the current time
         sText =  DATE$ & " " & TIME$
         CONTROL  SET TEXT CBHNDL, %ID_DATETIME, sText

     CASE %WM_SYSCOMMAND

         IF  (CBWPARAM AND &hFFF0) = %SC_CLOSE THEN
             DIALOG GET USER CBHNDL, %DSU_HTHREAD TO hThread
             IF ISTRUE hThread THEN
                 MSGBOX    "Must abort worker thread function " & $CRLF _
                        & "(or wait for it to complete) to exit", _
                          %MB_APPLMODAL OR %MB_ICONHAND, "Can't Exit Now"
                 ' Return True To prevent default action (close).
                 FUNCTION = %TRUE
                 EXIT FUNCTION
             END IF
         END IF


     CASE %WM_DESTROY
         ' we should never get here unless it's OK to exit
         ' kill the timer
         KillTimer  CBHNDL, %ID_TIMER

     CASE %WM_COMMAND
       SELECT CASE AS LONG CBCTL

          CASE %ID_START
              ' should not be enabled unless the file in the filename control is available
              ' create a ready event and save in the designated dialog user value slot

              ' start a worker thread, passing handle to the dialog
              ' create a ready event:
              hEventReady     =  m_CreateThreadReadyEvent
              ' store it where our thread function can read it:
              DIALOG SET USER  CBHNDL, %DSU_HEVENTREADY, hEVentReady
              ' get filename and set the pointer; cannot use CONTROL GET TEXT from thread function
              ' since this thread is in a Wait State

              CONTROL GET TEXT CBHNDL, %ID_FILENAME TO sText
              DIALOG  SET USER CBHNDL, %DSU_FILENAME_PTR, VARPTR(sText)

              ' create suspended, set priority, and resume:
              THREAD CREATE WorkerThreadFunction (CBHNDL) SUSPEND TO hThread
              SetThreadPriority  hThread, %THREAD_PRIORITY_BELOW_NORMAL
              THREAD RESUME hThread  TO iRet  ' hard to believe the "TO var" is REQUIRED huh?
              ' wait for the thread function to copy its run parameters:
              WaitForSingleObject  hEventReady, %INFINITE
              ' clean up
              CloseHandle          hEventReady

              ' Save the (open) thread handle
              DIALOG SET USER CBHNDL, %DSU_HTHREAD, hThread
              ' now that thread function has started, disable the start and enable the abort buttons
              CONTROL DISABLE    CBHNDL, %ID_START
              CONTROL ENABLE     CBHNDL, %ID_ABORT
              ' -------------------------------------------------------------------
              ' HERE IS THE POINT WHERE YOU WOULD DISABLE/ENABLE *ALL* CONTROLS
              ' WHOSE ENABLE STATUS DEPENDS IF A WORKER THREAD IS RUNNING OR NOT.
              ' -------------------------------------------------------------------




          CASE %ID_ABORT
              ' should not be enabled unless a worker thread is running.
              DIALOG GET USER CBHNDL, %DSU_HTHREAD TO hTHREAD
              CALL   AbortWorkerThread (CBHNDL, hThread)
              ' this will (eventually) post a completion message to this window,
              ' at which time we close the thread handle

          CASE %ID_FILENAME_BROWSE

'FUNCTION OpenFileDialog (BYVAL hWnd AS DWORD, _            ' parent window
'                         BYVAL sCaption AS STRING, _       ' caption
'                         sFileSpec AS STRING, _            ' filename
'                         BYVAL sInitialDir AS STRING, _    ' start directory
'                         BYVAL sFilter AS STRING, _        ' filename filter
'                         BYVAL sDefExtension AS STRING, _  ' default extension
'                         dFlags AS DWORD _                 ' flags
'                        ) AS LONG
              sText = ""
              IF OpenFileDialog(CBHNDL, "Select File to Process", sText, "", "*.*","", %OFN_FILEMUSTEXIST) THEN
                   CONTROL SET TEXT CBHNDL, %ID_FILENAME, sText
                   ' this will trigger an EN_CHANGE which will enable the ID_START if it should be enabled
              END IF



          CASE %ID_FILENAME
              ' check if the file is avaiable and no worker thread is running already,
              ' if so enable the start button
              IF CBCTLMSG = %EN_CHANGE THEN
                 DIALOG GET USER CBHNDL, %DSU_HTHREAD TO hThread
                 IF ISFALSE hThread THEN    ' no worker thread is running, so we can enable
                                            ' the 'go' button if this file is valid
                      CONTROL GET TEXT CBHNDL, %ID_FILENAME TO sText
                      IF DIR$ (sText) > "" THEN
                           CONTROL ENABLE CBHNDL, %ID_START
                      ELSE
                           CONTROL DISABLE CBHNDL, %ID_START
                      END IF
                 END IF
              END IF

      END SELECT

   CASE %PWM_THREAD_FUNCTION_COMPLETED

       SText       = "Worker Thread Function Completed via "  & IIF$(CBLPARAM, "Manual Abort", "Natural Causes")
       CONTROL    SET TEXT CBHNDL, %ID_PROGRESS, Stext

      ' diasable abort
       CONTROL DISABLE CBHNDL, %ID_ABORT
       ' close the open Thread handle
       DIALOG GET USER CBHNDL,  %DSU_HTHREAD TO hThread
       THREAD CLOSE hThread  TO hThread
       DIALOG SET USER CBHNDL, %DSU_HTHREAD, %NULL   ' set to %NULL so we know no worker thread
                                                     ' function is currently exectuting.

      ' enable the start button if we have a valid file in the control
      CONTROL GET TEXT CBHNDL, %ID_FILENAME TO sText
      IF DIR$ (sText) > "" THEN
          CONTROL ENABLE  CBHNDL, %ID_START
      END IF
     ' -------------------------------------------------------------------
     ' HERE IS THE POINT WHERE YOU WOULD DISABLE/ENABLE *ALL* CONTROLS
     ' WHOSE ENABLE STATUS DEPENDS IF A WORKER THREAD IS RUNNING OR NOT.
     ' (HERE THREAD FUNCTION IS *NOT* RUNNING).
     ' -------------------------------------------------------------------


 END SELECT


END FUNCTION

' ----------------------------------------------------------
' Worker thread function. Processes the current file by reading it
' %NUMBER_CYCLES times or until manually aborted, then exits after
' posting a private message to the calling Window/Dialog (passed parameter).
' ----------------------------------------------------------
THREAD FUNCTION WorkerThreadFunction (BYVAL hDlg AS LONG) AS LONG

 LOCAL sFile AS STRING, hFile AS LONG, nRecord AS LONG, Z AS LONG, W AS STRING, S AS STRING
 LOCAL sTExt AS STRING, iRecord AS LONG
 LOCAL pFilename AS STRING PTR
 ' ------Wait Variables ------
 LOCAL heventReady   AS LONG
 LOCAL bWaitAll      AS LONG
 LOCAL iWait         AS LONG
 '----- event variables ------
 LOCAL szEventAbort  AS ASCIIZ * 64, hEvent() AS LONG
 LOCAL lpSecurity    AS SECURITY_ATTRIBUTES PTR
 LOCAL bManualReset  AS LONG, bInitialState AS LONG
 LOCAL bAbort        AS LONG
 LOCAL SE            AS LONG

 ' ---------------------------------------------------------------
 ' Get our thread parameters into LOCAL variables before allowing
 ' the calling thread to continue.
 ' ----------------------------------------------------------------

 DIALOG GET USER  hDlg, %DSU_HEVENTREADY TO hEventReady
 DIALOG GET USER  hDlg, %DSU_FILENAME_PTR TO pFileName
 ' -----------------------------------------------------------------------------------------------------
 ' I had to use a string ptr here instead of CONTROL GET TEXT because the calling thread was in a wait
 ' state (WaitForSingleObject) and apparently (undocumented but not reasonably) CONTROL GET TEXT does
 ' "something" which must execute in the context of the same thread (suspended) as the dialog.
 ' Apparently (that means also not documented), DIALOG GET USER does not need to execute anything in the
 ' context of the thread in which the dialog was created.
 ' -----------------------------------------------------------------------------------------------------

 sFile          = @pFileName
 ' signal the calling thread we have copied our parameters and it may continue
 SetEvent         hEventReady


 ' ------------Set up processing events -------------------------------------------------
 ' We will be looking for two events: an 'abort' event and a 'continue' event.
 ' WaitForMultipleObjects will suspend this thread until EITHER event is signalled.
 ' The 'continue' event is created in a signalled state and remains in that state;
 ' the abort event is created unsignalled, and is signalled by calling SetEvent() at the
 ' appropriate times.


 ' We want the abort event to be first (in the array assed to WaitForMultipleObjects), since
 ' WFMO returns the LOWEST (first) event which is signalled when more than one
 ' event is signalled.

   REDIM hEvent(1)   ' we need to monitor two events in total

 ' Create our abort event as first event in the array
 ' We use a named event so other parts of the program have access to it.
   szEventAbort       = $EVENT_ABORT
   bManualReset       = %TRUE   ' The only choice for control freaks. Actually it's immaterial in this program.
   lpSecurity         = %NULL   ' null pointer ==> Default security
   bInitialSTate      = %FALSe  ' create unsignalled.
   hEvent(0)          = CreateEvent (BYVAL lpSecurity, bManualreset, bInitialState, szEventAbort)

  ' Create an unnamed event in signalled state as event #2, so worker thread processes forever -
  ' or at least processes until it completes the task or is manually aborted.
   bManualReset     = %TRUE    ' Do not allow system to reset this to unsignalled
                               ' which it will do if not manual reset type!
   bInitialState    = %TRUE    ' Create this event signalled so wait will be satisfied.
  ' This event does not need a name: no other functions need access to it!
   hEvent(1)        = CreateEvent ( BYVAL lpSecurity, bManualReset, bInitialState, BYVAL %NULL)

    ' set parameter for the wait:
   bWaitAll         = %FALSE      ' we want WFMO to return when EITHER event is signalled (or both).

   ' --------------------------------------------
   ' PROCESS THE FILE %NUMBER_CYCLE TIMES
   ' --------------------------------------------

   FOR Z = 1 TO %NUMBER_CYCLES

      hFile   = FREEFILE
      OPEN      sFile FOR INPUT AS hFile
      FILESCAN  hFile, RECORDS TO nRecord
      w        = USING$ ("Scanned #, Records for cycle # of # ", nRecord, Z, %NUMBER_CYCLES)
      CONTROL    SET TEXT hDlg, %ID_PROGRESS, W
      iRecord  = 0&      ' record counter for each cycle

      ' now process each record of the file
       DO
          ' Wait until either the abort event (object 1) or the continue event (object 2) is signalled.
          ' Since 'continue' is ALWAYS signalled, this function will always return immediately
          ' and it's just a matter of deciding if Abort was signalled or not.
          ' iWait will be the LOWEST of the the signalled events when more than one event is signalled.
          iWait = WaitForMultipleObjects (BYVAL 2&, BYVAL VARPTR(hEvent(0)), bWaitAll, %INFINITE)
          SE    = GetLastError

          SELECT CASE AS LONG iWait
              CASE %WAIT_OBJECT_0     ' first event, the abort, satisfied the waut
                bAbort = %TRUE
                EXIT DO

              CASE %WAIT_OBJECT_0 + 1  ' second event, the "please continue" , satisfied the wait.

                 IF NOT EOF(hFile) THEN
                      LINE INPUT #hFile, S
                      INCR iRecord
                      IF iRecord MOD %PROGRESS_MODULO = 0 THEN
                         sText = USING$ ("Processed #, of #, Records in Cycle # of #", iRecord, nrecord, Z, %NUMBER_CYCLES)
                         CONTROL SET TEXT hDlg, %ID_PROGRESS, sText
                      END IF
                      ' way too fast to demo unless I code a delay in here (with small file)
                       SLEEP  5
                 ELSE          ' end of file
                     ' set cool message
                     sText = USING$ ("All #, records processed in Cycle #", nRecord, Z)
                     CONTROL SET TEXT hDlg, %ID_PROGRESS, sText
                     EXIT DO
                 END IF

             CASE ELSE
                 ' needless to say, you should not get here. Ever.
                 MSGBOX "Oops!" & SystemErrorMessageText (SE)
                 EXIT DO
          END SELECT

       LOOP

       CLOSE hFile  ' done with this cycle
       ' Go again? or all done?
       IF bAbort THEN
           EXIT FOR
       END IF


  NEXT Z   ' repeat file processing

  ' Close our handles to both events since we are done with them
  ' Since we acquired the handles in this procedure, we should close them here. No, that's not
  ' any kind of "rule" but it is IMNSHO a "Best Programming Practice"
  CloseHandle  hEvent(0)
  CloseHandle  hEvent(1)

  ' post message to calling window with results; set lparam = the abort status
  DIALOG POST hDlg, %PWM_THREAD_FUNCTION_COMPLETED, %NULL, bAbort

END FUNCTION
'/// END OF FILE
