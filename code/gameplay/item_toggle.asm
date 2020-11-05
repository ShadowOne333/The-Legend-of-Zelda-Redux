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
	lda.b #$01	// PAD_RIGHT
	ldy.w $0656	// Load current item
	jsr $B7A8	// Get next item $B7C8 (use 'jsr $B7A8' to also play SFX)
// Old Letter overflow fix by gzip
	ldy.w $0656	// Load current item position
	cpy.b #$10	// Compare if value is $10 (out of range)
	bpl out_range	// BPL $03 - Go to out_range if its out of range
	jmp return	// End routine
out_range:
	ldy.w $065F	// Load Magical Rod address
	cpy.b #$01	// Check if Magic Rod is obtained
	bne no_rod	// BNE $08 - Jump to no_rod if there's no Rod
	lda.b #$08	// If Magic Rod is obtained, load its position
	sta.w $0656	// Store Rod position in current item position
	jmp return	// End routine
no_rod:
	lda.b #$00	// Load value $00 into stack
	sta.w $0656	// Store $00 in the current item position
return:
	rts
