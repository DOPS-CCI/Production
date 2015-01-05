'------------------------------------------------------------------------------
' StatusOk200
' Returns %TRUE if the error message is of the 200 class.
'
FUNCTION StatusOk200 (BYVAL sBuffer AS STRING) AS LONG

    LOCAL iVal AS LONG

    iVal = VAL(LEFT$(sBuffer, 3))

    IF iVal >= 200 AND iVal <= 299 THEN
        FUNCTION = %TRUE
    END IF

END FUNCTION


'------------------------------------------------------------------------------
' StatusOk300
' Returns %TRUE if the error message is of the 200 or 300 class.
'
FUNCTION StatusOk300 (BYVAL sBuffer AS STRING) AS LONG

    LOCAL iVal AS LONG

    iVal = VAL(LEFT$(sBuffer, 3))

    IF iVal >= 200 AND iVal <= 399 THEN
        FUNCTION = %TRUE
    END IF

END FUNCTION


'-----------------------------------------------------------------------------
' Retrieve the current time and date in E-mail header format
'
'==================================================================================================
'  MailFile : Send E-mail with a file attachment using TCP statements
'==================================================================================================

'--------------------------------------------------------------------------------------------------
' Modify these equates to match your E-mail server and desired E-mail headers.
'--------------------------------------------------------------------------------------------------
$mailhost = "cms.mail.virginia.edu"                               'The name of your SMTP E-mailserver.
$MailFrom = "me@sender.com"
$MailTo   = "you@receiver.com"
$Subject  = "Arcovox E-mail, attachment demo"

'--------------------------------------------------------------------------------------------------
' Retrieve the current time and date in E-mail header format
'--------------------------------------------------------------------------------------------------
FUNCTION MailDate () AS STRING
    LOCAL szFormat AS ASCIIZ * 40, szTemp AS ASCIIZ * 40, sResult AS STRING
    LOCAL t AS SYSTEMTIME, sUCTOffset AS STRING, tzi AS TIME_ZONE_INFORMATION

    GetLocalTime t
    szFormat = "ddd',' dd MMM yyyy"
    GetDateFormat %LOCALE_USER_DEFAULT, 0, t, szFormat, szTemp, SIZEOF(szTemp)
    sResult = szTemp

    szFormat = "HH':'mm':'ss"
    GetTimeFormat %LOCALE_USER_DEFAULT, 0, t, szFormat, szTemp, SIZEOF(szTemp)

    SELECT CASE GetTimeZoneInformation(tzi)
    CASE %TIME_ZONE_ID_DAYLIGHT
        sUCTOffset = IIF$((tzi.bias + tzi.DaylightBias) <= 0, "+", "-") _
                   + FORMAT$(ABS(tzi.bias + tzi.DaylightBias) \ 60, "00") _
                   + FORMAT$(ABS(tzi.bias + tzi.DaylightBias) MOD 60, "00")
    CASE %TIME_ZONE_ID_STANDARD
        sUCTOffset = IIF$((tzi.bias + tzi.StandardBias) <= 0, "+", "-") _
                   + FORMAT$(ABS(tzi.bias + tzi.StandardBias) \ 60, "00") _
                   + FORMAT$(ABS(tzi.bias + tzi.StandardBias) MOD 60, "00")
    CASE ELSE
        sUCTOffset = "-0000"
    END SELECT
    FUNCTION = sResult + " " + szTemp + " " + sUCTOffset
END FUNCTION

'--------------------------------------------------------------------------------------------------
' Encode binary file data using Base64 encoding for MIME.
'--------------------------------------------------------------------------------------------------
FUNCTION MimeEncode (BYVAL sFileData AS STRING) AS STRING
  LOCAL lBlock, lcBlocks, lByte1, lByte2, lByte3, lIndex1, lIndex2, lIndex3, lIndex4 AS LONG
    LOCAL pInput, pOutput, pTable AS BYTE PTR
    LOCAL sBase64, sResult, Pad AS STRING

    sBase64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"   'Base64 table
    Pad = STRING$(2 - (LEN(sFileData) - 1) MOD 3, "=")          'Calculate padding on Base64 stream

    lcBlocks = (LEN(sFileData) + 2) \ 3                         'Round up the length of the input
    IF lcBlocks * 3 > LEN(sFileData) THEN                       'data to a multiple of three
      sFileData = LSET$(sFileData, lcBlocks * 3 USING $NUL)
    END IF

    sResult = SPACE$(lcBlocks * 4)                              'Allocate space for output string

    pInput  = STRPTR(sFileData)                                 'Set up pointers so we can treat
    pOutput = STRPTR(sResult)                                   'the data as byte streams
    pTable  = STRPTR(sBase64)

    FOR lBlock = 1 TO lcBlocks                                  'Loop through the input buffer
      lByte1 = @pInput : INCR pInput                            'Get the next three binary data-
      lByte2 = @pInput : INCR pInput                            'bytes to process
      lByte3 = @pInput : INCR pInput

      lIndex1 = lByte1 \ 4                                      'Translate 3 databytes to 4 Base64
      lIndex2 = (lByte1 AND 3) * 16 + lByte2 \ 16               'table indices
      lIndex3 = (lByte2 AND 15) * 4 + lByte3 \ 64
      lIndex4 = lByte3 AND 63

      @pOutput = @pTable[lIndex1] : INCR pOutput                'Use Base64 table to encode the
      @pOutput = @pTable[lIndex2] : INCR pOutput                'output string
      @pOutput = @pTable[lIndex3] : INCR pOutput
      @pOutput = @pTable[lIndex4] : INCR pOutput
    NEXT
  RSET ABS sResult = Pad                                        'Merge in the padding bytes
  FUNCTION = sResult
