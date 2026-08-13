;***********************************************************
;		AUTOMAP PLUS (BY SNARFBLAM)
;	       Disassembled and modified for
;	   1/4 hearts decrements by ShadowOne333
;*********************************************************** 

;****************************************
;	Table file
;****************************************
; Font table required for attribute tables definitions
incsrc "code/text/text.tbl"


;****************************************
;	Map image
;****************************************

%org($AD00,5)		; 0x16D10-0x16F0C
; Automap tilemap (Filling map tiles)
	incbin "code/gameplay/automap_tiles.bin"


;****************************************
;	Variable declarations
;****************************************

; HUD Icons
; ———————————————
!INFINITY		= $64
!RUPEE			= $F7
!ARROW			= $65
!KEY			= $F9
!BOMB			= $61
!LOW_X			= $62

; Game variables
; ———————————————
!LevelNumber		= $10
!RoutineIndex		= $13
!PendingPpuMacro	= $14
!SaveSlot		= $16
!CurrentMapLocation	= $EB
!NewMapLocation		= $EC
!OAM_MapBlipY		= $0254

; Game routines
; ———————————————
!BankSwap		= $FFAC
!SendPpuMacro		= $A0F6

; Our addresses
; ———————————————
!MapTiles		= $AD00	; 06:AD00
!VRAM_MapTiles		= $1300

; Our variables
; ———————————————
!tileFlag		= $0628		; Used to indicate that there is a pending PPU macro for the map. Changed from $6C00 -> $0628 to fix a bug of Dungeon palettes being overwritten with $00. ($6C30, $6CB4)
!mapVar			= !tileFlag+1	; Temporary storage variable
!mapVar_X		= !tileFlag+2
!mapVar_Y		= !tileFlag+3
!mapLoop_X		= !tileFlag+4
!mapLoop_Y		= $0673		; !tileFlag+5

!disable_animation	= $07FF

!SecondPpuStringIndex	= $7F10
!MapBits_Left		= !SecondPpuStringIndex+1	; Stores flags for whether the two screens in the left/right side
!MapBits_Right		= !SecondPpuStringIndex+2	; of the current map tile have been visited, in lower 2 bits
!MapFilter_Top		= !SecondPpuStringIndex+3	; Stores a value to be ANDed with the bytes of a map tile to black out unvisited screens
!MapFilter_Bottom	= !SecondPpuStringIndex+4
!MapTileMacro		= !SecondPpuStringIndex+5	; 10 bytes of tile data, 2 byte pointer, 1 byte len specifier, 1 byte FF terminator
; TempAddress:	dw 1
!MapBlipY		= $7F29	; SecondPpuStringIndex+19, Stores the y-coordinate of the map blip

!MapRam			= $7F50
!MapSaveRam		= $7F60	; MapRam+10

; Registers
; ———————————————
!PpuControl1		= $2000
!PpuControl2		= $2001
!PpuStatus		= $2002
!OamAddress		= $2003
!OamData		= $2004
!PpuScroll		= $2005
!PpuAddress		= $2006
!PpuData		= $2007


;************************************
;	Magic key tile index
;************************************
; This byte specifies the tile index to use for the key count when player has the magic key

; $64 is the value for the new "Infinite" symbol
%org($A5A1,1)		; 0x065B1
	lda #!INFINITY	; Originally A9 0A (LDA #$0A)


;************************************
;	Map blip blinking
;************************************
; New blip pattern
%org($845F,2)		; 0x0846F
	;db $E0,$E0,$E0,$00,$00,$00,$00,$00,$E0,$A0,$E0,$00,$00,$00,$00,$00


; Corrects positioning of map blip
;	:71F7:	LDA #$11	; A = left edge of map
 
; Blip update routine
; ——————
%org($BDF0,5)		; 0x17E00 - Free space
; Original Automap location at $BC00 (0x17C10)
; Moved for Zelda Redux to allow for more free space range
BlipUpdate:
	pha

; Exit if in a dungeon
	lda !LevelNumber	; Level Number
	bne exitHijack		; Exit Hijack

; Grab the current blip position if it is on-screen
	lda !OAM_MapBlipY	; OAM Map Blip Y
	cmp #$FF		; Compare with $FF
	beq OW_BlipUpdate	; BEQ $03, Branch to OW Blip Update
	sta !MapBlipY	; Map Blip Y

OW_BlipUpdate:	; 0x17C1F
	lda $15	; Get frame counter

; Blink every 32 frames
	lsr
	lsr
	lsr
	lsr
	lsr
	bcc l_BC20	; BCC $08

