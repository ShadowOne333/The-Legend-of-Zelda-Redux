//***********************************************************
//		File Select Menu Tweaks by Minucce
//  Code should be used only for educational, documentation and modding purposes
//***********************************************************

//***********************************************************
//	Table file
//***********************************************************

table code/text/text.tbl,ltr

// *********************************************************

//  Original code by SpiderDave

bank 2;
org $A4A6	// 0x0A4B6
	jsr main_menu_palette
	nop

// ---------------------------------------------------------

org $A573	// 0x0A583

main_menu_init_done:
	lda.b $54
	cmp.b #$03
	bcc .write

	lda.b #$00	// Default save slot 0

.write:
	sta.b $16

// ---------------------------------------------------------

	lda.b #$00	// Main menu - Submode 0
	sta.b $13

	lda.b #$FF	// Cave ID
	sta.w $0526

	inc.b $11
	rts

//warnpc $A589

// #########################################################

org $A596	// 0x0A5A6

	dw main_menu_run
	dw main_menu_exit

// ---------------------------------------------------------

main_menu_run:
	ldy.b $16		// Current slot
	ldx.b $F8		// Joypad 1


// -------------------------------------------------------

.select_option:
	txa
	and.b #$10
	beq .cursor_up

	lda.w $0633,y		// Slot enabled
	bne .valid_slot

	lda.b #$03		// Register mode
	sta.b $16

.valid_slot:
	sty.b $54		// Selected mode  (reset on game start)

	inc.b $13		// Stop menu
	rts


// -------------------------------------------------------

.cursor_up:
	txa
	and.b #$08
	beq .cursor_down

	dey			// Wrap index  (0-4)
	bpl .move_cursor


	ldy.b #$04
	bne .move_cursor

// -------------------------------------------------------

.cursor_down:
	txa
	and.b #($04|$20)
	beq .draw_cursor

	iny			// Wrap index  (0-4)
	cpy.b #$05
	bne .move_cursor

	ldy.b #$00

// -------------------------------------------------------

.move_cursor:
	sty.b $16

	lda.b #$01		// Play sound
	sta.w $0602

// ====================================================

.draw_cursor:
	ldx.b #$02		// Copy OAM data


.loop:
	lda.w $A589,x
	sta.w $0201,x
	dex
	bpl .loop

	lda.w $A58C,y		// Y-pos
	sta.w $0200

	lda.b #$58		// Link sprites Y,X
	sta.b $01

	lda.b #$30
	sta.b $00

	jmp $A638		// Draw

// ####################################################

main_menu_exit_check:
	lda.b $16		// Game slot
	cmp.b #$03
	bcc .load_game


	// sec			// Run other menu mode
	adc.b #$0B-1
	sta $12

	jmp $EBA3
	nop #5

// =====================================================

.load_game:

//warnpc $A5FE

// /////////////////////////////////////////////////////////

org $A58C	// 0x0A59C
	db $5C,$74,$8C		// Main menu - Cursor Y-pos
	db $A8-1,$B8-1

org $9DAF	// 0x09DBF
	db $2F+4,$47+4,$5F+4	// Register mode - Cursor Y-pos
	db $77

org $9DF9	// 0x09E09
	db $43+2		// Copy, Erase - Cursor X-pos

org $A1D1	// 0x0A1E1
	jsr register_mode_letter_ypos

// ###########################################################

org $9E3F	// 0x09E4F

	ldy.b $54		// Game mode
	jmp main_menu_mode_name
	nop #1

//warnpc $9e45

// ////////////////////////////////////////////////////

org $9EAA	// 0x09EBA
	ldy.b $54		// Erase mode = Blue cursor
	cpy.b #$04

// ###########################################################

org $9EB9	// 0x09EC9

main_menu_active_player:
	ldx.b $54		// Create mode (0-2)
	cpx.b #$03
	bcc .store

	ldx #$FF		// Find 1st active slot

.find:
	inx
	lda.w $0633,x
	beq .find

