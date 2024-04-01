'FILE= "m100newsub.bas"

#ifndef  M100NEWSUB_BAS
#define  M100NEWSUB_BAS		123



'===============================================================================
' SEND INITIAL DATA TO ARDUINO
'===============================================================================

Sub Send_Initial_Data()

			data_string = ""
			data_string = data_string + "20"+ DP(BCD2Bin(Time(TIME_YEARS_BCD)),2,1)		'Date
			data_string = data_string + "-"+ DP(BCD2Bin(Time(TIME_MONTHS_BCD)),2,1)		'Date
			data_string = data_string + "-"+ DP(BCD2Bin(Time(TIME_DATES_BCD)),2,1)		'Date
			data_string = data_string + ","+ DP(unit_number,4,1)											'Unit number
'			data_string = data_string + CHR(&H0D)
			data_string = data_string + CHR(&H0A)

			debug data_string, cr

			putstr 1, data_string
			putstr 1, data_string


End Sub


'===============================================================================
' SEND DATA TO RS-232 AFTER EACH FEEDING
'===============================================================================
Sub Data_exchange_process()


		if (data_exchange=1) then					'send data to com port
			data_exchange = 0
'			debug "0 -- Data_state = ", dec data_exchange, cr, cr

			debug "GATE(A=0/B=1)= ", dec group_pointer, cr
			debug "LOCATION= ", dec line_pointer, cr
			debug "Feed Rate= ", dec feed_rate, cr
			debug "PRESET= ", dec schedule(SCHEDULE_PRESET, line_pointer, group_pointer), cr
			debug "DELIVERD= ", dec schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer), cr
			debug "TOTAL= ", dec schedule(SCHEDULE_TOTAL, line_pointer, group_pointer), cr
			debug "Grand TOTAL A= ", dec grand_total_array(Grand_total_A), cr
			debug "Grand TOTAL B= ", dec grand_total_array(Grand_total_B), cr
			debug "Density= ", dec schedule(SCHEDULE_PRESET, 0, group_pointer), cr
			debug "Adjust Fact= ", dec schedule(SCHEDULE_TOTAL, 0, group_pointer), cr, cr

			data_string = ""
			data_string = data_string + "20"+ dec BCD2Bin(Time(TIME_YEARS_BCD))		'Date
			data_string = data_string + "-"+ dec BCD2Bin(Time(TIME_MONTHS_BCD))		'Date
			data_string = data_string + "-"+ dec BCD2Bin(Time(TIME_DATES_BCD))		'Date
			data_string = data_string + ","+ dec BCD2Bin(Time(TIME_HOURS_BCD))		'Time
			data_string = data_string + ":"+ dec BCD2Bin(Time(TIME_MINUTES_BCD))	'Time
			data_string = data_string + ":"+ dec BCD2Bin(Time(TIME_SECONDS_BCD))	'Time
			data_string = data_string + ","+ dec unit_number			'Unit number
			data_string = data_string + ","+ dec group_pointer		'Gate A/B (0/1)
			data_string = data_string + ","+ dec line_pointer			'Location
			data_string = data_string + ","+ dec feed_rate				'Feed rate
			data_string = data_string + ","+ dec schedule(SCHEDULE_PRESET, line_pointer, group_pointer)		'Preset
			data_string = data_string + ","+ dec schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer)	'Deliverd
			data_string = data_string + ","+ dec schedule(SCHEDULE_TOTAL, line_pointer, group_pointer)		'Total
			data_string = data_string + ","+ dec grand_total_array(Grand_total_A)			'Grand Total A
			data_string = data_string + ","+ dec grand_total_array(Grand_total_B)			'Grand Total B
			data_string = data_string + ","+ dec schedule(SCHEDULE_PRESET, 0, group_pointer)		'Density
			data_string = data_string + ","+ dec schedule(SCHEDULE_TOTAL, 0, group_pointer)			'Adjust Fact
			data_string = data_string + CHR(&H0A)

			debug data_string, cr

'			debug "Data to com port sent", cr
'			debug data_string, cr


			putstr 1, data_string
'			putstr 0, data_string, cr



			endif


End Sub


