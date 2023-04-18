//***********************************************************
//		DUNGEON AUTOMAP (BY TACOSCHIP)
//*********************************************************** 

bank 6; org $ADC0	// 0x1ADD0
dungeon_automap_draw_once:

.map_once:
	jsr .checkmap
	beq .map_once_run

.map_once_exit:
	lda.b $00
	jsr $7282

	lda.b $00
	jsr $7282

	lda.b $00
	jsr $7282

	lda.b #.map_once_return>>8
	pha
	lda.b #.map_once_return-1
	pha
	
	lda.b #$05
	jmp $FFAC

.map_once_run:
	lda.b $00
	pha

	lda.b #$20	// Mark visited flag
	ldy.b $EB	// Room ID
	ora.w $06FF,y
	sta.w $06FF,y

	jsr .get_map_tile
	sta.w $0305

	lda.b #$FF	// eof
	sta.w $0306

	lda.b #$20	// 20xx = status bar
	sta.w $0302

	lda.b $00
	sta.w $0303

	lda.b #$01	// 1 map tile
	sta.w $0304

	lda.b #$04	// 3+1 byte vram payload
	sta.w $0301

	pla
	sta.b $00

	jmp .map_once_exit

// =================================

.get_map_tile:
	lda.b $EB	// Y-pos / 2
	lsr
	lsr
	lsr
	lsr
	lsr
	sta.b $01

	lda.b $EB	// Room #
	clc
	adc.w $6BAB	// xofs
	and.b #$0F	// Wrap X-pos
	tay
	lda.w $6BBD,y	// Dungeon map mask

	ldy.b $01
	and.w .map_mask,y	// Map masks - Two 8x4 tiles
	sta.b $00

	lda.b #$24	// Map tile = none
	sta.b $01
	clc		// Flag = No upper room

	lda.b $EB	// Top room data
	and.b #$EF
	tay

	lda.w $06FF,y	// Visited flag
	and.b #$20
	beq .get_map_tile_lower

	lda.b $00	// Upper map mask
	and.b #$AA
	beq .get_map_tile_lower

	lda.b #$67	// Map tile = upper room
	sta.b $01
	sec

.get_map_tile_lower:
	lda.b $EB	// Bottom room data
	ora.b #$10
	tay

	lda.w $06FF,y	// Visited flag
	and.b #$20
	beq .get_map_tile_exit

	lda.b $00	// Lower map mask
	and.b #$55
	beq .get_map_tile_exit

	lda.b #$FB	// Map tile = Lower room
	bcc .get_map_tile_done

	lda.b #$FF	// Map tile = Upper + lower

.get_map_tile_done:
	sta.b $01

.get_map_tile_exit:
	lda.w $6BAC	// xofs / 8
	lsr
	lsr
	lsr
	sta.b $00

	lda.b $EB	// X-pos
	and.b #$0F
	clc
	adc.b $00	// xofs / 8
	adc.b #$02	// 2 cols indent
	and.b #$1F	// Wrap X-pos
	sta.b $00

	lda.b $EB	// Y-pos % 2
	and.b #$E0
	adc.b #$60	// Y-top
	adc.b $00
	sta.b $00


	lda.b $01	// Tile #
	rts

.map_mask:
	db $C0,$30,$0C,$03

.ppu_map:
	db $72,$92,$B2,$D2

// =================================

.checkmap:
	ldy.b $10	// Dungeon 1-8
	cpy.b #$09
	bcs .checkmap_9

	dey
	lda.w .checkmap_mask, y

	bit.w $0668	// Map 1-8
	rts

.checkmap_9:
	lda.b #$01
	bit.w $066A	// Map 9
	rts

.checkmap_mask:
	db $01,$02,$04,$08,$10,$20,$40,$80

// =================================

.map_full:
	lda.b $10	// Overworld = exit
	beq .map_full_exit

	jsr .checkmap
	beq .map_full_run

.map_full_exit:
	lda.b #$44	// Transfer type
	sta.b $14

.map_full_exit2:
	lda.b #$B0
	pha
	lda.b #$1A-1
	pha

	lda.b #$05	// Bank switch
	jmp $FFAC

.map_full_run:
	ldx.b #$00	// Vram size


.map_full_row:
	lda.b $EB
	and.b #$E8	// Reset xpos = 0/8, ypos = 6
	sta.b $EB

	jsr .get_map_tile	// Dummy

	lda.b #$20	// 20xx = status bar
	sta.w $0302,x

	lda.b $00
	sta.w $0303,x

	lda.b #$08	// 8 map tiles
	sta.w $0304,x

	sta.b $EC	// Unused on dungeon entry

.map_full_room:
	jsr .get_map_tile
	sta.w $0305,x

	inx
	inc.b $EB

	dec.b $EC
	bne .map_full_room

	inx
	inx
	inx

	lda.b $EB
	sec
	sbc.b #$20-8
	sta.b $EB
	bpl .map_full_row

	lda.b #(3+8)*4	// Vram payload size
	sta.w $301

	lda.b #$FF	// eof
	sta.w $032E

	lda.w $6BAD	// Reload starting room
	sta.b $EB

	jmp .map_full_exit2

// ##########################################

bank 5; org $B01D
	lda.b #.map_full>>8
	pha
	lda.b #.map_full-1
	pha

	lda.b #$06	// Bank switch
	jmp $FFAC

	nop #2

warnpc $B02A+1

bank 5; org $A731
	lda.b #.map_once>>8
	pha
	lda.b #.map_once-1
	pha

	lda.b #$06	// Bank switch
	jmp $FFAC

	nop #2

.map_once_return:

warnpc $A73E+1

