'************************************************************
'* INCLUDE FILE FOR SACKSPB.DLL
'* Author:    Ken Myers
'* Company:   ZCureIT Tech
'* Copyright: (c) 2004.  ZCureIT Tech.  All Rights Reserved.
'*
'* PLEASE REVIEW THE LICENSE AGREEMENT FOR SACKSPB.DLL BEFORE
'* USING THIS INCLUDE FILE AND THE DLL.
'************************************************************

'**************************
' Special Type Declarations
'**************************
'This structure is used for all attribute manipulation
TYPE PARSEPTR
    pString AS LONG
    xmlData AS LONG
END TYPE

TYPE ATTRIBUTENODE
    AttributeName AS PARSEPTR       'Pointer to the attribute name string
    AttributeValue AS PARSEPTR      'Pointer to the attribute value string
END TYPE

'*******************************************************
' Registration Function - All registered users
' should call this function first before any
' other SacksPB function!  Make sure you type
' everything exactly or the XPath and INET functions
' will not work properly!  All other functions are fine.
'*******************************************************
DECLARE SUB SPB_Register LIB "SACKSPB.DLL" ALIAS "SPB_REGISTER" (BYVAL myKey AS STRING, BYVAL regName AS STRING)

' Exported Functions for Parsing XML
'*******************************************
'GetXmlTags        ----> takes the following:
'   xmldoc         ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
'   myTags()       ----> An array that will hold the tags (mini XML files)
'   whitespace     ----> Specify 0 to remove whitespace, non-zero to keep whitespace
DECLARE FUNCTION SPB_GetXmlTags LIB "SACKSPB.DLL" ALIAS "SPB_GETXMLTAGS" (BYVAL xmldoc AS STRING, BYREF myTags() AS STRING, whitespace AS LONG) AS LONG

'Same as above with a Callback for each Tag
'Callback prototype is simple:
'CallBack Function GetXmlTagsCB(myTag as String) as long -> return 1 for success 0 for failure. NOTE: 0 will exit this function.
DECLARE FUNCTION SPB_GetXmlTagsEvent LIB "SACKSPB.DLL" ALIAS "SPB_GETXMLTAGSEVENT" (BYVAL xmldoc AS STRING, whitespace AS LONG, cbfunction AS LONG) AS LONG

'GetXmlTagsElement ----> takes the following:
'   xmldoc         ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
'   myTags()       ----> An array that will hold the tags (mini XML files)
'   elementName    ----> The name of the element you are specifically looking for
'   whitespace     ----> Specify 0 to remove whitespace, non-zero to keep whitespace
DECLARE FUNCTION SPB_GetXmlTagsElement LIB "SACKSPB.DLL" ALIAS "SPB_GETXMLTAGSELEMENT" (BYVAL xmldoc AS STRING, BYREF myTags() AS STRING, elementName AS STRING, whitespace AS LONG) AS LONG

'Same as above with a Callback for each Tag
'Callback prototype is simple:
'CallBack Function GetXmlTagsElementCB(myTag as String) as long -> return 1 for success 0 for failure. NOTE: 0 will exit this function.
DECLARE FUNCTION SPB_GetXmlTagsElementEvent LIB "SACKSPB.DLL" ALIAS "SPB_GETXMLTAGSELEMENTEVENT" (BYVAL xmldoc AS STRING, elementName AS STRING, whitespace AS LONG, cbfunction AS LONG) AS LONG

'GetAttributes     ----> takes the following:
'   Tag            ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
'   attributes()   ----> An array of type ATTRIBUTENOD that will hold all of the attributes for each tag (if any)
DECLARE FUNCTION SPB_GetAttributes LIB "SACKSPB.DLL" ALIAS "SPB_GETATTRIBUTES" (Tag AS STRING,BYREF attributes() AS ATTRIBUTENODE) AS LONG

'GetElementName    ----> takes the following:
'   Tag            ----> This is a tag retrieved from GetXmlTags or GetXmlTagsElement
DECLARE FUNCTION SPB_GetElementName LIB "SACKSPB.DLL" ALIAS "SPB_GETELEMENTNAME" (Tag AS STRING) AS STRING

'GetElementValue   ----> takes the following:
'   Tag            ----> This is a tag retrieved from GetXmlTags or GetXmlTagsElement
DECLARE FUNCTION SPB_GetElementValue LIB "SACKSPB.DLL" ALIAS "SPB_GETELEMENTVALUE" (Tag AS STRING) AS STRING

