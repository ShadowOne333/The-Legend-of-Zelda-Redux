//***********************************************************
//  Save hearts to SRAM (by ShadowOne333 w/help by minucce)
//*********************************************************** 

// RAM $066F is the amount of hearts obtained and filled
// Hearts are separated in nibbles:
// 1st: 1111 -> F = 16 hearts / Max amount of hearts (0 = 1 heart)
// 2nd: 1111 -> F = Fill all 16 hearts (0 = 1 heart filled)

// FREE RANGES: 
// Bank 5: 145DA-1460F, 153EC-1540F, 15BE8-15F0F (OW columns, rupees code begins at 15F10 and ends at 15FAC), 16CB0-16D0F

bank 5;
// Routine in charge of saving hearts on manual save or game over
org $8B66	// 0x14B76
// Untouched
	ldy.b $13	// Routine index
	lda.w $8AE9,y
	sta.b $12	// Game mode
// Changed for hearts save
	jsr save_hearts	// Jump to our custom subroutine
	nop #07		// NOP bytes from original routine
// Untouched
	lda.b #$FF	// Load value #$FF
	sta.w $0670	// Store $FF in "Partial hearts" address
	jsr $EBA3

org $85D0	// 0x145E0, Free space
save_hearts:
	lda.w $066F	// Load Hearts address
	and.b #$0F	// Mask higher nibble (only consider current health, not max amount of hearts)
	cmp.b #$02	// Compare result to #$02 (3 hearts)
	bcs not_three	// Branch if equal or greater than 3 hearts

	lda.w $066F	// Load Hearts address
	and.b #$F0	// Mask lower nibble (to avoid the case of heart value $01 loading as $03)
	ora.b #$02	// Bitwise OR to #$02 (Org. ORA #$02)
	sta.w $066F	// Store in address $066F (Hearts)
not_three:
	rts