'===============================================================================
' READ AND COMPARE RTC FROM EEPROM
'===============================================================================
Sub  Initialize_variables()
	part_add	Var	Integer

'Debug cr, "*****  Initialize_variables()  *****", cr

	max_location = Eeread(EE_NUMBER_OF_LOCATIONS, 2)
	rotary_type = Eeread(EE_ROTARY_TYPE, 1)
	weight_unit = Eeread(EE_WEIGHT_UNIT, 1)
	unit_number = Eeread(EE_UNIT_NUMBER, 2)

	part_add = MAX_SCHEDULE_LINES_PER_GROUP * SCHEDULE_ELEMENTS_PER_LINE
	schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A) = Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2 * SCHEDULE_PRESET, 2 )
	schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A) = Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2 * SCHEDULE_TOTAL, 2 )
	schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B) = Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2 * (SCHEDULE_PRESET + part_add), 2 )
	schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B) = Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2 * (SCHEDULE_TOTAL + part_add), 2 )

	Opencom 1, BAUD_RATE, 3, 10, 100
	Opencom 0, 115200, 3, 50, 100
	time_of_year = Time(Bin2Bcd(TIME_YEARS_BCD))
	time_of_month = Time(Bin2Bcd(TIME_MONTHS_BCD))
	time_of_date = Time(Bin2Bcd(TIME_DATES_BCD))
'	If (time_of_year < CURRENT_YEAR) Then
'		time_error = 1
'	Endif
'	Debug "RTC ERROR = ", dec Time_error, Cr

	Debug cr, "Max Location = ", dec max_location, "     Rotary Type = ", dec rotary_type
	Debug "      Weight Unit = ", dec weight_unit, "     Unit Number = ", dec unit_number, Cr
	Debug "Gravity A = ", dec schedule(SCHEDULE_PRESET, 0, 0), "      A Factor A = ", dec schedule(SCHEDULE_TOTAL, 0, 0)
	DEBUG "      Gravity B = ", dec schedule(SCHEDULE_PRESET, 0, 1), "      A Factor B = ", dec schedule(SCHEDULE_TOTAL, 0, 1), cr
	Debug "DATE = ", dec BCD2Bin(time_of_year), "-", dec BCD2Bin(time_of_month), "-", dec BCD2Bin(time_of_date), cr
	

End Sub


'===============================================================================
' SETTING RTC DATE AND TIME
' CAUTION: The following is not "polished" and uses empirically determined values
'===============================================================================
Sub Multi_Parameter_Setting()

	mpss_int	Var	Integer
	mpss_intb	Var	Integer
	Byteout LED_PORTBLOCK_L, leds.Byte0
	Byteout LED_PORTBLOCK_H, leds.Byte1



'---- ADJUSTING FEEDING PARAMETERS -------------------------------------

	If (line_pointer > 0) Then										' ADJUST PRESET FOR LOCATION

			If ( (switches.PB_MORE_BIT = PB_PRESSED)  And  _			'	?: WANTING TO INCREASE THE VALUE
			     ( (leds.LED_RUNNING_BIT <> RUNNING)  Or  _
				    (leds.LED_PAUSED_BIT = PAUSED) ) )  Then
																		'	Y: INCREASE THE VALUE
				mpss_int = Setting_Push_Button( INCDEC_MORE, schedule(SCHEDULE_PRESET, line_pointer, group_pointer) )
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_PRESET, line_pointer, group_pointer) = mpss_int
				Display_Feed_Preset

			Elseif ( (switches.PB_LESS_BIT = PB_PRESSED)  And  _		'	N: '?: WANTING TO DECREASE THE VALUE
			         ( (leds.LED_RUNNING_BIT <> RUNNING)  Or  _
				        (leds.LED_PAUSED_BIT = PAUSED) ) )  Then
																		'	Y: DECREASE THE VALUE
				mpss_int = Setting_Push_Button( INCDEC_LESS, schedule(SCHEDULE_PRESET, line_pointer, group_pointer) )
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_PRESET, line_pointer, group_pointer) = mpss_int
				Display_Feed_Preset
		
			Else																	'	N: NEITHER, SET accel_amount = 0
				accel_amount = 0										'	   NOTE: accel_amount IS VALUE AND FLAG
	
			Endif
	Endif

