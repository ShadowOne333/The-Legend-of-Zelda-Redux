;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%org($AAB4,5)		; 0x16AC4
	jsr hud_loading_blink
	nop

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Turn on BG display during VBlank; Disable after HUD scanline
%org($AF40,5)		; 0x16F50+$2C
hud_loading_blink:
	inc $06

	lda $06
	cmp #$10	; Done loading
	beq .exit
	and #$03	; Redraw every 4 frames
	bne .exit


	lda $12		; Verify overworld transition
	cmp #$0A
	beq +
	cmp #$0B
	bne .exit
+
-
	bit $2002	; Wait vblank
	bpl -

	lda #$00	; Refresh OAM
	sta $2003

	lda #$02
	sta $4014

-
	bit $2002	; Wait pre-render
	bvs -

	lda #$1E	; Enable drawing
	sta $2001

	jsr $8521	; Draw HUD

.exit:
	lda $06
	rts

assert pc() <= $AF80	; 0x16F90, Originally warnpc $AF80
