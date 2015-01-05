#COMPILE EXE
#DIM ALL

'#INCLUDE "DOPS_ExptClass.inc"

TYPE Test
    UDTPtr AS DWORD
END TYPE

CLASS GVS
    INSTANCE Desc AS STRING
    INSTANCE Value AS INTEGER

    INTERFACE GVsInterface
        INHERIT IUNKNOWN

        PROPERTY GET Desc() AS STRING
            PROPERTY = Desc
        END PROPERTY
        PROPERTY SET Desc(str  AS STRING)
            Desc = str
        END PROPERTY
        PROPERTY GET Value() AS LONG
            PROPERTY = Value
        END PROPERTY
        PROPERTY SET Value(num AS LONG)
            Value = num
        END PROPERTY
    END INTERFACE
END CLASS

CLASS GroupVars
    INSTANCE Condition AS ASCIIZ * 255
    INSTANCE Desc AS ASCIIZ * 255
    INSTANCE NbrOfGVsObj AS LONG
    INSTANCE GVsObj() AS GVsInterface

    CLASS METHOD CREATE()
    END METHOD

    INTERFACE GroupVarsInterface
        INHERIT IUNKNOWN


        PROPERTY GET Condition() AS STRING
            PROPERTY = Condition
        END PROPERTY
        PROPERTY SET Condition(str  AS STRING)
            Condition = str
        END PROPERTY
        PROPERTY GET Desc() AS STRING
            PROPERTY = Condition
        END PROPERTY
        PROPERTY SET Desc(str  AS STRING)
            Desc = str
        END PROPERTY
        PROPERTY GET NbrOfGVsObj() AS LONG
            PROPERTY = NbrOfGVsObj
        END PROPERTY
        PROPERTY SET NbrOfGVsObj(num  AS LONG)
            NbrOfGVsObj = num
        END PROPERTY
        METHOD CreateGVsObj()
            LOCAL x AS LONG
            FOR x = 1 TO NbrOfGVsObj
                LET GVsObj(x) = CLASS "GVsInterface"
            NEXT x
        END METHOD
        METHOD SetGVsObj(idx AS LONG, obj AS GVsInterface)
            GVsObj(idx) = obj
        END METHOD
    END INTERFACE
END CLASS

CLASS ExperimentEvents
    INSTANCE EvtName AS STRING
    INSTANCE EvtType AS STRING
    INSTANCE Desc AS STRING
    INSTANCE Channel AS STRING
    INSTANCE Edge AS STRING
    INSTANCE Location AS STRING
    INSTANCE EvtMin AS LONG
    INSTANCE EvtMax AS LONG
    INSTANCE NbrOfGroupVarsObj AS LONG
    INSTANCE GroupVarsObj() AS GroupVarsInterface

    CLASS METHOD CREATE()
    END METHOD

    INTERFACE ExperimentEventsInterface
        INHERIT IUNKNOWN


        PROPERTY GET EvtName() AS STRING
            PROPERTY = EvtName
        END PROPERTY
        PROPERTY SET EvtName(str  AS STRING)
            EvtName = str
        END PROPERTY
        PROPERTY GET NbrOfGroupVarsObj() AS LONG
            PROPERTY = NbrOfGroupVarsObj
        END PROPERTY
        PROPERTY SET NbrOfGroupVarsObj(num  AS LONG)
            NbrOfGroupVarsObj = num
        END PROPERTY
        METHOD CreateGroupVarsObj()
            LOCAL x AS LONG
            FOR x = 1 TO NbrOfGroupVarsObj
                LET GroupVarsObj(x) = CLASS "GroupVarsInterface"
            NEXT x
        END METHOD
        METHOD SetGroupVarsObj(idx AS LONG, obj AS GroupVarsInterface)
            GroupVarsObj(idx) = obj
        END METHOD

    END INTERFACE
END CLASS

FUNCTION PBMAIN () AS LONG
    LOCAL x, cnt, idx AS LONG
    LOCAL ptr1 AS DWORD PTR
    LOCAL temp AS WSTRING
    LOCAL tempType AS STRING
    LOCAL variantTemp AS VARIANT
    LOCAL testUDT AS Test
    LOCAL MyEvents() AS ExperimentEventsInterface
    LOCAL MyGroupVars AS GroupVarsInterface
    LOCAL MyGVs AS GVsInterface
    LOCAL Collect, tempCollect AS IPOWERCOLLECTION

    LET MyGVs = CLASS "GVsInterface"

    LET MyGroupVars = CLASS "GroupVarsInterface"

    REDIM MyEvents(10)

    LET MyEvents(1) = CLASS "ExperimentEvents"

    MyEvents(1).EvtName = "TargetSelected"
    MyEvents(1).NbrOfGroupVarsObj = 2
    myEvents(1).CreateGroupVarsObj()
    MyGroupVars.Condition = "SUITS"
    MyGroupVars.Desc = "These are the suits of a playing card deck."
    MyGroupVars.NbrOfGVsObj = 4
    MyGroupVars.CreateGVsObj()
    MyGroupVars.NbrOfGVsObj = 4
    MyGroupVars.CreateGVsObj()
    MyGVs.Desc = "HEARTS"
    MyGVs.Value = 1
    MyGroupVars.SetGVsObj(1, MyGVs)
    MyEvents(1).SetGroupVarsObj(1, MyGroupVars)

'    myEvents(1).SetGroupVarsObj(1, MyGroupVars)
'    myEvents(1).CreateGroupVarsObj()
'    MyGroupVars.Condition = "HITMISS"
'    MyGroupVars.Desc = "These are the hits and misses in an experiment."
'    MyGroupVars.GVs.Clear()
'    MyGroupVars.GVs.Add("HIT", 1)
'    MyGroupVars.GVs.Add("MISS", 2)
'    myEvents(1).SetGroupVarsObj(2, MyGroupVars)



'    LET Collect = CLASS "PowerCollection"
'    LET tempCollect = CLASS "PowerCollection"

'    Collect.Add("A", "Apple")
'    Collect.Add("B", "Banana")
'
'    LET variantTemp = Collect
'
'    MSGBOX STR$(testUDT.UDTPtr)
'
'    testUDT.UDTPtr = VARPTR(Collect)
'
'    MSGBOX STR$(testUDT.UDTPtr)
'
    'ptr1 = testUDT.UDTPtr

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