'------SETTING MODE START----------------------------------------------------

	If (leds.LED_TIME_BIT = TIME_MODE_ON) And (line_pointer = 0) Then					' CHANGE FUNCTIONS

		If (switches_asserted.PB_MORE_BIT = PB_PRESSED) Then
				mpss_int = Function_Button_Incr(setting_mode)
				setting_mode = mpss_int
				If (setting_mode>MAX_SETTING_MODE) Then setting_mode = 1
		Elseif (switches_asserted.PB_LESS_BIT = PB_PRESSED) Then
				mpss_int = Function_Button_Decr(setting_mode)
				setting_mode = mpss_int
				If (setting_mode=0) Then setting_mode = MAX_SETTING_MODE
		Else
				faccel_amount = 0
		Endif

		Display_Functions setting_mode



		Select Case setting_mode

			Case 1											'DENSITY setting A

'				Display_Functions setting_mode
				Display_Value schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A)

				mpss_int = Change_Value(schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A))
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A) = mpss_int

				Display_Value schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A)
				kg_per_rot_changed = 1																	'	SET THE KG/ROT-CHANGED FLAG



			Case 3												'ADJUST FACT SETTING A

'				Display_Functions setting_mode
				Display_Value schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A)

				mpss_int = Change_Value(schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A))
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A) = mpss_int

				Display_Value schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A)
				kg_per_rot_changed = 1																	'	SET THE KG/ROT-CHANGED FLAG



			Case 2												'DENSITY setting B

'				Display_Functions setting_mode
				Display_Value schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B)

				mpss_int = Change_Value(schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B))
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B) = mpss_int

				Display_Value schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B)
				kg_per_rot_changed = 1																	'	SET THE KG/ROT-CHANGED FLAG



			Case 4												'ADJUST FACT SETTING B

'				Display_Functions setting_mode
				Display_Value schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B)

				mpss_int = Change_Value(schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B))
				If (mpss_int>9999) Then mpss_int = 1
				If (mpss_int<1) Then mpss_int = 9999
				schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B) = mpss_int

				Display_Value schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B)
				kg_per_rot_changed = 1																	'	SET THE KG/ROT-CHANGED FLAG



			Case 6												'YEAR SETTING

'				Display_Functions setting_mode
				time_of_year = BCD2Bin(Time(TIME_YEARS_BCD))
				Display_Value time_of_year

				mpss_int = Change_Value(time_of_year)
				time_of_year = mpss_int

				If (time_of_year>TIME_YEARS_MAX) Then time_of_year = TIME_YEARS_MAX
				Timeset TIME_YEARS_BCD,Bin2BCD(time_of_year)				'   set the year
				Display_Value time_of_year
		


			Case 7												'MONTH SETTING

'				Display_Functions setting_mode
				time_of_month = BCD2Bin(Time(TIME_MONTHS_BCD))
				Display_Value time_of_month

				mpss_int = Change_Value(time_of_month)
				time_of_month = mpss_int

				If (time_of_month>TIME_MONTHS_MAX) Then
						time_of_month = TIME_MONTHS_MIN
				Elseif (time_of_month<TIME_MONTHS_MIN) Then
						time_of_month = TIME_MONTHS_MAX
				Endif
				Timeset TIME_MONTHS_BCD,Bin2BCD(time_of_month)			'   set the month
				Display_Value time_of_month



			Case 8												'DATE SETTING

'				Display_Functions setting_mode
				time_of_date = BCD2Bin(Time(TIME_DATES_BCD))
				Display_Value time_of_date

				mpss_int = Change_Value(time_of_date)
				time_of_date = mpss_int

				If (time_of_date>TIME_DATES_MAX_31) Then
						time_of_date = TIME_DATES_MIN
				Elseif (time_of_date<TIME_DATES_MIN) Then
						time_of_date = TIME_DATES_MAX_31
				Endif
				Timeset TIME_DATES_BCD,Bin2BCD(time_of_date)				'		set the date
				Display_Value time_of_date



			Case 9												'HOUR SETTING

