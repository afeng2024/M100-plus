'FILE= "display.bas"

#ifndef  DISPLAYS_BAS
#define  DISPLAYS_BAS	123


'===============================================================================
' INITIALIZE ALL DISPLAYS TO SHOW 8888 WITH DECIMAL POINTS
'===============================================================================
Sub  Initialize_Displays()

		Set_Digits 0x00, 0			' 8-segment LED pattern, inter-digit delay
		Inter_Digit_Delay 200		' short delay after blanking all displays
	
		Set_Digits 0xFF, 300		' progressively add 8's to all displays
		Inter_Digit_Delay 2000		' short delay after blanking all displays
	
		Set_Digits 0x00, 300		' 8-segment LED pattern, inter-digit delay
		Inter_Digit_Delay 1500		' short delay after blanking all displays

End Sub


'===============================================================================
' SET DIGITS IS USED WITH THE ABOVE SUBROUTINE(S)
'===============================================================================
Sub  Set_Digits(hex_digit_pattern As Byte, inter_digit_wait As Integer)
	i Var Byte
	j Var Integer
	For i=0 To 3
		Nop
		For j=0 To 3
			Csgxput i, j, hex_digit_pattern
			Inter_Digit_Delay  inter_digit_wait
		Next
	Next
End Sub


'===============================================================================
' INTER-DIGIT DELAY IS USED WITH THE ABOVE SUBROUTINE(S)
'===============================================================================
Sub  Inter_Digit_Delay(delay_d As Integer)
	k Var Integer
	For k=0 To delay_d
 		Nop
	Next
End Sub


'===============================================================================
' DISPLAY_BLANKING
'===============================================================================
Sub Display_Blanked(display_address As Byte)

	Csgxput	display_address, 0, 0		'blank-out the 1000's digit
	Csgxput	display_address, 1, 0		'blank-out the  100's digit
	Csgxput	display_address, 2, 0		'blank-out the   10's digit
	Csgxput	display_address, 3, 0		'blank-out the    1's digit

End Sub


'===============================================================================
' DISPLAY_DASHED
'===============================================================================
Sub Display_Dashed(display_address As Byte)

	Csgxput	display_address, 0, 0x40		'dash-out the 1000's digit
	Csgxput	display_address, 1, 0x40		'dash-out the  100's digit
	Csgxput	display_address, 2, 0x40		'dash-out the   10's digit
	Csgxput	display_address, 3, 0x40		'dash-out the    1's digit

End Sub


