'FILE= "constants.inc"

#ifndef  CONSTANTS_INC
#define  CONSTANTS_INC	123


'==============================================================================
'CUBLOC CB290 FEATURES
'==============================================================================
' CPU module: CPU with Ladder-Logic
' Package:		108-pin module
' IO ports:		91KB
' Flash memory:	80KB
' Data memory:	28KB
' EEPROM":       4KB
' ADC: 8-chan. 10-bit
' PWM: 6-chan. 16-bit
' RTC
' 2 RS232 Channels/Ports
' Modbus Master or Slave


'===============================================================================
' SOURCE OF INITIALIZATION (0=FRAM,NORMAL; 1=WRITE TO AND READ FROM FRAM)
'===============================================================================
#define  INIT_NORMAL_FROM_FRAM				0	'AT START: VARIABLES RESTORED AS NORMAL FROM FRAM
#define  INIT_TEST_PATTERN_INTO_FRAM	1	'AT START: FRAM LOADED WITH SPECIAL TEST PATTERN
#define  INIT_ALL_NECESSARY						2	'AT START: INITIALIZE ONLY WHAT IS NECESSARY
#define  INIT_SIMPLE_TEST_SCHEDULE		3	'AT START: INITIALIZE SIMPLE TEST SCHEDULE

#define  INITIALIZATION_SOURCE			INIT_NORMAL_FROM_FRAM



'===============================================================================
' TESTS WHICH TESTPOINT_1 PINOUT WILL REPRESENT
'===============================================================================
#define  TESTPOINT_1_NOTHING					0	'SHOW NOTHING
#define  TESTPOINT_1_TIMER_TIC				1	'SAME AS SYSTEM TIC
#define  TESTPOINT_1_DISPENSER_PULSE	2	'ISR3 = DISPENSER SENSOR PULSE
#define  TESTPOINT_1_EEPROM_WRITE			3	'WRITE schedule_presets(0),100 TO EEPROM
'
'CHOOSE WHAT TESTPOINT_1 WILL REPRESENT 
'
#define  TESTPOINT_1_INDICATOR		TESTPOINT_1_TIMER_TIC


'===============================================================================
' SYSTEM "TIC" (TIMER IRQ)
'===============================================================================
#define  TIMER_TIME_BASE					0.01	' 0.01sec = TIME UNIT FOR SYSTEM "TIC"
#define  TIMER_ISR_INTERVAL  			2			' 1=10ms, 2=20ms, 3=30ms, etc
#define  CLOCK_TICS_PER_SECOND		50		' 1.0 / (TIMER_ISR_INTERVAL * TIMER_TIME_BASE)



'===============================================================================
' TESTPOINTS DEFINITIONS
'===============================================================================
#define  TESTPOINT_0			  20	' NORMALLY USED FOR SYSTEM "HEARTBEAT"
#define  HEARTBEAT_LED	 TESTPOINT_0

#define  TESTPOINT_1			  21	' NORMALLY USED FOR AN OSCILLOSCOPE "STETHOSCOPE"
#define  STETHOSCOPE_LED TESTPOINT_1

#define  SHOW_SPECIFIC_TESTING     0	' FOR TEMPORARY AND SPECIFIC TESTING ONLY
#define  SHOW_DISPENSER_INDEXER	   1	' NARROW PULSE WHEN INDEXER CAUSES IRQ3
#define  SHOW_IR_BEAM_DETECTED     2	' SHOW IR BEAM PULSE RECEIVED INTERRUPT
#define  SHOW_IR_BEAM_PROCESSING   3	' SHOW PROCESS TO DETECT EMPTY HOPPER
#define  SHOW_TIMER_ISR					   4	' SHOW THE SYSTEM "TIC" TIME CONSUMED

#define  TESTPOINT_1_PULSES       SHOW_TIMER_ISR	' SHOWS DURING NORMAL RUNNING


'===============================================================================
' HEARTBEAT DEFINITIONS (TIMING WAS EMPERICALLY DETERMINED)
'===============================================================================
'THE FOLLOWING IS BASED ON A 20ms TIMER_ISR "TIC"
#define  HEARTBEAT_TIME_1       1			' LED IS ON  UNTIL HEARTBEAT_TIME_1
#define  HEARTBEAT_TIME_2       11		' LED IS OFF UNTIL HEARTBEAT_TIME_2
#define  HEARTBEAT_TIME_3       12		' LED IS ON  UNTIL HEARTBEAT_TIME_3
#define  HEARTBEAT_PERIOD       50		' LED STAYS OFF UNTIL PERIOD ENDS


