//***********************************************************
//		AUTOMAP PLUS (BY SNARFBLAM)
//	       Disassembled and modified for
//	   1/4 hearts decrements by ShadowOne333
//*********************************************************** 

//****************************************
//	Table file
//****************************************
// Font table required for attribute tables definitions
table code/text/text.tbl,ltr


//****************************************
//	Map image
//****************************************

bank 5; org $AD00	// 0x16D10-0x16F0C
// Automap tilemap (Filling map tiles)
	incbin code/gameplay/automap_tiles.bin


//****************************************
//	Variable declarations
//****************************************

// HUD Icons
// ———————————————
define	INFINITY	$64
define	RUPEE		$F7
define	ARROW		$65
define	KEY		$F9
define	BOMB		$61
define	LOW_X		$62

// Game variables
// ———————————————
define	LevelNumber		$10
define	RoutineIndex		$13
define	PendingPpuMacro		$14
define	SaveSlot		$16
define	CurrentMapLocation	$EB
define	NewMapLocation		$EC
define	OAM_MapBlipY		$0254

// Game routines
// ———————————————
define	BankSwap	$FFAC
define	SendPpuMacro	$A0F6

// Our addresses
// ———————————————
define	MapTiles	$AD00	// 06:AD00
define	VRAM_MapTiles	$1300

// Our variables
// ———————————————
define	tileFlag	$0628	// Used to indicate that there is a pending PPU macro for the map. Changed from $6C00 -> $0628 to fix a bug of Dungeon palettes being overwritten with $00. ($6C30, $6CB4)
define	mapVar		{tileFlag}+1	// Temporary storage variable
define	mapVar_X	{tileFlag}+2
define	mapVar_Y	{tileFlag}+3
define	mapLoop_X	{tileFlag}+4
define	mapLoop_Y	$0673	// {tileFlag}+5

define	disable_animation	$07FF

define	SecondPpuStringIndex	$7F10
define	MapBits_Left	{SecondPpuStringIndex}+1	// Stores flags for whether the two screens in the left/right side
define	MapBits_Right	{SecondPpuStringIndex}+2	// of the current map tile have been visited, in lower 2 bits
define	MapFilter_Top	{SecondPpuStringIndex}+3	// Stores a value to be ANDed with the bytes of a map tile to black out unvisited screens
define	MapFilter_Bottom	{SecondPpuStringIndex}+4
define	MapTileMacro	{SecondPpuStringIndex}+5	// 10 bytes of tile data, 2 byte pointer, 1 byte len specifier, 1 byte FF terminator
// TempAddress:	dw 1
define	MapBlipY	$7F29	// SecondPpuStringIndex+19, Stores the y-coordinate of the map blip

define	MapRam		$7F50
define	MapSaveRam	$7F60	// MapRam+10

// Registers
// ———————————————
define	PpuControl1	$2000
define	PpuControl2	$2001
define	PpuStatus	$2002
define	OamAddress	$2003
define	OamData		$2004
define	PpuScroll	$2005
define	PpuAddress	$2006
define	PpuData		$2007


//************************************
//	Magic key tile index
//************************************
// This byte specifies the tile index to use for the key count when player has the magic key

bank 1; org $A5A1	// 0x065B1
// $64 is the value for the new "Infinite" symbol
	lda.b #{INFINITY}	// Originally A9 0A (LDA #$0A)


//************************************
//	Map blip blinking
//************************************
// New blip pattern
//bank 2; org $845F	// 0x0846F
	//db $E0,$E0,$E0,$00,$00,$00,$00,$00,$E0,$A0,$E0,$00,$00,$00,$00,$00


// Corrects positioning of map blip
//	:71F7:	LDA #$11	; A = left edge of map
 
// Blip update routine
// ——————
bank 5; org $BDF0	// 0x17E00 - Free space
// Original Automap location at $BC00 (0x17C10)
// Moved for Zelda Redux to allow for more free space range
BlipUpdate:
	pha

// Exit if in a dungeon
	lda.b {LevelNumber}	// Level Number
	bne exitHijack		// Exit Hijack

// Grab the current blip position if it is on-screen
	lda.w {OAM_MapBlipY}	// OAM Map Blip Y
	cmp.b #$FF		// Compare with $FF
	beq OW_BlipUpdate	// BEQ $03, Branch to OW Blip Update
	sta.w {MapBlipY}	// Map Blip Y

OW_BlipUpdate:	// 0x17C1F
	lda.b $15	// Get frame counter

// Blink every 32 frames
	lsr
	lsr
	lsr
	lsr
	lsr
	bcc l_BC20	// BCC $08

