;===============================================================
; RIT Hot Wheelz - OS25
;===========================================
;
;   Copyright © 2016, all rights reserved
;
;		RIT Hot Wheelz Formula SAE Electric Team
;		Rochester Institue of Technology
;   		77 Lomb Memorial Dr
;		Rochester, NY 14623                             	          
;
;										
VCL_App_Ver = 103	;Set VCL software revision (101 is Rev 1.01)
;
;---------------------------------------------------------------
; Declaration Section
;--------------------

	Interlock_Switch		equals 	SW_3
	
	Forward_Switch			equals  SW_7
	Forward_Switch_Up		equals	SW_7_UP
	Forward_Switch_Down		equals	SW_7_DOWN
	Reverse_Switch			equals  SW_8
	
	Drag_Mode_Switch		equals	SW_4
	Drag_Mode_Switch_UP		equals	SW_4_UP			;Used if up edge is used for input signal
	Drag_Mode_Switch_DOWN		equals	SW_4_DOWN		;Used if down edge is used for input signal
	
	
	Endurance_Mode_Switch		equals	SW_6
	Endurance_Mode_Switch_UP	equals	Sw_6_UP			;Used if up edge is used for input signal
	Endurance_Mode_Switch_DOWN	equals	Sw_6_DOWN		;Used if down edge is used for input signal
	
	AutoCross_Mode_Switch		equals	SW_5
	AutoCross_Mode_Switch_UP	equals	Sw_5_UP			;Used if up edge is used for input signal
	AutoCross_Mode_Switch_DOWN	equals	Sw_5_DOWN		;Used if down edge is used for input signal
	
	Buzzer_Noise			equals  PWM5			;Using proportional driver to power noise maker

	Drag_Lights			equals	DigOut6			;Driver 6 OFF/ON
	Endurance_Lights		equals	PWM4			;Driver 4 PWM
	AutoCross_Lights		equals	DigOut7			;Driver 7 OFF/ON
	
	Drag_MaxCurrent_DLY		equals	DLY1
	Drag_MaxCurrent_DLY_Output	equals	DLY1_Output
	
	Buzzer_DLY			equals  DLY2		
	Buzzer_DLY_Output		equals	DLY2_Output
	
	Startup_Delay			equals DLY3
	Startup_Delay_Output		equals DLY3_Output
	
	EnGage_State_Delay		equals DLY4
	EnGage_State_Delay_Output	equals DLY4_Output
	
	Engage_Display_Delay		equals DLY5
	Engage_Display_Delay_Output	equals DLY5_Output
	
	Engage_Fault_Display_Delay	equals DLY6
	Engage_Fault_Display_Delay_Output	equals DLY6_Output
	
	Debounce_DLY			equals DLY7
	Debounce_DLY_Output		equals DLY7_Output
	
	BMS_State_Delay			equals DLY8
	BMS_State_Delay_Output		equals DLY8_Output
	
	Program_Flags			equals	User_Bit1
	Drag_Mode_Initialized_Flag 		 bit	Program_Flags.1
	Startup_CAN_System_Has_Been_Called_Flag	 bit	Program_Flags.2
	Button_Press_Flag			 bit	Program_Flags.4
;	Not Used				 bit	Program_Flags.8
;	Not Used				 bit	Program_Flags.16
;	Not Used				 bit	Program_Flags.32
;	Not Used				 bit	Program_Flags.64
;	Not Used				 bit	Program_Flags.128

Switch_Screen_Flags			equals	User_Bit2
Goto_MSG_Screen_Flag				 bit	 Switch_Screen_Flags.1 ;Indicates if a button press occured to change E6 Screen to show fault list
Goto_Gauge_Screen_Flag				 bit	 Switch_Screen_Flags.2 ;Indicates if a button press occured to change E6 Screen to show gauge



Engage_State	    			equals	User1	;state machine for sending messages to engage display 
NMT_Command_Specifier			equals  User2
NMT_Node_Address			equals  User3

E7_Battery_Current 		  	equals User4		 			
E7_Keyswitch_Voltage			equals User5	 
E7_Regen_Percentage			equals	User6		  
E7_Vehicle_Speed			equals	User7	 
E7_Icon_Status				equals	User8
	Battery_Icon				bit	E7_Icon_Status.1
	Warning_Icon				bit	E7_Icon_Status.2
	Temperature_Icon			bit	E7_Icon_Status.4
	Rabbit_Icon				bit	E7_Icon_Status.8
	Turtle_Icon				bit	E7_Icon_Status.16
	;unused					bit	E7_Icon_Status.32
	Left_Turn_Signal_Icon			bit	E7_Icon_Status.64
	Right_Turn_Signal_Icon			bit	E7_Icon_Status.128
	             
E7_Drive_Gear_Select		equals	User9
	NO_GEAR_ICON						constant	0x00
	PARKING_ICON						constant	0x01
	REVERSE_ICON						constant	0x02
	NEUTRAL_ICON						constant	0x03
	DRIVE_ICON						constant	0x04
	SPORT_ICON						constant	0x05		
E7_Pushbutton_Status		equals	User10
	;unused					bit	E7_Pushbutton_Status.1
	;unused					bit	E7_Pushbutton_Status.2
	Left_Button				bit	E7_Pushbutton_Status.4
	Up_Button				bit	E7_Pushbutton_Status.8
	Enter_Button				bit	E7_Pushbutton_Status.16
	Down_Button				bit	E7_Pushbutton_Status.32
	Right_Button				bit	E7_Pushbutton_Status.64	  
	
