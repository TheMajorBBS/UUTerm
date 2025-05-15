DECLARE SUB icon (h%, v%, wd%, ht%, C1%, c2%, fild%, outin%)
DECLARE SUB mousepointer (OnOff%)
DECLARE SUB openwindow (sw%)
DECLARE SUB cubeit (h%, v%, wd%, ht%, C1%, c2%, fild%)
DECLARE SUB metal (pattern$)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION Exists% (FileName$)

SUB config (a%, soundx%, linport$, anim$)
icon 370, 305, 56, 18, 15, 8, 7, 1
icon 500, 305, 56, 18, 15, 8, 7, 1
icon 500, 193, 56, 17, 8, 15, 11, 0
icon 500, 221, 56, 17, 8, 15, 11, 0
icon 500, 249, 56, 17, 8, 15, 11, 0
icon 500, 277, 56, 17, 8, 15, 11, 0
cl = 0 + 128 XOR 7: COLOR cl
LOCATE 15, 43: PRINT "ouse Speed (1-9)";
LOCATE 17, 55: PRINT "ound";
LOCATE 19, 51: PRINT "ine Port";
LOCATE 21, 45: PRINT "nimation Speed";
LOCATE 23, 65: PRINT "Sa e";
LOCATE 23, 50: PRINT "one";
cl = 4 + 128 XOR 7: COLOR cl
LOCATE 15, 42: PRINT "M";
LOCATE 17, 54: PRINT "S";
LOCATE 19, 50: PRINT "L";
LOCATE 21, 44: PRINT "A";
LOCATE 23, 67: PRINT "V";
LOCATE 23, 49: PRINT "D";
IF soundx% = 1 THEN mssg$ = "On" ELSE mssg$ = "Off"
cl = 1 + 128 XOR 11: COLOR cl
LOCATE 15, 65: PRINT a%
LOCATE 17, 66: PRINT mssg$
LOCATE 19, 65: PRINT linport$
LOCATE 21, 65: PRINT anim$
END SUB

SUB helpscreen (sw$)
LINE (310, 60)-(608, 327), 0, BF
COLOR 12, 0: LOCATE 8, 52: PRINT "様様様様様様様"
SELECT CASE sw$
CASE "D"
  COLOR 10, 0: LOCATE 7, 54: PRINT "PRINT MENU"
  COLOR 11, 0
  LOCATE 11, 41: PRINT "Print files that UUDEVICE has saved"
  LOCATE 12, 41: PRINT "to disk. "
  LOCATE 14, 41: PRINT "If you want to print the Picklist"
  LOCATE 15, 41: PRINT "currently in memory,  then please"
  LOCATE 16, 41: PRINT "save to disk first with the SAVE"
  LOCATE 17, 41: PRINT "option in the PICKLIST menu."
  LOCATE 19, 41: PRINT "You can print: List of Devices "
  LOCATE 20, 41: PRINT "(.NAM file), groups of related"
  LOCATE 21, 41: PRINT "Devices (.DEV) or Picklists (.LST)."
CASE "P"
  COLOR 10, 0: LOCATE 7, 53: PRINT " DEVICE MENU"
  COLOR 9, 0
  LOCATE 9, 41: PRINT "  Use this option when you need to"
  LOCATE 10, 41: PRINT " find a device that fits a certain"
  LOCATE 11, 41: PRINT "             purpose."
  COLOR 11, 0
  LOCATE 13, 41: PRINT "   You can search by text string."
  LOCATE 14, 41: PRINT "Ex: Enter 'sensor' to find devices"
  LOCATE 15, 41: PRINT "that pertain to sensors. This one"
  LOCATE 16, 41: PRINT "is case sensitive, so 'warp' and  "
  LOCATE 17, 41: PRINT "'Warp' will give 2 different lists"
  LOCATE 19, 41: PRINT "   You can search by price to find"
  LOCATE 20, 41: PRINT "an item by price range. Examples:"
  LOCATE 21, 41: PRINT ">400000<500000 list items in range"
  LOCATE 23, 41: PRINT "Or search thru the devices by name."
