//
// Source:
//	minucce
//
//
// License:
//	Code should be used only for educational, documentation and modding purposes.
//	Please keep derivative work open source.


//
// Draw sword or rod
//

bank 7;
org $F7AB	// 0x1F7BB
	lda.b #$06	// Bank switch
	jsr $FFAC

	jsr sword_detect

	lda.b $84,x	// Normal swing (00)
	bne $44		// $44 , $F7FB-$F7B7

//warnpc $F7B7

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Diagonal sword swing
//

bank 6;
org $BD00	// 0x1BD10
sword_detect:
	lda.b $98	// Player direction
	sta.b $98,x	// Object direction

	jsr $7013	// Direction index
	sty $01

	tya
	clc
	adc.b $00
	tay


// =============================================

	sty.b $0C

	lda.b $AC,x	// State 2 = Attack position
	cmp.b #$02
	bne normal_weapon

	cpx.b #$0D	// Sword only
	beq wide_sword

normal_weapon:
	ldy.b $0C

	lda.b #$00	// Regular attack
	sta.b $84,x

	jmp wide_sword_exit


// ##################################################

wide_sword:
	ldy.b $0C

	lda.b $01	// 8 frames per direction
	asl
	asl
	asl
	sta.b $01

	lda.w $03D0,x	// Frame #(8,7,6, .. ,1)
	sec
	sbc.b #$01
	eor.b #$07
	clc
	adc.b $01
	tay


// ====================================================

	lda.b $70	// Player Xpos
	clc
	adc.w wide_sword_xpos,y
	sta.b $70,x	// Hitbox Xpos
	sta.b $00

	lda.b $84	// Player Ypos
	clc
	adc.w wide_sword_ypos,y
	sta.b $84,x	// Hitbox Ypos
	sta.b $01

	lda.w wide_sword_sprite,y	// Vertical (0), horizontal (1), diagonal (2)
	sta.b $0C

	lda.w wide_sword_face,y		// Hitbox direction
	sta.b $98,x

	lda.w wide_sword_flip,y		// VH-flip (80, 40)
	clc
	adc.w $0657			// Sword type (1-3)
	sec
	sbc.b #$01			// Palette (0-2)
	jsr $7988

	lda.w wide_sword_flip_h16,y	// Wide H-flip
	sta.b $0F


// ##################################################

wide_sword_exit:
	lda.b #$05
	jmp $FFAC


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// 8 frames

wide_sword_xpos:
	db $0A,$0A,$07,$06,$04,$02,$00,$FF	// Up
	db $F7,$F7,$FB,$FD,$FE,$FF,$00,$01	// Down
	db $01,$FF,$FB,$FA,$F9,$F8,$F6,$F5	// Left
	db $01,$03,$05,$06,$07,$08,$0A,$0B	// Right


wide_sword_ypos:
	db $02,$00,$FB,$FA,$F9,$F8,$F7,$F6	// Up
	db $03,$05,$09,$0A,$0B,$0C,$0D,$0D	// Down
	db $F6,$F6,$F7,$F8,$FA,$FC,$02,$03	// Left
	db $F6,$F6,$F8,$F9,$FB,$FD,$02,$03	// Right

//   8
// 2   1
//   4

wide_sword_face:
	db $01,$01,$08,$08,$08,$08,$08,$08	// Up
	db $02,$02,$04,$04,$04,$04,$04,$04	// Down
	db $08,$08,$02,$02,$02,$02,$02,$02	// Left
	db $08,$08,$01,$01,$01,$01,$01,$01	// Right


wide_sword_sprite:
	db $01,$01,$02,$02,$02,$02,$00,$00	// Up
	db $01,$01,$02,$02,$02,$02,$00,$00	// Down
	db $00,$00,$02,$02,$02,$02,$01,$01	// Left
	db $00,$00,$02,$02,$02,$02,$01,$01	// Right

// 40 = horizontal, 80 = vertical
//
// Vertical down sword is h-flipped to center the blade correctly (+1 right)
// -  See Displaced Gamers hitbox detection

wide_sword_flip:
	db $00,$00,$40,$40,$40,$40,$00,$00	// Up
	db $00,$00,$80,$80,$80,$80,$C0,$C0	// Down
	db $00,$00,$00,$00,$00,$00,$00,$00	// Left
	db $00,$00,$40,$40,$40,$40,$00,$00	// Right


wide_sword_flip_h16:
	db $00,$00,$00,$01,$01,$00,$00,$00	// Up
	db $01,$01,$01,$00,$00,$00,$00,$00	// Down
	db $00,$00,$00,$00,$00,$01,$01,$01	// Left
	db $00,$00,$00,$01,$01,$00,$00,$00	// Right

//warnpc $BEF0	// 0x1BF00

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Sprite table lookup
//

bank 1; org $B14C	// 0x715C, base $78DC
	db $20,$82,$48	// V,H,D sword tiles


