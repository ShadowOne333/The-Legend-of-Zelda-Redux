;***********************************************************
;	Refill all heart containers when loading a game
;***********************************************************

%org($A635,2)		; 0x0A645
	jmp RefillHealth

%org($A830,2)		; 0x0A840
RefillHealth:
	lda $066F	; Make health container equal to current health
	and #$F0
	sta $066F
	lsr
	lsr
	lsr
	lsr
	adc $066F
	sta $066F

	jmp $EBA1
