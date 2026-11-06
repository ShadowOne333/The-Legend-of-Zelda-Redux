; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;	Candle Flame Damage Boost Fix
;		by moogie-digm
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
!BeginShove		= $7626+$800	; $7E26
!PreventSidewaysPush	= $6BFE		; $19380-12782

; Prevent the sideways 'illegal' flame hit exploit movement.
%org($F8FF,7)		; 0x1F90F
	jsr !BeginShove	; -- bank 5 probably
	jsr !PreventSidewaysPush
	nop 

%org($9380,6)		; 0x19390
PreventSidewaysPush:	; This specific address gets copied into SRAM at $6BFE
	lda $64		; Get used_ladder object index
	beq .done	; If used_ladder == 0, skip the rest

	tay		; Transfer index to Y for indexing RAM
	lda $AC,y	; Check on_ladder (ram[0xac + used_ladder])
	cmp.b #$02	; Is it equal to 2?
	bne .done	; If not, skip

	lda $98,y	; Check ladder_dir (ram[0x98 + used_ladder])
	and.b #$0C	; Mask bits 2 & 3
	sta.b $00	; Temp store ladder_dir truthy value in ZP ($00)

	lda $C0		; Check knockback_dir (ram[0xc0])
	and.b #$0C	; Mask bits 2 & 3
	cmp.b $00	; Compare ladder_dir and knockback_dir flags
	beq .done	; If they match (both 0 or both non-zero), skip

	lda #$00	; Otherwise, directions are orthogonal
	sta $D3		; Clear shove (ram[0xd3] = 0)

.done:	; Copy back our hijacked opcodes
	lda #$00
	sta $0d
	rts