e7_Text_Code  			 equals User11	

Display_State			 equals	User12
Fault_Code 			 equals	User13
Display_Set_To_Message 		 equals User14

Index  				equals	User15
Fault_Code_Engage		equals	User16
Traction_Fault_Count		equals	User17

BMS_State			equals	User18
E7_BMS_SOC			equals	User19

;---------------------VCL Fault Definitions--------------------------

;-------------------Fault Action Definitions------------------------
Shutdown_Motor				constant	0x0001
Shutdown_Main				constant	0x0002
Shutdown_EMBrake			constant	0x0004
Shutdown_Throttle			constant	0x0008
Shutdown_Interlock			constant	0x0010
Shutdown_Driver1			constant	0x0020
Shutdown_Driver2			constant	0x0040
Shutdown_Driver3			constant	0x0080
Shutdown_Driver4			constant	0x0100
Shutdown_PD				constant	0x0200
Full_Brake				constant	0x0400

;------------ USER FAULT DEFINITION --------

BMS_Module_Fault					bit	Userfault1.1	 ;Fault #1 51  Indicates a fault on BMS Module
;													bit	UserFault1.2	 ;Fault #2 52	
;													bit	UserFault1.4	 ;Fault #3 53  
;													bit UserFault1.8	 ;Fault #4 54
;													bit UserFault1.16	 ;Fault #5 55
;													bit UserFault1.32	 ;Fault #6 56
;													bit UserFault1.64	 ;Fault #7 57
;													bit UserFault1.128 	 ;Fault #8 58
;													bit UserFault2.1	 ;Fault #9 59
;													bit UserFault2.2	 ;Fault #10 61
;               											bit UserFault2.4	 ;Fault #11 62
;													bit UserFault2.8	 ;Fault #12 63
;													bit UserFault2.16	 ;Fault #13 64
;													bit UserFault2.32	 ;Fault #14 65
;													bit UserFault2.64	 ;Fault #15 66
;													bit UserFault2.128 ;Fault #16 67
																						
;--------- USER FAULT ACTIONS -----------
User_Fault_Action_01 = 0;
User_Fault_Action_02 = 0;   
User_Fault_Action_03 = 0;  		


;****************************************
; 					 CONSTANTS 
;****************************************
;------------------------------------------------------------------------------
; Message Types
; -These message types are defined in the CAN-Open  protocol and
;  appear in the upper-most 4 bits of the 11-BIT message identifier
;------------------------------------------------------------------------------
;NMT                constant        0x000       ; Network Management
SYNC_ERR_BASE       constant        0x080       ; Both Sync (COB-ID=0) & Error (COB-ID=Error)
TIME_STAMP          constant        0x100
PDO1_TX_BASE        constant        0x180       ; Process Data Object (Master In  Slave Out)
PDO1_RX_BASE        constant        0x200       ; Process Data Object (Master Out Slave In)
PDO2_TX_BASE        constant        0x280       ; Process Data Object (System Broadcast 1)
PDO2_RX_BASE        constant        0x300       ; Process Data Object (System Broadcast 2)
PDO3_TX_BASE        constant        0x380       ; Process Data Object (System Broadcast 3)
PDO3_RX_BASE        constant        0x400       ; Process Data Object (System Broadcast 4)
PDO4_TX_BASE        constant        0x480       ; Index Data Object   (Master In  Slave Out)
PDO4_RX_BASE        constant        0x500       ; Index Data Object   (Master Out Slave In)
SDO_MISO_BASE       constant        0x580       ; Service Data Object (Master In  Slave Out)
SDO_MOSI_BASE       constant        0x600       ; Service Data Object (Master Out Slave In)
HEARTBEAT_BASE      constant        0x700       ; Node Guard Message
;-------- NMT command specifier (CS)------------------------------------------------------------
NMT_CS_START_REMOTE_NODE        constant 0x01
NMT_CS_STOP_REMOTE_NODE         constant 0x02
NMT_CS_ENTER_PREOPERATIONAL     constant 0x80
NMT_CS_RESET_NODE               constant 0x81
NMT_CS_RESET_COMMUNICATION      constant 0x82
ENGAGE_7_NODE			constant 0x6E




;------------- SDO COMMANDS --------------------------------------------------------------------
SDO_WRITE_COMMAND								constant 0x22	
SDO_READ_COMMAND								constant 0x42	


;-----------------------------------------------------------------------------------------------

;------------- CAN DEFINITIONS ----------
e7_SDO_MOSI_Mailbox							equals CAN1
e7_SDO_MISO_Mailbox							equals CAN2

STARTUP_Mailbox								equals CAN17
e7_PDO_MOSI_Mailbox							equals CAN18
e7_PDO_MISO_Mailbox							equals CAN19
BMS_SDO_MOSI_Mailbox							equals CAN15
BMS_SDO_MISO_Mailbox			     				equals CAN16

		
	
	
;===============================================================
; One time Initialization
;===============================================================
;
		Program_Flags = 0
		Setup_Delay(Buzzer_DLY,3000)		;Amount of time for ready to drive noise
		Put_PWM(MainContactor_Indicator,32767)	;Output 10V on analog out to indicate the main contactor is closed
		Setup_Delay(Startup_Delay,3000)		; Wait for 3000 msec to allow time for switches to debounce and CAN slaves to come online
		Enable_Precharge()