'				Display_Functions setting_mode
				time_of_day_hours = BCD2Bin(Time(TIME_HOURS_BCD))
				Display_Value time_of_day_hours

				mpss_int = Change_Value(time_of_day_hours)
				time_of_day_hours = mpss_int

				If (time_of_day_hours>TIME_HOURS_MAX) Then time_of_day_hours = TIME_HOURS_MAX
				Timeset TIME_HOURS_BCD,Bin2BCD(time_of_day_hours)		'   set the hours
				Display_Value time_of_day_hours
		
		
		
			Case 10												'MINUTE SETTING

'				Display_Functions setting_mode
				time_of_day_minutes = BCD2Bin(Time(TIME_MINUTES_BCD))
				Display_Value time_of_day_minutes

				mpss_int = Change_Value(time_of_day_minutes)
				time_of_day_minutes = mpss_int

				If (time_of_day_minutes>TIME_MINUTES_MAX) Then
						time_of_day_minutes = TIME_MINUTES_MAX
				Elseif (time_of_day_minutes>999) Then
						time_of_day_minutes = TIME_MINUTES_MIN
				Endif
				Timeset TIME_MINUTES_BCD,Bin2BCD(time_of_day_minutes)	'   set the minutes
				Display_Value time_of_day_minutes



			Case 5											'Changing Number of Locations

'				Display_Functions setting_mode
				Display_Value max_location

				mpss_int = Change_Value(max_location)
				max_location = mpss_int

				If (max_location>99) Then max_location =99
				If (max_location<1) Then max_location =1
				Eewrite EE_NUMBER_OF_LOCATIONS, max_location, 2
				Display_Value max_location



			Case 11											'Changing Rotary Type

'				Display_Functions setting_mode
				Display_Value rotary_type

				mpss_int = Change_Value(rotary_type)
				rotary_type = mpss_int

				If (rotary_type>2) Then rotary_type = 1
				If (rotary_type<1) Then rotary_type = 2
				Eewrite EE_ROTARY_TYPE, rotary_type, 2
				Display_Value rotary_type



			Case 12											'Changing Weight Unit

'				Display_Functions setting_mode
				Display_Value weight_unit

				mpss_int = Change_Value(weight_unit)
				weight_unit = mpss_int

				If (weight_unit>2) Then weight_unit = 1
				If (weight_unit<1) Then weight_unit = 2
				Eewrite EE_WEIGHT_UNIT, weight_unit, 2
				Display_Value weight_unit



			Case 13											'Changing Unit Number

'				Display_Functions setting_mode
				Display_Value unit_number

				mpss_int = Change_Value(unit_number)
				unit_number = mpss_int

				If (unit_number>9999) Then unit_number = 1
				If (unit_number<1) Then unit_number = 9999
				Eewrite EE_UNIT_NUMBER, unit_number, 2
				Display_Value unit_number



			Case 14												'SECOND SETTING

'				Display_Functions setting_mode
				time_of_day_seconds = BCD2Bin(Time(TIME_SECONDS_BCD))
				Display_Value time_of_day_seconds

				mpss_int = Change_Value(time_of_day_seconds)
				time_of_day_seconds = mpss_int

				If (time_of_day_seconds>TIME_SECONDS_MAX) Then
						time_of_day_seconds = TIME_SECONDS_MAX
				Elseif (time_of_day_seconds>999) Then
						time_of_day_seconds = TIME_SECONDS_MIN
				Endif
				Timeset TIME_SECONDS_BCD,Bin2BCD(time_of_day_seconds)	'   set the minutes
				Display_Value time_of_day_seconds



			Case Else

				setting_mode = 1              											'	N: NEITHER, SET accel_amount = 0         
				accel_amount = 0


			End Select
		

	Endif
		

End Sub




'===============================================================================
' DISPLAY SYMBLE ON DISPLAYER
'===============================================================================
Sub Display_Functions (sym_1 As Byte)

Led Var Byte
Temp_sym Var Byte
Temp_sym = Bin2BCD(sym_1)

		For Led = 0 to 3
			Csgxput DISPLAY_0, led, 0x00
			Csgxput DISPLAY_1, Led, 0x00
		Next

		Csgxput DISPLAY_2, 1, 0x00
		Csgxput DISPLAY_2, 0, 0x71
		Csgxput DISPLAY_2, 2, Seven_Segment(Temp_sym.Nib1)
		Csgxput DISPLAY_2, 3, Seven_Segment(Temp_sym.Nib0)