'===============================================================================
' REFERENCE FOR US POOR "SOTS" WHO ARE USED TO "C" OR "C++" PROGRAMMING
'-------------------------------------------------------------------------------
' Byte 		=   +  8 bit number: 0 to   255
' Integer	=   + 16 bit number: 0 to +65535
' Long		= +/- 32 bit number: -2147483648 to +2147483647
' Single	= 32 bit floating-point number: -3.402823E+38 to +3.402823E+38
' String	= character string: 0 to 127 bytes
'-------------------------------------------------------------------------------
#define  MAX_POSITIVE_INTEGER    0x7FFF


'===============================================================================
' POWER MONITOR LINE
'===============================================================================
#define  POWER_MONITOR			 91		' Input Port for monitoring power supply


'===============================================================================
' COMMUNICATION BAUD RATE
'===============================================================================
#define  BAUD_RATE				 9600		' Baud rate for RS-232 port setting


'===============================================================================
' SWITCHES AND PUSHBUTTONS DEFINITIONS
'===============================================================================
#define  DEBOUNCE_DELAY		3	'units of system "tic" (typ. multiples of 10 ms)


'===============================================================================
#define  AUX_SW_PORTBLOCK_L		 7	'CB290's Port Block  7 = Port bits P56 through P63
#define  AUX_SW_PORTBLOCK_H		 8	'CB290's Port Block  8 = Port bits P64 through P71
'===============================================================================
#define  AUX_SW_00		56
#define  AUX_SW_01		57
#define  AUX_SW_02		58
#define  AUX_SW_03		59
#define  AUX_SW_04		60
#define  AUX_SW_05		61
#define  AUX_SW_06		62
#define  AUX_SW_07		63
'--------------------------------------------------
#define  AUX_SW_08		64
#define  AUX_SW_09		65
#define  AUX_SW_10		66
#define  AUX_SW_11		67
#define  AUX_SW_12		68
#define  AUX_SW_13		69
#define  AUX_SW_14		70
#define  AUX_SW_15		71
'-------------------------------------------------------------------------------
#define  HOPPER_MANUAL_SELECT_A			AUX_SW_00		' FEEDBACK FROM MANUAL GATE SENSOR A
#define  HOPPER_MANUAL_SELECT_A_BIT			0
#define  HOPPER_MANUAL_SELECT_A_MASK		1<<HOPPER_MANUAL_SELECT_A_BIT
#define  BIT_HOPPER_MANUAL_SELECT_A			BIT0
'--------------------------------------------------------------
#define  HOPPER_MANUAL_SELECT_B			AUX_SW_01		' FEEDBACK FROM MANUAL GATE SENSOR B
#define  HOPPER_MANUAL_SELECT_B_BIT			1
#define  HOPPER_MANUAL_SELECT_B_MASK		1<<HOPPER_MANUAL_SELECT_B_BIT
#define  BIT_HOPPER_MANUAL_SELECT_B			BIT1
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_02		AUX_SW_02		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_03		AUX_SW_03		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_04		AUX_SW_04		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_05		AUX_SW_05		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_06		AUX_SW_06		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_07		AUX_SW_07		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_08		AUX_SW_08		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_09		AUX_SW_09		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_10		AUX_SW_10		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_11		AUX_SW_11		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_12		AUX_SW_12		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_13		AUX_SW_13		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_14		AUX_SW_14		' NOT USED AT THIS TIME
'--------------------------------------------------------------
#define  AUX_SW_NOT_USED_15		AUX_SW_15		' NOT USED AT THIS TIME
'===============================================================================


'===============================================================================
' AUXILIARY SWITCHES MASK
'===============================================================================
' A GENERALIZED LOGIC STATEMENT CAN GENERATE A BIT MASK FROM THE ABOVE
' HOWEVER, THE CUBLOC BASIC COMPILER HAS SOME LIMITATIONS.  SO, THE
' FOLLOWING MASK WAS QUICKLY CREATED USING BRUTE FORCE 'BIT BASHING'.

#define  AUX_SW_MASK	0B0000000000000011


