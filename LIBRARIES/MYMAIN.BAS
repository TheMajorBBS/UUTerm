'this is the actual main module code of my terminal programs
'It's here as an example of what you'll need to creat your own

'Thes routines are in a 3rd party library called QBSerial. D/l it from
'your local BBS. QBSER30.ZIP is the latest I believe.
  DECLARE FUNCTION CarrierLost% CDECL ALIAS "_carrier_state" ()
  DECLARE SUB OpenComm CDECL ALIAS "_open_comm" (BYVAL port%, irq%, BYVAL Wlen%, BYVAL parity%, BYVAL baud&, BYVAL hs%, BYVAL FOSSIL%)
  DECLARE SUB closecomm CDECL ALIAS "_close_comm" ()
  DECLARE FUNCTION ReadChar% CDECL ALIAS "_readchar" ()
  DECLARE SUB transmit CDECL ALIAS "_transmit_string" (addr$)
  DECLARE FUNCTION DataWaiting% CDECL ALIAS "_data_waiting" ()

TYPE RegTypeX
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  DS    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED inregs AS RegTypeX, outregs AS RegTypeX
DECLARE SUB InterruptX (intnum AS INTEGER, inregs AS RegTypeX, outregs AS RegTypeX)
CONST dos = &H21
CONST SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00

DEFINT A-Z
'put your COMMON SHARED variables here

'$DYNAMIC
'Put your DIM SHARED variables here

'define other variables here

'put any DATA statements here

RANDOMIZE TIMER

'do your initialization routine here. Check for graphic card, open and load
'any configuration files, create and display main screen, open com port
'etc..

LOCATE 1, 1
IF CarrierLost% <> 1 THEN LOCATE 1, 1, 1: transmit CHR$(13)
fore0 = 7
DO                              ' Main communications loop.
  keyin$ = INKEY$
  IF CarrierLost% THEN Nocary
  IF keyin$ = CHR$(24) THEN   'CNTRL X  this is the key I use to exit
    BEEP
    nz = DRAWSTR%(0, "Do you really want to exit TWTERM?  Y/N", 164, 337, 14, 9, 8)
    DO: keyin$ = UCASE$(INKEY$): LOOP UNTIL keyin$ <> ""
    IF keyin$ = "Y" THEN EXIT DO
    LINE (4, 336)-(634, 344), 9, BF
  END IF

  'if the user doesn't want to exit, then here is where you will
  'process any other key they may have pressed
  IF LEN(keyin$) = 2 THEN    'if it's an ALT keys
    'dooptions keyin$, port, hs      'add your own routine
  ELSEIF keyin$ <> "" THEN  'if it's any other key
    'ckey keyin$, port, hs           'add your own routine
  END IF

  DO WHILE DataWaiting
    modemin$ = CHR$(ReadChar)
    emul modemin$   'does the ANSI emulator
  LOOP
LOOP
closecomm
CLOSE

savecfg "out", port, hs  'save configurations
IF regit = 0 THEN reg    'if not a registered user, display reg screen

SCREEN 0                'reset to text mode
CLS
WIDTH 80, 25
END