; Show blip
	lda !MapBlipY	; Map Blip Y
	sta !OAM_MapBlipY	; OAM Map Blip Y
	bne exitHijack		; Exit Hijack

l_BC20:		; 0x17E20
; Hide blip
	lda #$FF		; Load value $FF into A register
	sta !OAM_MapBlipY	; OAM Map Blip Y

exitHijack:	; 0x17E25
; Exit Hijack
	pla
	jmp $77E7		; Jump to $77E7 (0x07067)


; Hijack
; ———————————————
; Hijack JSR has been moved to the end of the file!

; Safe Blip Update
%org($F322,7)		; 0x1F332, Per-frame update hijack
	jsr SafeBlipUpdate	; Jump to subroutine at $FFD6 ($1FFE6 in PC) - Originally 20 E7 77 (JSR $77E7)
 
; SafeBlipUpdate
; ———————————————
; This routine was placed after DoWholeMapHijack (under "Draw whole map -HIJACK-") below because these two functions must be placed in the fixed bank, together in the small available space.
; This code really belongs under the "Map blip blinking" section, but is placed with DoWholeMapHijack, because
; they need to be placed together in the tiny bit of free space in the fixed bank.


%org($FFD6,7)		; 0x1FFE6
SafeBlipUpdate:
; Only runs the blip-flashing code when it is banked in.
	pha		; Need to preserve A
	lda $8000	; Load address $8000
	cmp #$20	; Is this bank 5? (checking for a known value)
	bne l_FFE2	; BNE $04
	pla
	jmp BlipUpdate	; Jump to Blip Update

l_FFE2:		; 0x1FFF2
	pla
	jmp $77E7 	; Jump to $77E7


;************************************
;	New heart data
; 	(NOT USED FOR REDUX!)
;************************************
; New heart PPU macros
; ———————————————
; The PPU addresses of these macros have been swapped so that the hearts fill the top row before the bottom row.

; Flip heart rows in HUD:
%org($A507,1)		; 0x06517
; First row of hearts
	;db $20,$D6,$08	; Originally 20 B6 08
	;db $24,$24,$24,$24,$24,$24,$24,$24
;%org($A512,1)		; 0x06522
; Second row of hearts
	;db $20,$B6,$08	; Originally 20 D6 08
	;db $24,$24,$24,$24,$24,$24,$24,$24
;%org($BF0E,1)		; 0x1BF1E
; "-LIFE-" (unchanged)
	;db $62,$15,$12,$0F,$0E,$62


; New heart tiles
; ———————————————
;%org($8C8F,3)		; 0x08C9F
	;db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$DE,$FE,$FE,$7C,$38,$10 ; Partial hearts
	;db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$9E,$9E,$FE,$7C,$38,$10
	;db $6C,$EE,$EE,$EE,$EE,$5C,$38,$10,$6C,$9E,$9E,$9E,$9E,$7C,$38,$10
	;db $6C,$EE,$EE,$EE,$EE,$6C,$38,$10,$6C,$9E,$9E,$9E,$9E,$5C,$28,$10
	;db $6C,$FE,$EE,$EE,$F6,$7C,$38,$10,$6C,$9E,$9E,$9E,$8E,$44,$28,$10
	;db $6C,$FE,$EE,$FE,$FE,$7C,$38,$10,$6C,$9E,$9E,$82,$82,$44,$28,$10
	;db $6C,$FA,$E6,$FE,$FE,$7C,$38,$10,$6C,$9E,$9A,$82,$82,$44,$28,$10
	;db $6C,$FA,$E6,$FE,$FE,$7C,$38,$10,$6C,$9E,$9A,$82,$82,$44,$28,$10
	;db $6C,$9E,$9A,$B2,$F2,$6C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;%org($8E7F,3)		; 0x08E8F
	;db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$DE,$FE,$FE,$7C,$38,$10 ; Whole heart



;************************************
;	Map PPU Macros
;************************************
; New tilemap for the map to allow each tile to be unique.
 
; PPU transfers for Automap tiles in the HUD and Subscreen
%org($934F,6)		; 0x1935F
; Whole overworld map
	db $20,$62,$08
	; db $30,$30,$30,$30,$30,$30,$30,$30
	db $30,$31,$32,$33,$34,$35,$36,$37

	db $20,$82,$08
	; db $30,$30,$30,$30,$30,$30,$30,$30
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F

	db $20,$A2,$08
	; db $30,$30,$30,$30,$30,$30,$30,$30
	db $40,$41,$42,$43,$44,$45,$46,$47

	db $20,$C2,$08
	; db $30,$30,$30,$30,$30,$30,$30,$30
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F 

