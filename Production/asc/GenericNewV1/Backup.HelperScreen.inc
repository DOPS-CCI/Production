SUB dlgControllerHelperScreen()
    LOCAL temp, temp2, cond, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255
    LOCAL condCode, x AS INTEGER
    LOCAL hFont1, hFont2 AS DWORD

         #PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    DIALOG NEW PIXELS, 0, "Enter parameters", 339, 92, 479, 659, _
         %DS_CENTER OR %WS_OVERLAPPEDWINDOW OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO globals.hdl.DlgHelper
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, "9999", 108, 5, 100, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_NUMBER, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, "", 108, 48, 363, _
        88, %WS_CHILD OR %WS_VISIBLE OR %ES_LEFT OR %ES_MULTILINE, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %TEXTBOX_COMMENT, "", 16, 187, 448, 56
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %IDC_BUTTON_SetConditions, "Set Conditions", _
        160, 272, 152, 40, , , CALL cbHelperScreenConditions()
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, "EEG Settings", 160, _
        320, 152, 40, , , CALL cbHelperScreenEEGSettings
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, "Long Description", _
        160, 368, 152, 40, , , CALL cbHelperScreenLongDesc
    CONTROL ADD CHECKBOX, globals.hdl.DlgHelper, %IDC_CHECKBOX_UseStartingPoint, "Use Starting " + _
        "Point", 136, 432, 197, 24
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %IDC_TEXTBOX_DateOfVideo, "", 275, 476, 144, _
        29
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %IDC_TEXTBOX_TimeOfVideo, "", 275, 512, 144, _
        29
    CONTROL ADD TEXTBOX,  globals.hdl.DlgHelper, %IDC_TEXTBOX_Offset, "", 275, 550, 144, 29
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELPEROK, "OK", 88, 608, 88, 40, _
        %WS_CHILD OR %WS_VISIBLE OR %BS_TEXT OR %BS_PUSHBUTTON OR %BS_CENTER _
        OR %BS_VCENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING, CALL cbHelperScreenOK
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, "Cancel", 184, 608, 88, _
        40, , ,CALL cbHelperScreenCancel
    CONTROL ADD BUTTON,   globals.hdl.DlgHelper, %BUTTON_HELP, "?", 304, 608, 88, 40, , , CALL cbHelperScreenHelp
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9903, "Subject ID:", 7, 8, 98, 32, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_9905, "Initial comment:", 19, 155, 117, _
        30
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_LABEL5, "Description:", 8, 52, 97, 28, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_LABEL6, "Start Date (MM/DD/YYYY):", 40, _
        480, 227, 29, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_LABEL7, "Start Time (HH:MM:SS):", 32, _
        520, 232, 24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,    globals.hdl.DlgHelper, %IDC_LABEL1, "Offset (secs):", 32, 558, 232, _
        24, %WS_CHILD OR %WS_VISIBLE OR %SS_RIGHT, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING

    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont2

    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %TEXTBOX_COMMENT, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_SetConditions, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_EEGSettings, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_BUTTON_LongDesc, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_CHECKBOX_UseStartingPoint, hFont2
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_TEXTBOX_DateOfVideo, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_TEXTBOX_TimeOfVideo, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_TEXTBOX_Offset, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPEROK, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELPERCANCEL, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %BUTTON_HELP, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9903, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_9905, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL5, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL6, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL7, hFont1
    CONTROL SET FONT globals.hdl.DlgHelper, %IDC_LABEL1, hFont1

#PBFORMS END DIALOG

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    GetPrivateProfileString("Subject Section", "ID", "", temp, %MAXPPS_SIZE, filename)
    CONTROL SET TEXT globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID, temp

    GetPrivateProfileString("Experiment Section", "Description", "", temp, %MAXPPS_SIZE, filename)
    CONTROL SET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION, temp

    'GetPrivateProfileString("Experiment Section", "Comment", "", temp, %MAXPPS_SIZE, filename)
    'CONTROL SET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT, temp

    CALL UseOffset()

    CONTROL SET FOCUS globals.hdl.DlgHelper, %TEXTBOX_SUBJECTID
