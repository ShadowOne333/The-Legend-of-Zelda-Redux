//
// Source:
//	minucce
//
//
// License:
//	Code should be used only for educational, documentation and modding purposes.
//	Please keep derivative work open source.


//
// Warning:
// -  Requires game power off / on to load new code into sram
//



//
// Detect hitbox orientation
//

bank 1; org $B641	// 0x7651, base $7DD1
	ldy.b $00	// Get weapon direction
	lda.w $0098,y

	and.b #$0C
	beq weapon_horizontal_facing

weapon_vertical_facing:
	lda.b #$08	// Y-delta
	pha

	lda.b #$06	// X-delta
	bne weapon_position

weapon_horizontal_facing:
	lda.b #$09	// #$06+3, Credit: Displaced Gamers
	pha

	lda.b #$08

weapon_position:
	clc		// Weapon Xpos
	adc.w $0070,y
	sta.b $04

	pla		// Weapon Ypos
	clc
	adc.w $0084,y
	jmp $7BE2

//warnpc $7DFB-7

// 7 free variables !!
	nop
	nop
	nop
	nop
	nop
	nop
	nop

//warnpc $7DFB


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Detect hitbox orientation
//

bank 1; org $B5AC	// 0x75BC, base $7D3C
	sta.b $07	// Weapon damage

	ldy.b $00	// Get weapon orientation
	lda.w $0098,y
	and.b #$0C
	beq weapon_horizontal_hitbox

weapon_vertical_hitbox:
	lda.b #$0C
	ldy.b #$10
	bne weapon_collide_check

weapon_horizontal_hitbox:
	lda.b #$10
	ldy.b #$0C

weapon_collide_check:
	sta.b $0D
	sty.b $0E

	jsr $7DD1	// Collision

	lda.b $06	// Fail (rts)
	db $F0,$C9	// beq $C9 -> $7595, $7D25-($7D5F-3)

	jmp $7DAA	// Damage routine

//warnpc $7D5F