'===============================================================================
#define  SW_PORTBLOCK_L		 9	'CB290's Port Block  9 = Port bits P72 through P79
#define  SW_PORTBLOCK_H		10	'CB290's Port Block 10 = Port bits P80 through P87
'===============================================================================
' CB290-BASED CONTROLLERS DO NOT DRAW A DISTINCTION BETWEEN SWITCHES, PUSHBUTTONS
' AND LOGIC-LEVEL INPUTS.  ALL ARE HANDLED AS LOGIC LEVELS (T=1,F=0)
'       SWITCH#   PORT#
'-------------------------------------------------------------------------------
#define  SW_00		72
#define  SW_01		73
#define  SW_02		74
#define  SW_03		75
#define  SW_04		76
#define  SW_05		77
#define  SW_06		78
#define  SW_07		79
'--------------------------------------------------
#define  SW_08		80
#define  SW_09		81
#define  SW_10		82
#define  SW_11		83
#define  SW_12		84
#define  SW_13		85
#define  SW_14		86
#define  SW_15		87
'-------------------------------------------------------------------------------
#define  PB_BEGIN		  		SW_00	' SW: BEGIN PROGRAM (CYCLES)
#define  PB_END			  		SW_01	' SW: END PROGRAM (CYCLES)                       
#define  PB_PAUSE  	  			SW_02	' SW: PAUSE PROGRAM (DISPENSER POWER OFF)        
#define  PB_SELECT_AB 	 		SW_03	' SW: SELECT A OR B (SELECT FOR PARAMETERS)   
#define  PB_MORE		  		SW_04	' SW: MORE PB (INCREMENTS DISPLAY VALUE)             
#define  PB_LESS		  		SW_05	' SW: LESS PB (DECREMENTS DISPLAY VALUE)             
#define  PB_CYCLES_PLUS			SW_06	' CYCLES PB (INCREMENTS SCHEDULE LINE NUMBER)    
#define  PB_GRAND_TOTAL  		SW_07	' GRAND TOTAL (USED WITH SW_CLEAR_TOTALS) 
'--------------------------------------------------
#define  SW_PRESSURE			SW_08	' BLOWER OR PUMP PRESSURE
#define  SW_FEED_LEVEL_A		SW_09	' FEED LEVEL A
#define  SW_FEED_LEVEL_B		SW_10	' FEED LEVEL B
#define  SW_NOT_USED_1			SW_11	' NOT USED AT THIS TIME
#define  SW_NOT_USED_2			SW_12	' NOT USED AT THIS TIME
#define  PB_TIME				SW_13	' TIME/CLOCK ENABLING AND FUNCTIONS
#define  PB_CLEAR_TOTALS		SW_14	' USED WITH DAILY TOTAL AND GRAND TOTAL
#define  PB_CLEAR_DELIVERED		SW_15	' USED FOR CLEARING DELIVERED AMOUNT
'-------------------------------------------------------------------------------
#define  PB_BIT_BEGIN				0		' use: if (buttons & (1 << PB_BEGIN))
#define  PB_BEGIN_BIT				BIT0	' use: buttons.PB_BEGIN_BIT
'----------------------------------------
#define  PB_BIT_END					1
#define  PB_END_BIT					BIT1
'----------------------------------------
#define  PB_BIT_PAUSE				2
#define  PB_PAUSE_BIT				BIT2
'----------------------------------------
#define  PB_BIT_SELECT_AB  			3
#define  PB_SELECT_AB_BIT			BIT3
'----------------------------------------
#define  PB_BIT_MORE				4
#define  PB_MORE_BIT				BIT4
'----------------------------------------
#define  PB_BIT_LESS				5
#define  PB_LESS_BIT				BIT5
'----------------------------------------
#define  PB_BIT_CYCLES_PLUS			6		' NOT USED ON THIS MODEL (CHECK MASKS)
#define  PB_CYCLES_PLUS_BIT			BIT6
'----------------------------------------
#define  PB_BIT_GRAND_TOTAL			7
#define  PB_GRAND_TOTAL_BIT			BIT7
'--------------------------------------------------
#define  SW_BIT_PRESSURE			8		' use: if (switches & (1 << SW_BIT_PRESSURE))
#define  SW_PRESSURE_BIT			BIT8	' use: switches.SW_PRESSURE_BIT
#define    SW_PRESSURE_OK			  	1
#define    SW_PRESSURE_NOT_OK		  	0
'----------------------------------------
#define  SW_BIT_FEED_LEVEL_A		9
#define  SW_FEED_LEVEL_A_BIT		BIT9
#define    FEED_LEVEL_OK			  	1
#define    FEED_LEVEL_NOT_OK		  	0
'----------------------------------------
#define  SW_BIT_FEED_LEVEL_B		10
#define  SW_FEED_LEVEL_B_BIT		BIT10
'----------------------------------------
#define  SW_BIT_FEED_LEVEL_C		11		' NOT USED AT THIS TIME
#define  SW_FEED_LEVEL_C_BIT		BIT11
'----------------------------------------
#define  IN_BIT_12_NOT_USED			12		' NOT USED AT THIS TIME
#define  IN_12_NOT_USED_BIT			BIT12
'----------------------------------------
#define  PB_BIT_TIME				13
#define  PB_TIME_BIT				BIT13
'
#define    TIME_PB_PRESSED				1
#define    TIME_PB_NOT_PRESSED			0
'----------------------------------------
#define  PB_BIT_CLEAR_TOTAL			14
#define  PB_CLEAR_TOTAL_BIT			BIT14
#define    CLEAR_TOTAL_ASSERTED			1
#define    DO_NOT_CLEAR_TOTAL			0
'----------------------------------------
#define  PB_BIT_CLEAR_DELIVERED		15
#define  PB_CLEAR_DELIVERED_BIT		BIT15
#define    CLEAR_ALARM_ASSERTED		  	1
#define    DO_NOT_CLEAR_ALARM		  	0
'===============================================================================


