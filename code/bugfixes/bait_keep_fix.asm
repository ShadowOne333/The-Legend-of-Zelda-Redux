//
// Source:
// 	The3Dude
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// Ensure the Bait item is removed from the inventory at the exact time it is given

bank 1; org $8C88	// 0x4C98

	jmp bait_keep_fix
	nop
	nop

org $8CB0	// 0x4CC0
bait_keep_fix:
	lda.b #$00	// Load 0 into accumulator
	sta.w $065D	// InvFood, remove food item from the inventory in RAM
	lda.b #$04	// Load 4 into accumulator (track ID)
	sta.w $0602	// Tune 1 request
	jmp $8C8D	// Return back to the original hijack code
	//rts		// This isn't necessary since we're jumping back to the original code
