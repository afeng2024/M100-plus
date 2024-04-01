'FILE= "dispenser.inc"

#ifndef  DISPENSER_INC
#define  DISPENSER_INC	123


'===============================================================================
' INDEXER PULSES EDGE DETECTION
'===============================================================================
#define  INDEXER_RISING_EDGE		 1
#define  INDEXER_FALLING_EDGE		 0

#define  DISPENSER_RISING_EDGE		 1
#define  DISPENSER_FALLING_EDGE		 0

#define  PROX_SENSOR_RISING_EDGE	 1
#define  PROX_SENSOR_FALLING_EDGE	 0


'*******************************************************************************
'*   ALWAYS UPDATE THE FOLLOWING SPECIFICATIONS TO MATCH THE FEED BEING USED   *
'*******************************************************************************
'*                FEED AND FEEDING RELATED SPECIFICATIONS                      *
'*******************************************************************************
'*   NOMINAL FEED SPECIFIC-GRAVITY (RELATIVE TO WATER DEFINED AS SP = 1.000)   *
'*******************************************************************************
#define SPECIFIC_GRAVITY_FEED_NOM		0.700	'density relative to water
#define SPECIFIC_GRAVITY_FEED_NOM_INT	  700	'NOTE: integer value = 1000 * real value


'*******************************************************************************
'*    ALWAYS UPDATE THE FOLLOWING SPECIFICATIONS TO MATCH ROTARY VALVE USED    *
'*******************************************************************************
'*  CONSTANTS DEPEND ON MANUFACTURER AND MODEL CHOSEN                          *
'*  Note: "CFR" means Cubic Feet per Revolution                                *
'*******************************************************************************
#define  ROTARY_VALVE_CU_FT_6		0.095		'Cubic Feet per Rotation (CFR)
#define  ROTARY_VALVE_CU_FT_8		0.23		'Cubic Feet per Rotation (CFR)
#define  CHAMBERS_PER_ROTARY		8			'8 Chambers
#define  CHAMBER_CU_FT_6				0.01188		'CFR/Chamber = 0.01188
#define  CHAMBER_CU_FT_8				0.02875		'CFR/Chamber


'===============================================================================
'   CONVERSION FACTORS
'===============================================================================
#define  KG_TO_LBS							2.20462	'1 kg = 2.20462 pounds
#define  CU_FT_H2O_TO_KG				28.3168	'1 cu.ft. of water weighs 28.3168 kg
#define  CU_FT_H2O_TO_LBS				62.4279	'1 cu.ft. of water weights 62.4279 pounds 

'===============================================================================
'    ROTARY VALVE DELIVERY
'===============================================================================
#define  ROTARY_VALVE_KG_H2O_6		ROTARY_VALVE_CU_FT_6 * CU_FT_H2O_TO_KG
#define  ROTARY_VALVE_KG_H2O_8		ROTARY_VALVE_CU_FT_8 * CU_FT_H2O_TO_KG
'#define  ROTARY_VALVE_KG_FEED_6		ROTARY_VALVE_KG_H2O_6 * SPECIFIC_GRAVITY_FEED_NOM
'#define  ROTARY_VALVE_KG_FEED_8		ROTARY_VALVE_KG_H2O_8 * SPECIFIC_GRAVITY_FEED_NOM
'
#define  ROTARY_VALVE_LBS_H2O_6		ROTARY_VALVE_CU_FT_6 * CU_FT_H2O_TO_LBS
#define  ROTARY_VALVE_LBS_H2O_8		ROTARY_VALVE_CU_FT_8 * CU_FT_H2O_TO_LBS
'#define  ROTARY_VALVE_LBS_FEED_6	ROTARY_VALVE_LBS_H2O_6 * SPECIFIC_GRAVITY_FEED_NOM
'#define  ROTARY_VALVE_LBS_FEED_8	ROTARY_VALVE_LBS_H2O_8 * SPECIFIC_GRAVITY_FEED_NOM