End Sub


'===============================================================================
' DISPLAY VALUE ON DISPLAY
'===============================================================================
Sub Display_Value(dis_val As integer) 				' display setting value

	dis_temp	var	integer

    dis_temp = dis_val
    dis_temp = Bin2bcd(dis_temp)
		If (setting_mode>0 and setting_mode<5) Then
			Csgxput DISPLAY_3, 0, Seven_Segment(dis_temp.Nib3) + 0x80	' 1000s place
			Csgxput DISPLAY_3, 1, Seven_Segment(dis_temp.Nib2)			'  100s place
		Elseif (setting_mode=6) Then
			Csgnput DISPLAY_3, 0, 0x032
			Csgnput DISPLAY_3, 1, 0x030
		Elseif (setting_mode=13) Then
			Csgxput DISPLAY_3, 0, Seven_Segment(dis_temp.Nib3)			' 1000s place
			Csgxput DISPLAY_3, 1, Seven_Segment(dis_temp.Nib2)			'  100s place
		Else
			Csgxput DISPLAY_3, 0, 0
			Csgxput DISPLAY_3, 1, 0
		Endif
		Csgxput DISPLAY_3, 2, Seven_Segment(dis_temp.Nib1)			'   10s place
		Csgxput DISPLAY_3, 3, Seven_Segment(dis_temp.Nib0)			'    1s place

End Sub



'===============================================================================
' DISPLAY NUMBERS ON DISPLAYER
'===============================================================================
Sub Display_Numbers(dis_data As Integer)

		Csgxput DISPLAY_3, 0, Seven_Segment(dis_data.Nib3) + 0x80 	' 1000s place
		Csgxput DISPLAY_3, 1, Seven_Segment(dis_data.Nib2)					' 100s place
		Csgxput DISPLAY_3, 2, Seven_Segment(dis_data.Nib1) 				' 10s place
		Csgxput DISPLAY_3, 3, Seven_Segment(dis_data.Nib0)   			' 1s place

End Sub


'===============================================================================
' INC or DEC PRESSED
'===============================================================================
Function Change_Value(iodp As Integer)

	tempvar Var Integer
	tempvar = iodp

			If ( (switches.PB_CLEAR_TOTAL_BIT = PB_PRESSED)  And _						'	INCREASE KEY PRESSED
			   	(leds.LED_RUNNING_BIT = NOT_RUNNING) )   Then
					tempvar = Setting_Push_Button( INCDEC_MORE, iodp)
					iodp = tempvar

			Elseif ( (switches.PB_GRAND_TOTAL_BIT = PB_PRESSED)  And _				'	DECREASE KEY PRESSED
				   (leds.LED_RUNNING_BIT = NOT_RUNNING ) )   Then				'	   Y: DECREASE THE VALUE
					tempvar = Setting_Push_Button( INCDEC_LESS, iodp)
					iodp = tempvar

			Else																		'	N: NEITHER, SET accel_amount = 0
					accel_amount = 0
	
			Endif
			Change_Value = iodp

'debug "change value =", dec iodp, "     temp = ", dec tempvar, cr

End Function



