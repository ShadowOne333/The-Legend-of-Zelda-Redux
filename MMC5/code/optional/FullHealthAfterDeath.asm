//***********************************************************
//	Refill all heart containers after a Game Over
//***********************************************************

bank 5;		
org $85D0	// 0x145E0
	lda.w $066F	// Load heart container value
	and.b #$F0	// Mask higher byte, Originally AND #$0F
	sta.w $066F	// Store masked value for heart container
	lsr		// Do 4 bit shifts right
	lsr
	lsr
	lsr
	ora.w $066F
	sta.w $066F
	rts

	nop
