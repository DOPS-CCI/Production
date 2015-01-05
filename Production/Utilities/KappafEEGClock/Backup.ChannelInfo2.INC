'There are 2 extra channels when connecting to the Kappametrics fEEG amp.
'You have to choose an extra channel on the scalp cap because of a bug in
'the software and the event channel. This is why all of the unions are set
'up with 2 extra channels. For example - even if we want just 1 channel -
' we have to allocate space to handle 3 channels, etc.
'
%EXTRA_CHANS = 2

UNION Channel01
    ChannelStr AS STRING * ((1 + %EXTRA_CHANS) * 2)
    Channels(1 TO 1 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel02
    ChannelStr AS STRING * ((2 + %EXTRA_CHANS) * 2)
    Channels(1 TO 2 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel03
    ChannelStr AS STRING * ((3 + %EXTRA_CHANS) * 2)
    Channels(1 TO 3 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel04
    ChannelStr AS STRING * ((4 + %EXTRA_CHANS) * 2)
    Channels(1 TO 4 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel05
    ChannelStr AS STRING * ((5 + %EXTRA_CHANS) * 2)
    Channels(1 TO 5 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel06
    ChannelStr AS STRING * ((6 + %EXTRA_CHANS) * 2)
    Channels(1 TO 6 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel07
    ChannelStr AS STRING * ((7 + %EXTRA_CHANS) * 2)
    Channels(1 TO 7 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel08
    ChannelStr AS STRING * ((8 + %EXTRA_CHANS) * 2)
    Channels(1 TO 8 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel09
    ChannelStr AS STRING * ((9 + %EXTRA_CHANS) * 2)
    Channels(1 TO 9 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel10
    ChannelStr AS STRING * ((10 + %EXTRA_CHANS) * 2)
    Channels(1 TO 10 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel11
    ChannelStr AS STRING * ((11 + %EXTRA_CHANS) * 2)
    Channels(1 TO 11 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel12
    ChannelStr AS STRING * ((12 + %EXTRA_CHANS) * 2)
    Channels(1 TO 12 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel13
    ChannelStr AS STRING * ((13 + %EXTRA_CHANS) * 2)
    Channels(1 TO 13 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel14
    ChannelStr AS STRING * ((14 + %EXTRA_CHANS) * 2)
    Channels(1 TO 14 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel15
    ChannelStr AS STRING * ((15 + %EXTRA_CHANS) * 2)
    Channels(1 TO 15 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel16
    ChannelStr AS STRING * ((16 + %EXTRA_CHANS) * 2)
    Channels(1 TO 16 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel17
    ChannelStr AS STRING * ((17 + %EXTRA_CHANS) * 2)
    Channels(1 TO 17 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel18
    ChannelStr AS STRING * ((18 + %EXTRA_CHANS) * 2)
    Channels(1 TO 18 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel19
    ChannelStr AS STRING * ((19 + %EXTRA_CHANS) * 2)
    Channels(1 TO 19 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel20
    ChannelStr AS STRING * ((20 + %EXTRA_CHANS) * 2)
    Channels(1 TO 20 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel21
    ChannelStr AS STRING * ((21 + %EXTRA_CHANS) * 2)
    Channels(1 TO 21 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel22
    ChannelStr AS STRING * ((22 + %EXTRA_CHANS) * 2)
    Channels(1 TO 22 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel23
    ChannelStr AS STRING * ((23 + %EXTRA_CHANS) * 2)
    Channels(1 TO 23 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel24
    ChannelStr AS STRING * ((24 + %EXTRA_CHANS) * 2)
    Channels(1 TO 24 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel25
    ChannelStr AS STRING * ((25 + %EXTRA_CHANS) * 2)
    Channels(1 TO 25 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel26
    ChannelStr AS STRING * ((26 + %EXTRA_CHANS) * 2)
    Channels(1 TO 26 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel27
    ChannelStr AS STRING * ((27 + %EXTRA_CHANS) * 2)
    Channels(1 TO 27 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel28
    ChannelStr AS STRING * ((28 + %EXTRA_CHANS) * 2)
    Channels(1 TO 28 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel29
    ChannelStr AS STRING * ((29 + %EXTRA_CHANS) * 2)
    Channels(1 TO 29 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel30
    ChannelStr AS STRING * ((30 + %EXTRA_CHANS) * 2)
    Channels(1 TO 30 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel31
    ChannelStr AS STRING * ((31 + %EXTRA_CHANS) * 2)
    Channels(1 TO 31 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel32
    ChannelStr AS STRING * ((32 + %EXTRA_CHANS) * 2)
    Channels(1 TO 32 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel33
    ChannelStr AS STRING * ((33 + %EXTRA_CHANS) * 2)
    Channels(1 TO 33 + %EXTRA_CHANS) AS INTEGER
END UNION

UNION Channel34
    ChannelStr AS STRING * ((34 + %EXTRA_CHANS) * 2)
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
