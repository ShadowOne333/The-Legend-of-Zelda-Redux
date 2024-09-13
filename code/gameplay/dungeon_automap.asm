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

	// Dungeon 4 1st Quest and Dugneon 5 2nd Quest fix by bogaa
	lda $12		// Only load on initial load 
	cmp #$05
	bcs +
    
	lda #$7E	// Load icons to HUD + B/A window 
	sta $14
	jsr $A080

	+		// End of fix

	lda.b #$05
	jmp $FFAC

.map_once_run:
	lda.b $00
	pha

	jsr .get_map_room_index
	lda.b #$20	// Mark visited flag
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

	jsr .get_map_room_index
	and.b #$EF	// Top room data
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
	jsr .get_map_room_index
	ora.b #$10	// Bottom room data
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

	jsr .get_map_room_index
	lda.b #$20	// Mark first room visited flag
	ora.w $06FF,y
	sta.w $06FF,y

.map_full_row:
	lda.b $EB
	and.b #$E8	// Reset X-pos = 0/8, Y-pos = 6
	sta.b $EB

	lda.b #$08	// 8 map tiles (gzip recommended #$07 here instead of #$08))
	sta.b $EC	// Unused on dungeon entry

.map_full_skip:
	jsr .get_map_tile	// Ignore leading empty tiles
	cmp.b #$24
	bne .map_full_header

	inc.b $EB
	dec.b $EC
	bne .map_full_skip
	beq .map_full_next

.map_full_header:
	lda.b #$20	// 20xx = status bar
	sta.w $0302,x

	lda.b $00
	sta.w $0303,x

	lda.b $EC
	sta.w $0304,x

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

.map_full_next:
	lda.b $EB
	sec
	sbc.b #$20-8
	sta.b $EB
	bpl .map_full_row

	stx.w $0301	// Vram payload size

	lda.b #$FF	// eof
	inx
	sta.w $0301,x

	lda.w $6BAD	// Reload starting room
	sta.b $EB

	jmp .map_full_exit2

// =================================

.get_map_room_index:
	php
	lda.b $EB	// Room ID

	// Fix for automap for Dungeons 7, 8 and 9
// Previous method filled the maps for dungeons 7-9 due to them having shared properties with dungeons 2 and 3.
	ldy.w $6BB0	// Ptr bank $06FF, $077F
	cpy.b #$07-1
	beq .get_map_room_index_exit
    
	ora.b #$80	// Other map bank

.get_map_room_index_exit:
	tay
	plp
	rts

// ##########################################

bank 5;
org $B01D	// 0x1702D
	lda.b #.map_full>>8
	pha
	lda.b #.map_full-1
	pha

	lda.b #$06	// Bank switch
	jmp $FFAC

	nop #2

warnpc $B02A+1

bank 5;
org $A731	// 0x16741
	lda.b #.map_once>>8
	pha
	lda.b #.map_once-1
	pha

	lda.b #$06	// Bank switch
	jmp $FFAC

	nop #2

.map_once_return:

warnpc $A73E+1
