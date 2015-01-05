'Attribute VB_Name = "CBW"
'*********************************************************************
'
'  File: CBW.BAS
'
'  (c) Copyright 1996 - 2009 by Measurement Computing Corp.
'      All Rights Reserved
'
' This file contains the Visual BASIC declarations for all Measurement
' Computing library commands.   This file should be included in the
' project as a Global Module
'
'***********************************************************************

' Current Revision Number
'%CURRENTREVNUM = 5.91
' Error Codes
%NOERRORS = 0
%BADBOARD = 1
%DEADDIGITALDEV = 2
%DEADCOUNTERDEV = 3
%DEADDADEV = 4
%DEADADDEV = 5
%NOTDIGITALCONF = 6
%NOTCOUNTERCONF = 7
%NOTDACONF = 8
%NOTADCONF = 9
%NOTMUXCONF = 10
%BADPORTNUM = 11
%BADCOUNTERDEVNUM = 12
%BADDADEVNUM = 13
%BADSAMPLEMODE = 14
%BADINT = 15
%BADADCHAN = 16
%BADCOUNT = 17
%BADCNTRCONFIG = 18
%BADDAVAL = 19
%BADDACHAN = 20
%ALREADYACTIVE = 22
%PAGEOVERRUN = 23
%BADRATE = 24
%COMPATMODE = 25
%TRIGSTATE = 26
%ADSTATUSHUNG = 27
%TOOFEW = 28
%OVERRUN = 29
%BADRANGE = 30
%NOPROGGAIN = 31
%BADFILENAME = 32
%DISKISFULL = 33
%COMPATWARN = 34
%BADPOINTER = 35
%TOOMANYGAINS = 36
%RATEWARNING = 37
%CONVERTDMA = 38
%DTCONNECTERR = 39
%FORECONTINUOUS = 40
%BADBOARDTYPE = 41
%WRONGDIGCONFIG = 42
%NOTCONFIGURABLE = 43
%BADPORTCONFIG = 44
%BADFIRSTPOINT = 45
%ENDOFFILE = 46
%NOT8254CTR = 47
%NOT9513CTR = 48
%BADTRIGTYPE = 49
%BADTRIGVALUE = 50
%BADOPTION = 52
%BADPRETRIGCOUNT = 53
%BADDIVIDER = 55
%BADSOURCE = 56
%BADCOMPARE = 57
%BADTIMEOFDAY = 58
%BADGATEINTERVAL = 59
%BADGATECNTRL = 60
%BADCOUNTEREDGE = 61
%BADSPCLGATE = 62
%BADRELOAD = 63
%BADRECYCLEFLAG = 64
%BADBCDFLAG = 65
%BADDIRECTION = 66
%BADOUTCONTROL = 67
%BADBITNUMBER = 68
%NONEENABLED = 69
%BADCTRCONTROL = 70
%BADEXPCHAN = 71
%WRONGADRANGE = 72
%OUTOFRANGE = 73
%BADTEMPSCALE = 74
%BADERRCODE = 75
%NOQUEUE = 76
%CONTINUOUSCOUNT = 77
%UNDERRUN = 78
%BADMEMMODE = 79
%FREQOVERRUN = 80
%NOCJCCHAN = 81
%BADCHIPNUM = 82
%DIGNOTENABLED = 83
%CONVERT16BITS = 84
%NOMEMBOARD = 85
%DTACTIVE = 86
%NOTMEMCONF = 87
%ODDCHAN = 88
%CTRNOINIT = 89
%NOT8536CTR = 90
%FREERUNNING = 91
%INTERRUPTED = 92
%NOSELECTORS = 93
%NOBURSTMODE = 94
%NOTWINDOWSFUNC = 95
%NOTSIMULCONF = 96
%EVENODDMISMATCH = 97
%M1RATEWARNING = 98
%NOTRS485 = 99
%NOTDOSFUNC = 100
%RANGEMISMATCH = 101
%CLOCKTOOSLOW = 102
%BADCALFACTORS = 103
%BADCONFIGTYPE = 104
%BADCONFIGITEM = 105
%NOPCMCIABOARD = 106
%NOBACKGROUND = 107
%STRINGTOOSHORT = 108
%CONVERTEXTMEM = 109
%BADEUADD = 110
%DAS16JRRATEWARNING = 111
%DAS08TOOLOWRATE = 112
%AMBIGSENSORTYPE = 114      ' more than one sensor type defined for EXP-GP (obsolete)
%AMBIGSENSORONGP = 114      ' more than one sensor type defined for EXP-GP
%NOSENSORTYPEONGP = 115             ' no sensor type defined for EXP-GP
%NOCONVERSIONNEEDED = 116   ' 12 bit board without chan tags - converted in ISR
%NOEXTCONTINUOUS = 117
%INVALIDPRETRIGCONVERT = 118  ' cbConvertPretirg called after cbPretrigScan failed
%BADCTRREG = 119            ' Bad arg to CLoad for 9513 }
%BADTRIGTHRESHOLD = 120     ' Invalid trigger threshold specified in cbSetTrigger }
%BADPCMSLOTREF = 121     ' Bad PCM Card slot reference
%AMBIGPCMSLOTREF = 122  ' Ambiguous PCM Card slot reference
%BADSENSORTYPE = 123 ' Bad sensor type selected in Instacal
%DELBOARDNOTEXIST = 124     ' tried to delete board number which doesn't exist
%NOBOARDNAMEFILE = 125      ' board name file not found
%CFGFILENOTFOUND = 126      ' configuration file not found
%NOVDDINSTALLED = 127     ' CBUL.386 device driver not installed
%NOWINDOWSMEMORY = 128    ' No Windows memory available
%OUTOFDOSMEMORY = 129    ' No DOS memory available
%OBSOLETEOPTION = 130      ' Option on longer supporeted in cbGetConfig/cbSetConfig
%NOPCMREGKEY = 131      ' No registry entry for this PCMCIA board
%NOCBUL32SYS = 132        ' CBUL32.SYS device driver not installed
%NODMAMEMEMORY = 133                ' No memory for device driver's DMA buffer
%IRQNOTAVAILABLE = 134    ' IRQ in use by another device
%NOT7266CTR = 135         ' This board does not have an LS7266 counter /
%BADQUADRATURE = 136      ' Invalid quadrature specified
%BADCOUNTMODE = 137       ' Invalid counting mode specified
%BADENCODING = 138        ' Invalid data encoding specified
%BADINDEXMODE = 139       ' Invalid index mode specified
%BADINVERTINDEX = 140     ' Invalid invert index specified
%BADFLAGPINS = 141        ' Invalid flag pins specified
%NOCTRSTATUS = 142        ' This board does not support cbCStatus()
%NOGATEALLOWED = 143      ' Gating and indexing not allowed simultaneously
%NOINDEXALLOWED = 144     ' Indexing not allowed in non-quadratue mode
%OPENCONNECTION = 145     ' Temperature input has open connection
%BMCONTINUOUSCOUNT = 146  ' Count must be integer multiple of packetsize for recycle mode.
%BADCALLBACKFUNC = 147    ' Invalid pointer to callback function passed as arg
%MBUSINUSE = 148          ' Metrabus in use
%MBUSNOCTLR = 149         ' MetraBus I/O card has no configured controller card
%BADEVENTTYPE = 150       ' Invalid event type specified for this board.
%ALREADYENABLED = 151     ' An event handler has already been enabled for this event type
%BADEVENTSIZE = 152       ' Invalid event count specified.
%CANTINSTALLEVENT = 153   ' Unable to install event handler
%BADBUFFERSIZE = 154             ' Buffer is too small for operation
%BADAIMODE = 155          ' Invalid Analog Input Mode (RSE, NRSE, DIFF)
%BADSIGNAL = 156          ' Invalid signal type specified.
%BADCONNECTION = 157      ' Invalid connection specified.
%BADINDEX = 158           ' Invalid index specified, or reached end of internal connection list.
%NOCONNECTION = 159       ' No connection is assigned to specified signal.
%BADBURSTIOCOUNT = 160    ' Count cannot be greater than the FIFO size for BURSTIO mode
%DEADDEV = 161            ' Device has stopped responding. Please check connections.