'===============================================================================
' SEND NUMBERS TO DISPLAYS
'===============================================================================
Sub Display_Registers()

	dreg_temp0  Var Integer
	dreg_temp1  Var Integer
	dreg_temp4	Var	Long

	'----------------------------------------------------------------------------
	If (switches.PB_GRAND_TOTAL_BIT) Then

		If (leds.LED_RUNNING_BIT = NOT_RUNNING) Then

			If (leds.LED_TIME_BIT = TIME_MODE_OFF) And (time_state = 0) Then

				If line_pointer = 0 Then

					Display_Index_And_Feed_Rate			' display line_pointer (=schedule_index)

					'Display_Feed_Preset 				' display feed density (only for index = 0)
					Display_Feed_Density

					'Display_Feed_Total					' display feed delivery factor (only for index = 0)
					Display_Delivery_Factor

				Else
					If group_pointer = SCHEDULE_GROUP_B Then
						dreg_temp4 = grand_total_array(GRAND_TOTAL_B)
					Else
						dreg_temp4 = grand_total_array(GRAND_TOTAL_A)
					Endif

					dreg_temp1 = (dreg_temp4 / 10000).Word0
					dreg_temp0 = (dreg_temp4 Mod 10000).Word0

					' A GRAND TOTAL CAN USE 2 SIDE-BY-SIDE 4-DIGIT DISPLAYS (BOT-LEFT & BOT-RIGHT)
					' THE LEFT DISPLAY GROUP IS BLANKED IF THE GRAND TOTAL IS <= 9999

					If (dreg_temp1 = 0) Then								'?: upper 4 digit are 0's
						Display_Blanked  DISPLAY_FEED_VOLUME_PRESET			'Y: blank-out B-L display
					Else
						Csgdec  DISPLAY_FEED_VOLUME_PRESET, dreg_temp1		'N: display upper 4 digits
					Endif

					Csgdec  DISPLAY_FEED_VOLUME_TOTAL, dreg_temp0			'display lower 4 digits

				Endif
			Endif

		' leds.LED_RUNNING_BIT = RUNNING
		Else
			If group_pointer = SCHEDULE_GROUP_B Then									'IF THERE ARE MORE THAN
				dreg_temp1 = (grand_total_array(GRAND_TOTAL_B) / 10000).Word0			'TWO SCHEDULE GROUPS
				dreg_temp0 = (grand_total_array(GRAND_TOTAL_B) Mod 10000).Word0			'MORE ELSES/ELSEIFS
			Else																		'WOULD BE REQUIRED HERE
				dreg_temp1 = (grand_total_array(GRAND_TOTAL_A) / 10000).Word0
				dreg_temp0 = (grand_total_array(GRAND_TOTAL_A) Mod 10000).Word0
			Endif

			If (dreg_temp1 = 0) Then
				Display_Blanked  DISPLAY_FEED_VOLUME_PRESET			'blank-out feed_volume_preset display
	
				Csgdec  DISPLAY_FEED_VOLUME_TOTAL, dreg_temp0
			Else
				Csgdec  DISPLAY_FEED_VOLUME_PRESET, dreg_temp1
				dreg_temp1 = Bin2bcd(dreg_temp0)
				Csgxput DISPLAY_FEED_VOLUME_TOTAL, 0, Seven_Segment(dreg_temp1.Nib3)		' 1000s place
				Csgxput DISPLAY_FEED_VOLUME_TOTAL, 1, Seven_Segment(dreg_temp1.Nib2)		'  100s place
				Csgxput DISPLAY_FEED_VOLUME_TOTAL, 2, Seven_Segment(dreg_temp1.Nib1)		'   10s place
				Csgxput DISPLAY_FEED_VOLUME_TOTAL, 3, Seven_Segment(dreg_temp1.Nib0)		'    1s place
			Endif
		Endif

	'----------------------------------------------------------------------------
	Else	'N: switches.PB_GRAND_TOTAL_BIT = 0

		If time_state = 0 Then					' SHOW FEED DELIVERY RELATED PARAMETERS
			
			If line_pointer = 0 Then			'?: pointer points to Time (in schedule)

				Display_Dashed  DISPLAY_0		'	instead, put 4 dashes in display
				Display_Index_And_Feed_Rate		'   and show line_pointer (=schedule_index)

				'Display_Feed_Preset 				' display feed density (only for index = 0)
				Display_Feed_Density

				'Display_Feed_Total					' display feed delivery factor (only for index = 0)
				Display_Delivery_Factor

			Else								'n:
				Display_Feed_Delivered			'   show normal feed/feeding parameters
				Display_Index_And_Feed_Rate
				Display_Feed_Preset
				Display_Feed_Total
			Endif
		
		Else	'N: time_state = 1				' SHOW TIME/SCHEDULE RELATED PARAMETERS
			Display_Current_Time
			Display_Index_And_Seconds
			Display_Start_Time
			Display_Stop_Time
			
		Endif
	Endif

End Sub


'===============================================================================
' DISPLAY FEED VOLUME DELIVERED VALUE
'===============================================================================
Sub Display_Feed_Delivered()

	Csgdec  DISPLAY_FEED_VOLUME_DELIVERED, schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer)

End Sub


'===============================================================================
' DISPLAY SCHEDULE INDEX (FORMERLY "CYCLES") AND ESTIMATED FEED RATE
'===============================================================================
Sub Display_Index_And_Feed_Rate()

	temp_integer	Var	Integer

	'---------------------------------------------------------------------------
	'SHOW SCHEDULE INDEX (OLD NAME = "CYCLES")

	temp_integer = Bin2BCD(line_pointer)
	
	'SHOW INDEX'S 10s VALUE IN FIRST DIGIT
	CsgxPut DISPLAY_CYCLES_AND_RATE, 0, Seven_Segment(temp_integer.NIB1)
	
	'SHOW INDEX'S 1s VALUE IN SECOND DIGIT, AND ADD DECIMAL POINT AFTER IT
	CsgxPut DISPLAY_CYCLES_AND_RATE, 1, Seven_Segment(temp_integer.NIB0) + 0x80

	'---------------------------------------------------------------------------
	' SHOW FEED RATE

#If FEED_RATE_DISPLAY_SMOOTHING	= 1		' FOR LESS "JUMPINESS" IN DISPLAYED RATE

		If (feed_rate_avg1 >= FEED_RATE_THRESHOLD_3) Then		'THRESHOLDS EMPERICALLY DETERMINED
			feed_rate = feed_rate_avg4

		Elseif (feed_rate_avg1 >= FEED_RATE_THRESHOLD_2) Then
			feed_rate = feed_rate_avg3

		Elseif (feed_rate_avg1 >= FEED_RATE_THRESHOLD_1) Then
			feed_rate = feed_rate_avg2

		Else
			feed_rate = feed_rate_avg1

		Endif