// Show blip
	lda.w {MapBlipY}	// Map Blip Y
	sta.w {OAM_MapBlipY}	// OAM Map Blip Y
	bne exitHijack		// Exit Hijack

l_BC20:		// 0x17E20
// Hide blip
	lda #$FF		// Load value $FF into A register
	sta.w {OAM_MapBlipY}	// OAM Map Blip Y

exitHijack:	// 0x17E25
// Exit Hijack
	pla
	jmp $77E7		// Jump to $77E7 (0x07067)


// Hijack
// ———————————————
// Hijack JSR has been moved to the end of the file!

bank 7; org $F322	// 0x1F332, Per-frame update hijack
// Safe Blip Update
	jsr SafeBlipUpdate	// Jump to subroutine at $FFD6 ($1FFE6 in PC) - Originally 20 E7 77 (JSR $77E7)
 
// SafeBlipUpdate
// ———————————————
// This routine was placed after DoWholeMapHijack (under "Draw whole map -HIJACK-") below because these two functions must be placed in the fixed bank, together in the small available space.
// This code really belongs under the "Map blip blinking" section, but is placed with DoWholeMapHijack, because
// they need to be placed together in the tiny bit of free space in the fixed bank.


bank 7; org $FFD6	// 0x1FFE6
SafeBlipUpdate:
// Only runs the blip-flashing code when it is banked in.
	pha		// Need to preserve A
	lda.w $8000	// Load address $8000
	cmp.b #$20	// Is this bank 5? (checking for a known value)
	bne l_FFE2	// BNE $04
	pla
	jmp BlipUpdate	// Jump to Blip Update

l_FFE2:		// 0x1FFF2
	pla
	jmp $77E7 	// Jump to $77E7


//************************************
//	New heart data
// 	(NOT USED FOR REDUX!)
//************************************
// New heart PPU macros
// ———————————————
// The PPU addresses of these macros have been swapped so that the hearts fill the top row before the bottom row.

//bank 1;
// Flip heart rows in HUD:
//org $A507	// 0x06517
// First row of hearts
	//db $20,$D6,$08	// Originally 20 B6 08
	//db $24,$24,$24,$24,$24,$24,$24,$24
//org $A512	// 0x06522
// Second row of hearts
	//db $20,$B6,$08	// Originally 20 D6 08
	//db $24,$24,$24,$24,$24,$24,$24,$24
//org $BF0E	// 0x1BF1E
// "-LIFE-" (unchanged)
	//db $62,$15,$12,$0F,$0E,$62


// New heart tiles
// ———————————————
//bank 3; org $8C8F	// 0x08C9F
	//db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$DE,$FE,$FE,$7C,$38,$10 // Partial hearts
	//db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$9E,$9E,$FE,$7C,$38,$10
	//db $6C,$EE,$EE,$EE,$EE,$5C,$38,$10,$6C,$9E,$9E,$9E,$9E,$7C,$38,$10
	//db $6C,$EE,$EE,$EE,$EE,$6C,$38,$10,$6C,$9E,$9E,$9E,$9E,$5C,$28,$10
	//db $6C,$FE,$EE,$EE,$F6,$7C,$38,$10,$6C,$9E,$9E,$9E,$8E,$44,$28,$10
	//db $6C,$FE,$EE,$FE,$FE,$7C,$38,$10,$6C,$9E,$9E,$82,$82,$44,$28,$10
	//db $6C,$FA,$E6,$FE,$FE,$7C,$38,$10,$6C,$9E,$9A,$82,$82,$44,$28,$10
	//db $6C,$FA,$E6,$FE,$FE,$7C,$38,$10,$6C,$9E,$9A,$82,$82,$44,$28,$10
	//db $6C,$9E,$9A,$B2,$F2,$6C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

//org $8E7F	// 0x08E8F
	//db $6C,$EE,$EE,$EE,$FE,$7C,$38,$10,$6C,$9E,$DE,$FE,$FE,$7C,$38,$10 // Whole heart



//************************************
//	Map PPU Macros
//************************************
// New tilemap for the map to allow each tile to be unique.
 
// PPU transfers for Automap tiles in the HUD and Subscreen
bank 6; org $934F	// 0x1935F
// Whole overworld map
	db $20,$62,$08
	// db $30,$30,$30,$30,$30,$30,$30,$30
	db $30,$31,$32,$33,$34,$35,$36,$37

	db $20,$82,$08
	// db $30,$30,$30,$30,$30,$30,$30,$30
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F

	db $20,$A2,$08
	// db $30,$30,$30,$30,$30,$30,$30,$30
	db $40,$41,$42,$43,$44,$45,$46,$47

	db $20,$C2,$08
	// db $30,$30,$30,$30,$30,$30,$30,$30
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F 