; Terminator
	db $FF


;************************************
;	New Map Attribute
;************************************
; Used to apply the proper palette for the overworld map.
 
; This is the original routine that queues the PPU macro that sets HUD palettes
;05:B005:A9 18		LDA #$18
;05:B007:D0 0F		BNE $B018
;05:B009:A9 D0		LDA #$D0
;05:B00B:A0 17		LDY #$17
;05:B00D:4C 01 85	JMP $8501
;05:B010:A9 E8		LDA #$E8
;05:B012:A0 2F		LDY #$2F
;05:B014:D0 F7		BNE $B00D
;05:B016:A9 0E		LDA #$0E
;05:B018:85 14		STA $0014 = #$00
;05:B01A:E6 13		INC $0013 = #$05
;05:B01C:60		RTS

!OriginalHudAttributeMacro	= $A2D3

; Hijack the routine that queues the attribute macro
%org($B01A,5)		; 0x1702A
	jmp NewHudMacroSelector	; Jump to NewHudMacroSelector routine at $AF20, or 16F30 in PC - Originally E6 13 60 (INC $13, RTS)


; Map palette selection routine
; ———————————————
; If the overworld map attribute macro is queued in a level, we swap in the dungeon map attribute macro (since we’ve changed the overworld map macro)

%org($AF20,5)		; 0x16F30
NewHudMacroSelector:
; Skip this routine for overworld
	lda !LevelNumber	; Load LevelNumber
 	beq l_AF2E	; BEQ $0A, Branch if equal to $00

; Only run this routine if the pending macro is the HUD attribute macro
	lda !PendingPpuMacro	; Load PendingPpuMacro RAM address
	cmp #$0E	; Compare with $0E
	bne l_AF2E	; BNE $04, Branch if not equal to $0E

; Change 0E to 7E to load dungeon hud attributes
	lda #$7E	; Load value $7E into A register
	sta !PendingPpuMacro	; Store at PendingPpuMacro RAM address

l_AF2E:		; 0x16F3E
	inc !RoutineIndex	; Increment value at RAM $13
	rts


; Modifications to PPU macro pointer table
; ———————————————
; Pointer to below attributes (new overworld attribute macro)
%org($A00E,6)		; 0x1A01E
; Repoint the subscreen palette mappings for the new Automap tiles
	dw OverworldAttributeData	; New overworld map attribute macro (Pointer to $BEF0) - Originally D3 A2 (Pointer to $A2D3 or $1A2E3 in PC)

%org($A07E,6)		; 0x1A08E
; Repoint Original Hud Attribute Macro, Original attribute macro to be used for dungeons
	dw !OriginalHudAttributeMacro	; D3 A2 (Pointer to $A2D3) - Originally 02 03 (Pointer to $0302)


; New attribute data
; Attribute table and tilemap for the Automap graphics in the HUD and Subscreen
%org($BEF0,6)		; 0x1BF00
OverworldAttributeData:
; New data to change map colors
	db $23,$C0,$10		; PPU Transfer $23C0
	db $C0,$FF,$70,$00,$00,$44,$55,$55	; Attribute table for HUD
	db $C0,$AF,$36,$00,$00,$44,$55,$55	; Attribute table for HUD, originally db $FF,$FF,$37,$00,$00,$44,$55,$55 for brown map

; This is additional macros from the original data. It needs to be part of the same PPU macro string.
	db $20,$6F,$0E		; PPU Transfer to $206F
	db $69,"B",$6B,$69,"A",$6B,$24,$24,$2F,"LIFE",$2F	; Tiles for item rectangles, B/A and -LIFE-
	db $20,$CF,$06		; PPU Transfer to $20CF
	db $6E,$6A,$6D,$6E,$6A,$6D	; Tiles for the bottom of the HUD rectangles
	db $20,$8F,$C2,$6C	; PPU Transfer for side lines of HUD rectangles
	db $20,$91,$C2,$6C	; PPU Transfer for side lines of HUD rectangles
	db $20,$92,$C2,$6C	; PPU Transfer for side lines of HUD rectangles
	db $20,$94,$C2,$6C	; PPU Transfer for side lines of HUD rectangles
	db $20,$6B,$84,!RUPEE,!KEY,!ARROW,!BOMB,$FF	; PPU Transfer for Rupee, (Empty), Key and Bomb icons in HUD (Jumps 0x20 in PPU per icon)
	db $29,$84,$09		; PPU Transfer to $2984
	db "INVENTORY"		; Tiles for "INVENTORY"