'GetParsePtr       ----> takes the following:
'   myPtr          ----> This is a pointer to a PARSEPTR - Used by ATTRIBUTENODE
DECLARE FUNCTION SPB_GetParsePtr LIB "SACKSPB.DLL" ALIAS "SPB_GETPARSEPTR" (myPtr AS LONG) AS STRING

'XMLFileLoad       ----> takes the following:
'   FileName       ----> This is an absolute path to a file (NO RELATIVE PATHS!)
DECLARE FUNCTION SPB_XMLFileLoad LIB "SACKSPB.DLL" ALIAS "SPB_XMLFILELOAD" (BYVAL FileName AS STRING) AS STRING

'XMLFileSave        ----> takes the following:
'   xmldoc          ----> XML string that you want to save
'   FileName        ----> The path to a file you want to create
'Returns a 0 on success 1 on failure
DECLARE FUNCTION SPB_XMLFileSave LIB "SACKSPB.DLL" ALIAS "SPB_XMLFILESAVE" (BYVAL xmldoc AS STRING, FileName AS STRING) AS LONG

'RemoveComments    ----> Necessary as comment tags are not supported by the parser
'   xmldoc         ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
DECLARE FUNCTION SPB_RemoveComments LIB "SACKSPB.DLL" ALIAS "SPB_REMOVECOMMENTS" (BYVAL xmldoc AS STRING) AS STRING

'RemoveCDATA       ----> Necessary as CDATA sections are not supported by the parser
'   xmldoc         ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
DECLARE FUNCTION SPB_RemoveCDATA LIB "SACKSPB.DLL" ALIAS "SPB_REMOVECDATA" (BYVAL xmldoc AS STRING) AS STRING

'FilterCDATA       ----> Most likely is necessary unless you decide to use RemoveCDATA
'   xmldoc         ----> XML as a string (use XMLFileLoad if you need to load the file to a string)
DECLARE FUNCTION SPB_FilterCDATA LIB "SACKSPB.DLL" ALIAS "SPB_FILTERCDATA" (BYVAL xmldoc AS STRING) AS STRING

'EncodeValue       ----> Deal with the characters <,>,&,',%, and /.  If you are using CDATA sections
'DecodeValue             and getting unusual results, these functions will clean your data for you
'                        at least for use with SacksPB.  You shouldn't need EncodeValue, but you
'                        will need DecodeValue if you use CDATA sections.
DECLARE FUNCTION SPB_EncodeValue LIB "SACKSPB.DLL" ALIAS "SPB_ENCODEVALUE" (BYVAL strin AS STRING) AS STRING
DECLARE FUNCTION SPB_DecodeValue LIB "SACKSPB.DLL" ALIAS "SPB_DECODEVALUE" (BYVAL strin AS STRING) AS STRING

'GenerateDTD        ----> Create an Element-centric DTD for basic validation
'                   ----> Takes XML as a string or the absolute path to the file
DECLARE FUNCTION SPB_GenerateDTD LIB "SACKSPB.DLL" ALIAS "SPB_GENERATEDTD" (BYVAL xmldoc AS STRING) AS STRING

'This function returns a 1 if the document is valid and a 0 if it is not valid.
' xmldoc            ----> This is the XML instance string or absolute path
' xmldtd            ----> This is the DTD string or absolute path
DECLARE FUNCTION SPB_ValidateDTD LIB "SACKSPB.DLL" ALIAS "SPB_VALIDATEDTD"(BYVAL xmldoc AS STRING, BYVAL xmldtd AS STRING) AS LONG

'Create an SPB_XMLToArray Function for Elements and Values (Pass Multi-Dimension Array Name,Value)
'This array should be zero-based meaning the first element name should be at 0,1 and the first value at 0,2
'Set decrypt=0 if you don not need to decrypt.
'Returns a 0 if an error, else the number of nodes in the array is returned.
DECLARE FUNCTION SPB_XMLToArray LIB "SACKSPB.DLL" ALIAS "SPB_XMLTOARRAY" (BYVAL xmldoc AS STRING, BYREF xmlArray() AS STRING, decrypt AS LONG, password AS STRING) AS LONG

