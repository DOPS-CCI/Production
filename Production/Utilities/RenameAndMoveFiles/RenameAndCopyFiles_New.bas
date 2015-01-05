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
#RESOURCE "RenameAndCopyFiles_New.pbr"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------
%MAXPPS_SIZE = 2048
'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG1      =  101
%IDC_CHECKBOX_BDF = 1001
%IDC_CHECKBOX_ETR = 1002
%IDC_CHECKBOX_CFG = 1003
%IDC_CHECKBOX_HDR = 1004
%IDC_CHECKBOX_EVT = 1005
%IDC_CHECKBOX_WMV = 1006
%IDC_BUTTON_Start = 1008
%IDC_BUTTON_Done  = 1007
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG1Proc()
DECLARE FUNCTION ShowDIALOG1(BYVAL hParent AS DWORD) AS LONG
#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

GLOBAL hDlg AS DWORD
GLOBAL hThread AS DWORD
'GLOBAL gActiviewFilename AS ASCIIZ * 256
GLOBAL gINIFilename AS ASCIIZ * 256
'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    LOCAL cmdCnt AS LONG
    LOCAL temp AS STRING

    temp = COMMAND$
    IF (TRIM$(temp) <> "") THEN
        cmdCnt = PARSECOUNT(temp, " ")

        SELECT CASE cmdCnt
            CASE 1
                gINIFilename = COMMAND$(1)
            CASE ELSE
                MSGBOX "Too many command line arguments."
                EXIT FUNCTION
        END SELECT
    ELSE
        MSGBOX "No .INI file name passed via the command line."
        EXIT FUNCTION  ' No command-line params given, just quit
    END IF


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
                ' /* Inserted by PB/Forms 06-05-2013 09:08:27
                CASE %IDC_BUTTON_Done
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlg, 0
                    END IF

                CASE %IDC_BUTTON_Start
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        copyFiles()
                    END IF
                ' */

                CASE %IDC_CHECKBOX_BDF

                CASE %IDC_CHECKBOX_ETR

                CASE %IDC_CHECKBOX_CFG

                CASE %IDC_CHECKBOX_HDR

                CASE %IDC_CHECKBOX_EVT

                CASE %IDC_CHECKBOX_WMV

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
    GLOBAL hDlg   AS DWORD
    LOCAL hFont1 AS DWORD

    DIALOG NEW hParent, "Copy Experiment Files", 70, 70, 150, 182, TO hDlg
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_BDF, "BDF File copied", 15, 10, _
        125, 20
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_ETR, "ETR File copied", 15, 30, _
        125, 20
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_CFG, "CFG File copied", 15, 50, _
        125, 20
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_HDR, "HDR File copied", 15, 70, _
        125, 20
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_EVT, "EVT File copied", 15, 90, _
        125, 20
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_WMV, "WMV File copied", 15, _
        110, 125, 20
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Done, "Done", 81, 145, 55, 30
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_Start, "Start", 15, 145, 55, 30

    FONT NEW "Arial Narrow", 12, 0, %ANSI_CHARSET TO hFont1

    CONTROL SET FONT hDlg, %IDC_CHECKBOX_BDF, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_ETR, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_CFG, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_HDR, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_EVT, hFont1
    CONTROL SET FONT hDlg, %IDC_CHECKBOX_WMV, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Done, hFont1
    CONTROL SET FONT hDlg, %IDC_BUTTON_Start, hFont1
#PBFORMS END DIALOG

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG1Proc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
    FONT END hFont1
#PBFORMS END CLEANUP

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

FUNCTION WorkerFunc(BYVAL x AS LONG) AS LONG
    LOCAL temp, ETRFile, tempConfigFile, actualConfigFile, nbrChannels AS ASCIIZ *256
    LOCAL subjectID, BDFFile, EVTFile, HDRFile, iDrive AS ASCIIZ *256

    ON ERROR GOTO CopyFileError

    GetPrivateProfileString("Subject Section", "SubjectFile", "", EVTFile, %MAXPPS_SIZE, gINIFilename)
    tempConfigFile = LEFT$(EVTFile, LEN(EVTFile) - 4)

    GetPrivateProfileString("Subject Section", "ID", "", subjectID, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Subject Section", "BDFFile", "", BDFFile, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Subject Section", "HeaderFile", "", HDRFile, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Subject Section", "ElectrodeFile", "", ETRFile, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Experiment Section", "Channels", "", nbrChannels, %MAXPPS_SIZE, gINIFilename)
    GetPrivateProfileString("Experiment Section", "ActiviewConfig", "", actualConfigFile, %MAXPPS_SIZE, gINIFilename)

    SELECT CASE TRIM$(nbrChannels)
        CASE "32"
            temp = "BS32.etr"
        CASE "64"
            temp = "BS64.etr"
        CASE "128"
            temp = "BS128.etr"
    END SELECT

    iDrive = "I:\Experiment Data v2\Subject_Data\" + subjectID + "\"

    IF (ISFOLDER(iDrive) = 0) THEN
        MKDIR iDrive
    END IF

    'Get .CFG file
    CHDRIVE "Y:"
    CHDIR "Actiview605\Configuring"

    FILECOPY actualConfigFile, iDrive + tempConfigFile + ".cfg"

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_CFG, 1

    'Get .BDF file
    CHDRIVE "X:"
    CHDIR "Subject_Data\" + subjectID

    FILECOPY TRIM$(BDFFile), iDrive + TRIM$(BDFFile)

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_BDF, 1

    'Get .ETR file
    CHDRIVE "X:"
    CHDIR "ElectrodePositionFiles\" + subjectID

    FILECOPY temp, iDrive + TRIM$(ETRFile)

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_ETR, 1

    'Get .EVT file
    CHDRIVE "C:"
    CHDIR "DOPS_Experiments\Subject_Data\" + subjectID

    FILECOPY TRIM$(EVTFile), iDrive + TRIM$(EVTFile)

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_EVT, 1

    'Get .HDR file
    CHDRIVE "C:"
    CHDIR "DOPS_Experiments\Subject_Data\" + subjectID

    FILECOPY TRIM$(HDRFile), iDrive + TRIM$(HDRFile)

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_HDR, 1

    'Get .WMV file
    CHDRIVE "C:"
    CHDIR "DOPS_Experiments\CameraFiles"

    FILECOPY "Generic.wmv", iDrive + tempConfigFile + ".WMV"

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_WMV, 1




CopyFileError:
    MSGBOX "Error on copying files. Error: " + ERR$
END FUNCTION

THREAD FUNCTION WorkerThread(BYVAL x AS LONG) AS LONG

    FUNCTION = WorkerFunc(x)

END FUNCTION

FUNCTION copyFiles() AS LONG
    LOCAL temp AS LONG

    temp = 1

    THREAD CREATE WorkerThread(temp) TO hThread

END FUNCTION
