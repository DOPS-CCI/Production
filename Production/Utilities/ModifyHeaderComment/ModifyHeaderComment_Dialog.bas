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
#RESOURCE "ModifyHeaderComment_Dialog.pbr"
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
%TEXTBOX_COMMENT = 1000
%ID_OPEN         = 1001
%ID_SAVE         = 1002
%ID_CANCEL       = 1003
%IDD_DIALOG1     =  101
%IDC_9000        = 9000
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

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
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()

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

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %TEXTBOX_COMMENT

                CASE %ID_OPEN
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%ID_OPEN=" + FORMAT$(%ID_OPEN), %MB_TASKMODAL
                    END IF

                CASE %ID_SAVE
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%ID_SAVE=" + FORMAT$(%ID_SAVE), %MB_TASKMODAL
                    END IF

                CASE %ID_CANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        MSGBOX "%ID_CANCEL=" + FORMAT$(%ID_CANCEL), _
                            %MB_TASKMODAL
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
    LOCAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, hParent, "Modify Header Session Comment", 230, 214, _
        675, 300, %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
    CONTROL ADD LABEL,   hDlg, %IDC_9000, "Modify Header Comment below:", 20, _
        12, 240, 25
    CONTROL ADD TEXTBOX, hDlg, %TEXTBOX_COMMENT, "", 16, 38, 640, 202, _
        %ES_MULTILINE OR %ES_WANTRETURN OR %WS_CHILD OR %WS_VISIBLE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  hDlg, %ID_OPEN, "Open", 192, 264, 75, 25
    CONTROL ADD BUTTON,  hDlg, %ID_SAVE, "Save", 296, 264, 75, 25
    CONTROL ADD BUTTON,  hDlg, %ID_CANCEL, "Close", 397, 264, 75, 25

    FONT NEW "Arial", 10, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_9000, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------


#PBFORMS COPY
'==============================================================================
'The following is a copy of your code before importing:
#IF 0
#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ModifyHeaderComment.pbr"

#INCLUDE "comdlg32.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"

%TEXTBOX_COMMENT = 1000
%ID_OPEN = 1001
%ID_SAVE = 1002
%ID_CANCEL = 1003

GLOBAL ghDlg AS DWORD
GLOBAL filename AS STRING

' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD


    CALL dlgControllerScreen()

    DIALOG SHOW MODAL ghDlg, CALL cbControllerScreen TO hr


        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION

SUB dlgControllerScreen()
    LOCAL hr AS DWORD

    DIALOG NEW PIXELS, 0, "Modify Header Session Comment", EXPERIMENT.Misc.Screen(0).x, EXPERIMENT.Misc.Screen(0).y, 675, 300, %WS_OVERLAPPEDWINDOW, 0 TO ghDlg
    ' Use default styles
    CONTROL ADD LABEL, ghDlg, 9000, "Modify Header Comment below:", 83, 18, 240, 25,,
    CONTROL ADD TEXTBOX, ghDlg, %TEXTBOX_COMMENT, "", 83, 38, 503, 125, %ES_MULTILINE OR %ES_WANTRETURN,
    CONTROL ADD BUTTON, ghDlg, %ID_OPEN, "Open", 173, 203, 75, 25,,, CALL cbControllerOpen()
    CONTROL ADD BUTTON, ghDlg, %ID_SAVE, "Save", 277, 203, 75, 25,,, CALL cbControllerSave()
    CONTROL ADD BUTTON, ghDlg, %ID_CANCEL, "Close", 378, 203, 75, 25,,, CALL cbControllerCancel()

    DIALOG SET ICON ghDlg, "Comments.ico"

END SUB

CALLBACK FUNCTION cbControllerScreen()
    LOCAL PS AS paintstruct

    SELECT CASE CBMSG
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
                CASE %IDCANCEL
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                        DIALOG END CBHNDL, 0
                    END IF
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbControllerOpen() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL Res AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here


          OpenFileDialog (0, _                                  ' parent window
                          "Open Header File", _                         ' caption
                          sFileSpec, _                          ' filename   <- gets set to user selection
                          CURDIR$, _                            ' start directory
                          "Hdr Files|*.hdr|All Files|*.*", _  ' filename filter
                          "hdr", _                              ' default extension
                          0 _                                   ' flags
                         ) TO Res

          IF Res <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            filename =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            CALL GetHeaderComment(filename)
          END IF

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerSave() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL ModifyHeaderComment(filename)
        CALL GetHeaderComment(filename)

        MSGBOX "Saved."

        'DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerCancel() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

        DIALOG END CBHNDL
        FUNCTION = 1
    END IF
END FUNCTION

SUB GetHeaderComment(filename AS STRING)
    LOCAL x, y, cnt, lPos AS LONG
    LOCAL tmpArray() AS STRING
    LOCAL comment AS STRING
    LOCAL flag AS INTEGER

    DIM tmpArray(2048)

    OPEN filename FOR INPUT AS #1

    LINE INPUT #1, tmpArray(0)

    cnt = 1
    WHILE ISFALSE EOF(1)  ' check if at end of file
      LINE INPUT #1, tmpArray(cnt)
      cnt = cnt + 1
    WEND

    CLOSE #1

    flag = 0
    FOR x = 1 TO cnt - 1
        lPos = INSTR(tmpArray(x), "<SessionDescription>")
        IF (lPos <> 0) THEN
            FOR y = x TO cnt - 1
                lPos = INSTR(tmpArray(y), "<Comment>")
                IF (lPos <> 0) THEN
                    flag = 1
                    comment = EXTRACT$(lPos + 9, tmpArray(y), "</")
                    CONTROL SET TEXT ghDlg, %TEXTBOX_COMMENT, comment
                    EXIT FOR
                END IF
            NEXT y
            EXIT FOR
        END IF
    NEXT x

    IF (flag = 0) THEN
        MSGBOX "No <Comment></Comment> found."
        SHELL("notepad.exe " + filename)
    END IF
END SUB

SUB ModifyHeaderComment(filename AS STRING)
    LOCAL x, y, cnt, lPos AS LONG
    LOCAL tmpArray() AS STRING
    LOCAL temp, comment, newComment AS STRING

    DIM tmpArray(2048)

    OPEN filename FOR INPUT AS #1

    LINE INPUT #1, tmpArray(0)

    cnt = 1
    WHILE ISFALSE EOF(1)  ' check if at end of file
      LINE INPUT #1, tmpArray(cnt)
      cnt = cnt + 1
    WEND

    CLOSE #1

    FOR x = 1 TO cnt - 1
        lPos = INSTR(tmpArray(x), "<SessionDescription>")
        IF (lPos <> 0) THEN
            FOR y = x TO cnt - 1
                lPos = INSTR(tmpArray(y), "<Comment>")
                IF (lPos <> 0) THEN
                    comment = EXTRACT$(lPos + 9, tmpArray(y), "</")
                    CONTROL GET TEXT ghDlg, %TEXTBOX_COMMENT TO newComment
                    temp = " (" + DATE$ + " " + TIME$ + ")"
                    newComment = newComment + temp
                    REPLACE comment WITH newComment IN tmpArray(y)
                    EXIT FOR
                END IF
            NEXT y
            EXIT FOR
        END IF
    NEXT x

    OPEN filename FOR OUTPUT AS #1


    FOR x = 1 TO cnt - 1
        PRINT #1, tmpArray(x)
    NEXT x

    CLOSE #1
END SUB

#ENDIF
'==============================================================================

