#COMPILE EXE
#DIM ALL

#INCLUDE ONCE "windows.inc"

TYPE MIDIMessageParts
    NoteOn AS BYTE
    KeyNumber AS BYTE
    KeyVelocity AS BYTE
    unused AS BYTE
END TYPE

UNION MIDIMessage
    msgPart AS MIDIMessageParts
    message AS DWORD
END UNION

' Voice = 0 to 127 (Shanai = 111, Tuba = 58, Accordion = 21)
' more midi voices:
' Rock Organ = 18, Marimba = 12, Steel String Guitar = 25
' Choir Aahs = 52, Alto Sax = 65, Bird Tweet = 123, Sitar = 104
' FX 8 (sci-fi) = 103, FX 3 (crystal) = 98, Glockenspiel = 9

FUNCTION PBMAIN () AS LONG
LOCAL hMidiOut AS LONG
LOCAL voice AS LONG
LOCAL freq AS DOUBLE
LOCAL n AS DOUBLE
LOCAL DEFAULT_DEVICE AS LONG
LOCAL note AS MIDIMessage
LOCAL NoteC, NoteE, NoteG, vol AS DWORD

'    note.msgPart(1) = 0
'    note.msgPart(2) = 64
'    note.msgPart(3) = 60
'    note.msgPart(4) = 144

    note.msgPart.NoteOn = 144
    note.msgPart.KeyNumber = 60
    note.msgPart.KeyVelocity = 100
    note.msgPart.unused = 0
    voice = 19


    DEFAULT_DEVICE = 0         ' Default MIDI Device
    NoteC = &H00403c90         '00 - unused, 40 (Dec. 64) - key velocity, 3C (Dec. 60) - key number [middle C], 90 (Dec. 144) - Note on
    NoteE = &H00404090
    NoteG = &H00404390
    vol = &H4E20
    'vol = &H7D00   ' 1/2 volume 32000
    'vol = &HFFFF    ' full volume 65535

    IF (NOT midiOutOpen(hMidiOut, -1, 0, 0, 0))  THEN
        midiOutShortMsg(hMidiOut, (256 * voice) + 192)
        'midiOutSetVolume(hMidiOut, vol)
        'midiOutShortMsg(hMidiOut, NoteE)
        'Sleep 250
        'FOR n = 10@ TO 30@ STEP .1@
        n = 10
            freq = 440 * 2^((n - 58)/12)

            'freq = Round((log(n)-log(440.0))/log(2.0)*12+69, 0)


            note.msgPart.NoteOn = 144
            note.msgPart.KeyNumber = freq
            note.msgPart.KeyVelocity = 100
            note.msgPart.unused = 0

            midiOutSetVolume(hMidiOut, vol)

            'midiOutShortMsg(hMidiOut, NoteC)
            midiOutShortMsg(hMidiOut, note.message)
            SLEEP 50
       ' NEXT n

'        FOR n = 20@ TO 1000@ 'STEP .1@
'            'freq = 440 * 2^((n - 58)/12)
'
'            freq = Round((log(n)-log(440.0))/log(2.0)*12+69, 0)
'
'
'            note.msgPart.NoteOn = 144
'            note.msgPart.KeyNumber = freq
'            note.msgPart.KeyVelocity = 100
'            note.msgPart.unused = 0
'
'            midiOutSetVolume(hMidiOut, vol)
'
'            'midiOutShortMsg(hMidiOut, NoteC)
'            midiOutShortMsg(hMidiOut, note.message)
'            SLEEP 10
'        NEXT n

'        Sleep 5000
'
'        midiOutShortMsg(hMidiOut, NoteE)
'        Sleep 250
'
'        midiOutShortMsg(hMidiOut, NoteG)
'        Sleep 1500

    ELSE
        MSGBOX "Error Opening Default MIDI Device"
    END IF

    MSGBOX "done."
END FUNCTION
