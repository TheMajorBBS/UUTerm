'Turn on trapping of Ctrl+Alt+Del:

'12 = 4 + 8 = (code for Ctrl key) + (code for Alt key)
'83 = scan code for Del key
KEY 15, CHR$(12) + CHR$(83)         'Ctrl-Alt-Del (on num pad)
KEY 16, CHR$(128 + 12) + CHR$(83)   'Ctrl-Alt-Del (on alt editing pad)
ON KEY(15) GOSUB CtrlAltDel
ON KEY(16) GOSUB CtrlAltDel
KEY(15) ON
KEY(16) ON

DO                                  'Exit as soon as a key other than
    A$ = INKEY$                     'Ctrl-alt-del is pressed.
LOOP UNTIL LEN(A$)
END

CtrlAltDel:
    PRINT "Got it"
RETURN