.store:
	stx.b $16		// Save slot
	jsr $A18E


	lda.b #$50		// Link Y,X position
	sta.b $00

	lda.b #$30
	sta.b $01

	inc.b $11
	jmp $A638		// Write sprites

// //////////////////////////////////////////////////////

menu_misc_draw_name_map:
	lda.b #$00
	bcs .exit

	lda.b #$16		// Draw alphabet board

.exit:
	sta.b $14

	inc.b $13		// Next submode 03
	rts

// //////////////////////////////////////////////////////

register_mode_letter_ypos:
	sec
	sbc.b #$08+4
	jmp $A1FA
	nop #0

//warnpc $9eeb

// ###########################################################

org $9E9D	// 0x09EAD

	lda.b $54		// Register mode only
	cmp.b #$03

	jmp menu_misc_draw_name_map
	nop #0

//warnpc $9EA4

// ///////////////////////////////////////////////////////////

org $9EB5	// 0x09EC5

	jmp misc_menu_palette
	nop #1

//warnpc $9eb9

// ///////////////////////////////////////////////////////////

org $9EF0	// 0x09FF0

register_player_joypad_start:
	lda.b $F8		// Joypad 1
	and.b #$10
	bne .save

	jmp $9FB0		// Spin loop
	nop #6

.save:

//warnpc $9eff

// ///////////////////////////////////////////////////////////

org $9FB9	// 0x09FC9
	nop #3			// Register mode -- Ignore select button

// ###########################################################

org $9FC5	// 0x09FD5

erase_player_run:
	jmp erase_player_mode

	nop #22

//warnpc $9fde

// ###########################################################

org $A204	// 0x0A214
// Free space = Old menu input handler

// ///////////////////////////////////////////////////////////

register_menu_quit_sound:
	lda.b $54		// Register only
	cmp.b #$03
	bcs .exit1

// ---------------------------------------------------------

	ldx.b #$07		// Blank name

.loop1:
	lda.w $0640,x		// All space
	cmp.b #$24
	bne .exit1

	dex
	bpl .loop1

	lda.b #$20		// All space = Quit sound
	sta.w $0602



.exit1:
	lda.b #$00		// Silent
	sta.w $0607

	rts

// /////////////////////////////////////////////////////////////

register_menu_name_done:
	ldy.b #$00
	lda ($CC),y		// Check quest number
	bne .zelda

	lda.b #$08		// Play sound (Fairy)
	sta.w $0602
	bne .exit2

.zelda:
	lda.b #$0C		// Play sound (Secret)
	sta.w $0602

// ---------------------------------------------------------

.exit2:
	tax			// Mark save ready
	lda.b #$01

	rts

// /////////////////////////////////////////////////////////////

main_menu_exit:
	lda.b #$00
	sta.w $0602		// Sound off
	sta.w $0656		// Item index
	sta.b $10		// Level = Overworld

	ldx.b $54		// Copy player
	cpx.b #$03
	bne .exit3

	inx
	stx.b $16

.exit3:
	jmp main_menu_exit_check

	nop #7

//warnpc $a254

// ###########################################################

org $BA00	// 0x0BA10

main_menu_palette:
	ldy.b #$02

.loop2:
	lda.w $0633,y		// Non-active player
	bne .next

	tya
	asl
	asl
	tax

	lda.b #$19		// Faded default palette
	sta.w $6803+1,x

	lda.b #$17
	sta.w $6803+2,x

	lda.b #$07
	sta.w $6803+3,x

.next:
	dey
	bpl .loop2

// ---------------------------------------------------------

	lda.b #$12		// Transfer palette at VBlank
	sta.b $14

	rts

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

main_menu_mode_name:
	cpy.b #$03		// Register your name
	bcs .copy_player

	lda.b #$24		// Title edge spaces
	sta.w $0308
	sta.w $031B

	jmp $9E45

// ---------------------------------------------------------

.copy_player:
	bne .erase_player

	ldy.b #$13-1		// Copy new string

.loop3:
	lda .copy_save_title, y
	sta.w $0308, y
	dey
	bpl .loop3