// Terminator
	db $FF


//************************************
//	New Map Attribute
//************************************
// Used to apply the proper palette for the overworld map.
 
// This is the original routine that queues the PPU macro that sets HUD palettes
//05:B005:A9 18		LDA #$18
//05:B007:D0 0F		BNE $B018
//05:B009:A9 D0		LDA #$D0
//05:B00B:A0 17		LDY #$17
//05:B00D:4C 01 85	JMP $8501
//05:B010:A9 E8		LDA #$E8
//05:B012:A0 2F		LDY #$2F
//05:B014:D0 F7		BNE $B00D
//05:B016:A9 0E		LDA #$0E
//05:B018:85 14		STA $0014 = #$00
//05:B01A:E6 13		INC $0013 = #$05
//05:B01C:60		RTS

define	OriginalHudAttributeMacro	$A2D3

// Hijack the routine that queues the attribute macro
bank 5; org $B01A	// 0x1702A
	jmp NewHudMacroSelector	// Jump to NewHudMacroSelector routine at $AF20, or 16F30 in PC - Originally E6 13 60 (INC $13, RTS)


// Map palette selection routine
// ———————————————
// If the overworld map attribute macro is queued in a level, we swap in the dungeon map attribute macro (since we’ve changed the overworld map macro)

org $AF20	// 0x16F30
NewHudMacroSelector:
// Skip this routine for overworld
	lda.b {LevelNumber}	// Load LevelNumber
 	beq l_AF2E	// BEQ $0A, Branch if equal to $00

// Only run this routine if the pending macro is the HUD attribute macro
	lda.b {PendingPpuMacro}	// Load PendingPpuMacro RAM address
	cmp.b #$0E	// Compare with $0E
	bne l_AF2E	// BNE $04, Branch if not equal to $0E

// Change 0E to 7E to load dungeon hud attributes
	lda.b #$7E	// Load value $7E into A register
	sta.b {PendingPpuMacro}	// Store at PendingPpuMacro RAM address

l_AF2E:		// 0x16F3E
	inc.b {RoutineIndex}	// Increment value at RAM $13
	rts


// Modifications to PPU macro pointer table
// ———————————————
// Pointer to below attributes (new overworld attribute macro)
bank 6; org $A00E	// 0x1A01E
// Repoint the subscreen palette mappings for the new Automap tiles
	dw OverworldAttributeData	// New overworld map attribute macro (Pointer to $BEF0) - Originally D3 A2 (Pointer to $A2D3 or $1A2E3 in PC)

org $A07E	// 0x1A08E
// Repoint Original Hud Attribute Macro, Original attribute macro to be used for dungeons
	dw {OriginalHudAttributeMacro}	// D3 A2 (Pointer to $A2D3) - Originally 02 03 (Pointer to $0302)


// New attribute data
// Attribute table and tilemap for the Automap graphics in the HUD and Subscreen
org $BEF0	// 0x1BF00
OverworldAttributeData:
// New data to change map colors
	db $23,$C0,$10		// PPU Transfer $23C0
	db $C0,$FF,$70,$00,$00,$44,$55,$55	// Attribute table for HUD
	db $C0,$AF,$36,$00,$00,$44,$55,$55	// Attribute table for HUD, originally db $FF,$FF,$37,$00,$00,$44,$55,$55 for brown map

// This is additional macros from the original data. It needs to be part of the same PPU macro string.
	db $20,$6F,$0E		// PPU Transfer to $206F
	db $69,"B",$6B,$69,"A",$6B,$24,$24,$2F,"LIFE",$2F	// Tiles for item rectangles, B/A and -LIFE-
	db $20,$CF,$06		// PPU Transfer to $20CF
	db $6E,$6A,$6D,$6E,$6A,$6D	// Tiles for the bottom of the HUD rectangles
	db $20,$8F,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$91,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$92,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$94,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$6B,$84,{RUPEE},{KEY},{ARROW},{BOMB},$FF	// PPU Transfer for Rupee, (Empty), Key and Bomb icons in HUD (Jumps 0x20 in PPU per icon)
	db $29,$84,$09		// PPU Transfer to $2984
	db "INVENTORY"		// Tiles for "INVENTORY"

// Terminator
	db $FF


//************************************
//	Save/Load/Delete hijacks
//************************************