'===============================================================================
' SWITCHES MASK
'===============================================================================
' A GENERALIZED LOGIC STATEMENT CAN GENERATE A BIT MASK FROM THE ABOVE
' HOWEVER, THE CUBLOC BASIC COMPILER HAS SOME LIMITATIONS.  SO, THE
' FOLLOWING MASK WAS QUICKLY CREATED USING BRUTE FORCE 'BIT BASHING'.

#define  SW_MASK	0B1110011111111111

'--------------------------------------------------------------------------------------------+
' SWITCHES AND SW_MASK     1 1 1 0   0 1 1 1   1 1 1 1   1 1 1 1
'--------------------------------------------------------------------------------------------+
'                          F E D C   B A 9 8   7 6 5 4   3 2 1 0                    '
' 32768  CLEAR DELIVERED --+ | | |   | | | |   | | | |   | | | +-- BEGIN        1   '
' 16384  CLEAR TOTALS    --|-+ | |   | | | |   | | | |   | | +-|-- END          2   '
'  8192  TIME            --|-|-+ |   | | | |   | | | |   | +-|-|-- PAUSE        4   '
'  4096  (NOT USED)      --|-|-|-+   | | | |   | | | |   +-|-|-|-- A/B          8   '
'  2048  HOPPER LEVEL C  --|-|-|-|---+ | | |   | | | +- -|-|-|-|--  +           16  '
'  1024  HOPPER LEVEL B  --|-|-|-|---|-+ | |   | | +-|- -|-|-|-|--  -           32  '
'   512  HOPPER LEVEL A  --|-|-|-|---|-|-+ |   | +-|-|- -|-|-|-|-- CYCLES+      64  '
'   256  PRESSURE        --|-|-|-|---|-|-|-+   +-|-|-|- -|-|-|-|-- GRAND TOTAL  128 '
'--------------------------|-|-|-|---|-|-|-|---|-|-|-|- -|-|-|-|--------------------+
'    switches:  0x0300 =   0 0 0 0   0 0 1 1   0 0 0 0   0 0 0 0
'               0x0F00 =   0 0 0 0   1 1 1 1   0 0 0 0   0 0 0 0
'               0x0E00 =   0 0 0 0   1 1 1 0   0 0 0 0   0 0 0 0  = PRESSURE NOT OK
'               0x0D00 =   0 0 0 0   1 1 0 1   0 0 0 0   0 0 0 0  = FEED LEVEL A NOT OK
'               0x0B00 =   0 0 0 0   1 0 1 1   0 0 0 0   0 0 0 0  = FEED LEVEL B NOT OK
'               0x0700 =   0 0 0 0   0 1 1 1   0 0 0 0   0 0 0 0  = FEED LEVEL C NOT OK
'
'     SW_MASK:  0xE3FF =   1 1 1 0   0 0 1 1   1 1 1 1   1 1 1 1
'===============================================================================


'===============================================================================
' LEDS, PUSHBUTTONS OR SWITCHES ACTIVE, INACTIVE, SELECTED, NOT SELECTED, ETC.
'===============================================================================
#define  SELECTED				1
#define  NOT_SELECTED			0
'----------------------------------------
#define  PB_PRESSED				1
#define  PB_NOT_PRESSED			0
'----------------------------------------
#define  PB_ASSERTED			1
#define  PB_NOT_ASSERTED		0
'----------------------------------------
#define  PB_ACTIVE				1
#define  PB_INACTIVE			0
'----------------------------------------
#define  SW_OK					1
#define  SW_NOT_OK				0
'----------------------------------------
#define  SW_ON					1
#define  SW_OFF					0
'----------------------------------------
#define  SW_CLOSED				1
#define  SW_OPEN				0
'----------------------------------------
#define  SW_CONTACT				1
#define  SW_NO_CONTACT			0
'----------------------------------------
#define  SW_ACTIVE				1
#define  SW_INACTIVE			0
'===============================================================================