;-------------------------------------------------------------------------
; Main :: Main Loop of the Program
;---------------------------------------------
;
MainLoop:
	
	
	;Put_PWM(MainContactor_Indicator,32767)	;Output 10V on analog out to indicate the main contactor is closed
	;---------------------------------------------------------------------------------------------------------
;   Startup_CAN System is called 3 seconds after power up.
;   However the vehicle is allowed to respond prior to this as the CAN slaves is the Engage 7.
;   The vehilce is allowed to operate normally even if these slaves are not operational.
;---------------------------------------------------------------------------------------------------------
If ( (Startup_Delay_Output = 0) & (Startup_CAN_System_Has_Been_Called_Flag = Off) )
	{    ;	Waiting for enGage to come ON (Splash Screen adds 2 sec to start of CAN)
		Call Startup_CAN_System		;setup and start the CAN communications system
		Startup_CAN_System_Has_Been_Called_Flag = On
	}

Call E7_Get_Data
Call Process_BMS

	if (Buzzer_DLY_Output<>0)             ;while the buzzer delay output does not equal 0, sound the buzzer, and turn on autox race mode
		{
    	Put_PWM(Buzzer_Noise, 32767)         ;turn on the buzzer
        Call AutoCrossMode		     ;turn on autox
    }
	else
		{
    	Put_PWM(Buzzer_Noise,0)              ;turn off the buzzer
		}
	
	if (Interlock_Switch = ON)		;The Interlock Switch is the switch on the throttle pedal. If the switch is off, do not allow throttle command
		{
			Throttle_Multiplier = 128
		}
		else
		{
			Throttle_Multiplier = 0
		}
	
	
	if (Drag_Mode_Switch_UP = ON)			;Someone pressed Drag Mode Button
		{
			Endurance_Mode_Switch_UP = OFF
			AutoCross_Mode_Switch_UP = OFF
			Call DragMode
			Drag_Mode_Switch_UP = OFF
			
		
			Setup_Delay(Drag_MaxCurrent_DLY,7000)		;Drag should exit after 7~8 seconds without input from driver
		}
	if (Endurance_Mode_Switch_UP = ON)		;Someone pressed Endurance Mode Button
		{
			AutoCross_Mode_Switch_UP = OFF
			Drag_Mode_Switch_UP = OFF
			Call EnduranceMode
			Endurance_Mode_Switch_UP = OFF
			
		}
	else if ((AutoCross_Mode_Switch_UP = ON)|((Drag_MaxCurrent_DLY_Output = 0)&(Drag_Mode_Initialized_Flag = ON)))	;If AutoCross Mode Switch UP edge is sensed OR the Drag_MaxCurrent_DLY = 0 AND Drag_Mode_Initialized_Flag = ON
		{
			Endurance_Mode_Switch_UP = OFF
			Drag_Mode_Switch_UP = OFF
			Drag_Mode_Initialized_Flag = OFF
			Call AutoCrossMode
			AutoCross_Mode_Switch_UP = OFF
		
		}
		
		
		if(Interlock_Switch = OFF)
			{
				E7_Drive_Gear_Select = PARKING_ICON
			}	
;		else if(Drag_MaxCurrent_DLY_Output <> 0)
;			{
;				;E7_Drive_Gear_Select = SPORT_ICON
;			}
		else if((Forward_Switch=OFF)&(Reverse_Switch = OFF))
			{
				E7_Drive_Gear_Select = NEUTRAL_ICON
			}				
		else if(Reverse_Switch = ON)
			{
				E7_Drive_Gear_Select = REVERSE_ICON
			}
		else if((Forward_Switch=ON)&(Drag_Mode_Switch_UP = OFF))
			{
				E7_Drive_Gear_Select = DRIVE_ICON
			}
		else
			{
				E7_Drive_Gear_Select = NO_GEAR_ICON
			}
			
			
		
;	else
;		{
;			;Do Nothing
;		}
		if ((Engage_Display_Delay_Output = 0)	& (Startup_CAN_System_Has_Been_Called_Flag = On) )	;if engage message timer expired
		{
		 Call Process_Engage
		}	
			
	goto MainLoop
	
	
;-------------------------------------------------------------------------
; Subroutines
;---------------------------------------------
;

DragMode:			

	Drive_Current_Limit = 26213 		;MAX Amps = 400A which is 80% of 32767
	Put_PWM(Endurance_Lights,0)     	;endurance light = ON	
	Clear_Digout(AutoCross_Lights)		;Turn off autocross light
	Set_Digout(Drag_Lights)			;Turn on drag light
  Drag_Mode_Initialized_Flag = ON ;Turn on Drag Mode Flag	
  Turtle_Icon = OFF
	Rabbit_Icon = ON	
		
	return
		
EnduranceMode:
	
	Drive_Current_Limit = 6553		;MAX AMPS = 100A which is 20% of 32767
	Clear_Digout(Drag_Lights)		;turn off drag light
	Clear_Digout(AutoCross_Lights)		;Turn off autocross light
	Put_PWM(Endurance_Lights,32767) 	;Turn on endurance light
	Rabbit_Icon = OFF
	Turtle_Icon = ON

	return

AutoCrossMode:
			
	Drive_Current_Limit = 16383 		;MAX AMPS = 250A which is 50% of 32767
	Clear_Digout(Drag_Lights) 		;Turn off drag light	
	Put_PWM(Endurance_Lights,0)		;Turn off  endurance light
	Set_DigOut(AutoCross_Lights)		;Turn on autocross light
	

	return




