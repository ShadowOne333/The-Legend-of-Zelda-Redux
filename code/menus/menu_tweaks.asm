;***********************************************************
;		File Select Menu Tweaks by Minucce
;  Code should be used only for educational, documentation and modding purposes
;***********************************************************

;***********************************************************
;	Table file
;***********************************************************

incsrc "code/text/text.tbl"

; *********************************************************
;  Original code by SpiderDave

%org($A4A6,2)		; 0x0A4B6
	jsr main_menu_palette
	nop

; ---------------------------------------------------------

%org($A573,2)		; 0x0A583
main_menu_init_done:
; We will default the position to always be Slot 1 instead
; Previously checked against RAM $54 to know slot position
	;lda $54
	;cmp #$03
	;bcc rite

	lda #$00	; Default save slot 0
rite:
	sta $16

; ---------------------------------------------------------

	lda #$00	; Main menu - Submode 0
	sta $13

	lda #$FF	; Cave ID
	sta $0526

	inc $11
	rts

assert pc() <= $A589	; 0x0A599

; #########################################################

%org($A596,2)		; 0x0A5A6
	dw main_menu_run
	dw main_menu_exit

; ---------------------------------------------------------

main_menu_run:
	ldy $16		; Current slot
	ldx $F8		; Joypad 1


; -------------------------------------------------------

.select_option:
	txa
	and #$10
	beq .cursor_up

	lda $0633,y		; Slot enabled
	bne .valid_slot

	lda #$03		; Register mode
	sta $16

.valid_slot:
	sty $54		; Selected mode  (reset on game start)

	inc $13		; Stop menu
	rts


; -------------------------------------------------------

.cursor_up:
	txa
	and #$08
	beq .cursor_down

	dey			; Wrap index  (0-4)
	bpl .move_cursor


	ldy #$04
	bne .move_cursor

; -------------------------------------------------------

.cursor_down:
	txa
	and #($04|$20)
	beq .draw_cursor

	iny			; Wrap index  (0-4)
	cpy #$05
	bne .move_cursor

	ldy #$00

; -------------------------------------------------------

.move_cursor:
	sty $16

	lda #$01		; Play sound
	sta $0602

; ====================================================

.draw_cursor:
	ldx #$02		; Copy OAM data


.loop:
	lda $A589,x
	sta $0201,x
	dex
	bpl .loop

	lda $A58C,y		; Y-pos
	sta $0200

	lda #$58		; Link sprites Y,X
	sta $01

	lda #$30
	sta $00

	jmp $A638		; Draw

; ####################################################

main_menu_exit_check:
	lda $16		; Game slot
	cmp #$03
	bcc .load_game


	; sec			; Run other menu mode
	adc #$0B-1
	sta $12

	jmp $EBA3
	nop #5

; =====================================================

.load_game:

assert pc() <= $A6FE	; 0x0A70E

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

%org($A58C,2)		; 0x0A59C
	db $5C,$74,$8C		; Main menu - Cursor Y-pos
	db $A8-1,$B8-1

%org($9DAF,2)		; 0x09DBF
	db $2F+4,$47+4,$5F+4	; Register mode - Cursor Y-pos
	db $77

%org($9DF9,2)		; 0x09E09
	db $43+2		; Copy, Erase - Cursor X-pos

%org($A1D1,2)		; 0x0A1E1
	jsr register_mode_letter_ypos

; ###########################################################

%org($9E3F,2)		; 0x09E4F
	ldy $54		; Game mode
	jmp main_menu_mode_name
	nop #1

assert pc() <= $9E45+1	; 0x09E55

; ;;;;;;;;;;;;;;;;;;;;;;;;;;

%org($9EAA,2)		; 0x09EBA
	ldy $54		; Erase mode = Blue cursor
	cpy #$04

; ###########################################################

%org($9EB9,2)		; 0x09EC9
main_menu_active_player:
	ldx $54		; Create mode (0-2)
	cpx #$03
	bcc .store

	ldx #$FF		; Find 1st active slot

.find:
	inx
	lda $0633,x
	beq .find

.store:
	stx $16		; Save slot
	jsr $A18E


	lda #$50		; Link Y,X position
	sta $00

	lda #$30
	sta $01

	inc $11
	jmp $A638		; Write sprites

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu_misc_draw_name_map:
	lda #$00
	bcs .exit

	lda #$16		; Draw alphabet board

