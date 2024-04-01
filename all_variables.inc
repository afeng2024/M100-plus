'FILE= "all_variables.inc"

#ifndef  ALL_VARIABLES_INC
#define  ALL_VARIABLES_INC	123


'=================I=====================================================================
' INITIALIZE VARIABLES
'=======================================================================================

#define  GRAND_TOTAL_A	0
#define  GRAND_TOTAL_B	1
'
Dim	grand_total_array(GRAND_TOTALS_PER_ARRAY)	As Long		'SAVED TO AND LOADED FROM EEPROM


'=======================================================================================
' THE SCHEDULE BLOCK (ARRAY)
'=======================================================================================
' INSTEAD OF INSTANTIATING MULTIPLE ARRAYS IN MULTIPLE GROUPS, CREATE ONE 3-DIMENSIONAL
' ARRAY "BLOCK" (NOTE: "LINE" 0 IS SPECIAL AND NOT A SCHEDULE LINE)
'    schedule(element# 0...5, line# 0...20, group# 0...1)
'---------------------------------------------------------------------------------------

Dim  schedule( SCHEDULE_ELEMENTS_PER_LINE, MAX_SCHEDULE_LINES_PER_GROUP, NR_OF_SCHEDULE_GROUPS ) As Integer

'---------------------------------------------------------------------------------------
'SCHEDULE ELEMENTS PER SCHEDULE LINE
'---------------------------------------------------------------------------------------
#define  SCHEDULE_STATE				0
#define  SCHEDULE_START				1
#define  SCHEDULE_STOP				2
#define  SCHEDULE_PRESET			3
#define  SCHEDULE_DELIVERED		4
#define  SCHEDULE_TOTAL				5
'
'LINES PER SCHEDULE GROUP = 0, 1, 2, ..., 20	(LINE 0 = SPECIAL PURPOSE)
'
'GROUPS IN THE WHOLE SCHEDULE BLOCK
#define  SCHEDULE_GROUP_A			0
#define  SCHEDULE_GROUP_B			1

'=======================================================================================

element_pointer			Var	Integer		'pointer to an element in a schedule line
element_pointer			= 0
'
element_pointer_saved	Var	Integer		'saved pointer to an element in a schedule line
element_pointer_saved	= 0

line_pointer				Var	Integer		'pointer to a line in a schedule group
line_pointer				= 0
'
line_pointer_saved	Var	Integer		'saved pointer to a line in a schedule group
line_pointer_saved	= 0

group_pointer				Var	Integer		'pointer to a group in the schedule block (array)
group_pointer				= 0
'
group_pointer_saved	Var	Integer		'saved pointer to a group in the schedule block (array)
group_pointer_saved	= 0

'------------------------------

feed_mass_per_rotation_f	Var	Single					' "SINGLE" = FLOATING POINT (4 BYTES)
feed_mass_per_rotation_f	= 0.0

feed_rate_const_f			Var Single
feed_rate_const_f			= 0.0

'------------------------------

time_state          	Var Byte        ' USED WITH TIME PUSHBUTTON
time_state          	= 0

time_index          	Var Byte        ' USED WITH CB290'S TIME() FUNCTION
time_index          	= 0

time_of_day_hours    	Var Integer     ' HOURS(BCD) FROM CLOCK IC
time_of_day_hours			= 0

time_of_day_minutes  	Var Integer     ' MINUTES(BCD) FROM CLOCK IC
time_of_day_minutes		= 0

time_of_day_seconds		Var Byte		' SECONDS FROM CLOCK IC
time_of_day_seconds		= 0

time_changed_flag			Var Integer		' SET WHEN OPERATOR HAS CHANGE THE TIME
time_changed_flag			= 0

'------------------------------

accel_amount			Var Integer
accel_amount 			= 0

accel_delay 			Var Integer
accel_delay  			= 0

accel_repeat			Var Integer
accel_repeat 			= ACCELERATION_REPEATS

faccel_amount			Var Integer
faccel_amount 			= 0

faccel_delay 			Var Integer
faccel_delay  			= 0

faccel_repeat			Var Integer
faccel_repeat 			= ACCELERATION_REPEATS

'------------------------------

blinking_timer			Var Integer
blinking_timer			= 0

debounce_timer			Var Byte
debounce_timer			= 0

aux_debounce_timer	Var Byte
aux_debounce_timer	= 0

'------------------------------

feed_specific_gravity_i		Var	Integer		' adjustable integer value (= 100 * real value)
																				' initialized from EEprom at power-up

feed_delivery_factor_i		Var Integer		' adjustable feed delivery factor (= 100 * real value)
																				' initialized from EEprom at power-up

feed_SG_x_DF							var	Long			' variable to carry the product of the above two values
																				' calcualted in subroutine "Calculate_Coefficients()"

feed_added_per_chamber_L	var	Long			' amount of feed added each time a chamber dumps
feed_added_per_chamber_L	= 0						' uses next variable to avoid error during updates