;*******************************************************************************************************
;If the controller is in a fault mode, the Message Center text displays the fault code.
;When multiple faults are active, the fault codes will be cycled through, each displaying for 2 sec. 
;When the controller is not in fault mode Message Center displays nothing (and other gages display)
;*******************************************************************************************************
Process_Engage:
															
		If ((Down_Button = On)&(Button_Press_Flag = OFF)&((Debounce_DLY_Output = 0)));&(Down_Button = On)));check if the operator wants to see the faults
			{		
			  Goto_MSG_Screen_Flag = On	
			  Goto_Gauge_Screen_Flag = Off
			  Setup_Delay(Debounce_DLY,500) 
			  Button_Press_Flag = ON
			}	
		else if((Down_Button = On)&(Button_Press_Flag = ON)&((Debounce_DLY_Output = 0)));&(Down_Button = On))) ;check if the operator wants to see the gauges
			{		
			  Goto_Gauge_Screen_Flag = On	
			  Goto_MSG_Screen_Flag = Off
			  Setup_Delay(Debounce_DLY,500) 
			  Button_Press_Flag = OFF
			}	
;		If ((Warning_Icon = Off)&(Down_Button = On)&(Reverse_Switch = On));check if the operator wants to see the faults
;			{		
;			  Goto_MSG_Screen_Flag = On	
;			  Goto_Gauge_Screen_Flag = Off
;			  ;Setup_Delay(Debounce_DLY,1000) 
;			}	
;		else if((Warning_Icon = Off)&(((Forward_Switch = On)&(Reverse_Switch = Off))|((Forward_Switch = Off)&(Reverse_Switch = On)))) ;check if the operator wants to see the gauges
;			{		
;			  Goto_Gauge_Screen_Flag = On	
;			  Goto_MSG_Screen_Flag = Off
;			  ;Forward_Switch_Up = OFF	
;			}	
					
;			else
;				{
;					Goto_Gauge_Screen_Flag = Off	
;			  	Goto_MSG_Screen_Flag = Off	
;			  }
		
		If (EnGage_State=0)				;Check for screen selection changes
			{
				User110 = 0x22	  		;Write 
				User111 = 0x00				;Object ID = 0x3224 Subindex =0x00
				User112 = 0x32
				User113 = 0x00	
				If (Goto_Gauge_Screen_Flag = On) {User114 = 0x05}
				If (Goto_MSG_Screen_Flag = On) {User114 = 0x06}
				User115 = 0x00 
				User116 = 0x00
				User117 = 0x00
				
				If (Switch_Screen_Flags <>0)
				{
					Send_Mailbox(e7_SDO_MOSI_Mailbox)								
					Switch_Screen_Flags = 0
					Setup_Delay(Engage_State_Delay, 100)
					EnGage_State = 1
				}	
				else
				{
					EnGage_State = 1 ;no delay needed because no SDO was sent
				} 	
			}
			else if( EnGage_State = 1)		;Determine if there is a fault present
			{
				if(Fault_Count <> 0)
					{
						if(Engage_Fault_Display_Delay_Output = 0)
	 						{													;Timer so that multiple faults will display each flash code for 2 secs on the engage Message Center
	 							Call Determine_Fault		;Note if Fault Exists, the response of RPM and AMP gages will also be delayed by 2+ secs before update cycle.
							}                         ;Determine if there is a fault to be displayed in the Message Center
			      														;Determine_Fault sets Engage_Fault_Display_Delay to 2 sec so that code bypasses this step.
							Warning_Icon = ON
							EnGage_State = 2
							
							If((e7_Text_Code = 8)|(e7_Text_Code = 5))
								{
									Temperature_Icon = ON
								}
							else
								{
									Temperature_Icon = OFF
								}
									
							
					}
					else
					{
						Warning_Icon = OFF
						EnGage_State = 0
					}
					Setup_Delay(Engage_State_Delay, 100)
			}
			else if(EnGage_State = 2)
				{
					If(Traction_Fault_Count <> 0)
					{
						User110 = 0x22	 		;Write of e7 Error Message
						User111 = 0x03
						User112 = 0x34      ;Object ID = 0x3403  for Text lines of Message Center
						User113 = 0x05      ;Sub Index = 0x05  5th line of 10 line display (right above middle of display)
						User114 = e7_Text_Code  ; Error Code for E6
						User115 = 0x00
						User116 = 0x00
						User117 = 0x00
						Send_Mailbox(e7_SDO_MOSI_Mailbox)		;Message Center SDOs must be sent using different Node ID
						Engage_State = 0
						Setup_Delay(Engage_State_Delay,200)	;reset engage message timer
					}
					else
					{	
						EnGage_State = 0
						Warning_Icon = OFF
						Battery_Icon = OFF
					}	
		
		
				}
  Return
  
  E7_Get_Data:
	
	If(Engage_Display_Delay_Output = 0)
		{
			If (Regen_State = On)
			{
				E7_Regen_Percentage	=  Get_Muldiv(MTD1,Current_RMS,100,IrmsPowerLimit)
			}
			Else
			{
				E7_Regen_Percentage = 0
			}
;			;If(MODE FROM BMS = XX)
;			{
;				E7_BMS_SOC = 0;THIS IS GOING TO BE DATA FROM THE BMS
;			}
			E7_Battery_Current = Current_RMS
			;E7_Battery_Current = Battery_Current
			E7_Keyswitch_Voltage = 0;THIS IS GOING TO BE DATA FROM THE BMS;(KeySwitch_Voltage/100)
			E7_Vehicle_Speed = (ABS_Vehicle_Speed/10)
			; E7_Vehicle_Speed = Vehicle_Speed/10 ; need to add equation to convert motor rpm to mph
		
			Setup_Delay(Engage_Display_Delay,100)
		}
			
	Return
	
	