.exit:
	sta $14

	inc $13		; Next submode 03
	rts

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;

register_mode_letter_ypos:
	sec
	sbc #$08+4
	jmp $A1FA
	nop #0

assert pc() <= $9EEB+1	; 0x09EFB

; ###########################################################

%org($9E9D,2)		; 0x09EAD
	lda $54		; Register mode only
	cmp #$03

	jmp menu_misc_draw_name_map
	nop #0

assert pc() <= $9EA4+1	; 0x09EB4

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

%org($9EB5,2)		; 0x09EC5
	jmp misc_menu_palette
	nop #1

assert pc() <= $9EB9+1	; 0x09EC9

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

%org($9EF0,2)		; 0x09FF0
register_player_joypad_start:
	lda $F8		; Joypad 1
	and #$10
	bne .save

	jmp $9FB0		; Spin loop
	nop #6

.save:

assert pc() <= $9EFF+1	; 0x09F0F

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

%org($9FB9,2)		; 0x09FC9
	nop #3			; Register mode -- Ignore select button

; ###########################################################

%org($9FC5,2)		; 0x09FD5
erase_player_run:
	jmp erase_player_mode

	nop #22

assert pc() <= $9FDE+1	; 0x09FEE

; ###########################################################

%org($A204,2)		; 0x0A214
; Free space = Old menu input handler

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

register_menu_quit_sound:
	lda $54		; Register only
	cmp #$03
	bcs .exit1

; ---------------------------------------------------------

	ldx #$07		; Blank name

.loop1:
	lda $0640,x		; All space
	cmp #$24
	bne .exit1

	dex
	bpl .loop1

	lda #$20		; All space = Quit sound
	sta $0602



.exit1:
	lda #$00		; Silent
	sta $0607

	rts

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

register_menu_name_done:
	ldy #$00
	lda ($CC),y		; Check quest number
	bne .zelda

	lda #$08		; Play sound (Fairy)
	sta $0602
	bne .exit2

.zelda:
	lda #$0C		; Play sound (Secret)
	sta $0602

; ---------------------------------------------------------

.exit2:
	tax			; Mark save ready
	lda #$01

	rts

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

main_menu_exit:
	lda #$00
	sta $0602		; Sound off
	sta $0656		; Item index
	sta $10		; Level = Overworld

	ldx $54		; Copy player
	cpx #$03
	bne .exit3

	inx
	stx $16

.exit3:
	jmp main_menu_exit_check

	nop #7

assert pc() <= $A254+1	; 0x0A264

; ###########################################################

%org($BA00,2)		; 0x0BA10
main_menu_palette:
	ldy #$02

.loop2:
	lda $0633,y		; Non-active player
	bne .next

	tya
	asl
	asl
	tax

	lda #$19		; Faded default palette
	sta $6803+1,x

	lda #$17
	sta $6803+2,x

	lda #$07
	sta $6803+3,x

.next:
	dey
	bpl .loop2

; ---------------------------------------------------------

	lda #$12		; Transfer palette at VBlank
	sta $14

	rts

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

main_menu_mode_name:
	cpy #$03		; Register your name
	bcs .copy_player

	lda #$24		; Title edge spaces
	sta $0308
	sta $031B

	jmp $9E45

; ---------------------------------------------------------

.copy_player:
	bne .erase_player

	ldy #$13-1		; Copy new string

.loop3:
	lda .copy_save_title, y
	sta $0308, y
	dey
	bpl .loop3

.erase_player:
	jmp $9E52


; ---------------------------------------------------------

.copy_save_title:
	; Copy Save
	db $6A,$6A,$6A,$6A
	db " COPY SAVE "
	db $6A,$6A,$6A,$6A

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

misc_menu_palette:
	lda $54		; Creation mode only
	cmp #$03
	bcs .exit4

	asl
	asl
	tax

	lda #$29		; Normal palette
	sta $6803+1,x

	lda #$27
	sta $6803+2,x

	lda #$17
	sta $6803+3,x


; ---------------------------------------------------------

.exit4:
	lda #$12		; Transfer palette
	sta $14

	inc $13		; Next submode 04
	rts

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

erase_player_mode:
	lda $13
	cmp #$04
	bne .submode_05

.submode_04:
	ldx.b #(.text_end-.text)

.loop4:
	lda .text,x
	sta $0302,x

	dex
	bpl .loop4

	inc $13
	rts

; -----------------------------------------------------------

