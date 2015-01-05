#COMPILE EXE
#DIM ALL
#DEBUG ERROR ON

#RESOURCE "RenameAndCopyFiles.pbr"


#INCLUDE "comdlg32.inc"
#INCLUDE "win32api.inc"
#INCLUDE "DOPS_PB_CBW.INC"
#INCLUDE "DOPS_ExperimentInfo.inc"
#INCLUDE "DOPS_Utils.inc"
#INCLUDE "DOPS_Statistics.inc"

%MAXPPS_SIZE = 2048

%LISTBOX_FILES = 1005
%BUTTON_LOCATEHDR = 1006
%BUTTON_LOCATEEVT = 1007
%BUTTON_LOCATEBDF = 1008
%BUTTON_LOCATEETR = 1009

%BUTTON_MOVEFILES = 1010
%BUTTON_CANCEL = 1011
%BUTTON_DELETEFILES = 1012
%BUTTON_LOCATECAM = 1013
%IDC_LABEL1 = 1014
%BUTTON_LOCATECFG = 1015

%IDC_TEXTBOX_SubjectID = 1016
%IDC_LABEL_Message     = 2049


GLOBAL hDlg AS DWORD
GLOBAL lastSubjectID AS STRING
GLOBAL gazHdrFile, gazEvtFile, gazBDFFile, gazETRFile, gazNewBDFFile, gazNewETRFile, gazCAMFile, gazCFGFile AS ASCIIZ * 255
GLOBAL gsHeaderFilename AS STRING
GLOBAL giGotHdr, giGotEvt, giGotBDF, giGotETR, giGotWMV, giGotCFG, giHdrOnce AS INTEGER

' *********************************************************************************************
'                                  M A I N     P R O G R A M
' *********************************************************************************************
FUNCTION PBMAIN
    LOCAL lResult AS LONG

    giHdrOnce = 0
    lastSubjectID = ""
    CALL dlgRenameAndMoveFiles()
    DIALOG SHOW MODAL hDlg, CALL cbRenameAndMoveFiles TO lResult


END FUNCTION

SUB dlgRenameAndMoveFiles()
    LOCAL hr AS DWORD

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    'LOCAL hDlg  AS DWORD

    DIALOG NEW PIXELS, 0, "Rename And Copy Files", 180, 148, 634, 320, _
        %WS_OVERLAPPEDWINDOW OR %DS_CENTER OR %WS_VISIBLE OR %DS_3DLOOK OR _
        %DS_NOFAILCREATE OR %DS_SETFONT, %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %WS_EX_CONTROLPARENT, TO hDlg
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX_SubjectID, "", 136, 16, 160, 24
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATEHDR, "Locate Header File", 16, _
        56, 125, 25, , CALL cbLocateHeaderFile
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATEEVT, "Locate Event File", 16, _
        96, 125, 25, , CALL cbLocateEventFile()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATEBDF, "Locate BDF file", 16, 136, _
        125, 25, , CALL cbLocateBDFFile()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATEETR, "Locate Electrode File", _
        16, 176, 125, 25, , CALL cbLocateETRFile()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATECAM, "Locate Camera File", 16, _
        215, 125, 25  , , CALL cbLocateCamFile()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_LOCATECFG, "Locate Biosemi cfg File", _
        16, 255, 125, 25, , CALL cbLocateCFGFile()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_MOVEFILES, "Copy Files", 201, 253, 75, _
        30, , , CALL cbMoveFiles()
    'CONTROL ADD BUTTON,  hDlg, %BUTTON_DELETEFILES, "Delete Files", 309, 253, _
    '    75, 30, , , CALL cbDeleteFiles()
    CONTROL ADD BUTTON,  hDlg, %BUTTON_CANCEL, "Close", 421, 253, 75, 30, , , CALL cbCancel()
    CONTROL ADD LISTBOX, hDlg, %LISTBOX_FILES, , 156, 66, 441, 165
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL1, "Enter the Subject ID:", 16, 16, _
       120, 24
    CONTROL ADD LABEL,   hDlg, %IDC_LABEL_Message, "", 128, 296, 400, 24
