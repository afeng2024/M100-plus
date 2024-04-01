'FILE= "eeprom.bas"

#ifndef  EEPROM_BAS
#define  EEPROM_BAS		123


'===============================================================================
' INITIALIZE SCHEDULE LINE IN A SHEDULE GROUP FROM EEPROM
'===============================================================================
Sub  Initialize_Schedule_Line_From_EEprom(islfe_line As Integer, islfe_group As Integer)

	islfe_part_address	Var	Integer

	islfe_part_address = (islfe_line + islfe_group * MAX_SCHEDULE_LINES_PER_GROUP) * SCHEDULE_ELEMENTS_PER_LINE

	schedule(SCHEDULE_STATE, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_STATE, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_STATE + islfe_part_address), 2 )

	schedule(SCHEDULE_START, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_START, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_START + islfe_part_address), 2 )

	schedule(SCHEDULE_STOP, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_STOP, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_STOP + islfe_part_address), 2 )

	schedule(SCHEDULE_PRESET, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_PRESET, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_PRESET + islfe_part_address), 2 )

	schedule(SCHEDULE_DELIVERED, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_DELIVERED, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_DELIVERED + islfe_part_address), 2 )

	schedule(SCHEDULE_TOTAL, islfe_line, islfe_group) = 0
	schedule(SCHEDULE_TOTAL, islfe_line, islfe_group) =  _
		Eeread( EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_TOTAL + islfe_part_address), 2 )

End Sub


'===============================================================================
' INITIALIZE SCHEDULE GROUP FROM EEPROM
'===============================================================================
Sub  Initialize_Schedule_From_EEprom(isfe_group As Integer)

	isfe_line			Var	Integer
	isfe_part_address	Var	Integer

	Debug "READING SCHEDULE GROUP "
		If isfe_group = 0 Then
			Debug "A "
		Else
			Debug "B "
		Endif
	DEBUG CR

	For isfe_line = 0 To max_location
		Initialize_Schedule_Line_From_EEprom  isfe_line, isfe_group
	Next

End Sub


'===============================================================================
' INITIALIZE FROM EEPROM
'===============================================================================
Sub  Initialize_From_EEprom()

	ife_i				Var	Integer
	ife_grp				Var	Integer
	ife_line			Var	Integer
	ife_part_address	Var	Integer

'Debug "=== INITIALIZE FROM EEPROM ===",CR
'Debug "GROUP A [RAM] <<< EEPROM",CR

	ife_grp = SCHEDULE_GROUP_A
	Initialize_Schedule_From_EEprom  ife_grp

'Debug "GROUP B [RAM] <<< EEPROM",CR

	ife_grp = SCHEDULE_GROUP_B
	Initialize_Schedule_From_EEprom  ife_grp

'Debug "GROUP A IN [RAM]",Cr
'Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", CR

	ife_grp = SCHEDULE_GROUP_A

'	For ife_line = 0 To max_location
'		Debug Dec ife_grp, "  ", Dec2 ife_line
'		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ife_line, ife_grp)
'		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ife_line, ife_grp)
'		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ife_line, ife_grp)
'		Debug Cr
'	Next

'Debug "GROUP B IN [RAM]",CR
'Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", CR

	ife_grp = SCHEDULE_GROUP_B

'	For ife_line = 0 To max_location
'		Debug Dec ife_grp, "  ", Dec2 ife_line
'		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ife_line, ife_grp)
'		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ife_line, ife_grp)
'		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ife_line, ife_grp)
'		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ife_line, ife_grp)
'		Debug CR
'	Next

	'----------------------------------------------------------------------------
	'GRAND TOTALS

'Debug "GRAND TOTALS [RAM] <<< [EEPROM]",CR

	Initialize_Grand_Totals_From_EEprom

'Debug "GRAND TOTALS IN [RAM]",Cr
Debug "GRAND TOTAL A = ", Dec8 grand_total_array(GRAND_TOTAL_A), CR
Debug "GRAND TOTAL B = ", Dec8 grand_total_array(GRAND_TOTAL_B), CR


End Sub


