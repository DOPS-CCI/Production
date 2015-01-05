#COMPILE EXE
#DIM ALL

'#INCLUDE "DOPS_ExptClass.inc"

TYPE Test
    UDTPtr AS DWORD
END TYPE

MACRO  CObj(pUnk, dwAddr)                   ' Used to convert an address to an object.  This could
  POKE DWORD, VARPTR(pUnk), dwAddr          ' be a new feature suggestion!
  pUnk.AddRef()
END MACRO

FUNCTION PBMAIN () AS LONG
    LOCAL x, cnt, idx AS LONG
    LOCAL ptr1 AS DWORD PTR
    LOCAL temp AS WSTRING
    LOCAL tempType AS STRING
    LOCAL variantTemp AS VARIANT
    LOCAL testUDT AS Test
    LOCAL Collect, tempCollect AS IPOWERCOLLECTION



    LET Collect = CLASS "PowerCollection"
    LET tempCollect = CLASS "PowerCollection"

    Collect.Add("A", "Apple")
    Collect.Add("B", "Banana")

    testUDT.UDTPtr = VARPTR(Collect)

    MSGBOX STR$(testUDT.UDTPtr)

    tempCollect = CObj(Collect, testUDT.UDTPtr)

    'tempCollect = objptr(ptr1)
    'ptr1 = peek(dword, testUDT.UDTPtr)

    'ptr1 = testUDT.UDTPtr


'    let variantTemp = variant$(testUDT.UDTPtr)
'
'    tempCollect = variantTemp
'    tempType = variant$(tempCollect.Item("A"))
'    msgbox tempType

    'let tempCollect = class "PowerCollection"

    'tempCollect = testUDT.UDTPtr





END FUNCTION