bank 2;
// Delete Map Hijack - Register Name
// ———————————————
org $A2C7	// 0x0A2D7
	jsr DeleteMap_RegisterName	// Jump to DeleteMap_RegisterName routine at $B020 (or $0B030 in PC) - Originally 20 64 A7 (JSR $A764, or $0A774 in PC)

// Load Hijack
// ———————————————
org $A5FE	// 0x0A60E
	jsr LoadMapData	// Jump to LoadMapData routine at $B010 (or $0B020 in PC) - Originally 20 25 E6 (JSR $E625, or $1E635 in PC)
define	LoadHijackReturn	$E625

// Save Hijack
// ———————————————
org $A77A	// 0x0A78A
	jsr SaveMapData	// Jump to SaveMapdata routine at $B000 (or $0B010 in PC) - Originally 20 2A 9D (JSR $9D2A, or $9D3A in PC)
define	SaveHijackReturn	$9D2A

// Delete Map Hijack 2 – Second Quest
// ———————————————
org $ABB5	// 0x0ABC5
	jmp DeleteMap_SecondQuest	// Jump to DeleteMap_SecondQuest routine at $B026 (or $0B036 in PC) - Originally 20 64 A7 (JMP $AF5A, or $0AF6A in PC)


//************************************
//	Save/Load/Delete routines
//************************************

// Save map data
// ———————————————
bank 2; org $B000	// 0x0B010 - Free space
SaveMapData:
	jsr PrepLoadSaveIndexers	// Jump to PrepLoadSaveIndexers routine
l_B003:		// B003:
	lda.w {MapRam},x	// Load MapRam,X
	sta.w {MapSaveRam},y	// Store at MapSaveRam,Y address
	dey
	dex
	bpl l_B003	// BPL $F6
	jmp {SaveHijackReturn}	// Jump to SaveHijackReturn code

// Load map data
// ———————————————
LoadMapData:
	jsr PrepLoadSaveIndexers	// Jump to PrepLoadSaveIndexers routine
l_B013:		// B013:
	lda.w {MapSaveRam},y	// Load MapSaveRam,Y
	sta.w {MapRam},x	// Store at MapRam,X address
	dey
	dex
	bpl l_B013	// BPL $F6
	jmp {LoadHijackReturn}	// Jump to LoadHijackReturn code

// Delete routines
// ———————————————
DeleteMap_RegisterName:
	jsr DeleteMap	// Jump to DeleteMap routine
	jmp $A764	// Return from hijack
DeleteMap_SecondQuest:
	jsr DeleteMap	// Jump to DeleteMap routine
	jmp $AF5A	// Return from hijack

// Delete map data
// ———————————————
DeleteMap:
	ldx.b #$0F	// Load value $0F on X register
	lda.b #$00	// Load value $00 on A register
l_B030:		// B030:
	sta.w {MapRam},x	// Store at MapRam,X address
	dex
	bpl l_B030	// BPL $FA
	rts

// Common routines
// ———————————————
PrepLoadSaveIndexers:
// Sets the Y register to point to the end of the player’s map save data (MapSaveRam,Y), and sets X to point to the end of map data ram.
	ldy.b #$0F	// Load $0F on Y register
	ldx.b {SaveSlot}	// Load Save slot 1
	beq $B044	// BEQ $07
	ldy.b #$1F	// Load Save slot 2
	dex
	beq l_B044	// BEQ $02
	ldy.b #$2F	// Load Save slot 3
l_B044:		// B044:
	ldx.b #$0F	// Load value $0F on X register
	rts


//************************************
//	Update map spot
//************************************
// Updates a single tile on the map as the player walks around


// Hijack
// ———————————————
bank 5; org $A8BE	// 0x168CE
define	UpdateMapSpotReturn	$A9F4
	jsr $85A0	// Jump to subroutine at $85A0 (or $145B0 in PC) - Originally 20 F4 A9 (JSR $A9F4, or $16A04 in PC)


// Update routine
// ———————————————
UpdateMapSpot:
org $85A0	// 0x145B0
// Update map data
	lda.b {CurrentMapLocation}	// Load CurrentMapLocation
	and.b #$0F	// Get X-coordinate
	tax		// Used to index into map data
	lsr		// Push tile-X onto stack
	pha
	lda.b {CurrentMapLocation}	// Load CurrentMapLocation
	lsr		// A /= 16 (Get map Y)
	lsr
	lsr
	lsr
	tay

	lsr
	pha		// Push Tile-Y onto stack

// Set bit for y location
	lda.b #$01	// Load $01
	cpy.b #$00	// Compare $00,Y
	beq l_85BA	// BEQ $04

l_85B6:		// 0x85B6:
	asl
	dey
	bne l_85B6	// BNE FC

