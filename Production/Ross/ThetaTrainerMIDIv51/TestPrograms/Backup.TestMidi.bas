#COMPILE EXE
#DIM ALL

#INCLUDE ONCE "windows.inc"

FUNCTION PBMAIN () AS LONG
LOCAL hMidiOut AS LONG
LOCAL T AS LONG
LOCAL lngMsg() AS LONG
LOCAL bytVol AS BYTE
LOCAL bytNote() AS BYTE
LOCAL bytStatus AS BYTE
LOCAL intI AS INTEGER

REDIM lngMsg(0 TO 2)
REDIM bytNote(0 TO 2)
'
' Notes for the chord of C Major
'
bytNote(0) = &H3C   'Middle C
bytNote(1) = &H40   ' E
bytNote(2) = &H43   ' G

midiOutOpen hMidiOut, 0, 0, 0, 0
'
' Maximum Volume and Midi Channel 13
'
bytVol = &HFF
bytStatus = &H9D
'
' Create the Midi Message and play each note
'
FOR intI = 0 TO 2
    lngMsg(intI) = CreateMidiMsg(bytNote(intI), bytVol, bytStatus)
    midiOutShortMsg hMidiOut, lngMsg(intI)
NEXT intI
'
' Wait for some time whilst the chord plays
'
SLEEP 5000
'
' Stop playing (set volume to zero)
'
bytVol = 0
FOR intI = 0 TO 2
    lngMsg(intI) = CreateMidiMsg(bytNote(intI), bytVol, bytStatus)
    midiOutShortMsg hMidiOut, lngMsg(intI)
NEXT intI
midiOutClose hMidiOut

END FUNCTION

FUNCTION CreateMidiMsg(bytNote AS BYTE, bytVol AS BYTE, bytStatus AS BYTE) AS LONG
LOCAL msg AS LONG
'
' Pack the data into a Long variable
'   Byte 0 (LSB)    = Status
'   Byte 1          = Note
'   Byte 2          = Volume
'   Byte 3          = 00
'
    msg = (bytVol * (16 ^ 4))
    msg = msg + (bytNote * (16 ^ 2))
    msg = msg + bytStatus

    FUNCTION = msg
END FUNCTION
