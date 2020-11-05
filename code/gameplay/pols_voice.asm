//***********************************************************
//	Kill Pols Voice by using the flute and/or arrows
//***********************************************************

// Code by Stratoform from RomHacking.net

bank 4;
org $9C36	// 0x11C46
	jsr flute_pols_call

org $BF30	// 0x13F40
flute_pols_call:
	jsr $79D0		// Detour code

	lda.w $051B		// Flute (0) = Unused, exit
	beq flute_pols_exit

	lda.b $28,x		// Timer (0) = Start SFX
	bne flute_pols_timer

	lda.b #$44+$80-1	// Timer = x44 frames
	sta.b $28,x
	rts

flute_pols_timer:
	bmi flute_pols_exit	// Timer (x80+) = Playing SFX
	// Timer (x7F) = done
	jsr $FEA6		// Kill all pols

flute_pols_exit:
	rts