l_85BA:		// 0x85BA:
	ora.w {MapRam},x	// Or MapRam,X
	sta.w {MapRam},x	// Store at MapRam,X address

// Pull tile index into registers
	pla
	tay
	pla
	tax
	jsr UpdateMapTile	// Jump to UpdateMapTile routine

// RTS
	jmp {UpdateMapSpotReturn}	// Jump to UpdateMapSpotReturn


//************************************
//	Update map tile
//************************************
// Processes map data and invokes the rendering routine.
// Used by "Update map spot" and "draw whole map" code

define	PlayerMapData	$7F50
define	PpuMapMacroBase	$6BCD	// Map macros
define	SingleTileMacro	$6BFA	// Single map tile macro
define	SingleTileMacroByte	$6BFD
define	PpuMapMacroLen	$0B	// 11 Bytes: 8 tiles + 3-byte header
define	MapTiles	$30


bank 5; org $BE19	// 0x17E29 - Free space
// Original Automap location at $BC30 (0x17C40)
// Moved for Zelda Redux to allow for more free space range
UpdateMapTile:
//————————
// A – Unused
// X – Tile X
// Y – Tile Y

l_BE19:		// 0x17E29
	stx.w {mapVar_X}	// Store mapVar_X
	sty.w {mapVar_Y}	// Store mapVar_Y

	txa			// X = X * 2
	asl
	tax

// We need to extract four bits out of the player’s "explored map data" and use them as a tile index
	lda.w {MapRam},x	// Load map byte, MapRam,X
	jsr ProcessMapByte	// Get relevant two bits, ProcessMapByte
	sta.w {mapVar}		// Store semi-calculated tile value, mapVar
 	sta.w {MapBits_Left}	// Store at MapBits_Left address

	ldy.w {mapVar_Y}	// Load mapVar_Y
	lda.w {MapRam}+1,x	// Get next map byte, MapRam +1,X
	jsr ProcessMapByte	// Get relevant two bits, ProcessMapByte
	sta.w {MapBits_Right}	// Store to MapBits_Right address

// Set flag to update single tile on screen
	lda.b #$01		// Load $01
	sta.w {tileFlag}	// Store at tileFlag address $0628
	jsr RenderMapTile	// Jump to RenderMapTile routine
	rts

ProcessMapByte:	 // 0x17E43
// Takes a player-map data byte and gets the relevant two bits out of it
//	A – Map byte
//	Y – Map Tile Y
// Return via A
//	A = A >> (Y * 2) | 3

l_BE43:		// 0x17E53
	cpy.b #$00	// While Y != 0
	beq l_BE4C	// BEQ $05
l_BE47:		// 0x17E57
	lsr		// A >> 2
	lsr
	dey		// Y-
	bne l_BE47	// BNE $FB
l_BE4C:		// 0x17E5C
	and.b #$03	// A
	rts


//************************************
//	Draw whole map
//************************************

DrawWholeMap:	// 0x17E5F
	jmp DrawMapAllBanks	// Head over to a subroutine to loop through each bank
DoDrawWholeMap: 
// Prepare PPU to write map data
	lda.w $2002		// AD 02 20 -> PPU_STATUS = #$30
	lda.b #{VRAM_MapTiles}>>8	// Set PPU address #>VRAM_MapTiles (High byte)
	sta.w $2006		// 8D 06 20 -> PPU_ADDRESS = #$00
	lda.b #{VRAM_MapTiles}		// Set PPU address #>VRAM_MapTiles (Low byte)
	sta.w $2006		// 8D 06 20 -> PPU_ADDRESS = #$00

	lda.b #$00		// Loop over Y
	sta.w {mapLoop_Y}	// Store at mapLoop_Y address
l_BC78:		// BC78
	lda.b #$00		// Loop over X
	sta.w {mapLoop_X}	// Store at mapLoop_X address
l_BC7D:		// BC7D
	ldx.w {mapLoop_X}	// Render one map tile (mapLoop_X)
	ldy.w {mapLoop_Y}	// Render one map tile (mapLoop_Y)
	jsr UpdateMapTile	// Jump to Update Map Tile routine ($BC30)

	txa		// Send to PPU (preserve registers)
	pha
	jsr SendTileToPPU	// Jump to Send Tile to PPU routine ($BCA2)
	pla
	tax

	inc.w {mapLoop_X}	// Increase value of mapLoop_X
	lda.w {mapLoop_X}	// Load value of mapLoop_X
	cmp.b #$08		// Compare with $08
	bne l_BC7D		// BNE $E6

	inc.w {mapLoop_Y}	// Increase value of mapLoop_Y
	lda.w {mapLoop_Y}	// Load value of mapLoop_Y
	cmp.b #$04		// Compare with $04
	bne l_BC78		// BNE $D7

	rts