feed_added_per_chamber_flag		var	Byte	' used to avoid calculation errors during variable-update
feed_added_per_chamber_flag		= 0				' 1 = feed_added_per_chamber_L is changing, do not use 

'------------------------------

kg_per_rot_changed		Var	Byte
kg_per_rot_changed		= 0

'------------------------------

feed_rate_f				Var Single						' REAL-TIME FEED DELIVERY RATE
feed_rate_f				= 0.0

feed_rate					Var	Integer
feed_rate					= 0

#If FEED_RATE_DISPLAY_SMOOTHING = 1			' FOR LESS "JUMPINESS" IN DISPLAYED FEED RATE
feed_rate_avg1			Var Integer
feed_rate_avg1			= 0

feed_rate_avg2			Var Integer
feed_rate_avg2			= 0

feed_rate_avg3			Var Integer
feed_rate_avg3			= 0

feed_rate_avg4			Var Integer
feed_rate_avg4			= 0
#Endif

'------------------------------

feed_volume_preset			Var Integer		' PRESET VALUE SET BY OPERATOR
feed_volume_delivered		Var Integer		' AMOUNT BEING DELIVERED IN REAL-TIME
feed_volume_total				Var Integer		' TOTAL FEED DELIVERED (TODAY) SINCE POWER ON

feed_volume_delivered		= 0
feed_volume_total				= 0

feed_volume_added_f			Var Single
feed_volume_added_f			= 0.0

feed_chamber_amount_added_f	var single
feed_chamber_amount_added_f	= 0.0

feed_temp1_long					var long
feed_temp1_long					= 0

feed_temp2_int					var Integer
feed_temp2_int					= 0

'------------------------------

heartbeat_timer					Var Byte
heartbeat_timer					= 0

'------------------------------

hopper_empty_counter		Var Byte
hopper_empty_counter		= 0

#define  HOPPER_EMPTY_DELAY_SEC		5
#define  HOPPER_EMPTY_COUNTER_MAX	CLOCK_TICS_PER_SECOND * HOPPER_EMPTY_DELAY_SEC

hopper_empty_flag				Var Byte
hopper_empty_flag				= 0


#define  HOPPER_A				0
#define  HOPPER_B				1

hopper_pointer					Var	Byte			'0 = Hopper A, 1 = Hopper B
hopper_pointer					= HOPPER_A			'DEFAULT IS HOPPER A

'------------------------------

#define  HOPPER_GROUP_SELECT_X		0	'CLOSE ALL HOPPER GATES
#define  HOPPER_GROUP_SELECT_A		1	'SELECT HOPPER A: OPEN HOPPER A'S GATE A
#define  HOPPER_GROUP_SELECT_B		2	'SELECT HOPPER B: OPEN HOPPER B'S GATE B
#define  HOPPER_GROUP_SELECT_AB		3	'TOGGLE BETWEEN HOPPERS:
										'  IF GATE A IS OPEN CLOSE GATE A AND OPEN GATE B, OR
										'  IF GATE B IS OPEN CLOSE GATE B AND OPEN GATE A
'------------------------------

leds								Var Integer
leds								= 0

'------------------------------

machine_state				Var Integer
machine_state				= 0

'------------------------------

dispenser_flag			Var Byte
dispenser_flag			= 0

dispenser_indexer_period				Var Integer
dispenser_indexer_period				= 0

dispenser_indexer_period_saved	Var Integer
dispenser_indexer_period_saved	= 0

'------------------------------

special_flags					Var Integer
special_flags					= 0

'------------------------------

switches							Var Integer
switches							= 0

switches_previous			Var Integer
switches_previous			= 0

switches_asserted			Var Integer
switches_asserted			= 0

switches_released			Var Integer
switches_released			= 0

'------------------------------

aux_switches					Var	Integer
aux_switches					= 0

aux_switches_previous			Var Integer
aux_switches_previous			= 0

aux_switches_asserted			Var Integer
aux_switches_asserted			= 0

aux_switches_released			Var Integer
aux_switches_released			= 0

'------------------------------

debug_flag			Var	Integer
debug_flag			= 0



'==========================================
'=--=--= M100+ ADDED VARIABLES

data_exchange			Var	Byte				'Data exchange indicator
data_exchange			= 0

data_string				Var String
data_string				= " "

time_of_date     	Var Byte  	   ' DATE(BCD) FROM RTC
time_of_date			= 0

time_of_month     Var Byte  	   ' MONTH(BCD) FROM RTC
time_of_month			= 0

time_of_year      Var Byte	     ' YEAR(BCD) FROM RTC
time_of_year			= 0

time_error				Var	Byte				'RTC error indicator
time_error				= 0

setting_mode			Var Byte
setting_mode			= 0

max_location			Var Byte
max_location			= 20

unit_number				Var Integer
unit_number				= 1

weight_unit				Var Byte
weight_unit				= 1

rotary_type				Var Byte
rotary_type				= 1


'=--=--= end



#endif

