#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

'#RESOURCE "AP-CSV.pbr"

#RESOURCE ICON,     ICON_ID, "AP-CSV.ICO"


#INCLUDE "comdlg32.inc"
#INCLUDE "win32api.inc"

#PBFORMS BEGIN CONSTANTS
%MAXPPS_SIZE           = 2048   '*
%FRAME_TECHNICIAN      = 1000   '*
%TEXTBOX_TECH          = 1001   '*
%BUTTON_ADDTECH        = 1002   '*
%BUTTON_REMTECH        = 1003   '*
%LISTBOX_TECH          = 1004   '*
%FRAME_EXP             = 1005   '*
%TEXTBOX_EXP           = 1006   '*
%BUTTON_ADDEXP         = 1007   '*
%BUTTON_REMEXP         = 1008   '*
%LISTBOX_EXP           = 1009   '*
%BUTTON_OK             = 1010
%BUTTON_CANCEL         = 1011   '*
%IDD_DIALOG1           =  101
%IDC_LABEL1            = 2049
%IDC_TEXTBOX_SubjectID = 2050
%IDC_BUTTON1           = 2051   '*
%IDC_BUTTON_Process    = 2052
%IDC_BUTTON_Close      = 2053
#PBFORMS END CONSTANTS


GLOBAL ghDlg AS DWORD
GLOBAL filename, extension, newFilename AS ASCIIZ * 255


' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD

    CALL dlgModifyTechExpt()

    DIALOG SHOW MODAL ghDlg, CALL cbModifyTechExpt TO hr

     PostQuitMessage hr
        'SetWindowsPos

END FUNCTION

SUB dlgModifyTechExpt()
    LOCAL hr AS DWORD

    GLOBAL ghDlg AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW PIXELS, 0, "Audio Paced Trials - CSV Utility", 238, 222, _
        318, 140, %WS_POPUP OR %WS_CAPTION OR %WS_SYSMENU OR %WS_MINIMIZEBOX _
        OR %WS_MAXIMIZEBOX OR %WS_VISIBLE OR %DS_MODALFRAME OR %DS_CENTER OR _
        %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_CONTROLPARENT _
        OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO _
        ghDlg
    CONTROL ADD TEXTBOX, ghDlg, %IDC_TEXTBOX_SubjectID, "0000", 139, 18, 112, _
        32, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  ghDlg, %BUTTON_OK, "Get File", 24, 88, 83, 32
    CONTROL ADD BUTTON,  ghDlg, %IDC_BUTTON_Process, "Process", 120, 88, 83, _
        32
    CONTROL ADD BUTTON,  ghDlg, %IDC_BUTTON_Close, "Close", 216, 88, 83, 32
    CONTROL ADD LABEL,   ghDlg, %IDC_LABEL1, "Subject ID:", 24, 24, 104, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT ghDlg, %IDC_TEXTBOX_SubjectID, hFont1
    CONTROL SET FONT ghDlg, %BUTTON_OK, hFont1
    CONTROL SET FONT ghDlg, %IDC_BUTTON_Process, hFont1
    CONTROL SET FONT ghDlg, %IDC_BUTTON_Close, hFont1
    CONTROL SET FONT ghDlg, %IDC_LABEL1, hFont1


    DIALOG SET ICON ghDlg, "ICON_ID"

END SUB

CALLBACK FUNCTION cbModifyTechExpt()
    LOCAL x, lResult AS LONG
    LOCAL temp AS STRING
    LOCAL PS AS paintstruct
    LOCAL sFileSpec, subjectID AS STRING

    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
        CASE %WM_DESTROY
            'PostQuitMessage 0

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_TEXTBOX_SubjectID

                CASE %BUTTON_OK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CONTROL GET TEXT ghDlg, %IDC_TEXTBOX_SubjectID TO subjectID

                        OpenFileDialog (0, _                                  ' parent window
                              "Open .EVT File", _                         ' caption
                              sFileSpec, _                          ' filename   <- gets set to user selection
                              "C:\DOPS_Experiments\Subject_Data\" + subjectID, _                            ' start directory
                              "EVT Files|*.evt", _  ' filename filter
                              "evt", _                              ' default extension
                              0 _                                   ' flags
                             ) TO lResult

                          IF (lResult <> 0) THEN                                      ' Res nonzero = Not cancelled, No error
                            filename =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
                          END IF
                    END IF

                CASE %IDC_BUTTON_Process
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       GetEventTimes()
                    END IF

                CASE %IDC_BUTTON_Close
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        PostQuitMessage 1
                        DIALOG END ghDlg, 1
                    END IF

            END SELECT

        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION


SUB GetEventTimes()
    LOCAL flag AS BYTE
    LOCAL x, lCnt, lStart, lEnd, lMiddle AS LONG
    LOCAL temp, intention, milliStart, milliEnd AS STRING


    newFilename = PATHNAME$(NAME, filename) + "-Times.csv"

    OPEN filename FOR INPUT AS #1
    OPEN newFilename FOR OUTPUT AS #2

    lCnt = 0
    flag = 0
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp

        temp = TRIM$(temp)

        lStart = INSTR(temp, "StartExperiment")
        IF (lStart <> 0) THEN
            FOR x = 1 TO 8
                LINE INPUT #1, temp
            NEXT x
           ITERATE LOOP
        END IF

        lStart = INSTR(temp, "IntentionSelected")
        IF (lStart <> 0) THEN
           ITERATE LOOP
        END IF

        lStart = INSTR(temp, "<ElapsedMillis>")
        IF (lStart <> 0) THEN
            flag = 1
            INCR lCnt
            lEnd = INSTR(temp, "</ElapsedMillis>")
            lMiddle = lEnd - (lStart + 15)
            IF (lCnt = 1) THEN
                milliStart = MID$(temp, (lStart + 15), lMiddle)
            ELSEIF (lCnt = 2) THEN
                milliEnd = MID$(temp, (lStart + 15), lMiddle)
                lCnt = 0
            END IF
        END IF



        lStart = INSTR(temp, "Intention")
        IF (lStart <> 0) THEN
            lEnd = INSTR(temp, "</GV>")
            lMiddle = lEnd - (lStart + 11)
            intention = MID$(temp, (lStart + 11), lMiddle)
            IF (flag = 1) THEN
                PRINT #2, milliStart + ", " + milliEnd + ", " + intention
                flag = 0
            END IF
        END IF


        lStart = INSTR(temp, "Milliseconds")
        IF (lStart <> 0) THEN
            INCR lCnt
            lEnd = INSTR(temp, "</GV>")
            lMiddle = lEnd - (lStart + 14)
            IF (lCnt = 1) THEN
                milliStart = MID$(temp, (lStart + 14), lMiddle)
            ELSEIF (lCnt = 2) THEN
                milliEnd = MID$(temp, (lStart + 14), lMiddle)
                PRINT #2, milliStart + ", " + milliEnd + ", " + intention
                lCnt = 0
            END IF

        END IF
    WEND

    CLOSE #1
    CLOSE #2

    MSGBOX "Done. " + newFilename + " created."


END SUB

SUB ModifyEventTimes(filename AS STRING)
END SUB