CASE "S"
  COLOR 10, 0: LOCATE 7, 52: PRINT "PICKLIST  MENU"
  COLOR 11, 0
  LOCATE 10, 41: PRINT "The picklist is a neat feature that"
  LOCATE 11, 41: PRINT "works like a TSR.  Whenever you see"
  LOCATE 12, 41: PRINT "a device that you would like to buy"
  LOCATE 13, 41: PRINT "hit the INSERT key  or  right mouse"
  LOCATE 14, 41: PRINT "button  to enter that device into"
  LOCATE 15, 41: PRINT "your Picklist."
  LOCATE 17, 41: PRINT "Whenever you would like to see what"
  LOCATE 18, 41: PRINT "is in your Picklist, go to the MAIN"
  LOCATE 19, 41: PRINT "MENU and choose the PICKLIST option"
  LOCATE 21, 41: PRINT "Also you can create a macro for use"
  LOCATE 22, 41: PRINT "in UU with the MACRO feature."
CASE "T"
  COLOR 10, 0: LOCATE 7, 53: PRINT "CONVERT MENU"
  COLOR 11, 0
  LOCATE 9, 41: PRINT "This option only appears on the"
  LOCATE 10, 41: PRINT "MAIN MENU when UUDEVICE can't find"
  LOCATE 11, 41: PRINT "a database to work with."
  LOCATE 13, 41: PRINT "To create the database UUDEVICE"
  LOCATE 14, 41: PRINT "needs to work with, simply put the"
  LOCATE 15, 41: PRINT "DEVICE.DOC file that comes with UU"
  LOCATE 16, 41: PRINT "in the same directory as this"
  LOCATE 17, 41: PRINT "program. Then run the CONVERT"
  LOCATE 18, 41: PRINT "option to make the database."
  LOCATE 20, 41: PRINT "To free up disk space, when CONVERT"
  LOCATE 21, 41: PRINT "is done it can erase DEVICE.DOC"
  LOCATE 22, 41: PRINT "since the new database DEVICE.CON"
  LOCATE 23, 41: PRINT "will be it's replacement."

CASE "X"
  COLOR 10, 0: LOCATE 7, 54: PRINT "XTRAS MENU"
  COLOR 14, 0: LOCATE 9, 41: PRINT "Exit UUDEVICE"
  LOCATE 12, 41: PRINT "Shell To DOS"
  LOCATE 15, 41: PRINT "Configuration Menu"
  LOCATE 19, 41: PRINT "Registration Info"
  COLOR 11, 0
  LOCATE 10, 41: PRINT "Shut down system and return to DOS"
  LOCATE 13, 41: PRINT "Allows use of DOS commands"
  LOCATE 16, 41: PRINT "Customize UUDEVICE settings for"
  LOCATE 17, 41: PRINT "your system"
  LOCATE 20, 41: PRINT "Learn how to register UUDEVICE and"
  LOCATE 21, 41: PRINT "get in on the many extra benifits"
END SELECT
END SUB

SUB metal (pattern$)
  pattern$ = CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(124)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(195) + CHR$(195) + CHR$(195) + CHR$(124)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)

END SUB

SUB openconfig (timin%, soundx%, sw$)
IF soundx% = 1 THEN
  hum$ = "mb l32 o0 cccc"
  PLAY hum$
END IF
IF sw$ = "O" THEN
  FOR x% = 313 TO 190 STEP -15          'open
    icon 308, x%, 304, 14, 7, 7, 7, 7
    FOR Y = 1 TO timin%: NEXT Y
  NEXT x%
  icon 308, 178, 304, 14, 7, 7, 7, 7
ELSE
  FOR x% = 178 TO 320 STEP 15
    icon 307, x%, 304, 14, 15, 8, 7, 0
    PSET (307, x%): DRAW "c8 d14"
    FOR Y = 1 TO timin%: NEXT Y
  NEXT x%
END IF
END SUB

SUB opensmall (direction$, soundx%, timin%)

IF direction$ = "O" THEN
  h = 128: v = 134
  FOR x = 1 TO 96
    LINE (h, 252)-(h + 1, 307), 8, B
    LINE (h + 2, 252)-(h + 3, 307), 0, B
    LINE (v - 2, 252)-(v - 1, 307), 0, B
    LINE (v, 252)-(v + 1, 307), 15, B
    h = h - 1: v = v + 1
    FOR Y = 1 TO loopy: NEXT Y
  NEXT x