Process_BMS:
	
	If ((BMS_State=0)&(BMS_State_Delay_Output = 0))				;Check for Pack SOC 
					{
				User70 = 0x42	  		;READ 
				User71 = 0x0F				;Object ID = 0xF00F Subindex =0x00
				User72 = 0xF0
				User73 = 0x00	
				User74 = 0x00
				User75 = 0x00 
				User76 = 0x00
				User77 = 0x00
				
				;Send_Mailbox(BMS_SDO_MOSI_Mailbox)								
				Setup_Delay(BMS_State_Delay, 100)
				BMS_State = 1
			}
			else if((BMS_State=1)&(BMS_State_Delay_Output = 0))				;Check for Pack Voltage
			{
				User70 = 0x42	  		;READ 
				User71 = 0x0D				;Object ID = 0xF00F Subindex =0x00
				User72 = 0xF0
				User73 = 0x00	
				User74 = 0x00
				User75 = 0x00 
				User76 = 0x00
				User77 = 0x00
				
				;Send_Mailbox(BMS_SDO_MOSI_Mailbox)								
				Setup_Delay(BMS_State_Delay, 100)
				BMS_State = 2
			}
				else if((BMS_State=2)&(BMS_State_Delay_Output = 0))				;Check for Pack Voltage
			{
				User70 = 0x42	  		;READ 
				User71 = 0x0D				;Object ID = 0xF00F Subindex =0x00
				User72 = 0xF0
				User73 = 0x00	
				User74 = 0x00
				User75 = 0x00 
				User76 = 0x00
				User77 = 0x00
				
				;Send_Mailbox(BMS_SDO_MOSI_Mailbox)								
				Setup_Delay(BMS_State_Delay, 100)
				BMS_State = 0
		}
			
	Return



	;*****************************************************************************************
Determine_Fault:
	
	Traction_Fault_Count = Fault_Count 	 ;this prevents the fault count form changing as faults are set or cleared
	Setup_Delay(Engage_Fault_Display_Delay,2000)			;Set timer so that fault text will remain for 2 secs, before next fault is displayed

	If(Traction_Fault_Count <> 0)
		{
			
			if(Index >= Traction_Fault_Count)	;check the end of the stack of fault codes was not reached
	   	{
				Index 	= 0		;end of stack reached so reset Index to beginning and retreive fault codes
			}
			Call Find_Fault_Code
			Index = Index+1
		}
				
	Return
	