'===============================================================================
'    ROTARY VALVE CHAMBER DELIVERY
'===============================================================================
#define  ROTARY_CHAMBER_KG_H2O_6	 		ROTARY_VALVE_KG_H2O_6/CHAMBERS_PER_ROTARY
#define  ROTARY_CHAMBER_KG_H2O_8	 		ROTARY_VALVE_KG_H2O_8/CHAMBERS_PER_ROTARY
'#define  ROTARY_CHAMBER_KG_FEED_6	 		ROTARY_VALVE_KG_FEED_6/CHAMBERS_PER_ROTARY
'#define  ROTARY_CHAMBER_KG_FEED_8	 		ROTARY_VALVE_KG_FEED_8/CHAMBERS_PER_ROTARY
'
#define  ROTARY_CHAMBER_LBS_H2O_6	 		ROTARY_VALVE_LBS_H2O_6/CHAMBERS_PER_ROTARY
#define  ROTARY_CHAMBER_LBS_H2O_8	 		ROTARY_VALVE_LBS_H2O_8/CHAMBERS_PER_ROTARY
'#define  ROTARY_CHAMBER_LBS_H2O_6X100	100 * ROTARY_CHAMBER_LBS_H2O_6
'#define  ROTARY_CHAMBER_LBS_H2O_8X100	100 * ROTARY_CHAMBER_LBS_H2O_8
'#define  ROTARY_CHAMBER_LBS_FEED_6	 	ROTARY_VALVE_LBS_FEED/CHAMBERS_PER_ROTARY
'#define  ROTARY_CHAMBER_LBS_FEED_8	 	ROTARY_VALVE_LBS_FEED/CHAMBERS_PER_ROTARY

'===============================================================================
'    FEED DELIVERY FACTOR
'===============================================================================
#define  ROTARY_DELIVERY_FACTOR	 	 1.000	'now loaded from EEprom
#define  ROTARY_DELIVERY_FACTOR_INT	 1000	'NOTE: integer value = 1000 * real value


'===============================================================================
' CONSTANTS RELATED MAXIMUM AND MINIMUM DISPENSER RPM OR PERIOD
'===============================================================================
#define  MAX_DISPENSER_INDEXER_INTERVAL		15.0	'SECONDS
#define  MIN_DISPENSER_INDEXER_INTERVAL		0.25	'SECONDS

#define  MAXIMUM_RPM		60.0 / CHAMBERS_PER_ROTARY / MIN_DISPENSER_INDEXER_INTERVAL
#define  INDEXER_SPP_MIN	MIN_DISPENSER_INDEXER_INTERVAL
#define  INDEXER_TPP_MIN	MIN_DISPENSER_INDEXER_INTERVAL * CLOCK_TICS_PER_SECOND

#define  MINIMUM_RPM		60.0 / CHAMBERS_PER_ROTARY / MAX_DISPENSER_INDEXER_INTERVAL
#define  INDEXER_SPP_MAX	MAX_DISPENSER_INDEXER_INTERVAL
#define  INDEXER_TPP_MAX	MAX_DISPENSER_INDEXER_INTERVAL * CLOCK_TICS_PER_SECOND

#define  DISPENSER_INDEXER_PERIOD_MAX	MAX_DISPENSER_INDEXER_INTERVAL*CLOCK_TICS_PER_SECOND											'
#define  DISPENSER_INDEXER_PERIOD_MIN	MIN_DISPENSER_INDEXER_INTERVAL*CLOCK_TICS_PER_SECOND


'===============================================================================
' FEED VOLUMES AND RATE CONSTANTS
'===============================================================================
#define  FEED_VOLUME_A_MAX		 9999
#define  FEED_VOLUME_A_DEFAULT      0
#define  FEED_VOLUME_A_MIN		    0
'-------------------------------------------------------------------------------
#define  FEED_RATE_MAX			 999
#define  FEED_RATE_MIN			  0.5
'-------------------------------------------------------------------------------
#define  ACCUMULATED_TOTAL_A_MAX	 9000	' use < 9999 to prevent math wrap-around
#define  ACCUMULATED_TOTAL_A_DEFAULT	0
#define  ACCUMULATED_TOTAL_A_MIN		0
'-------------------------------------------------------------------------------
#define  GRAND_TOTAL_MAX        99999999
#define  GRAND_TOTAL_DEFAULT    0
#define  GRAND_TOTAL_MIN      	0


'===============================================================================
' FEED RATE DISPLAYED-VALUE "SMOOTHING"
'===============================================================================
' Because the time between rotary-valve indexer-pulses becomes shorter and
' shorter as the speed of rotation increases, the quantized steps between feed
' rate values becomes bigger and bigger.  A simple IIR averaging is used to
' smooth the "jumpiness" depending on the time between rotary valve index pulses.
'
' 	feed_rate_avg(k) = (feed_rate_avg[k] + feed_rate) / (2^k)
'
' Thresholds to switch k from 1 to 2, 2 to 3, etc., were empirically determined.
'===============================================================================
#define  FEED_RATE_DISPLAY_SMOOTHING	1	' 0 = NO SMOOTHING, 1 = SMOOTHING

#define  FEED_RATE_THRESHOLD_1	 17		' EMPIRICALLY DETERMINED VALUE
#define  FEED_RATE_THRESHOLD_2	 33		' (ditto)
#define  FEED_RATE_THRESHOLD_3	 65		' (ditto)



#endif

