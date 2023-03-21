// Move Link's weapon sprite in dungeon mode

bank 7; org $f7c1

dungeon_draw_weapon:
	lda.b $84
	clc
	adc.w $f759,y
	sta.b $84,x
	sta.b $01

	lda.b $10		// dungeon = -2 pixels
	beq .exit
	dec.b $01
	dec.b $01

.exit:
	lda.b $98,x		// object direction
	nop
	nop

//warnpc $f7d7+1
