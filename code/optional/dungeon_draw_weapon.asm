;-------------------------------------
; Move Link's weapon sprite in dungeon mode
;-------------------------------------
%org($F7C1,7)		; 0x1F7D1
dungeon_draw_weapon:
	lda $84
	clc
	adc $F759,y
	sta $84,x
	sta $01

	lda $10		; Dungeon = -2 pixels
	beq .exit
	dec $01
	dec $01

.exit:
	lda $98,x		; Object direction
	nop
	nop

assert pc() <= $F7D7+1	 ; 0x1F7E7
