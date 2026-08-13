;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Reset timer for cave start
%org($86A3,1)		; 0x046B3
	sta $70,x	; x,y
	sty $84,x

	lda #$00	; HP
	sta $0485,x

	sta $29	; Cloud timer

	lda #$81	; Attr
	sta $04BF,x

	lda #$40	; Freeze player
	sta $AC

	sta $0351	; Bonfire 1,2
	sta $0352

	lda #$48	; x1
	sta $71,x

	lda #$A8	; x2
	sta $72,x

	sty $85,x	; y1, y2
	sty $86,x

	rts

