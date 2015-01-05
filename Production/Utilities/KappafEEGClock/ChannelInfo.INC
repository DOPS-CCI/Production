'There are 2 extra channels when connecting to the Kappametrics fEEG amp.
'You have to choose an extra channel on the scalp cap because of a bug in
'the software and the event channel. This is why all of the unions are set
'up with 2 extra channels. For example - even if we want just 1 channel -
' we have to allocate space to handle 3 channels, etc.
'
%EXTRA_CHANS = 1

UNION Channel01
    ChannelStr AS ASCIIZ * ((1 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 1 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel02
    ChannelStr AS ASCIIZ * ((2 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 2 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel03
    ChannelStr AS ASCIIZ * ((3 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 3 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel04
    ChannelStr AS ASCIIZ * ((4 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 4 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel05
    ChannelStr AS ASCIIZ * ((5 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 5 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel06
    ChannelStr AS ASCIIZ * ((6 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 6 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel07
    ChannelStr AS ASCIIZ * ((7 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 7 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel08
    ChannelStr AS ASCIIZ * ((8 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 8 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel09
    ChannelStr AS ASCIIZ * ((9 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 9 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel10
    ChannelStr AS ASCIIZ * ((10 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 10 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel11
    ChannelStr AS ASCIIZ * ((11 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 11 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel12
    ChannelStr AS ASCIIZ * ((12 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 12 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel13
    ChannelStr AS ASCIIZ * ((13 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 13 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel14
    ChannelStr AS ASCIIZ * ((14 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 14 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel15
    ChannelStr AS ASCIIZ * ((15 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 15 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel16
    ChannelStr AS ASCIIZ * ((16 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 16 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel17
    ChannelStr AS ASCIIZ * ((17 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 17 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel18
    ChannelStr AS ASCIIZ * ((18 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 18 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel19
    ChannelStr AS ASCIIZ * ((19 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 19 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel20
    ChannelStr AS ASCIIZ * ((20 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 20 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel21
    ChannelStr AS ASCIIZ * ((21 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 21 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel22
    ChannelStr AS ASCIIZ * ((22 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 22 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel23
    ChannelStr AS ASCIIZ * ((23 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 23 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel24
    ChannelStr AS ASCIIZ * ((24 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 24 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel25
    ChannelStr AS ASCIIZ * ((25 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 25 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel26
    ChannelStr AS ASCIIZ * ((26 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 26 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel27
    ChannelStr AS ASCIIZ * ((27 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 27 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel28
    ChannelStr AS ASCIIZ * ((28 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 28 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel29
    ChannelStr AS ASCIIZ * ((29 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 29 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel30
    ChannelStr AS ASCIIZ * ((30 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 30 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel31
    ChannelStr AS ASCIIZ * ((31 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 31 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel32
    ChannelStr AS ASCIIZ * ((32 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 32 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel33
    ChannelStr AS ASCIIZ * ((33 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 33 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel34
    ChannelStr AS ASCIIZ * ((34 + %EXTRA_CHANS) * 2) + 1
    Channels(1 TO 34 + %EXTRA_CHANS) AS INTEGER
END UNION

FUNCTION SwapBytesInteger(BYVAL n AS INTEGER) AS INTEGER
    'big endian to little endian
    ROTATE LEFT n, 8
    FUNCTION = n
END FUNCTION

UNION WordToBytes
    num AS WORD
    arr(1 TO 2) AS BYTE
END UNION

FUNCTION SwapBytesWord(BYVAL n AS WORD) AS WORD
    LOCAL chg AS WordToBytes

    chg.num = n
    IF (chg.arr(1) = 32) THEN
        chg.arr(1) = 0
    END IF
    n = chg.num
    '#debug print "n = " + str$(n) + "arr(1): " + str$(chg.arr(1)) + " arr(2): " + str$(chg.arr(2))
    'big endian to little endian
    ROTATE LEFT n, 8
    FUNCTION = n
END FUNCTION