; Terminator
	db $FF


;************************************
;	Save/Load/Delete hijacks
;************************************

; Delete Map Hijack - Register Name
; ———————————————
%org($A2C7,2)		; 0x0A2D7
	jsr DeleteMap_RegisterName	; Jump to DeleteMap_RegisterName routine at $B020 (or $0B030 in PC) - Originally 20 64 A7 (JSR $A764, or $0A774 in PC)

; Load Hijack
; ———————————————
%org($A5FE,2)		; 0x0A60E
	jsr LoadMapData	; Jump to LoadMapData routine at $B010 (or $0B020 in PC) - Originally 20 25 E6 (JSR $E625, or $1E635 in PC)
!LoadHijackReturn	= $E625

; Save Hijack
; ———————————————
%org($A77A,2)		; 0x0A78A
	jsr SaveMapData	; Jump to SaveMapdata routine at $B000 (or $0B010 in PC) - Originally 20 2A 9D (JSR $9D2A, or $9D3A in PC)
!SaveHijackReturn	= $9D2A

; Delete Map Hijack 2 – Second Quest
; ———————————————
%org($ABB5,2)		; 0x0ABC5
	jmp DeleteMap_SecondQuest	; Jump to DeleteMap_SecondQuest routine at $B026 (or $0B036 in PC) - Originally 20 64 A7 (JMP $AF5A, or $0AF6A in PC)


;************************************
;	Save/Load/Delete routines
;************************************

; Save map data
; ———————————————
%org($B000,2)		; 0x0B010 - Free space
SaveMapData:
	jsr PrepLoadSaveIndexers	; Jump to PrepLoadSaveIndexers routine
l_B003:		; B003:
	lda !MapRam,x	; Load MapRam,X
	sta !MapSaveRam,y	; Store at MapSaveRam,Y address
	dey
	dex
	bpl l_B003	; BPL $F6
	jmp !SaveHijackReturn	; Jump to SaveHijackReturn code

; Load map data
; ———————————————
LoadMapData:
	jsr PrepLoadSaveIndexers	; Jump to PrepLoadSaveIndexers routine
l_B013:		; B013:
	lda !MapSaveRam,y	; Load MapSaveRam,Y
	sta !MapRam,x	; Store at MapRam,X address
	dey
	dex
	bpl l_B013	; BPL $F6
	jmp !LoadHijackReturn	; Jump to LoadHijackReturn code

; Delete routines
; ———————————————
DeleteMap_RegisterName:
	jsr DeleteMap	; Jump to DeleteMap routine
	jmp $A764	; Return from hijack
DeleteMap_SecondQuest:
	jsr DeleteMap	; Jump to DeleteMap routine
	jmp $AF5A	; Return from hijack

; Delete map data
; ———————————————
DeleteMap:
	ldx #$0F	; Load value $0F on X register
	lda #$00	; Load value $00 on A register
l_B030:		; B030:
	sta !MapRam,x	; Store at MapRam,X address
	dex
	bpl l_B030	; BPL $FA
	rts

; Common routines
; ———————————————
PrepLoadSaveIndexers:
; Sets the Y register to point to the end of the player’s map save data (MapSaveRam,Y), and sets X to point to the end of map data ram.
	ldy #$0F	; Load $0F on Y register
	ldx !SaveSlot	; Load Save slot 1
	beq l_B044	; BEQ $07
	ldy #$1F	; Load Save slot 2
	dex
	beq l_B044	; BEQ $02
	ldy #$2F	; Load Save slot 3
l_B044:		; B044:
	ldx #$0F	; Load value $0F on X register
	rts


;************************************
;	Update map spot
;************************************
; Updates a single tile on the map as the player walks around


; Hijack
; ———————————————
%org($A8BE,5)		; 0x168CE
!UpdateMapSpotReturn	= $A9F4
	jsr $85A0	; Jump to subroutine at $85A0 (or $145B0 in PC) - Originally 20 F4 A9 (JSR $A9F4, or $16A04 in PC)


; Update routine
; ———————————————
UpdateMapSpot:
%org($85A0,5)		; 0x145B0
; Update map data
	lda !CurrentMapLocation	; Load CurrentMapLocation
	and #$0F	; Get X-coordinate
	tax		; Used to index into map data
	lsr		; Push tile-X onto stack
	pha
	lda !CurrentMapLocation	; Load CurrentMapLocation
	lsr		; A /= 16 (Get map Y)
	lsr
	lsr
	lsr
	tay

	lsr
	pha		; Push Tile-Y onto stack

