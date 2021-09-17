//
// Source:
//	minucce
//
//
// License:
//	Code should be used only for educational, documentation and modding purposes.
//	Please keep derivative work open source.


//
// Sword - Rod draw parameters
//

bank 7;
org $F749	// 0x1F759
// X-Pos - up, down, left, right
	db $FF, $01, $00, $F8	// State 1 = Dummy (not drawn)
	db $FF, $01, $F5, $0B	// State 2 = Attack
	db $FF, $01, $F9, $07	// State 3 = Pull back
	db $FF, $01, $FD, $03	// State 4 = Put away

org $F759	// 0x1F769
// Y-Pos - up, down, left, right
	db $F7, $F2, $F5, $F5	// State 1 = Dummy (not drawn)
	db $F6, $0D, $03, $03	// State 2 = Attack
	db $F7, $09, $03, $03	// State 3 = Pull back
	db $FF, $05, $03, $03	// State 4 = Put away

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// State 1 X-Pos = Unused, reuse for our purpose
// State 1 Y-Pos = Unused, reuse for our purpose

// Vertical down sword is h-flipped to center the blade correctly (+1 right)
// -  See Displaced Gamers hitbox detection
org $F749	// 0x1F759
sword_palette:
	db $00, $C0, $00, $00

org $F759	// 0x1F769
rod_palette:
	db $01, $C1, $01, $01

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

org $F7DF	// 0x1F7EF
	cpx.b #$0D		// Sword only
	bne rod_attr

	lda.w sword_palette,y
	clc
	adc.w $0657		// Sword type (1-3)
	sec
	sbc.b #$01
	bcs set_attribute

rod_attr:
	lda.w rod_palette,y

set_attribute:

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

org $F82C	// 0x1F83C
	lda.b #$06		// Bank 6 swap
	jsr $FFAC

	lda.b #$10
	jsr magic_shot_align

	php
	lda.b #$05		// Restore bank 5
	jsr $FFAC
	plp

	bcs $16			// $F855-($F841-2)
	bcc $00			// $F841-($F841-0)

// #############################################################

bank 6; org $BFC0	// 0x1BFD0
magic_shot_align:
	jsr $711F		// Create magic weapon

	lda.b $98,x		// Horizontal beam (1,2)
	cmp.b #$04
	bcs vertical_beam

	lda.b $70,x		// Check X-Pos boundary
	cmp.b #$14
	bcc exit_2

	cmp.b #$EC
	bcs exit_2

exit_1:
	rts	// goto $F841

exit_2:
	sec	// goto $F855
	rts


// =======================================================

vertical_beam:
	cmp.b #$08	// Up = +1 left
	lda.b #$FF
	bcs move_beam

down_beam:
	lda.b $AC,x	// Rod (80) = +1 right
	cmp.b #$80

	lda.b #$01
	bcs move_beam

	lda.b #$02	// Sword (10) = +2 right

move_beam:
	clc
	adc.b $70,x
	sta.b $70,x

	clc	// goto $F841
	rts

