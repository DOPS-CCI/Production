' *********************************************************************************************
'The following are all written by Jose' Roca
' *********************************************************************************************
' ATLAPI_(BOOL) AtlAxWinInit( );
' This function initializes ATL's control hosting code by registering the "AtlAxWin7" and
' "AtlAxWinLic7" window classes plus a couple of custom window messages.
' Return Value: TRUE, if the initialization of the control hosting code was successful; otherwise FALSE.
' Remarks: This function must be called before using the ATL control hosting API. Following a
' call to this function, the "AtlAxWin" window class can be used in calls to CreateWindow or
' CreateWindowEx, as described in the Platform SDK.
' *********************************************************************************************
  DECLARE FUNCTION AtlAxWinInit LIB "ATL.DLL" ALIAS "AtlAxWinInit" () AS LONG
' *********************************************************************************************

' *********************************************************************************************
' inline BOOL AtlAxWinTerm( );
' This function uninitializes ATL's control hosting code by unregistering the "AtlAxWin7" and
' "AtlAxWinLic7" window classes.
' This function simply calls UnregisterClass as described in the Platform SDK.
' Call this function to clean up after all existing host windows have been destroyed if you
' called AtlAxWinInit and you no longer need to create host windows. If you don't call this
' function, the window class will be unregistered automatically when the process terminates.
' Return Value: If the function succeeds, the return value is nonzero.
' *********************************************************************************************
  DECLARE FUNCTION AtlAxWinTerm () AS LONG
' *********************************************************************************************
  FUNCTION AtlAxWinTerm () AS LONG
	  UnregisterClass ("AtlAxWin", GetModuleHandle(BYVAL %NULL))
  END FUNCTION
' *********************************************************************************************

' *********************************************************************************************
' ATLAPI AtlAxGetControl (HWND h, IUNKNOWN** pp);
' Obtains a direct interface pointer to the control contained inside a specified window given its handle.
' **********************************************************************************************
  DECLARE FUNCTION AtlAxGetControl LIB "ATL.DLL" ALIAS "AtlAxGetControl" _
		(_
		BYVAL hWnd AS DWORD, _   ' [in] A handle to the window that is hosting the control.
		BYREF pp AS DWORD _      ' [out] The IUnknown of the control being hosted.
) AS DWORD
' *********************************************************************************************
' *********************************************************************************************
' Puts the address of an object in a variant and marks it as containing a dispatch variable
' *********************************************************************************************
  SUB AtlMakeDispatch (_
		BYVAL lpObj AS DWORD, _                        ' Address of the object instance
		BYREF vObj AS VARIANT _                        ' Variant to contain this address
	) EXPORT

		LOCAL lpvObj AS VARIANTAPI PTR                 ' Pointer to a VARIANTAPI structure
		LET vObj = EMPTY                               ' Make sure is empty to avoid memory leaks
		lpvObj = VARPTR(vObj)                          ' Get the VARIANT address
		@lpvObj.vt = %VT_DISPATCH                      ' Mark it as containing a dispatch variable
		@lpvObj.vd.pdispVal = lpObj                    ' Set the dispatch pointer address

  END SUB
' *********************************************************************************************

' *********************************************************************************************
' Converts a Windows error code in a message string
' *********************************************************************************************
  FUNCTION WinErrorMsg (BYVAL dwError AS DWORD) AS STRING

		LOCAL pBuffer AS ASCIIZ PTR
		LOCAL ncbBuffer AS DWORD
		LOCAL sText AS STRING

		ncbBuffer = FormatMessage(%FORMAT_MESSAGE_ALLOCATE_BUFFER _
							 OR %FORMAT_MESSAGE_FROM_SYSTEM OR %FORMAT_MESSAGE_IGNORE_INSERTS, _
							 BYVAL %NULL, dwError, BYVAL MAKELANGID(%LANG_NEUTRAL, %SUBLANG_DEFAULT), _
							 BYVAL VARPTR(pBuffer), 0, BYVAL %NULL)

		IF ncbBuffer THEN
				sText = PEEK$(pBuffer, ncbBuffer)
				sText = REMOVE$ (sText, ANY CHR$(13) + CHR$(10))
				LocalFree pBuffer
		ELSE
				sText = "Unknmown error - Code " + HEX$(dwError, 8)
		END IF

		FUNCTION = sText

  END FUNCTION
' *********************************************************************************************



'*********************************************************************************************
' Small class to encapsulate some of the ATL/OCX work (by F.A.A.)
'*********************************************************************************************
CLASS LoadOCX
	 INSTANCE iOCXName AS STRING

	 INTERFACE ILoadOCX
		  INHERIT IDISPATCH

	 METHOD initializeATLForOCX(BYVAL value AS STRING)
		 iOCXName = value
		 AtlAxWinInit
	 END METHOD
	 
	 method TerminateATLForOCX()
			AtlAxWinTerm  
	 END METHOD

	 METHOD getOCXName() AS STRING
		  METHOD = iOCXName
	 END METHOD

	 METHOD getOCX(BYVAL hDlg AS DWORD, BYVAL ID AS LONG) AS DISPATCH
		  LOCAL vOCX AS VARIANT
		  LOCAL hOcx AS DWORD
		  LOCAL pUnk AS DWORD
		  LOCAL vVar AS VARIANT
		  CONTROL HANDLE hDlg, ID TO hOcx
		  AtlAxGetControl(hOcx, pUnk)
		  AtlMakeDispatch(pUnk, vVar)
		  METHOD = vVar
	 END METHOD

	 END INTERFACE ' ILoadOCX
END CLASS ' LoadOCX