%INVALIDACCESS = 163      ' Invalid access or privilege for specified operation
%UNAVAILABLE = 164        ' Device unavailable at time of request. Please repeat operation.
%NOTREADY = 165           ' Device is not ready to send data. Please repeat operation.
%BITUSEDFORALARM = 169    ' The specified bit is used for alarm.
%PORTUSEDFORALARM = 170   ' One or more bits on the specified port are used for alarm.
%PACEROVERRUN = 171       ' Pacer overrun, external clock rate too fast.
%BADCHANTYPE = 172        'Invalid channel type specified.
%BADTRIGSENSE = 173       'Invalid trigger sensitivity specified.
%BADTRIGCHAN = 174        'Invalid trigger channel specified.
%BADTRIGLEVEL = 175       'Invalid trigger level specified.
%NOPRETRIGMODE = 176      'Pre-trigger mode is not supported for the specified trigger type.
%BADDEBOUNCETIME = 177    ' Invalid debounce time specified.
%BADDEBOUNCETRIGMODE = 178    ' Invalid debounce trigger mode specified.
%BADMAPPEDCOUNTER = 179      ' Invalid mapped counter specified.
%BADCOUNTERMODE = 180         'This function can not be used with the current mode of the specified counter.
%BADTCCHANMODE = 181      'Single-Ended mode can not be used for temperature input.
%BADFREQUENCY = 182        'Invalid frequency specified.
%BADEVENTPARAM = 183      'Invalid event parameter specified.
%NONETIFC = 184                       'No interface devices were found with required PAN ID and/or RF Channel.
%DEADNETIFC = 185             'The interface device(s) with required PAN ID and RF Channel has failed. Please check connection.
%NOREMOTEACK = 186            'The remote device is not responding to commands and queries. Please check device.
%INPUTTIMEOUT = 187           'The device acknowledged the operation, but has not completed before the timeout.
%MISMATCHSETPOINTCOUNT = 188  ' Number of Setpoints not equal to number of channels with setpoint flag set.
%INVALIDSETPOINTLEVEL = 189  ' Setpoint Level is outside channel range.
%INVALIDSETPOINTOUTPUTTYPE = 190 ' Setpoint Output Type is invalid.
%INVALIDSETPOINTOUTPUTVALUE = 191 'Setpoint Output Value is outside channel range.
%INVALIDSETPOINTLIMITS = 192 ' Setpoint Comparison limit B greater than Limit A.
%STRINGTOOLONG = 193              ' The string entered is too long for the operation and/or device.
%INVALIDLOGIN = 194        ' The account name and/or password entered is incorrect.
%SESSIONINUSE = 195       ' The device session is already in use.
%NOEXTPOWER = 196         ' External power is not connected.
%BADDUTYCYCLE = 197         ' Invalid duty cycle specified.
%BADINITIALDELAY = 199      'Invalid initial delay specified.
%NOTEDSSENSOR = 1000               ' No TEDS sensor was detected on the specified channel.
%INVALIDTEDSSENSOR = 1001          ' Connected TEDS sensor to the specified channel is not supported.
%CALIBRATIONFAILED = 1002          ' Calibration failed.
%BITUSEDFORTERMINALCOUNTSTATUS = 1003     ' The specified bit is used for terminal count stauts.
%PORTUSEDFORTERMINALCOUNTSTATUS = 1004    ' One or more bits on the specified port are used for terminal count stauts.
%BADEXCITATION = 1005    ' Invalid excitation specified
%BADBRIDGETYPE = 1006    ' Invalid bridge type specified
%BADLOADVAL = 1007    ' Invalid load value specified
%BADTICKSIZE = 1008    ' Invalid tick size specified


' Internal errors returned by 16 bit library
%INTERNALERR = 200         ' 200-299 = 16 bit library internal errors
%CANT_LOCK_DMA_BUF = 201   ' DMA buffer could not be locked
%DMA_IN_USE = 202          ' DMA already controlled by another device
%BAD_MEM_HANDLE = 203      ' Invalid Windows memory handle

%INTERNALERR32 = 300          ' 300-399 = 32 bit library internal errors
%CFG_FILE_READ_FAILURE = 304  ' Error reading from configuration file
%CFG_FILE_WRITE_FAILURE = 305 ' Error writing to configuration file
%CFGFILE_CANT_OPEN = 308      ' Cannot open configuration file
%BAD_RTD_CONVERSION = 325     ' Overflow of RTD conversion
%NO_PCI_BIOS = 326            ' PCI BIOS not present on the PC
%BAD_PCI_INDEX = 327          ' Specified PCI board not detected
%NO_PCI_BOARD = 328           ' Specified PCI board not detected
%CANT_INSTALL_INT = 334       ' Cannot install interrupt handler. IRQ already in use
%NO_USB_BOARD = 343           ' Specified USB board not detected
%NOMOREFILES = 344            ' No more files in the directory
%BADFILENUMBER = 345          ' Invalid file number
%INVALIDSTRUCTSIZE = 346      ' Invalid structure size
%LOSSOFDATA = 347             ' EOF marker not found, possible loss of data
%INVALIDBINARYFILE = 348      ' File is not a valid MCC binary file

%PCMCIAERRS = 400             ' 400-499 = PCMCIA errors

' These are the most commonly occurring remapped DOS error codes
%DOSBADFUNC = 501
%DOSFILENOTFOUND = 502
%DOSPATHNOTFOUND = 503
%DOSNOHANDLES = 504
%DOSACCESSDENIED = 505
%DOSINVALIDHANDLE = 506
%DOSNOMEMORY = 507
%DOSBADDRIVE = 515
%DOSTOOMANYFILES = 518
%DOSWRITEPROTECT = 519
%DOSDRIVENOTREADY = 521
%DOSSEEKERROR = 525
%DOSWRITEFAULT = 529
%DOSREADFAULT = 530
%DOSGENERALFAULT = 531

%WIN_CANNOT_ENABLE_INT = 603       ' Cannot enable interrupt. IRQ already in use
%WIN_CANNOT_DISABLE_INT = 605      ' Cannot disable interrupts
%WIN_CANT_PAGE_LOCK_BUFFER = 606   ' Insufficient memory to page lock data buffer
%NO_PCM_CARD = 630                 ' PCM card not detected


' Types of operations or functions
%AIFUNCTION = 1           ' Analog Input Function
%AOFUNCTION = 2           ' Analog Output Function
%DIFUNCTION = 3           ' Digital Input Function
%DOFUNCTION = 4           ' Digital Output Function
%CTRFUNCTION = 5          ' Counter Function
%DAQIFUNCTION = 6         'Daq Input Function
%DAQOFUNCTION = 7         'Daq Output Function


%NOTUSED = -1

' Maximum length of error string
%ERRSTRLEN = 256

' Maximum length of board name string
%BOARDNAMELEN = 25


' Status values
%IDLE = 0
%RUNNING = 1


%CBENABLED = 1
%CBDISABLED = 0

%UPDATEIMMEDIATE = 0
%UPDATEONCOMMAND = 1

' Types of error reporting
%DONTPRINT = 0
%PRINTWARNINGS = 1
%PRINTFATAL = 2
%PRINTALL = 3

' Types of error handling
%DONTSTOP = 0
%STOPFATAL = 1
%STOPALL = 2