'===============================================================================
' LED DEFINITIONS
'-------------------------------------------------------------------------------
#define  LED_PORTBLOCK_L	 5		'CB290's Port Block 5 = Port bits P40 through P47
'-------------------------------------------------------------------------------
#define  LED_00			40		'CB290 Port40 (not Pin 40)
#define  LED_01			41		'...
#define  LED_02			42		'...
#define  LED_03			43		'...
#define  LED_04			44		'...
#define  LED_05			45		'...
#define  LED_06			46		'...
#define  LED_07			47		'CB290 Port47 (not Pin 47)
'-------------------------------------------------------------------------------
#define  LED_PORTBLOCK_H	6		'CB290's Port Block 6 = Port bits P48 through P55
'-------------------------------------------------------------------------------
#define  LED_08			48		'CB290 Port48 (not Pin 48)
#define  LED_09			49		'...
#define  LED_10			50		'...
#define  LED_11			51		'...
#define  LED_12			52		'...
#define  LED_13			53		'...
#define  LED_14			54		'...
#define  LED_15			55		'CB290 Port55 (not Pin 55)
'-------------------------------------------------------------------------------
#define  LED_RUNNING			LED_00	'  1 = PROGRAM (CYCLES) RUNNING (otherwise: ENDED)
#define  LED_PAUSED				LED_01	'  1 = PROGRAM PAUSED (PAUSED LED = ON)
#define  LED_A_SELECTED			LED_02	'  1 = ON = SELECTED
#define  LED_B_SELECTED			LED_03	'  1 = ON = SELECTED
#define  LED_GATE_TO_A			LED_04	'  1 = ON = ACTIVE
#define  LED_GATE_TO_B			LED_05	'  1 = ON = ACTIVE
#define  LED_DIVERTER_TO_A		LED_06	'  1 = ON = ACTIVE
#define  LED_DIVERTER_TO_B		LED_07	'  1 = ON = ACTIVE
'										'
#define  LED_TIME				LED_08	'  1 = ON = ACTIVE
#define  LED_NOT_USED_1			LED_09	'  NOT USED AT THIS TIME
#define  LED_NOT_USED_2			LED_10	'  NOT USED AT THIS TIME
#define  LED_NOT_USED_3			LED_11	'  NOT USED AT THIS TIME
#define  LED_NOT_USED_4			LED_12	'  NOT USED AT THIS TIME
#define  LED_DISPENSER_POWER	LED_13	'  1 = DISPENSER POWER ON
#define  LED_PRESSURE_ALARM		LED_14	'  1 = PRESSURE ALARM ON
#define  LED_EMPTY_ALARM		LED_15	'  1 = HOPPER EMPTY ALARM ON
'-------------------------------------------------------------------------------
#define  LED_BIT_RUNNING			0
#define  LED_RUNNING_BIT			BIT0
#define  RUNNING							1
#define  NOT_RUNNING					0
'----------------------------------------
#define  LED_BIT_PAUSED				1
#define  LED_PAUSED_BIT				BIT1
#define  PAUSED								1
#define  NOT_PAUSED						0
'----------------------------------------
#define  LED_BIT_A_SELECTED		2
#define  LED_A_SELECTED_BIT		BIT2
#define  A_SELECTED_ON				1
#define  A_SELECTED_OFF				0
'----------------------------------------
#define  LED_BIT_B_SELECTED		3
#define  LED_B_SELECTED_BIT		BIT3
#define  B_SELECTED_ON				1
#define  B_SELECTED_OFF				0
'----------------------------------------
#define  LED_BIT_GATE_A				4
#define  LED_GATE_A_BIT				BIT4
#define  GATE_OPEN						1
#define  GATE_CLOSED					0
'----------------------------------------
#define  LED_BIT_GATE_B				5
#define  LED_GATE_B_BIT				BIT5
'----------------------------------------
#define  LED_BIT_DIVERTER_A		6
#define  LED_DIVERTER_A_BIT		BIT6
#define  DIVERTER_OPEN				1
#define  DIVERTER_CLOSED			0
'----------------------------------------
#define  LED_BIT_DIVERTER_B		7
#define  LED_DIVERTER_B_BIT		BIT7
'========================================
#define  LED_BIT_TIME					8
#define  LED_TIME_BIT					BIT8
#define  TIME_MODE_ON					1
#define  TIME_MODE_OFF				0
'----------------------------------------
#define  LED_BIT_NOT_USED_1		9
#define  LED_NOT_USED_1_BIT		BIT9
#define  NOT_USED_1_ON				1
#define  NOT_USED_1_OFF				0
'----------------------------------------
#define  LED_BIT_NOT_USED_2		10
#define  LED_NOT_USED_2_BIT		BIT10
#define  NOT_USED_2_ON				1
#define  NOT_USED_2_OFF				0
'----------------------------------------
#define  LED_BIT_NOT_USED_3		11
#define  LED_NOT_USED_3_BIT		BIT11
#define  NOT_USED_3_ON				1
#define  NOT_USED_3_OFF				0
'----------------------------------------
#define  LED_BIT_NOT_USED_4		12
#define  LED_NOT_USED_4_BIT		BIT12
#define  NOT_USED_4_ON				1
#define  NOT_USED_4_OFF				0
'----------------------------------------
#define  LED_BIT_DISPENSER_POWER	13
#define  LED_DISPENSER_POWER_BIT	BIT13
#define  DISPENSER_POWER_ON				1
#define  DISPENSER_POWER_OFF			0
'----------------------------------------
#define  LED_BIT_PRESSURE_ALARM		14
#define  LED_PRESSURE_ALARM_BIT		BIT14
#define  PRESSURE_ALARM_ON				1
#define  PRESSURE_ALARM_OFF				0
'----------------------------------------
#define  LED_BIT_EMPTY_ALARM		15
#define  LED_EMPTY_ALARM_BIT		BIT15
#define  EMPTY_ALARM_ON					1
#define  EMPTY_ALARM_OFF				0
'-------------------------------------------------------------------------------
' ADDITIONAL LED STATES
'-------------------------------------------------------------------------------
#define  LED_ON						1
#define  LED_OFF					0
'----------------------------------------
#define  LED_ACTIVE				1
#define  LED_NOT_ACTIVE		0
'----------------------------------------
#define  LED_ALARMING			1
#define  LED_NOT_ALARMING	0
'-------------------------------------------------------------------------------