END SUB

SUB UseOffset()
    LOCAL lResult AS LONG

    CONTROL GET CHECK globals.hdl.DlgHelper, %IDC_CHECKBOX_UseStartingPoint TO lResult
    IF (lResult = 1) THEN 'checked
        gUseOffset = 1
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_LABEL6
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_LABEL7
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_LABEL1
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_TEXTBOX_DateOfVideo
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_TEXTBOX_TimeOfVideo
        CONTROL NORMALIZE globals.hdl.DlgHelper, %IDC_TEXTBOX_Offset
    ELSE
        gUseOffset = 0
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_LABEL6
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_LABEL7
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_LABEL1
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_TEXTBOX_DateOfVideo
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_TEXTBOX_TimeOfVideo
        CONTROL HIDE globals.hdl.DlgHelper, %IDC_TEXTBOX_Offset

    END IF

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
            SELECT CASE CB.CTL
                CASE %IDC_CHECKBOX_UseStartingPoint
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       CALL UseOffset()
                    END IF
            END SELECT
        CASE %WM_PAINT
                'beginpaint(ghDlg, PS)
                'endpaint ghDlg, PS
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbHelperScreenConditions() AS LONG
    LOCAL exitVar AS LONG
    LOCAL filename AS ASCIIZ *256

    filename = EXE.PATH$ + EXPERIMENT.SessionDescription.INIFile

    SHELL "H:\ConditionsChoices\ConditionsChoices.exe " + filename, 1, EXIT TO exitVar

    BringWindowToTop globals.hdl.DlgHelper

    FUNCTION = exitVar
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

SUB CreateConditionsFile(filename AS ASCIIZ * 255)
    LOCAL x AS LONG
    LOCAL temp, temp2, cond, condCode, GVDesc AS ASCIIZ * 255
    LOCAL tempFileName, outFile AS ASCIIZ * 255

    GetPrivateProfileString("Stimulus section", "ConditionsFile", "", tempFileName, %MAXPPS_SIZE, filename)

    outFile = PATHNAME$(PATH,  filename) + "Conditions\ASCCondition.txt"

    OPEN tempFileName FOR INPUT AS #1
    OPEN outFile FOR OUTPUT AS #2  'This is the file name used to create the header file.

    IF ISTRUE EOF(1) THEN  ' check if at end of file
        MSGBOX "No data in " + tempFileName + "."
        EXIT SUB
    END IF

    INPUT #1, GVDesc
    PRINT #2, GVDesc

    x = 0
    DO
        INPUT #1, cond, condCode, temp2
        PRINT #2, cond + "," + condCode + "," + temp2
        IF (cond = "xxx") THEN
            EXIT LOOP
        END IF
        x = x + 1
    LOOP

    CLOSE #2
    CLOSE #1
END SUB

SUB CreateButtons(filename AS ASCIIZ * 255)
    LOCAL x AS LONG
    LOCAL buttonName AS STRING
    LOCAL temp, temp2, cond, condCode, GVDesc AS ASCIIZ * 255
    LOCAL inFile AS ASCIIZ * 255

    inFile = PATHNAME$(PATH,  filename) + "Conditions\ASCCondition.txt"


    OPEN inFile FOR INPUT AS #1

    IF ISTRUE EOF(1) THEN  ' check if at end of file
        MSGBOX "No data in " + inFile + "."
        EXIT SUB
    END IF

    INPUT #1, GVDesc

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

    CLOSE #2
    CLOSE #1
END SUB