'===============================================================================
' INCDEC WITH ACCELERATION
'===============================================================================
Function  Setting_Push_Button (incdec_x As Byte, parameter As Integer) As Integer

	param_temp Var Integer
	param_temp = parameter


	If (accel_amount = 0) Then
		accel_amount = 1							' amount of acceleration (until it is increased)
		accel_delay  = 0							' delay before next increase of parameter_x
		accel_repeat = ACCELERATION_REPEATS			' number of repeats of same acceleration before changing

		If (incdec_x = 1) Then														' first increment/decrment
				param_temp = parameter + accel_amount					'	increase value
				If (param_temp > MAX_POSITIVE_INTEGER) Then		'	above the max. limit
					param_temp = MAX_POSITIVE_INTEGER						' set parameter to max. limit
				Endif
		Else
				param_temp = parameter - accel_amount					' decrease value
				If (param_temp > MAX_POSITIVE_INTEGER) Then		' number became negative
					param_temp = 0															' set to 0 (min. limit)
				Endif
		Endif
	Endif


	If (accel_delay > 0) Then
			Decr accel_delay
			If (accel_repeat < ACCELERATION_REPEATS-1) or (accel_amount > 1) Then
					If (incdec_x = 1) Then														' first increment/decrment
							param_temp = parameter + accel_amount					'	increase value
							If (param_temp > MAX_POSITIVE_INTEGER) Then		'	above the max. limit
								param_temp = MAX_POSITIVE_INTEGER						' set parameter to max. limit
							Endif
					Else
							param_temp = parameter - accel_amount					' decrease value
							If (param_temp > MAX_POSITIVE_INTEGER) Then		' number became negative
								param_temp = 0															' set to 0 (min. limit)
							Endif
					Endif
			Endif
	Else

			accel_delay = ACCELERATION_DELAY					' set the delay before next (possible) change
			'accel_delay = ACCEL_DELAY_MAX - accel_amount			' same as above but for larger parameter ranges
			If (accel_amount > ACCELERATION_MAX) Then				' above maximum acceleration limit
					accel_amount = ACCELERATION_MAX							' set acceleration to maximum
			Endif

			If (accel_repeat > 0) Then
				Decr accel_repeat

			Else
				accel_repeat = ACCELERATION_REPEATS					' number of time to repeat the same acceleration
				'accel_amount = 2*accel_amount + 1					' acceleration formula

				If (accel_amount = 1) Then
					accel_amount = 10
				Elseif (accel_amount = 10) Then
					accel_amount = 20
				Elseif (accel_amount = 20) Then
					accel_amount = 50
				Else
					accel_amount = 100
				Endif

			Endif

	Endif
	Setting_Push_Button = param_temp

'	Debug "IncDec=", dec incdec_x, "    Acc_Amt=", dec accel_amount, "    Acc_dly=", dec accel_delay
'	Debug "    Acc_rept=", dec accel_repeat, cr



End Function



'===============================================================================
' FUNCTION KEY WITH ACCELERATION PLUS
'===============================================================================
Function  Function_Button_Incr (fparameter As Integer) As Integer

	fparam_temp Var Integer
	fparam_temp = fparameter


		If (faccel_amount = 0) Then
			faccel_amount = 1										' amount of acceleration (until it is increased)
			faccel_delay = ACCELERATION_DELAY		' delay before next increase of parameter_x
			Incr fparam_temp										'	increase value
		Endif
	
		If (faccel_delay>0) Then
			Decr faccel_delay
		Else
			faccel_delay = ACCELERATION_DELAY					' set the delay before next (possible) change
			Incr fparam_temp
		Endif

	Function_Button_Incr = fparam_temp

'	Debug "    Acc_Amt=", dec faccel_amount, "    Acc_dly=", dec faccel_delay, cr


End Function


'===============================================================================
' FUNCTION KEY WITH ACCELERATION MINUS
'===============================================================================
Function  Function_Button_Decr (fparameter As Integer) As Integer

	fparam_temp Var Integer
	fparam_temp = fparameter


		If (faccel_amount = 0) Then
			faccel_amount = 1										' amount of acceleration (until it is increased)
			faccel_delay = ACCELERATION_DELAY		' delay before next increase of parameter_x
			Decr fparam_temp										'	increase value
		Endif
	
		If (faccel_delay>0) Then
			Decr faccel_delay
		Else
			faccel_delay = ACCELERATION_DELAY					' set the delay before next (possible) change
			Incr fparam_temp
		Endif

	Function_Button_Decr = fparam_temp

'	Debug "    Acc_Amt=", dec faccel_amount, "    Acc_dly=", dec faccel_delay, cr


End Function



'===============================================================================================
sub time_setting_test()

mpss Var integer
mpss_int Var integer
mpss_intb Var integer

'----------------------------------------------------------------------------------
																		'DATE AND TIME SETTING