#Endif

''DEBUG CR, "FR:fr=",dec feed_rate,":",dec feed_rate_f

    If ( (dispenser_indexer_period_saved = 0)  Or  _            ' OTHER SPECIAL CASES
         (leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF) )  Then

        Csgxput DISPLAY_CYCLES_AND_RATE, 2, 0x40        '  10s place = middle "-"
        Csgxput DISPLAY_CYCLES_AND_RATE, 3, 0x40        '   1s place = middle "-"

    Elseif (feed_rate_f >= FEED_RATE_MAX)  Then			' FEED RATE TOO HIGH
    	
        Csgxput DISPLAY_CYCLES_AND_RATE, 2, 0x01        '  10s place = high "-"
        Csgxput DISPLAY_CYCLES_AND_RATE, 3, 0x01        '   1s place = high "-"

    Elseif (feed_rate_f < FEED_RATE_MIN)  Then			' FEED RATE TOO LOW

        Csgxput DISPLAY_CYCLES_AND_RATE, 2, 0x08        '  10s place = low "-"
        Csgxput DISPLAY_CYCLES_AND_RATE, 3, 0x08        '   1s place = low "-"

    Else												' WITHIN RANGE

		if (feed_rate < 100.0) Then						' WITHIN DISPLAY OF 2 DIGITS
            temp_integer = feed_rate
            temp_integer = Bin2bcd(temp_integer)
            
            Csgxput DISPLAY_CYCLES_AND_RATE, 2, Seven_Segment(temp_integer.Nib1)    ' show 10s digit
            Csgxput DISPLAY_CYCLES_AND_RATE, 3, Seven_Segment(temp_integer.Nib0)    ' show  1s digit

        Else  ' feed_rate_local >= 100.0				' EXCEEDS DISPLAY OF 2 DIGITS 

	        Csgxput DISPLAY_CYCLES_AND_RATE, 2, 0x01     '  10s place = high "-"
    	    Csgxput DISPLAY_CYCLES_AND_RATE, 3, 0x01     '   1s place = high "-"

        Endif
    Endif

End Sub


'===============================================================================
' DISPLAY FEED VOLUME PRESET VALUE
'===============================================================================
Sub Display_Feed_Preset()

	Csgdec  DISPLAY_FEED_VOLUME_PRESET, schedule(SCHEDULE_PRESET, line_pointer, group_pointer)

End Sub


'===============================================================================
' DISPLAY FEED DESNITY VALUE
'===============================================================================
Sub Display_Feed_Density() 				' display feed density (only for index = 0)

	dfd_integer		var	integer

    dfd_integer = schedule(SCHEDULE_PRESET, line_pointer, group_pointer)
    dfd_integer = Bin2bcd(dfd_integer)

	Csgxput DISPLAY_FEED_VOLUME_PRESET, 0, Seven_Segment(dfd_integer.Nib3) + 0x80	' 1000s place
	Csgxput DISPLAY_FEED_VOLUME_PRESET, 1, Seven_Segment(dfd_integer.Nib2)			'  100s place
	Csgxput DISPLAY_FEED_VOLUME_PRESET, 2, Seven_Segment(dfd_integer.Nib1)			'   10s place
	Csgxput DISPLAY_FEED_VOLUME_PRESET, 3, Seven_Segment(dfd_integer.Nib0)			'    1s place

End Sub


'===============================================================================
' DISPLAY FEED VOLUME TOTAL VALUE
'===============================================================================
Sub Display_Feed_Total()

	Csgdec  DISPLAY_FEED_VOLUME_TOTAL, schedule(SCHEDULE_TOTAL, line_pointer, group_pointer)

End Sub


'===============================================================================
' DISPLAY FEED DELIVERY FACTOR VALUE
'===============================================================================
Sub Display_Delivery_Factor()			' display feed delivery factor (only for index = 0)

	ddf_integer		var	integer

    ddf_integer = schedule(SCHEDULE_TOTAL, line_pointer, group_pointer)
    ddf_integer = Bin2bcd(ddf_integer)

	Csgxput DISPLAY_FEED_VOLUME_TOTAL, 0, Seven_Segment(ddf_integer.Nib3) + 0x80	' 1000s place
	Csgxput DISPLAY_FEED_VOLUME_TOTAL, 1, Seven_Segment(ddf_integer.Nib2)			'  100s place
	Csgxput DISPLAY_FEED_VOLUME_TOTAL, 2, Seven_Segment(ddf_integer.Nib1)			'   10s place
	Csgxput DISPLAY_FEED_VOLUME_TOTAL, 3, Seven_Segment(ddf_integer.Nib0)			'    1s place