.erase_player:
	jmp $9E52


// ---------------------------------------------------------

.copy_save_title:
	// Copy Save
	db $6A,$6A,$6A,$6A
	db " COPY SAVE "
	db $6A,$6A,$6A,$6A

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

misc_menu_palette:
	lda.b $54		// Creation mode only
	cmp.b #$03
	bcs .exit4

	asl
	asl
	tax

	lda.b #$29		// Normal palette
	sta.w $6803+1,x

	lda.b #$27
	sta.w $6803+2,x

	lda.b #$17
	sta.w $6803+3,x


// ---------------------------------------------------------

.exit4:
	lda.b #$12		// Transfer palette
	sta.b $14

	inc.b $13		// Next submode 04
	rts

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

erase_player_mode:
	lda.b $13
	cmp.b #$04
	bne .submode_05

.submode_04:
	ldx.b #(.text_end-.text)

.loop4:
	lda.w .text,x
	sta.w $0302,x

	dex
	bpl .loop4

	inc.b $13
	rts

// -----------------------------------------------------------

.text:
	// Box - Upper
	db $22,$46,$01,$69	// Up-Left corner
	db $22,$47,$13|$40,$6A	// Horizontal line
	db $22,$5A,$01,$6B	// Up-Right corner

	// Box - Sides
	db $22,$66,$07|$C0,$6C	// Vertical line
	db $22,$7A,$07|$C0,$6C	// Vertical line

	db $FF

.text_end:



// /////////////////////////////////////////////////////////

.submode_05:
	cmp.b #$05
	bne .submode_06

	lda.b $54		// Copy or erase
	cmp.b #$03
	bne .erase_text

.copy_text:
	ldx.b #(.copy_str_end-.copy_str)

.copy_loop:
	lda.w .copy_str,x
	sta.w $0302,x

	dex
	bpl .copy_loop

	inc.b $13
	rts

// ---------------------------------------------------------

.erase_text:
	ldx.b #(.erase_str_end-.erase_str)

.erase_loop:
	lda.w .erase_str,x
	sta.w $0302,x

	dex
	bpl .erase_loop

	inc.b $13
	rts

// ---------------------------------------------------------

.erase_str:
	// Box - lower
	db $23,$46,$01,$6E
	db $23,$47,$13|$40,$6A
	db $23,$5A,$01,$6D

	// Erase which save?
	db $22,$88,$11
	db "ERASE WHICH SAVE?"

	db $FF

.erase_str_end:



.copy_str:
	// Box - lower
	db $23, $46, $01, $6e
	db $23, $47, $13|$40, $6a
	db $23, $5a, $01, $6d

	// Copy which save?
	db $22,$88,$11
	db "COPY WHICH SAVE? "

	db $FF

.copy_str_end:



// /////////////////////////////////////////////////////////

.submode_06:
	cmp.b #$06
	bne .submode_07

	ldx.b $F8		// Joypad 1

.start_button:
	txa
	and.b #$10
	beq .down_cursor

	lda.b $16			// Player slot only
	cmp.b #$03
	bcs .quit

.copy_slot_2:
	lda.b $54
	cmp.b #$03
	bne .erase_confirm

	lda.b #$10
	sta.b $13

	jmp .submode_10

.erase_confirm:
	inc.b $13

	lda.b $13
	bne .submode_07

.quit:
	jmp .submode_quit

// ---------------------------------------------------------

.down_cursor:
	txa			// Down + Select button
	and.b #($20|$04)
	beq .up_cursor

	ldy.b $16		// Save slot

.loop5:
	iny
	cpy.b #$04		// Past exit
	bne .check

	ldy.b #$00		// Slot 1

.check:
	lda.w $0633,y		// Slot active
	beq .loop5

	bne .move_cursor1

// ---------------------------------------------------------

.up_cursor:
	txa
	and.b #$08
	beq .no_move

	ldy.b $16		// Save slot

.loop6:
	dey
	bpl .check1

	ldy.b #$03		// Exit slot

.check1:
	lda.w $0633,y		// Slot active
	beq .loop6