'===============================================================================
' DELAYS AND SPECIAL FLAGS (16-bits wide)
'-------------------------------------------------------------------------------
#define  DEBOUNCE_INTERVAL    7     '70 ms if TIMER_ISR_INTERVAL = 10 ms

'AFTER DESPENSER POWER IS OFF (DESPENSER QUICKLY STOPS MOVING)
'THE CHUTE MOVES TO/FROM A FROM/TO B DURING PIPE CLEARING

#define  PIPE_CLEARING_DELAY        100     '200, 700 = 700 * 0.01 sec = 7 seconds
#define  DIVERTER_SWITCHING_DELAY   100     '100, 500 = 500 * 0.01 sec = 5 seconds
#define  SPINNER_STARTUP_DELAY      100     '100, 300 = 300 * 0.01 sec = 3 seconds

'THE DISPENSER (ROTARY VALVE OR AUGER) RESTARTS AFTER SPINNER IS UP TO SPEED

'-------------------------------------------------------------------------------
'THE FOLLOWING IS USED WITH INTEGER VARIABLE "special_flags"
'-------------------------------------------------------------------------------
#define  PIPE_CLEARING_DELAY_BIT        BIT0    ' these values use the LS 5 bits
#define  DIVERTER_SWITCHING_DELAY_BIT   BIT1    '
#define  SPINNER_STARTUP_DELAY_BIT      BIT2    '
#define  HOPPER_A_EMPTY_DELAY_BIT       BIT3    '
#define  HOPPER_B_EMPTY_DELAY_BIT       BIT4    '
#define  FUNNEL_C_EMPTY_DELAY_BIT       BIT5
#define  NO_DELAYS_MASK_BITS          (NOT 63)  ' maximum value for all bits above

#define  HOPPER_DELAY_BIT               BIT6    '
#define  END_ACK_BIT                    BIT7
#define  END_REQ_BIT                    BIT8
#define  DISPLAY_HOLD                   BIT9    '

#define  EMPTY_HOPPER_PAUSE							BIT10	' hopper went empty while feeding