SendTileToPPU:	// $BCA2, 0x17CB2
	ldx.b #$00	// A2 00
l_BCA4:		// BCA4:
	lda.w {MapTileMacro}+3,x	// Load tile data byte of MapTileMacro+3,X
	sta.w $2007	// Write to PPU -> PPU_DATA = #$90
	inx
	cpx.b #$10	// Compare with $10
	bne l_BCA4	// D0 F5

	rts


//************************************
//	Map tile rendering
//************************************

RenderMapTile:
// Parameters
//	– mapVar_X :		Tile X
//	– mapVar_Y :		Tile Y
//	– mapBits_Left:		Bit-0 = TL screen discovered, Bit-1 = BL screen discovered
//	– mapBits_Right:	Bit-0 = TR screen discovered, Bit-1 = BR screen discovered


// Preserve zp variables
	lda.b $00	// A5 00
	pha
	lda.b $01	// A5 01
	pha

// Calculate the source address of tile data, to copy to macro
// and the PPU dest address to write to the macro.
// Address = BaseAddress + tileX * $10 + tileY * $80
// Y = tileY / 2
// Set x to low byte of pointer (will be 00 or 80)
	ldx.b #$00	// Low byte of src/dest pointers
	lda.w {mapVar_Y}	// Add mapVar_Y
	lsr
	tay
	bcc l_BCC1	// If carry was set (Y was odd), add 80 to low byte of pointers

	ldx.b #$80	// Load value $80 into X register
l_BCC1:		// BCC1:
	stx.b $00	// Write low byte of pointer
	lda.w {mapVar_X}	// Add mapVar_X * #$10 to $00
	asl
	asl
	asl
	asl
	clc
	adc.b $00	// Add $00

// Write low byte of ROM source and PPU dest (low byte will be same on both)
	sta.b $00	// Store at RAM $00
	sta.w {MapTileMacro}+1	// Store at Map tile macro address + 1

// Calculate high byte of source pointer
	tya
	adc.b #$AD	// Add $AD
	sta.b $01	// Store at RAM address $01

// Calculate high bte of destination pointer
	tya
	adc.b #$13	// Add $13
	sta.w {MapTileMacro}	// Store at Map tile macro address

// Write macro-length
	lda.b #$10	// Load value $10
	sta.w {MapTileMacro}+2	// Store at Map tile macro address + 2


// Run this code twice to create two bit filters (to be ANDed) for tile data, one for top half, one for bottom
// This "blacks out" map areas that have not been visited.
	ldy.b #$00	// A0 00	
MapBitLoop:	// BCE4:
	lda.b #$FF	// Load value $FF
	lsr.w {MapBits_Left}	// Grab low bit (for top-left or bottom-left)
 	bcs l_BCED	// BCS $02
	and.b #$0F	// If clear, AND out high nibble

l_BCED:		// BCED:
	lsr.w {MapBits_Right}	// Grab low bit (for top-right or bottom-right)
	bcs l_BCF4	// BCS $02
	and.b #$F0	// If clear, AND out low nibble
l_BCF4:		// BCF4:
	sta.w {MapFilter_Top},y	// Store at MapFilter_Top address
	iny		// Increment Y register
	cpy.b #$02	// Compare to $02
	bne MapBitLoop	// Branch if not equal to Map Bit Loop


// Copy 10 bytes of tile data. We use four loops:
// 	-Top half, first plane
//	-Bottom half, first plane
//	-Top half, second plane
//	-Bottom half, second plane
	ldy.b #$03	// Load value $03 into Y register
l_BCFE:		// BCFE:
	lda.b ($00),y	// Load RAM $00,Y
	and.w {MapFilter_Top}	// Compare with MapFilter_Top address
	sta.w {MapTileMacro}+3,y	// Store at Map tile macro address + 3,Y
	dey
	bpl l_BCFE	// BPL $F5

	ldy.b #$07	// Load value $07 into Y register
l_BD0B:		// BD0B:
	lda.b ($00),y	// Load RAM $00,Y
	and.w {MapFilter_Bottom}	// Compare with MapFilter_Bottom address
	sta.w {MapTileMacro}+3,y	// Store at Map tile macro address + 3,Y
	dey
 	cpy.b #$03	// Compare with $03 on Y register
	bne l_BD0B	// BNE $F3

	ldy.b #$0B	// Load value $0B into Y register