// ---------------------------------------------------------

.move_cursor1:
	sty.b $16

	lda.w $9DAF,y		// Y-pos cursor
	sta.w $0200

	lda.b #$01		// Play tune
	sta.w $0602

// ---------------------------------------------------------

.no_move:
	rts

// /////////////////////////////////////////////////////////

.submode_07:
	cmp.b #$07
	bne .submode_08

	ldx.b #(.text1_end-.text1)

.loop7:
	lda.w .text1,x
	sta.w $0302,x

	dex
	bpl .loop7

	ldx.b $16		// Slot 1
	inx
	stx.w $0302+$10

// ---------------------------------------------------------

	lda.b #$20		// Play sound
	sta.w $0604

	lda.b #$00		// Cursor choice
	sta.b $55

	lda.b $16		// Color 1
	sta.w $0202

	lda.b #$AF		// Sprite cursor 2
	sta.w $0230

	lda.b #$F2+1
	sta.w $0231

	lda.b #$03
	sta.w $0232

	lda.b #$4C
	sta.w $0233

	inc.b $13
	rts

// ---------------------------------------------------------

.text1:
	// Erase player X?
	db $22,$88,$11
	db "ERASE PLAYER 0?  "

	// Okay
	db $22,$CB,$04
	db "OKAY"

	// Quit
	db $23,$0B,$04
	db "QUIT"

	db $FF

.text1_end:


// /////////////////////////////////////////////////////////

.submode_08:
	cmp.b #$08
	bne .submode_09

	ldx.b #(.text2_end-.text2)

.loop8:
	lda.w .text2,x
	sta.w $0302,x

	dex
	bpl .loop8

// ---------------------------------------------------------

.sprite1:
	ldx.b #$00
	cpx.b $16
	bne .sprite2

	stx.w $0290+2		// Gray sword

.sprite2:
	inx
	cpx.b $16
	bne .sprite3

	lda.b #$15		// Gray sprite
	sta.w $0302+1

	lda.b #$D3		// Grey text
	sta.w $0302+7

	lda.b #$0A
	sta.w $0302+9

	lda.b #$01		// Gray sword
	sta.w $0298+2

.sprite3:
	inx
	cpx.b $16
	bne .exit5

	lda.b #$19		// Gray sprite
	sta.w $0302+1

	lda.b #$DB		// Gray text
	sta.w $0302+7

	lda.b #$0A
	sta.w $0302+9

	lda.b #$02		// Gray sword
	sta.w $02A0+2

.exit5:
	inc.b $13
	rts

// --------------------------------------------------------

.text2:
	// Gray sprite
	db $3F,$11,$03
	db $10,$30,$00

	// Grey text
	db $23,$CB,$03|$40
	db $A0

	// Grey color
	db $3F,$09,$01
	db $00

	// Red text
	db $23,$EB,$03
	db $04,$05,$01

	db $FF

.text2_end:


// /////////////////////////////////////////////////////////

.submode_09:
	cmp.b #$09
	bne .submode_10

	ldx.b $F8		// Joypad 1
	ldy.b $55

.start_button:
	txa
	and.b #$10
	beq .down_cursor1
	tya			// Okay chosen (00)
	bne .exit6

	lda.b $16		// Delete player
	jsr $9FE8

	jmp .submode_quit

.exit6:
	lda.b #$20		// Play sound (Quit)
	sta.w $0602

	bne .submode_quit

// ---------------------------------------------------------

.down_cursor1:
	txa			// Down + Select button
	and.b #($20|$04)
	beq .up_cursor1

	dey
	bpl .move_cursor2

	ldy.b #$01
	bne .move_cursor2

// ---------------------------------------------------------

.up_cursor1:
	txa
	and.b #$08
	beq .no_move1

	iny
	cpy.b #$02
	bne .move_cursor2

	ldy.b #$00

// ---------------------------------------------------------

.move_cursor2:
	sty.b $55

	lda.w .cursor4_ypos,y	// Y-pos cursor
	sta.w $0230

	lda.b #$01		// Play tune
	sta.w $0602

