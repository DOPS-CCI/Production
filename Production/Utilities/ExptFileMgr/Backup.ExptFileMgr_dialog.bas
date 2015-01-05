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
#RESOURCE "ExptFileMgr_dialog.pbr"
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
%IDD_DIALOG1                      =  101
%IDC_LABEL1                       = 1002
%IDC_FRAME1                       = 1004
%IDC_LISTBOX_SubjectFiles         = 1001
%IDC_LABEL2                       = 1005    '*
%IDC_COMBOBOX_ByPath              = 1003
%IDC_COMBOBOX_BySubjectID         = 1006
%IDC_LABEL3                       = 1007    '*
%IDC_COMBOBOX_ByExperimentCode    = 1008
%IDC_LABEL4                       = 1009    '*
%IDC_BUTTON_Cancel                = 1011
%IDC_LABEL5                       = 1013
%IDC_LISTBOX_FilteredSubjectFiles = 1012
%IDC_BUTTON_FilterFiles           = 1010
%IDC_BUTTON_ResetFilter           = 1014
%IDC_BUTTON_CopyFiles             = 1015
%IDC_OPTION1                      = 1016
%IDC_COMBOBOX_AndOr_1             = 1019    '*
%IDC_COMBOBOX_AndOr_2             = 1020    '*
%IDC_BUTTON_ViewFile              = 1021
%IDC_LABEL6                       = 1024    '*
%IDC_COMBOBOX_ByStartDate         = 1022
%IDC_COMBOBOX_ByEndDate           = 1023
%IDC_CHECKBOX_BySubjectID         = 1025
%IDC_CHECKBOX_ByExperimentCode    = 1026
%IDC_CHECKBOX_ByDateRange         = 1027
%IDC_COMBOBOX_ByExtension         = 1028
%IDC_CHECKBOX_ByExtension         = 1029
%IDC_BUTTON_ZipFiles              = 1030
%IDC_BUTTON_DirLocation           = 1031
%IDC_BUTTON_DeletFiles            = 1032
%IDC_BUTTON_MoveToFiltered        = 1033
%IDC_BUTTON_ViewFileAttr          = 1034    '*
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION SampleComboBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION SampleListBox(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL _
    lCount AS LONG) AS LONG
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

%MAXPPS_SIZE = 2048

TYPE SubjectFileData
    PATH AS ASCIIZ * 256
    SubjectID AS ASCIIZ * 5
    ExperimentCode AS ASCIIZ * 3
    ExperimentDescription AS ASCIIZ * 30
    Date AS ASCIIZ * 9
    Time AS ASCIIZ * 5
    Extension AS ASCIIZ * 4
    DateModifiedAndSize AS ASCIIZ * 40
END TYPE

TYPE GlobalVariables
    INIFile AS ASCIIZ * 256
    sfd(9999) AS SubjectFileData
    files(9999) AS ASCIIZ * 256
    nbrOfFiles AS LONG
    directoryLocation AS ASCIIZ * 256