'Create an SPB_ArrayToXML Function for Elements and Values (Pass Multi-Dimension Array Name,Value)
'Element name cannot begin with a number, if it does an A will be placed in front of it.  In addition,
'the element name cannot contain &,<,>,',%,/,= or " All of these characters will be removed from the name.
'This array should be zero-based meaning the first element name should be at 0,1 and the first value at 0,2
'Set encrypt=0 if you don not want to encrypt.  NOTE: the encryption is RC4 compatible.
DECLARE FUNCTION SPB_ArrayToXML LIB "SACKSPB.DLL" ALIAS "SPB_ARRAYTOXML" (BYREF xmlArray() AS STRING, rootName AS STRING, encrypt AS LONG, password AS STRING) AS STRING

'This is a general use function that will encrypt data using an RC4 compatible
'encryption algorithm and then hex encode.
DECLARE FUNCTION SPB_EncryptData LIB "SACKSPB.DLL" ALIAS "SPB_ENCRYPTDATA" (BYVAL strin AS STRING,password AS STRING) AS STRING

'This is a general use function that will decrypt data using an RC4 compatible
'encryption algorithm and then hex decode.
DECLARE FUNCTION SPB_DecryptData LIB "SACKSPB.DLL" ALIAS "SPB_DECRYPTDATA" (BYVAL strin AS STRING,password AS STRING) AS STRING

'This is a function for adding the xml version
'XMLDoc -> The existing document created with SPB_CreateXMLDocument
'ver -> Optional version number (default=1)
DECLARE FUNCTION SPB_SetXMLVersion LIB "SACKSPB.DLL" ALIAS "SPB_SETXMLVERSION" (BYVAL xmldoc AS STRING, OPTIONAL BYVAL ver AS LONG) AS STRING

'This is a function for creating an attribute string
'attributeName = What name would you like to give the attribute
'attributeValue = What value should the attribute have?
'priorAttribute = What was the full attribute string prior to adding this attribute?
DECLARE FUNCTION SPB_CreateXMLAttribute LIB "SACKSPB.DLL" ALIAS "SPB_CREATEXMLATTRIBUTE" (BYVAL attributeName AS STRING, BYVAL attributeValue AS STRING, BYVAL priorAttribute AS STRING) AS STRING

'This is a function for creating an xmldocument
'rootName -> what is the name of the first/root tag?
'attributes -> this would be attributes created using SPB_CreateXMLAttribute
'version -> You should likely always pass a string of "1"
DECLARE FUNCTION SPB_CreateXMLDocument LIB "SACKSPB.DLL" ALIAS "SPB_CREATEXMLDOCUMENT" (BYVAL rootName AS STRING, OPTIONAL attributes AS STRING, BYVAL version AS STRING) AS STRING

'This is a function for creating an element node other than root
'XMLDoc -> The existing document created with SPB_CreateXMLDocument
'elementName -> This is name you would like to give the lement
'attributes -> This is the attribute string that should be created with SPB_CreateXMLAttribute
'elementValue -> This is the actual value for the element if any
DECLARE FUNCTION SPB_CreateXMLFragment LIB "SACKSPB.DLL" ALIAS "SPB_CREATEXMLFRAGMENT" (BYVAL elementName AS STRING, BYVAL attributes AS STRING, BYVAL elementValue AS STRING) AS STRING

'This is a function for creating an element node other than root
'XMLDoc -> The existing document created with SPB_CreateXMLDocument
'elementName -> This is name you would like to give the lement
'attributes -> This is the attribute string that should be created with SPB_CreateXMLAttribute
'elementValue -> This is the actual value for the element if any
DECLARE FUNCTION SPB_CreateXMLElement LIB "SACKSPB.DLL" ALIAS "SPB_CREATEXMLELEMENT" (BYVAL XMLDoc AS STRING, BYVAL elementName AS STRING, BYVAL attributes AS STRING, BYVAL elementValue AS STRING) AS STRING

'This can be used to update an element value inside an xml document
'xmlDoc -> This is an xml string or an absolute path to an xml file
'elementName -> This is the name of the element we want to change the value for
'elementNewValue -> This is the new element value
'elementOldValue -> If we may have multiple of the same node we OPTIONALLY want to provide the old value unless we want to change ALL elements with the same name
'whiteSpace -> 0=remove whitespace 1=keep whitespace as is
DECLARE FUNCTION SPB_UpdateXMLElement LIB "SACKSPB.DLL" ALIAS "SPB_UPDATEXMLELEMENT" (BYVAL xmlDoc AS STRING, BYVAL elementName AS STRING, BYVAL elementNewValue AS STRING, BYVAL elementOldValue AS STRING, BYVAL whiteSpace AS LONG) AS STRING

