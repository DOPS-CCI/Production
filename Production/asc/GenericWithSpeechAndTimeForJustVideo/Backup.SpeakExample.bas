' ########################################################################################
' SAPI example
' Creates an instance of the speech engine and calls the Speak method.
' ########################################################################################

#COMPILE EXE
#DIM ALL
#INCLUDE ONCE "SAPI.INC"

' ========================================================================================
' Main
' ========================================================================================
FUNCTION PBMAIN () AS LONG

   LOCAL pISpVoice AS ISpVoice
   LOCAL wszText AS STRING
   LOCAL ulStreamNumber AS DWORD

   ' Create an instance of the ISpVoice interface
   pISpVoice = NEWCOM CLSID $CLSID_SpVoice
   IF ISNOTHING(pISpVoice) THEN EXIT FUNCTION

   ' Speak some text
   'wszText = UCODE$("Hello everybody" + $nul)
   wszText = "Hello everybody"
   pISpVoice.Speak("Eat me", %SPF_DEFAULT, ulStreamNumber)
   pISpVoice.WaitUntilDone(&HFFFFFFFF)

   ' Release the interface
   pISpVoice = NOTHING

END FUNCTION
' ========================================================================================