.text:
	; Box - Upper
	db $22,$46,$01,$69	; Up-Left corner
	db $22,$47,$13|$40,$6A	; Horizontal line
	db $22,$5A,$01,$6B	; Up-Right corner

	; Box - Sides
	db $22,$66,$07|$C0,$6C	; Vertical line
	db $22,$7A,$07|$C0,$6C	; Vertical line

	db $FF

.text_end:



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_05:
	cmp #$05
	bne .submode_06

	lda $54		; Copy or erase
	cmp #$03
	bne .erase_text

.copy_text:
	ldx.b #(.copy_str_end-.copy_str)

.copy_loop:
	lda .copy_str,x
	sta $0302,x

	dex
	bpl .copy_loop

	inc $13
	rts

; ---------------------------------------------------------

.erase_text:
	ldx.b #(.erase_str_end-.erase_str)

.erase_loop:
	lda .erase_str,x
	sta $0302,x

	dex
	bpl .erase_loop

	inc $13
	rts

; ---------------------------------------------------------

.erase_str:
	; Box - lower
	db $23,$46,$01,$6E
	db $23,$47,$13|$40,$6A
	db $23,$5A,$01,$6D

	; Erase which save?
	db $22,$88,$11
	db "ERASE WHICH SAVE?"

	db $FF

.erase_str_end:



.copy_str:
	; Box - lower
	db $23, $46, $01, $6e
	db $23, $47, $13|$40, $6a
	db $23, $5a, $01, $6d

	; Copy which save?
	db $22,$88,$11
	db "COPY WHICH SAVE? "

	db $FF

.copy_str_end:



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_06:
	cmp #$06
	bne .submode_07

	ldx $F8		; Joypad 1

.start_button_06:
	txa
	and #$10
	beq .down_cursor

	lda $16			; Player slot only
	cmp #$03
	bcs .quit

.copy_slot_2:
	lda $54
	cmp #$03
	bne .erase_confirm

	lda #$10
	sta $13

	jmp .submode_10

.erase_confirm:
	inc $13

	lda $13
	bne .submode_07

.quit:
	jmp .submode_quit

; ---------------------------------------------------------

.down_cursor:
	txa			; Down + Select button
	and #($20|$04)
	beq .up_cursor

	ldy $16		; Save slot

.loop5:
	iny
	cpy #$04		; Past exit
	bne .check

	ldy #$00		; Slot 1

.check:
	lda $0633,y		; Slot active
	beq .loop5

	bne .move_cursor1

; ---------------------------------------------------------

.up_cursor:
	txa
	and #$08
	beq .no_move

	ldy $16		; Save slot

.loop6:
	dey
	bpl .check1

	ldy #$03		; Exit slot

.check1:
	lda $0633,y		; Slot active
	beq .loop6

; ---------------------------------------------------------

.move_cursor1:
	sty $16

	lda $9DAF,y		; Y-pos cursor
	sta $0200

	lda #$01		; Play tune
	sta $0602

; ---------------------------------------------------------

.no_move:
	rts

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_07:
	cmp #$07
	bne .submode_08

	ldx.b #(.text1_end-.text1)

.loop7:
	lda .text1,x
	sta $0302,x

	dex
	bpl .loop7

	ldx $16		; Slot 1
	inx
	stx $0302+$10

; ---------------------------------------------------------

	lda #$20		; Play sound
	sta $0604

	lda #$00		; Cursor choice
	sta $55

	lda $16		; Color 1
	sta $0202

	lda #$AF		; Sprite cursor 2
	sta $0230

	lda #$F2+1
	sta $0231

	lda #$03
	sta $0232

	lda #$4C
	sta $0233

	inc $13
	rts

; ---------------------------------------------------------

.text1:
	; Erase player X?
	db $22,$88,$11
	db "ERASE PLAYER 0?  "

	; Okay
	db $22,$CB,$04
	db "OKAY"

	; Quit
	db $23,$0B,$04
	db "QUIT"

	db $FF

.text1_end:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_08:
	cmp #$08
	bne .submode_09

	ldx.b #(.text2_end-.text2)

.loop8:
	lda .text2,x
	sta $0302,x

	dex
	bpl .loop8

; ---------------------------------------------------------

.sprite1:
	ldx #$00
	cpx $16
	bne .sprite2

	stx $0290+2		; Gray sword