// ---------------------------------------------------------

.no_move1:
	rts

.cursor4_ypos:
	db $AF,$BF

// /////////////////////////////////////////////////////////

.submode_quit:
	lda.b #$15		// Red cursor
	sta.w $6810

	jmp $9EFF		// Reset save integrity

// /////////////////////////////////////////////////////////

.submode_10:
	cmp.b #$10
	bne .submode_11

	ldx.b #(.text3_end-.text3)

.loop9:
	lda.w .text3,x
	sta.w $0302,x

	dex
	bpl .loop9

// ---------------------------------------------------------

	ldx.b #$00		// Cursor 2 choice
	cpx.b $16
	bne .cursor2

	inx
	cpx.b $16
	bne .cursor2

	inx

.cursor2:
	stx.b $54

	lda.b $16		// Cursor 1 color
	sta.w $0202

	lda.w .cursor2_ypos,x	// Sprite cursor 2
	sta.w $0234

	lda.b #$F2+1
	sta.w $0235

	lda.b #$03
	sta.w $0236

	lda.b #$45
	sta.w $0237

.slot2:
	ldx.b $16
	dex
	bne .slot3

	lda.b #$D3		// Red text
	sta.w $0302+21

	lda.b #$05
	sta.w $0302+23

.slot3:
	dex
	bne .exit7


	lda.b #$DB		// Red text
	sta.w $0302+21

	lda.b #$05
	sta.w $0302+23

.exit7:
	lda.b #$10		// Play sound (Heart)
	sta.w $0604

	inc $13
	rts

.cursor2_ypos:
	db $33,$4B,$63

// ---------------------------------------------------------

.text3:
	// To which slot?
	db $22,$88,$11
	db "TO WHICH SLOT?   "

	// Red text
	db $23,$CB,$03|$40
	db $50

	db $FF

.text3_end:


// /////////////////////////////////////////////////////////

.submode_11:
	cmp.b #$11
	bne .submode_12

	ldx.b $F8		// Joypad 1

.start_button:
	txa
	and.b #$10
	beq .down_cursor2

	lda.b $54		// Player slot only
	cmp.b #$03
	bcs .quit1

	inc.b $13

	lda.b $13
	bne .submode_12

.quit1:
	jmp .submode_quit

// ---------------------------------------------------------

.down_cursor2:
	txa			// Down + Select button
	and.b #($20|$04)
	beq .up_cursor2

	ldy.b $54		// Destination (dst) slot

.loop10:
	iny

	cpy.b #$04		// Past exit
	bne .check2

	ldy.b #$00		// Slot 1

.check2:
	cpy.b $16		// Not save 1
	beq .loop10

	bne .move_cursor3

// ---------------------------------------------------------

.up_cursor2:
	txa
	and.b #$08
	beq .no_move2

	ldy.b $54		// Destination (dst) slot

.loop11:
	dey
	bpl .check3

	ldy.b #$03		// Exit slot

.check3:
	cpy.b $16		// Not save 1
	beq .loop11

// ---------------------------------------------------------


.move_cursor3:
	sty.b $54

	lda.w $9DAF,y		// Y-pos cursor 2
	sta.w $0234

	lda.b #$01		// Play tune
	sta.w $0602

// ---------------------------------------------------------

.no_move2:
	rts

// /////////////////////////////////////////////////////////

.submode_12:
	cmp.b #$12
	bne .submode_13

	ldx.b #(.text4_end-.text4)

.loop12:
	lda.w .text4,x
	sta.w $0302,x

	dex
	bpl .loop12

	ldx.b $16		// Save 1
	inx
	stx.w $0302+$0D

	ldx.b $54		// Save 2
	inx
	stx.w $0302+$12

// ---------------------------------------------------------

	lda.b #$20		// Play sound
	sta.w $0604

	lda.b #$00		// Cursor choice
	sta.b $55

	lda.b $54		// Color 2
	sta.w $0236

	lda.b #$AF		// Sprite cursor 3
	sta.w $0230

	lda.b #$F3
	sta.w $0231

	lda.b #$03
	sta.w $0232

	lda.b #$4C
	sta.w $0233

	inc.b $13
	rts

