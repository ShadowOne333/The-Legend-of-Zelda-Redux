;***********************************************************
;	Increase text printing speed
;***********************************************************

; Increase text print speed
%org($881C,1)		; 0x0482C
	lda #$04	; Originally LDA $06

; Skip SFX sound for spaces in text
;%org($884C,1)		; 0x0485C
;	cmp #$25	; Originally CMP #$25