.sprite2:
	inx
	cpx $16
	bne .sprite3

	lda #$15		; Gray sprite
	sta $0302+1

	lda #$D3		; Grey text
	sta $0302+7

	lda #$0A
	sta $0302+9

	lda #$01		; Gray sword
	sta $0298+2

.sprite3:
	inx
	cpx $16
	bne .exit5

	lda #$19		; Gray sprite
	sta $0302+1

	lda #$DB		; Gray text
	sta $0302+7

	lda #$0A
	sta $0302+9

	lda #$02		; Gray sword
	sta $02A0+2

.exit5:
	inc $13
	rts

; --------------------------------------------------------

.text2:
	; Gray sprite
	db $3F,$11,$03
	db $10,$30,$00

	; Grey text
	db $23,$CB,$03|$40
	db $A0

	; Grey color
	db $3F,$09,$01
	db $00

	; Red text
	db $23,$EB,$03
	db $04,$05,$01

	db $FF

.text2_end:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_09:
	cmp #$09
	bne .submode_10

	ldx $F8		; Joypad 1
	ldy $55

.start_button_09:
	txa
	and #$10
	beq .down_cursor1
	tya			; Okay chosen (00)
	bne .exit6

	lda $16		; Delete player
	jsr $9FE8

	jmp .submode_quit

.exit6:
	lda #$20		; Play sound (Quit)
	sta $0602

	bne .submode_quit

; ---------------------------------------------------------

.down_cursor1:
	txa			; Down + Select button
	and #($20|$04)
	beq .up_cursor1

	dey
	bpl .move_cursor2

	ldy #$01
	bne .move_cursor2

; ---------------------------------------------------------

.up_cursor1:
	txa
	and #$08
	beq .no_move1

	iny
	cpy #$02
	bne .move_cursor2

	ldy #$00

; ---------------------------------------------------------

.move_cursor2:
	sty $55

	lda .cursor4_ypos,y	; Y-pos cursor
	sta $0230

	lda #$01		; Play tune
	sta $0602

; ---------------------------------------------------------

.no_move1:
	rts

.cursor4_ypos:
	db $AF,$BF

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_quit:
	lda #$15		; Red cursor
	sta $6810

	jmp $9EFF		; Reset save integrity

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_10:
	cmp #$10
	bne .submode_11

	ldx.b #(.text3_end-.text3)

.loop9:
	lda .text3,x
	sta $0302,x

	dex
	bpl .loop9

; ---------------------------------------------------------

	ldx #$00		; Cursor 2 choice
	cpx $16
	bne .cursor2

	inx
	cpx $16
	bne .cursor2

	inx

.cursor2:
	stx $54

	lda $16		; Cursor 1 color
	sta $0202

	lda .cursor2_ypos,x	; Sprite cursor 2
	sta $0234

	lda #$F2+1
	sta $0235

	lda #$03
	sta $0236

	lda #$45
	sta $0237

.slot2:
	ldx $16
	dex
	bne .slot3

	lda #$D3		; Red text
	sta $0302+21

	lda #$05
	sta $0302+23

.slot3:
	dex
	bne .exit7


	lda #$DB		; Red text
	sta $0302+21

	lda #$05
	sta $0302+23

.exit7:
	lda #$10		; Play sound (Heart)
	sta $0604

	inc $13
	rts

.cursor2_ypos:
	db $33,$4B,$63

; ---------------------------------------------------------

.text3:
	; To which slot?
	db $22,$88,$11
	db "TO WHICH SLOT?   "

	; Red text
	db $23,$CB,$03|$40
	db $50

	db $FF

.text3_end:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_11:
	cmp #$11
	bne .submode_12

	ldx $F8		; Joypad 1

.start_button_11:
	txa
	and #$10
	beq .down_cursor2

	lda $54		; Player slot only
	cmp #$03
	bcs .quit1

	inc $13

	lda $13
	bne .submode_12

.quit1:
	jmp .submode_quit

; ---------------------------------------------------------

.down_cursor2:
	txa			; Down + Select button
	and #($20|$04)
	beq .up_cursor2

	ldy $54		; Destination (dst) slot

.loop10:
	iny

	cpy #$04		; Past exit
	bne .check2

	ldy #$00		; Slot 1

.check2:
	cpy $16		; Not save 1
	beq .loop10

	bne .move_cursor3

; ---------------------------------------------------------

.up_cursor2:
	txa
	and #$08
	beq .no_move2

	ldy $54		; Destination (dst) slot

