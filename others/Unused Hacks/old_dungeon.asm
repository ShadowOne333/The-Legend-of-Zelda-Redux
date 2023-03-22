//***********************************************************
//	Change "LEVEL-0" to "DUNGEON-0" (by abw)
// 		(Old repointed method)
//***********************************************************

// LEVEL-X text changed to "DUNGEON-X" for text that appears above the Dungeon maps

define	level_string_ram_addr	$6C80

bank 6;
// Re-arrange existing code to free up space for a JSR to new code
org $8047	// 0x18057
// Indirect control flow target
L06_8047:
	lda.b $10
	asl
	tax
	ldy.b $16
	lda.w $062D,y
	bne L06_805E
	lda.w $8000,x
	sta.b $00
	lda.w $8001,x
	jmp L06_8067
L06_805E:
	lda.w $802A,x
	sta.b $00
	lda.w $802B,x
L06_8067:
	sta.b $01
	ldy.b #$03
	jsr setup_copy_range	// Set up copy destination start ($02) and end ($04) variables
	jmp L06_80D7		// Read data from ($00) and write it to ($02) through to ($04); exits with Y == #$00
	nop			// Maintain original code alignment

// Indirect control flow target
L06_8070:
	lda.b $10
	asl
	tax
	lda.w $8014,x
	sta.b $00
	lda.w $8015,x
	sta.b $01
	ldy.b #$07
	jsr setup_copy_range	// Set up copy destination start ($02) and end ($04) variables
	jsr L06_80D7		// Read data from ($00) and write it to ($02) through to ($04); exits with Y == #$00
	sty.b $13
	nop			// Maintain original code alignment
L06_8089:
	jmp $FFC0		// JMP $FFC0 required by Automap!
// If not using Automap, substitute JMP $FFC0 for the following
//	inc.b $11
//	rts

// Indirect control flow target
L06_808C:
	lda.b #$D8	// Inlining low byte of L06_9CD8
	sta.b $00
	lda.b #$9C	// Inlining high byte of L06_9CD8
	sta.b $01
	ldy.b #$0B
	jsr setup_copy_range	// Set up copy destination start ($02) and end ($04) variables
	jsr L06_80D7		// Read data from ($00) and write it to ($02) through to ($04); exits with Y == #$00
	sty.b $13

// Copy the "DUNGEON-X" string from ROM to cartridge RAM
copy_level_text:
	ldy.b #$0D 		// 13 = length of PPU address (2) + text length (1) + text (9) + string end token (1)
loop:
	lda.w level_text-1,y
	sta {level_string_ram_addr}-1,y
	dey
	bne loop
	rts

copy_ranges:
	dw $687E,$6B7D
	dw $6B7E,$6C7D
	dw $67F0,$687D

setup_copy_range:
	ldx.b #$04
copy_loop:
	lda.w copy_ranges,y
	sta.b $01,x
	dey
	dex
	bne copy_loop
	rts

L06_80D7:
	ldy.b #$00
L06_80D9:
	lda.b ($00),y
	sta.b ($02),y
	lda.b $02
	cmp.b $04
	bne INC_read_write_addrs
	lda.b $03
	cmp.b $05
	bne INC_read_write_addrs
	inc.b $13	// Routine index
	rts

// Optimize existing code to free up space for a new routine
INC_read_write_addrs:
	inc.b $02
	bne done_write_addr_INC
	inc.b $03
done_write_addr_INC:
	inc.b $00
	bne done_read_addr_INC
	inc.b $01
done_read_addr_INC:
	jmp L06_80D9

// String bytes
//org $9D90	// 0x19DA0, Free Space
level_text:
	db $20,$56,$09	// Originally $20,$56,$07
	db "DUNGEON-0"	// Originally "LEVEL-0"
	db $FF

// The old "LEVEL-0" string still gets copied to RAM $681C, but is no longer used
org $9D04	// 0x19D14 - Original location
	db $20,$56,$07	// Originally $20,$56,$07
	db "LEVEL-0"	// Originally "LEVEL-0"
	db $FF

// Update pointer to new string for Dungeons
org $A00C	// 0x1A01C
	dw {level_string_ram_addr}		// Originally $681C

bank 5;
// Move Dungeon numeral two tiles to the right (DUNGEON-X)
org $B02F	// 0x1703F
// Update level number write address
	sta.w {level_string_ram_addr}+11	// Originally STA $6825



