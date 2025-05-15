'Shell and automatically return to orig dir
     DEFINT A-Z
     
     TYPE RegType2
          AX    AS INTEGER
          BX    AS INTEGER
          CX    AS INTEGER
          DX    AS INTEGER
          BP    AS INTEGER
          SI    AS INTEGER
          DI    AS INTEGER
          Flags AS INTEGER
          DS AS INTEGER
          ES AS INTEGER
     END TYPE
     
     'You must link with QB.LIB (QB.QLB) to use Interrupt functions
     
     DECLARE SUB InterruptX (Intr%, InReg AS RegType2, OutReg AS RegType2)
     DECLARE SUB DoShell (Before$, Args$, After$)
     
     DoShell "Type EXIT to return", "", "Welcome back"   'Just to test it
     END

     SUB DoShell (Before$, Args$, After$) 'Declare some stuff to use
     
     DIM InReg AS RegType2
     DIM OutReg AS RegType2
     DIM CurrentDrive AS INTEGER
     DIM CurrentDir AS STRING * 64
     
     'Get current disk drive
     InReg.AX = &H19 * 256
     InterruptX &H21, InReg, OutReg
     CurrentDrive = OutReg.AX MOD 256
     
     'Get current directory
     InReg.AX = &H47 * 256
     InReg.DX = CurrentDrive + 1  'Note adding one to drive for this, or
                                  'could use 0 for default drive
     InReg.DS = VARSEG(CurrentDir)
     InReg.SI = VARPTR(CurrentDir)
     InterruptX &H21, InReg, OutReg
     
     'Do the shell
     IF Before$ <> "" THEN CLS : PRINT Before$  'Optional
     SHELL Args$
     IF After$ <> "" THEN CLS : PRINT After$    'Optional
     
     'Change to old disk drive
     InReg.AX = &HE * 256
     InReg.DX = CurrentDrive
     InterruptX &H21, InReg, OutReg
          '(InReg.AX MOD 256 is the # of logical drives in the
          'system if anyone is interested)
     
     'Change to old subdirectory (Could use Int &H21 func &H3B instead)
     ToDir$ = CHR$(ASC("A") + CurrentDrive) + ":\" + LEFT$(CurrentDir, INSTR(CurrentDir, CHR$(0)))
     CHDIR ToDir$
     
     END SUB

