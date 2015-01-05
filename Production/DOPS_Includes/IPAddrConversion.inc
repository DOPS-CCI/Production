'==================================================
' String2IP - converts a text IP address like 10.145.222.10 to a DWORD value (which is how windows handles them internally)
'==================================================
FUNCTION String2IP(sIP AS STRING) AS DWORD
   LOCAL dIP   AS DWORD
   LOCAL pIP   AS BYTE PTR
   IF PARSECOUNT(sIP,".") > 2 THEN
	  pIP = VARPTR(dIP) 'assign the Byte size pointer to the DWORD variable called dIP  (a DWORD can fit 4 byte variables inside it)
	  IF pIP <> 0 THEN
		 @pIP = VAL(PARSE$(sIP,".",1))    'assign the 1st octet of the dword variable called dIP
		 @pIP[1] = VAL(PARSE$(sIP,".",2)) '2nd octet (the [1] tells it we want to offset the pointer by one byte size variable)
		 @pIP[2] = VAL(PARSE$(sIP,".",3)) '3rd octet
		 @pIP[3] = VAL(PARSE$(sIP,".",4)) '4th octet
		 FUNCTION = dIP
	  END IF
   ELSE
	  FUNCTION = 0
   END IF
END FUNCTION

'==================================================
' IP2String - converts a DWORD in to the text version of a IP address (opposite of the String2IP function)
'==================================================
FUNCTION IP2String(dRawAddr AS DWORD) AS STRING
   DIM pIP AS BYTE PTR
   pIP = VARPTR(dRawAddr)     'assign the address to the pointer
   IF pIP <> 0 THEN
	  FUNCTION = USING$("#_.#_.#_.#", @pIP, @pIP[1], @pIP[2], @pIP[3])  'the powerbasic using$ command is similar to the Format() command
   END IF
END FUNCTION

'==================================================
' IsValidIP - looks at a text to see if it is a valid IP address
'==================================================
FUNCTION IsValidIP(BYVAL sIP AS STRING) AS LONG
   LOCAL iCount AS LONG
   IF ISTRUE VERIFY(sIP, "0123456789.") THEN EXIT FUNCTION  'the powerbasic Verify() command tells us if we have any character not in our list
   IF INSTR(1,sIP,"..") THEN EXIT FUNCTION   'not valid if we have 2 periods together
   IF PARSECOUNT(sIP, ".") <> 4 THEN EXIT FUNCTION 'not valid if we dont have exactly 4 segments
   FOR iCount = 1 TO 4     'now loop through each segment and make sure the number value is from 0 to 255
	  IF VAL(PARSE$(sIP, ".", iCount)) > 255 THEN EXIT FUNCTION
   NEXT iCount
   FUNCTION = %TRUE  'if we made it passed all the tests it must be valid so return TRUE
END FUNCTION


'==================================================
' IncrIpRange - used to process through a IP range (changes the IP dword to the next IP and returns FALSE if past the last IP in the range)
'==================================================
FUNCTION IncrIpRange(IP AS DWORD, ToIP AS DWORD) AS LONG 'increases to the next IP address
   LOCAL pIP   AS BYTE PTR
   LOCAL pToIP AS BYTE PTR
   LOCAL iRet  AS LONG
   pIP = VARPTR(IP)
   pToIP = VARPTR(ToIP)
   IF (pIP = 0) OR (pToIP = 0) THEN EXIT FUNCTION
   INCR @pIP[3]         '4th octet
   IF @pIP[3] = 0 THEN
	  INCR @pIP[2]      '3rd octet
	  IF @pIP[2] = 0 THEN
		 INCR @pIP[1]   '2nd octet
		 IF @pIP[1] = 0 THEN
			INCR @pIP   '1st octet
		 END IF
	  END IF
   END IF
   iRet = %TRUE   '%TRUE unless we find otherwise
   IF @pIP[3] > @pToIP[3] THEN iRet = %FALSE    '4th octet is greater so %FALSE
   IF @pIP[2] < @pToIP[2] THEN iRet = %TRUE     '3rd octet is lessthan so %TRUE even if 4th octet is greater
   IF @pIP[2] > @pToIP[2] THEN iRet = %FALSE    '3rd octet is greater so %FALSE
   IF @pIP[1] < @pToIP[1] THEN iRet = %TRUE     '2nd octet is lessthan so %TRUE even if 3rd or 4th octet is greater
   IF @pIP[1] > @pToIP[1] THEN iRet = %FALSE    '2nd octet is greater so %FALSE
   IF @pIP < @pToIP THEN iRet = %TRUE           '1st octet is lessthan so %TRUE even if 2nd or 3rd or 4th octet is greater
   IF @pIP > @pToIP THEN iRet = %FALSE          '1st octet is greater so %FALSE
   FUNCTION = iRet
   'returns %FALSE if new IP is past ToIP
