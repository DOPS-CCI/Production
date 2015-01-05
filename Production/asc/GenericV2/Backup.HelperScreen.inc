SUB dlgControllerHelperScreen()
    LOCAL temp, temp2, cond, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255
    LOCAL condCode, x AS INTEGER

         #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    DIALOG NEW PIXELS, 0, "Enter parameters", 339, 92, 479, 724, _
        %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 66, 12, 100, 20, _
        %ES_NUMBER OR %WS_CHILD OR %WS_VISIBLE, %WS_EX_CLIENTEDGE OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, "", 64, 48, 384, 88, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_MULTILINE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL, "", 72, 272, _
        192, 24
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_VALUE, "", 72, 299, _
        56, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_NUMBER, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_GVADD, "&Add", 368, 347, 64, 32, , ,  CALL cbAddCondition
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_GVDELETE, "&Delete", 368, 391, 64, 32, , , CALL cbRemoveCondition
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %TEXTBOX_COMMENT, "", 16, 527, 448, 43, , , CALL cbHelperScreenHelp
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 144, _
        584, 152, 32, , , CALL cbHelperScreenEEGSettings
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", 144, _
        623, 152, 32, , , CALL cbHelperScreenLongDesc
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 104, 688, 75, 23, _
        %BS_DEFAULT OR %BS_CENTER OR %BS_VCENTER OR %BS_TEXT OR %WS_CHILD OR _
        %WS_VISIBLE, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    DIALOG  SEND         globals.hdl.DlgHelper, %DM_SETDEFID, %BUTTON_HELPEROK, 0
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 195, 688, 75, 23, , ,CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,  globals.hdl.DlgHelper, %BUTTON_HELP, "?", 295, 687, 24, 24
    CONTROL ADD FRAME,   globals.hdl.DlgHelper, %IDC_FRAME1, "Set Levels of ASC Condition " + _
        "Variables", 8, 251, 448, 224
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9903, "Subject ID:", 6, 16, 60, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_9905, "Initial comment:", 19, 512, 80, 13
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL1, "Group Variable:", 2, 183, 80, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR, "ASCCondition", 88, _
        180, 192, 24, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR _
        %ES_AUTOHSCROLL OR %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR _
        %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX, globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC, "The GV is used " + _
        "for generic ASC experiments.", 88, 207, 298, 24, %WS_CHILD OR _
        %WS_VISIBLE OR %WS_TABSTOP OR %ES_LEFT OR %ES_AUTOHSCROLL OR _
        %ES_READONLY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL2, "Description:", 10, 210, 72, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL3, "Level:", 16, 275, 50, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL4, "Value:", 24, 302, 42, 24, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LISTBOX, globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, , 16, 331, 320, _
        136, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_VSCROLL OR _
        %LBS_NOTIFY, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING _
        OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD LINE,    globals.hdl.DlgHelper, %IDC_LINE1, "Line1", 0, 167, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LINE,    globals.hdl.DlgHelper, %IDC_LINE2, "Line1", 0, 483, 480, 8, %WS_CHILD _
        OR %WS_VISIBLE OR %SS_BLACKFRAME
    CONTROL ADD LABEL,   globals.hdl.DlgHelper, %IDC_LABEL5, "Description:", 4, 52, 60, 13
#PBFORMS END DIALOG

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Subject Section", "ID", "", temp, %MAXPPS_SIZE, filename)
    CONTROL SET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, temp

    GetPrivateProfileString("Experiment Section", "Description", "", temp, %MAXPPS_SIZE, filename)
    CONTROL SET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, temp

    GetPrivateProfileString("Experiment Section", "Comment", "", temp, %MAXPPS_SIZE, filename)
    CONTROL SET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT, temp

    '****************************************************************************
    'Reading in the conditions and the condition codes from the
    'ASCCondition.txt file and pre-filling the listbox.
    '****************************************************************************

    CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR TO temp
    tempFileName = filename
    REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\" + temp + ".txt" IN tempFileName

        OPEN tempFileName FOR INPUT AS #1

        INPUT #1, GVDesc
        CONTROL SET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC, GVDesc

        x = 1
        DO
            INPUT #1, cond, condCode, temp2
            IF (cond = "xxx") THEN
                EXIT LOOP
            END IF
            temp = cond + "," + STR$(condCode)
            LISTBOX SET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x, temp
            x = x + 1
        LOOP

        CLOSE #1

    CONTROL SET FOCUS globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID
END SUB

CALLBACK FUNCTION cbControllerHelperScreen()
    LOCAL PS AS paintstruct
    LOCAL temp AS STRING
    LOCAL lError AS LONG

    SELECT CASE CBMSG
         CASE %WM_INITDIALOG
            gHelperOpened = 1 'Helper screen opened
        CASE %WM_DESTROY
            gHelperOpened = 0
            PostQuitMessage 0

        CASE %WM_COMMAND
            SELECT CASE CBCTL
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbHelperScreenLongDesc() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "H:\ModifyLongDescription\ModifyLongDescription.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION

CALLBACK FUNCTION cbHelperScreenEEGSettings() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "",  EXPERIMENT.ActiviewConfig, 255, filename)


    SHELL "H:\EEGSettings3\EEGSettingsScreen.exe " + EXPERIMENT.ActiviewConfig + " " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
END FUNCTION

CALLBACK FUNCTION cbAddCondition() AS LONG
    LOCAL condLevel, condValue AS STRING

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL TO condLevel
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_VALUE TO condValue
        LISTBOX ADD globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, condLevel + "," + condValue
        CONTROL SET FOCUS globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL
        'Highlights the text in the textbox
        CONTROL SEND globals.hdl.DlgHelper, %IDC_TEXTBOX_GV_CONDITION_LEVEL, %EM_SETSEL, 0, -1


        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbRemoveCondition() AS LONG
    LOCAL sel AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        LISTBOX GET SELECT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO sel
        LISTBOX DELETE globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, sel

        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y, lbCount, pid, dur AS LONG
    LOCAL temp, temp2, cond, condCode, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255
    LOCAL buttonName AS STRING
    LOCAL headerFile AS ASCIIZ * 255

    EXPERIMENT.SessionDescription.INIFile = "ASCGeneric.ini"
    EXPERIMENT.SessionDescription.Date = DATE$
    EXPERIMENT.SessionDescription.Time = TIME$


    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile




    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID TO temp
        lResult = WritePrivateProfileString( "Subject Section", "ID", temp, filename)
        globals.SubjectID = VAL(temp)
        IF (globals.SubjectID < 0 OR globals.SubjectID > 9999) THEN
            MSGBOX "Subject ID should be a number between 1 and 9999."
            EXIT FUNCTION
        END IF

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION TO temp
        lResult = WritePrivateProfileString( "Experiment Section", "Description", temp, filename)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO temp
        IF (TRIM$(temp) <> "") THEN
            headerFile = ConvertToFullPath(EXPERIMENT.SessionDescription.HDRFile)
            ModifyHeaderComment(headerFile + "")
        END IF

        LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount
        IF (lbCount = 0) THEN
            MSGBOX "No group variables were added."
            EXIT FUNCTION
        END IF
        '*****************************************************************************
        'Write out the conditions to the conditions file.
        '*****************************************************************************
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR TO temp
        tempFileName = filename
        REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\" + temp + ".txt" IN tempFileName
        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC TO GVDesc

        OPEN tempFileName FOR OUTPUT AS #1
        PRINT #1, GVDesc

        FOR x = 1 TO lbCount
            LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x TO temp
            PRINT #1, temp + ","
        NEXT x

        'PRINT #1, "SpecialEvent, 88"
        'PRINT #1, "EndEpoch,99"
        PRINT #1, "xxx,999,"

        CLOSE #1

        '*****************************************************************************
        CALL StartModifyExpAndTech(filename)

        CALL LoadINISettings()

        CALL initializeEventFile()

        IF (LTRIM$(LCASE$(EXPERIMENT.Misc.DigitalIOCard)) = "yes") THEN
            globals.DioCardPresent = 1
        ELSE
            globals.DioCardPresent = 0
        END IF


        DIALOG SHOW STATE globals.hdl.DlgHelper, %SW_HIDE

        '**********************************************************************************************
        'added 12/11/2012 FAA
        '
        'The following lines were added to add automation functions between the Experiment and
        'the Actiview application on the Biosemi PC. It is using a file semaphore system.
        'The experiment will create a file on the Biosemi machine (see StartupActiview() routine)
        'A macro written in Macro Express Pro is sitting and waiting for a file to be created (via
        'the StartupActiview() routine). This file contains information that will be written in to
        'certain fields in the Actiview program. When the file is created by this experiment, the
        'macro will run, start up Actiview, and fill in the necessary fields. The StartBiosemiRecord()
        'routine also writes a file to the Biosemi PC. This file starts up a macro that starts Actiview
        'recording. The 2 files created: MacroValues.txt and MacroValues2.txt are created on a mapped
        'network drive X: in the directories: \Semaphores\ActiviewStart and \Semaphores\BiosemiRecord
        'respectively.
        '


        '======================================================
        'added 5/13/2014 - changed a MessageBox into a dialog
        ' that the user has to check off items.
        '======================================================
        CALL ShowDIALOGExptCheckList(0)


        '======================================================
        'added 5/20/2014 - changed a MessageBox into a dialog
        ' to allow a sound check.
        '======================================================
        'CALL ShowDIALOGSoundCheck(0)


        CALL StartupActiview()

        CustomMessageBox3(0, "DO NOT TOUCH BIOSEMI MOUSE!" + $CRLF + _
            "Click below when ready to start Biosemi recording.", "Start Biosemi Recording", 12)

        CALL StartBiosemiRecord()

        '======================================================
        'added 5/21/2014 - changed a MessageBox into a dialog
        ' to allow a method to sync video and BDF.
        '======================================================
        SLEEP 8000

        CALL ShowDIALOG_BiosemiRecording(0)
        '**********************************************************************************************


        CustomMessageBox(1, "Press OK to start ASC Run.", "Start Run")

        CALL dlgSubjectScreen()

        '*****************************************************************************
        'Create buttons out the conditions in the conditions file.
        '*****************************************************************************
        '****************************************************************************
        'Reading in the conditions and the condition codes from the
        'ASCCondition.txt file and pre-filling the listbox.
        '****************************************************************************

        CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR TO temp
        tempFileName = filename
        REPLACE EXPERIMENT.SessionDescription.INIFile WITH "Conditions\" + temp + ".txt" IN tempFileName

            OPEN tempFileName FOR INPUT AS #1

            IF ISTRUE EOF(1) THEN  ' check if at end of file
                MSGBOX "No data in " + tempFileName + "."
                EXIT FUNCTION
            END IF

            INPUT #1, GVDesc
            CONTROL SET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_GROUPVAR_DESC, GVDesc

            x = 0
            DO
                INPUT #1, cond, condCode, temp2
                IF (cond = "xxx") THEN
                    EXIT LOOP
                END IF
                buttonName = cond
                CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, buttonName
                CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, %SW_SHOW
                x = x + 1
            LOOP

            CLOSE #1

            DIM rngInt AS EvenOddRNGInterface
            LET rngInt = CLASS "EvenOddRNGClass"

            rngInt.SetDuration(1000)
            rngInt.SetSampleSize(50)

            dur = rngInt.GetDuration()

            rngInt.PrintHeaders(EXPERIMENT.SessionDescription.INIFile)

            CALL SetTimer(globals.hdl.DlgSubject, BYVAL &H0000FEED, dur, BYVAL %NULL)

'        LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount
'        FOR x = lbCount - 1 TO 0 STEP -1
'            LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x + 1 TO temp
'            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, LEFT$(temp, INSTR(temp, ",") - 1)
'            CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + x, %SW_SHOW
'        NEXT x


        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult


        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW


        DIALOG SET LOC globals.hdl.DlgSubject, EXPERIMENT.Misc.Screen(1).x + (EXPERIMENT.Misc.Screen(1).xMax - 1200) / 2, EXPERIMENT.Misc.Screen(1).y + (EXPERIMENT.Misc.Screen(1).yMax - 800) / 2

        'DO
        '    DIALOG DOEVENTS
        '    DIALOG GET SIZE ghDlgController TO x&, x&
        'LOOP WHILE x& ' When x& = 0, dialog has ended


        DIALOG END CBHNDL
    END IF
END FUNCTION


CALLBACK FUNCTION cbHelperScreenCancel() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        DIALOG END CBHNDL, 0
    END IF
END FUNCTION

CALLBACK FUNCTION cbHelperScreenHelp() AS LONG
    LOCAL lError AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
            '...Process the click event here
        SHELL("NOTEPAD.EXE HelpFile.txt")
    END IF
END FUNCTION

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
                    CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO newComment
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
