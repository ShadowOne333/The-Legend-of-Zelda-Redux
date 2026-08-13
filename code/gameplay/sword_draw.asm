;
; Source:
;	minucce
;
;
; License:
;	Code should be used only for educational, documentation and modding purposes.
;	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Fix sword beam position inside Dungeons
incsrc "code/optional/dungeon_draw_beam.asm"

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Draw sword or rod
%org($F7AB,7)		; 0x1F7BB
	lda #$06	; Bank switch
	jsr $FFAC

	jsr sword_detect

	lda $84,x	; Normal swing (00)
	bne $44		; $44 , $F7FB-$F7B7

assert pc() <= $F7B7+1	; 0x1F7C7

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Diagonal sword swing
%org($BD00,6)		; 0x1BD10
sword_detect:
	lda $98	; Player direction
	sta $98,x	; Object direction

	jsr $7013	; Direction index
	sty $01

	tya
	clc
	adc $00
	tay

; =============================================

	sty $0C

	lda $AC,x	; State 2 = Attack position
	cmp #$02
	bne normal_weapon

	cpx #$0D	; Sword only
	beq wide_sword

normal_weapon:
	ldy $0C

	lda #$00	; Regular attack
	sta $84,x

	jmp wide_sword_exit


; ##################################################

wide_sword:
	ldy $0C

	lda $01	; 8 frames per direction
	asl
	asl
	asl
	sta $01

	lda $03D0,x	; Frame #(8,7,6, .. ,1)
	sec
	sbc #$01
	eor #$07
	clc
	adc $01
	tay


; ====================================================

	lda $70			; Player Xpos
	clc
	adc wide_sword_xpos,y
	sta $70,x			; Hitbox Xpos
	sta $00

	lda $84			; Player Ypos
	clc
	adc wide_sword_ypos,y
	sta $84,x			; Hitbox Ypos
	sta $01

	lda $10			; Dungeon = -2 pixels
	beq .load_attr
	dec $01
	dec $01

.load_attr:
	lda wide_sword_sprite,y	; Vertical (0), horizontal (1), diagonal (2)
	sta $0C

	lda wide_sword_face,y		; Hitbox direction
	sta $98,x

	lda wide_sword_flip,y		; VH-flip (80, 40)
	clc
	adc $0657			; Sword type (1-3)
	sec
	sbc #$01			; Palette (0-2)
	jsr $7988

	lda wide_sword_flip_h16,y	; Wide H-flip
	sta $0F


; ##################################################

wide_sword_exit:
	lda #$05
	jmp $FFAC


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; 8 frames
wide_sword_xpos:
	db $0A,$0A,$07,$06,$04,$02,$00,$FF	; Up
	db $F7,$F7,$FB,$FD,$FE,$FF,$00,$01	; Down
	db $01,$FF,$FB,$FA,$F9,$F8,$F6,$F5	; Left
	db $01,$03,$05,$06,$07,$08,$0A,$0B	; Right


wide_sword_ypos:
	db $02,$00,$FB,$FA,$F9,$F8,$F7,$F6	; Up
	db $03,$05,$09,$0A,$0B,$0C,$0D,$0D	; Down
	db $F6,$F6,$F7,$F8,$FA,$FC,$02,$03	; Left
	db $F6,$F6,$F8,$F9,$FB,$FD,$02,$03	; Right

;   8
; 2   1
;   4

wide_sword_face:
	db $01,$01,$08,$08,$08,$08,$08,$08	; Up
	db $02,$02,$04,$04,$04,$04,$04,$04	; Down
	db $08,$08,$02,$02,$02,$02,$02,$02	; Left
	db $08,$08,$01,$01,$01,$01,$01,$01	; Right


wide_sword_sprite:
	db $01,$01,$02,$02,$02,$02,$00,$00	; Up
	db $01,$01,$02,$02,$02,$02,$00,$00	; Down
	db $00,$00,$02,$02,$02,$02,$01,$01	; Left
	db $00,$00,$02,$02,$02,$02,$01,$01	; Right

; 40 = horizontal, 80 = vertical
;
; Vertical down sword is h-flipped to center the blade correctly (+1 right)
; -  See Displaced Gamers hitbox detection

wide_sword_flip:
	db $00,$00,$40,$40,$40,$40,$00,$00	; Up
	db $00,$00,$80,$80,$80,$80,$C0,$C0	; Down
	db $00,$00,$00,$00,$00,$00,$00,$00	; Left
	db $00,$00,$40,$40,$40,$40,$00,$00	; Right


wide_sword_flip_h16:
	db $00,$00,$00,$01,$01,$00,$00,$00	; Up
	db $01,$01,$01,$00,$00,$00,$00,$00	; Down
	db $00,$00,$00,$00,$00,$01,$01,$01	; Left
	db $00,$00,$00,$01,$01,$00,$00,$00	; Right

assert pc() <= $BE35+1	; Originally warnpc $BEF0, 0x1BF00

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Sprite table lookup
%org($B14C,1)		; 0x715C, base $78DC
	db $20,$82,$48	; V,H,D sword tiles

