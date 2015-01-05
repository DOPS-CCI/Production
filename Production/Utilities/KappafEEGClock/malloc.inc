' MALLOC.INC
' Generic Memory Alloction/ReAllocation/Free Routines for use with PB Programs.
' CREATED: 11/09/02
' 11/24/02 Added #INCLUDE file control %MALLOC_INC
' Placed in Public Domain by author, Michael C. Mattias Racine WI USA
' 3.17.04 Changed Free flags to drop NO_SERIALIZE, which should not be used on process heap

#IF NOT %DEF(%MALLOC_INC)
  %MALLOC_INC = 1

#IF NOT %DEF(%WINAPI)
  DECLARE FUNCTION GetProcessHeap LIB "KERNEL32.DLL" ALIAS "GetProcessHeap" () AS LONG
  DECLARE FUNCTION HeapAlloc LIB "KERNEL32.DLL" ALIAS "HeapAlloc" (BYVAL hHeap AS DWORD, BYVAL dwFlags AS DWORD, BYVAL dwBytes AS DWORD) AS DWORD
  DECLARE FUNCTION HeapFree LIB "KERNEL32.DLL" ALIAS "HeapFree" (BYVAL hHeap AS DWORD, BYVAL dwFlags AS DWORD, BYVAL lpMem AS DWORD) AS LONG
  DECLARE FUNCTION HeapReAlloc LIB "KERNEL32.DLL" ALIAS "HeapReAlloc" (BYVAL hHeap AS DWORD, BYVAL dwFlags AS DWORD, BYVAL lpMem AS DWORD, BYVAL dwBytes AS DWORD) AS DWORD
  %HEAP_NO_SERIALIZE             = &H00000001
  %HEAP_GENERATE_EXCEPTIONS      = &H00000004
  %HEAP_ZERO_MEMORY              = &H00000008
#ENDIF

#IF NOT %DEF(%HEAP_ALLOC_FLAGS)
' See MSDN for options for flags.
%HEAP_ALLOC_FLAGS    = %HEAP_ZERO_MEMORY OR %HEAP_GENERATE_EXCEPTIONS
%HEAP_FREE_FLAGS     = 0&
#ENDIF

FUNCTION malloc  (BYVAL NumberOfBytes AS LONG) AS DWORD
  ' returns: address of block of size NumberOfBytes
   FUNCTION = HeapAlloc (GetProcessHeap(), %HEAP_ALLOC_FLAGS, NumberOfBytes)
END FUNCTION

FUNCTION realloc (BYVAL currentaddress AS DWORD, BYVAL NewSize AS LONG) AS DWORD
' returns: new address for block at current address after resized to newsize
' do I have to save what was there? I do not think so...nope, the original contents
' of the memory block are unaffected by HeapRealloc, pass or fail.
    FUNCTION = HeapRealloc(GetProcessHeap(), %HEAP_ALLOC_FLAGS, Currentaddress, newSize)
END FUNCTION

FUNCTION FREE (BYVAL BlockAddress AS DWORD) AS DWORD
  'returns: null on failure (probably was passed an invalid pointer)
  FUNCTION = HeapFree (getProcessHeap(), %HEAP_FREE_FLAGS, blockAddress)
END FUNCTION

#ENDIF
 'if %DEF %MALLOC_INC
' ** END OF FILE ***