END TYPE

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    GLOBAL globals AS GlobalVariables
    GLOBAL hDlg   AS DWORD

    'globals.INIFile = "E:\DOPS_Applications\Utilities\ExptFileMgr\ExptFileMgr.ini"
    globals.INIFile = CURDIR$ + "\ExptFileMgr.ini"

    LoadINISettings()


    'CALL GetSubjectFiles()

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG1 %HWND_DESKTOP
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG1Proc()
    LOCAL listboxCount, selectedCount, x, itemState, cnt, lResult AS LONG
    LOCAL fileName, folder, temp AS STRING
    LOCAL extension, helper AS ASCIIZ * 256
    LOCAL fileNames() AS STRING
    LOCAL processID AS DWORD


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
                ' /* Inserted by PB/Forms 07-24-2013 08:42:13
                CASE %IDC_BUTTON_MoveToFiltered
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_SubjectFiles TO selectedCount
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_SubjectFiles TO listboxCount

                        REDIM fileNames(selectedCount)
                        cnt = 0
                        FOR x = 1 TO listboxCount
                            LISTBOX GET STATE hDlg, %IDC_LISTBOX_SubjectFiles, x TO itemState
                            IF (itemState <> 0) THEN
                                INCR cnt
                                LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles,x TO fileNames(cnt)
                                lResult = INSTR(fileNames(cnt), SPACE$(8))
                                LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, LEFT$(fileNames(cnt), lResult- 1)
                            END IF
                        NEXT x
                        EnableDisableForFilterFiles(1)
                    END IF
                ' */

                ' /* Inserted by PB/Forms 07-03-2013 08:07:29
                CASE %IDC_BUTTON_DeletFiles
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        lResult = MSGBOX("Are you sure you want to delete these files?", %MB_YESNO OR %MB_DEFBUTTON2 OR %MB_TASKMODAL, "Delete Files")
                        IF (lResult = %IDNO) THEN
                            EXIT FUNCTION
                        END IF


                        LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO selectedCount
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO listboxCount

                        REDIM fileNames(selectedCount)
                        cnt = 0
                        FOR x = 1 TO listboxCount
                            LISTBOX GET STATE hDlg, %IDC_LISTBOX_FilteredSubjectFiles, x TO itemState
                            IF (itemState <> 0) THEN
                                INCR cnt
                                LISTBOX GET TEXT hDlg, %IDC_LISTBOX_FilteredSubjectFiles,x TO fileNames(cnt)
                            END IF
                        NEXT x

                        FOR x = 1 TO cnt
                            KILL fileNames(x)
                        NEXT x

                        FOR x = 1 TO cnt
                            LISTBOX FIND EXACT hDlg, %IDC_LISTBOX_FilteredSubjectFiles, 1, fileNames(x) TO lResult
                            LISTBOX DELETE hDlg, %IDC_LISTBOX_FilteredSubjectFiles, lResult
                        NEXT x

                        CALL GetSubjectFiles()
                        CB_ListBoxSubjectFiles  hDlg, %IDC_LISTBOX_SubjectFiles, 30
                        'MSGBOX "Files deleted."
                    END IF
                ' */

                ' /* Inserted by PB/Forms 07-03-2013 07:34:53
                CASE %IDC_BUTTON_DirLocation
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       LISTBOX RESET hDlg, %IDC_LISTBOX_SubjectFiles
                       resetFilters()
                       COMBOBOX RESET hDlg, %IDC_COMBOBOX_BySubjectID
                       COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByExperimentCode
                       COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByStartDate
                       COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByExtension
                       DISPLAY BROWSE 0, , , "Choose the directory where Experiment files reside.", globals.directoryLocation , %BIF_RETURNONLYFSDIRS TO globals.directoryLocation
                       IF (globals.directoryLocation <> "") THEN
                           IF (RIGHT$(globals.directoryLocation, 12) <> "Subject_Data") THEN
                               MSGBOX "Must be set to Subject_Data directory."
                           ELSE
                               CALL EnableDisableForDirLocation(1) 'disable button and checkboxes
                               globals.directoryLocation = globals.directoryLocation + "\"
                               CALL GetSubjectFiles()
                               CB_ListBoxSubjectFiles  hDlg, %IDC_LISTBOX_SubjectFiles, 30
                               CB_ComboBoxBySubjectID hDlg, %IDC_COMBOBOX_BySubjectID, 30
                               CB_ComboBoxByExperimentCode hDlg, %IDC_COMBOBOX_ByExperimentCode, 30
                               CB_ComboBoxByDate  hDlg, %IDC_COMBOBOX_ByStartDate, 30
                               CB_ComboBoxByExtension  hDlg, %IDC_COMBOBOX_ByExtension, 30
                           END IF
                       END IF
                    END IF
                ' */

                ' /* Inserted by PB/Forms 04-10-2013 13:42:56
                CASE %IDC_BUTTON_ZipFiles
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO selectedCount
                       LISTBOX GET COUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO listboxCount

                        REDIM fileNames(selectedCount)
                        cnt = 0
                        FOR x = 1 TO listboxCount
                            LISTBOX GET STATE hDlg, %IDC_LISTBOX_FilteredSubjectFiles, x TO itemState
                            IF (itemState <> 0) THEN
                                INCR cnt
                                LISTBOX GET TEXT hDlg, %IDC_LISTBOX_FilteredSubjectFiles,x TO fileNames(cnt)
                            END IF
                        NEXT x

                        DISPLAY BROWSE hDlg, , , "Where do you want to copy the files to?", "c:\",  %BIF_NEWDIALOGSTYLE  TO folder

                        IF (folder <> "") THEN
                            fileName = LEFT$(RIGHT$(fileNames(1), 26), 22) + ".zip"
                            OPEN "ZipFileList.tmp" FOR OUTPUT AS #2
                            FOR x = 1 TO cnt
                                PRINT #2, fileNames(x)
                            NEXT x
                            CLOSE #2
                            '7-Zip\7z.exe u -tzip C:\Users\admin\Desktop\S0001-A1-20120315-1615.zip @ZipFileList.tmp