; Set bit for y location
	lda #$01	; Load $01
	cpy #$00	; Compare $00,Y
	beq l_85BA	; BEQ $04

l_85B6:		; 0x85B6:
	asl
	dey
	bne l_85B6	; BNE FC

l_85BA:		; 0x85BA:
	ora !MapRam,x	; Or MapRam,X
	sta !MapRam,x	; Store at MapRam,X address

; Pull tile index into registers
	pla
	tay
	pla
	tax
	jsr UpdateMapTile	; Jump to UpdateMapTile routine

; RTS
	jmp !UpdateMapSpotReturn	; Jump to UpdateMapSpotReturn


;************************************
;	Update map tile
;************************************
; Processes map data and invokes the rendering routine.
; Used by "Update map spot" and "draw whole map" code

!PlayerMapData	= $7F50
!PpuMapMacroBase	= $6BCD	; Map macros
!SingleTileMacro	= $6BFA	; Single map tile macro
!SingleTileMacroByte	= $6BFD
!PpuMapMacroLen	= $0B	; 11 Bytes: 8 tiles + 3-byte header
!MapTiles	= $30

; Original Automap location at $BC30 (0x17C40)
; Moved for Zelda Redux to allow for more free space range
%org($BE19,5)		; 0x17E29 - Free space
UpdateMapTile:
;————————
; A – Unused
; X – Tile X
; Y – Tile Y
l_BE19:		; 0x17E29
	stx !mapVar_X	; Store mapVar_X
	sty !mapVar_Y	; Store mapVar_Y

	txa		; X = X * 2
	asl
	tax

; We need to extract four bits out of the player’s "explored map data" and use them as a tile index
	lda !MapRam,x	; Load map byte, MapRam,X
	jsr ProcessMapByte	; Get relevant two bits, ProcessMapByte
	sta !mapVar		; Store semi-calculated tile value, mapVar
 	sta !MapBits_Left	; Store at MapBits_Left address

	ldy !mapVar_Y	; Load mapVar_Y
	lda !MapRam+1,x	; Get next map byte, MapRam +1,X
	jsr ProcessMapByte	; Get relevant two bits, ProcessMapByte
	sta !MapBits_Right	; Store to MapBits_Right address

; Set flag to update single tile on screen
	lda #$01		; Load $01
	sta !tileFlag	; Store at tileFlag address $0628
	jsr RenderMapTile	; Jump to RenderMapTile routine
	rts

ProcessMapByte:	 ; 0x17E43
; Takes a player-map data byte and gets the relevant two bits out of it
;	A – Map byte
;	Y – Map Tile Y
; Return via A
;	A = A >> (Y * 2) | 3

l_BE43:		; 0x17E53
	cpy #$00	; While Y != 0
	beq l_BE4C	; BEQ $05
l_BE47:		; 0x17E57
	lsr		; A >> 2
	lsr
	dey		; Y-
	bne l_BE47	; BNE $FB
l_BE4C:		; 0x17E5C
	and #$03	; A
	rts


;************************************
;	Draw whole map
;************************************

DrawWholeMap:	; 0x17E5F
	jmp DrawMapAllBanks	; Head over to a subroutine to loop through each bank
DoDrawWholeMap: 
; Prepare PPU to write map data
	lda $2002		; AD 02 20 -> PPU_STATUS = #$30
	lda.b #!VRAM_MapTiles>>8	; Set PPU address #>VRAM_MapTiles (High byte)
	sta $2006		; 8D 06 20 -> PPU_ADDRESS = #$00
	lda.b #!VRAM_MapTiles		; Set PPU address #>VRAM_MapTiles (Low byte)
	sta $2006		; 8D 06 20 -> PPU_ADDRESS = #$00

	lda #$00		; Loop over Y
	sta !mapLoop_Y	; Store at mapLoop_Y address
l_BE64:		; $BE64, 0x17E74
	lda #$00		; Loop over X
	sta !mapLoop_X	; Store at mapLoop_X address
