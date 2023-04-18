// Move Link's weapon sprite in dungeon mode

bank 7; org $F397

dungeon_draw_beam:
	lda.b #$06	// Bank switch
	jsr $FFAC
	jsr .start

	nop
	nop
	nop

warnpc $F3A2+1


bank 6; org $BE40	// Originally $BE00, moved 30 bytes lower to coexist with original Sword Draw
.start:
	lda.b $98,x	// if horizontal direction, +3 y-pixels
	and.b #$03
	beq .addy

	lda.b #$03

.addy:
	clc
	adc.b $01
	sta.b $01

	lda.b $10	// Dungeon = -2 y-pixels
	beq .exit
	dec.b $01
	dec.b $01

.exit:
	lda.b #$05
	jmp $FFAC