'                            OPEN "ZipUpFiles.bat" FOR OUTPUT AS #2
'                            PRINT #2, "7-Zip\7z.exe u -tzip " + folder + "\" + fileName + " @ZipFileList.tmp"
'                            CLOSE #2
                            'msgbox "7-Zip\7z.exe u -tzip " + folder + "\" + fileName + "@ZipFileList.tmp"
                            SHELL("7-Zip\7z.exe u -tzip " + folder + "\" + fileName + " @ZipFileList.tmp")
                            MSGBOX "Files zipped."
                        END IF
                    END IF
                ' */

                ' /* Inserted by PB/Forms 04-10-2013 10:47:11
                CASE %IDC_CHECKBOX_ByExtension
                ' */

                ' /* Inserted by PB/Forms 04-10-2013 10:27:43
                CASE %IDC_COMBOBOX_ByExtension

                ' */

                ' /* Inserted by PB/Forms 04-09-2013 11:22:13
                CASE %IDC_CHECKBOX_BySubjectID

                CASE %IDC_CHECKBOX_ByExperimentCode

                CASE %IDC_CHECKBOX_ByDateRange
                ' */

                ' /* Inserted by PB/Forms 04-09-2013 10:01:33
                CASE %IDC_COMBOBOX_ByStartDate

                CASE %IDC_COMBOBOX_ByEndDate
                ' */

                ' /* Inserted by PB/Forms 04-09-2013 08:55:11
                CASE %IDC_BUTTON_ViewFile
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN


                        LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO selectedCount
                        IF (selectedCount > 1) THEN
                            MSGBOX "You can only select a single file to view."
                        ELSEIF (selectedCount = 0) THEN
                            MSGBOX "You must select a file to view."
                        ELSE
                            LISTBOX GET COUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO listboxCount

                            cnt = 0
                            FOR x = 1 TO listboxCount
                                LISTBOX GET STATE hDlg, %IDC_LISTBOX_FilteredSubjectFiles, x TO itemState
                                IF (itemState <> 0) THEN
                                    INCR cnt
                                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_FilteredSubjectFiles,x TO temp
                                    IF (cnt = 1) THEN
                                         extension = RIGHT$(UCASE$(PATHNAME$(EXTN,  temp)), 3)
                                         GetPrivateProfileString("Helpers Section", extension, "notepad.exe", helper, %MAXPPS_SIZE, globals.INIFile)
                                         fileName = RIGHT$(temp, 26)
                                         folder = LEFT$(temp, LEN(temp) - 26)
                                         CHDIR folder
                                         processID = SHELL(helper + " " + fileName)
                                        EXIT FOR
                                    END IF
                                END IF
                            NEXT x
                        END IF
                    END IF
                ' */


                ' /* Inserted by PB/Forms 04-08-2013 14:13:39
                CASE %IDC_BUTTON_CopyFiles
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX GET SELCOUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO selectedCount
                        LISTBOX GET COUNT hDlg, %IDC_LISTBOX_FilteredSubjectFiles TO listboxCount

                        REDIM fileNames(selectedCount)
                        cnt = 0
                        FOR x = 1 TO listboxCount
                            LISTBOX GET STATE hDlg, %IDC_LISTBOX_FilteredSubjectFiles, x TO itemState
                            IF (itemState <> 0) THEN
                                INCR cnt
                                LISTBOX GET TEXT hDlg, %IDC_LISTBOX_FilteredSubjectFiles,x TO fileNames(cnt)
                            END IF
                        NEXT x

                        DISPLAY BROWSE hDlg, , , "Where do you want to copy the files to?", "c:\",  %BIF_NEWDIALOGSTYLE  TO folder

                        IF (folder <> "") THEN
                            FOR x = 1 TO cnt
                                FILECOPY fileNames(x) ,  folder + "\" + RIGHT$(fileNames(x), 26)
                            NEXT x

                            MSGBOX "Files copied."
                        END IF
                    END IF
                ' */

                ' /* Inserted by PB/Forms 04-08-2013 14:05:32
                CASE %IDC_BUTTON_ResetFilter
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                       EnableDisableForFilterFiles(0)
                       resetFilters()
                    END IF
                ' */

                ' /* Inserted by PB/Forms 04-08-2013 13:51:14
                ' */

                ' /* Inserted by PB/Forms 04-08-2013 13:46:11
                CASE %IDC_LISTBOX_FilteredSubjectFiles
                ' */

                CASE %IDC_LISTBOX_SubjectFiles

                CASE %IDC_COMBOBOX_ByPath

                CASE %IDC_COMBOBOX_BySubjectID

                CASE %IDC_COMBOBOX_ByExperimentCode

                CASE %IDC_BUTTON_FilterFiles
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        LISTBOX RESET hDlg, %IDC_LISTBOX_FilteredSubjectFiles
                        EnableDisableForFilterFiles(1)
                        FilterSubjectFiles()
                    END IF

                CASE %IDC_BUTTON_Cancel
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        'MSGBOX "%IDC_BUTTON_Cancel=" + _
                        DIALOG END CB.HNDL
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

SUB resetFilters()
   LISTBOX RESET hDlg, %IDC_LISTBOX_FilteredSubjectFiles
   CONTROL SET TEXT hDlg, %IDC_COMBOBOX_BySubjectID, ""
   CONTROL SET TEXT hDlg, %IDC_COMBOBOX_ByExperimentCode, ""
   CONTROL SET TEXT hDlg, %IDC_COMBOBOX_ByStartDate, ""
   CONTROL SET TEXT hDlg, %IDC_COMBOBOX_ByEndDate, ""
   CONTROL SET TEXT hDlg, %IDC_COMBOBOX_ByExtension, ""
   CONTROL SET CHECK hDlg, %IDC_CHECKBOX_BySubjectID, 0
   CONTROL SET CHECK hDlg, %IDC_CHECKBOX_ByExperimentCode, 0
   CONTROL SET CHECK hDlg, %IDC_CHECKBOX_ByDateRange, 0
   CONTROL SET CHECK hDlg, %IDC_CHECKBOX_ByExtension, 0
   'COMBOBOX RESET hDlg, %IDC_COMBOBOX_BySubjectID
   'COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByExperimentCode
   'COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByStartDate
   'COMBOBOX RESET hDlg, %IDC_COMBOBOX_ByExtension
   'CB_ListBoxSubjectFiles  hDlg, %IDC_LISTBOX_SubjectFiles, 30
   'CB_ComboBoxBySubjectID hDlg, %IDC_COMBOBOX_BySubjectID, 30
   'CB_ComboBoxByExperimentCode hDlg, %IDC_COMBOBOX_ByExperimentCode, 30
   'CB_ComboBoxByDate  hDlg, %IDC_COMBOBOX_ByStartDate, 30
   'CB_ComboBoxByExtension  hDlg, %IDC_COMBOBOX_ByExtension, 30
END SUB
'------------------------------------------------------------------------------
'   ** Sample Code **
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION CB_ComboBoxBySubjectID(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL cItem AS VARIANT
    LOCAL cKey AS WSTRING
    LOCAL Collect AS IPOWERCOLLECTION
    LOCAL tempArr() AS WSTRING

    REDIM tempArr(globals.nbrOfFiles)

    FOR i = 1 TO globals.nbrOfFiles
        tempArr(i) = globals.sfd(i).SubjectID
    NEXT i

    LET Collect = CLASS "PowerCollection"

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    Collect = RemoveDuplicatesFromArray(tempArr())

    FOR i = 1 TO Collect.Count
        Collect.Entry(i, cKey, cItem)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_BySubjectID, cKey
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION CB_ComboBoxByExperimentCode(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL cItem AS VARIANT
    LOCAL cKey AS WSTRING
    LOCAL Collect AS IPOWERCOLLECTION
    LOCAL tempArr() AS WSTRING

    REDIM tempArr(globals.nbrOfFiles)

    FOR i = 1 TO globals.nbrOfFiles
        tempArr(i) = globals.sfd(i).ExperimentCode + " - " + globals.sfd(i).ExperimentDescription
    NEXT i

    LET Collect = CLASS "PowerCollection"

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    Collect = RemoveDuplicatesFromArray(tempArr())

    FOR i = 1 TO Collect.Count
        Collect.Entry(i, cKey, cItem)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_ByExperimentCode, cKey
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION CB_ComboBoxByDate(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL cItem AS VARIANT
    LOCAL cKey AS WSTRING
    LOCAL Collect AS IPOWERCOLLECTION
    LOCAL tempArr() AS WSTRING

    REDIM tempArr(globals.nbrOfFiles)

    FOR i = 1 TO globals.nbrOfFiles
        tempArr(i) = globals.sfd(i).Date
    NEXT i

    LET Collect = CLASS "PowerCollection"

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    Collect = RemoveDuplicatesFromArray(tempArr())

    Collect.Sort(0)
    FOR i = 1 TO Collect.Count
        Collect.Entry(i, cKey, cItem)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_ByStartDate, MID$(cKey, 5, 2) + "/" + MID$(cKey, 7, 2) + "/" + LEFT$(cKey, 4)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_ByEndDate, MID$(cKey, 5, 2) + "/" + MID$(cKey, 7, 2) + "/" + LEFT$(cKey, 4)
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION CB_ComboBoxByExtension(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL cItem AS VARIANT
    LOCAL cKey AS WSTRING
    LOCAL Collect AS IPOWERCOLLECTION
    LOCAL tempArr() AS WSTRING

    REDIM tempArr(globals.nbrOfFiles)

    FOR i = 1 TO globals.nbrOfFiles
        tempArr(i) = globals.sfd(i).Extension
    NEXT i

    LET Collect = CLASS "PowerCollection"

    CONTROL SEND hDlg, lID, %CB_SETEXTENDEDUI, %TRUE, 0

    Collect = RemoveDuplicatesFromArray(tempArr())

    FOR i = 1 TO Collect.Count
        Collect.Entry(i, cKey, cItem)
        COMBOBOX ADD hDlg, %IDC_COMBOBOX_ByExtension, cKey
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION CB_ListBoxSubjectFiles(BYVAL hDlg AS DWORD, BYVAL lID AS LONG, BYVAL lCount _
    AS LONG) AS LONG
    LOCAL i AS LONG
    LOCAL dates() AS LONG
    LOCAL sfd() AS SubjectFileData

    REDIM sfd(globals.nbrOfFiles)
    REDIM dates(globals.nbrOfFiles)

    FOR i = 1 TO globals.nbrOfFiles
        sfd(i) = globals.sfd(i)
        dates(i) = VAL(sfd(i).Date)
    NEXT i


    LISTBOX RESET hDlg, %IDC_LISTBOX_SubjectFiles
    ARRAY SORT dates(), TAGARRAY sfd(), DESCEND
    FOR i = 1 TO globals.nbrOfFiles
        globals.sfd(i) = sfd(i)
    NEXT i
    globals.nbrOfFiles = globals.nbrOfFiles - 1
    FOR i = 1 TO globals.nbrOfFiles
        LISTBOX ADD hDlg, %IDC_LISTBOX_SubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                        globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension + SPACE$(8) + _
                                                        globals.sfd(i).DateModifiedAndSize
    NEXT i
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
    LOCAL lRslt  AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD
    LOCAL hFont2 AS DWORD
    LOCAL hFont3 AS DWORD
    LOCAL hFont4 AS DWORD

    DIALOG NEW hParent, "Manage Experiment Files", 107, 54, 653, 517, TO hDlg
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DirLocation, "Dir Location", 570, _
        59, 80, 25
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_BySubjectID, "By Subject ID:", _
        45, 215, 85, 15
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_BySubjectID, , 47, 230, 80, 119
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ByExperimentCode, "By " + _
        "Experiment Code:", 151, 215, 120, 15
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_ByExperimentCode, , 153, 230, _
        163, 120
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ByDateRange, "By Date Range:", _
        45, 258, 85, 15
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_ByStartDate, , 47, 275, 135, _
        55, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %CBS_DROPDOWN, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_ByEndDate, , 187, 275, 135, 55, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %CBS_DROPDOWN, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ByExtension, "By Extension:", _
        348, 258, 85, 15
    CONTROL ADD COMBOBOX, hDlg, %IDC_COMBOBOX_ByExtension, , 350, 275, 80, _
        119
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_FilterFiles, "Filter", 495, 230, _
        80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ResetFilter, "Reset Filter", 495, _
        260, 80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_CopyFiles, "Copy Files", 570, _
        335, 80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ViewFile, "View File", 570, 370, _
        80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_ZipFiles, "Zip Files", 570, 405, _
        80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Cancel, "Close", 290, 485, 80, 25
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_SubjectFiles, , 15, 25, 545, _
        145, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL SET COLOR     hDlg, %IDC_LISTBOX_SubjectFiles, %BLACK, %LTGRAY
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL1, "List of Subject Files     " + _
        "Snnnn-xx-yyyymmdd-hhmm  -  nnnn (SubjectID) xx (Expt Code) yyyymmdd " + _
        "(Date) hhmm (Time)", 15, 9, 620, 16
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME1, "Filters", 15, 200, 580, 95
    CONTROL SET COLOR     hDlg, %IDC_FRAME1, -1, %LTGRAY
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_FilteredSubjectFiles, , 15, 325, _
        545, 145, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %WS_HSCROLL OR _
        %WS_VSCROLL OR %LBS_MULTIPLESEL OR %LBS_NOTIFY, _
        %WS_EX_CLIENTEDGE OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR
    CONTROL SET COLOR     hDlg, %IDC_LISTBOX_FilteredSubjectFiles, %BLACK, %WHITE
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL5, "List of FILTERED Subject " + _
        "Files:", 15, 309, 170, 16
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DeletFiles, "Delete Files", 570, _
        440, 80, 25
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_MoveToFiltered, "Move to " + _
        "Filtered", 570, 94, 80, 25

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1
    FONT NEW "Arial", 12, 0, %ANSI_CHARSET TO hFont2
    FONT NEW "Arial", 12, 1, %ANSI_CHARSET TO hFont3
    FONT NEW "Arial Narrow", 10, 0, %ANSI_CHARSET TO hFont4

    CONTROL SET FONT hDlg, %IDC_BUTTON_DirLocation, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_BySubjectID, hFont2
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_BySubjectID, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ByExperimentCode, hFont2
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_ByExperimentCode, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ByDateRange, hFont2
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_ByStartDate, hFont1
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_ByEndDate, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ByExtension, hFont2
    CONTROL SET FONT hDlg, %IDC_COMBOBOX_ByExtension, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_FilterFiles, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_ResetFilter, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_CopyFiles, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_ViewFile, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_ZipFiles, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Cancel, hFont1
    CONTROL SET FONT hDlg, %IDC_LISTBOX_SubjectFiles, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL1, hFont1
    CONTROL SET FONT hDlg, %IDC_FRAME1, hFont3
    CONTROL SET FONT hDlg, %IDC_LISTBOX_FilteredSubjectFiles, hFont4
    CONTROL SET FONT hDlg, %IDC_LABEL5, hFont3
    CONTROL SET FONT hDlg, %IDC_BUTTON_DeletFiles, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_MoveToFiltered, hFont1
#PBFORMS END DIALOG

    CB_ListBoxSubjectFiles  hDlg, %IDC_LISTBOX_SubjectFiles, 30
    CB_ComboBoxBySubjectID hDlg, %IDC_COMBOBOX_BySubjectID, 30
    CB_ComboBoxByExperimentCode hDlg, %IDC_COMBOBOX_ByExperimentCode, 30
    CB_ComboBoxByDate  hDlg, %IDC_COMBOBOX_ByStartDate, 30
    CB_ComboBoxByExtension  hDlg, %IDC_COMBOBOX_ByExtension, 30

    DIALOG SET ICON hDlg, "EXPTFILEMGRICO"

    CALL EnableDisableForDirLocation(0) 'disable button and checkboxes
    CALL EnableDisableForFilterFiles(0)

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
    FONT END hFont2
    FONT END hFont3
    FONT END hFont4
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

SUB GetSubjectFiles()
    LOCAL x, y, cnt, nbrDirs, nbrFiles, strLen AS LONG
    LOCAL temp, temp2, dateModified, period, charS, title AS STRING
    LOCAL subDirs() AS STRING
    REDIM subDirs(9999)
    x = 1

    temp = DIR$(globals.directoryLocation,  %SUBDIR)

    'temp$ = DIR$("*.*", TO Listing(x&))
    subDirs(x) = temp
    WHILE LEN(temp) AND x < 9999 ' max = 1000
      INCR x
      temp = DIR$(NEXT)
      subDirs(x) = temp
    WEND

    nbrDirs = x
    'x = 1



    FOR y = 1 TO nbrDirs
        temp = DIR$(globals.directoryLocation + subDirs(y) + "\")
        globals.files(x) = globals.directoryLocation + subDirs(y) + "\" + temp
        WHILE LEN(temp) AND x < 1000 ' max = 1000
          INCR x
          temp = DIR$(NEXT)
          globals.files(x) = globals.directoryLocation + subDirs(y) + "\" + temp
        WEND
    NEXT y

    nbrFiles = x - 1

    cnt = 0
    FOR y = 1 TO nbrFiles
        IF (TRIM$(globals.files(y)) <> "") THEN
            strLen = LEN(globals.files(y))
            'msgbox MID$(globals.files(y), strLen - 3, 1) + MID$(globals.files(y), strLen - 25, 1)
            period = MID$(globals.files(y), strLen - 3, 1)
            charS = MID$(globals.files(y), strLen - 25, 1)
            IF (period = "." AND charS = "S") THEN
                temp = UCASE$(RIGHT$(globals.files(y), 3))  ' looking for only files with certain extemsions
                SELECT CASE temp
                    CASE "HDR", "EVT", "BDF", "ETR", "WMF", "CFG"
                        INCR cnt
                        globals.sfd(cnt).Extension = UCASE$(RIGHT$(globals.files(y), 3))
                        globals.sfd(cnt).Time = MID$(globals.files(y), strLen - 7, 4)
                        globals.sfd(cnt).Date = MID$(globals.files(y), strLen - 16, 8)
                        globals.sfd(cnt).ExperimentCode = MID$(globals.files(y), strLen - 19, 2)
                        globals.sfd(cnt).ExperimentDescription = GetExperimentCodeDesc(globals.sfd(cnt).ExperimentCode)
                        globals.sfd(cnt).SubjectID = MID$(globals.files(y), strLen - 24, 4)
                        globals.sfd(cnt).Path = LEFT$(globals.files(y), strLen - 26)
                        globals.sfd(cnt).DateModifiedAndSize = GetFileAttribs(globals.files(y) + "")
                END SELECT
           END IF
        END IF
    NEXT y

    globals.nbrOfFiles = cnt
    DIALOG GET TEXT hDlg TO title
    DIALOG SET TEXT hDlg, title + " - " + STR$(globals.nbrOfFiles) + " files"

END SUB

FUNCTION GetExperimentCodeDesc(exptCode AS ASCIIZ * 3) AS STRING
LOCAL temp, desc, eCode AS STRING
LOCAL info() AS STRING

    eCode = exptCode
    REDIM info(2)

    desc = "NONE FOUND"

    OPEN "H:\ExptFileMgr\ExperimentCodes.txt" FOR INPUT AS #1

    WHILE ISFALSE EOF(1)  ' check if at end of file
        LINE INPUT #1, temp
        PARSE temp, info()
        IF (eCode = info(0)) THEN
            desc = info(1)
            EXIT DO
        END IF
    WEND

    CLOSE #1

    FUNCTION = desc
END FUNCTION

FUNCTION RemoveDuplicatesFromArray(arr() AS WSTRING) AS IPOWERCOLLECTION
'=======================================================
'Using a trick with PowerCollection so that if it runs
'into a duplicate, it just moves on.
'=======================================================
LOCAL i AS LONG
LOCAL temp AS VARIANT
LOCAL tStr AS WSTRING
LOCAL Collect AS IPOWERCOLLECTION

    LET Collect = CLASS "PowerCollection"

    ON ERROR GOTO Duplicate
    FOR i = 1 TO globals.nbrOfFiles
        tStr = arr(i)
        Collect.Add(tStr, temp)
       Duplicate:
        ITERATE
    NEXT i

    FUNCTION = Collect

END FUNCTION

SUB FilterSubjectFiles()
    LOCAL i AS LONG
    LOCAL SubjectID, ExperimentCode, StartDate, EndDate, extension AS STRING
    LOCAL tStartDate, tEndDate, subjectFileDate, temp AS STRING
    LOCAL bySubject, byExperimentCode, byDateRange, byExt, flag AS LONG
    LOCAL subjectFile AS STRING
    LOCAL lSubjectDate, byStartDate, byEndDate   AS LONG

    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_BySubjectID TO SubjectID
    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_ByExperimentCode TO ExperimentCode
    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_ByStartDate TO StartDate
    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_ByEndDate TO EndDate
    CONTROL GET TEXT hDlg, %IDC_COMBOBOX_ByExtension TO extension




    'LISTBOX reset hDlg, %IDC_LISTBOX_SubjectFiles
    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_BySubjectID TO bySubject
    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ByExperimentCode TO byExperimentCode
    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ByDateRange TO byDateRange
    CONTROL GET CHECK hDlg, %IDC_CHECKBOX_ByExtension TO byExt

    IF (bySubject = 1 AND byExperimentCode = 0 AND byDateRange = 0 AND byExt = 0) THEN
        flag = 1
    ELSEIF (bySubject = 0 AND byExperimentCode = 1 AND byDateRange = 0 AND byExt = 0) THEN
        flag = 2
    ELSEIF (bySubject = 0 AND byExperimentCode = 0 AND byDateRange = 1 AND byExt = 0) THEN
        flag = 3
    ELSEIF (bySubject = 0 AND byExperimentCode = 0 AND byDateRange = 0 AND byExt = 1) THEN
        flag = 4
    ELSEIF (bySubject = 1 AND byExperimentCode = 1 AND byDateRange = 0 AND byExt = 0) THEN
        flag = 5
    ELSEIF (bySubject = 1 AND byExperimentCode = 0 AND byDateRange = 1 AND byExt = 0) THEN
        flag = 6
    ELSEIF (bySubject = 1 AND byExperimentCode = 0 AND byDateRange = 0 AND byExt = 1) THEN
        flag = 7
    ELSEIF (bySubject = 1 AND byExperimentCode = 1 AND byDateRange = 1 AND byExt = 0) THEN
        flag = 8
    ELSEIF (bySubject = 1 AND byExperimentCode = 1 AND byDateRange = 0 AND byExt = 1) THEN
        flag = 9
    ELSEIF (bySubject = 1 AND byExperimentCode = 1 AND byDateRange = 1 AND byExt = 1) THEN
        flag = 10
    ELSEIF (bySubject = 0 AND byExperimentCode = 1 AND byDateRange = 1 AND byExt = 0) THEN
        flag = 11
    ELSEIF (bySubject = 0 AND byExperimentCode = 1 AND byDateRange = 0 AND byExt = 1) THEN
        flag = 12
    ELSEIF (bySubject = 0 AND byExperimentCode = 1 AND byDateRange = 1 AND byExt = 1) THEN
        flag = 13
    ELSEIF (bySubject = 0 AND byExperimentCode = 0 AND byDateRange = 1 AND byExt = 1) THEN
        flag = 14
    END IF

    SELECT CASE flag
        CASE 1 'SubjectID
            IF (TRIM$(SubjectID) <> "") THEN
                FOR i = 1 TO globals.nbrOfFiles
                   LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile

                   IF (INSTR(1, subjectFile, "S" + SubjectID) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                   END IF
                NEXT i
            END IF
        CASE 2 'ExperimentCode
            IF (TRIM$(ExperimentCode) <> "") THEN
                ExperimentCode =LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                   LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                   IF (INSTR(1, subjectFile, ExperimentCode) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                   END IF
                NEXT i
            END IF
        CASE 3 'DateRange
            FOR i = 1 TO globals.nbrOfFiles
                IF (TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "") THEN
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                   IF (lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                   END IF
               END IF
            NEXT i
        CASE 4 'Extension
            IF (TRIM$(extension) <> "") THEN
                FOR i = 1 TO globals.nbrOfFiles
                   LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                       IF (INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                           LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                    globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                       END IF
                NEXT i
            END IF
        CASE 5 'SubjectID, ExperimentCode
            IF (TRIM$(SubjectID) <> "" AND TRIM$(ExperimentCode) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    IF (INSTR(1, subjectFile, SubjectID) <> 0 AND INSTR(1, subjectFile, ExperimentCode) <> 0) THEN
                        LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                        globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 6 'SubjectID, DateRange
            IF (TRIM$(SubjectID) <> "" AND TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "") THEN
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (INSTR(1, subjectFile, SubjectID) <> 0 AND lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 7 'SubjectID, extension
            IF (TRIM$(SubjectID) <> "" AND TRIM$(extension) <> "") THEN
                FOR i = 1 TO globals.nbrOfFiles
                   LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                       IF (INSTR(1, subjectFile, SubjectID) <> 0 AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                           LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                    globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                       END IF
                NEXT i
            END IF
        CASE 8 'SubjectID, ExperimentCode, DateRange
            IF (TRIM$(SubjectID) <> "" AND TRIM$(ExperimentCode) <> "" AND TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (INSTR(1, subjectFile, SubjectID) <> 0 AND INSTR(1, subjectFile, ExperimentCode) <> 0 AND lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 9 'SubjectID, ExperimentCode, Extension
            IF (TRIM$(SubjectID) <> "" AND TRIM$(ExperimentCode) <> "" AND TRIM$(extension) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    IF (INSTR(1, subjectFile, SubjectID) <> 0 AND INSTR(1, subjectFile, ExperimentCode) <> 0 AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 10 'SubjectID, ExperimentCode, DateRange, Extension
            IF (TRIM$(SubjectID) <> "" AND TRIM$(ExperimentCode) <> "" AND TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "" AND TRIM$(extension) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (INSTR(1, subjectFile, SubjectID) <> 0 AND INSTR(1, subjectFile, ExperimentCode) <> 0 AND lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 11 'ExperimentCode, DateRange
            IF (TRIM$(ExperimentCode) <> "" AND TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (INSTR(1, subjectFile, ExperimentCode) <> 0 AND lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 12 'ExperimentCode, Extension
            IF (TRIM$(ExperimentCode) <> "" AND TRIM$(extension) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    IF (INSTR(1, subjectFile, ExperimentCode) <> 0 AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 13 'ExperimentCode, DateRange, Extension
            IF (TRIM$(ExperimentCode) <> "" AND TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "" AND TRIM$(extension) <> "") THEN
                ExperimentCode = LEFT$(ExperimentCode, 2)
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (INSTR(1, subjectFile, ExperimentCode) <> 0 AND lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF
        CASE 14 ' DateRange, Extension
            IF (TRIM$(StartDate) <> "" AND TRIM$(EndDate) <> "" AND TRIM$(extension) <> "") THEN
                FOR i = 1 TO globals.nbrOfFiles
                    LISTBOX GET TEXT hDlg, %IDC_LISTBOX_SubjectFiles, i TO subjectFile
                    tStartDate = RIGHT$(StartDate, 4) + LEFT$(StartDate, 2) + MID$(StartDate, 4, 2)
                    byStartDate = VAL(tStartDate)
                    tEndDate = RIGHT$(EndDate, 4) + LEFT$(EndDate, 2) + MID$(EndDate, 4, 2)
                    byEndDate = VAL(tEndDate)
                    temp = RIGHT$(subjectFile, 26)
                    subjectFileDate = MID$(temp, 10, 8)
                    lSubjectDate = VAL(subjectFileDate)
                    IF (lSubjectDate >= byStartDate AND lSubjectDate <= byEndDate AND INSTR(1, UCASE$(subjectFile), extension) <> 0) THEN
                       LISTBOX ADD hDlg, %IDC_LISTBOX_FilteredSubjectFiles, globals.sfd(i).Path + "S" + globals.sfd(i).SubjectID + "-" + globals.sfd(i).ExperimentCode + "-" + _
                                                                globals.sfd(i).Date + "-" + globals.sfd(i).Time + "." + globals.sfd(i).Extension
                    END IF
                NEXT i
            END IF

    END SELECT


    DIALOG REDRAW hDlg

END SUB

SUB LoadINISettings()
    GetPrivateProfileString("Experiment Section", "Directory", "NONE", globals.directoryLocation, %MAXPPS_SIZE, globals.INIFile)
END SUB

SUB EnableDisableForDirLocation(flag AS LONG)
    IF (flag = 1) THEN
        CONTROL ENABLE hDlg, %IDC_BUTTON_FilterFiles
        CONTROL ENABLE hDlg, %IDC_BUTTON_ResetFilter
        CONTROL ENABLE hDlg, %IDC_OPTION1
        CONTROL ENABLE hDlg, %IDC_CHECKBOX_BySubjectID
        CONTROL ENABLE hDlg, %IDC_CHECKBOX_ByExperimentCode
        CONTROL ENABLE hDlg, %IDC_CHECKBOX_ByDateRange
        CONTROL ENABLE hDlg, %IDC_CHECKBOX_ByExtension
        CONTROL ENABLE hDlg, %IDC_BUTTON_MoveToFiltered
    ELSE
        CONTROL DISABLE hDlg, %IDC_BUTTON_FilterFiles
        CONTROL DISABLE hDlg, %IDC_BUTTON_ResetFilter
        CONTROL DISABLE hDlg, %IDC_OPTION1
        CONTROL DISABLE hDlg, %IDC_CHECKBOX_BySubjectID
        CONTROL DISABLE hDlg, %IDC_CHECKBOX_ByExperimentCode
        CONTROL DISABLE hDlg, %IDC_CHECKBOX_ByDateRange
        CONTROL DISABLE hDlg, %IDC_CHECKBOX_ByExtension
        CONTROL DISABLE hDlg, %IDC_BUTTON_MoveToFiltered
    END IF
END SUB

SUB EnableDisableForFilterFiles(flag AS LONG)
    IF (flag = 1) THEN
        CONTROL ENABLE hDlg, %IDC_BUTTON_CopyFiles
        CONTROL ENABLE hDlg, %IDC_BUTTON_ViewFile
        CONTROL ENABLE hDlg, %IDC_BUTTON_ZipFiles
        CONTROL ENABLE hDlg, %IDC_BUTTON_DeletFiles
    ELSE
        CONTROL DISABLE hDlg, %IDC_BUTTON_CopyFiles
        CONTROL DISABLE hDlg, %IDC_BUTTON_ViewFile
        CONTROL DISABLE hDlg, %IDC_BUTTON_ZipFiles
        CONTROL DISABLE hDlg, %IDC_BUTTON_DeletFiles

    END IF
END SUB

FUNCTION GetFileAttribs(FilePattern AS STRING) AS STRING
   LOCAL FileInfo AS DIRDATA
   LOCAL fileSize AS QUAD
   LOCAL temp AS STRING
   LOCAL lft AS FileTime
   LOCAL st AS SystemTime

   temp = DIR$ (FilePattern TO FileInfo)
   FileTimeToLocalFileTime(BYVAL VARPTR(FileInfo.LastWriteTime), lft)
   FileTimeToSystemTime(lft, st)
   fileSize = FileInfo.FileSizeHigh ' fetch the file size from DIRDATA
   SHIFT LEFT fileSize, 32    ' Tom Hanlin's tip..
   fileSize OR = FileInfo.FileSizeLow
   FUNCTION =  FORMAT$(st.wMonth, "00") + "/" + FORMAT$(st.wDay, "00") + "/" + FORMAT$(st.wYear) + " " + _
               FORMAT$(st.wHour, "00") + ":" + FORMAT$(st.wMinute, "00") + _
               "    " + FORMAT$(fileSize, "000000000") + " KB"
END FUNCTION
