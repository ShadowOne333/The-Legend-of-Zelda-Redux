;
; Source:
;	minucce
;
;
; License:
;	Code should be used only for educational, documentation and modding purposes.
;	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Warning:
; -  Requires game power off / on to load new code into sram
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Detect hitbox orientation
%org($B641,1)		; 0x7651, base $7DD1
	ldy $00	; Get weapon direction
	lda $0098,y

	and #$0C
	beq weapon_horizontal_facing

weapon_vertical_facing:
	lda #$08	; Y-delta
	pha

	lda #$06	; X-delta
	bne weapon_position

weapon_horizontal_facing:
	lda #$09	; #$06+3, Credit: Displaced Gamers
	pha

	lda #$08

weapon_position:
	clc		; Weapon Xpos
	adc $0070,y
	sta $04

	pla		; Weapon Ypos
	clc
	adc $0084,y
	jmp $7BE2

assert pc() <= $B66B-7+1	; warnpc base $7DFB-7

; 7 free variables !!
	nop
	nop
	nop
	nop
	nop
	nop
	nop

assert pc() <= $B66B+1	; warnpc base $7DFB


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Detect hitbox orientation
%org($B5AC,1)		; 0x75BC, base $7D3C
	sta $07	; Weapon damage

	ldy $00	; Get weapon orientation
	lda $0098,y
	and #$0C
	beq weapon_horizontal_hitbox

weapon_vertical_hitbox:
	lda #$0C
	ldy #$10
	bne weapon_collide_check

weapon_horizontal_hitbox:
	lda #$10
	ldy #$0C

weapon_collide_check:
	sta $0D
	sty $0E

	jsr $7DD1	; Collision

	lda $06	; Fail (rts)
	db $F0,$C9	; beq $C9 -> $7595, $7D25-($7D5F-3)

	jmp $7DAA	; Damage routine

assert pc() <= $B5CF+1	; warnpc $7D5F