END FUNCTION
'==================================================


'==================================================
' InIpRange - tests to see if a IP is inside a IP range
'==================================================
FUNCTION InIpRange(dIP AS DWORD, dFromIP AS DWORD, dToIP AS DWORD) AS LONG
   LOCAL pIP      AS BYTE PTR
   LOCAL pFromIP  AS BYTE PTR
   LOCAL pToIP    AS BYTE PTR
   LOCAL iRet1    AS LONG
   LOCAL iRet2    AS LONG
   pIP = VARPTR(dIP)
   pFromIP = VARPTR(dFromIP)
   pToIP = VARPTR(dToIP)
   IF (pIP = 0) OR (pToIP = 0) OR (pFromIP = 0) THEN EXIT FUNCTION

   'check if IP is above the From IP
   iRet1 = %TRUE   '%TRUE unless we find otherwise
   IF @pIP[3] < @pFromIP[3] THEN iRet1 = %FALSE    '4th octet is lessthan so %FALSE
   IF @pIP[2] > @pFromIP[2] THEN iRet1 = %TRUE     '3rd octet is greater so %TRUE even if 4th octet is less
   IF @pIP[2] < @pFromIP[2] THEN iRet1 = %FALSE    '3rd octet is lessthan so %FALSE
   IF @pIP[1] > @pFromIP[1] THEN iRet1 = %TRUE     '2nd octet is greater so %TRUE even if 3rd or 4th octet is less
   IF @pIP[1] < @pFromIP[1] THEN iRet1 = %FALSE    '2nd octet is lessthan so %FALSE
   IF @pIP > @pFromIP THEN iRet1 = %TRUE           '1st octet is greater so %TRUE even if 2nd or 3rd or 4th octet is less
   IF @pIP < @pFromIP THEN iRet1 = %FALSE          '1st octet is lessthan so %FALSE

   'check if IP is below the To IP
   iRet2 = %TRUE   '%TRUE unless we find otherwise
   IF @pIP[3] > @pToIP[3] THEN iRet2 = %FALSE    '4th octet is greater so %FALSE
   IF @pIP[2] < @pToIP[2] THEN iRet2 = %TRUE     '3rd octet is lessthan so %TRUE even if 4th octet is greater
   IF @pIP[2] > @pToIP[2] THEN iRet2 = %FALSE    '3rd octet is greater so %FALSE
   IF @pIP[1] < @pToIP[1] THEN iRet2 = %TRUE     '2nd octet is lessthan so %TRUE even if 3rd or 4th octet is greater
   IF @pIP[1] > @pToIP[1] THEN iRet2 = %FALSE    '2nd octet is greater so %FALSE
   IF @pIP < @pToIP THEN iRet2 = %TRUE           '1st octet is lessthan so %TRUE even if 2nd or 3rd or 4th octet is greater
   IF @pIP > @pToIP THEN iRet2 = %FALSE          '1st octet is greater so %FALSE

   IF (iRet1 = %TRUE) AND (iRet2 = %TRUE) THEN FUNCTION = %TRUE
END FUNCTION
