'Get the original R,G,B color values from a VGA

    OUT &H3C7, Attribute
    OUT &H3C8, Attribute
    Red = INP(&H3C9)
    Green = INP(&H3C9)
    Blue = INP(&H3C9)