'Channel types
%ANALOG = 0       'Analog channel
%DIGITAL8 = 1     '8-bit digital port
%DIGITAL16 = 2    '16-bit digital port
%CTR16 = 3        '16-bit counter
%CTR32LOW = 4     'Lower 16-bits of 32-bit counter
%CTR32HIGH = 5    'Upper 16-bits of 32-bit counter
%CJC = 6          'CJC channel
%TC = 7           'Thermocouple channel
%ANALOG_SE = 8    'Analog channel, singel-ended mode
%ANALOG_DIFF = 9  'Analog channel, Differential mode
%SETPOINTSTATUS = 10 'Setpoint status register

'Channel type flags
%SETPOINT_ENABLE = &H100  'Enable setpoint detection

'Setpoint flags
%SF_EQUAL_LIMITA = &H0              'Channel = LimitA value
%SF_LESSTHAN_LIMITA = &H1           'Channel < LimitA value
%SF_INSIDE_LIMITS = &H2             'Channel Inside LimitA and LimitB (LimitA < Channel < LimitB)
%SF_GREATERTHAN_LIMITB = &H3        'Channel > LimitB
%SF_OUTSIDE_LIMITS = &H4            'Channel Outside LimitA and LimitB (LimitA < Channel or Channel > LimitB)
%SF_HYSTERESIS = &H5                'Use As Hysteresis
%SF_UPDATEON_TRUEONLY = &H0         'Latch output condition (output = output1 for duration of acquisition)
%SF_UPDATEON_TRUEANDFALSE = &H8     'Do not latch output condition (output = output1 when criteria met else output = output2)

'Setpoint output channels
%SO_NONE = 0        'No Output
%SO_DIGITALPORT = 1 'Output to digital port
%SO_FIRSTPORTC = 1  'Output to first PortC
%SO_DAC0 = 2        'Output to DAC0
%SO_DAC1 = 3        'Output to DAC1
%SO_DAC2 = 4        'Output to DAC2
%SO_DAC3 = 5        'Output to DAC3
%SO_TMR0 = 6        'Output to TMR0
%SO_TMR1 = 7        'Output to TMR1


'cbDaqSetTrigger trigger sources
%TRIG_IMMEDIATE = 0
%TRIG_EXTTTL = 1
%TRIG_ANALOG_HW = 2
%TRIG_ANALOG_SW = 3
%TRIG_DIGPATTERN = 4
%TRIG_COUNTER = 5
%TRIG_SCANCOUNT = 6

'cbDaqSetTrigger trigger sensitivities
%RISING_EDGE = 0
%FALLING_EDGE = 1
%ABOVE_LEVEL = 2
%BELOW_LEVEL = 3
%EQ_LEVEL = 4
%NE_LEVEL = 5

'Trigger events
%START_EVENT = 0
%STOP_EVENT = 1

' Settling time settings
%SETTLE_DEFAULT = 0
%SETTLE_1us = 1
%SETTLE_5us = 2
%SETTLE_10us = 3
%SETTLE_1ms = 4

' Types of digital input ports
%DIGITALOUT = 1
%DIGITALIN = 2

' DT Modes for cbSetDTMode ()
%DTIN = 0
%DTOUT = 2

%FROMHERE = -1
%GETFIRST = -2
%GETNEXT = -3

'  Temperature scales
%CELSIUS = 0
%FAHRENHEIT = 1
%KELVIN = 2
%VOLTS = 4
%NOSCALE = 5

' default Option
%DEFAULTOPTION = &H0


' Types of digital I/O Ports
%AUXPORT = 1
%FIRSTPORTA = 10
%FIRSTPORTB = 11
%FIRSTPORTCL = 12
%FIRSTPORTC = 12
%FIRSTPORTCH = 13
%SECONDPORTA = 14
%SECONDPORTB = 15
%SECONDPORTCL = 16
%SECONDPORTCH = 17
%THIRDPORTA = 18
%THIRDPORTB = 19
%THIRDPORTCL = 20
%THIRDPORTCH = 21
%FOURTHPORTA = 22
%FOURTHPORTB = 23
%FOURTHPORTCL = 24
%FOURTHPORTCH = 25
%FIFTHPORTA = 26
%FIFTHPORTB = 27
%FIFTHPORTCL = 28
%FIFTHPORTCH = 29
%SIXTHPORTA = 30
%SIXTHPORTB = 31
%SIXTHPORTCL = 32
%SIXTHPORTCH = 33
%SEVENTHPORTA = 34
%SEVENTHPORTB = 35
%SEVENTHPORTCL = 36
%SEVENTHPORTCH = 37
%EIGHTHPORTA = 38
%EIGHTHPORTB = 39
%EIGHTHPORTCL = 40
%EIGHTHPORTCH = 41


' Selectable A/D Ranges codes
%BIP60VOLTS = 20                    ' Bipolar Ranges (-60 to +60 Volts)
%BIP20VOLTS = 15                    ' Bipolar Ranges (-20 to +20 Volts)
%BIP15VOLTS = 21                    ' Bipolar Ranges (-15 to +15 Volts)
%BIP10VOLTS = 1                     ' -10 to +10 Volts
%BIP5VOLTS = 0                      ' -5 to +5 Volts
%BIP4VOLTS = 16                     ' -4 to +4 Volts
%BIP2PT5VOLTS = 2                   ' -2.5 to +2.5 Volts
%BIP2VOLTS = 14                     ' -2 to +2 Volts
%BIP1PT25VOLTS = 3                  ' -1.25 to +1.25 Volts
%BIP1VOLTS = 4                      ' -1 to +1 Volt
%BIPPT625VOLTS = 5                  ' -0.625 to + 0.625 Volt
%BIPPT5VOLTS = 6                    ' -0.5 to +0.5 Volt
%BIPPT25VOLTS = 12                  ' -0.25 to +0.25 Volt
%BIPPT2VOLTS = 13                   ' -0.2 to +0.2 Volt
%BIPPT1VOLTS = 7                    ' -0.1 to +0.1 Volt
%BIPPT05VOLTS = 8                   ' -0.05 to +0.05 Volt
%BIPPT01VOLTS = 9                   ' -0.01 to +0.01 Volt
%BIPPT005VOLTS = 10                 ' -0.005 to +0.005 Volt
%BIP1PT67VOLTS = 11                 ' -1.67 to +1.67 Volts
%BIPPT312VOLTS = 17                 ' -0.3125 to +0.3125 Volts
%BIPPT156VOLTS = 18                 ' -0.15625 to +0.15625 Volts
%BIPPT125VOLTS = 22                 ' -0.125 to +0.125 Volts
%BIPPT078VOLTS = 19                 ' -0.078125 to +0.078125 Volts

%UNI10VOLTS = 100                  ' Unipolar Ranges (0 to 10 Volts)
%UNI5VOLTS = 101                   ' 0 to 5 Volts
%UNI4VOLTS = 114                   ' 0 to 4 Volts
%UNI2PT5VOLTS = 102                ' 0 to 2.5 Volts
%UNI2VOLTS = 103                   ' 0 to 2 Volts
%UNI1PT67VOLTS = 109               ' 0 to 1.67 Volts
%UNI1PT25VOLTS = 104               ' 0 to 1.25 Volts
%UNI1VOLTS = 105                   ' 0 to 1 Volt
%UNIPT5VOLTS = 110                 ' 0 to 0.5 Volt
%UNIPT25VOLTS = 111                ' 0 to 0.25 Volt
%UNIPT2VOLTS = 112                 ' 0 to 0.2 Volt
%UNIPT1VOLTS = 106                 ' 0 to 0.1 Volt
%UNIPT05VOLTS = 113                ' 0 to 0.05 Volt
%UNIPT02VOLTS = 108                ' 0 to 0.02 Volt
%UNIPT01VOLTS = 107                ' 0 to 0.01 Volt



%MA4TO20 = 200                     ' Current Ranges (4 to 20 mA )
%MA2to10 = 201                     ' 2 to 10 mA
%MA1TO5 = 202                      ' 1 to 5 mA
%MAPT5TO2PT5 = 203                 ' 0.5 to 2.5 mA
%MA0TO20 = 204                     ' 0 to 20 mA
%BIPPT025AMPS = 205                ' -0.025 to 0.025 ma

