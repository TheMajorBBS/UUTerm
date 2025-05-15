'performs a warm boot
TYPE RegType
   AX AS INTEGER
   BX AS INTEGER
   CX AS INTEGER
   DX AS INTEGER
   BP AS INTEGER
   SI AS INTEGER
   DI AS INTEGER
   FLAGS AS INTEGER
END TYPE
 
DIM InRegs AS RegType, OutRegs AS RegType
 
CALL Interrupt(CINT(&H19), InRegs, OutRegs)