l_BE69:		; $BE69, 0x17E79
	ldx !mapLoop_X	; Render one map tile (mapLoop_X)
	ldy !mapLoop_Y	; Render one map tile (mapLoop_Y)
	jsr UpdateMapTile	; Jump to Update Map Tile routine ($BC30)

	txa		; Send to PPU (preserve registers)
	pha
	jsr SendTileToPPU	; Jump to Send Tile to PPU routine ($BCA2)
	pla
	tax

	inc !mapLoop_X	; Increase value of mapLoop_X
	lda !mapLoop_X	; Load value of mapLoop_X
	cmp #$08		; Compare with $08
	bne l_BE69		; BNE $E6

	inc !mapLoop_Y	; Increase value of mapLoop_Y
	lda !mapLoop_Y	; Load value of mapLoop_Y
	cmp #$04		; Compare with $04
	bne l_BE64		; BNE $D7

	rts

SendTileToPPU:	; $BE8E, 0x17E9E
	ldx #$00	; A2 00
l_BE90:		; $BE90, 0x17EA0:
	lda !MapTileMacro+3,x	; Load tile data byte of MapTileMacro+3,X
	sta $2007	; Write to PPU -> PPU_DATA = #$90
	inx
	cpx #$10	; Compare with $10
	bne l_BE90	; D0 F5

	rts


;************************************
;	Map tile rendering
;************************************

RenderMapTile:
; Parameters
;	– mapVar_X :		Tile X
;	– mapVar_Y :		Tile Y
;	– mapBits_Left:		Bit-0 = TL screen discovered, Bit-1 = BL screen discovered
;	– mapBits_Right:	Bit-0 = TR screen discovered, Bit-1 = BR screen discovered


; Preserve zp variables
	lda $00	; A5 00
	pha
	lda $01	; A5 01
	pha

; Calculate the source address of tile data, to copy to macro
; and the PPU dest address to write to the macro.
; Address = BaseAddress + tileX * $10 + tileY * $80
; Y = tileY / 2
; Set x to low byte of pointer (will be 00 or 80)
	ldx #$00	; Low byte of src/dest pointers
	lda !mapVar_Y	; Add mapVar_Y
	lsr
	tay
	bcc l_BEAD	; If carry was set (Y was odd), add 80 to low byte of pointers

	ldx #$80	; Load value $80 into X register
l_BEAD:		; $BEAD, 0x17EBD:
	stx $00	; Write low byte of pointer
	lda !mapVar_X	; Add mapVar_X * #$10 to $00
	asl
	asl
	asl
	asl
	clc
	adc $00	; Add $00

; Write low byte of ROM source and PPU dest (low byte will be same on both)
	sta $00	; Store at RAM $00
	sta !MapTileMacro+1	; Store at Map tile macro address + 1

; Calculate high byte of source pointer
	tya
	adc #$AD	; Add $AD
	sta $01	; Store at RAM address $01

; Calculate high bte of destination pointer
	tya
	adc #$13	; Add $13
	sta !MapTileMacro	; Store at Map tile macro address

; Write macro-length
	lda #$10	; Load value $10
	sta !MapTileMacro+2	; Store at Map tile macro address + 2


; Run this code twice to create two bit filters (to be ANDed) for tile data, one for top half, one for bottom
; This "blacks out" map areas that have not been visited.
	ldy #$00	; A0 00	
MapBitLoop:	; $BED0, 0x17EE0:
	lda #$FF	; Load value $FF
	lsr !MapBits_Left	; Grab low bit (for top-left or bottom-left)
 	bcs l_BED9	; BCS $02
	and #$0F	; If clear, AND out high nibble

l_BED9:		; $BED9, 0x17EE9:
	lsr !MapBits_Right	; Grab low bit (for top-right or bottom-right)
	bcs l_BEE0	; BCS $02
	and #$F0	; If clear, AND out low nibble
l_BEE0:		; $BEE0, 0x17EF0:
	sta !MapFilter_Top,y	; Store at MapFilter_Top address
	iny		; Increment Y register
	cpy #$02	; Compare to $02
	bne MapBitLoop	; Branch if not equal to Map Bit Loop


; Copy 10 bytes of tile data. We use four loops:
; 	-Top half, first plane
;	-Bottom half, first plane
;	-Top half, second plane
;	-Bottom half, second plane
	ldy #$03	; Load value $03 into Y register
l_BEEA:		; $BEEA, 0x17EFA:
	lda ($00),y	; Load RAM $00,Y
	and !MapFilter_Top	; Compare with MapFilter_Top address
	sta !MapTileMacro+3,y	; Store at Map tile macro address + 3,Y
	dey
	bpl l_BEEA	; BPL $F5

	ldy #$07	; Load value $07 into Y register