%UNIPOLAR = 300                    ' Unipolar range
%BIPOLAR = 301                     ' Bipolar range

%BIPPT025VOLTSPERVOLT = 400        '-0.025 to +0.025 V/V

' Types of D/A
%ADDA1 = 0
%ADDA2 = 1

' 8536 counter output 1 control
%NOTLINKED = 0
%GATECTR2 = 1
%TRIGCTR2 = 2
%INCTR2 = 3

' 8536 trigger types
%HW_START_TRIG = 0
%HW_RETRIG = 1
%SW_START_TRIG = 2

' Types of 8254 Counter configurations
%HIGHONLASTCOUNT = 0
%ONESHOT = 1
%RATEGENERATOR = 2
%SQUAREWAVE = 3
%SOFTWARESTROBE = 4
%HARDWARESTROBE = 5

' Where to reload from for 9513 counters
%LOADREG = 0
%LOADANDHOLDREG = 1

' Counter recycle modes
%ONETIME = 0
%RECYCLE = 1

' Direction of counting for 9513 counters
%COUNTDOWN = 0
%COUNTUP = 1

' Types of count detection for 9513 counters
%POSITIVEEDGE = 0
%NEGATIVEEDGE = 1

' Counter output control
%ALWAYSLOW = 0
%HIGHPULSEONTC = 1
%TOGGLEONTC = 2
%DISCONNECTED = 4
%LOWPULSEONTC = 5
%HIGHUNTILTC = 6

' Counter input sources
%TCPREVCTR = 0
%CTRINPUT1 = 1
%CTRINPUT2 = 2
%CTRINPUT3 = 3
%CTRINPUT4 = 4
%CTRINPUT5 = 5
%GATE1 = 6
%GATE2 = 7
%GATE3 = 8
%GATE4 = 9
%GATE5 = 10
%FREQ1 = 11
%FREQ2 = 12
%FREQ3 = 13
%FREQ4 = 14
%FREQ5 = 15
%CTRINPUT6 = 101
%CTRINPUT7 = 102
%CTRINPUT8 = 103
%CTRINPUT9 = 104
%CTRINPUT10 = 105
%GATE6 = 106
%GATE7 = 107
%GATE8 = 108
%GATE9 = 109
%GATE10 = 110
%FREQ6 = 111
%FREQ7 = 112
%FREQ8 = 113
%FREQ9 = 114
%FREQ10 = 115

%CTRINPUT11 = 201
%CTRINPUT12 = 202
%CTRINPUT13 = 203
%CTRINPUT14 = 204
%CTRINPUT15 = 205
%GATE11 = 206
%GATE12 = 207
%GATE13 = 208
%GATE14 = 209
%GATE15 = 210
%FREQ11 = 211
%FREQ12 = 212
%FREQ13 = 213
%FREQ14 = 214
%FREQ15 = 215
%CTRINPUT16 = 301
%CTRINPUT17 = 302
%CTRINPUT18 = 303
%CTRINPUT19 = 304
%CTRINPUT20 = 305
%GATE16 = 306
%GATE17 = 307
%GATE18 = 308
%GATE19 = 309
%GATE20 = 310
%FREQ16 = 311
%FREQ17 = 312
%FREQ18 = 313
%FREQ19 = 314
%FREQ20 = 315

' Counter load registers
%LOADREG0 = 0
%LOADREG1 = 1
%LOADREG2 = 2
%LOADREG3 = 3
%LOADREG4 = 4
%LOADREG5 = 5
%LOADREG6 = 6
%LOADREG7 = 7
%LOADREG8 = 8
%LOADREG9 = 9
%LOADREG10 = 10

%LOADREG11 = 11
%LOADREG12 = 12
%LOADREG13 = 13
%LOADREG14 = 14
%LOADREG15 = 15
%LOADREG16 = 16
%LOADREG17 = 17
%LOADREG18 = 18
%LOADREG19 = 19
%LOADREG20 = 20

' 9513 Counter registers
%HOLDREG1 = 101
%HOLDREG2 = 102
%HOLDREG3 = 103
%HOLDREG4 = 104
%HOLDREG5 = 105
%HOLDREG6 = 106
%HOLDREG7 = 107
%HOLDREG8 = 108
%HOLDREG9 = 109
%HOLDREG10 = 110

%HOLDREG11 = 111
%HOLDREG12 = 112
%HOLDREG13 = 113
%HOLDREG14 = 114
%HOLDREG15 = 115
%HOLDREG16 = 116
%HOLDREG17 = 117
%HOLDREG18 = 118
%HOLDREG19 = 119
%HOLDREG20 = 120

%ALARM1CHIP1 = 201
%ALARM2CHIP1 = 202
%ALARM1CHIP2 = 301
%ALARM2CHIP2 = 302
%ALARM1CHIP3 = 401
%ALARM2CHIP3 = 402
%ALARM1CHIP4 = 501
%ALARM2CHIP4 = 502

' LS7266 Counter registers
%COUNT1 = 601
%COUNT2 = 602
%COUNT3 = 603
%COUNT4 = 604

%PRESET1 = 701
%PRESET2 = 702
%PRESET3 = 703
%PRESET4 = 704

%PRESCALER1 = 801
%PRESCALER2 = 802
%PRESCALER3 = 803
%PRESCALER4 = 804


'  Counter Gate Control
%NOGATE = 0
%AHLTCPREVCTR = 1
%AHLNEXTGATE = 2
%AHLPREVGATE = 3
%AHLGATE = 4
%ALLGATE = 5
%AHEGATE = 6
%ALEGATE = 7

' 7266 Counter Quadrature values
%NO_QUAD = 0
%X1_QUAD = 1
%X2_QUAD = 2
%X4_QUAD = 4

' 7266 Counter Counting Modes
%NORMAL_MODE = 0
%RANGE_LIMIT = 1
%NO_RECYCLE = 2
%MODULO_N = 3

' 7266 Counter encodings
%BCD_ENCODING = 1
%BINARY_ENCODING = 2

' 7266 Counter Index Modes
%INDEX_DISABLED = 0
%LOAD_CTR = 1
%LOAD_OUT_LATCH = 2
%RESET_CTR = 3

' 7266 Counter Flag Pins
%CARRY_BORROW = 1
%COMPARE_BORROW = 2
%CARRYBORROW_UPDOWN = 3
%INDEX_ERROR = 4

' Counter status bits
%C_UNDERFLOW = &H1
%C_OVERFLOW = &H2
%C_COMPARE = &H4
%C_SIGN = &H8
%C_ERROR = &H10
%C_UP_DOWN = &H20
%C_INDEX = &H40

' USB-QUAD08 Counter registers
%MAXLIMITREG0 = &H0
%MAXLIMITREG1 = &H1
%MAXLIMITREG2 = &H2
%MAXLIMITREG3 = &H3
%MAXLIMITREG4 = &H4
%MAXLIMITREG5 = &H5
%MAXLIMITREG6 = &H6
%MAXLIMITREG7 = &H7

' 25xx series counter mode constants
%TOTALIZE = &H0
%CLEAR_ON_READ = &H1
%ROLLOVER = &H0
%STOP_AT_MAX = &H2
%DECREMENT_OFF = &H0
%DECREMENT_ON = &H20
%BIT_16 = &H0
%BIT_32 = &H4
%BIT_48 = &H10000
%GATING_OFF = &H0
%GATING_ON = &H10
%LATCH_ON_SOS = &H0
%LATCH_ON_MAP = &H8
%UPDOWN_OFF = &H0
%UPDOWN_ON = &H1000
%RANGE_LIMIT_OFF = &H0
%RANGE_LIMIT_ON = &H2000
%NO_RECYCLE_OFF = &H0
%NO_RECYCLE_ON = &H4000
%MODULO_N_OFF = &H0
%MODULO_N_ON = &H8000&

