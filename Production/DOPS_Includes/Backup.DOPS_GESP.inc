TYPE GridLayout
    Position AS INTEGER
    UpperLeftX AS INTEGER
    UpperLeftY AS INTEGER
    LowerRightX AS INTEGER
    LowerRightY AS INTEGER
END TYPE

GLOBAL Grid() AS GridLayout

SUB InitializeGrid(nbrOfRows AS INTEGER, nbrOfCols AS INTEGER, upperLeftX AS INTEGER, upperLeftY AS INTEGER, lowerRightX AS INTEGER, lowerRightY AS INTEGER)
    LOCAL lRow, lCol, cnt AS LONG
    LOCAL tUpperLeftX, tUpperLeftY, tLowerRightX, tLowerRightY AS LONG
    REDIM Grid(nbrOfRows * nbrOfCols)

    cnt = 0
    tUpperLeftX = -1 * lowerRightX
    tUpperLeftY = 0
    tLowerRightX = 0
    tLowerRightY = lowerRightY
    FOR lRow = 1 TO nbrOfRows
        FOR lCol = 1 TO nbrOfCols
            INCR cnt
            tUpperLeftX = tUpperLeftX + lowerRightX
            tLowerRightX = tLowerRightX + lowerRightX
            Grid(cnt).Position = cnt
            Grid(cnt).UpperLeftX = tUpperLeftX
            Grid(cnt).UpperLeftY = tUpperLeftY
            Grid(cnt).LowerRightX = tLowerRightX
            Grid(cnt).LowerRightY = tLowerRightY
            '#DEBUG PRINT STR$(Grid(cnt).Position)
            '#DEBUG PRINT STR$(Grid(cnt).UpperLeftX)+ ", " + STR$(Grid(cnt).UpperLeftY)
            '#DEBUG PRINT STR$(Grid(cnt).LowerRightX) + ", " + STR$(Grid(cnt).LowerRightY)
        NEXT lCol
        tUpperLeftX = -1 * lowerRightX
        tLowerRightX = 0
        tUpperLeftY = tUpperLeftY + lowerRightY
        tLowerRightY = tLowerRightY + lowerRightY
    NEXT lRow
END SUB

FUNCTION FindSubjectResponseInGrid(lParam AS DWORD) AS INTEGER
    LOCAL l, xStart, yStart, xMouse, yMouse AS LONG
    LOCAL xTempMin, xTempMax, yTempMin, yTempMax, found, arrayCnt AS LONG


    CONTROL GET LOC globals.hdl.DlgSubject, %ID_GRID TO xStart, yStart

    #DEBUG PRINT "LOC: " + STR$(xStart) + ", " + STR$(yStart)

    xMouse = LO(WORD, lParam) - xStart
    yMouse = HI(WORD, lParam) - yStart
    #DEBUG PRINT "Mouse: " + STR$(xMouse) + ", " + STR$(yMouse)

    arrayCnt = 0
    found = 0
    FOR l = 1 TO EXPERIMENT.Misc.NbrOfTargets
        INCR arrayCnt
        #DEBUG PRINT STR$(Grid(l).Position) + ": " + STR$(Grid(l).UpperLeftX) + ", " + STR$(Grid(l).LowerRightX)
        #DEBUG PRINT STR$(Grid(l).Position) + ": " +STR$(Grid(l).UpperLeftY) + ", " + STR$(Grid(l).LowerRightY)

        IF ((xMouse >= Grid(l).UpperLeftX)  AND (xMouse <= Grid(l).LowerRightX)) THEN
            IF ((yMouse >= Grid(l).UpperLeftY) AND (yMouse <= Grid(l).LowerRightY)) THEN
                arrayCnt = l
                #DEBUG PRINT STR$(Grid(l).Position) + " response: " +STR$(Grid(l).UpperLeftY) + ", " + STR$(Grid(l).LowerRightY)
                #DEBUG PRINT "arrayCnt: " +STR$(l)
                found = 1
            END IF
        END IF
        IF (found = 1) THEN
            EXIT FOR
        END IF
    NEXT l

    IF (found = 1) THEN
        FUNCTION = arrayCnt
    ELSE
        FUNCTION = -1
    END IF
END FUNCTION

SUB Feedback(targ_resp AS LONG, targScrn_respScrn AS DWORD)
    LOCAL l, m, xMax, ymax, xStart, yStart, xMouse, yMouse AS LONG
    LOCAL xTempMin, xTempMax, yTempMin, yTempMax, found, arrayCnt AS LONG
    LOCAL targetStr, targ AS STRING

    CONTROL GET LOC targScrn_respScrn, %ID_GRID TO xStart, yStart
    CONTROL GET CLIENT targScrn_respScrn, %ID_GRID TO xMax, yMax

    '#DEBUG PRINT "Feedback"
    '#DEBUG PRINT "LOC: " + STR$(xStart) + ", " + STR$(yStart)
    '#DEBUG PRINT "CLIENT: " + STR$(xMax) + ", " + STR$(yMax)

    FOR l = 1 TO EXPERIMENT.Misc.NbrOfTargets
        '#DEBUG PRINT ColorCards(l).CardName + ": " + STR$(ColorCards(l).UpperLeftX) + ", " + STR$(ColorCards(l).LowerRightX)
        '#DEBUG PRINT ColorCards(l).CardName + ": " +STR$(ColorCards(l).UpperLeftY) + ", " + STR$(ColorCards(l).LowerRightY)

        IF (targ_resp = l) THEN
             CONTROL SET LOC targScrn_respScrn, %ID_HIGHLIGHT, Grid(l).UpperLeftX + xStart, Grid(l).UpperLeftY + yStart
             CONTROL SHOW STATE targScrn_respScrn, %ID_HIGHLIGHT, %SW_SHOW
             #DEBUG PRINT STR$(Grid(l).Position) + " feedback: " +STR$(Grid(l).UpperLeftY) + ", " + STR$(Grid(l).LowerRightY)
             #DEBUG PRINT "l: " +STR$(l)
             EXIT FOR
        END IF
    NEXT l

    CONTROL REDRAW targScrn_respScrn, %ID_GRID
    CONTROL REDRAW targScrn_respScrn, %ID_HIGHLIGHT
END SUB

FUNCTION getRow(x AS LONG, cols AS INTEGER) AS LONG
    LOCAL divisor, temp  AS LONG
    LOCAL remainder AS DOUBLE

    divisor = INT(x / cols)
    remainder = x / cols
    IF (divisor - remainder = 0) THEN
       temp = divisor
    ELSE
       temp = divisor + 1
    END IF

    FUNCTION = temp
END FUNCTION

FUNCTION getColumn(x AS LONG, cols AS INTEGER) AS LONG
    LOCAL temp  AS LONG

    temp = x MOD cols
    IF (temp = 0) THEN
        temp = cols
    END IF

    FUNCTION = temp
END FUNCTION