'===============================================================================
' SAVE SCHEDULE LINE IN A SCHEDULE GROUP TO EEPROM
'===============================================================================
Sub Save_Schedule_Line_To_EEPROM (sslte_line As Integer, sslte_group As Integer)

	sslte_part_address	Var	Integer

	sslte_part_address = (sslte_line + sslte_group * MAX_SCHEDULE_LINES_PER_GROUP) * SCHEDULE_ELEMENTS_PER_LINE

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_STATE + sslte_part_address), _
			 	schedule(SCHEDULE_STATE, sslte_line, sslte_group), 2

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_START + sslte_part_address), _
			 	schedule(SCHEDULE_START, sslte_line, sslte_group), 2

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_STOP + sslte_part_address), _
			 	schedule(SCHEDULE_STOP, sslte_line, sslte_group), 2

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_PRESET + sslte_part_address), _
			 	schedule(SCHEDULE_PRESET, sslte_line, sslte_group), 2

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_DELIVERED + sslte_part_address), _
			 	schedule(SCHEDULE_DELIVERED, sslte_line, sslte_group), 2

	Eewrite  EE_SCHEDULE_BLOCK_BEGIN + 2*(SCHEDULE_TOTAL + sslte_part_address), _
			 	schedule(SCHEDULE_TOTAL, sslte_line, sslte_group), 2

End Sub


'===============================================================================
' SAVE SCHEDULE GROUP TO EEPROM
'===============================================================================
Sub Save_Schedule_Group_To_EEPROM (ssgte_group As Integer)

	ssgte_line			Var	Integer
	ssgte_part_address	Var	Integer


Debug "WRITING SCHEDULE GROUP"

		If ssgte_group = 0 Then
			Debug "GROUP A [RAM] >>> [EEPROM]",Cr
		Else
			Debug "GROUP B [RAM] >>> [EEPROM]",Cr
		Endif

		For ssgte_line = 0 To max_location
			Save_Schedule_Line_To_EEPROM  ssgte_line, ssgte_group
		Next

End Sub


'===============================================================================
' SAVE GRAND TOTALS TO EEPROM
'===============================================================================
Sub  Initialize_Grand_Totals_In_EEprom()

DEBUG "INIT GRAND TOTAL A = 0 >>> [EEPROM]",CR

	grand_total_array(GRAND_TOTAL_A) = 0
 	Eewrite  EE_GRAND_TOTAL_A_ADDRESS, grand_total_array(GRAND_TOTAL_A), 4	'4 BYTE LONG EEWRITE TAKES 34.1 ms

DEBUG "INIT GRAND TOTAL B = 0 >>> [EEPROM]",CR

	grand_total_array(GRAND_TOTAL_B) = 0
 	Eewrite  EE_GRAND_TOTAL_B_ADDRESS, grand_total_array(GRAND_TOTAL_B), 4	'4 BYTE LONG EEWRITE TAKES 34.1 ms

End Sub


'===============================================================================
' SAVE ONE GRAND TOTAL FROM RAM INTO EEPROM
'===============================================================================
Sub  Save_Grand_Total_To_EEprom (sgtte_GT As Integer)

	If sgtte_GT = GRAND_TOTAL_B Then

		Eewrite  EE_GRAND_TOTAL_B_ADDRESS, grand_total_array(GRAND_TOTAL_B), 4	'4 BYTE EEWRITE ~ 34.1 ms
DEBUG "GRAND TOTAL B >>> [EEPROM]",CR

	Else		
		Eewrite  EE_GRAND_TOTAL_A_ADDRESS, grand_total_array(GRAND_TOTAL_A), 4	'4 BYTE EEWRITE ~ 34.1 ms
DEBUG "GRAND TOTAL A >>> [EEPROM]",CR

	Endif

End Sub


'===============================================================================
' SAVE GRAND TOTALS FROM RAM INTO EEPROM
'===============================================================================
Sub  Save_Grand_Totals_To_EEprom ()

	Save_Grand_Total_To_EEprom  GRAND_TOTAL_A
	
	Save_Grand_Total_To_EEprom  GRAND_TOTAL_B

End Sub


'===============================================================================
' INITIALIZE GRAND TOTALS IN RAM FROM EEPROM
'===============================================================================
Sub  Initialize_Grand_Totals_From_EEprom ()

	grand_total_array(GRAND_TOTAL_A) = 0
	grand_total_array(GRAND_TOTAL_A) = Eeread(EE_GRAND_TOTAL_A_ADDRESS, 4)	'4 BYTE LONG EEWRITE TAKES 34.1 ms

	grand_total_array(GRAND_TOTAL_B) = 0
	grand_total_array(GRAND_TOTAL_B) = Eeread(EE_GRAND_TOTAL_B_ADDRESS, 4)

End Sub


'===============================================================================
' INITIALIZE EEPROM WITH TEST/INITIAL VALUES       *** USED FOR TESTING ONLY ***
'===============================================================================
Sub Test_Init_Schedule_and_EEprom()		' *** USED FOR TESTING PURPOSES ONLY ***

Debug Cr,"INIT TEST SCHEDULE >>> [EEPROM]",CR

	tis_line			Var	Integer
	tis_part_address	Var	Integer
	tis_data			Var	Integer
	tis_long			Var Long