End Sub


'===============================================================================
' DISPLAY CURRENT TIME
'===============================================================================
Sub Display_Current_Time()

	Csgxput DISPLAY_3, 0, Seven_Segment(time_of_day_hours.Nib1)   		' 10s of Hours
	
	If (time_of_day_seconds And 1) Then
		Csgxput DISPLAY_3, 1, Seven_Segment(time_of_day_hours.Nib0)  		'  1s of Hours, no DP
	Else
		Csgxput DISPLAY_3, 1, Seven_Segment(time_of_day_hours.Nib2)+0x80  '  1s of Hours + DP
	Endif

	Csgxput DISPLAY_3, 2, Seven_Segment(time_of_day_minutes.Nib1) 		' 10s of Minutes
	Csgxput DISPLAY_3, 3, Seven_Segment(time_of_day_minutes.Nib0)   	'  1s of Minutes

End Sub



'===============================================================================
' DISPLAY SCHEDULE INDEX (FORMERLY "CYCLES") AND SECONDS OF TIME
'===============================================================================
Sub Display_Index_And_Seconds()

	dias_integer	Var	Integer

	'---------------------------------------------------------------------------
	'SHOW SCHEDULE INDEX (OLD NAME = "CYCLES")

	dias_integer = Bin2BCD(line_pointer)
	
	'SHOW INDEX'S 10s VALUE IN FIRST DIGIT
	CsgxPut DISPLAY_CYCLES_AND_RATE, 0, Seven_Segment(dias_integer.NIB1)
	
	'SHOW INDEX'S 1s VALUE IN SECOND DIGIT, AND ADD DECIMAL POINT AFTER IT
	CsgxPut DISPLAY_CYCLES_AND_RATE, 1, Seven_Segment(dias_integer.NIB0) + 0x80

	'---------------------------------------------------------------------------
	'SHOW SECONDS OF TIME
	Csgxput DISPLAY_1, 2, Seven_Segment(time_of_day_seconds.Nib1)		'SECONDS: 10s
	Csgxput DISPLAY_1, 3, Seven_Segment(time_of_day_seconds.Nib0)		'SECONDS:  1s

End Sub


'===============================================================================
' DISPLAY SCHEDULE START TIME
'===============================================================================
Sub Display_Start_Time()

	Csgxput DISPLAY_2, 0, _
		Seven_Segment(schedule(SCHEDULE_START, line_pointer, group_pointer).Nib3)			'10s of HOURS

    Csgxput DISPLAY_2, 1, _
    	Seven_Segment(schedule(SCHEDULE_START, line_pointer, group_pointer).Nib2) + 0x80 	' 1s of HOURS + DP

    Csgxput DISPLAY_2, 2, _
    	Seven_Segment(schedule(SCHEDULE_START, line_pointer, group_pointer).Nib1)   		'10s of MINUTES

    Csgxput DISPLAY_2, 3, _
    	Seven_Segment(schedule(SCHEDULE_START, line_pointer, group_pointer).Nib0)			' 1s of MINUTES

End Sub


'===============================================================================
' DISPLAY SCHEDULE STOP TIME
'===============================================================================
Sub Display_Stop_Time()

    Csgxput DISPLAY_3, 0, _
    	Seven_Segment(schedule(SCHEDULE_STOP, line_pointer, group_pointer).Nib3)			'10s of HOURS

    Csgxput DISPLAY_3, 1, _
    	Seven_Segment(schedule(SCHEDULE_STOP, line_pointer, group_pointer).Nib2) + 0x80		' 1s of HOURS + DP

    Csgxput DISPLAY_3, 2, _
    	Seven_Segment(schedule(SCHEDULE_STOP, line_pointer, group_pointer).Nib1)			'10s of MINUTES

    Csgxput DISPLAY_3, 3, _
    	Seven_Segment(schedule(SCHEDULE_STOP, line_pointer, group_pointer).Nib0)			' 1s of MINUTES

End Sub


'===============================================================================
' SEVEN SEGMENT FUNCTION
'===============================================================================
'      -A-           #   HGFE DCBA  (Decimal Point = segment H)
'    F|   |B         0 = 0011 1111
'      -G-           1 = 0000 0110
'    E|   |C         2 = 0101 1011
'      -D-   (H)     3 = 0100 1111
'-------------------------------------------------------------------------------
Function Seven_Segment(source As Byte) As Byte

	Seven_Segment = LED_8SEG_PATTERNS(source And 0x0F)

End Function



#endif