;--------------------------------------------------------------------------
;Subroutine Find_Fault_Code - uses a Get_Fault_Code function to pop an active fault
;	code off the stack and then uses this info to translate into a Fault_Flash_Code,
;	which is returned for display on the spyglass (840).			
;				
;--------------------------------------------------------------------------
Find_Fault_Code:
	
	Fault_Code = Get_Fault_Code(Index)	;The resultant Fault_Code is NOT the flash code

	if(Fault_Code=0)
		{
		;Fault_Flash_Code=38	Main Contactor Welded
		e7_Text_Code=25
		}
	else if(Fault_Code=1)
		{
		;Fault_Flash_Code=39 Main Contactor Did Not Close
		e7_Text_Code=26
		}
	else if(Fault_Code=2)
		{
  	;Fault_Flash_Code=45 Pot Low Over Current
		e7_Text_Code=31
		}
	else if(Fault_Code=3)
		{
		;Fault_Flash_Code=42 Throttle Wiper Low
		e7_Text_Code=28
		}
	else if(Fault_Code=4)
		{
		;Fault_Flash_Code=41 Throttle Wiper High
		e7_Text_Code=27
		}
	else if(Fault_Code=5)
		{
		;Fault_Flash_Code=44 Pot 2 Wiiper Low
		e7_Text_Code=30
		}
	else if(Fault_Code=6)
		{
		;Fault_Flash_Code=43 Pot 2 Wiper Hi
		e7_Text_Code=29
		}
	else if(Fault_Code=7)
		{
		;Fault_Flash_Code=46 EEPROM Failure
		e7_Text_Code=32
		}
	else if(Fault_Code=8)
		{
		;Fault_Flash_Code=47 HPD/Sequencing
		e7_Text_Code=33
		}
	else if(Fault_Code=9)
		{
		;Fault_Flash_Code=17 Severe Undervoltage
		e7_Text_Code=6
		}
	else if(Fault_Code=10)
		{
		;Fault_Flash_Code=18 Severe Overvoltage
		e7_Text_Code=7
		}
	else if(Fault_Code=11)
		{
		;Fault_Flash_Code=23 Undervoltage Cutback
		e7_Text_Code=9
		}
	else if(Fault_Code=12)
		{
		;Fault_Flash_Code=24 Overvoltage Cutback
		e7_Text_Code=10
		}
	else if(Fault_Code=13) 
		{
		;Fault_Flash_Code=21 Not Used
		
		}
	else if(Fault_Code=14)
		{
		;Fault_Flash_Code=22 Controller Overtemp Cutback
    e7_Text_Code=8
		}
	else if(Fault_Code=15)
		{
		;Fault_Flash_Code=15 Controller Severe Undertemp
		e7_Text_Code=4
		}
	else if(Fault_Code=16)
		{
		;Fault_Flash_Code=16 Controller Severe Overtemp
		e7_Text_Code=5
		}
	else if(Fault_Code=17)
		{
		;Fault_Flash_Code=31 Coil 1 Driver Open/Short
		e7_Text_Code=16
		}
	else if(Fault_Code=18)
		{
		;Fault_Flash_Code=32 Coil 2 Driver Open/Short
		e7_Text_Code=18
		}
	else if(Fault_Code=19)
		{
		;Fault_Flash_Code=33 Coil 3 Driver Open/Short
		e7_Text_Code=20
		}
	else if(Fault_Code=20)
		{
		;Fault_Flash_Code=34 Coil 4 Driver Open/Short
		e7_Text_Code=21
		}
	else if(Fault_Code=21)
		{
		;Fault_Flash_Code=35 PD Open/Short
		e7_Text_Code=22
		}
	else if(Fault_Code=22)
		{
		;Fault_Flash_Code=31 Main Open/Short
		e7_Text_Code=17
		}
	else if(Fault_Code=23)
		{
		;Fault_Flash_Code=32 EM Brake Open /Short
		e7_Text_Code=19
		}
	else if(Fault_Code=24)
		{
		;Fault_Flash_Code=14 Precharge Fault
		e7_Text_Code=3
		}
	else if(Fault_Code=25)
		{
		;Fault_Flash_Code=26 Digital Out 6 Overcurrent
		e7_Text_Code=12
		}
	else if(Fault_Code=26)
		{
		;Fault_Flash_Code=27 Digital Out 7 Overcurrent
		e7_Text_Code=13
		}
	else if(Fault_Code=27)
		{
		;Fault_Flash_Code=12 Controller Overcurrent
		e7_Text_Code=1
		}
	else if(Fault_Code=28)
		{
		;Fault_Flash_Code=13 Current Sensor Fault
		e7_Text_Code=2
		}
	else if(Fault_Code=29)
		{
		;Fault_Flash_Code=28 Motor Temp Hot Cutback
		e7_Text_Code=14
		}
	else if(Fault_Code=30)
		{
		;Fault_Flash_Code=49 Parameter Change Fault
		e7_Text_Code=36
		}
	else if(Fault_Code=31)
		{
		;Fault_Flash_Code=37 Motor Open
		e7_Text_Code=24
		}
	else if(Fault_Code=32)
		{
		;Fault_Flash_Code=51 VCL FAULT 1
		 e7_Text_Code=62    ; "BMS Module Fault" will display on e7 to indicate BMS has a fault
		 
		}
	else if(Fault_Code=33)
		{
		;Fault_Flash_Code=52 VCL FAULT 2  this is a custom HPD Fault that trips if throttle is active at within 100ms of power up.
		;e7_Text_Code=70    ; "Low pressure Switch" will display on e7.
		}
	else if(Fault_Code=34)
		{
		;Fault_Flash_Code=53 VCL FAULT 3
		;e7_Text_Code=73   ; "Motor RPM"  will display on e7 to indicate Motor has been spun too fast.  
		}
	else if(Fault_Code=35)
		{
		;Fault_Flash_Code=54 VCL FAULT 4 
		}
	else if(Fault_Code=36)
		{
		;Fault_Flash_Code=55 VCL FAULT 5
		}
	else if(Fault_Code=37)
		{
		;Fault_Flash_Code=56 VCL FAULT 6
		}
	else if(Fault_Code=38)
		{
		;Fault_Flash_Code=57 VCL FAULT 7
		}
	else if(Fault_Code=39)
		{
		;Fault_Flash_Code=58 VCL FAULT 8
		}
	else if(Fault_Code=40)
		{
		;Fault_Flash_Code=59 VCL FAULT 9
		}
	else if(Fault_Code=41)
		{
		;Fault_Flash_Code=61 VCL FAULT 10
		}
	else if(Fault_Code=42)
		{
		;Fault_Flash_Code=62 VCL FAULT 11
		}
	else if(Fault_Code=43)
		{
		;Fault_Flash_Code=63 VCL FAULT 12
		}
	else if(Fault_Code=44)
		{
		;Fault_Flash_Code=64 VCL FAULT 13
		}
	else if(Fault_Code=45)
		{
		;Fault_Flash_Code=65 VCL FAULT 14
		}
	else if(Fault_Code=46)
		{
		;Fault_Flash_Code=66 VCL FAULT 15
		}
	else if(Fault_Code=47)
		{
		;Fault_Flash_Code=67 VCL FAULT 16
		}
	else if(Fault_Code=48)
		{
		;Fault_Flash_Code=69 External Supply Out Of Range
		e7_Text_Code=38
		}
	else if(Fault_Code=49)
		{
		;Fault_Flash_Code=29 Motor Temp Sensor Fault
		e7_Text_Code=15
		}
	else if(Fault_Code=50)
		{
		;Fault_Flash_Code=68 VCL Run Time Error
		e7_Text_Code=37
		}
	else if(Fault_Code=51)
		{
		;Fault_Flash_Code=25 +5V Supply 
		e7_Text_Code=11
		}
	else if(Fault_Code=52)
		{
		;Fault_Flash_Code=71 OS General
		e7_Text_Code=39
		}
	else if(Fault_Code=53)
		{
		;Fault_Flash_Code=72 PDO Timeout
		e7_Text_Code=40
		}
	else if(Fault_Code=54)
		{
		;Fault_Flash_Code=36 Encoder Fault
		e7_Text_Code=23
		}
	else if(Fault_Code=55)
		{
		;Fault_Flash_Code=73 Stall Detected
		e7_Text_Code=41
		}
	else if(Fault_Code=58)
		{
		;Fault_Flash_Code=47 Emergency Rev HPD
		e7_Text_Code=34
		}
	else if(Fault_Code=60)
		{
		;Fault_Flash_Code=89 Motor Type Fault
		e7_Text_Code=45
		}
	else if(Fault_Code=62)
		{ 
		;Fault_Flash_Code=87 Motor Characterization Fault
		e7_Text_Code=44
		}
