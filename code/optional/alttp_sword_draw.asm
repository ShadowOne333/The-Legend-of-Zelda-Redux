;
; Source:
;	minucce
;
; Reworked:
;	tacoschip
;
; License:
;	Code should be used only for educational, documentation and modding purposes.
;	Please keep derivative work open source.

; Implement the sword and beam Y position inside Dungeons by tacoschip
; These are already included in 'sword_draw.asm', no need to re-include them here.
;incsrc "code/optional/dungeon_draw_beam.asm"
incsrc "code/optional/dungeon_draw_weapon.asm"

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Draw sword or rod
%org($F7AB,7)		; 0x1F7BB
wide_sword_draw:
	lda #$06		; Bank switch
	jsr $FFAC

	jsr .start

	lda $84,x		; Normal swing (00)
	bne .resume

assert pc() <= $F7B7+1	; 0x1F7C7


%org($F7FB,7)		; 0x1F80B
.resume:


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Diagonal sword swing
%org($BD00,6)		; 0x1BD10
.start:
	lda $98		; Player direction  (1,2,4,8)
	sta $98,x	; Object direction

	jsr $7013	; Direction index (0,1,2,3)

; =============================================

	lda $AC,x	; State 2 = Attack position
	cmp #$02
	bne .normal

	cpx #$0D	; Sword only
	beq .sword

.normal:
	tya
	clc
	adc $00		; Table addr
	tay

	lda #$00	; Exit flag = normal attack
	sta $84,x

	jmp .exit

; ##################################################

.sword:
	lda $03D0,x		; Frame #  [8,7,6, .. ,1]
	cmp #$08			; frame 8 only
	bne .frame

	lda .face,y		; Hitbox direction
	sta $98,x

.frame:
	tya					; 8 frames per direction  [0-3]
	asl
	asl
	asl

	; clc
	adc $03D0,x		; Frame #  [8,7,6, .. ,1]
	; clc
	adc #$ff
	tay

; ====================================================

.hitbox:
	lda $70			; Player Xpos
	clc
	adc .xadd,y
	sta $70,x			; Hitbox Xpos
	sta $00

	lda $84			; Player Ypos
	clc
	adc .yadd,y
	sta $84,x			; Hitbox Ypos
	sta $01

	lda $10			; Dungeon = -2 pixels
	beq .load_attr
	dec $01
	dec $01

.load_attr:
	lda .attr,y		; vh-flip (80, 40)
	and #$c0
	ora $0657			; sword type (1-3)
	clc
	adc #$ff			; palette (0-2)
	jsr $7988

	lda .attr,y		; vertical (0), horizontal (1), diagonal (2)
	and #$06
	lsr
	sta $0C

	lda .attr,y		; h16 flip
	and #$01
	sta $0F

; ##################################################

.exit:
	lda #$05			; bank swap
	jmp $FFAC

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; last [1] - first [8]

.xadd:
	db $F8,$FA,$FE,$FE,$00,$03,$05,$08	; Up
	db $08,$06,$01,$01,$FF,$FD,$FB,$F8	; Down
	db $FB,$F9,$F6,$F6,$F7,$F9,$FB,$FF	; Left
	db $05,$07,$0A,$0A,$09,$06,$04,$01	; Right

.yadd:
	db $F9,$F7,$F6,$F6,$F7,$F9,$FB,$01	; Up
	db $0A,$0C,$0D,$0D,$0C,$0A,$09,$02	; Down
	db $0C,$09,$03,$03,$00,$FA,$F8,$F7	; Left
	db $FA,$FD,$03,$03,$05,$0A,$0C,$0E	; Right

.face:
	db $01		; Up => Right
	db $02		; Down => Left
	db $08		; Left => Up
	db $04		; Right => Down


; 40 = horizontal flip, 80 = vertical flip
; 02 = horizontal sprite, 04 = diagonal sprite
; 01 = horizontal-16 flip
;
; Vertical down sword is h-flipped to center the blade correctly (+1 right)
; -  See Displaced Gamers hitbox detection

.attr:
	db $04,$04,$40,$40,$40,$44,$44,$02	; Up
	db $C4,$C4,$C0,$C0,$C0,$84,$84,$03	; Down
	db $84,$84,$03,$03,$03,$04,$04,$00	; Left
	db $44,$44,$02,$02,$02,$C4,$C4,$80	; Right

assert pc() <= $BE00+1	; 0x1BE10

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Sprite table lookup
%org($B14C,1)		; 0x0715C, base $78DC
	db $20,$82,$48	; V,H,D sword tiles

