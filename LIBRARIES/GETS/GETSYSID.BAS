'Gets the ROM date and System ID

CONST SysIDSeg = &HF000
CONST SysIDOff = &HFFFE
CONST RDOffset = &HFFF5

DIM RomDate AS STRING

DEF SEG = SysIDSeg
SysID% = PEEK(SysIDOff)
RomDate = ""
FOR I% = 0 TO 7
   RomDate = RomDate + CHR$(PEEK(RDOffset + I%))
NEXT I%

PRINT "The system ID number is ";
PRINT HEX$(SysID%); " which is a ";

SELECT CASE SysID%
      CASE &HFF
          PRINT "PC"
      CASE &HFE, &HFB
          PRINT "PC/XT"
      CASE &HFD
          PRINT "PC Jr."
      CASE &HFC
          PRINT "PC/AT or PC/XT-286/386"
      CASE &HF9
          PRINT "PC Convertible"
      CASE ELSE
          PRINT "unlisted PC model"
END SELECT

PRINT "The ROM BIOS release date is ";
PRINT RomDate
END