l_BD1A:		// BD1A:
	lda.b ($00),y	// Load RAM $00,Y
	and.w {MapFilter_Top}	// Compare with MapFilter_Top address
	sta.w {MapTileMacro}+3,y	// Store at Map tile macro address + 3,Y
	dey
	cpy.b #$07	// Compare with $07 on Y register
	bne l_BD1A	// BNE $F3

	ldy.b #$0F	// Load value $0F into Y register
l_BD29:		// BD29:
	lda.b ($00),y	// Load RAM $00,Y
	and.w {MapFilter_Bottom}	// Compare with MapFilter_Bottom address
	sta.w {MapTileMacro}+3,y	// Store at MapTileMacro address + 3,Y
	dey
	cpy.b #$0B	// Compare with $0B on Y register
	bne l_BD29	// BNE $F3

// Write terminator to end of macro
	lda.b #$FF	// Load value $FF into A register
	sta.w {MapTileMacro}+$13	// Store at Map Tile Macro address + $13

// Restore zero-page
	pla
	sta.b $01	// Store at RAM $01
	pla
	sta.b $00	// Store at RAM $00
	rts


//************************************
//	Partial heart routine
//************************************
// Modified by ShadowOne333 to allow 1/4 hearts decrements instead of the original 1/8

PartialHeartRoutine:	// 0x17F3E, $BF2E
// 1/4 Hearts subroutine
	lda.w $0670	// Originally LDA $0F (A5 0F) - Can be changed for AD 70 06 for direct access to the heart damage in RAM
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr		// Added another LSR so that the hearts are now in 1/4 drops instead of 1/8
	clc
	adc.b #$50	// 69 50
	jmp $6ED7	// Jump to $6ED7, or $06757 in PC address. Return to the original code for hearts


//******************************************
// Draw Map on all banks for MMC1 Animation (by frantik)
//******************************************
org $BFC0	// 0x17FD0, $BFC0
// This draws the map on all the banks
DrawMapAllBanks:
// Update all 4 banks if animation is enabled and only 1 bank otherwise
	lda.b #$04
	ldy.w {disable_animation}
	beq +
	lda.b #01
+
	sta.w $7FF0

DrawMapLoop:
	lda.w $7FF0
	jsr SetChrBank

	jsr DoDrawWholeMap

	dec.w $7FF0
	bne DrawMapLoop
	rts

SetChrBank:
	sta.w $C000
	lsr
	sta.w $C000
	lsr
	sta.w $C000
	lsr
	sta.w $C000
	lsr
	sta.w $C000

	rts 

// Hijack
// ———————————————
 
// Original code
//	(1):6EC8:C9 80	CMP #$80	; If partial-heart-value >= #$80, load full-heart-tile
//	:6ECA:B0 F4	BCS $6EC0
//	:6ECC:A9 00	LDA #$00	; ??????????????
//	:6ECE:8D 29 05	STA $0529
//	(2):6ED1:A9 65	LDA #$65	; Load half-full heart tile
//	:6ED3:D0 02	BNE $6ED7	; Branch always

//	(1) – Update value of CMP #$80 to run our partial heart routine for smaller increments
//	(2) – Hijack goes here

bank 1;	// This code is run from RAM
// Changes the break point for when to change the heart sprite when losing health, to take into account the new 1/4 hearts drop
org $A738	// 0x06748
	cmp.b #$C0	// Originally C9 80 (CMP #$80) - (CMP #$F8 in original Automap) 

org $A741	// 0x06751
// Jump to PartialHeartRoutine at $BD42 ($17D52 in PC address) - Originally A9 65 D0 02 (LDA #$65, BNE $A747 or $6757 in PC)
	jmp PartialHeartRoutine

// Originally $02 - NOP a leftover byte the original Automap code forgot
	nop


//************************************
//	Draw whole map hijack
//************************************

// Hijack
// ———————————————
bank 6; org $8089	// 0x18099 - Free space
// Jump to Do Whole Map Hijack code
	jmp DoWholeMapHijack	// Jump to $FFC0 (or $1FFD0 in PC) - Originally E6 11 60 (INC $11, RTS)


// Hijack code
// ———————————————
// This routine must go in the fixed bank because bank-swapping is
// needed to run the desired code.

bank 7; org $FFC0	// 0x1FFD0 - Start of Unused Space
DoWholeMapHijack:
	lda.b {LevelNumber}	// Only run this routine for the overworld
	bne Exit	// BNE $0D, Branch to exit