#define  FEEDING_TOO_FAST_PAUSE					BIT11	' RPM or Feed Rate above limits
#define  FEEDING_TOO_SLOW_FLAG					BIT12	' RPM or Feed Rate too slow


'===============================================================================
' INFRARED SWITCH HOPPER-EMPTY
'-------------------------------------------------------------------------------

#define  HOPPER_EMPTY_STATE_DELAY			2		' = 'TICS' BETWEEN HOPPER TESTS - 1

' IR TRANSMITTER PULSES GO OUT ON PWM CHANNEL 0, PORT 5 ON BOTH CB280 AND CB290
#define  IR_TRANSMITTER_PORT					5		' BLOCK 0, PORT 5, PWM CHANNEL 0

' IR RECEIVER SIGNAL COMES IN ON INTERRUPT CHANNEL 2, PORT 18 ON CB290
#define  IR_RECEIVER_FALLING_EDGE			0		' COMES IN ON INTERRUPT CH.2 (PORT 18)
#define  IR_PULSE_DETECTED						1		' HOPPER EMPTY (PULSES GET THROUGH)
#define  IR_PULSE_NOT_DETECTED				0

#define  HOPPER_EMPTY_COUNTER_LIMIT		33	' APPROX. 1 SECOND
#define  HOPPER_EMPTY_COUNTER_CLEAR   0
#define  HOPPER_EMPTY									1		' FLAG = 1 = HOPPER CONFIRMED EMTPY
#define  HOPPER_NOT_EMPTY							0		' FLAG = 0 = HOPPER NOT CONFIRMED EMPTY


'===============================================================================
' SPECIAL FLAGS (16-bits wide)
'-------------------------------------------------------------------------------
#define  END_ACK_BIT           			BIT6
#define  END_REQ_BIT           			BIT7
#define  DISPLAY_HOLD								BIT8

#define  MAX_SETTING_MODE						13

'===============================================================================
' I2C "CUNET" PORT FOR THE 4 7-SEGMENT LED DISPLAYS
'-------------------------------------------------------------------------------
#define  CUNET_SDA	17		' I2C SDA IS ON PORT 17 OF CB290 (WAS CB280 PORT 9)
#define  CUNET_SCL	16		' I2C SCL IS ON PORT 16 OF CB290 (WAS CB280 PORT 8)


'===============================================================================
' PARAMETER ACCELERATION COEFFICIENTS (FOR CHANGING FEED VOLUME PRESET)
'-------------------------------------------------------------------------------
#define  ACCELERATION_MAX					100
'#define  ACCELERATION_DELAY			59			'for 10ms system Tic
#define  ACCELERATION_DELAY				29			'for 20ms system Tic

#define  ACCELERATION_REPEATS		  7

#define  INCDEC_MORE		 1
#define  INCDEC_LESS		 0
'-------------------------------------------------------------------------------


'===============================================================================
' SOME CONVENIENCES FOR TESTING
'-------------------------------------------------------------------------------
'Csghex DISPLAY_ADRS_PROBE, switches		'FOR TESTING PURPOSES
'Csgdec DISPLAY_ADRS_PROBE, byte_variable	'FOR TESTING PURPOSES

'Display_Probe  byte_variable				'FOR TESTING PURPOSES
'-------------------------------------------------------------------------------


'===============================================================================
' TIME CLOCK CONSTANTS
'===============================================================================
'addressing the clock chip (DS1302)
'command byte = 1 R/-C A4 A3 A2 A1 A0 R/-W
'  where -C: 0 = select Clock
'  and   -W: 0 = write to Ram or Clock
'clock command/data registers
'    CH    10s2   10s1   10s0    1s3    1s2    1s1    1s0   range: 00-59 seconds
'   ----   10m2   10m1   10m0    1m3    1m2    1m1    1m0   range: 00-59 minutes
'  12/-24    0    10h1   10h0    1h3    1h2    1h1    1h0   range: 00-23 hours
'     0      0    10d1   10d0    1d3    1d2    1d1    1d0   range: 01-31 dates (day of month)
'     0      0      0    10m0    1m3    1m2    1m1    1m0   range: 01-12 months
'     0      0      0      0      0     dy2    dy1    dy0   range: 01-07 days (day of week)
'   10y3   10y2   10y1   10y0   10y3   10y2   10y1   10y0   range: 00-99 years (only 2 digits))
'-------------------------------------------------------------------------------
#define  TIME_SECONDS_BCD   0   ' 00 ... 59 formatted as one digit per nibble
#define  TIME_MINUTES_BCD   1   ' 00 ... 59 formatted as one digit per nibble
#define  TIME_HOURS_BCD     2   ' 00 ... 23 formatted as one digit per nibble
#define  TIME_DATES_BCD     3   ' 00 ... 31 formatted as one digit per nibble
#define  TIME_DAYS_BCD      4   ' 0=Sunday, ..., 6=Saturday   (ditto)
#define  TIME_MONTHS_BCD    5   ' 0=January, ..., 11=December  (ditto)
#define  TIME_YEARS_BCD     6   ' only last 2 digits are supplied: 00-99
'
'Note: The clock chip in the DCB290 does not include Century and Millenium values, so
'#define  TIME_CENTURY   0x20    ' THIS VALUE MUST BE CHANGED EVERY CENTURY :-)
	                               ' Note that the value is partitioned as 1 digit per nibble