l_BEF7:		; $BEF7, 0x17F07:
	lda ($00),y	; Load RAM $00,Y
	and !MapFilter_Bottom	; Compare with MapFilter_Bottom address
	sta !MapTileMacro+3,y	; Store at Map tile macro address + 3,Y
	dey
 	cpy #$03	; Compare with $03 on Y register
	bne l_BEF7	; BNE $F3

	ldy #$0B	; Load value $0B into Y register
l_BF06:		; $BF06, 0x17F16:
	lda ($00),y	; Load RAM $00,Y
	and !MapFilter_Top	; Compare with MapFilter_Top address
	sta !MapTileMacro+3,y	; Store at Map tile macro address + 3,Y
	dey
	cpy #$07	; Compare with $07 on Y register
	bne l_BF06	; BNE $F3

	ldy #$0F	; Load value $0F into Y register
l_BF15:		; $BF15, 0x17F25:
	lda ($00),y	; Load RAM $00,Y
	and !MapFilter_Bottom	; Compare with MapFilter_Bottom address
	sta !MapTileMacro+3,y	; Store at MapTileMacro address + 3,Y
	dey
	cpy #$0B	; Compare with $0B on Y register
	bne l_BF15	; BNE $F3

; Write terminator to end of macro
	lda #$FF	; Load value $FF into A register
	sta !MapTileMacro+$13	; Store at Map Tile Macro address + $13

; Restore zero-page
	pla
	sta $01	; Store at RAM $01
	pla
	sta $00	; Store at RAM $00
	rts


;************************************
;	Partial heart routine
;************************************
; Modified by ShadowOne333 to allow 1/4 hearts decrements instead of the original 1/8

PartialHeartRoutine:	; 0x17F3E, $BF2E
; 1/4 Hearts subroutine
	lda $0670	; Originally LDA $0F (A5 0F) - Can be changed for AD 70 06 for direct access to the heart damage in RAM
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr		; Added another LSR so that the hearts are now in 1/4 drops instead of 1/8
	clc
	adc #$50	; 69 50
	jmp $6ED7	; Jump to $6ED7, or $06757 in PC address. Return to the original code for hearts


;******************************************
; Draw Map on all banks for MMC1 Animation (by frantik)
;******************************************
%org($BFC0,5)		; 0x17FD0, $BFC0
; This draws the map on all the banks
DrawMapAllBanks:
; Update all 4 banks if animation is enabled and only 1 bank otherwise
	lda #$04
	ldy !disable_animation
	beq +
	lda #01
+
	sta $7FF0

DrawMapLoop:
	lda $7FF0
	jsr SetChrBank

	jsr DoDrawWholeMap

	dec $7FF0
	bne DrawMapLoop
	rts

SetChrBank:
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000

	rts 

; Hijack
; ———————————————
 
; Original code
;	(1):6EC8:C9 80	CMP #$80	; If partial-heart-value >= #$80, load full-heart-tile
;	:6ECA:B0 F4	BCS $6EC0
;	:6ECC:A9 00	LDA #$00	; ??????????????
;	:6ECE:8D 29 05	STA $0529
;	(2):6ED1:A9 65	LDA #$65	; Load half-full heart tile
;	:6ED3:D0 02	BNE $6ED7	; Branch always

;	(1) – Update value of CMP #$80 to run our partial heart routine for smaller increments
;	(2) – Hijack goes here

; Changes the break point for when to change the heart sprite when losing health, to take into account the new 1/4 hearts drop
%org($A738,1)		; 0x06748, This code runs from RAM
	cmp #$C0	; Originally C9 80 (CMP #$80) - (CMP #$F8 in original Automap) 

