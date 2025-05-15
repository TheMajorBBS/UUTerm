DECLARE SUB hextodec (x%, inline$)
DECLARE SUB soundfx (sw%)
DECLARE SUB ermes (tp$, sw%)
DECLARE SUB sndstop ()
DECLARE SUB playvoc (filename$)
DECLARE SUB delay (x%)
DECLARE SUB cubeit (h%, v%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
DECLARE FUNCTION Exists% (filen$)
DECLARE FUNCTION DRAWSTR% (Mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION Iinkey$ (max%, row%, col%, fore%, sw%)
DECLARE FUNCTION RUCKDAC% (SEG packinfo AS ANY)
DECLARE SUB epalette (BYVAL PalReg%, BYVAL Colour%)

TYPE DeallocPackTYPE            'DP
 Func       AS INTEGER
 stat       AS INTEGER
 HandSeg    AS INTEGER          'RUCKUS allocates either XMM handle or DOS para
 TypeFlag   AS INTEGER          '0=DOS para, 1=XMS handle
END TYPE '8

TYPE InitPackTYPE               'IP
 Func       AS INTEGER
 stat       AS INTEGER
 DeviceID   AS INTEGER          '0=SPKR,1=LPTDAC,2=DSS,4=SB,5=SBPro
 IOport     AS INTEGER
 IRQline    AS INTEGER
 DMAch      AS INTEGER
 FLAGS      AS INTEGER          '(see source)
 InfoPtrOff AS INTEGER          'ret:far ptr to dac info
 InfoPtrSeg AS INTEGER
 DacExitPtrOff AS INTEGER       'ret:far ptr to dac's ExitXB routine
 DacExitPtrSeg AS INTEGER
 ModExitPtrOff AS INTEGER       'ret:far ptr to mod's ExitXB routine
 ModExitPtrSeg AS INTEGER
END TYPE '24

TYPE LoadPackTYPE               'LP
 Func       AS INTEGER
 stat       AS INTEGER
 FilenamePtrOff AS INTEGER      'far ptr to filenameZ to load
 FilenamePtrSeg AS INTEGER
 StartPos   AS LONG             'offset into file to start load at
 LoadSize   AS LONG             'number of bytes to load (or 0 for autosize)
 XMMflag    AS INTEGER          'if <> 0 use XMS for load
 XMMhandle  AS INTEGER          'ret:XMS handle, or
 LoadPtrOff AS INTEGER          'ret:DOS seg:offset (offset always 0)
 LoadPtrSeg AS INTEGER
END TYPE '20

TYPE PlaybackPackTYPE           'PBP
 Func       AS INTEGER
 stat       AS INTEGER
 Mode       AS INTEGER          'playback mode (0=interrupt FG,1=BG,2=DMA,3=DMA+BG for mod)
 XMMhandle  AS INTEGER          'if <> 0 this XMM handle used regardless
 LoadPtrOff AS INTEGER          'seg:off to start of data to play
 LoadPtrSeg AS INTEGER
 BufferSize AS INTEGER          'size of DMA buffer for mod playback
END TYPE '14

TYPE SetPackTYPE                'SP
 Func       AS INTEGER
 stat       AS INTEGER          ' (if volume=0 SB speaker off'ed else on'ed)
 Volume     AS INTEGER          'volume (left ch=MSB,right=LSB) (0-127,0-127)
 IntRate    AS INTEGER          'playback interrupt rate (5000-23000)
 Priority   AS INTEGER          'priority level (0-2, default=1)
END TYPE '18

TYPE XitPackTYPE                'XP
 Func       AS INTEGER
 stat       AS INTEGER
END TYPE '4

TYPE SysInfoPackTYPE            'SIP
 Func       AS INTEGER          '
 stat       AS INTEGER
 CPU        AS INTEGER          'CPU class (88,286,386,486)
 CPUmode    AS INTEGER          '0=real mode,1=PM,2=PM w/paging
 MHz        AS INTEGER          'approx speed (5,20,33)
 Device0    AS INTEGER          '=1 speaker available
 D0port     AS INTEGER          '42h
 D0IRQ      AS INTEGER          'n/a
 D0DMA      AS INTEGER          'n/a
 D0flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
 Device1    AS INTEGER          '=1 LPT-DAC available on LPT1
 D1port     AS INTEGER          'port of _first_ LPT found in BIOS data area
 D1IRQ      AS INTEGER          'n/a
 D1DMA      AS INTEGER          'n/a
 D1flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
 Device2    AS INTEGER          '=1 Disney Sound Source available
 D2port     AS INTEGER          'port of DSS
 D2IRQ      AS INTEGER          'n/a
 D2DMA      AS INTEGER          'n/a
 D2flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
 Device3    AS INTEGER          '=1 AdLib available
 D3port     AS INTEGER          '388h
 D3IRQ      AS INTEGER          'n/a
 D3DMA      AS INTEGER          'n/a
 D3flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
 Device4    AS INTEGER          '=1 SB available
 D4port     AS INTEGER          'port of SB
 D4IRQ      AS INTEGER          'IRQ
 D4DMA      AS INTEGER          'DMA
 D4flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
 Device5    AS INTEGER          '=1 SBPro available
 D5port     AS INTEGER          'port of SBPro
 D5IRQ      AS INTEGER          'IRQ
 D5DMA      AS INTEGER          'DMA
 D5flags    AS INTEGER          'bit4=MIDI/3=XMS/2=DMA/1=REC/0=PLAY
END TYPE '70
CONST SysInfoDac = 0, InitDac = 1, ExitDac = 2, AtExitDac = 3
CONST LoadDac = 4, PlayDac = 5, RecordDac = 6
CONST StoreDac = 7, EndDac = 8, PauseDac = 9
CONST DeallocDac = 10
CONST SetAllDac = 20, SetVolumeDac = 21, SetIntRateDac = 22, SetPriorityDac = 23
CONST GetBufferDataDac = 28, GetBytePosDac = 29
CONST SetAllSBP = 30, SetVolMainSBP = 31, SetVolVocSBP = 32
CONST SetLevelMicSBP = 33, SetLevelCDSBP = 34, SetLevelLineSBP = 35
CONST SetFilterOutSBP = 36, SetFilterInSBP = 37
CONST SetSourceSBP = 38, SetStereoSBP = 39
CONST SetSpeakerSB = 40
CONST GetMixerRegSBP = 48, GetDacSB = 49
CONST gig1 = "MB T255 MS O3"
CONST beepit = "MB MS O4 L30 AGB"
CONST gig2 = "MB T255 MS O1 L64"

DEFINT A-Z
'$DYNAMIC
COMMON SHARED snd%, snddev, xmsflag
DIM SHARED SIP AS SysInfoPackTYPE
DIM SHARED IP AS InitPackTYPE
DIM SHARED LP AS LoadPackTYPE
DIM SHARED SP AS SetPackTYPE
DIM SHARED PBP AS PlaybackPackTYPE
DIM SHARED DP AS DeallocPackTYPE
DIM SHARED XP AS XitPackTYPE

REM $STATIC
SUB closesnd
XP.Func = ExitDac       'shut down RUCKDAC and end program
x = RUCKDAC(XP)
END SUB

SUB destruct (spce, maxline, cl, menusav())
IF spce = 0 OR spce = 2 THEN EXIT SUB
PCOPY 0, 1
IF maxline = 24 THEN v = 201 ELSE v = 331
GET (2, v)-(637, 349), menusav
SCREEN 9, , 1, 0
PUT (4, v), menusav, PSET
SCREEN 9, , 0, 1
PUT (0, v), menusav, PSET
SCREEN 9, , 1, 1
PAINT (100, 100), cl, 15
FOR z = 1 TO 20
  SCREEN 9, , 1, 1
  FOR x = 1 TO 5000: NEXT x
  SCREEN 9, , 0, 0
  FOR x = 1 TO 6050: NEXT x
NEXT z
SCREEN 9, , 0, 0
PUT (2, v), menusav, PSET
IF maxline = 24 THEN LINE (0, 202)-(0, 348), 15 ELSE LINE (0, 332)-(0, 348), 15
END SUB

SUB disrupt (spce, menusav())
IF spce = 0 OR spce = 2 THEN EXIT SUB
GET (400, 0)-(600, 150), menusav
v = 106: h = 500
colr = 4: GOSUB expl
colr = 12: GOSUB expl
PUT (400, 0), menusav, PSET
EXIT SUB
expl:
radius = 50
FOR x = 1 TO radius
  CIRCLE (h, v), x, colr
NEXT
FOR x = 1 TO radius
  CIRCLE (h, v), x, 0
NEXT
RETURN
END SUB

SUB flash (maxline, spce)
IF spce = 0 OR spce = 2 THEN EXIT SUB
PCOPY 0, 1
SCREEN 9, , 1, 0
PAINT (320, 100), 15, 7
SCREEN 9, , 0, 1
delay 3
SCREEN 9, , 0, 0
END SUB

SUB initsb
i = 1
DO UNTIL UCASE$(LEFT$(ENVIRON$(i), 8)) = "BLASTER="
  i = i + 1
  IF ENVIRON$(i) = "" THEN EXIT DO
LOOP
inline$ = UCASE$(ENVIRON$(i))
IF inline$ = "" THEN
  snddev = 0
ELSE
  DaPort = VAL("&H" + MID$(inline$, INSTR(8, inline$, "A") + 1, 3))
  DaIrq = VAL(MID$(inline$, INSTR(8, inline$, "I") + 1, 2))
  DaDMA = VAL(MID$(inline$, INSTR(8, inline$, "D") + 1, 1))
  DaType = VAL(MID$(inline$, INSTR(8, inline$, "T") + 1, 1))
  IF DaType = 4 THEN snddev = 5 ELSE snddev = 4
  IF DaIrq = 10 THEN snddev = 5
END IF
IF snddev = 0 THEN EXIT SUB
'
IP.Func = InitDac              'initializes sound card
IP.DeviceID = snddev
IP.IOport = DaPort
IP.IRQline = DaIrq
IP.DMAch = DaDMA
IP.FLAGS = &H40
stat = RUCKDAC(IP)
IF stat = 0 THEN
   XP.Func = AtExitDac
   x = RUCKDAC(XP)
   IF x THEN snddev = 0
END IF
END SUB

SUB phaser (spce, menusav(), cl)
IF spce = 0 OR spce = 2 THEN EXIT SUB
GET (0, 0)-(639, 150), menusav
w = 240: h = 200
FOR z = 0 TO 95
  LINE (h, z)-(h + w, z), cl
  h = h + 1: w = w - 2
NEXT z
PUT (0, 0), menusav, PSET
delay 1
END SUB

SUB playvoc (filename$)
IF snd = 0 OR snddev = 0 THEN EXIT SUB
filename$ = filename$ + ".snd"
IF NOT Exists(filename$) THEN EXIT SUB
sndstop
'
IF xmsflag = 1 THEN
  x& = 17000
ELSE
  x = FREEFILE
  OPEN "I", x, filename$
  x& = LOF(x) + 100
  CLOSE #x
END IF
nix& = SETMEM(-x&)
IF FRE("") < 2000 THEN nix& = SETMEM(x&): EXIT SUB
'
filename$ = filename$ + CHR$(0)
LP.Func = LoadDac
LP.FilenamePtrOff = SADD(filename$)    'QB format
LP.FilenamePtrSeg = VARSEG(filename$)
LP.StartPos = 0&     'start load at byte 0 of filename$
LP.LoadSize = 0&     'load entire file
LP.XMMflag = xmsflag 'load into DOS or XMS memory
stat = RUCKDAC(LP)
IF stat <> 0 THEN sndstop: EXIT SUB
'
'immediately after load, but before play if non-DMA, we can peek
DEF SEG = IP.InfoPtrSeg
bp = IP.InfoPtrOff
fileSR& = 256 * PEEK(bp + 25) + PEEK(bp + 24)
IF fileSR& < 0 THEN fileSR& = fileSR& + 65536
DEF SEG
'
'data is loaded, if device is a Sound Blaster, use DMA at
PBP.Func = PlayDac
IF snddev >= 4 THEN
  PBP.Mode = 2
ELSE
  SP.Func = SetIntRateDac
      'to play hal.voc using PCSPKR1 (the hi-rez mode) set
      'SP.IntRate=8463. This results in an upsample rate of 17045Hz
  IF fileSR& < 11025 THEN     'if the recorded sample rate is <11025
    SP.IntRate = fileSR&     'according to the VOC or WAVE file hdr
  ELSE                        'then just go ahead and use that, else
    SP.IntRate = 8000        'down sample to 8000 (or closest fit)
  END IF
  stat = RUCKDAC(SP)
  IF stat THEN snddev = 0: sndstop: EXIT SUB
  PBP.Mode = 1
END IF
'
IF LP.XMMflag = 0 THEN
  PBP.XMMhandle = 0
  PBP.LoadPtrOff = LP.LoadPtrOff
  PBP.LoadPtrSeg = LP.LoadPtrSeg
ELSE
  PBP.XMMhandle = LP.XMMhandle
  PBP.LoadPtrOff = 0
  PBP.LoadPtrSeg = 0
  IF PBP.Mode < 2 THEN PRINT "error loading into XMS.": EXIT SUB
END IF
stat = RUCKDAC(PBP)
IF xmsflag = 1 THEN nix& = SETMEM(70000)
END SUB

SUB sndstop
XP.Func = EndDac              'stops it
stat = RUCKDAC(XP)
'
DP.Func = DeallocDac           'release memory used by LoadDac
IF LP.XMMflag = 0 THEN
  DP.HandSeg = LP.LoadPtrSeg
  DP.TypeFlag = 0
ELSE
  DP.HandSeg = LP.XMMhandle
  DP.TypeFlag = 1
END IF
stat = RUCKDAC(DP)
IF xmsflag <> 1 THEN x& = SETMEM(70000)
END SUB

SUB soundfx (sw)
IF snddev = 0 THEN
  IF snd = 0 THEN EXIT SUB
  SELECT CASE sw
    CASE 1, 8          'mines
      y% = 30
      FOR x% = 700 TO 40 STEP -10
        SOUND x%, .1: y% = y% + 10: SOUND y%, .1
      NEXT x%
    CASE 2        'transwarp drive
      PLAY gig2
      y% = 14
      FOR z = 1 TO 4
        FOR x = 0 TO 20
          k = INT((RND * y) + 1)
          PLAY "N" + STR$(k)
        NEXT x
        y% = 1.3 * y%
      NEXT z
      PLAY "MB O6 L22 ML CDEFGA"
    CASE 3          'phasers
      FOR J = 1 TO 5
        FOR i = 1000 TO 400 STEP -10
          SOUND i, .025
        NEXT
      NEXT
      FOR i = 399 TO 100 STEP -10
        SOUND i, .03
      NEXT
    CASE 4                   'genesis
      PLAY gig1 + "L32"
      PLAY "cdefgagg L64 aagagfedc ML O2 L24 edccc"
    CASE 5               'explosion
      PLAY gig2
      y% = 14
      FOR z = 1 TO 4
        FOR x = 0 TO 20
          k = INT((RND * y) + 1)
          PLAY "N" + STR$(k)
        NEXT x
        y% = 1.2 * y%
      NEXT z
      PLAY "ML dd O0 cc"
    CASE 6                    'replace beep
      PLAY beepit
    CASE 7
      FOR x = 1000 TO 1200 STEP 100
        SOUND x, .15
      NEXT
    CASE 9
      PLAY "MB T75 ML O6 L64 abdcgaedbfgface"
    CASE 10                'tearing noise
      FOR x = 1 TO 18
        SOUND RND * 500 + 37, .1
      NEXT x
    CASE 11
      PLAY ">>": PLAY "O0MST180G8P8.MNA16P32MSB-8.P32G"
  END SELECT
ELSE
  SELECT CASE sw
    CASE 1
      IF snd <> 0 THEN
      y% = 30
      FOR x% = 700 TO 40 STEP -10
        SOUND x%, .1: y% = y% + 10: SOUND y%, .1
      NEXT x%
      END IF
    CASE 2
      playvoc "uutwarp"
    CASE 4
      playvoc "uuTgenis"
    CASE 6
      IF snd <> 0 THEN PLAY beepit
    CASE 7
      playvoc "uutbuton"
    CASE 8
      playvoc "uutbuz"
    CASE 9     'bounced off warp shielding
      playvoc "uutran"
    CASE 11
      playvoc "uutcabal"
  END SELECT
END IF
END SUB

