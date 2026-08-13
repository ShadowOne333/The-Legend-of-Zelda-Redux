;***********************************************************
;   Select button toggles between selected B button items
;***********************************************************

; Max value is $08. After 08 it jumps to the Raft and other Key items.
; Routine begins at $EC1B (0x1EC2B), ends at $EC79 (0x1EC89)
; Pause check begins at 1EC46, compares if Select has been pressed and then does LDA $00E0, EOR #$01 and STA $00E0 to #$01 (RAM $00E0), which tells the game it is Paused. Bypassing the Pause can be done by NOP'ing the LDA/EOR/STA starting at 0x1EC4C ($EC3C).

%org($EC3C,7)		; 0x1EC4C
; Hijack PAD_SELECT pressed on the overworld
	jsr quick_select
	nop #10

; This is the routine called to switch items as a database
; Moved to Bank 2 for compatibility with the MMC1 animation code by Bogaa
%org($B7A8,2)		; 0x0B7B8
	ldx #$01
	stx $0602
	tax
	lda $0656
	pha
	txa
	jsr $B7C8
	pla
	cmp $0656
	beq l_1C
	ldy $0656
	lda $0657,y
	bne l_1F
l_1C:
	lsr $0602
l_1F:
	rts

	sta $EF
	ldx #$09
l_24:
	jsr $B821
	cpy #$00
	beq l_4A
	cpy #$03
	beq l_38
	lda $0657,y
	bne l_3D
	cpy #$07
	beq l_60
l_38:
	dex
	bpl l_24
	ldy #$00
l_3D:
	cpy #$02
	bne l_46
	lda $065A
	beq l_24
l_46:
	sty $0656
	rts
l_4A:
	ldy #$1E
l_4C:
	lda $0657,y
	bne l_5B
	dey
	cpy #$1C
	bne l_4C
	ldy #$00
	jmp $B7E0
l_5B:
	ldy #$00
	jmp $B7E5
l_60:
	ldy #$0F
	lda $0657,y
	bne l_6B
	ldy #$07
	bne l_38
l_6B:
	lda $065E
	beq l_46
	ldy #$07
	bne l_46
	txa
	tay
	jmp $E735
	lda $EF
	and #$03
	beq l_91
	iny
	lsr
	bcs l_85
	dey
	dey
l_85:
	cpy #$FF
	bne l_8B
	ldy #$08
l_8B:
	cpy #$09
	bne l_91
	ldy #$00
l_91:
	rts

; Actual Quick Select code
quick_select:
; New method by gzip
	lda #$01	; PAD_RIGHT
	ldy $0656	; Load current item
	jsr $B7A8	; Get next item $B7C8 (use 'jsr $B7A8' to also play SFX)
; Old Letter overflow fix by gzip
	ldy $0656	; Load current item position into Y
	cpy #$10	; Compare if value is $10 (out of range)
	bpl out_range	; BPL $03 - Branch if greater than or equal to $10 (out of range
	jmp l_BFDE	; Otherwise, skip to return
out_range:	; $BFD2, 0x17FE2
	lda #$08	; Load rod value into A
	sta $0656	; Set current item to rod
	ldy $065F	; Load rod status into Y
	cpy #$01	; Check if rod is present (1)
	bne l_BFDF	; BNE $01, Branch back to beginning if there's no rod (0)
l_BFDE:
	rts		; Otherwise, return
l_BFDF:
	jmp quick_select	; Jump back to beginning so the correct item is set