'	time_of_day_hours				= 0x1000	'INITIAL DEFAULT TIME = 10:00 (24 HRS)
'	time_of_day_seconds 	= 0			'INITIAL DEFAULT SECONDS = 00

'	Timeset TIME_SECONDS_BCD, 0
'	Timeset TIME_MINUTES_BCD, time_of_day_minutes
'	Timeset TIME_HOURS_BCD,   time_of_day_hours

	'---------------------------------------------------------------------------
	' WRITE TEST PATTERNS TO SCHEDULE ARRAYS
	'---------------------------------------------------------------------------

Debug "SCHEDULE GROUPS A & B >>> [RAM]",CR

	group_pointer = SCHEDULE_GROUP_A

	tis_line = 0
	
	schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_A) = 700
	schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_A) = 1000

	schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_B) = 701
	schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_B) = 1001

	For tis_line = 1 To max_location
		schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_A) = 101 + tis_line
		schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_A) = 102 + tis_line
		schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_A) = 103 + tis_line
		schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_A) = 104 + tis_line
		schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_A) = 105 + tis_line
		schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_A) = 106 + tis_line
		
		schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_B) = 201 + tis_line
		schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_B) = 202 + tis_line
		schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_B) = 203 + tis_line
		schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_B) = 204 + tis_line
		schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_B) = 205 + tis_line
		schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_B) = 206 + tis_line
	Next

Debug "SCHEDULE GROUP A IN [RAM]",CR
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", CR

	group_pointer = SCHEDULE_GROUP_A

	For tis_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 tis_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "SCHEDULE GROUP B IN [RAM]",CR
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", CR

	group_pointer = SCHEDULE_GROUP_B

	For tis_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 tis_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

Debug "GROUP A IN [RAM] >>> [EEPROM]",CR
	group_pointer = SCHEDULE_GROUP_A
	Save_Schedule_Group_To_EEPROM  group_pointer

Debug "GROUP B IN [RAM] >>> [EEPROM]",CR
	group_pointer = SCHEDULE_GROUP_B
	Save_Schedule_Group_To_EEPROM  group_pointer

Debug "GROUP A IN [RAM] <<< [EEPROM]",Cr
	group_pointer = SCHEDULE_GROUP_A
	Initialize_Schedule_From_EEprom  group_pointer

Debug "GROUP A IN [RAM] <<< [EEPROM]",Cr
	group_pointer = SCHEDULE_GROUP_B
	Initialize_Schedule_From_EEprom  group_pointer

Debug "SCHEDULE GROUP A IN [RAM]",CR
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	group_pointer = SCHEDULE_GROUP_A

	For tis_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 tis_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "SCHEDULE GROUP B IN [RAM]",CR
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	group_pointer = SCHEDULE_GROUP_B

	For tis_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 tis_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     tis_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      tis_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, tis_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     tis_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

	'----------------------------------------------------------------------------
	'GRAND TOTALS

Debug "GRAND TOTALS [RAM] >>> [EEPROM]",CR

	Save_Grand_Totals_To_EEprom

	Initialize_Grand_Totals_From_EEprom

Debug "GRAND TOTAL A IN [RAM]",CR
Debug "GRAND TOTAL A = ", Dec8 grand_total_array(GRAND_TOTAL_A), Cr

Debug "GRAND TOTAL B IN [RAM]",CR
Debug "GRAND TOTAL B = ", Dec8 grand_total_array(GRAND_TOTAL_B), Cr

Debug "================================================",Cr
Debug Cr

End Sub


'===============================================================================
' SHOW SCHEDULE ARRAYS
'===============================================================================
Sub  Show_Schedule_Array()

	Dim ssa_i As Integer

Debug Cr,"   #  State  Start  Stop  Preset  Delivered  Total"

	For ssa_i = 0 To max_location
Debug Cr,"A "
		If ssa_i < 10 Then
Debug " ",Dec ssa_i
		Else
Debug Dec ssa_i
		Endif

Debug "   ",    Hex4 schedule(SCHEDULE_STATE,    ssa_i, SCHEDULE_GROUP_A)
Debug "   ",    Hex4 schedule(SCHEDULE_START,    ssa_i, SCHEDULE_GROUP_A)
Debug "  ",     Hex4 schedule(SCHEDULE_STOP,     ssa_i, SCHEDULE_GROUP_A)
Debug "    ",   Dec4 schedule(SCHEDULE_PRESET,   ssa_i, SCHEDULE_GROUP_A)
Debug "       ",Dec4 schedule(SCHEDULE_DELIVERED,ssa_i, SCHEDULE_GROUP_A)
Debug "   ",    Dec4 schedule(SCHEDULE_TOTAL,    ssa_i, SCHEDULE_GROUP_A)

	Next

