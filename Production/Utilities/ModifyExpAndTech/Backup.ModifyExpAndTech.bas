#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "ModifyExpAndTech.pbr"


#INCLUDE "comdlg32.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"

%MAXPPS_SIZE = 2048

%FRAME_TECHNICIAN = 1000
%TEXTBOX_TECH = 1001
%BUTTON_ADDTECH = 1002
%BUTTON_REMTECH = 1003
%LISTBOX_TECH = 1004
%FRAME_EXP = 1005
%TEXTBOX_EXP = 1006
%BUTTON_ADDEXP = 1007
%BUTTON_REMEXP = 1008
%LISTBOX_EXP = 1009

%BUTTON_OK = 1010
%BUTTON_CANCEL = 1011


GLOBAL ghDlg AS DWORD
GLOBAL filename, extension, techName, expName AS ASCIIZ * 255
GLOBAL techs(), exps() AS STRING

' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL hr AS DWORD
    LOCAL cmdLine AS STRING
    LOCAL sFileSpec AS STRING
    LOCAL RES AS LONG
    DIM techs(10), exps(10)

    cmdLine = COMMAND$

    IF (TRIM$(cmdLine) = "") THEN
        OpenFileDialog (0, _                                  ' parent window
              "Open .INI or .HDR File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "C:\DOPS_Experiments\Subject_Data", _                            ' start directory
              "HDR Files|*.hdr|INI Files|*.ini", _  ' filename filter
              "hdr", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            filename =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
          END IF
    ELSE
        filename = cmdLine
    END IF

    extension = LCASE$(PATHNAME$(EXTN,  filename))
    SELECT CASE extension
        CASE ".hdr"
            CALL GetHeaderInfo()
        CASE ".ini"
            CALL GetINIInfo()
    END SELECT


    'MSGBOX cmdLine

    CALL dlgModifyTechExpt()

    DIALOG SHOW MODAL ghDlg, CALL cbModifyTechExpt TO hr

     PostQuitMessage hr
        'SetWindowsPos
    CALL closeEventFile()

END FUNCTION

SUB dlgModifyTechExpt()
    LOCAL hr AS DWORD


    DIALOG NEW PIXELS, 0, "Modify Technician/Experimenter", 0, 0, 625, 280, %WS_OVERLAPPEDWINDOW OR %DS_CENTER, 0 TO ghDlg
    ' Use default styles
    CONTROL ADD FRAME, ghDlg, %FRAME_TECHNICIAN, "Technician:", 5, 5, 274, 211, ,
    CONTROL SET COLOR ghDlg, %FRAME_TECHNICIAN, %RGB_BLACK, %RGB_MISTYROSE
    CONTROL ADD TEXTBOX, ghDlg, %TEXTBOX_TECH, "", 12, 25, 153, 20, , ,
    CONTROL ADD BUTTON, ghDlg, %BUTTON_ADDTECH, "Add", 185, 97, 75, 25, , ,CALL cbAddTech
    CONTROL ADD BUTTON, ghDlg, %BUTTON_REMTECH, "Remove", 185, 126, 75, 25, , ,CALL cbRemoveTech
    CONTROL ADD LISTBOX, ghDlg, %LISTBOX_TECH, , 15, 75, 150, 120, , ,
    CONTROL ADD FRAME, ghDlg, %FRAME_EXP, "Experimenter:", 322, 5, 274, 211, ,
    CONTROL SET COLOR ghDlg, %FRAME_EXP, %RGB_BLACK, %RGB_SALMON
    CONTROL ADD TEXTBOX, ghDlg, %TEXTBOX_EXP, "", 333, 25, 153, 20, ,
    CONTROL ADD BUTTON, ghDlg, %BUTTON_ADDEXP, "Add", 506, 101, 75, 25, , ,CALL cbAddExp
    CONTROL ADD BUTTON, ghDlg, %BUTTON_REMEXP, "Remove", 506, 130, 75, 25, , ,CALL cbRemoveExp
    CONTROL ADD LISTBOX, ghDlg, %LISTBOX_EXP, , 336, 77, 150, 120, , ,
    CONTROL ADD BUTTON, ghDlg, %BUTTON_OK, "Save", 250, 244, 75, 25, , ,CALL cbOK


    DIALOG SET ICON ghDlg, "Modify.ico"

END SUB

CALLBACK FUNCTION cbModifyTechExpt()
    LOCAL x AS LONG
    LOCAL temp AS STRING
    LOCAL PS AS paintstruct

    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
            FOR x = 0 TO 10
                temp = techs(x)
                IF (temp = "") THEN
                    EXIT FOR
                END IF
                LISTBOX ADD ghDlg, %LISTBOX_TECH, temp
            NEXT x
            FOR x = 0 TO 10
                temp = exps(x)
                IF (temp = "") THEN
                    EXIT FOR
                END IF
                LISTBOX ADD ghDlg, %LISTBOX_EXP, temp
            NEXT x
        CASE %WM_DESTROY
            'PostQuitMessage 0

        CASE %WM_COMMAND

        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbAddTech() AS LONG
  IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
    '...Process the click event here
    CONTROL GET TEXT ghDlg, %TEXTBOX_TECH TO techName
    LISTBOX ADD ghDlg, %LISTBOX_TECH, techName
    CONTROL SET FOCUS ghDlg, %LISTBOX_TECH
    'control redraw  ghDlg, %LISTBOX_TECH
    'CONTROL post CB.HNDL, %TEXTBOX_TECH, %EM_SETSEL, CB.WPARAM, CB.LPARAM
    'CONTROL REDRAW  ghDlg, %LISTBOX_TECH

    FUNCTION = 1
  END IF
END FUNCTION

CALLBACK FUNCTION cbRemoveTech() AS LONG
    LOCAL sel AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        LISTBOX GET SELECT ghDlg, %LISTBOX_TECH TO sel
        LISTBOX DELETE ghDlg, %LISTBOX_TECH, sel

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbAddExp() AS LONG
    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT ghDlg, %TEXTBOX_EXP TO expName
        LISTBOX ADD ghDlg, %LISTBOX_EXP, expName
        CONTROL SET FOCUS ghDlg, %LISTBOX_EXP


        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbRemoveExp() AS LONG
    LOCAL sel AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        LISTBOX GET SELECT ghDlg, %LISTBOX_EXP TO sel
        LISTBOX DELETE ghDlg, %LISTBOX_EXP, sel

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbOK() AS LONG
    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here

        SELECT CASE extension
        CASE ".hdr"
            CALL SaveHeaderInfo()
        CASE ".ini"
            CALL SaveINIInfo()
        END SELECT

        PostQuitMessage 1
        DIALOG END ghDlg, 1

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbCancel() AS LONG
  IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
    '...Process the click event here

     PostQuitMessage 0
     DIALOG END ghDlg, 0
    FUNCTION = 1
  END IF
END FUNCTION

SUB GetHeaderInfo()
    LOCAL x, y, cnt, tempCnt, lPos AS LONG
    LOCAL tmpArray() AS STRING
    LOCAL expt, tech AS STRING
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
    tempCnt = -1
    FOR x = 1 TO cnt - 1
        lPos = INSTR(tmpArray(x), "<ExperimentDescription>")
        IF (lPos <> 0) THEN
            FOR y = x TO cnt - 1
                lPos = INSTR(tmpArray(y), "<Experimenter>")
                IF (lPos <> 0) THEN
                    tempCnt = tempCnt + 1
                    flag = 1
                    expt = EXTRACT$(lPos + 14, tmpArray(y), "</")
                    exps(tempCnt) = expt
                END IF
            NEXT y
            EXIT FOR
        END IF
    NEXT x

    flag = 0
    tempCnt = -1
    FOR x = 1 TO cnt - 1
        lPos = INSTR(tmpArray(x), "<SessionDescription>")
        IF (lPos <> 0) THEN
            FOR y = x TO cnt - 1
                lPos = INSTR(tmpArray(y), "<Technician>")
                IF (lPos <> 0) THEN
                    tempCnt = tempCnt + 1
                    flag = 1
                    tech = EXTRACT$(lPos + 12, tmpArray(y), "</")
                   techs(tempCnt) = tech
                END IF
            NEXT y
            EXIT FOR
        END IF
    NEXT x
END SUB

SUB SaveHeaderInfo()
    LOCAL x, y, z, cnt, tempCnt, lPos AS LONG
    LOCAL tmpArray() AS STRING
    LOCAL temp, comment, newComment, str AS STRING

    DIM tmpArray(2048)

    OPEN filename FOR INPUT AS #1

    LINE INPUT #1, tmpArray(0)

    cnt = 1
    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, tmpArray(cnt)
        lPos = INSTR(tmpArray(cnt), "<Experimenter>")
        IF (lPos <> 0) THEN
            ITERATE
        END IF
        lPos = INSTR(tmpArray(cnt), "<Technician>")
        IF (lPos <> 0) THEN
            ITERATE
        END IF
      cnt = cnt + 1
    WEND

    CLOSE #1


    OPEN filename FOR OUTPUT AS #1


    FOR x = 0 TO cnt - 1
        PRINT #1, tmpArray(x)
        lPos = INSTR(tmpArray(x), "</LongDescription")
        IF (lPos <> 0) THEN
            LISTBOX GET COUNT ghDlg, %LISTBOX_EXP TO y
            FOR z = 1 TO y
                LISTBOX GET TEXT ghDlg, %LISTBOX_EXP, z TO str
                PRINT #1, "    <Experimenter>" + str + "</Experimenter>"
            NEXT z
        END IF
        lPos = INSTR(tmpArray(x), "</Agent>")
        IF (lPos <> 0) THEN
            LISTBOX GET COUNT ghDlg, %LISTBOX_TECH TO y
            FOR z = 1 TO y
                LISTBOX GET TEXT ghDlg, %LISTBOX_TECH, z TO str
                PRINT #1, "    <Technician>" + str + "</Technician>"
            NEXT z
        END IF
     NEXT x

    CLOSE #1
END SUB


SUB GetINIInfo()
    LOCAL temp AS ASCIIZ * 1000

    GetPrivateProfileString("Experiment Section", "Experimenter", "", temp, %MAXPPS_SIZE, filename)
    PARSE temp, exps(), ","

    GetPrivateProfileString("Experiment Section", "Technician", "", temp, %MAXPPS_SIZE, filename)
    PARSE temp, techs(), ","
END SUB

SUB SaveINIInfo()
    LOCAL x, lbCount AS LONG
    LOCAL str, temp AS STRING

    temp = ""
    LISTBOX GET COUNT ghDlg, %LISTBOX_TECH TO lbCount
    FOR x = 1 TO lbCount
        LISTBOX GET TEXT ghDlg, %LISTBOX_TECH, x TO str
        temp = temp + str + ","
    NEXT x

    WritePrivateProfileString("Experiment Section", "Technician", LEFT$(temp, LEN(temp) - 1), filename)

    temp = ""
    LISTBOX GET COUNT ghDlg, %LISTBOX_EXP TO lbCount
    FOR x = 1 TO lbCount
        LISTBOX GET TEXT ghDlg, %LISTBOX_EXP, x TO str
        temp = temp + str + ","
    NEXT x

    WritePrivateProfileString("Experiment Section", "Experimenter", LEFT$(temp, LEN(temp) - 1), filename)
END SUB