%PERIOD = &H200
%PERIOD_MODE_X1 = &H0
%PERIOD_MODE_X10 = &H1
%PERIOD_MODE_X100 = &H2
%PERIOD_MODE_X1000 = &H3
%PERIOD_MODE_BIT_16 = &H0
%PERIOD_MODE_BIT_32 = &H4
%PERIOD_MODE_BIT_48 = &H10000
%PERIOD_MODE_GATING_ON = &H10

%PULSEWIDTH = &H300
%PULSEWIDTH_MODE_BIT_16 = &H0
%PULSEWIDTH_MODE_BIT_32 = &H4
%PULSEWIDTH_MODE_BIT_48 = &H10000
%PULSEWIDTH_MODE_GATING_ON = &H10

%TIMING = &H400
%TIMING_MODE_BIT_16 = &H0
%TIMING_MODE_BIT_32 = &H4
%TIMING_MODE_BIT_48 = &H10000

%ENCODER = &H500
%ENCODER_MODE_X1 = &H0
%ENCODER_MODE_X2 = &H1
%ENCODER_MODE_X4 = &H2
%ENCODER_MODE_BIT_16 = &H0
%ENCODER_MODE_BIT_32 = &H4
%ENCODER_MODE_BIT_48 = &H10000
%ENCODER_MODE_LATCH_ON_Z = &H8
%ENCODER_MODE_CLEAR_ON_Z_OFF = &H0
%ENCODER_MODE_CLEAR_ON_Z_ON = &H20
%ENCODER_MODE_RANGE_LIMIT_OFF = &H0
%ENCODER_MODE_RANGE_LIMIT_ON = &H2000
%ENCODER_MODE_NO_RECYCLE_OFF = &H0
%ENCODER_MODE_NO_RECYCLE_ON = &H4000
%ENCODER_MODE_MODULO_N_OFF = &H0
%ENCODER_MODE_MODULO_N_ON = &H8000&


' obsolete encoder mode constants, use preferred constants above
%LATCH_ON_Z = &H8
%CLEAR_ON_Z_OFF = &H0
%CLEAR_ON_Z_ON = &H20


' 25xx series counter debounce time constants
%CTR_DEBOUNCE500ns = 0
%CTR_DEBOUNCE1500ns = 1
%CTR_DEBOUNCE3500ns = 2
%CTR_DEBOUNCE7500ns = 3
%CTR_DEBOUNCE15500ns = 4
%CTR_DEBOUNCE31500ns = 5
%CTR_DEBOUNCE63500ns = 6
%CTR_DEBOUNCE127500ns = 7
%CTR_DEBOUNCE100us = 8
%CTR_DEBOUNCE300us = 9
%CTR_DEBOUNCE700us = 10
%CTR_DEBOUNCE1500us = 11
%CTR_DEBOUNCE3100us = 12
%CTR_DEBOUNCE6300us = 13
%CTR_DEBOUNCE12700us = 14
%CTR_DEBOUNCE25500us = 15
%CTR_DEBOUNCE_NONE = 16

' 25xx series counter debounce trigger constants
%CTR_TRIGGER_AFTER_STABLE = 0
%CTR_TRIGGER_BEFORE_STABLE = 1

' 25xx series counter edge detection constants
%CTR_RISING_EDGE = 0
%CTR_FALLING_EDGE = 1

' Types of triggers
%TRIGABOVE = 0
%TRIGBELOW = 1
%GATENEGHYS = (%TRIGBELOW + 1)
%GATEPOSHYS = (%TRIGBELOW + 2)
%GATEABOVE = (%TRIGBELOW + 3)
%GATEBELOW = (%TRIGBELOW + 4)
%GATEINWINDOW = (%TRIGBELOW + 5)
%GATEOUTWINDOW = (%TRIGBELOW + 6)
%GATEHIGH = (%TRIGBELOW + 7)
%GATELOW = (%TRIGBELOW + 8)
%TRIGHIGH = (%TRIGBELOW + 9)
%TRIGLOW = (%TRIGBELOW + 10)
%TRIGPOSEDGE = (%TRIGBELOW + 11)
%TRIGNEGEDGE = (%TRIGBELOW + 12)

' Timer idle state
%IDLE_LOW = 0
%IDLE_HIGH = 1


' Signal I/O Configuration Parameters
' --Connections
%AUXIN0 = &H1
%AUXIN1 = &H2
%AUXIN2 = &H4
%AUXIN3 = &H8
%AUXIN4 = &H10
%AUXIN5 = &H20

%AUXOUT0 = &H100
%AUXOUT1 = &H200
%AUXOUT2 = &H400

%DS_CONNECTOR = &H1000

%MAX_CONNECTIONS = 4  'maximum  number connections per output signal

' --Signal Types
%ADC_CONVERT = &H1
%ADC_GATE = &H2
%ADC_START_TRIG = &H4
%ADC_STOP_TRIG = &H8
%ADC_TB_SRC = &H10
%ADC_SCANCLK = &H20&
%ADC_SSH = &H40&
%ADC_STARTSCAN = &H80&
%ADC_SCAN_STOP = &H100&

%DAC_UPDATE = &H200&
%DAC_TB_SRC = &H400&
%DAC_START_TRIG = &H800&

%SYNC_CLK = &H1000&

%CTR1_CLK = &H2000&
%CTR2_CLK = &H4000&

%DGND = &H8000&

' -- Signal Direction
%SIGNAL_IN = 2
%SIGNAL_OUT = 4

%INVERTED = 1
%NONINVERTED = 0




' Types of configuration information
%GLOBALINFO = 1
%BOARDINFO = 2
%DIGITALINFO = 3
%COUNTERINFO = 4
%EXPANSIONINFO = 5
%MISCINFO = 6
%EXPINFOARRAY = 7
%MEMINFO = 8

' Types of global configuration information
%GIVERSION = 36        ' Config file format version number
%GINUMBOARDS = 38      ' Maximum number of boards
%GINUMEXPBOARDS = 40   ' Maximum number of expansion boards

' Types of board configuration information
%BIBASEADR = 0         ' Base Address
%BIBOARDTYPE = 1       ' Board Type (0x101 - 0x7FFF)
%BIINTLEVEL = 2        ' Interrupt level
%BIDMACHAN = 3         ' DMA channel
%BIINITIALIZED = 4     ' TRUE or FALSE
%BICLOCK = 5           ' Clock freq (1, 10 or bus)
%BIRANGE = 6           ' Switch selectable range
%BINUMADCHANS = 7      ' Number of A/D channels
%BIUSESEXPS = 8        ' Supports expansion boards TRUE/FALSE
%BIDINUMDEVS = 9       ' Number of digital devices
%BIDIDEVNUM = 10       ' Index into digital information
%BICINUMDEVS = 11      ' Number of counter devices
%BICIDEVNUM = 12       ' Index into counter information
%BINUMDACHANS = 13     ' Number of D/A channels
%BIWAITSTATE = 14      ' Wait state enabled TRUE/FALSE
%BINUMIOPORTS = 15     ' I/O address space used by board
%BIPARENTBOARD = 16    ' Board number of parent board
%BIDTBOARD = 17        ' Board number of connected DT board
%BINUMEXPS = 18        ' Number of EXPs attached to board
%BISERIALNUM = 214     ' Serial Number for USB boards
%BIDACUPDATEMODE = 215 ' Update immediately or upon AOUPDATE command
%BIDACUPDATECMD = 216  ' Issue D/A UPDATE command
%BIDACSTARTUP = 217    ' Restore last value written for startup
%BIADTRIGCOUNT = 219          ' Number of samples to acquire per trigger in retrigger mode
%BIADFIFOSIZE = 220    ' Set FIFO override size for retrigger mode
%BIADSOURCE = 221      ' Set A/D source to internal reference(>=0) or external connector(-1)
%BICALOUTPUT = 222     ' CAL output pin setting
%BISRCADPACER = 223     ' Source A/D Pacer output
%BIDIALARMMASK = 230

