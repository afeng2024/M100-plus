'FILE= "state_machine.bas"

#ifndef  STATE_MACHINE_BAS
#define  STATE_MACHINE_BAS	123


'===============================================================================
' STATE MACHINE
'===============================================================================
Sub  State_Machine()

	sm_i Var Byte

	If (switches.SW_PRESSURE_BIT = SW_PRESSURE_NOT_OK) Then
		special_flags.END_REQ_BIT = 1				' PRESSURE FAILURE STOPS SYSTEM AS SOON AS PRACTICABLE
		machine_state = 255							' GO TO SPECIAL STATE
	Endif

'debug "GL=",dec2 group_pointer,dec3 line_pointer,Cr

	Select Case machine_state
	'----------------------------------------------------------------------------
	Case 0		'WAIT/IDLE STATE

		' TO LEAVE THIS STATE, AN EXTERNAL FUNCTION MUST SET machine_state = 1
		' E.G.:Begin_Program_Handler() SETS machine_state = 1 UNDER THE RIGHT CONDITIONS
		
		leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF			'STOP FEEDING AND
		leds.LED_RUNNING_BIT = NOT_RUNNING							'END FEEDING PROGRAM

		If kg_per_rot_changed = 1 And _						'?: CHANGING KG/ROTATION FLAG SET
			accel_amount = 0  Then
			Save_Schedule_Line_To_EEprom  0, group_pointer	'Y: SAVE THE NEW SG & DELIVERY FACTOR
			kg_per_rot_changed = 0							'	AND CLEAR THE FLAG

			Calc_Feed_Rate									'	AND CALCULATE NEW FEED RATE CONSTANT
		Endif
		
	'----------------------------------------------------------------------------
	Case 1		'BEGIN RUNNING DELIVERY SCHEDULE
'Debug"01 "

		If ((special_flags.END_REQ_BIT) Or  _						'?: END-PROGRAM REQUESTED
		   (leds.LED_EMPTY_ALARM_BIT = EMPTY_ALARM_ON)) Then		'   or ALARM DETECTED
			machine_state = 255										'Y: TERMINATE PROGRAM
		Else


	'=--=--= M100+ added begin
				if (data_exchange = 0) then
				 data_exchange = 1
				endif
'				debug "1 -- comm_state = ", dec data_exchange, cr
	'=--=--= M100+ added end


			leds.LED_RUNNING_BIT = RUNNING							'N: SYSTEM IS RUNNING
			leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF		'	BUT SYSTEM IS NOT DISPENSING FEED

			schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer) = 0	'   CLEAR DELIVERED AMOUNT

			If schedule(SCHEDULE_PRESET, line_pointer, group_pointer) = 0 Then	'	?: FEED TO BE DELIVERED = 0
				machine_state = 20												'	Y: NOTHING TO DO
			Else
				Save_Schedule_Line_To_EEprom  line_pointer, group_pointer		'	N: SAVE VOLUMES & TOTALS
				Save_Grand_Total_To_EEprom  group_pointer

				feed_volume_added_f = 0.0										'	   PRESUME AN EMPTY DISPENSER "CHAMBER"
				schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer) = 0	'	   CLEAR VOLUME DELIVERED VALUE
				machine_state = 30												'	   START FEEDING
			Endif

		Endif

	'----------------------------------------------------------------------------
	Case 20		'NO FEED TO BE DELIVERED
'Debug"20 "

		If ((special_flags.END_REQ_BIT) Or  _						'?: END-PROGRAM REQUESTED
			(leds.LED_EMPTY_ALARM_BIT = EMPTY_ALARM_ON)) Then		'   or ALARM DETECTED
			machine_state = 255										'Y: TERMINATE PROGRAM
		Else
			leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF		'N: ENSURE FEEDING IS STOPPED
		Endif

	'----------------------------------------------------------------------------
	Case 30		'START FEEDING
'Debug"30 "

		If (special_flags.END_REQ_BIT) Then							' ?: END-PROGRAM REQUESTED
			leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF		' STOP FEEDING IMMEDIATELY
			machine_state = 255										' Y: GO TO SPECIAL STATE
		Else
			schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer) = 0	' RESET AMOUNT DELIVERED
			If (leds.LED_EMPTY_ALARM_BIT = EMPTY_ALARM_OFF) Then	' ?: FEED LEVEL OK
				machine_state = 50							   		' Y: GO TO STATE 50
			Else													' N:
				machine_state = 40									'    GO TO STATE 40
			Endif
		Endif

	'----------------------------------------------------------------------------
	Case 40		'FEED LEVEL NOT OK
'Debug"40 "

		If (special_flags.END_REQ_BIT) Then				' ?: WAIT FOR END PROGRAM REQUESTED
			machine_state = 255							' Y: GO TO SPECIAL/TERMINATION STATE
		Endif

	'----------------------------------------------------------------------------
	Case 50		'FEED LEVEL OK
'Debug"50 "

		If (special_flags.END_REQ_BIT) Then						' ?: END FEEDING PROGRAM REQUESTED
			machine_state = 255										' Y: GO TO SPECIAL STATE (NEXT SYSTEM 'TIC')
		Else																' N: NORMAL FEEDING PROGRAM
			If (leds.LED_PAUSED_BIT = NOT_PAUSED) Then
				If schedule(SCHEDULE_DELIVERED, line_pointer, group_pointer) >=  _
				   schedule(SCHEDULE_PRESET, line_pointer, group_pointer) Then		'?: NORMAL End
					leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF				'Y: STOP FEEDING AND
					machine_state = 60												'   WAIT FOR TIME OVER
				Else															' NO: PRESET AMOUNT NOT YET DELIVERED
					If (leds.LED_EMPTY_ALARM_BIT = EMPTY_ALARM_OFF) Then		' 	  ?: FEED LEVEL OK
						If (leds.LED_PAUSED_BIT = NOT_PAUSED) Then				' 	  Y: ?: NOT PAUSED
							leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_ON	'    	 Y: KEEP FEEDING
						Else													'
							leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF	'		 N: STOP FEEDING 
						Endif
					Else														' 	  N: FEED LEVEL A NOT OK
						leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF		'    	 STOP FEEDING
						machine_state = 40										'  		 GO TO STATE 40
					Endif
				Endif
			Endif
	   Endif

	'----------------------------------------------------------------------------
	Case 60		'PRESET FEED AMOUNT DELIVERED
'Debug"60 "

'		Save_Schedule_Line_To_EEprom  line_pointer, group_pointer	' UPDATE THE EEPROM VALUES
		
'		Save_Grand_Total_To_EEprom  group_pointer

		machine_state = 255										' GO TO SPECIAL STATE

	'----------------------------------------------------------------------------
	Case Else		' STATE "255" = SPECIAL/TERMINATION STATE
'Debug"255 "

		leds.LED_DISPENSER_POWER_BIT = DISPENSER_POWER_OFF		' STOP FEEDING AND WAIT
		leds.LED_RUNNING_BIT = NOT_RUNNING						' NOT RUNNING
		leds.LED_PAUSED_BIT = NOT_PAUSED						' NOT PAUSED

		Save_Schedule_Line_To_EEprom  line_pointer, group_pointer	' UPDATE THE EEPROM VALUES

		Save_Grand_Total_To_EEprom  group_pointer

		
		'=--=--= M100+ added begin
			Data_exchange_process
		'=--=--= M100+ added end


		special_flags.END_REQ_BIT = 0					' ACKNOWLEDGE END PROGRAM REQUEST
		machine_state = 0								' GO TO WAIT/IDLE STATE

	'----------------------------------------------------------------------------
	End Select

End Sub




#endif