'----------------------------

#define  TIME_SECONDS_BIN   10  ' 0 ... 59 as a binary number
#define  TIME_MINUTES_BIN   11  ' 0 ... 59 as a binary number
#define  TIME_HOURS_BIN     12  ' 0 ... 65535 as a binary number
#define  TIME_CONT_SECS_BCD 13  ' 0 ... 65535 as a binary number (continuous seconds)


'-------------------------------------------------------------------------------
' ASSOCIATED CONSTANTS AND LIMITS
'-------------------------------------------------------------------------------

#define  CURRENT_YEAR   0x024      ' Defined by programmer
'--------------------------------
#define  TIME_SECONDS_MIN    0
#define  TIME_SECONDS_MAX   59
'--------------------------------
#define  TIME_MINUTES_MIN    0
#define  TIME_MINUTES_MAX   59
'--------------------------------
#define  TIME_HOURS_MIN      0
#define  TIME_HOURS_MAX     23
'--------------------------------
#define  TIME_DATES_MIN      1  'for all months (values defined by date-clock IC)
#define  TIME_DATES_MAX_31  31  '0=Jan 2=Mar 4=May 6=Jul 7=Aug 9=Oct 11=Dec
#define  TIME_DATES_MAX_30  30  '3=Apr 5=Jun 8=Sep 10=Nov
#define  TIME_DATES_MAX_29  29  '1=Feb EXCEPT on a CENTURY start
#define  TIME_DATES_MAX_28  28  '1=Feb
'--------------------------------
#define  TIME_DAYS_MIN       0  ' 0=Sunday (values defined by date-clock IC)
#define  TIME_DAYS_MAX       6  ' 6=Saturday
'--------------------------------
#define  TIME_MONTHS_MIN     1  ' 0=January (values defined by date-clock IC)
#define  TIME_MONTHS_MAX    12  ' 11=December
'--------------------------------
#define  TIME_YEARS_MIN      0  ' (values defined by date-clock IC)
#define  TIME_YEARS_MAX     99  ' (values defined by date-clock IC)


'===============================================================================
' PROGRAMMABLE SCHEDULE TIMES
'===============================================================================
'TIME_INDEX: 0 = TIME (Hr.Min), 1-9=START/STOP FOR EACH FEED CYCLE
'-------------------------------------------------------------------------------
#define  TIME_INDEX_MAX     9   ' MAXIMUM VALUE
#define  TIME_INDEX_LIMIT   9   ' LIMIT FOR SCHEDULED START/STOP TIME
#define  TIME_INDEX_INIT    0
#define  TIME_INDEX_MIN     0

'===============================================================================
' TIME STATE MACHINE (TSM) STATES
'===============================================================================
#define  TSM_WAIT_FOR_TIME_PB_PRESS			 0
#define  TSM_RUNNING_WAIT_RELEASE			(1 + TSM_WAIT_FOR_TIME_PB_PRESS)
#define  TSM_NOT_RUNNING_WAIT_RELEASE_1		(1 + TSM_RUNNING_WAIT_RELEASE)
#define  TSM_NOT_RUNNING_ALLOW_CHANGES		(1 + TSM_NOT_RUNNING_WAIT_RELEASE_1)
#define  TSM_NOT_RUNNING_START_SAVING		(1 + TSM_NOT_RUNNING_ALLOW_CHANGES)
#define  TSM_NOT_RUNNING_FINISH_SAVING		(1 + TSM_NOT_RUNNING_START_SAVING)
#define  TSM_NOT_RUNNING_WAIT_RELEASE_2		(1 + TSM_NOT_RUNNING_FINISH_SAVING)


#endif