ELSE
  h = 33: v = 229
  FOR x = 1 TO 96
    LINE (h, 252)-(h + 1, 307), 7, B
    LINE (h + 2, 252)-(h + 3, 307), 8, B
    LINE (v, 252)-(v + 1, 307), 7, B
    LINE (v - 2, 252)-(v - 1, 307), 15, B
    h = h + 1: v = v - 1
    FOR Y = 1 TO loopy: NEXT Y
  NEXT x
END IF
END SUB

SUB printbuttons (winselect$, winopen$)
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
LINE (308, 58)-(612, 90), 7, BF
LINE (308, 91)-(612, 91), 8
LINE (308, 299)-(612, 327), 7, BF
LINE (308, 298)-(612, 298), 15
cl = 0 + 128 XOR 7: COLOR cl
icon 333, 305, 70, 18, 15, 8, 7, 1
icon 497, 305, 38, 18, 15, 8, 7, 1
icon 554, 305, 38, 18, 15, 8, 7, 1
cl = 4 + 128 XOR 7: COLOR cl
LOCATE 23, 45: PRINT "D"
LOCATE 23, 65: PRINT ""
LOCATE 23, 72: PRINT ""
cl = 0 + 128 XOR 7: COLOR cl
LOCATE 23, 46: PRINT "one"
END SUB

DEFINT A-Z
SUB pushbutton (number$, whereicon, whereprint, doit)
mousepointer 0
IF doit = 0 THEN
  icon 249, whereicon, 27, 21, 8, 15, 7, 1
  nz% = DRAWSTR%(0, number$, 260, whereprint, 0, 7, 8)
ELSE
  icon 249, whereicon, 27, 21, 15, 8, 7, 1
  nz% = DRAWSTR%(0, number$, 260, whereprint, 0, 7, 8)
END IF
mousepointer 1
END SUB

DEFSNG A-Z
SUB reg
CLS
COLOR 1, 3
PRINT "   UUDEVICE v.2.1                             Copyright 1995 by Will Boyett  "
COLOR 3, 0: PRINT
PRINT "  If you find this utility useful and plan to keep using it, then please"
PRINT "register!  Besides, there are many other benefits as a registered user."
COLOR 15, 0: PRINT
PRINT "1) The registered versions includes: Page Up/Page Down Keys, Not limited to"
PRINT "   only 500 lines in the scroll window, Select picklist items with mouse."
PRINT "   And so much more!"
PRINT "2) Info and updates on more utilities for UU."
PRINT "3) Tips and strategies on how you can win at UU."
PRINT "4) Phone Support! That's right, call and get advice. "
PRINT "5) NO shareware screens to slow you down."
COLOR 3, 0: PRINT
PRINT "To receive the above benefits, please send your registration in the amount of"
PRINT "$8.00 U.S. plus $3 S/H to:"
PRINT
PRINT "                                Will Boyett"
PRINT "                               11955 209th St."
PRINT "                             Lakewood, CA 90715"
END SUB

SUB titles
DEFINT A-Z
nz% = DRAWSTR%(0, "1", 260, 70, 0, 7, 8)
nz% = DRAWSTR%(0, "2", 260, 99, 0, 7, 8)
nz% = DRAWSTR%(0, "3", 260, 126, 0, 7, 8)
nz% = DRAWSTR%(0, "4", 260, 154, 0, 7, 8)
nz% = DRAWSTR%(0, "5", 260, 182, 0, 7, 8)
cl = 14 + 128 XOR 3: COLOR cl
x = 9
LOCATE 2, x
PRINT "    T     D          P            C           X          H";
cl = 4 + 128 XOR 3: COLOR cl
LOCATE 2, x: PRINT "Prin"
LOCATE 2, x + 11: PRINT "evices"
LOCATE 2, x + 22: PRINT "icklist"
LOCATE 2, x + 35: PRINT "onvert"
LOCATE 2, x + 47: PRINT "tras"
LOCATE 2, x + 58: PRINT "elp"
IF Exists("device.con") THEN LINE (330, 13)-(400, 28), 3, BF
END SUB