%BINETIOTIMEOUT = 247

%BIDIDEBOUNCESTATE = 255
%BIDIDEBOUNCETIME = 256 ' Digital inputs debounce Time

%BIPANID = 258
%BIRFCHANNEL = 259

%BIRSS = 261
%BINODEID = 262
%BIDEVNOTES = 263

%BIADCSETTLETIME = 270  ' Set settling time for A/D channels

%BIFACTORYID = 272
%BIHTTPPORT = 273
%BIHIDELOGINDLG = 274
%BIDACTRIGCOUNT = 284  ' Number of samples to generate per trigger in retrigger mode
%BIADRES = 291
%BIDACRES = 292

' Types of digital device information
%DIBASEADR = 0         ' Base address
%DIINITIALIZED = 1     ' TRUE or FALSE
%DIDEVTYPE = 2         ' AUXPORT or xPORTA - CH
%DIMASK = 3            ' Bit mask for this port
%DIREADWRITE = 4       ' Read required before write
%DICONFIG = 5          ' Current configuration
%DINUMBITS = 6         ' Number of bits in port
%DICURVAL = 7          ' Current value of outputs
%DIINMASK = 8                  ' Input bit mask for port
%DIOUTMASK = 9                      ' Output bit mask for port

' Types of counter device information
%CIBASEADR = 0         ' Base address
%CIINITIALIZED = 1     ' TRUE or FALSE
%CICTRTYPE = 2         ' Counter type 8254, 9513 or 8536
%CICTRNUM = 3          ' Which counter on chip
%CICONFIGBYTE = 4      ' Configuration byte

' Types of expansion board information
%XIBOARDTYPE = 0       ' Expansion board type
%XIMUXADCHAN1 = 1      ' 0 - 15
%XIMUXADCHAN2 = 2      ' 0 - 15 or NOTUSED
%XIRANGE1 = 3          ' Range (gain) of low 16 chans
%XIRANGE2 = 4          ' Range (gain) of high 16 chans
%XICJCCHAN = 5         ' 0 - 15 or NOTUSED
%XITHERMTYPE = 6       ' TYPEJ, TYPEK, TYPEB, TYPET, TYPEE, TYPER, or TYPES
%XINUMEXPCHANS = 7     ' Number of expansion channels on board
%XIPARENTBOARD = 8     ' Board number of parent A/D board
%XISPARE0 = 9          ' 16 words of misc options

' Types of Events
%ON_SCAN_ERROR = &H1&
%ON_EXTERNAL_INTERRUPT = &H2&
%ON_PRETRIGGER = &H4&
%ON_DATA_AVAILABLE = &H8&
%ON_END_OF_AI_SCAN = &H10&
%ON_END_OF_AO_SCAN = &H20&
%ON_CHANGE_DI = &H40&
%ALL_EVENT_TYPES = &HFF&

' ON_EXTERNAL_INTERRUPT event parameters
%LATCH_DI = &H1&
%LATCH_DO = &H2&


'#If Win32 Then

' Option Flags
'
%FOREGROUND = &H0&
%BACKGROUND = &H1&

%SINGLEEXEC = &H0&
%CONTINUOUS = &H2&

%TIMED = &H0&
%EXTCLOCK = &H4&

%NOCONVERTDATA = &H0&
%CONVERTDATA = &H8&

%NODTCONNECT = &H0&
%DTCONNECT = &H10&
%SCALEDATA = &H10&      ' Scale scan data to engineering units

%DEFAULTIO = &H0&
%SINGLEIO = &H20&
%DMAIO = &H40&
%BLOCKIO = &H60&
%BURSTIO = &H10000     ' Transfer upon scan completion
%RETRIGMODE = &H20000   ' Re-arm trigger upon acquiring trigger count samples
%NONSTREAMEDIO = &H40000 ' Non-streamed D/A output
%ADCCLOCKTRIG = &H80000
%ADCCLOCK = &H100000
%HIGHRESRATE = &H200000  ' Use high resolution rate
%SHUNTCAL = &H400000     ' Enable Shunt Calibration


%BYTEXFER = &H0&
%WORDXFER = &H100&

%INDIVIDUAL = &H0&
%SIMULTANEOUS = &H200&

%FILTER = &H0&
%NOFILTER = &H400&

%NORMMEMORY = &H0&
%EXTMEMORY = &H800&

%BURSTMODE = &H1000&

%NOTODINTS = &H2000&

%EXTTRIGGER = &H4000&

%NOCALIBRATEDATA = &H8000&
%CALIBRATEDATA = &H0&

%CTR16BIT = &H0&    ' 16-bit counter data
%CTR32BIT = &H100&  ' 32-bit counter data
%CTR48BIT = &H200&  ' 48-bit counter data


' time zone constants
%TIMEZONE_LOCAL = 0
%TIMEZONE_GMT = 1


' time format constants
%TIMEFORMAT_12HOUR = 0
%TIMEFORMAT_24HOUR = 1


' delimiter constants
%DELIMITER_COMMA = 0
%DELIMITER_SEMICOLON = 1
%DELIMITER_SPACE = 2
%DELIMITER_TAB = 3


' Data Logger units constants
%UNITS_TEMPERATURE = 0
%UNITS_RAW = 1
       '
        ' 32-bit function prototypes
        '
DECLARE FUNCTION cbLoadConfig LIB "cbw32.dll" (BYVAL CfgFileName$) AS LONG
DECLARE FUNCTION cbSaveConfig LIB "cbw32.dll" (BYVAL CfgFileName$) AS LONG
DECLARE FUNCTION cbAConvertData LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL NumPoints&, ADData%, ChanTags%) AS LONG
DECLARE FUNCTION cbACalibrateData LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL NumPoints&, BYVAL Gain&, ADData%) AS LONG
DECLARE FUNCTION cbAConvertPretrigData LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PretrigCount&, BYVAL TotalCount&, ADData%, ChanTags%) AS LONG
DECLARE FUNCTION cbAIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, DataValue%) AS LONG
DECLARE FUNCTION cbAIn32 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, DataValue&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbAInScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, BYVAL CBCount&, CBRate&, BYVAL Gain&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbALoadQueue LIB "cbw32.dll" (BYVAL BoardNum&, ChanArray%, GainArray%, BYVAL NumChans&) AS LONG
DECLARE FUNCTION cbAOut LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, BYVAL DataValue%) AS LONG
DECLARE FUNCTION cbAOutScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, BYVAL CBCount&, CBRate&, BYVAL Gain&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbAPretrig LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, PretrigCount&, CBCount&, CBRate&, BYVAL Gain&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbATrig LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL TrigType&, BYVAL TrigValue%, BYVAL Gain&, DataValue%) AS LONG
DECLARE FUNCTION cbC7266Config LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, BYVAL Quadrature&, BYVAL CountingMode&, BYVAL DataEncoding&, BYVAL IndexMode&, BYVAL InvertIndex&, BYVAL FlagPins&, BYVAL GateEnable&) AS LONG
DECLARE FUNCTION cbC8254Config LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, BYVAL Config&) AS LONG
DECLARE FUNCTION cbC8536Config LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, BYVAL OutputControl&, BYVAL RecycleMode&, BYVAL TrigType&) AS LONG
DECLARE FUNCTION cbC9513Config LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, BYVAL GateControl&, BYVAL CounterEdge&, BYVAL CountSource&, BYVAL SpecialGate&, BYVAL Reload&, BYVAL RecycleMode&, BYVAL BCDMode&, BYVAL CountDirec&, BYVAL OutputCtrl&) _
AS LONG
DECLARE FUNCTION cbC8536Init LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL ChipNum&, BYVAL Ctr1Output&) AS LONG
DECLARE FUNCTION cbC9513Init LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL ChipNum&, BYVAL FOutDivider&, BYVAL FOutSource&, BYVAL Compare1&, BYVAL Compare2&, BYVAL TimeOfDay&) AS LONG
DECLARE FUNCTION cbCStoreOnInt LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL IntCount&, CntrControl%, BYVAL DataBuffer&) AS LONG
DECLARE FUNCTION cbCFreqIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL SigSource&, BYVAL GateInterval&, CBCount%, Freq&) AS LONG

