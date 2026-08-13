;***********************************************************
;		DUNGEON AUTOMAP (BY TACOSCHIP)
;*********************************************************** 

%org($ADC0,6)		; 0x1ADD0
dungeon_automap_draw_once:

.map_once:
	jsr .checkmap
	beq .map_once_run

.map_once_exit:
	lda $00
	jsr $7282

	lda $00
	jsr $7282

	lda $00
	jsr $7282

	lda.b #.map_once_return>>8
	pha
	lda.b #.map_once_return-1
	pha

	; Dungeon 4 1st Quest and Dugneon 5 2nd Quest fix by bogaa
	lda $12		; Only load on initial load 
	cmp #$05
	bcs +
    
	lda #$7E	; Load icons to HUD + B/A window 
	sta $14
	jsr $A080

	+		; End of fix

	lda #$05
	jmp $FFAC

.map_once_run:
	lda $00
	pha

	jsr .get_map_room_index
	lda #$20	; Mark visited flag
	ora $06FF,y
	sta $06FF,y

	jsr .get_map_tile
	sta $0305

	lda #$FF	; eof
	sta $0306

	lda #$20	; 20xx = status bar
	sta $0302

	lda $00
	sta $0303

	lda #$01	; 1 map tile
	sta $0304

	lda #$04	; 3+1 byte vram payload
	sta $0301

	pla
	sta $00

	jmp .map_once_exit

; =================================

.get_map_tile:
	lda $EB	; Y-pos / 2
	lsr
	lsr
	lsr
	lsr
	lsr
	sta $01

	lda $EB	; Room #
	clc
	adc $6BAB	; xofs
	and #$0F	; Wrap X-pos
	tay
	lda $6BBD,y	; Dungeon map mask

	ldy $01
	and .map_mask,y	; Map masks - Two 8x4 tiles
	sta $00

	lda #$24	; Map tile = none
	sta $01
	clc		; Flag = No upper room

	jsr .get_map_room_index
	and #$EF	; Top room data
	tay

	lda $06FF,y	; Visited flag
	and #$20
	beq .get_map_tile_lower

	lda $00	; Upper map mask
	and #$AA
	beq .get_map_tile_lower

	lda #$67	; Map tile = upper room
	sta $01
	sec

.get_map_tile_lower:
	jsr .get_map_room_index
	ora #$10	; Bottom room data
	tay

	lda $06FF,y	; Visited flag
	and #$20
	beq .get_map_tile_exit

	lda $00	; Lower map mask
	and #$55
	beq .get_map_tile_exit

	lda #$FB	; Map tile = Lower room
	bcc .get_map_tile_done

	lda #$FF	; Map tile = Upper + lower

.get_map_tile_done:
	sta $01

.get_map_tile_exit:
	lda $6BAC	; xofs / 8
	lsr
	lsr
	lsr
	sta $00

	lda $EB	; X-pos
	and #$0F
	clc
	adc $00	; xofs / 8
	adc #$02	; 2 cols indent
	and #$1F	; Wrap X-pos
	sta $00

	lda $EB	; Y-pos % 2
	and #$E0
	adc #$60	; Y-top
	adc $00
	sta $00

	lda $01	; Tile #
	rts

.map_mask:
	db $C0,$30,$0C,$03

; =================================

.checkmap:
	ldy $10	; Dungeon 1-8
	cpy #$09
	bcs .checkmap_9

	dey
	lda .checkmap_mask, y

	bit $0668	; Map 1-8
	rts

.checkmap_9:
	lda #$01
	bit $066A	; Map 9
	rts

.checkmap_mask:
	db $01,$02,$04,$08,$10,$20,$40,$80

; =================================

.map_full:
	lda $10	; Overworld = exit
	beq .map_full_exit

	jsr .checkmap
	beq .map_full_run

.map_full_exit:
	lda #$44	; Transfer type
	sta $14

.map_full_exit2:
	lda #$B0
	pha
	lda #$1A-1
	pha

	lda #$05	; Bank switch
	jmp $FFAC

.map_full_run:
	ldx #$00	; Vram size

	jsr .get_map_room_index
	lda #$20	; Mark first room visited flag
	ora $06FF,y
	sta $06FF,y

.map_full_row:
	lda $EB
	and #$E8	; Reset X-pos = 0/8, Y-pos = 6
	sta $EB

	lda #$08	; 8 map tiles (gzip recommended #$07 here instead of #$08))
	sta $EC	; Unused on dungeon entry

.map_full_skip:
	jsr .get_map_tile	; Ignore leading empty tiles
	cmp #$24
	bne .map_full_header

	inc $EB
	dec $EC
	bne .map_full_skip
	beq .map_full_next

.map_full_header:
	lda #$20	; 20xx = status bar
	sta $0302,x

	lda $00
	sta $0303,x

	lda $EC
	sta $0304,x

.map_full_room:
	jsr .get_map_tile
	sta $0305,x

	inx
	inc $EB

	dec $EC
	bne .map_full_room

	inx
	inx
	inx

.map_full_next:
	lda $EB
	sec
	sbc #$20-8
	sta $EB
	bpl .map_full_row

	stx $0301	; Vram payload size

	lda #$FF	; eof
	inx
	sta $0301,x

	lda $6BAD	; Reload starting room
	sta $EB

	jmp .map_full_exit2

; =================================

.get_map_room_index:
	php
	lda $EB	; Room ID

	; Fix for automap for Dungeons 7, 8 and 9
; Previous method filled the maps for dungeons 7-9 due to them having shared properties with dungeons 2 and 3.
	ldy $6BB0	; Ptr bank $06FF, $077F
	cpy #$07-1
	beq .get_map_room_index_exit
    
	ora #$80	; Other map bank

.get_map_room_index_exit:
	tay
	plp
	rts

; ##########################################

%org($B01D,5)		; 0x1702D
	lda.b #.map_full>>8
	pha
	lda.b #.map_full-1
	pha

	lda #$06	; Bank switch
	jmp $FFAC

	nop #2

assert pc() <= $B02A+1

%org($A731,5)		; 0x16741
	lda.b #.map_once>>8
	pha
	lda.b #.map_once-1
	pha

	lda #$06	; Bank switch
	jmp $FFAC

	nop #2

.map_once_return:

assert pc() <= $A73E+1