.loop11:
	dey
	bpl .check3

	ldy #$03		; Exit slot

.check3:
	cpy $16		; Not save 1
	beq .loop11

; ---------------------------------------------------------


.move_cursor3:
	sty $54

	lda $9DAF,y		; Y-pos cursor 2
	sta $0234

	lda #$01		; Play tune
	sta $0602

; ---------------------------------------------------------

.no_move2:
	rts

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_12:
	cmp #$12
	bne .submode_13

	ldx.b #(.text4_end-.text4)

.loop12:
	lda .text4,x
	sta $0302,x

	dex
	bpl .loop12

	ldx $16		; Save 1
	inx
	stx $0302+$0D

	ldx $54		; Save 2
	inx
	stx $0302+$12

; ---------------------------------------------------------

	lda #$20		; Play sound
	sta $0604

	lda #$00		; Cursor choice
	sta $55

	lda $54		; Color 2
	sta $0236

	lda #$AF		; Sprite cursor 3
	sta $0230

	lda #$F3
	sta $0231

	lda #$03
	sta $0232

	lda #$4C
	sta $0233

	inc $13
	rts

; ---------------------------------------------------------

.text4:
	; Copy from x to y?
	db $22,$88,$11
	db "COPY FROM 0 TO 0?"

	; Okay
	db $22,$CB,$04
	db "OKAY"

	; Quit
	db $23,$0B,$04
	db "QUIT"

	db $FF

.text4_end:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_13:
	cmp #$13
	bne .submode_14

	ldx.b #(.text5_end-.text5)

.loop13:
	lda .text5,x		; !!
	sta $0302,x

	dex
	bpl .loop13

; ---------------------------------------------------------

.sprite4:
	ldx #$00
	cpx $54
	bne .sprite5

	stx $0290+2		; Gray sword

.sprite5:
	inx
	cpx $54
	bne .sprite6

	lda #$15		; Gray sprite
	sta $0302+1

	lda #$D3		; Gray text
	sta $0302+7

	lda #$0A
	sta $0302+9

	lda #$01		; Gray sword
	sta $0298+2

.sprite6:
	inx
	cpx $54
	bne .exit8

	lda #$19		; Gray sprite
	sta $0302+1

	lda #$DB		; Gray text
	sta $0302+7

	lda #$0A
	sta $0302+9

	lda #$02		; Gray sword
	sta $02A0+2

.exit8:
	inc $13
	rts

; ---------------------------------------------------------

.text5:
	; Gray sprite
	db $3F,$11,$03
	db $10,$30,$00

	; Gray text
	db $23,$CB,$03|$40
	db $A0

	; Gray color
	db $3F,$09,$01
	db $00

	; Red text
	db $23,$EB,$02
	db $05,$05

	; Green text
	db $23,$ED,$01
	db $0F

	; Green color
	db $3F,$0D,$01
	db $1A

	db $ff

.text5_end:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

.submode_14:
	ldx $F8		; Joypad 1
	ldy $55

.start_button_14:
	txa
	and #$10
	beq .down_cursor3
	tya			; Okay chosen (00)
	bne .exit9

	jsr copy_player1

	lda #$08		; Play sound (Fairy)
	sta $0602

	jmp .submode_quit

.exit9:
	lda #$20		; Play sound (Quit)
	sta $0602

	jmp .submode_quit

; ----------------------------------------------------

.down_cursor3:
	txa			; Down + Select button
	and #($20|$04)
	beq .up_cursor3

	dey
	bpl .move_cursor4

	ldy #$01
	bne .move_cursor4

; ---------------------------------------------------------

.up_cursor3:
	txa
	and #$08
	beq .no_move3

	iny
	cpy #$02
	bne .move_cursor4

	ldy #$00

; ---------------------------------------------------------

.move_cursor4:
	sty $55

	lda .cursor3_ypos,y	; Y-pos cursor 3
	sta $0230

	lda #$01		; Play tune
	sta $0602

; ---------------------------------------------------------

.no_move3:
	rts

.cursor3_ypos:
	db $AF,$BF

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

copy_player1:
	lda $16		; Source (src)
	asl
	tay

	lda $54		; Destination (dst)
	asl
	tax

	; Play save = Temporary in-game save data

	lda $6524,y		; Transfer checksum to play save
	sta $6D9C,x

	lda $6525,y
	sta $6D9D,x

; ---------------------------------------------------------