DECLARE FUNCTION cbCInScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL FirstCtr&, BYVAL LastCtr&, BYVAL CBCount&, CBRate&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbCConfigScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, BYVAL Mode&, BYVAL DebounceTime&, BYVAL DebounceMode&, BYVAL EdgeDetection&, BYVAL TickSize&, BYVAL MappedChannel&) AS LONG
DECLARE FUNCTION cbCClear LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&) AS LONG
DECLARE FUNCTION cbTimerOutStart LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TimerNum&, Frequency#) AS LONG
DECLARE FUNCTION cbTimerOutStop LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TimerNum&) AS LONG
DECLARE FUNCTION cbPulseOutStart LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TimerNum&, Frequency#, DutyCycle#, BYVAL PulseCount&, InitialDelay#, BYVAL IdleState&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbPulseOutStop LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TimerNum&) AS LONG

'*****************************************************************************
'   Legacy Function Prototypes: to revert to legacy calls, un-comment the
'          prototypes immediately below.
'
'      Declare Function cbCIn Lib "cbw32.dll" (ByVal BoardNum&, ByVal CounterNum&, CBCount&) As Long
'
'   Remove the following if using the above legacy function prototypes.
DECLARE FUNCTION cbCIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, CBCount%) AS LONG
'*****************************************************************************

DECLARE FUNCTION cbCIn32 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, CBCount&) AS LONG
DECLARE FUNCTION cbCLoad LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL RegNum&, BYVAL LoadValue&) AS LONG
DECLARE FUNCTION cbCLoad32 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL RegNum&, BYVAL LoadValue&) AS LONG
DECLARE FUNCTION cbCStatus LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL CounterNum&, StatusBits&) AS LONG
DECLARE FUNCTION cbDBitIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortType&, BYVAL BitNum&, BitValue%) AS LONG
DECLARE FUNCTION cbDBitOut LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortType&, BYVAL BitNum&, BYVAL BitValue&) AS LONG
DECLARE FUNCTION cbDConfigPort LIB "cbw32.dll" ALIAS "cbDConfigPort" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL Direction&) AS LONG
DECLARE FUNCTION cbDConfigBit LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL BitNum&, BYVAL Direction&) AS LONG
DECLARE FUNCTION cbDeclareRevision LIB "cbw32.dll" (RevNum!) AS LONG
DECLARE FUNCTION cbDIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, DataValue%) AS LONG
DECLARE FUNCTION cbDInScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL CBCount&, CBRate&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbDOut LIB "cbw32.dll" ALIAS "cbDOut" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL DataValue%) AS LONG
DECLARE FUNCTION cbDOutScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL CBCount&, CBRate&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbErrHandling LIB "cbw32.dll" (BYVAL ErrReporting&, BYVAL ErrHandling&) AS LONG
DECLARE FUNCTION cbFileAInScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, BYVAL CBCount&, CBRate&, BYVAL Gain&, BYVAL FILENAME$, BYVAL Options&) AS LONG
DECLARE FUNCTION cbFileGetInfo LIB "cbw32.dll" (BYVAL FILENAME$, LowChan%, HighChan%, PretrigCount&, TotalCount&, CBRate&, Gain&) AS LONG
DECLARE FUNCTION cbFilePretrig LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, PretrigCount&, CBCount&, CBRate&, BYVAL Gain&, BYVAL FILENAME$, BYVAL Options&) AS LONG
DECLARE FUNCTION cbFileRead LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL FirstPoint&, NumPoints&, DataBuffer%) AS LONG
DECLARE FUNCTION cbFlashLED LIB "cbw32.dll" (BYVAL BoardNum&) AS LONG
DECLARE FUNCTION cbGetErrMsg LIB "cbw32.dll" ALIAS "cbGetErrMsg" (BYVAL ErrCode&, BYVAL ErrMsg$) AS LONG
DECLARE FUNCTION cbGetRevision LIB "cbw32.dll" (DLLRevNum!, VXDRevNum!) AS LONG

'*****************************************************************************
'   Legacy Function Prototypes: to revert to legacy calls, un-comment the
'          prototypes immediately below.
'
'       Declare Function cbGetStatus Lib "cbw32.dll" (ByVal BoardNum&, Status%, CurCount&, CurIndex&) As Long
'       Declare Function cbStopBackground Lib "cbw32.dll" (ByVal BoardNum&) As Long
'
'   Remove the following if using the above legacy function prototypes.
DECLARE FUNCTION cbGetStatus LIB "cbw32.dll" ALIAS "cbGetIOStatus" (BYVAL BoardNum&, Status%, CurCount&, CurIndex&, BYVAL FunctionType&) AS LONG
DECLARE FUNCTION cbStopBackground LIB "cbw32.dll" ALIAS "cbStopIOBackground" (BYVAL BoardNum&, BYVAL FunctionType&) AS LONG
'*****************************************************************************

DECLARE FUNCTION cbMemSetDTMode LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Mode&) AS LONG
DECLARE FUNCTION cbMemReset LIB "cbw32.dll" (BYVAL BoardNum&) AS LONG
DECLARE FUNCTION cbMemRead LIB "cbw32.dll" (BYVAL BoardNum&, DataBuffer%, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG
DECLARE FUNCTION cbMemWrite LIB "cbw32.dll" (BYVAL BoardNum&, DataBuffer%, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG
DECLARE FUNCTION cbMemReadPretrig LIB "cbw32.dll" (BYVAL BoardNum&, DataBuffer%, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG
DECLARE FUNCTION cbRS485 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Transmit&, BYVAL Receive&) AS LONG
DECLARE FUNCTION cbTIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL CBScale&, TempValue!, BYVAL Options&) AS LONG
DECLARE FUNCTION cbTInScan LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL LowChan&, BYVAL HighChan&, BYVAL CBScale&, DataBuffer!, BYVAL Options&) AS LONG
DECLARE FUNCTION cbWinBufToArray LIB "cbw32.dll" (BYVAL MemHandle&, DataBuffer%, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG
DECLARE FUNCTION cbWinBufToArray32 LIB "cbw32.dll" (BYVAL MemHandle&, DataBuffer&, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG

DECLARE FUNCTION cbScaledWinBufAlloc LIB "cbw32.dll" (BYVAL NumPoints&) AS LONG
DECLARE FUNCTION cbScaledWinBufToArray LIB "cbw32.dll" (BYVAL MemHandle&, DataBuffer#, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG

DECLARE FUNCTION cbWinArrayToBuf LIB "cbw32.dll" (DataArray%, BYVAL MemHandle&, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG
DECLARE FUNCTION cbScaledWinArrayToBuf LIB "cbw32.dll" (DataArray#, BYVAL MemHandle&, BYVAL FirstPoint&, BYVAL CBCount&) AS LONG

DECLARE FUNCTION cbWinBufAlloc LIB "cbw32.dll" (BYVAL NumPoints&) AS LONG
DECLARE FUNCTION cbWinBufFree LIB "cbw32.dll" (BYVAL MemHandle&) AS LONG
DECLARE FUNCTION cbInByte LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&) AS LONG
DECLARE FUNCTION cbOutByte LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL PortVal%) AS LONG
DECLARE FUNCTION cbInWord LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&) AS LONG
DECLARE FUNCTION cbOutWord LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL PortNum&, BYVAL PortVal%) AS LONG

DECLARE FUNCTION cbWinBufAlloc32 LIB "cbw32.dll" (BYVAL NumPoints&) AS LONG
DECLARE FUNCTION cbWinBufAlloc64 LIB "cbw32.dll" (BYVAL NumPoints&) AS LONG
'*****************************************************************************
'   Legacy Function Prototypes: to revert to legacy calls, un-comment the
'          prototypes immediately below.
'
'      Declare Function cbGetConfig Lib "cbw32.dll" (ByVal InfoType&, ByVal BoardNum&, ByVal DevNum&, ByVal ConfigItem&, ByRef ConfigVal%) As Long
'
'   Remove the following if using the above legacy function prototypes.
DECLARE FUNCTION cbGetConfig LIB "cbw32.dll" (BYVAL InfoType&, BYVAL BoardNum&, BYVAL DevNum&, BYVAL ConfigItem&, BYREF ConfigVal&) AS LONG
'*****************************************************************************

DECLARE FUNCTION cbGetConfigString LIB "cbw32.dll" (BYVAL InfoType&, BYVAL BoardNum&, BYVAL DevNum&, BYVAL ConfigItem&, BYVAL ConfigVal$, BYREF MaxConfigLen&) AS LONG

DECLARE FUNCTION cbSetConfig LIB "cbw32.dll" (BYVAL InfoType&, BYVAL BoardNum&, BYVAL DevNum&, BYVAL ConfigItem&, BYVAL ConfigVal&) AS LONG

DECLARE FUNCTION cbSetConfigString LIB "cbw32.dll" (BYVAL InfoType&, BYVAL BoardNum&, BYVAL DevNum&, BYVAL ConfigItem&, BYVAL ConfigVal$, BYREF ConfigLen&) AS LONG

DECLARE FUNCTION cbToEngUnits LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Range&, BYVAL DataVal%, EngUnits!) AS LONG
DECLARE FUNCTION cbToEngUnits32 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Range&, BYVAL DataVal&, EngUnits#) AS LONG

