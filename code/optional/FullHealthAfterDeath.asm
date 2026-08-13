;***********************************************************
;	Refill all heart containers after a Game Over
;***********************************************************

%org($85D0,5)		; 0x145E0
	lda $066F	; Load heart container value
	and #$F0	; Mask higher byte, Originally AND #$0F
	sta $066F	; Store masked value for heart container
	lsr		; Do 4 bit shifts right
	lsr
	lsr
	lsr
	ora $066F
	sta $066F
	rts

	nop
