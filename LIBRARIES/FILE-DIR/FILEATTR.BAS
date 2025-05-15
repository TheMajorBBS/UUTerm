'Routine For Setting The File's Attribute
'     To Check For A File's Existance You Only Need Use The "Get Attribute"
'     routine. Its Only About 12 or 13 Lines Of Code.
      
     '*********************************************************************
     ' This Code Is QB 4.5
     '
     ' I have Included Functions For Getting And Setting File Attributes
     ' You Should Always Get The Attribute First So That You Only Toggle
     ' The Attribute You Want And Leave Any Other Attributes Alone.
     ' Both Functions Return the Same Error Codes, GetFileAttribute%
     ' Returns The Error In ReturnCode% And The Attribute In It's Name
     ' While Function SetFileAttribute% Returns The Error Code In It's
     ' Name.
     ' Error Codes Are As Follows:
     '       1 = Invalid Function (Networks Only)
     '       2 = File Not Found
     '       3 = Path Not Found
     '       5 = Access Denied (NetWorks Only)
     ' Have You Guessed That GetFileAttribute Would Be Ideal For Checking
     ' For A Path Or File's Existance??? Only 13 Lines Of Code.
     ' Usage:
     '       Attribute% = GetFileAttribute% (FileName$,ReturnCode%)
     '               FileName$ Can Include Full Path Names
     '               ReturnCode% Will Be One Of The Above Or 0
     '               The File Attribute Is Returned In The Function Name
     '
     '      ErrorCode% = SetFileAttribute%(FileName$,FileAttribute%,Attrb$)
     '               FileName$ Can Include Full Path Names
     '               FileAttribute% Is The Attribute You Wish To Change
     '               Attrb$ Is One Or All Of The Following Characters
     '                       A = Archive
     '                       S = System
     '                       H = Hidden
     '                       R = Read Only
     '               Will Accept Characters Of Any Case
     '
     ' I Have Included A SIMPLE Demo With No Error Checking Routine....
     ' And It Will' Continue To Toggle The Attribute As Desired Until You
     ' Press Enter Or Escape.
'==========================================================================

     DECLARE FUNCTION GetFileAttribute% (FileName$, ReturnCode%)
     DECLARE FUNCTION SetFileAttribute% (FileName$, FileAttribute%, Attrib$)
     '$INCLUDE: 'qb.bi'
      
     FileName$ = COMMAND$                            'Get The Name Easy
      
     IF FileName$ = "" THEN
	     INPUT "Enter file name "; FileName$     'Or get it direct
     END IF
      
     CLS                                             'Clear the screen
      
start:                                               'OH GOD A LABEL!!!!
      
     Attrb$ = STRING$(4, 95)                         'Set up the blanks
     FAttrb% = GetFileAttribute%(FileName$, RC%)     'Get the attribute
						   'And set string properly
      
     IF (FAttrb% AND 1) = 1 THEN MID$(Attrb$, 1, 1) = "R"
     IF (FAttrb% AND 2) = 2 THEN MID$(Attrb$, 2, 1) = "H"
     IF (FAttrb% AND 4) = 4 THEN MID$(Attrb$, 3, 1) = "S"
     IF (FAttrb% AND &H20) = &H20 THEN MID$(Attrb$, 4, 1) = "A"
      
     mess$ = FileName$ + "  " + Attrb$          ' Show the name and current
						     ' file attribute
     LOCATE 1, 1
     PRINT mess$                                     'And print it
      
     IF RC% = 0 THEN                                'Check for error and if
						     'none go on and toggle
      
     Ans$ = INPUT$(1)                              'Get attribute to toggle
						     'or request to exit
      
     IF Ans$ = CHR$(27) OR Ans$ = CHR$(13) THEN SYSTEM
	     RC% = SetFileAttribute%(FileName$, FAttrb%, Ans$)     'TOGGLE
	     Ans$ = ""                                             'Clear
	     GOTO start                              'OH GOD A GOTO!!!!!
     ELSE
	     PRINT "Error #" + LTRIM$(STR$(RC%))   'Yep, and error so print
						     'code and exit
	     SYSTEM
     END IF

     FUNCTION GetFileAttribute% (FileName$, ReturnCode%)
     '*********************************************************************
     'Now To The Meat Of Things... This Will Quickly Tell If A File Exists
     'Or Not.
     '*********************************************************************
      
     DIM InRegs AS RegTypeX, OutRegs AS RegTypeX     'Dimension Register
						     'Types
     FileToSet$ = FileName$ + CHR$(0)                'Make ASCIIZ String
						     'From File Name
     ReturnCode% = 0                                 'Zero Return Code
      
     InRegs.ax = (256 * &H43) + &H0                  'Set Function Number
     InRegs.ds = VARSEG(FileToSet$)                  'Pass Segment Of Name
     InRegs.dx = SADD(FileToSet$)                    'Pass Offset Of Name
     CALL INTERRUPTX(&H21, InRegs, OutRegs)          'Call Interrupt 21
      
     IF (OutRegs.flags AND 1) = 0 THEN               'Is There Any Errors?
      
	     GetFileAttribute% = OutRegs.cx         'Nope..Return Attribute
     ELSE
	     ReturnCode% = OutRegs.ax                'Yep! Pass Error Code
     END IF
     END FUNCTION

     FUNCTION SetFileAttribute% (FileName$, FileAttribute%, Attrib$)
      
     DIM InRegs AS RegTypeX, OutRegs AS RegTypeX    'Dimension Register
						    'Types
     Attrib$ = UCASE$(Attrib$)                      'Make Sure It's
						    'Upper Case
     FileToSet$ = FileName$ + CHR$(&H0)             'Convert Name to
						    'ASCIIZ
     FOR i = 1 TO LEN(Attrib$)                      'Toggle All The
						    'Any Selected
     SELECT CASE MID$(Attrib$, i, 1)                'Attributes
      
     CASE IS = "R"
	     FileAttribute% = FileAttribute% XOR &H1 'Toggle Read Only
     CASE IS = "H"
	     FileAttribute% = FileAttribute% XOR &H2 'Toggle Hidden
     CASE IS = "S"
	     FileAttribute% = FileAttribute% XOR &H4 'Toggle System
     CASE IS = "A"
	     FileAttribute% = FileAttribute% XOR &H20'Toggle Archive
     END SELECT
     NEXT i
     
     InRegs.ax = (256 * &H43) + &H1                  'Load Set Function
     InRegs.cx = FileAttribute%                      'Attribute To Set
     InRegs.ds = VARSEG(FileToSet$)                  'Pass Segment
     InRegs.dx = SADD(FileToSet$)                    'Pass Offset
     CALL INTERRUPTX(&H21, InRegs, OutRegs)          'Call Interrupt 21
     
     IF (OutRegs.flags AND 1) <> 0 THEN              'Is There An Error?
	     SetFileAttribute% = OutRegs.ax          'Yep! Pass Error
     ELSE                                            'Nope..Pass Zero
	     SetFileAttribute% = 0
     END IF
     
     END FUNCTION