%org($A741,1)		; 0x06751
; Jump to PartialHeartRoutine at $BD42 ($17D52 in PC address) - Originally A9 65 D0 02 (LDA #$65, BNE $A747 or $6757 in PC)
	jmp PartialHeartRoutine

; Originally $02 - NOP a leftover byte the original Automap code forgot
	nop


;************************************
;	Draw whole map hijack
;************************************

; Hijack
; ———————————————
%org($8089,6)		; 0x18099 - Free space
; Jump to Do Whole Map Hijack code
	jmp DoWholeMapHijack	; Jump to $FFC0 (or $1FFD0 in PC) - Originally E6 11 60 (INC $11, RTS)


; Hijack code
; ———————————————
; This routine must go in the fixed bank because bank-swapping is
; needed to run the desired code.

%org($FFC0,7)		; 0x1FFD0 - Start of Unused Space
DoWholeMapHijack:
	lda !LevelNumber	; Only run this routine for the overworld
	bne Exit	; BNE $0D, Branch to exit

; Load Bank 5
	lda #$05	; The code we want to run is in a different bank than is currently loaded
	jsr !BankSwap	; Jump to Bank swap routine

	jsr DrawWholeMap	; Jump to Draw whole map routine

; Load Bank 6
	lda #$06	; This is the bank that was previously loaded
	jsr !BankSwap	; Jump to Bank swap routine

Exit:		; $FFD1, 0x1FFE1
; Displaced code
	inc $11	; Increment value at RAM $11
	rts


;************************************
;	PPU Transfers
;************************************
; WholeMapMacro = $6BCD

; PPU Update hijack
; ———————————————
%org($E4C1,7)		; 0x1E4D1
; Jump to subroutine at $9D70, Originally 20 80 A0 (JSR $A080)
	jsr $9D70

; PPU Transfer
; ———————————————
%org($9D70,6)		; 0x19D80
; Call displaced code
	jsr $A080

	lda !LevelNumber	; If we aren't in overworld, clear flag and return
	bne ClearAndReturn	; Clear and Return, BNE $10
; This bis is from the old automap (without an actual image of overworld)
	ldx !tileFlag	; Load tile flag
	beq rtn			; Return, BEQ $10
	txa

	; Use the tile flag to keep track of which CHR bank we are on. Increment each time we visit this function.
	; This will allow us to update each bank, one time per frame. (by frantik)	
	jsr SetChrBank_6 
	lda.b #!MapTileMacro	; Load Map tile macro low byte
	sta $00		; Store $00
	lda.b #!MapTileMacro>>8	; Load Map tile macro high byte
	sta $01		; Store $01
	jsr !SendPpuMacro	; Jump to Send PPU Macro routine

ClearAndReturn:	; $9D87, 0x19D97 <-- this may have changed now
	lda !disable_animation
	bne +
	inc !tileFlag
	ldx !tileFlag
	cpx #$05		; Are we done with bank 4? If so, then reset the flag, otherwise exit and do it again next frame
	bcc rtn
+
	lda #$00		; Clear tile flag
; NOP to fix palettes in dungeons not being properly restored after exiting stairs (by gzip)
	sta !tileFlag	; Store in Tile Flag $0628

rtn:		; $9D8C, 0x19D9C
	rts

SetChrBank_6:
	sta $C000
	lsr
	sta $C000
 	lsr
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000

 	rts 


;************************************
;	Fast life fill
;************************************
; Causes life to fill faster with potion/fairy

%org($B1F2,5)		; 0x17202
	cmp #$D7	; Originally CMP $F8
	bcs l_B1FD	; Jump to routine to set current heart to 0 and increment full-heart count
	clc		; Add #$06 to current heart value (out of #$100), and return
	adc #$18	; Originally ADC #$06
	sta $0670	; Store at heart address
	rts
l_B1FD:		; 0x1720D
	lda #$00	; Load $00
	sta $0670	; Store at heart address
	jsr $746C	; Jump to routine at $746C
	bne l_B214	; Branch to life increment
	dec $0670	; Decrement Heart/Life value
	lda #$00	; Load $00
	sta $052E	; Store at address to disable sword
	sta $63	; Store at address $63 (?)
	sta $E0	; Store at address for Game Pause
	rts
l_B214:		; 0x17224
	inc $066F	; Increment filled hearts
	rts


;************************************
;	PPU transfers for mini tiles?
;************************************
%org($A0A2,6)		; 0x1A0B2
l_A0A2:
	pha
	sta $2006
	iny
	lda ($00),y
	sta $2006
	iny
	lda ($00),y
	asl
	pha
	lda $FF
	ora #$04
	bcs l_A0B9
	and #$FB
l_A0B9:
	sta !PpuControl1
	sta $FF
	pla
	asl
	php
	bcc l_A0C6
	ora #$02
	iny
l_A0C6:
	plp
	clc
	bne l_A0CB
	sec
l_A0CB:
	ror
	lsr
	tax
l_A0CE:
	bcs l_A0D1
	iny
l_A0D1:
	lda ($00),y
	sta !PpuData
	dex
	bne l_A0CE
	pla
	cmp #$3F
	bne l_A0EA
	sta !PpuAddress
	stx !PpuAddress
	stx !PpuAddress
	stx !PpuAddress
l_A0EA:
	sec
	tya
	adc $00
	sta $00
	lda #$00
	adc $01
	sta $01
;	--------sub start--------
	lda !PpuStatus
	ldy #$00
	lda ($00),y
	bpl l_A0A2
	rts