Debug Cr,"---"

	For ssa_i = 0 To max_location
Debug Cr,"B "
		If ssa_i < 10 Then
Debug " ",Dec ssa_i
		Else
Debug Dec ssa_i
		Endif

Debug "   ",    Hex4 schedule(SCHEDULE_STATE,    ssa_i, SCHEDULE_GROUP_B)
Debug "   ",    Hex4 schedule(SCHEDULE_START,    ssa_i, SCHEDULE_GROUP_B)
Debug "  ",     Hex4 schedule(SCHEDULE_STOP,     ssa_i, SCHEDULE_GROUP_B)
Debug "    ",   Dec4 schedule(SCHEDULE_PRESET,   ssa_i, SCHEDULE_GROUP_B)
Debug "       ",Dec4 schedule(SCHEDULE_DELIVERED,ssa_i, SCHEDULE_GROUP_B)
Debug "   ",    Dec4 schedule(SCHEDULE_TOTAL,    ssa_i, SCHEDULE_GROUP_B)

	Next

Debug Cr,"---"

Debug Cr

Debug"gtA=",dec grand_total_array(GRAND_TOTAL_A),Cr
Debug"gtB=",dec grand_total_array(GRAND_TOTAL_B),Cr

Debug Cr,"----------"
Debug Cr

End Sub


'===============================================================================
' INITIALIZE SIMPLE TEST SCHEDULE
'===============================================================================
Sub Initialize_Simple_Test_Schedule()

Debug Cr,"~~~~~~~~~~~~~~~~~~~~~~~~~",Cr

	itp_line			Var	Integer
	itp_part_address	Var	Integer
	itp_data			Var	Integer
	itp_long			Var Long

'	time_of_day_hours			= 0x1200	'INITIAL DEFAULT TIME = 12:00 (24-HR CLOCK)
'	time_of_day_seconds 	= 0			'INITIAL DEFAULT SECONDS = 00

'	Timeset TIME_SECONDS_BCD, 0
'	Timeset TIME_MINUTES_BCD, time_of_day_minutes
'	Timeset TIME_HOURS_BCD,   time_of_day_hours

	'---------------------------------------------------------------------------
	' WRITE TEST PATTERNS TO SCHEDULE ARRAYS
	'---------------------------------------------------------------------------

Debug "INITIALIZING SCHEDULE GROUPS A & B IN RAM",Cr

	itp_line = 0
	
	schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_A) = 700
	schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_A) = 0
	schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_A) = 1000

	schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_B) = 701
	schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_B) = 0
	schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_B) = 1001

	For itp_line = 1 To max_location
		schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_A) = 100+itp_line
		schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_A) = 0
		
		schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_B) = 200+itp_line
		schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_B) = 0
	Next

	'PRESET CERTAIN SPECIFIC VARIABLES
	
		schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A) = SPECIFIC_GRAVITY_FEED_NOM_INT
		schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B) = SPECIFIC_GRAVITY_FEED_NOM_INT
		
		schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A) = ROTARY_DELIVERY_FACTOR_INT
		schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B) = ROTARY_DELIVERY_FACTOR_INT

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP A IN RAM",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For itp_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 itp_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP B IN RAM",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For itp_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 itp_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

Debug "---",Cr

	Save_Schedule_Group_To_EEPROM  SCHEDULE_GROUP_A

Debug "---",Cr

	Save_Schedule_Group_To_EEPROM  SCHEDULE_GROUP_B

Debug "---",Cr

	Initialize_Schedule_From_EEprom  SCHEDULE_GROUP_A

Debug "---",Cr

	Initialize_Schedule_From_EEprom  SCHEDULE_GROUP_B

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP A (READ BACK INTO RAM)",Cr
Debug "G  Ln  GRPLN  START  STOP  PRESET  DELIV  TOTAL", Cr

	For itp_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 itp_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP B (READ BACK INTO RAM)",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For itp_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 itp_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     itp_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      itp_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, itp_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     itp_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

	'----------------------------------------------------------------------------
	'GRAND TOTALS

Debug "---",Cr
Debug "WRITING GRAND TOTALS FROM RAM INTO EEPROM",Cr

	Initialize_Grand_Totals_In_EEprom

	Initialize_Grand_Totals_From_EEprom

