'FILE= "display.inc"

#ifndef  DISPLAYS_INC
#define  DISPLAYS_INC	123



'===============================================================================
' DISPLAY DEFINTIONS
'===============================================================================
' NOTE: FEED RATE SMOOTHING CAN REDUCE "JUMPINESS" OF DISPLAY AT CERTAIN RATES
'		THE COMPILE-TIME SWITCH IS LOCATED IN THE ".INC" CONSTANTS FILE DEALING
'		WITH THE PARTICULAR DISPENSER, FOR EXAMPLE, "ROTARY_DISPENSER.INC" OR
'		AUGER_DISPENSER.INC".
'-------------------------------------------------------------------------------
#define  DISPLAY_0			0			'TOP-LEFT
#define  DISPLAY_1			1			'TOP-RIGHT
#define  DISPLAY_2			2			'BOTTOM-LEFT
#define  DISPLAY_3			3			'BOTTOM-RIGHT

'-----------------------------------------------------------------
'                    FOR SCHEDULE LINE 0 (SPECIAL)
'-----------------------------------------------------------------
'       DASHED OUT (NOT USED)     |  SCHEDULE LINE . FEED RATE   |
'-----------------------------------------------------------------
' FEED DENSITY (SPECIFIC GRAVITY) |     FEED DELIVERY FACTOR     |
'-----------------------------------------------------------------

'-----------------------------------------------------------------
' FOR SCHEDULE LINES 1 AND UP
'-----------------------------------------------------------------
'  DISPLAY_FEED_VOLUME_DELIVERED  |      DISPLAY_FEED_RATE       |
'-----------------------------------------------------------------
'    DISPLAY_FEED_VOLUME_PRESET   |  DISPLAY_FEED_VOLUME_TOTAL   |
'-----------------------------------------------------------------
#define  DISPLAY_FEED_VOLUME_DELIVERED	 DISPLAY_0
#define  DISPLAY_CYCLES_AND_RATE				 DISPLAY_1
#define  DISPLAY_FEED_VOLUME_PRESET			 DISPLAY_2
#define  DISPLAY_FEED_VOLUME_TOTAL			 DISPLAY_3


'===============================================================================
' LED DISPLAY 8-SEGMENT PATTERNS
'===============================================================================
'      -A-           #   HGFE DCBA  (Decimal Point = segment H)
'    F|   |B         0 = 0011 1111
'      -G-           1 = 0000 0110
'    E|   |C         2 = 0101 1011
'      -D-   (H)     3 = 0100 1111
'-------------------------------------------------------------------------------
#define  DECIMAL_POINT		0x80		'SEGMENT "H" = RIGHT-SIDE DECIMAL POINT

Const Byte LED_8SEG_PATTERNS = (0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x27,
'                                "0",  "1",  "2",  "3",  "4",  "5",  "6",  "7",
                                0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71)
'								 "8",  "9",  "A",  "b",  "C",  "d",  "E",  "F"
'===============================================================================



#endif