CALLBACK FUNCTION cbHelperScreenOK() AS LONG
    LOCAL lResult, lTemp, x, y, lbCount, pid AS LONG
    LOCAL temp, temp2, cond, condCode, GVDesc AS ASCIIZ * 255
    LOCAL filename, tempFileName AS ASCIIZ * 255
    LOCAL headerFile AS ASCIIZ * 255
    LOCAL sysTime AS SYSTEMTIME
    GLOBAL gOffset AS STRING
    LOCAL outFile AS STRING

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

        'CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DESCRIPTION TO temp
        'lResult = WritePrivateProfileString( "Experiment Section", "Description", temp, filename)

        CONTROL GET TEXT globals.hdl.DlgHelper, %TEXTBOX_COMMENT TO temp
        IF (TRIM$(temp) <> "") THEN
            headerFile = ConvertToFullPath(EXPERIMENT.SessionDescription.HDRFile)
            ModifyHeaderComment(headerFile + "")
        END IF


        IF (gUseOffset = 1) THEN

            CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_DateOfVideo TO gDateOfVideo
            IF (TRIM$(gDateOfVideo) = "") THEN
                MSGBOX "Please enter the starting date."
                EXIT FUNCTION
            END IF

           gMyTimeType.pYear = VAL(PARSE$(gDateOfVideo, "/", 3))
           gMyTimeType.pMonth = VAL(PARSE$(gDateOfVideo, "/", 1))
           gMyTimeType.pDay = VAL(PARSE$(gDateOfVideo, "/", 2))

           gMyTime.NewDate(gMyTimeType.pYear, gMyTimeType.pMonth, gMyTimeType.pDay)

            'SHELL "DATE " + gDateOfVideo

            CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_TimeOfVideo TO gTimeOfVideo
            IF (TRIM$(gTimeOfVideo) = "") THEN
                MSGBOX "Please enter the starting time."
                EXIT FUNCTION
            END IF

           gMyTimeType.pHour = VAL(PARSE$(gTimeOfVideo, ":", 1))
           gMyTimeType.pMinute = VAL(PARSE$(gTimeOfVideo, ":", 2))
           gMyTimeType.pSecond = VAL(PARSE$(gTimeOfVideo, ":", 3))

           CONTROL GET TEXT globals.hdl.DlgHelper, %IDC_TEXTBOX_Offset TO gOffset
            IF (TRIM$(gOffset) = "") THEN
                MSGBOX "Please enter the offset."
                EXIT FUNCTION
            END IF
        END IF

        '*****************************************************************************
        CALL StartModifyExpAndTech(filename)

        '****************************************************************************
        'Reading in the conditions and the condition codes from the
        'ASCCondition.txt file and pre-filling the listbox.
        '****************************************************************************

        CALL CreateConditionsFile(filename)

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

        '**********************************************************************************************
        'added 06/09/2014 per Ross Dunseath - wanted to have the ability of generating RNG and
        'alternate RNG files like those used in the Audio Paced Trials program.
        '**********************************************************************************************

        LET rngInt = CLASS "EvenOddRNGClass"

        rngInt.SetDuration(1000)
        rngInt.SetSampleSize(50)
        rngInt.SetINIFilename(EXPERIMENT.SessionDescription.INIFile)

        rngInt.StartHiddenRNGWindow()
         '**********************************************************************************************

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

        'CustomMessageBox(1, "Press OK to start ASC Run.", "Start Run")



        CALL dlgSubjectScreen()

        '*****************************************************************************
        'Create buttons out the conditions in the conditions file.
        '*****************************************************************************

        CALL CreateButtons(filename)




'        LISTBOX GET COUNT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS TO lbCount
'        FOR x = lbCount - 1 TO 1 STEP -1
'            LISTBOX GET TEXT globals.hdl.DlgHelper, %IDC_LISTBOX_GV_CONDITIONS, x TO temp
'            buttonName = LEFT$(temp, INSTR(temp, ",") - 1)
'            CONTROL SET TEXT globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + (x - 1), buttonName
'            CONTROL SHOW STATE globals.hdl.DlgSubject, %IDC_BUTTON_EVENT01 + (x - 1), %SW_SHOW
'        NEXT x

        CALL SetTimer(globals.hdl.DlgSubject, BYVAL %IDT_TIMER01, 1000, BYVAL %NULL)

        DIALOG SHOW MODELESS globals.hdl.DlgSubject, CALL cbSubjectScreen TO lResult



        CONTROL SHOW STATE globals.hdl.DlgSubject, %ID_OK, %SW_HIDE
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_BACK, %SW_SHOW
        CONTROL SHOW STATE globals.hdl.DlgSubject, %IMAGE_PROCEED, %SW_SHOW




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
