//
// Source:
//	minucce
//
// Reworked:
//	tacoschip
//
// License:
//	Code should be used only for educational, documentation and modding purposes.
//	Please keep derivative work open source.

// Implement the sword and beam Y position inside Dungeons by tacoschip
incsrc code/optional/dungeon_draw_beam.asm
incsrc code/optional/dungeon_draw_weapon.asm

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Draw sword or rod
//

bank 7; org $F7AB	// 0x1F7BB
wide_sword_draw:
	lda.b #$06		// Bank switch
	jsr $FFAC

	jsr .start

	lda.b $84,x		// Normal swing (00)
	bne .resume

//warnpc $F7B7+1


org $F7FB
.resume:


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


//
// Diagonal sword swing
//

bank 6; org $BD00	// 0x1BD10
.start:
	lda.b $98			// Player direction  (1,2,4,8)
	sta.b $98,x			// Object direction

	jsr $7013			// Direction index (0,1,2,3)

// =============================================

	lda.b $AC,x			// State 2 = Attack position
	cmp.b #$02
	bne .normal

	cpx.b #$0D			// Sword only
	beq .sword

.normal:
	tya
	clc
	adc.b $00			// table addr
	tay

	lda.b #$00			// exit flag = normal attack
	sta.b $84,x

	jmp .exit

// ##################################################

.sword:
	lda.w $03D0,x		// Frame #  [8,7,6, .. ,1]
	cmp.b #$08			// frame 8 only
	bne .frame

	lda.w .face,y		// Hitbox direction
	sta.b $98,x

.frame:
	tya					// 8 frames per direction  [0-3]
	asl
	asl
	asl

	// clc
	adc.w $03D0,x		// Frame #  [8,7,6, .. ,1]
	// clc
	adc.b #$ff
	tay

// ====================================================

.hitbox:
	lda.b $70			// Player Xpos
	clc
	adc.w .xadd,y
	sta.b $70,x			// Hitbox Xpos
	sta.b $00

	lda.b $84			// Player Ypos
	clc
	adc.w .yadd,y
	sta.b $84,x			// Hitbox Ypos
	sta.b $01

	lda.b $10			// Dungeon = -2 pixels
	beq .load_attr
	dec.b $01
	dec.b $01

.load_attr:
	lda.w .attr,y		// vh-flip (80, 40)
	and.b #$c0
	ora.w $0657			// sword type (1-3)
	clc
	adc.b #$ff			// palette (0-2)
	jsr $7988

	lda.w .attr,y		// vertical (0), horizontal (1), diagonal (2)
	and.b #$06
	lsr
	sta.b $0C

	lda.w .attr,y		// h16 flip
	and.b #$01
	sta.b $0F

// ##################################################

.exit:
	lda.b #$05			// bank swap
	jmp $FFAC

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// last [1] - first [8]

.xadd:
	db $F8,$FA,$FE,$FE,$00,$03,$05,$08	// Up
	db $08,$06,$01,$01,$FF,$FD,$FB,$F8	// Down
	db $FB,$F9,$F6,$F6,$F7,$F9,$FB,$FF	// Left
	db $05,$07,$0A,$0A,$09,$06,$04,$01	// Right

.yadd:
	db $F9,$F7,$F6,$F6,$F7,$F9,$FB,$01	// Up
	db $0A,$0C,$0D,$0D,$0C,$0A,$09,$02	// Down
	db $0C,$09,$03,$03,$00,$FA,$F8,$F7	// Left
	db $FA,$FD,$03,$03,$05,$0A,$0C,$0E	// Right

.face:
	db $01		// Up => Right
	db $02		// Down => Left
	db $08		// Left => Up
	db $04		// Right => Down


// 40 = horizontal flip, 80 = vertical flip
// 02 = horizontal sprite, 04 = diagonal sprite
// 01 = horizontal-16 flip
//
// Vertical down sword is h-flipped to center the blade correctly (+1 right)
// -  See Displaced Gamers hitbox detection

.attr:
	db $04,$04,$40,$40,$40,$44,$44,$02	// Up
	db $C4,$C4,$C0,$C0,$C0,$84,$84,$03	// Down
	db $84,$84,$03,$03,$03,$04,$04,$00	// Left
	db $44,$44,$02,$02,$02,$C4,$C4,$80	// Right

//warnpc $BE00+1	// 0x1BE10

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Sprite table lookup
//

bank 1; org $B14C	// 0x715C, base $78DC
	db $20,$82,$48	// V,H,D sword tiles

