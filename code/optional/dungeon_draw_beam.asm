;-------------------------------------
; Move Link's weapon sprite in dungeon mode
;-------------------------------------
%org($F397,7)		; 0x1F3A7
dungeon_draw_beam:
	lda #$06	; Bank switch
	jsr $FFAC
	jsr .start

	nop #3

assert pc() <= $F3A2+1

;-------------------------------------
%org($BE40,6)		; Originally $BE00, moved 30 bytes lower to coexist with original Sword Draw
.start:
	lda $98,x	; if horizontal direction, +3 y-pixels
	and #$03
	beq .addy

	lda #$03

.addy:
	clc
	adc $01
	sta $01

	lda $10	; Dungeon = -2 y-pixels
	beq .beam_exit
	dec $01
	dec $01

.beam_exit:
	lda #$05
	jmp $FFAC
