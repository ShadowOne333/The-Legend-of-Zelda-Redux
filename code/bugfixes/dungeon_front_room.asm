;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Reset dungeon room door flags

%org($B4A5,5)		; 0x174B5
	jsr dungeon_front_room_reset

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Clear save ram  (optimized)
%org($B4AC,5)		; 0x174BC
	lda $6001	; RAM start init
	cmp #$5A
	bne +

	lda $7FFF	; RAM end init
	cmp #$A5
	beq clear


; =====================================================

+	lda #$FF	; Reset save slots
	sta $652A
	sta $652B
	sta $652C

	lda #$65	; Wipe 6530-7fff
	sta $01
	lda #$30
	sta $00

	ldy #$00

-	tya		; Wipe sram
	sta ($00), y

	inc $00	; Bump ptr
	bne -
	inc $01
	bpl -

	sec
	rts

; =====================================================

clear:
	clc
	rts

; #####################################################

dungeon_front_room_reset:
	sta $0526	; Old code

	lda #$00	; Reset dungeon room flags
	sta $EE

	rts

