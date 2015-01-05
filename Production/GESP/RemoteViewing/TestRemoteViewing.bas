#COMPILE EXE
#DIM ALL

%MAX_TARGETS = 20
GLOBAL rndTargets() AS STRING
GLOBAL categories() AS STRING
GLOBAL target AS LONG

FUNCTION PBMAIN () AS LONG
    LOCAL x AS LONG

    RANDOMIZE TIMER

    FOR x = 1 TO 25
        #DEBUG PRINT " "
        #DEBUG PRINT "Trial " + STR$(x) + ": "
        target = pickTargets()
        #DEBUG PRINT " "
        #DEBUG PRINT "Target : " + rndTargets(target)
    NEXT x

END FUNCTION

FUNCTION pickTargets() AS LONG
    LOCAL x AS LONG
    LOCAL imageName AS STRING

    REDIM rndTargets(5)
    REDIM categories(5)


    categories(1) = "animals" : categories(2) = "architecture" : categories(3) = "scenery" : categories(4) = "transportation" : categories(5) = "plants"
    FOR x = 1 TO 5
        rndTargets(x) = "images/" + categories(x) + "/image-" + FORMAT$(RND(1, %MAX_TARGETS), "000") + ".bmp"
        #DEBUG PRINT rndTargets(x)
    NEXT x

    FUNCTION = RND(1,5)

END FUNCTION