'This can be used to update an attribute value given an element name
'xmlDoc -> This is an xml string or an absolute path to an xml file
'elementName -> This is the name of the element we want to change an attribute value for
'attributeName -> This is the name of the attribute we want to change
'attributeValue -> This is the new attribute value
'whiteSpace -> 0=remove whitespace 1=keep whitespace as is
DECLARE FUNCTION SPB_UpdateXMLAttribute LIB "SACKSPB.DLL" ALIAS "SPB_UPDATEXMLATTRIBUTE" (BYVAL xmlDoc AS STRING, BYVAL elementName AS STRING, BYVAL attributeName AS STRING, BYVAL attributeValue AS STRING, BYVAL whiteSpace AS LONG) AS STRING

'SPB_XpathCrLf allows the user to replace any CrLf with a token in the case that they want to use the Xpath functions
'and want to preserve any CrLf that may be in the source xml
'xmlin -> source XML as a string, NOT an absolute path
'whichWay -> pass 0 to replace CrLf with token, pass 1 to reverse
DECLARE FUNCTION SPB_XpathCrLf LIB "SACKSPB.DLL" ALIAS "SPB_XPATHCRLF" (BYVAL xmlin AS STRING, OPTIONAL BYVAL whichWay AS LONG) AS STRING

'This allows the user to create an element at a specific Xpath in the document
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The xpath query (NOTE: elements only here don't use @)
'elementName -> The name you want to give the element
'attributes -> This is consistent with the standard create attribute functions
'elementValue -> This is the value you want to give the new element
DECLARE FUNCTION SPB_XpathCreateXMLElement LIB "SACKSPB.DLL" ALIAS "SPB_XPATHCREATEXMLELEMENT" (BYVAL xmldoc AS STRING, BYVAL xpath AS STRING, BYVAL elementName AS STRING, BYVAL attributes AS STRING, BYVAL elementValue AS STRING, OPTIONAL BYVAL _
whitespace AS LONG) AS STRING

'SPB_XpathSetElementValue <- Will set ALL nodes with the same XPATH to a specific value
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The expath query (NOTE: elements only here don't use @)
'myValue -> The string that you would like to set the value to
DECLARE FUNCTION SPB_XpathSetElementValue LIB "SACKSPB.DLL" ALIAS "SPB_XPATHSETELEMENTVALUE" (BYVAL xmldoc AS STRING, xpath AS STRING, myValue AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS STRING

'SPB_XpathReplaceElementValue <- Will set a specific node with a specific XPATH from an old value to a new value
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The xpath query (NOTE: elements only here don't use @)
'oldValue -> The value that you want to change (*this node only)
'newValue -> The string that you would like to set the value to
DECLARE FUNCTION SPB_XpathReplaceElementValue LIB "SACKSPB.DLL" ALIAS "SPB_XPATHREPLACEELEMENTVALUE" (BYVAL xmldoc AS STRING, xpath AS STRING, BYVAL oldValue AS STRING, BYVAL newValue AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS STRING

'SPB_XpathSetAttributeValue <- Will set the value to all attributes that have the same name and xpath as the params
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The xpath query (NOTE: elements only here don't use @)
'attName -> The name of the attribute whose value you want to change
'attValue -> The new value
DECLARE FUNCTION SPB_XpathSetAttributeValue LIB "SACKSPB.DLL" ALIAS "SPB_XPATHSETATTRIBUTEVALUE" (BYVAL xmldoc AS STRING, xpath AS STRING, BYVAL attName AS STRING, BYVAL attValue AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS STRING

'SPB_XpathReplaceAttributeValue <- Will set the value to all attributes that have the same name, element value, and xpath as the params
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The xpath query (NOTE: elements only here don't use @)
'eleValue -> The value for an element <---- Used as a filter
'attName -> The name of the attribute whose value you want to change
'attValue -> The new value
DECLARE FUNCTION SPB_XpathReplaceAttributeValue LIB "SACKSPB.DLL" ALIAS "SPB_XPATHREPLACEATTRIBUTEVALUE" (BYVAL xmldoc AS STRING, xpath AS STRING, BYVAL eleValue AS STRING, BYVAL attName AS STRING, BYVAL attValue AS STRING, OPTIONAL BYVAL whitespace AS _
LONG ) AS STRING

'SPB_XpathGetElementValues will return element values only for a specified Xpath
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The expath query (NOTE: elements only here don't use @)
'myElements -> Single string array that will hold the element values
DECLARE FUNCTION SPB_XpathGetElementValues LIB "SACKSPB.DLL" ALIAS "SPB_XPATHGETELEMENTVALUES" (BYVAL xmlDoc AS STRING, xpath AS STRING, BYREF myElements() AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS LONG

'SPB_XpathSplit <- This will split an XML document into smaller XML documents matching a specified xpath
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The expath query (NOTE: elements only here don't use @)
'myNodes -> Single string array that will hold the nodes as a full XML string
DECLARE FUNCTION SPB_XpathSplit LIB "SACKSPB.DLL" ALIAS "SPB_XPATHSPLIT" (BYVAL xmldoc AS STRING, xpath AS STRING, BYREF myNodes() AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS LONG

'SPB_XpathGetFullNodeValues will return element values only for a specified Xpath
'xmldoc -> An absolute path to the XML OR an XML string
'xpath -> The expath query (NOTE: elements only here don't use @)
'myElements -> Multi-Dimension string array that will hold the element values & all attribute values 1,1=element 1,2=attributes
DECLARE FUNCTION SPB_XpathGetFullNodeValues LIB "SACKSPB.DLL" ALIAS "SPB_XPATHGETFULLNODEVALUES" (BYVAL xmlDoc AS STRING, xpath AS STRING, BYREF myElements() AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS LONG

'SPB_XpathList
'xmldoc -> An absolute path to the XML OR an XML string
'myPaths -> Single dimension string array that will contain the unique Xpaths for the given XML
DECLARE FUNCTION SPB_XpathList LIB "SACKSPB.DLL" ALIAS "SPB_XPATHLIST" (BYVAL xmldoc AS STRING, BYREF myPaths() AS STRING, OPTIONAL BYVAL whitespace AS LONG ) AS LONG

'Helper function to return the current application path with a trailing "\"
DECLARE FUNCTION SPB_AppPath LIB "SACKSPB.DLL" ALIAS "SPB_APPPATH"() AS STRING

'Check for the existence of a file or dir, etc. returns a 1 if it is a file <- Deprecated see SPB_IsFile below
DECLARE FUNCTION SPB_IsDir LIB "SACKSPB.DLL" ALIAS "SPB_ISDIR"(sObj AS STRING) AS DWORD

'Use this to Base64 Encode any string
DECLARE FUNCTION SPB_Base64Encode LIB "SACKSPB.DLL" ALIAS "SPB_BASE64ENCODE"(BYVAL strin AS STRING) AS STRING

'Use this to Base64 Decode any string
DECLARE FUNCTION SPB_Base64Decode LIB "SACKSPB.DLL" ALIAS "SPB_BASE64DECODE"(BYVAL strin AS STRING) AS STRING

'Use this to see if a file exists returns %TRUE if it does, else %FALSE
DECLARE FUNCTION SPB_IsFile LIB "SACKSPB.DLL" ALIAS "SPB_ISFILE"(BYVAL sFileName AS STRING) AS DWORD

'Image handling functions -> See the static lib help files
DECLARE FUNCTION SPB_Icon2String LIB "SACKSPB.DLL" ALIAS "SPB_ICON2STRING"(BYVAL iconData AS STRING) AS STRING
DECLARE FUNCTION SPB_String2Icon LIB "SACKSPB.DLL" ALIAS "SPB_STRING2ICON"(BYVAL iconData AS STRING) AS LONG
DECLARE FUNCTION SPB_DestroyIcon LIB "SACKSPB.DLL" ALIAS "SPB_DESTROYICON"(BYVAL hIcon AS LONG) AS LONG
DECLARE FUNCTION SPB_Bitmap2String LIB "SACKSPB.DLL" ALIAS "SPB_BITMAP2STRING"(BYVAL bmpData AS STRING) AS STRING
DECLARE FUNCTION SPB_String2Bitmap LIB "SACKSPB.DLL" ALIAS "SPB_STRING2BITMAP"(BYVAL bmpData AS STRING) AS LONG
DECLARE FUNCTION SPB_DestroyBitmap LIB "SACKSPB.DLL" ALIAS "SPB_DESTROYBITMAP"(BYVAL hbmp AS LONG) AS LONG

'myAgent - String containing the agent name for HTTP_USER_AGENT:
'myDomain - String containing the domain (secure.smartbusiness.net)
'myPath - String containing the path to the cgi, asp, etc. (/testvar.asp)
'isSecure - 0 for HTTP, 1 or nonzero for HTTPS
'myData - myData - The data to post -> This can be, but is not limited to XML (note there is a limit of 2048 characters with this GET implementation)
'retryTimes - Number of times to retry if the library cannot be constructed
'retryInterval - How long to wait between retries
'myTimeout - The timeout that you would like in seconds
'myPort - This is the port that you can optionally specify otherwise the default will be used for HTTP or HTTPS
DECLARE FUNCTION SPB_GetXML LIB "SACKSPB.DLL" ALIAS "SPB_GETXML" (BYVAL myAgent AS STRING, BYVAL myDomain AS STRING, BYVAL myPath AS STRING, BYVAL isSecure AS LONG, BYVAL myData AS STRING, BYVAL retryTimes AS LONG, BYVAL retryInterval AS LONG, _
OPTIONAL BYVAL myTimeout AS LONG, OPTIONAL BYVAL myPort AS LONG ) AS STRING

'myAgent - String containing the agent name for HTTP_USER_AGENT:
'myDomain - String containing the domain (secure.smartbusiness.net)
'myPath - String containing the path to the cgi, asp, etc. (/testvar.asp)
'isSecure - 0 for HTTP, 1 or nonzero for HTTPS
'myHeaders a $CRLF delimited list of headers as a String
'myData - The data to post -> This can be, but is not limited to XML
'retryTimes - Number of times to retry if the library cannot be constructed
'retryInterval - How long to wait between retries
'myTimeout - The timeout that you would like in seconds
'myPort - This is the port that you can optionally specify otherwise the default will be used for HTTP or HTTPS
DECLARE FUNCTION SPB_PostXML LIB "SACKSPB.DLL" ALIAS "SPB_POSTXML" (BYVAL myAgent AS STRING, BYVAL myDomain AS STRING, BYVAL myPath AS STRING, BYVAL isSecure AS LONG, BYVAL myHeaders AS STRING, BYVAL myData AS STRING, BYVAL retryTimes AS LONG, _
BYVAL retryInterval AS LONG, OPTIONAL BYVAL myTimeout AS LONG, OPTIONAL BYVAL myPort AS LONG ) AS STRING

'SPB_SetADOXData
'Use this funciton to execute any UPDATE, DELETE, INSERT, DROP, CREATE, etc. SQL Statements
'Conn -> A valid DSN connection string
'sql -> The sql query to execute
DECLARE FUNCTION SPB_SetADOXData LIB "SACKSPB.DLL" ALIAS "SPB_SETADOXDATA" (BYVAL conn AS STRING, BYVAL sql AS STRING) AS LONG

'SPB_GetADOXData
'Use this funciton to return an XML representation of any SELECT recordset
'Conn -> A valid DSN connection string
'sql -> The sql query
'XML Schema:
'    <Data>
'        <Row id="1">
'            <Column id="1"><![CDATA[Value]]></Column>
'            <Column id="2"><![CDATA[Value]]></Column>
'            <Column id="3"><![CDATA[Value]]></Column>
'        </Row>
'    </Data>
'NOTE:  To ensure that you get the columns that you want every time in the order you
'want them, you should explicity specify the columns in your SQL query and avoid the
'use of *.  So... SELECT * FROM TABLE should be avoided.
DECLARE FUNCTION SPB_GetADOXData LIB "SACKSPB.DLL" ALIAS "SPB_GETADOXDATA" (BYVAL conn AS STRING, BYVAL sql AS STRING) AS STRING

'SPB_CGIInit and SPB_CGIDestroy
'Use these functions to open up the STDIN/STDOUT required for the rest of the CGI functions to work
DECLARE SUB SPB_CGIInit LIB "SACKSPB.DLL" ALIAS "SPB_CGIINIT" ()
DECLARE SUB SPB_CGIDestroy LIB "SACKSPB.DLL" ALIAS "SPB_CGIDESTROY" ()

'SPB_CGIXMLWrite
'Use this function to write some XML/HTML back to a CGI user
'sText -> The data to return to the user
DECLARE SUB SPB_CGIXMLWrite LIB "SACKSPB.DLL" ALIAS "SPB_CGIXMLWRITE" ( BYVAL sText AS STRING )

'SPB_CGIXMLRead
'Use this to read data from a RAW POST only.  NOTE: Do not try to perform a GET on this.  YOU MUST USE POST!
DECLARE FUNCTION SPB_CGIXMLRead LIB "SACKSPB.DLL" ALIAS "SPB_CGIXMLREAD" () AS STRING

'SPB_CGISendFileStr
'Use this to send a file back to the user
'sFile -> This is the file loaded back as a string
'sUserFileName -> This is the filename you want the user to see
'sContentType -> This is optional set it to "" if you want application/octet-stream
'sEncodeing -> This is optional set it to "" if you want BINARY
DECLARE FUNCTION SPB_CGISendFileStr LIB "SACKSPB.DLL" ALIAS "SPB_CGISENDFILESTR" ( BYVAL sFile AS STRING, BYVAL sUserFileName AS STRING, BYVAL sContentType AS STRING, BYVAL sEncoding AS STRING ) AS LONG

'SPB_XpathToDelim
'Use this to return a column/row delimited string from an XPath
'xmldoc - xmlstring or abs path to xml
'xpath - the xpath query
'colDelim - the delimiter to use between columns/fields
'rowDelim - the delimiter to use between rows (usually $CRLF)
'ignoreBase - use 1 if you want to ignore the base xpath (exact match)
'eleNameHeader - use the element names to create a header row
'quoteChar - if you need a quote character around every value "val1","val2"
'whitespace - Specify 0 to remove whitespace, non-zero to keep whitespace
DECLARE FUNCTION SPB_XpathToDelim LIB "SACKSPB.DLL" ALIAS "SPB_XPATHTODELIM" (BYVAL xmldoc AS STRING, BYVAL xpath AS STRING, BYVAL colDelim AS STRING, BYVAL rowDelim AS STRING, _
                BYVAL ignoreBase AS LONG, BYVAL eleNameHeader AS LONG, BYVAL quoteChar AS STRING, OPTIONAL BYVAL whitespace AS LONG) AS STRING

'SPB_URLEncode
'Use this when you need the content you are posting to comply with application/x-www-form-urlencoded
DECLARE FUNCTION SPB_URLEncode LIB "SACKSPB.DLL" ALIAS "SPB_URLENCODE" ( BYVAL sToEscape AS STRING ) AS STRING
'The counterpart to SPB_URLEncode
DECLARE FUNCTION SPB_URLDecode LIB "SACKSPB.DLL" ALIAS "SPB_URLDECODE" ( url AS STRING) AS STRING

'Walk an XML document using the XPATH parser
'xmldoc - xmlstring or abs path to xml
'cbfunction - codeptr to a callback function
'whitespace - Specify 0 to remove whitespace, non-zero to keep whitespace
'Example callback:
'Function ParseNode(ByVal elementName As String, ByVal elementValue As String, ByRef attributes() As ATTRIBUTENODE, ByVal xpath As String) As Long
'    On Error GoTo errtrap:
'    'Get information from the node or "Tag" as we are calling it here.
'    Local msg As String
'    Local x As Long
'    If UBound(attributes())>0 Then
'        msg = "Number of attributes: " &  Format$(UBound(attributes())) & $CrLf
'        For x = 1 To UBound(attributes())
'            msg = msg & "Attribute " & Format$(x) & ": " & SPB_GetParsePtr(attributes(1).AttributeName.pString) & _
'                  " = " & SPB_GetParsePtr(attributes(1).AttributeValue.pString) & $CrLf
'        Next x
'    Else
'        msg = "Number of attributes: 0" & $CrLf
'    End If
'    msg = msg & "Element name: " & elementName & $CrLf
'    msg = msg & "Element value: " & elementValue & $CrLf
'    msg = msg & "Xpath: " & xpath
'    MsgBox msg,%MB_TASKMODAL,"Node Information"
'    Function=1
'    Exit Function
'errtrap:
'    Function=0
'    Exit Function
'End Function
DECLARE FUNCTION SPB_XpathWalk LIB "SACKSPB.DLL" ALIAS "SPB_XPATHWALK" (BYVAL xmldoc AS STRING, BYVAL cbfunction AS LONG, OPTIONAL BYVAL whitespace AS LONG) AS LONG