#PBFORMS END DIALOG

    CONTROL DISABLE hDlg, %BUTTON_LOCATEEVT
    CONTROL DISABLE hDlg, %BUTTON_LOCATEBDF
    CONTROL DISABLE hDlg, %BUTTON_LOCATEETR
    CONTROL DISABLE hDlg, %BUTTON_LOCATECAM
    CONTROL DISABLE hDlg, %BUTTON_LOCATECFG
    CONTROL DISABLE hDlg, %BUTTON_MOVEFILES


    DIALOG SET ICON hDlg, "RenAndMove.ico"

END SUB

CALLBACK FUNCTION cbRenameAndMoveFiles()
    SELECT CASE CBMSG
        CASE %WM_INITDIALOG
           giGotHdr = 0
           giGotEvt = 0
           giGotBDF = 0
           giGotETR = 0
           giGotWMV = 0
           giGotCFG = 0
        CASE %WM_DESTROY
            PostQuitMessage 0

        CASE %WM_COMMAND

        CASE %WM_PAINT
    END SELECT
END FUNCTION

CALLBACK FUNCTION cbLocateHeaderFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL sSubjectID AS STRING
    LOCAL sCamFile AS STRING
    LOCAL rngFile, arngFile AS STRING
    LOCAL RES AS LONG


    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_SubjectID TO sSubjectID
        IF (TRIM$(sSubjectID) = "") THEN
            MSGBOX "Please enter a Subject ID."
        END IF
        sSubjectID = FORMAT$(VAL(sSubjectID), "0000")
        OpenFileDialog (0, _                                  ' parent window
              "Open .HDR File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "C:\DOPS_Experiments\Subject_Data\" + TRIM$(sSubjectID), _                            ' start directory
              "HDR Files|*.hdr", _  ' filename filter
              "hdr", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            giGotHdr = 1
            gazHdrFile =  PATHNAME$(PATH, sFileSpec)  + PATHNAME$(NAME, sFileSpec)
            gsHeaderFilename = PATHNAME$(NAME, sFileSpec)

            rngFile = gazHdrFile + "-RNG.CSV"
            arngFile = gazHdrFile + "-ANG.CSV"

            'added 7/24/13 per Ross Dunseath who wanted defaults
            'listbox reset hDlg, %LISTBOX_FILES
            IF (sSubjectID <> lastSubjectID) THEN
                LISTBOX RESET hDlg, %LISTBOX_FILES
                LISTBOX DELETE hDlg, %LISTBOX_FILES, 1
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 1, gazHdrFile + ".HDR"
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 2, gazHdrFile + ".EVT"
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 3, "X:\Subject_Data\" + TRIM$(sSubjectID) + "\" + PATHNAME$(NAME, sFileSpec)+ ".BDF"
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 4, "X:\ElectrodePositionFiles\" + PATHNAME$(NAME, sFileSpec) + ".ETR"
                sCamFile = getLatestCamFile()
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 5, "C:\DOPS_Experiments\RecordedFiles\" + sCamFile
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 6, "Y:\Actiview605\Configuring\Generic.CFG"

                'added 4/8/2014 per Ross Dunseath - if there are RNG .CSV
                'files add them to be copied.
                IF (ISFILE(rngFile)) THEN
                   LISTBOX INSERT hDlg, %LISTBOX_FILES, 7, rngFile
                END IF
                IF (ISFILE(arngFile)) THEN
                   LISTBOX INSERT hDlg, %LISTBOX_FILES, 8, arngFile
                END IF

                MSGBOX "Please check the default files before copying."
            ELSE
                LISTBOX DELETE hDlg, %LISTBOX_FILES, 1
                LISTBOX INSERT hDlg, %LISTBOX_FILES, 1, gazHdrFile + ".HDR"
            END IF

            lastSubjectID = sSubjectID

            'control set text hDlg, %IDC_LABEL_Message, "You still need to choose your camera file."
            CONTROL ENABLE hDlg, %BUTTON_LOCATEEVT
            CONTROL ENABLE hDlg, %BUTTON_LOCATEBDF
            CONTROL ENABLE hDlg, %BUTTON_LOCATEETR
            CONTROL ENABLE hDlg, %BUTTON_LOCATECAM
            CONTROL ENABLE hDlg, %BUTTON_LOCATECFG
            CONTROL ENABLE hDlg, %BUTTON_MOVEFILES
            giGotHdr = 1
           giGotEvt = 1
           giGotBDF = 1
           giGotETR = 1
           giGotWMV = 1
           giGotCFG = 1
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

FUNCTION getLatestCamFile() AS STRING
    LOCAL x AS LONG
    LOCAL sFile, sTemp AS STRING

    SHELL ENVIRON$("COMSPEC") + " /C dir C:\DOPS_Experiments\RecordedFiles\*.WMV /o:-d > C:\DOPS_Experiments\RecordedFiles\tempfiles.tmp", 0
    OPEN "C:\DOPS_Experiments\RecordedFiles\tempfiles.tmp" FOR INPUT AS #1
    FOR x = 1 TO 5
        LINE INPUT #1, sTemp
    NEXT x
    LINE INPUT #1, sFile
    CLOSE #1

    KILL "C:\DOPS_Experiments\RecordedFiles\tempfiles.tmp"

    FUNCTION = MID$(sFile, 40, LEN(sFile) - 40 + 1)

END FUNCTION

CALLBACK FUNCTION cbLocateEventFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL sSubjectID AS STRING
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_SubjectID TO sSubjectID
        IF (TRIM$(sSubjectID) = "") THEN
            MSGBOX "Please enter a Subject ID."
        END IF
        sSubjectID = FORMAT$(VAL(sSubjectID), "0000")
        OpenFileDialog (0, _                                  ' parent window
              "Open .EVT File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "C:\DOPS_Experiments\Subject_Data\" + TRIM$(sSubjectID), _                            ' start directory
              "EVT Files|*.evt", _  ' filename filter
              "evt", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                                 ' Res nonzero = Not cancelled, No error
            giGotEvt = 1
            gazEvtFile =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            'LISTBOX ADD hDlg, %LISTBOX_FILES, gazEvtFile
            LISTBOX DELETE hDlg, %LISTBOX_FILES, 2
            LISTBOX INSERT hDlg, %LISTBOX_FILES, 2, gazEvtFile
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbLocateBDFFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL sSubjectID AS STRING
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        CONTROL GET TEXT hDlg, %IDC_TEXTBOX_SubjectID TO sSubjectID
        IF (TRIM$(sSubjectID) = "") THEN
            MSGBOX "Please enter a Subject ID."
        END IF
        sSubjectID = FORMAT$(VAL(sSubjectID), "0000")
        OpenFileDialog (0, _                                  ' parent window
              "Open .BDF File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "X:\Subject_Data\" + TRIM$(sSubjectID), _                            ' start directory
              "BDF Files|*.bdf", _  ' filename filter
              "bdf", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            giGotBDF = 1
            gazBDFFile =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            'LISTBOX ADD hDlg, %LISTBOX_FILES, gazBDFFile
            LISTBOX DELETE hDlg, %LISTBOX_FILES, 3
            LISTBOX INSERT hDlg, %LISTBOX_FILES, 3, gazBDFFile
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbLocateETRFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        OpenFileDialog (0, _                                  ' parent window
              "Open .ETR File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "X:\ElectrodePositionFiles", _                            ' start directory
              "ETR Files|*.etr", _  ' filename filter
              "etr", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            giGotETR = 1
            gazETRFile =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            'LISTBOX ADD hDlg, %LISTBOX_FILES, gazETRFile
            LISTBOX DELETE hDlg, %LISTBOX_FILES, 4
            LISTBOX INSERT hDlg, %LISTBOX_FILES, 4, gazETRFile
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbLocateCamFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        OpenFileDialog (0, _                                  ' parent window
              "Open .WMV File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "C:\DOPS_Experiments\RecordedFiles", _                            ' start directory
              "CAM Files|*.WMV", _  ' filename filter
              "wmv", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            giGotWMV = 1
            gazCAMFile =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            'LISTBOX ADD hDlg, %LISTBOX_FILES, gazCamFile
            LISTBOX DELETE hDlg, %LISTBOX_FILES, 5
            LISTBOX INSERT hDlg, %LISTBOX_FILES, 5, gazCamFile
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbLocateCFGFile() AS LONG
    LOCAL sFileSpec AS STRING
    LOCAL RES AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        '...Process the click event here
        OpenFileDialog (0, _                                  ' parent window
              "Open .cfg File", _                         ' caption
              sFileSpec, _                          ' filename   <- gets set to user selection
              "Y:\Actiview605\Configuring", _                            ' start directory
              "CFG Files|*.cfg", _  ' filename filter
              "cfg", _                              ' default extension
              0 _                                   ' flags
             ) TO RES

          IF RES <> 0 THEN                                      ' Res nonzero = Not cancelled, No error
            giGotCFG = 1
            gazCFGFile =  PATHNAME$(PATH, sFileSpec) + PATHNAME$(NAMEX, sFileSpec)
            'LISTBOX ADD hDlg, %LISTBOX_FILES, gazCFGFile
            LISTBOX DELETE hDlg, %LISTBOX_FILES, 6
            LISTBOX INSERT hDlg, %LISTBOX_FILES, 6, gazCFGFile
          END IF
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbMoveFiles() AS LONG
    LOCAL folder, str AS STRING
    LOCAL y, z, hThread AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        IF (giGotHdr = 1 AND giGotEvt = 1 AND giGotBDF = 1 AND giGotETR = 1 AND giGotWMV = 1 AND giGotCFG = 1) THEN

            THREAD CREATE CopyWorkerThread(y) TO hThread


        ELSE
            MSGBOX "You must have 6 files to copy (*.hdr, *.evt, *.bdf, *.etr, *.wmv, *.cfg)."
            EXIT FUNCTION
        END IF



        'DIALOG END ghDlg, 1
        FUNCTION = 1
    END IF
END FUNCTION

CALLBACK FUNCTION cbCancel() AS LONG
  IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
    '...Process the click event here
     PostQuitMessage 0
     DIALOG END hDlg, 0
    FUNCTION = 1
  END IF
END FUNCTION

CALLBACK FUNCTION cbDeleteFiles() AS LONG
    LOCAL folder, str AS STRING
    LOCAL y, z, result AS LONG

    IF CB.MSG = %WM_COMMAND AND CB.CTLMSG = %BN_CLICKED THEN
        IF (giGotHdr = 1 AND giGotEvt = 1 AND giGotBDF = 1 AND giGotETR = 1) THEN
            result = MSGBOX("Are you sure you want to delete the original files?", %MB_YESNO, "Delete Files?")

            IF (result = %IDYES) THEN
                LISTBOX GET COUNT hDlg, %LISTBOX_FILES TO y
                FOR z = 1 TO y
                    LISTBOX GET TEXT hDlg, %LISTBOX_FILES, z TO str
                    'msgbox "FILECOPY " + str + "," + folder + "\" + PATHNAME$(NAMEX, str)
                    KILL str
                NEXT z
                MOUSEPTR 1
            END IF
        ELSE
            MSGBOX "You must have 6 files to delete (*.hdr, *.evt, *.bdf, *.etr, *.wmv, *.cfg)."
            EXIT FUNCTION
        END IF

        MSGBOX "Your original files have been deleted properly."
        PostQuitMessage 1
        'DIALOG END ghDlg, 1
        FUNCTION = 1
    END IF
END FUNCTION


FUNCTION CopyWorkerFunc(BYVAL x AS LONG) AS LONG
    LOCAL folder, str, temp AS STRING
    LOCAL y, z AS LONG

    DISPLAY BROWSE hDlg, , , "Where do you want to copy the files to (Default is DVD)?", "D:\",  %BIF_NEWDIALOGSTYLE  TO folder

    IF (folder <> "") THEN
        MOUSEPTR 11
        LISTBOX GET COUNT hDlg, %LISTBOX_FILES TO y
        FOR z = 1 TO y
            LISTBOX GET TEXT hDlg, %LISTBOX_FILES, z TO str
            'add 4/8/2014 - these 2 files are hard-coded into the listbox (above)
            'we need to convert them to our experiment name format.
            str = UCASE$(str)
            IF (INSTR(str,".CFG") > 0 OR _
                    INSTR(str, ".ETR") > 0 OR _
                    INSTR(str, ".WMV") > 0) THEN
               temp = folder + "\" + gsHeaderFilename + PATHNAME$(EXTN, str)
               FILECOPY str ,  temp
            ELSE
               FILECOPY str ,  folder + "\" + PATHNAME$(NAMEX, str)
            END IF

            CONTROL SET TEXT hDlg, %IDC_LABEL_Message, "Copying " + str
        NEXT z
        MOUSEPTR 1

        CONTROL SET TEXT hDlg, %IDC_LABEL_Message, "Done."

        MSGBOX "Please verify that your files have been renamed properly and copied to the designated location."

        PostQuitMessage 1
    END IF

END FUNCTION



THREAD FUNCTION CopyWorkerThread(BYVAL x AS LONG) AS LONG

 FUNCTION = CopyWorkerFunc(x)

END FUNCTION
