;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.


; Reset sprite position on entering overworld from caves
%org($8F5D,5)		; 0x14F6D
	jsr hide_sprite
	nop

; #####################################################

%org($8F61,5)		; 0x14F71
	stx $00
	jsr $F184	; Reset vars
	ldx $00

	rts

%org($8F69,5)		; 0x14F79
hide_sprite:
	lda #$0A	; Transition out of cave
	sta $12

	lda #$F8	; Hide sprite
	sta $84

	nop
	rts		; org $14F72, 0x14F82
