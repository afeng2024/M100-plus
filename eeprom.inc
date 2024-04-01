'FILE= "eeprom.inc"

#ifndef  EEPROM_INC
#define  EEPROM_INC		123


'===============================================================================
' EEPROM ALLOCATIONS
'===============================================================================

#define  EE_START_ADDRESS				0	'BEGINNING OF EEPROM MEMORY SPACE


'===============================================================================
' PROGRAMMING MODEL OF SCHEDULE BLOCK (ARRAY)
'===============================================================================
' THE SCHEDULE BLOCK IS 3-DIMENSIONAL: ELEMENTS/LINE, LINES/GROUP, GROUPS/BLOCK
' schedule( SCHEDULE_ELEMENTS_PER_LINE, _								'ELEMENTS 0-5
'		    1 + MAX_SCHEDULE_LINES_PER_GROUP * NR_OF_SCHEDULE_GROUPS, _		'LINES 	  0,1...20
'		    NR_OF_SCHEDULE_GROUPS ) 									'BLOCKS	  0,1

#define  SCHEDULE_ELEMENTS_PER_LINE			6			'State, Start, Stop, Preset, Delivered, Total
#define  MAX_SCHEDULE_LINES_PER_GROUP		100		'Lines 99 = N+1 LINES PER GROUP - Define the max # of locations
																							'Note: Line 0 is special
#define  NR_OF_SCHEDULE_GROUPS					 2		'0 = GROUP A, 1 = GROUP B

#define  SCHEDULE_LINE_MAX		MAX_SCHEDULE_LINES_PER_GROUP-1	'LAST LINE IN A SCHEDULE GROUP
#define  SCHEDULE_LINE_MIN				 0					'FIRST LINE IN A GROUP (LINE 0 IS SPECIAL)

'#define  SCHEDULE_GROUP_A				 0		'ALREADY DEFINED IN variables.inc
'#define  SCHEDULE_GROUP_B				 1		'ALREADY DEFINED IN variables.inc


'===============================================================================
' EEPROM PHYSICAL MODEL OF SCHEDULE BLOCK (PHYSICAL BYTES, NOT ELEMENTS)
'===============================================================================

'Define EEPROM number of location address
#define  EE_NUMBER_OF_LOCATIONS  EE_START_ADDRESS					' MAX LOCATION STORE ADDRESS
#define  EE_NUMBER_OF_LOCATIONS_LENGTH	2

#define  EE_ROTARY_TYPE  EE_START_ADDRESS + 4					' ROTARY NUMBER ADDRESS
#define  EE_ROTARY_TYPE_LENGTH	 1

#define  EE_WEIGHT_UNIT  EE_START_ADDRESS + 6								' WEIGHT UNIT ADDRESS
#define  EE_WEIGHT_UNIT_LENGTH	 1

#define  EE_UNIT_NUMBER  EE_START_ADDRESS + 8					' MACHINE UNIT NUMBER
#define  EE_UNIT_NUMBER_LENGTH	 1


'===============================================================================



#define  EE_SCHEDULE_ELEMENT_SIZE	2		'2 BYTES PER INTEGER; ALL ELEMENTS ARE INTEGERS

#define  EE_SCHEDULE_LINE_SIZE		2 * SCHEDULE_ELEMENTS_PER_LINE
#define  EE_SCHEDULE_GROUP_SIZE		2 * SCHEDULE_ELEMENTS_PER_LINE * MAX_SCHEDULE_LINES_PER_GROUP
#define  EE_SCHEDULE_SIZE			2 * SCHEDULE_ELEMENTS_PER_LINE * MAX_SCHEDULE_LINES_PER_GROUP * NR_OF_SCHEDULE_GROUPS

#define  EE_SCHEDULE_BLOCK_BEGIN	EE_START_ADDRESS + 10
#define  EE_SCHEDULE_BLOCK_END		EE_START_ADDRESS + EE_SCHEDULE_SIZE - 1



'===============================================================================
'EEPROM GRAND TOTALS ARE HANDLED SEPARATELY
'===============================================================================

#define  GRAND_TOTALS_PER_ARRAY		2						'FOR NOW

#define  EE_GRAND_TOTALS_BEGIN		EE_SCHEDULE_BLOCK_END + 1		'LONG VARIABLES USE 4 BYTES
'
#define  EE_GRAND_TOTAL_A_ADDRESS	EE_GRAND_TOTALS_BEGIN			'START OF 1st GRAND TOTAL IN ARRAY
#define  EE_GRAND_TOTAL_A_LENGTH	4								'LENGTH OF 1st GRAND TOTAL IN ARRAY
'
#define  EE_GRAND_TOTAL_B_ADDRESS	EE_GRAND_TOTAL_A_ADDRESS + EE_GRAND_TOTAL_A_LENGTH
#define  EE_GRAND_TOTAL_B_LENGTH	4
'
#define  EE_GRAND_TOTAL_BLOCK_END	EE_GRAND_TOTAL_B_ADDRESS + EE_GRAND_TOTAL_B_LENGTH



#endif

