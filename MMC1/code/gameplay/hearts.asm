//***********************************************************
//	Save hearts to SRAM
//*********************************************************** 

// RAM $066F is the amount of hearts obtained and filled
// Hearts are separated in nibbles:
// 1st: 1111 -> F = 16 hearts / Max amount of hearts (0 = 1 heart)
// 2nd: 1111 -> F = Fill all 16 hearts (0 = 1 heart filled)

// Address $6032 is where the game stores the current amount of hearts obtained in SRAM for Slot 1
// $6032 - Slot 1
// $605A - Slot 2
// $6082 - Slot 3

// FREE RANGES: 
// Bank 2: 8F6F-900F, 9BE7-9D0F, A840-A86F, A8EA-A90F
// Bank 5: 145DA-1460F, 153EC-1540F, 15BE8-15F0F (OW columns, ruppe code begin at 15F10 and ends at 15FAC), 16CB0-16D0F

bank 2;
// Routine in charge of loading the hearts at File start
org $A606	// 0x0A616
	lda.b ($00),y	// Loads hearts value from SRAM ($6032-5A-82)
	sta.w $0657,y	// Stores table from SRAM (gets to $066F)
	dey

// ???
org $A6C6	// 0x0A6D6
	lda.w $0657,y	// Grabs the value from $066F, RAM Location
	sta.b ($C0),y	// Stores it from $68B0?, SRAM Location 

// ???
org $A6F3	// 0x0A703
	lda.w $066F	// Load RAM $066F (Hearts)
	and.b #$F0	// Compare to value #$F0
	pha		// Push to stack
	lsr		// Left shift
	lsr
	lsr
	lsr
	sta.b $0A	// Stores in RAM $0A
	pla
	ora.b $0A	// Or $0A
	sta.w $066F	// Store in RAM $066F (Hearts)
	lda.b #$FF	// Load value #$FF
	sta.w $0670	// Store $FF in "Partial hearts" address

// ???
org $A819	// 0x0A829
org $A827	// 0x0A837
	lda.w $066F,y	// Load table from RAM $066F
	sta.b ($C0),y	// Stores it from $0650?, SRAM Location 

bank 5;
// Routine in charge of saving hearts on manual save or game over
org $8B6D	// 0x14B7D
	lda.w $066F	// Load Hearts address
	and.b $F0	// Compare with #$F0
	ora.b #$02	// Set default value to #$02?
	sta.w $066F	// Store in address $066F (Hearts)
	lda.b #$FF	// Load value #$FF
	sta.w $0670	// Store $FF in "Partial hearts" address
	// Jump to $EBA3 (close routine?)