// ---------------------------------------------------------

.text4:
	// Copy from x to y?
	db $22,$88,$11
	db "COPY FROM 0 TO 0?"

	// Okay
	db $22,$CB,$04
	db "OKAY"

	// Quit
	db $23,$0B,$04
	db "QUIT"

	db $FF

.text4_end:


// /////////////////////////////////////////////////////////

.submode_13:
	cmp.b #$13
	bne .submode_14

	ldx.b #(.text5_end-.text5)

.loop13:
	lda.w .text5,x		// !!
	sta.w $0302,x

	dex
	bpl .loop13

// ---------------------------------------------------------

.sprite4:
	ldx.b #$00
	cpx.b $54
	bne .sprite5

	stx.w $0290+2		// Gray sword

.sprite5:
	inx
	cpx.b $54
	bne .sprite6

	lda.b #$15		// Gray sprite
	sta.w $0302+1

	lda.b #$D3		// Gray text
	sta.w $0302+7

	lda.b #$0A
	sta.w $0302+9

	lda.b #$01		// Gray sword
	sta.w $0298+2

.sprite6:
	inx
	cpx.b $54
	bne .exit8

	lda.b #$19		// Gray sprite
	sta.w $0302+1

	lda.b #$DB		// Gray text
	sta.w $0302+7

	lda.b #$0A
	sta.w $0302+9

	lda.b #$02		// Gray sword
	sta.w $02A0+2

.exit8:
	inc.b $13
	rts

// ---------------------------------------------------------

.text5:
	// Gray sprite
	db $3F,$11,$03
	db $10,$30,$00

	// Gray text
	db $23,$CB,$03|$40
	db $A0

	// Gray color
	db $3F,$09,$01
	db $00

	// Red text
	db $23,$EB,$02
	db $05,$05

	// Green text
	db $23,$ED,$01
	db $0F

	// Green color
	db $3F,$0D,$01
	db $1A

	db $ff

.text5_end:


// /////////////////////////////////////////////////////////

.submode_14:
	ldx.b $F8		// Joypad 1
	ldy.b $55

.start_button:
	txa
	and.b #$10
	beq .down_cursor3
	tya			// Okay chosen (00)
	bne .exit9

	jsr copy_player1

	lda.b #$08		// Play sound (Fairy)
	sta.w $0602

	jmp .submode_quit

.exit9:
	lda.b #$20		// Play sound (Quit)
	sta.w $0602

	jmp .submode_quit

// ----------------------------------------------------

.down_cursor3:
	txa			// Down + Select button
	and.b #($20|$04)
	beq .up_cursor3

	dey
	bpl .move_cursor4

	ldy.b #$01
	bne .move_cursor4

// ---------------------------------------------------------

.up_cursor3:
	txa
	and.b #$08
	beq .no_move3

	iny
	cpy.b #$02
	bne .move_cursor4

	ldy.b #$00

// ---------------------------------------------------------

.move_cursor4:
	sty.b $55

	lda.w .cursor3_ypos,y	// Y-pos cursor 3
	sta.w $0230

	lda.b #$01		// Play tune
	sta.w $0602

// ---------------------------------------------------------

.no_move3:
	rts

.cursor3_ypos:
	db $AF,$BF

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

copy_player1:
	lda.b $16		// Source (src)
	asl
	tay

	lda.b $54		// Destination (dst)
	asl
	tax

	// Play save = Temporary in-game save data

	lda.w $6524,y		// Transfer checksum to play save
	sta $6D9C,x

	lda $6525,y
	sta $6D9D,x

// ---------------------------------------------------------

.autosave:
	lda.b $16		// Source (src)
	asl
	asl
	asl
	asl
	tax

	lda.b $54		// Destination (dst)
	asl
	asl
	asl
	asl
	tay

	lda.b #$10
	sta.b $00