;	else if(Fault_Code=63)
;		{
;		;ENC CHAR 
;		Fault_Flash_Code=83
;		}
	else if(Fault_Code=66)
		{
		;Fault_Flash_Code=92 EM Brake Failed to Set
		e7_Text_Code=47
		}
	else if(Fault_Code=67)
		{
		;Fault_Flash_Code=93 Encoder Limited Operating Strategy
		e7_Text_Code=48
		}
	else if(Fault_Code=68)
		{
		;Fault_Flash_Code= 94 Emer Rev Timeout
		e7_Text_Code=49
		}
	else if(Fault_Code=69)
		{
		;Fault_Flash_Code=75 Dual Severe Fault
		e7_Text_Code=43
		}	
	else if(Fault_Code=70)
		{
		;Fault_Flash_Code=74 Fault on Other Traction Controller
		e7_Text_Code=42
		}	
	else if(Fault_Code=71)
		{
		;Fault_Flash_Code=98 Illegal Model Number
		e7_Text_Code=53
		}
	else if(Fault_Code=72)
		{
		;Fault_Flash_Code=95 Pump Overcurrent
		e7_Text_Code=50
		}
	else if(Fault_Code=73)
		{
		;Fault_Flash_Code=96 Pump BDI
		e7_Text_Code=51
		}
	else if(Fault_Code=74)
		{
		;Fault_Flash_Code=47 Pump HPD
		e7_Text_Code=35
		}
	else if(Fault_Code=75)
		{
		;Fault_Flash_Code=99 Dualmotor Parameter Mismatch
		e7_Text_Code=54
		}
	return	
	



;===============================================================
;									STARTUP CAN SYSTEM
;===============================================================


;Mailbox 1 - SDO Write to enGage 7
;Mailbox 2 - SDO READ from enGage 7
;Mailbox 3 - Dual Drive PDO_MOSI (OS Reserved if using dual drive)
;Mailbox 4 - Dual Drive PDO_MISO (OS Reserved if using dual drive)
;Mailbox 5 - Dual Drive EMCY Receive (OS Reserved if using dual drive)
;Mailbox 6 - Dual Drive EMCY transmit (OS Reserved if using dual drive)
;Mailbox 7 - CANopen Slave NMT receive (OS Reserved)  -- used to send NMt message in this application
;Mailbox 8 - CANopen Slave Heartbeat transmit (OS Reserved)
;Mailbox 9 - CANopen SDO MISO (OS Reserved)
;Mailbox 10 - CANopen SDO MOSI (OS Reserved)
;Mailbox 11 - CANopen PDO1_MOSI transmit (OS Reserved)   -- 
;Mailbox 12 - CANopen PDO1_MISO receive  (OS Reserved)  
;Mailbox 13 - CANopen PDO2_MISO transmit (OS Reserved)
;Mailbox 14 - CANopen PDO2_MISO receive  (OS Reserved)

; This routine initializes and starts the CAN System. It has to be
; called in the One Time setup (before the main loop).This setup 
; is supossed to work only if slave devices doesn't require NMT.
startup_CAN_System:
  Suppress_CANopen_Init = 0	;first undo suppress, then startup CAN, then disable CANopen
	Setup_CAN(CAN_Baud_Rate,0,0,-1,0) ; Baudrate from parameter block, no Sync, Not Used, Node ID from Parameter Block, Auto Restart

;  Disable_CANOpen_Emergency()  ;releases CAN6 to VCL control --- CAN6 is needed for Dual Drive Emergency Messages
;  Disable_CANOpen_Heartbeat()	;releases CAN8 to VCL control
 Disable_CANOpen_NMT()				;releases CAN7 to VCL control        ---
 Disable_CANOpen_PDO()				;releases CAN11-CAN14 to VCL control -- Used for PDO reception from the Acuity slave.
