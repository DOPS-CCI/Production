#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ModifyHeaderComment.pbr"

#INCLUDE "comdlg32.inc"
#INCLUDE "win32api.inc"
#INCLUDE ONCE "RICHEDIT.INC"
#INCLUDE ONCE "PBForms.INC"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"
#INCLUDE "ModifyHeaderCommentXML.inc"

%MAXPPS_SIZE = 2048

%TEXTBOX_COMMENT = 1000
%ID_OPEN = 1001
%ID_SAVE = 1002
%ID_CANCEL = 1003
%IDC_9000                     = 9000
%IDC_CHECKBOX_PrefillSettings = 9001
%IDC_RICHEDIT_Comment = 9002

GLOBAL hDlg AS DWORD
GLOBAL gHdrFilename, gOriginalComment AS STRING
GLOBAL gIniFilename AS ASCIIZ * 512
GLOBAL gPrefillChecked AS LONG

' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL cmdCnt AS LONG
    LOCAL temp, temp2 AS STRING

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gHdrFilename = COMMAND$(1)
            CASE 2
                gHdrFilename = COMMAND$(1)
                gIniFilename = COMMAND$(2)
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    'ELSE
    '    MSGBOX "No experiment .HDR file name passed via the command line."
    '    EXIT FUNCTION  ' No command-line params given, just quit
    END IF

    'PBFormsRichEdit ()      ' Load RichEdit

    CALL dlgControllerScreen()

    DIALOG SHOW MODAL hDlg, CALL cbControllerScreen TO hr

    'PBFormsRichEdit (%TRUE) ' Unload RichEdit

        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION

SUB dlgControllerScreen()
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD

    DIALOG NEW PIXELS, 0, "Modify Header Session Comment", 181, 112, _
        675, 300, %WS_POPUP OR %WS_CAPTION OR %WS_SYSMENU OR %WS_MINIMIZEBOX _
        OR %WS_MAXIMIZEBOX OR %WS_VISIBLE OR %DS_3DLOOK OR %DS_NOFAILCREATE _
        OR %DS_SETFONT, %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD LABEL,    hDlg, %IDC_9000, "Modify Header Comment below:", _
        24, 8, 240, 25
    CONTROL ADD TEXTBOX,  hDlg, %TEXTBOX_COMMENT, "", 24, 38, 632, 186, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %ES_LEFT OR %ES_MULTILINE OR %ES_AUTOVSCROLL OR _
        %ES_WANTRETURN, %WS_EX_CLIENTEDGE OR %WS_EX_STATICEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
'    CONTROL ADD PBFormsRichEdit(), hDlg, %IDC_RICHEDIT_Comment, "", 16, 40, _
'        640, 192, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
'        %WS_VSCROLL OR %ES_LEFT OR %ES_MULTILINE OR %ES_AUTOHSCROLL OR _
'        %ES_AUTOVSCROLL OR %ES_WANTRETURN, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT _
'        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,   hDlg, %ID_OPEN, "Open", 168, 248, 75, 33,,, CALL cbControllerOpen()
    CONTROL ADD BUTTON,   hDlg, %ID_SAVE, "Save", 272, 248, 75, 33,,, CALL cbControllerSave()
    CONTROL ADD BUTTON,   hDlg, %ID_CANCEL, "Close", 373, 248, 75, 33,,, CALL cbControllerCancel()
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_PrefillSettings, "Prefill " + _
        "Settings", 344, 8, 136, 24

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT hDlg, %IDC_9000, hFont1
    CONTROL SET FONT hDlg, %TEXTBOX_COMMENT, hFont2
    CONTROL SET FONT hDlg, %ID_OPEN, hFont1
    CONTROL SET FONT hDlg, %ID_SAVE, hFont1
    CONTROL SET FONT hDlg, %ID_CANCEL, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_PrefillSettings, hFont1

    CONTROL HIDE hDlg, %IDC_CHECKBOX_PrefillSettings

END SUB