.autosave:
	lda $16		; Source (src)
	asl
	asl
	asl
	asl
	tax

	lda $54		; Destination (dst)
	asl
	asl
	asl
	asl
	tay

	lda #$10
	sta $00

.loop14:
	lda $7F60,x		; Copy automap data to temp save
	sta $7F60,y

	inx
	iny

	dec $00
	bne .loop14

; ---------------------------------------------------------

	jsr $6DF1		; Compute data pointers
	ldx #$0E-1

.loop15:
	lda $00,x		; Copy to play save
	sta $C0,x

	dex
	bpl .loop15

; ---------------------------------------------------------

	lda $54		; Destination (dst) save
	sta $16

	jsr $6DF1		; Compute data pointers
	jsr $A780		; Copy file data

; ---------------------------------------------------------

	lda $16		; Menu - Un-fade sprite palettes
	asl
	asl
	tax

	lda #$27
	sta $6803+2,x

	lda #$17
	sta $6803+3,x

	rts

assert pc() <= $BF50	; 0x0BF60

; #########################################################

%org($9D44,2)		; 0x09D54
	; Erase Save
	db $6A,$6A,$6A,$6A,$6A,$6A
	db " ERASE SAVE "
	db $6A,$6A,$6A,$6A,$6A

%org($9D70,2)		; 0x09D80
	; Register - No exit
	db "        "

; ---------------------------------------------------------

%org($A15D,6)		; 0x1A16D
	; Main Menu - Copy Save
	db "COPY SAVE"
	db "         "

%org($A172,6)		; 0x1A182
	; Main Menu - Erase Save
	db "ERASE SAVE"
	db "      "
	db $FF

; ---------------------------------------------------------

%org($A183,6)		; 0x1A193
	; Register Your Name - Alphabet box
	db $21,$E4,$01,$69	; Box top left corner
	db $21,$E5,$57,$6A	; Box horizontal line
	db $21,$FC,$01,$6B	; Box top right corner

	db $22,$04,$C9,$6C	; Box vertical line (left)
	db $22,$1C,$C9,$6C	; Box vertical line (right)

	db $23,$24,$01,$6E	; Box bottom left corner
	db $23,$25,$57,$6A	; Box horizontal line
	db $23,$3C,$01,$6D	; Box bottom right corner

; ---------------------------------------------------------

%org($9D7B,2)		; 0x09D8B
	; Copy, Erase name template
	db $20,$CD,$08
	db "        "
	db $21,$2D,$08
	db "        "
	db $21,$8D,$08
	db "        "
	db $21,$EA,$0F
	db "QUIT           "

	db $FF

assert pc() <= $9DAF+1	; 0x09DBF

%org($9DDF,2)		; 0x09DEF
	; Write name offsets
	db $20,$CD,$01
	db $21,$2D,$01
	db $21,$8D,$01

	db $20,$CE,$48
	db " "

	db $FF

assert pc() <= $9DED+1	; 0x09DFD

; ---------------------------------------------------------

%org($A16C,2)		; 0x0A17C
	cmp #$05		; Name wrap position

%org($A1B6,2)		; 0x0A1C6
	lda #$68		; Sprite start position

%org($A183,2)		; 0x0A193
	cmp #$A8		; Sprite name wrap position

%org($A187,2)		; 0x0A197
	lda #$68		; Sprite name wrap position

; ---------------------------------------------------------

%org($9EFF,2)		; 0x09F0F
	jsr register_menu_quit_sound
	nop #2

assert pc() <= $9F04+1	; 0x09F14

%org($9F6F,2)		; 0x09F7F
	jsr register_menu_name_done

; #########################################################

%org($8AE5,5)		; 0x14AF5
	db $54			; Game over - Heart X-pos

%org($8AFF,5)		; 0x14B0F
	jmp game_over_menu_input
	nop

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;/

; Moved from $BF20 (0x17F30) for compatibility with Automap
%org($93E0,5)		; 0x153F0
game_over_menu_input:
	lda $F8		; Up cursor
	and #$08
	beq .down_cursor4

	lda #$01		; Play sound (Shield block) on Up press
	sta $0604

	dec $13		; Wrap
	bpl .exit

	lda #$02
	sta $13

.exit:
	jmp $8B16

; ---------------------------------------------------------

.down_cursor4:
	lda $F8		; Down cursor
	and #($20|$04)
	jmp $8B03

assert pc() <= $9400	; 0x15410, Originally warnpc $BF40
