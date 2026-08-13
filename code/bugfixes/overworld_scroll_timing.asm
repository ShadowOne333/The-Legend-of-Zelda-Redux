;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%org($854E,5)		; 0x1455E
; Reset Y-scroll value with more precision
	ldy #$5E+2

-	nop		; Manual timing
	dey
	bpl -

	nop #6

	lda $2002	; Reset latch

	lda $58		; Render-Y2
	ldy $E2		; Render-Y1

	; Credit to Quietust (nesdev) for explaining PPU Addr register scrolling

	sta $2006
	lda #$00

	sty $2006	; Render location  (must be h-blank)
	sta $2005	; Fine X-pos
	rts