DECLARE FUNCTION cbFromEngUnits LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Range&, BYVAL EngUnits!, DataVal%) AS LONG
DECLARE FUNCTION cbGetBoardName LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL BoardName$) AS LONG
DECLARE FUNCTION cbSetTrigger LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TrigType&, BYVAL LowThreshold%, BYVAL HighThreshold%) AS LONG
DECLARE FUNCTION cbEnableEvent LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL EventType&, BYVAL EventSize&, BYVAL CALLBACK AS LONG, BYREF UserData AS ANY) AS LONG
DECLARE FUNCTION cbDisableEvent LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL EventType&) AS LONG
DECLARE FUNCTION cbSelectSignal LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Direction&, BYVAL Signal&, BYVAL Connection&, BYVAL Polarity&) AS LONG
DECLARE FUNCTION cbGetSignal LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Direction&, BYVAL Signal&, BYVAL Index&, BYREF Connection&, BYREF Polarity&) AS LONG
DECLARE FUNCTION cbLogSetPreferences LIB "cbw32.dll" (BYVAL TimeFormat&, BYVAL TimeZone&, BYVAL Units&) AS LONG
DECLARE FUNCTION cbLogGetPreferences LIB "cbw32.dll" (BYREF TimeFormat&, BYREF TimeZone&, BYREF Units&) AS LONG
DECLARE FUNCTION cbLogGetFileName LIB "cbw32.dll" (BYVAL FileNum&, BYVAL Path$, BYVAL FILENAME$) AS LONG
DECLARE FUNCTION cbLogGetFileInfo LIB "cbw32.dll" (BYVAL FILENAME$, BYREF Version&, BYREF Size&) AS LONG
DECLARE FUNCTION cbLogGetSampleInfo LIB "cbw32.dll" (BYVAL FILENAME$, BYREF SampleInterval&, BYREF SampleCount&, BYREF StartDate&, BYREF StartTime&) AS LONG
DECLARE FUNCTION cbLogGetAIChannelCount LIB "cbw32.dll" (BYVAL FILENAME$, BYREF AICount&) AS LONG
DECLARE FUNCTION cbLogGetAIInfo LIB "cbw32.dll" (BYVAL FILENAME$, BYREF ChannelNumbers&, BYREF Units&) AS LONG
DECLARE FUNCTION cbLogGetCJCInfo LIB "cbw32.dll" (BYVAL FILENAME$, BYREF CJCChannelCount&) AS LONG
DECLARE FUNCTION cbLogGetDIOInfo LIB "cbw32.dll" (BYVAL FILENAME$, BYREF DIOChannelCount&) AS LONG
DECLARE FUNCTION cbLogReadTimeTags LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL StartSample&, BYVAL SampleCount&, BYREF Dates&, BYREF Times&) AS LONG
DECLARE FUNCTION cbLogReadAIChannels LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL StartSample&, BYVAL SampleCount&, BYREF AIChannelData!) AS LONG
DECLARE FUNCTION cbLogReadCJCChannels LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL StartSample&, BYVAL SampleCount&, BYREF CJCChannelData!) AS LONG
DECLARE FUNCTION cbLogReadDIOChannels LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL StartSample&, BYVAL SampleCount&, BYREF DIOChannelData&) AS LONG
DECLARE FUNCTION cbLogConvertFile LIB "cbw32.dll" (BYVAL FILENAME$, BYVAL DestFilename$, BYVAL StartSample&, BYVAL SampleCount&, BYVAL Delimiter&) AS LONG

DECLARE FUNCTION cbDaqInScan LIB "cbw32.dll" (BYVAL BoardNum&, ChanArray%, ChanTypeArray%, GainArray%, BYVAL ChanCount&, CBRate&, PretrigCount&, CBCount&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbDaqSetTrigger LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL TrigSource&, BYVAL TrigSense&, BYVAL TrigChan&, BYVAL ChanType&, BYVAL Gain&, BYVAL Level!, BYVAL Variance!, BYVAL TrigEvent&) AS LONG
DECLARE FUNCTION cbDaqOutScan LIB "cbw32.dll" (BYVAL BoardNum&, ChanArray%, ChanTypeArray%, GainArray%, BYVAL ChanCount&, CBRate&, BYVAL CBCount&, BYVAL MemHandle&, BYVAL Options&) AS LONG
DECLARE FUNCTION cbGetTCValues LIB "cbw32.dll" (BYVAL BoardNum&, ChanArray%, ChanTypeArray%, BYVAL ChanCount&, BYVAL MemHandle&, BYVAL FirstPoint&, BYVAL CBCount&, BYVAL CBScale&, TempValArray!) AS LONG
DECLARE FUNCTION cbDaqSetSetpoints LIB "cbw32.dll" (BYVAL BoardNum&, LimitAArray!, LimitBArray!, Reserved!, SetpointFlagsArray&, SetpointOutputArray&, Output1Array!, Output2Array!, OutputMask1Array!, OutputMask2Array!, BYVAL SetpointCount&) AS LONG

DECLARE FUNCTION cbVIn LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, DataValue!, BYVAL Options&) AS LONG
DECLARE FUNCTION cbVIn32 LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, DataValue#, BYVAL Options&) AS LONG
DECLARE FUNCTION cbVOut LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, BYVAL Gain&, BYVAL DataValue!, BYVAL Options&) AS LONG

DECLARE FUNCTION cbDeviceLogin LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL AccountName$, BYVAL Password$) AS LONG
DECLARE FUNCTION cbDeviceLogout LIB "cbw32.dll" (BYVAL BoardNum&) AS LONG

DECLARE FUNCTION cbTEDSRead LIB "cbw32.dll" (BYVAL BoardNum&, BYVAL Chan&, DataBuffer AS BYTE, CBCount&, BYVAL Options&) AS LONG

'#End If