.loop14:
	lda.w $7F60,x		// Copy automap data to temp save
	sta.w $7F60,y

	inx
	iny

	dec.b $00
	bne .loop14

// ---------------------------------------------------------

	jsr $6DF1		// Compute data pointers
	ldx.b #$0E-1

.loop15:
	lda.b $00,x		// Copy to play save
	sta $C0,x

	dex
	bpl .loop15

// ---------------------------------------------------------

	lda.b $54		// Destination (dst) save
	sta.b $16

	jsr $6DF1		// Compute data pointers
	jsr $A780		// Copy file data

// ---------------------------------------------------------

	lda.b $16		// Menu - Un-fade sprite palettes
	asl
	asl
	tax

	lda.b #$27
	sta.w $6803+2,x

	lda.b #$17
	sta.w $6803+3,x

	rts

//warnpc $BF50

// #########################################################

org $9D44	// 0x09D54
	// Erase Save
	db $6A,$6A,$6A,$6A,$6A,$6A
	db " ERASE SAVE "
	db $6A,$6A,$6A,$6A,$6A

org $9D70	// 0x09D80
	// Register - No exit
	db "        "

// ---------------------------------------------------------

bank 6;
org $A15D	// 0x1A16D
	// Main Menu - Copy Save
	db "COPY SAVE"
	db "         "

org $A172	// 0x1A182
	// Main Menu - Erase Save
	db "ERASE SAVE"
	db "      "
	db $FF

// ---------------------------------------------------------

org $A183	// 0x1A193
	// Register Your Name - Alphabet box
	db $21,$E4,$01,$69	// Box top left corner
	db $21,$E5,$57,$6A	// Box horizontal line
	db $21,$FC,$01,$6B	// Box top right corner

	db $22,$04,$C9,$6C	// Box vertical line (left)
	db $22,$1C,$C9,$6C	// Box vertical line (right)

	db $23,$24,$01,$6E	// Box bottom left corner
	db $23,$25,$57,$6A	// Box horizontal line
	db $23,$3C,$01,$6D	// Box bottom right corner

// ---------------------------------------------------------

bank 2;
org $9D7B	// 0x09D8B
	// Copy, Erase name template
	db $20,$CD,$08
	db "        "
	db $21,$2D,$08
	db "        "
	db $21,$8D,$08
	db "        "
	db $21,$EA,$0F
	db "QUIT           "

	db $FF

//warnpc $9daf

org $9DDF	// 0x09DEF
	// Write name offsets
	db $20,$CD,$01
	db $21,$2D,$01
	db $21,$8D,$01

	db $20,$CE,$48
	db " "

	db $FF

//warnpc $9ded

// ---------------------------------------------------------

org $A16C	// 0x0A17C
	cmp.b #$05		// Name wrap position

org $A1B6	// 0x0A1C6
	lda.b #$68		// Sprite start position

org $A183	// 0x0A193
	cmp.b #$A8		// Sprite name wrap position

org $A187	// 0x0A197
	lda.b #$68		// Sprite name wrap position

// ---------------------------------------------------------

org $9EFF	// 0x09F0F
	jsr register_menu_quit_sound
	nop #2

//warnpc $9F04

org $9F6F	// 0x09F7F
	jsr register_menu_name_done

// #########################################################

bank 5;
org $8AE5	// 0x14AF5
	db $54			// Game over - Heart X-pos

org $8AFF	// 0x14B0F
	jmp game_over_menu_input
	nop

// /////////////////////////////////////////////////////////

org $93E0	// 0x153F0
// Moved from $BF20 (0x17F30) for compatibility with MMC1 Automap

game_over_menu_input:
	lda.b $F8		// Up cursor
	and.b #$08
	beq .down_cursor4

	dec.b $13		// Wrap
	bpl .exit

	lda.b #$02
	sta.b $13

.exit:
	jmp $8B16

// ---------------------------------------------------------

.down_cursor4:
	lda.b $F8		// Down cursor
	and.b #($20|$04)
	jmp $8B03

//warnpc $9400, Originally warnpc $BF40