;   Disable_CANOpen_SDO()			;releases CAN9 and CAN10 to VCL control
;   Disable_CANOpen()				  ;releases all CAN mailboxes

  ; Setup_CAN(CAN_500KBAUD,0,0,0,0)	; Baudrate = OS Baud Rate, no Sync, Not Used, Not Used, Auto Restart\
  ;
	;############################# MAILBOX SETUP #################################
	;================== MESSAGES SETUP ====================      
	;--------------------------------------------
 	; Purpose        Send NMT Message to 
	; Type           NMT
  ; Reception      Only sent once
  ; Data Length    2 Byte						
	Setup_Mailbox(STARTUP_Mailbox,0,0,0x00,C_EVENT,C_XMT,0,0)
	Setup_Mailbox_Data(STARTUP_Mailbox,2,
                        @NMT_Command_Specifier,
                        @NMT_Node_Address,
                        0,0,0,0,0,0)
 
   
  ; Purpose:        Send information to the Engage display for the Message center.
  ; Type:           SDO MOSI
  ; Data Length:    8 Byte
  Setup_Mailbox(e7_SDO_MOSI_Mailbox,0,0,SDO_MOSI_BASE+ENGAGE_7_NODE,C_EVENT,C_XMT,0,0)
  Setup_Mailbox_Data(e7_SDO_MOSI_Mailbox,8,
						@User110,	  
  					@User111,			 
            @User112,			 
						@User113,	 
						@User114,		  
            @User115,	 
            @User116,	   
            @User117)
            
  		
                    
 
  ; Purpose:        Get information from the Engage display for the Message center.
  ; Type:           SDO MISO
  ; Data Length:    8 Byte
  Setup_Mailbox(e7_SDO_MISO_Mailbox,0,0,SDO_MISO_BASE+ENGAGE_7_NODE,C_EVENT,C_RCV,0,0)
  Setup_Mailbox_Data(e7_SDO_MISO_Mailbox,8,
						@User36,	  
  					@User36+USEHB,			 
            @User37,			 
						@User37+USEHB,	 
						@User38,		  
            @User38+USEHB,	 
            @User39,	   
            @User39+USEHB)	
            
             ; Purpose:        Send information to the Engage display for the Message center.
  ; Type:           PDO MOSI
  ; Data Length:    8 Byte
  Setup_Mailbox(e7_PDO_MOSI_Mailbox,0,0,PDO1_RX_BASE+ENGAGE_7_NODE,C_CYCLIC,C_XMT,50,e7_PDO_MISO_Mailbox)
  Setup_Mailbox_Data(e7_PDO_MOSI_Mailbox,8,
						@E7_Battery_Current,	  
  					@E7_Battery_Current+USEHB,			 
            @E7_BMS_SOC,					 
						@E7_Keyswitch_Voltage,	 
						@E7_Regen_Percentage,		  
            @E7_Vehicle_Speed,	 
            @E7_Icon_Status,	   
            @E7_Drive_Gear_Select)

  ; Purpose:        Receive information from the Engage display 
  ; Type:           PDO MISO
  ; Data Length:    8 Byte
  Setup_Mailbox(e7_PDO_MISO_Mailbox,0,0,PDO1_TX_BASE+ENGAGE_7_NODE,C_EVENT,C_RCV,0,0)
  Setup_Mailbox_Data(e7_PDO_MISO_Mailbox,8,
						@User50,	  		
  					@User50+USEHB,
  					@User51,
  					@User51+USEHB,
  					@User52,
  					@User52+USEHB,
  					@User53,
  					@E7_Pushbutton_Status)
										
						
            
;  ; Purpose:        Send information to the BMS.
;  ; Type:           SDO MOSI
;  ; Data Length:    8 Byte
;  Setup_Mailbox(BMS_SDO_MOSI_Mailbox,0,0,0x73E,C_EVENT,C_XMT,0,0)
;  Setup_Mailbox_Data(BMS_SDO_MOSI_Mailbox,8,
;						@User70,	  
;  					@User71,			 
;            @User72,			 
;						@User73,	 
;						@User74,		  
;            @User75,	 
;            @User76,	   
;            @User77)
;            
;  ; Purpose:        Send information to the BMS.
;  ; Type:           SDO MOSI
;  ; Data Length:    8 Byte
;  Setup_Mailbox(BMS_SDO_MISO_Mailbox,0,0,0x7EB,C_EVENT,C_RCV,0,0)
;  Setup_Mailbox_Data(BMS_SDO_MISO_Mailbox,8,
;						@User78,	  
;  					@User79,			 
;            @User80,			 
;						@User81,	 
;						@User82,		  
;            @User83,	 
;            @User84,	   
;            @User85)
;                                  
            
                      

  ;######################### CAN NODE START #####################################
 	Startup_CAN()                        
	
	call Setup_Engage
	
	;==================== START UP CAN ============================
	Startup_CAN_Cyclic()			; Do it now so there is no chance of the NODE 1 timing out.
	CAN_Set_Cyclic_Rate(5) 		;this sets the cyclic cycle to every 40 ms
	NMT_Command_Specifier =  NMT_CS_START_REMOTE_NODE		;CS=1 means go operational
	NMT_Node_Address = ENGAGE_7_NODE	
	Send_Mailbox(STARTUP_Mailbox)
	return	
	
	
	
Setup_Engage:
	

	User110 = 0x22	;write	  
  User111 =	0x41	;index id 0x3041	EEPROM Write Enable
  User112 = 0x30
	User113 =	0x00	;sub-index 0x00
	User114 =	0x01	;1=enable 
  User115 =	0x00
  User116 =	0x00 
  User117 = 0x00
	
	call Send_Engage_SDO
	
	User110 = 0x22	;write	  
  User111 =	0x00	;index id 0x3000 
  User112 = 0x30
	User113 =	0x00	;sub-index 0x00
	User114 =	0x01	;1=250KBaud  
  User115 =	0x00
  User116 =	0x00 
  User117 = 0x00
  
	call Send_Engage_SDO
	
	User110 = 0x22	;write	  
  User111 =	0x41	;index id 0x3041	EEPROM Write Enable
  User112 = 0x30
	User113 =	0x00	;sub-index 0x00
	User114 =	0x00	;0=disable 
  User115 =	0x00
  User116 =	0x00 
  User117 = 0x00
	
	call Send_Engage_SDO
	
	Return
	
	Send_Engage_SDO:

user98=user98+1
	CAN2_Received = Off		;clear SDO receive flag
	Send_Mailbox(e7_SDO_MOSI_Mailbox)
	Setup_Delay(Engage_Display_Delay,40)
	While((CAN2_Received = Off)&(Engage_Display_Delay_Output <> 0)) 
		{
		;Wait until SDO Response is received
		}
		
		Return
	
			