END FUNCTION

'==================================================================================================
'
'--------------------------------------------------------------------------------------------------
FUNCTION Send_Email(BYVAL sHost AS STRING, _                    'Mailhost URL
                    BYVAL sFrom AS STRING, _                    'Sender email address
                    BYVAL sTo AS STRING, _                      'Receiver email address
                    BYVAL sSubject AS STRING, _                 'Message header
                    BYVAL sMsgText AS STRING, _                 'Message text     ($Cr separated)
                    BYVAL sFiles AS STRING) AS LONG             'Attachment files ($Cr separated)

  LOCAL lLine AS LONG, nTCP AS LONG, sAttachment AS STRING, hFile AS DWORD
  LOCAL sLocalHost  AS STRING, sResponse AS STRING, sBoundary AS STRING
  LOCAL Cnt AS LONG, sPart AS STRING, sCut AS STRING, sFile AS STRING

  sBoundary = "Boundary." + REMOVE$(GUIDTXT$(GUID$), ANY "{-}") 'Make a unique filedata boundarymarker

  nTCP = FREEFILE                                               'Connect to E-mailserver (mailhost)
  TCP OPEN "smtp" AT sHost AS nTCP : IF ERR THEN EXIT FUNCTION

  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "220" THEN EXIT FUNCTION

  HOST NAME TO sLocalHost                                       'Get the local host name

  TCP PRINT nTCP, "HELO " + sLocalHost                          'Greet the mailhost
  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "250" THEN EXIT FUNCTION

  TCP PRINT nTCP, "MAIL FROM:<" + sFrom + ">"                   'Tell the mailhost who we are
  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "250" THEN EXIT FUNCTION

  sPart = sTo
  FOR Cnt = 0 TO TALLY (sTo, ",")
    SCut =  EXTRACT$(sPart, ",")
    TCP PRINT nTCP, "RCPT TO:<" + sCut + ">"                       'Tell mailhost who message is for
    TCP LINE nTCP, sResponse
    IF LEFT$(sResponse, 3) <> "250" THEN EXIT FUNCTION
    sPart = REMAIN$(sPart, ",")
  NEXT

  TCP PRINT nTCP, "DATA"                                        'Send the message
  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "354" THEN EXIT FUNCTION

  TCP PRINT nTCP, "Date: "    + MailDate                        'The E-mail header
  TCP PRINT nTCP, "From: "    + sFrom
  TCP PRINT nTCP, "To: "      + sTo
  TCP PRINT nTCP, "Subject: " + sSubject
  TCP PRINT nTCP, "X-Mailer: Arcovox MIME/Base64 E-mailer 1.0"
  TCP PRINT nTCP, "MIME-Version: 1.0"
  TCP PRINT nTCP, "Content-Type: multipart/mixed; boundary=" + $DQ + sBoundary + $DQ
  TCP PRINT nTCP, ""
  TCP PRINT nTCP, "--" + sBoundary

  ' Create a Plain-text section
  TCP PRINT nTCP, "Content-Type: text/plain; charset=" + $DQ + "us-ascii" + $DQ
  TCP PRINT nTCP, "Content-Transfer-Encoding: 7bit"
  TCP PRINT nTCP, ""

  ' Create a main E-mail body section
  sPart = sMsgText
  FOR Cnt = 0 TO TALLY(sPart, $CR)
    sCut = EXTRACT$(sPart, $CR)
    TCP PRINT nTCP, sCut
    sPart = REMAIN$(sPart, $CR)
  NEXT


  IF (sFiles <> "") THEN
    ' Create the attachment body section
    sPart = sFiles
    FOR Cnt = 0 TO TALLY(sFiles, $CR)
      sCut = EXTRACT$(sPart, $CR)
      sPart = REMAIN$(sPart, $CR)
      DIR$ CLOSE
      IF DIR$(sCut) <> "" THEN
        OPEN sCut FOR BINARY ACCESS READ LOCK SHARED AS #hFile 'Read the target file
        GET$ #hFile, LOF(hFile), sAttachment                                  '
        CLOSE #hFile                                                      '
        IF LEN (sAttachment) > 0 THEN
          sAttachment = MimeEncode(sAttachment)                         'Encode filedata in Base64 for MIME
          sFile = sCut
          WHILE INSTR(sFile, ANY "\:")
            sFile = RIGHT$(sFile, LEN(sFile) -1)
          WEND
          TCP PRINT nTCP, "--" + sBoundary
          TCP PRINT nTCP, "Content-Type: application/octet-stream; name=" + $DQ + sFile + $DQ
          TCP PRINT nTCP, "Content-Transfer-Encoding: base64"
          TCP PRINT nTCP, ""

          ' Write the encoded data in lines of 76 characters.  Add an equality
          ' character if the last line is less than 76 bytes long
          FOR lLine = 1 TO LEN(sAttachment) STEP 76
            IF LEN(sAttachment) - lLine >= 76 THEN
              TCP PRINT nTCP, MID$(sAttachment, lLine, 76)
            ELSE
              TCP PRINT nTCP, MID$(sAttachment, lLine) + "="
            END IF
          NEXT
        END IF
      END IF
    NEXT
    TCP PRINT nTCP, "--" + sBoundary + "--"                     'Send the terminating boundary marker
  END IF

  TCP PRINT nTCP, "."                                         'Now finish E-mail off; we're done sending the message
  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "250" THEN EXIT FUNCTION

  TCP PRINT nTCP, "QUIT"                                      'Say goodbye
  TCP LINE nTCP, sResponse
  IF LEFT$(sResponse, 3) <> "221" THEN EXIT FUNCTION

  TCP CLOSE nTCP
  FUNCTION = -1
END FUNCTION
