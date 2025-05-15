DECLARE FUNCTION GetBaudRate% (PORT%)
DEFINT A-Z

'finds baudrate connected at

a% = GetBaudRate%(1)
b% = GetBaudRate%(2)
PRINT a%, b%
END

FUNCTION GetBaudRate% (PORT%)

IF (PORT% <> 1 AND PORT% <> 2) THEN
   GetBaudRate% = -1
   EXIT FUNCTION
END IF

ADDR = &H4F8 - (&H100 * PORT)            ' base address of port reg's
ADDR.LCR = ADDR + 3                      ' Line Control Register
ADDR.DL.LSB = ADDR + 0: ADDR.DL.MSB = ADDR + 1' Divisor Latch LSB & MSB
VAL.LCR = INP(ADDR.LCR)                  ' get old LCR value
OUT ADDR.LCR, VAL.LCR AND &H7F           ' Disable DLAB to get to inters
VAL.INT = INP(ADDR.DL.MSB)               ' Get the int enable statuses
OUT ADDR.DL.MSB, 0                        ' Disable all modem intertupts
OUT ADDR.LCR, VAL.LCR OR &H80            ' Enable DLAB to gain access

'get the current baud rate

MSB = INP(ADDR.DL.MSB)
LSB = INP(ADDR.DL.LSB)'get old baud rate
DIVISOR = MSB * 2 ^ 8 + LSB

OUT ADDR.LCR, VAL.LCR AND &H7F    ' Disable DLAB to get to inters
OUT ADDR.DL.MSB, VAL.INT          ' Replace orig. inter. values
OUT ADDR.LCR, VAL.LCR             ' Replace orig. LCR values

GetBaudRate% = (1843200! / DIVISOR) / 16
END FUNCTION

