//***********************************************************
//   Select button toggles between selected B button items
//***********************************************************

// Max value is $08. After 08 it jumps to the Raft and other Key items.
// Routine begins at $EC1B (0x1EC2B), ends at $EC79 (0x1EC89)
// Pause check begins at 1EC46, compares if Select has been pressed and then does LDA $00E0, EOR #$01 and STA $00E0 to #$01 (RAM $00E0), which tells the game it is Paused. Bypassing the Pause can be done by NOP'ing the LDA/EOR/STA starting at 0x1EC4C ($EC3C).

bank 7; org $EC3C  // 0x1EC4C
	// Switch to bank 5
	lda.b #$05
	jsr $FFAC
	// Hijack PAD_SELECT pressed on the overworld
	jsr quick_select

bank 5; org $BFC0  // 0x17FD0
quick_select:
// New method by gzip
	lda.b #$01	// PAD_RIGHT
	ldy.w $0656	// Load current item
	jsr $B7A8	// Get next item $B7C8 (use 'jsr $B7A8' to also play SFX)
// Old Letter overflow fix by gzip
	ldy.w $0656	// Load current item position into Y
	cpy.b #$10	// Compare if value is $10 (out of range)
	bpl out_range	// BPL $03 - Branch if greater than or equal to $10 (out of range
	jmp l_BFDE	// Otherwise, skip to return
out_range:	// $BFD2, 0x17FE2
	lda.b #$08	// Load rod value into A
	sta.w $0656	// Set current item to rod
	ldy.w $065F	// Load rod status into Y
	cpy.b #$01	// Check if rod is present (1)
	bne l_BFDF	// BNE $01, Branch back to beginning if there's no rod (0)
l_BFDE:
	rts		// Otherwise, return
l_BFDF:
	jmp quick_select	// Jump back to beginning so the correct item is set