' READ DATE AND TIME
			time_of_year = BCD2Bin(Time(TIME_YEARS_BCD))
			time_of_month = BCD2Bin(Time(TIME_MONTHS_BCD))
			time_of_date = BCD2Bin(Time(TIME_DATES_BCD))
			time_of_day_seconds = BCD2Bin(Time(TIME_SECONDS_BCD))
			time_of_day_minutes = BCD2Bin(Time(TIME_MINUTES_BCD))
			time_of_day_hours = BCD2Bin(Time(TIME_HOURS_BCD))



' ADJUSTING TIME AND DATE
	select case setting_mode
		case 1
		If ( (switches.PB_MORE_BIT = PB_PRESSED)  And  _					' INCREASE THE DATE VALUE
					(leds.LED_RUNNING_BIT <> RUNNING)  )  Then
				mpss_int = Setting_Push_Button( INCDEC_MORE, time_of_date )
				time_of_date = mpss_int

				If (time_of_month=2) Then
					If (time_of_date>29) Then
						Incr time_of_month
						time_of_date = 1
					Endif
				ElseIf (time_of_month=4) or (time_of_month=6)	or (time_of_month=9) or (time_of_month=11) Then
					If (time_of_date>30) Then
						Incr time_of_month
						time_of_date = 1
					Endif
				Else
					If (time_of_date>31) Then
						Incr time_of_month
						time_of_date = 1
					Endif
				Endif

				If (time_of_month>12)	Then
						Incr time_of_year
						time_of_month = 1
				Endif
				If (time_of_year>99) Then time_of_year = 0


		ElseIf ( (switches.PB_LESS_BIT = PB_PRESSED)  And  _			' DECREASE THE DATE VALUE
						(leds.LED_RUNNING_BIT <> RUNNING)  )  Then
				mpss_int = Setting_Push_Button( INCDEC_LESS, time_of_date )
				time_of_date = mpss_int

				If (time_of_date=0) Then
					If (time_of_month=3) Then 
							time_of_date = 29
							Decr time_of_month
					ElseIf (time_of_month=5) or (time_of_month=7)	or (time_of_month=10) or (time_of_month=12) Then
							time_of_date = 30
							Decr time_of_month
					Else
							time_of_date = 31
							Decr time_of_month
					Endif
				Endif
				If (time_of_month=0) Then
					Decr time_of_year
					time_of_month = 12
				Endif
				If (time_of_year>99) Then time_of_year = 0


		ElseIf ( (switches.PB_CLEAR_TOTAL_BIT = PB_PRESSED)  And  _	' INCREASE THE TIME VALUE
		        (leds.LED_RUNNING_BIT <> RUNNING)  )  Then
				mpss_int = Setting_Push_Button( INCDEC_MORE, time_of_day_minutes )
				time_of_day_minutes = mpss_int
				If (time_of_day_minutes>59) Then
					Incr time_of_day_hours
					time_of_day_minutes = 0
				Endif
				If (time_of_day_hours>23)	Then time_of_day_hours = 0


		ElseIf ( (switches.PB_GRAND_TOTAL_BIT = PB_PRESSED) And _		' DECREASE THE TIME VALUE
						(leds.LED_RUNNING_BIT <> RUNNING)  )  Then
				mpss_int = Setting_Push_Button( INCDEC_LESS, time_of_day_minutes )
				time_of_day_minutes = mpss_int
				If (time_of_day_minutes=0) Then
					Decr time_of_day_hours
					time_of_day_minutes = 59
				Endif
				If (time_of_day_hours>23)	Then time_of_day_hours = 23


		ElseIf ( (switches_asserted.PB_CYCLES_PLUS_BIT = PB_PRESSED)  And  _					' INCREASE THE YEAR VALUE
					(leds.LED_RUNNING_BIT <> RUNNING)  )  Then
				mpss_int = Setting_Push_Button( INCDEC_MORE, time_of_year )
				time_of_year = mpss_int
				If (time_of_year>99) Then time_of_year = 0

		Else																		'	N: NEITHER, SET accel_amount = 0
				accel_amount = 0										'	   NOTE: accel_amount IS A VALUE AND FLAG
	
		Endif

		If (time_of_year>24) Then time_error = 0
		Timeset TIME_MINUTES_BCD,Bin2BCD(time_of_day_minutes)	'   set the minutes
		Timeset TIME_HOURS_BCD,Bin2BCD(time_of_day_hours)		'   set the hours
		Timeset TIME_DATES_BCD,Bin2BCD(time_of_date)				'		set the date
		Timeset TIME_MONTHS_BCD,Bin2BCD(time_of_month)			'   set the month
		Timeset TIME_YEARS_BCD,Bin2BCD(time_of_year)				'   set the year


