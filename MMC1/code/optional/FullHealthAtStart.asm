//***********************************************************
//	Refill all heart containers when loading a game
//***********************************************************

bank 2;		
org $A635	// 0x0A645
	jmp RefillHealth

org $A830	// 0x0A840
RefillHealth:
	lda.w $066F	// Make halth container equal to current health
	and.b #$F0
	sta.w $066F
	lsr
	lsr
	lsr
	lsr
	adc.w $066F
	sta.w $066F

	jmp $EBA1
