DECLARE SUB DisableKeyboard (sw%)
'disables/enables the keyboard
' sw% = 0 disables keyboard, anything else turns on.

DisableKeyboard sw%

SUB DisableKeyboard (sw%)

   IF sw% = 0 THEN OUT &H21, (INP(&H21) OR 2) ELSE OUT &H21, (INP(&H21) AND 253)

END SUB

