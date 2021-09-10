//
// Source:
// 	minucce
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Reset dungeon room door flags
//

bank 5; org $B4A5	// 0x174B5
	jsr dungeon_front_room_reset

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Clear save ram  (optimized)
//

org $B4AC	// 0x174BC
	lda.w $6001	// RAM start init
	cmp.b #$5A
	bne +

	lda.w $7FFF	// RAM end init
	cmp.b #$A5
	beq clear


// =====================================================

+;	lda.b #$FF	// Reset save slots
	sta.w $652A
	sta.w $652B
	sta.w $652C

	lda.b #$65	// Wipe 6530-7fff
	sta.b $01
	lda.b #$30
	sta.b $00

	ldy.b #$00

-;	tya		// Wipe sram
	sta.b ($00), y

	inc.b $00	// Bump ptr
	bne -
	inc.b $01
	bpl -

	sec
	rts

// =====================================================

clear:
	clc
	rts

// #####################################################

dungeon_front_room_reset:
	sta.w $0526	// Old code

	lda.b #$00	// Reset dungeon room flags
	sta.b $EE

	rts