// Load Bank 5
	lda.b #$05	// The code we want to run is in a different bank than is currently loaded
	jsr {BankSwap}	// Jump to Bank swap routine

	jsr DrawWholeMap	// Jump to Draw whole map routine

// Load Bank 6
	lda.b #$06	// This is the bank that was previously loaded
	jsr {BankSwap}	// Jump to Bank swap routine

Exit:		// $FFD1, 0x1FFE1
// Displaced code
	inc.b $11	// Increment value at RAM $11
	rts


//************************************
//	PPU Transfers
//************************************
// WholeMapMacro = $6BCD

// PPU Update hijack
// ———————————————
bank 7; org $E4C1	// 0x1E4D1
// Jump to subroutine at $9D70, Originally 20 80 A0 (JSR $A080)
	jsr $9D70

// PPU Transfer
// ———————————————
bank 6; org $9D70	// 0x19D80
// Call displaced code
	jsr $A080

	lda.b {LevelNumber}	// If we aren't in overworld, clear flag and return
	bne ClearAndReturn	// Clear and Return, BNE $10
// This bis is from the old automap (without an actual image of overworld)
	ldx.w {tileFlag}	// Load tile flag
	beq rtn			// Return, BEQ $10
	txa

	// Use the tile flag to keep track of which CHR bank we are on. Increment each time we visit this function.
	// This will allow us to update each bank, one time per frame. (by frantik)	
	jsr SetChrBank_6 
	lda.b #{MapTileMacro}	// Load Map tile macro low byte
	sta.b $00		// Store $00
	lda.b #{MapTileMacro}>>8	// Load Map tile macro high byte
	sta.b $01		// Store $01
	jsr {SendPpuMacro}	// Jump to Send PPU Macro routine

ClearAndReturn:	// $9D87, 0x19D97 <-- this may have changed now
	lda.w {disable_animation}
	bne +
	inc.w {tileFlag}
	ldx.w {tileFlag}
	cpx.b #$05		// Are we done with bank 4? If so, then reset the flag, otherwise exit and do it again next frame
	bcc rtn
+
	lda.b #$00		// Clear tile flag
// NOP to fix palettes in dungeons not being properly restored after exiting stairs (by gzip)
	sta.w {tileFlag}	// Store in Tile Flag $0628

rtn:		// $9D8C, 0x19D9C
	rts

SetChrBank_6:
	sta.w $C000
	lsr
	sta.w $C000
 	lsr
	sta.w $C000
	lsr
	sta.w $C000
	lsr
	sta.w $C000

 	rts 


//************************************
//	Fast life fill
//************************************
// Causes life to fill faster with potion/fairy

bank 5;
org $B1F2	// 0x17202
	cmp.b #$D7	// Originally CMP $F8
	bcs l_B1FD	// Jump to routine to set current heart to 0 and increment full-heart count
	clc		// Add #$06 to current heart value (out of #$100), and return
	adc.b #$18	// Originally ADC #$06
	sta.w $0670	// Store at heart address
	rts
l_B1FD:		// 0x1720D
	lda.b #$00	// Load $00
	sta.w $0670	// Store at heart address
	jsr $746C	// Jump to routine at $746C
	bne l_B214	// Branch to life increment
	dec $0670	// Decrement Heart/Life value
	lda.b #$00	// Load $00
	sta.w $052E	// Store at address to disable sword
	sta.b $63	// Store at address $63 (?)
	sta.b $E0	// Store at address for Game Pause
	rts
l_B214:		// 0x17224
	inc $066F	// Increment filled hearts
	rts


//************************************
//	PPU transfers for mini tiles?
//************************************
bank 6;	org $A0A2	// 0x1A0B2
l_A0A2:
	pha
	sta.w $2006
	iny
	lda.b ($00),y
	sta.w $2006
	iny
	lda.b ($00),y
	asl
	pha
	lda.b $FF
	ora.b #$04
	bcs l_A0B9
	and.b #$FB
l_A0B9:
	sta.w {PpuControl1}
	sta.b $FF
	pla
	asl
	php
	bcc l_A0C6
	ora.b #$02
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
	lda.b ($00),y
	sta.w {PpuData}
	dex
	bne l_A0CE
	pla
	cmp.b #$3F
	bne l_A0EA
	sta.w {PpuAddress}
	stx.w {PpuAddress}
	stx.w {PpuAddress}
	stx.w {PpuAddress}
l_A0EA:
	sec
	tya
	adc.b $00
	sta.b $00
	lda.b #$00
	adc.b $01
	sta.b $01
//	--------sub start--------
	lda.w {PpuStatus}
	ldy.b #$00
	lda.b ($00),y
	bpl l_A0A2
	rts

