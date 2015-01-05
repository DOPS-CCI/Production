#COMPILE EXE
#DIM ALL

FUNCTION PBMAIN () AS LONG

  LOCAL MyTime AS IPOWERTIME
  LET MyTime = CLASS "PowerTime"
  LOCAL now AS QUAD

  MyTime.Now()
  MyTime.FileTime TO now
  #DEBUG PRINT FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))

  MyTime.NewDate(2010, 12, 29)
  mYTime.NewTime(14,05,00)
  MyTime.FileTime TO now
  #DEBUG PRINT FORMAT$(now, "###################") 'TRIM$(STR$(now, 18))

END FUNCTION