Debug "---",Cr
Debug "SHOWING GRAND TOTALS FROM EEPROM INTO",Cr
Debug "GRAND TOTAL A = ", Dec8 grand_total_array(GRAND_TOTAL_A), Cr
Debug "GRAND TOTAL B = ", Dec8 grand_total_array(GRAND_TOTAL_B), Cr

Debug "================================================",Cr
Debug Cr

End Sub


'===============================================================================
' INITIALIZE ALL NECESSARY
'===============================================================================
Sub Initialize_All_Necessary()					' *** MASTER INITIALIZER ***

Debug Cr,"~~~~~~~~~~~~~~~~~~~~~~~~~",Cr

	ian_line			Var	Integer
	ian_part_address	Var	Integer
	ian_data			Var	Integer
	ian_long			Var Long

'	time_of_day_hours			= 0x1200	'INITIAL DEFAULT TIME = 12:00 (24-HR CLOCK)
'	time_of_day_seconds 	= 0			'INITIAL DEFAULT SECONDS = 00

'	Timeset TIME_SECONDS_BCD, 0
'	Timeset TIME_MINUTES_BCD, time_of_day_minutes
'	Timeset TIME_HOURS_BCD,   time_of_day_hours

	'---------------------------------------------------------------------------
	' WRITE TEST PATTERNS TO SCHEDULE ARRAYS
	'---------------------------------------------------------------------------

Debug "INITIALIZING SCHEDULE GROUPS A & B IN RAM",Cr

	For ian_line = 0 To max_location
		schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_A) = 0
		schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_A) = 0
		
		schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_B) = 0
		schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_B) = 0
	Next

	'PRESET CERTAIN SPECIFIC VARIABLES
	
		schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_A) = SPECIFIC_GRAVITY_FEED_NOM_INT
		schedule(SCHEDULE_PRESET, 0, SCHEDULE_GROUP_B) = SPECIFIC_GRAVITY_FEED_NOM_INT
		
		schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_A) = ROTARY_DELIVERY_FACTOR_INT
		schedule(SCHEDULE_TOTAL, 0, SCHEDULE_GROUP_B) = ROTARY_DELIVERY_FACTOR_INT



Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP A IN RAM",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For ian_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 ian_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP B IN RAM",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For ian_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 ian_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

Debug "---",Cr

	Save_Schedule_Group_To_EEPROM  SCHEDULE_GROUP_A

Debug "---",Cr

	Save_Schedule_Group_To_EEPROM  SCHEDULE_GROUP_B

Debug "---",Cr

	Initialize_Schedule_From_EEprom  SCHEDULE_GROUP_A

Debug "---",Cr

	Initialize_Schedule_From_EEprom  SCHEDULE_GROUP_B

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP A (READ BACK INTO RAM)",Cr
Debug "G  Ln  GRPLN  START  STOP  PRESET  DELIV  TOTAL", Cr

	For ian_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_A, "  ", Dec2 ian_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_A)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_A)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_A)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_A)
		Debug Cr
	Next

Debug "---",Cr
Debug "SHOWING SCHEDULE GROUP B (READ BACK INTO RAM)",Cr
Debug "G  Ln  GLINE  START  STOP  PRESET  DELIV  TOTAL", Cr

	For ian_line = 0 To max_location
		Debug Dec SCHEDULE_GROUP_B, "  ", Dec2 ian_line
		Debug "   ",  Dec4 schedule(SCHEDULE_STATE,     ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_START,     ian_line, SCHEDULE_GROUP_B)
		Debug "  ",   Dec4 schedule(SCHEDULE_STOP,      ian_line, SCHEDULE_GROUP_B)
		Debug "    ", Dec4 schedule(SCHEDULE_PRESET,    ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_DELIVERED, ian_line, SCHEDULE_GROUP_B)
		Debug "   ",  Dec4 schedule(SCHEDULE_TOTAL,     ian_line, SCHEDULE_GROUP_B)
		Debug Cr
	Next

	'----------------------------------------------------------------------------
	'GRAND TOTALS

Debug "---",Cr
Debug "WRITING GRAND TOTALS FROM RAM INTO EEPROM",Cr

	Initialize_Grand_Totals_In_EEprom

	Initialize_Grand_Totals_From_EEprom

Debug "---",Cr
Debug "SHOWING GRAND TOTALS FROM EEPROM INTO",Cr
Debug "GRAND TOTAL A = ", Dec8 grand_total_array(GRAND_TOTAL_A), Cr
Debug "GRAND TOTAL B = ", Dec8 grand_total_array(GRAND_TOTAL_B), Cr

Debug "================================================",Cr
Debug Cr

End Sub
'===============================================================================



#endif