FUNCTION LoadThetaTrainerSettings() AS STRING
    LOCAL temp  AS ASCIIZ * 256
    LOCAL settings AS STRING
    LOCAL sb AS ISTRINGBUILDERA

    sb = CLASS "StringBuilderA"


    GetPrivateProfileString("Theta Settings", "MIDI Instrument", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("MIDI Instrument: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "MP3 File", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("MP3 File: " + temp + " " + $CRLF)


    GetPrivateProfileString("Theta Settings", "EEGRMSThreshold", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("EEGRMSThreshold: " + temp + " " + $CRLF)


    GetPrivateProfileString("Theta Settings", "EMGChannel", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("EMGChannel: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "EEGChannel", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("EEGChannel: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "EMGRMSTime", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("EMGRMSTime: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "EEGRMSTime", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("EEGRMSTime: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "PitchSens", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("PitchSens: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "PitchBase", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("PitchBase: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "VolSens", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("VolSens: " + temp + " " + $CRLF)

    GetPrivateProfileString("Theta Settings", "VolBase", "", temp, %MAXPPS_SIZE, gIniFilename)
    sb.add("VolSens: " + temp + " " + $CRLF)

    FUNCTION = sb.string
END FUNCTION

CALLBACK FUNCTION cbControllerScreen()
    LOCAL PS AS paintstruct
    LOCAL settings, comment AS STRING

    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
            IF (TRIM$(gHdrFilename) <> "") THEN
                CALL GetHeaderComment(gHdrFilename)
                CONTROL GET TEXT hDlg, %TEXTBOX_COMMENT TO gOriginalComment
            END IF
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
                CASE %IDCANCEL
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                        DIALOG END CBHNDL, 0
                    END IF
                CASE %IDC_CHECKBOX_PrefillSettings
                    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_PrefillSettings TO gPrefillChecked

                    IF (gPrefillChecked = 1) THEN    'Prefill the comments
                        settings = LoadThetaTrainerSettings()
                        CONTROL GET TEXT hDlg, %IDC_RICHEDIT_Comment TO comment
                        comment = comment + $CRLF + settings
                        CONTROL SET TEXT hDlg, %IDC_RICHEDIT_Comment, comment
                        CONTROL REDRAW hDlg, %IDC_RICHEDIT_Comment
                    ELSE
                        CONTROL SET TEXT hDlg, %IDC_RICHEDIT_Comment, gOriginalComment
                        CONTROL REDRAW hDlg, %IDC_RICHEDIT_Comment
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
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here


          OpenFileDialog (0, _                                  ' parent window
                          "Open Header File", _                         ' caption
                          sFileSpec, _                          ' filename   <- gets set to user selection
                          "C:\DOPS_Experiments\Subject_Data", _                            ' start directory
                          "Hdr Files|*.hdr|All Files|*.*", _  ' filename filter
                          "hdr", _                              ' default extension
                          0 _                                   ' flags
                         ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            gHdrFilename =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            CALL GetHeaderComment(gHdrFilename)
          END IF

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbControllerSave() AS LONG
    LOCAL hr AS DWORD
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        CALL ModifyHeaderComment(gHdrFilename)
        CALL GetHeaderComment(gHdrFilename)

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
                    CONTROL SET TEXT hDlg, %TEXTBOX_COMMENT, comment
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
                    comment = "<Comment>" + comment + "</Comment>"
                    CONTROL GET TEXT hDlg, %TEXTBOX_COMMENT TO newComment
                    temp = " (" + DATE$ + " " + TIME$ + ")"
                    newComment = "<Comment>" + newComment + temp  + "</Comment>"
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


SUB GetHeaderComment2(filename AS STRING)
    LOCAL pXmlDoc AS IXMLDOMDocument
    LOCAL i, flag AS LONG
    LOCAL newComment AS STRING

    pXmlDoc = NEWCOM "Msxml2.DOMDocument.6.0"
    IF ISNOTHING(pXmlDoc) THEN EXIT SUB

    newComment = ""
    flag = 1
    TRY
        pXmlDoc.async = 0 '%VARIANT_FALSE
        pXmlDoc.load filename
        IF pXmlDoc.parseError.errorCode THEN
            MSGBOX "You have error " + pXmlDoc.parseError.reason
        ELSE
            CONTROL GET TEXT hDlg, %IDC_RICHEDIT_Comment TO newComment
            getNode(pXmlDoc.childNodes, 0, "//Comment", newComment)
            IF (TRIM$(newComment) = "") THEN
                flag = 0
            ELSE
                CONTROL SET TEXT hDlg, %IDC_RICHEDIT_Comment, newComment
            END IF
        END IF
   CATCH
      MSGBOX "Object error"
   END TRY

   LET pXmlDoc = NOTHING

    'IF (flag = 0) THEN
    '    MSGBOX "No <Comment></Comment> found."
    '    SHELL("notepad.exe " + filename)
    'END IF


END SUB

SUB ModifyHeaderComment2(filename AS STRING)
    LOCAL pXmlDoc AS IXMLDOMDocument
    LOCAL i AS LONG
    LOCAL newComment AS STRING

    pXmlDoc = NEWCOM "Msxml2.DOMDocument.6.0"
    IF ISNOTHING(pXmlDoc) THEN EXIT SUB


    TRY
        pXmlDoc.async = 0 '%VARIANT_FALSE
        pXmlDoc.load filename
        IF pXmlDoc.parseError.errorCode THEN
            MSGBOX "You have error " + pXmlDoc.parseError.reason
        ELSE
            CONTROL GET TEXT hDlg, %IDC_RICHEDIT_Comment TO newComment
            newComment = newComment + " (" + DATE$ + " " + TIME$ + ") "
            CALL UpdateNode(pXmlDoc.childNodes, 0, "//Comment", newComment)
            pXmlDoc.save filename
        END IF
   CATCH
      MSGBOX "Object error"
   END TRY

   LET pXmlDoc = NOTHING
END SUB
