;-------------------------------------
; Code optimization from the original game
;-------------------------------------

%org($8521,5)		; 0x14531
WaitAndScrollToSplitBottom:
	bit $2002
	bvc WaitAndScrollToSplitBottom

	ldx #$CD
-	dex
	bne -

	lda $12
	cmp #$08
	bcs misc

	lda $13
	beq exit

	lda $98
	cmp #$04
	bcc h_scroll
	
v_scroll:
	ldy #$8D	; wait until line 63

v_wait:
	dey
	bne v_wait

	lda $58		; VScrollAddrHi
	ldy $E2		; VScrollAddrLo
	ldx #$00
	sta $2006
	sty $2006	; hblank warning
	stx $2005

exit:
	rts

h_scroll:
	ldy #$5E	; wait until line 63

h_wait:
	dey
	bpl h_wait

	ldx $FD		; CurHScroll
	ldy #$00
	stx $2005	; before dot 257 hblank
	sty $2005

	lda $FF
	and #$FE
	ora $5F		; OddBaseNameTableOverride
	sta $FF

	sta $2000	; hblank window
	rts

misc:
	cmp #$11
	bcs nametable
	jmp $E625	; screen off

nametable:
	lda $FF
	ora #$01
	sta $FF
	sta $2000
	rts

	%fillto($85A0,5,$FF)	; Fill up to 0x1457D