' DISPLAY DATE AND TIME ON DISPLAYER
			Csgdec DISPLAY_1, 2000 + time_of_year
			mpss_int = time_of_month * 100 + time_of_date
			mpss_intb = time_of_day_hours * 100 + time_of_day_minutes
			Csgdec DISPLAY_2, mpss_int
			If time_of_day_hours = 0 Then Csgxput DISPLAY_3, 2, &H00 Else Csgdec DISPLAY_3, mpss_intb

'----------------------------------------------------------------------------------
		Case 3						'LOCATIONS AND WEIGHT UNIT SETTING

			Csgxput DISPLAY_1, 0, 0x008
			Csgxput DISPLAY_1, 1, 0x008
			If (weight_unit<1) or (weight_unit>2) Then weight_unit=1
			If (weight_unit=2) Then
					Csgxput DISPLAY_1, 2, 0x038													' Weight Unit is LB
					Csgxput DISPLAY_1, 3, 0x07C
			Else
					Csgxput DISPLAY_1, 2, 0x076													' Weight Unit is KG
					Csgxput DISPLAY_1, 3, 0x06F
			EndIf
			
			Csgxput DISPLAY_2, 0, 0x008
			Csgxput DISPLAY_2, 1, 0x008
			mpss_intb = Bin2BCD(max_location)
			Csgxput DISPLAY_2, 2, Seven_Segment(mpss_intb.Nib1)			'	Display Max Locations
			Csgxput DISPLAY_2, 3, Seven_Segment(mpss_intb.Nib0)
			If ( (switches.PB_MORE_BIT = PB_PRESSED)  And  _				'	WANTING TO INCREASE THE VALUE
			     (leds.LED_RUNNING_BIT <> RUNNING) )  Then
				mpss_int = Setting_Push_Button( INCDEC_MORE, max_location )
				max_location = mpss_int
				If (max_location>99) Then max_location =99
'Debug " = = = = = MAX_LOCATION = = = ", Dec max_location, Cr
				
			Elseif ( (switches.PB_LESS_BIT = PB_PRESSED)  And  _		'	WANTING TO DECREASE THE VALUE
			       (leds.LED_RUNNING_BIT <> RUNNING) )  Then
				mpss_int = Setting_Push_Button( INCDEC_LESS, max_location )
				max_location = mpss_int
				If (max_location<3) Then max_location =3
'				mpss_intb = Bin2BCD(max_location)
'				Csgxput DISPLAY_2, 2, Seven_Segment(mpss_intb.Nib1)		'	Display Max Locations
'				Csgxput DISPLAY_2, 3, Seven_Segment(mpss_intb.Nib0)
'Debug " = = = = = MAX_LOCATION = = = ", Dec max_location, Cr

			Else																		'	N: NEITHER, SET accel_amount = 0
				accel_amount = 0											'	NOTE: accel_amount IS VALUE AND FLAG
	
			Endif

			Eewrite EE_UNIT_NUMBER, unit_number, 2
			
'			Display_Symble DISPLAY_3, 0x008												'CHANGE UNMBER OF ROTARY CHAMBER
			Csgxput DISPLAY_3, 0, 0x008
			Csgxput DISPLAY_3, 1, 0x008
			Csgxput DISPLAY_3, 2, 0x008
			If (unit_number<1) or (unit_number>2) Then unit_number=1
			If unit_number=1 Then
					Csgxput DISPLAY_3, 3, 0x077										' GROUP A ONLY
			Else
					Csgxput DISPLAY_3, 3, 0x02										' GROUP A/B
			Endif

'----------------------------------------------------------------------------------

		Case Else

		            accel_amount = 0        											'	N: NEITHER, SET accel_amount = 0         

		End Select


End Sub



#Endif


