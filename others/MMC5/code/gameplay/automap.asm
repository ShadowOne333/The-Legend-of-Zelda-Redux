//***********************************************************
//	Automap for MMC5 (by bogaa)
//***********************************************************

//***********************************************************
//	Table file
//***********************************************************

table code/text/text.tbl,ltr


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

// SRAM Map SaveFormat:
// ———————————————
define	File1	$7F60
define	File2	$7F70
define	File3	$7F80
// This map File will be copied to SRAM $7F50 and drawn fully at launch. Afterwards, there will be checks for current screen.
define	MapRam	$7F50

// Game variables
// ———————————————
define	LevelNumber		$10
define	RoutineIndex		$13
define	PendingPpuMacro		$14
define	SaveSlot		$16
define	CurrentMapLocation	$EB
define	NewMapLocation		$EC
define	OAM_MapBlipY		$0254

// Our variables:
// ———————————————

// The Full map is 16 byte wide. Every byte represents a Column.
// Byte Column Encoding
// Bottom Half 	Top Half
//	1 1 1 1   	1 1 1 1 Show Full Column	$FF
//	1 0 0 0		0 0 0 0 First Tile Bottom  	$80
//	0 1 0 0		0 0 0 0 Second Tile Bottom 	$40 and $10 is the last one.

define	ColumnMap	$7F00
define	RowMap		$7F01
define	DrawFullMap	$7F02
define	YposLinkMarker	$7F03	// Used while flashing and blanked out.

define	tileFlag	$758C		// Flag Used when start Scrolling. LinkMarker Update?. Changed from $6C00 -> $6CB4 to fix a bug of Dungeon palettes being overwritten with $00
// The HudMap does consist of 32 tiles. 4 Rows and 8 Columns.
define	mapVar		{tileFlag}+1	// $6CB5, Temporary storage variable
define	mapVar_X	{tileFlag}+2	// $6CB6, 00=Column1, 01=Column2, 02=Column3, 03=Column4, 04=Column5, 05=Column6, 06=Column7, 07=Column5 
define	mapVar_Y	{tileFlag}+3	// $6CB7,	00=MapRow1, 01=MapRow2, 02=MapRow3, 03=MapRow4 
define	mapLoop_X	{tileFlag}+4
define	mapLoop_Y	{tileFlag}+5

define	BankSplice	$7F90	// Check if bank 5 and go to SRAM or Bank 5 location accordingly

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

//-------------------------------------------------------------

bank 1;		// PRG 4000
org $A450	// $4460
CopyToSRAM:
	ldy.b #$00	// Copy code block to SRAM. Run on startup
CopyToSRAMLoop:
	lda.w CodeBlock,y
	sta.w {BankSplice},y
	iny
	cpy.b #$6F    	// Size of block - Max size. This can be used to copy other code as well.
	// Probably would be good to define SRAM locations/Routines to make code more readable.
	bne CopyToSRAMLoop

//************************************************************
//			MMC5 Feature 
//************************************************************

// MMC5 For Additional SRAM. Only used with MMC5, so I copy the same code to not break anything when used on a different mapper.
	lda.b #$01	// Switch SRAM Page
	sta.w $5113

CopyToSRAM2:
	ldy.b #$00       // Copy code block to SRAM. Run on startup
CopyToSRAMLoop2:
	lda.w CodeBlock,y
	sta.w {BankSplice},y
	iny
	cpy.b #$6F
	bne CopyToSRAMLoop2
	
	lda.b #$00	// Set battery-backed default again
	sta.w $5113
//-------------------------------------------------------------
	jsr $8D00   	//This will fix the hijack and go to RTI eventually I guess.
	
CodeBlock:	
	pha           	// Blip?           
	lda.w $8000
	cmp.b #$20      // Check bank 5          
	bne GoSRAM
	pla
	jmp $BDF0     	// If bank 5           
GoSRAM:	
	pla
	jmp $77E7	// Else, SRAM routine

MapFlags:
	lda.b $12
	cmp.b #$04	// Check if it will turn to 5 soon. Overworld check
	bne EndMapFlags
	inc.w {DrawFullMap}	// SetFlag to draw map
	lda.b #$00	// It needs a buffer before it can run in play mode since automap is busy doing things
	sta.w $062C	//$0704
EndMapFlags:	
	jsr $EBA1	// HijackFix
	rts
	
	// ASCII for signing people in the debugger where to put code :P
	// Goes into SRAM. A good place to organize bank transitions system! This is just a note to see in the debugger.
	jsr $CAFE	// I just like coffee
	db "goes_into_sram._a_good_place_to_transit_to_different_banks"

	fillto $64CF,$EA

org $A5A1
	lda.b #$64
	
org $A738
	cmp.b #$C0
	
org $A741
	jmp HealthRefill
	nop

bank 2;
org $A2C7	// 0x0A2D7
	jsr DeleteMapFromSave


org $A5FE
	jsr LoadMap

org $A764	// Hijack Fix?
org $A77A
	jsr $B000

org $ABB5
	jmp $B026


// Free Space for new Code ----------------------------------------------
org $B000	// Will bring the save map to the right location in SRAM. When you register/save  
	jsr ChooseMap
LoadMapLoop1:	
	lda.w {MapRam},x	// $7F50,x
	sta.w {File1},y		// $7F60,y
	dey
	dex
	bpl LoadMapLoop1
	jmp $9D2A	// Fix Hijack?             

LoadMap:
	jsr ChooseMap
LoadMapLoop2:	
	lda.w {File1},y		// $7F60,y - Will bring the save2 map to the right location in SRAM. When you load game        
	sta.w {MapRam},x	// $7F50,x
	dey
	dex
	bpl LoadMapLoop2
	jmp $E625	// Fix Hijack?              
	
DeleteMapFromSave:	// Delete map from save file
	jsr Delete
	jmp $A764	// Fix Hijack?
	jsr Delete
	jmp $AF5A	// Fix Hijack?

Delete:	
	ldx.b #$0F
	lda.b #$00
LoopDelete:
	sta.w {MapRam},x	// $7F50,x
	dex
	bpl LoopDelete
	rts                      

ChooseMap:
	ldy.b #$0F		// Choose Save Map 1
	ldx.b {SaveSlot}	// Load Current Save Slot
	beq EndLoad
	ldy.b #$1F		// Choose Save Map 2
	dex
	beq EndLoad
	ldy.b #$2F		// Choose Save Map 3
EndLoad:	
	ldx.b #$0F		// Load Map Size
	rts


bank 5;		// PRG 14000
org $85A0	// Free Space for new Code ----------------------------------------------
VisitedMapFlags:	// !!	
	lda.b {CurrentMapLocation}	// Get Map Xpos and Ypos
	and.b #$0F			// Take Xpos and move to X register
	tax
	lsr
	sta.w {ColumnMap}
	pha
	
	lda.b {CurrentMapLocation}	// Take Ypos shift to lower nibble (halfbyte) move to Y register.             
	lsr
	lsr
	lsr
	lsr
	tay
	
	lsr		// Devide since marker moves half a tile. Push Ypos/Row Map   
	sta.w {RowMap}
	pha

	lda.b #$01	// Check for top Row?
	cpy.b #$00
	beq StoreVisitFlag

CheckNext:	
	asl
	dey		// Decrement Row
	bne CheckNext

StoreVisitFlag:	
	ora.w {MapRam},x	// $7F50,x
	sta.w {MapRam},x	// $7F50,x
	pla		// Pull YposMap/Row
	tay
	pla		// Pull XposMap/Column
	tax
	jsr GetDiscoverData
	jmp $A9F4

//-------------------------------------------
SetCaveFlag:
	lda.b $5B
	cmp.b #$0B
	bne EndSetCaveFlag
	dec.w {DrawFullMap}	// SetFlag to clear map
EndSetCaveFlag:	
	sta.b $12
	rts

org $8BA1
	jsr SetCaveFlag
	nop
//--------------------------------------------

org $A8BE
	jsr VisitedMapFlags		// !!

org $A8DE	// May be the initial thing should not be used?
	jsr FullMapDrawFlag	// Not used to draw at initial screen lvl 0, Original	LDA #$1A, STA $00, Hijack Fix
	nop

org $AF20
CheckCurrentLevel:	
	lda.b {LevelNumber}	// Load Current Level		
	beq EndLvLCheck		// Branch if Overworld            
	lda.b {PendingPpuMacro}	// Load PPU Index                 
	cmp.b #$0E		// Check?     
	bne EndLvLCheck                
	lda.b #$7E                 
	sta.b {PendingPpuMacro}	// Update PPU Index              
EndLvLCheck:	
	inc.b {RoutineIndex}	// Increase Routine Index   
	rts                      

org $B01A
	jmp CheckCurrentLevel
	
org $B1EA	// Part of Add health routine
	lda.b #$10	// Load heart fill sound         
	sta.w $0604	// Store Puls Sound Trigger        
	lda.w $0670	// Load Partial Health     
	cmp.b #$D7	// Check for sub health/heart indicator
	bcs HeartFill                
	clc                      
	adc.b #$18	// AddHealth            
	sta.w $0670                
	rts                      
HeartFill:

org $BDF0	//Position of Link's Marker on Map
LinkMarker:	
	pha
	lda.b {LevelNumber}	// Load Current Level           
	bne EndOverworldSet	// Branch Not overworld     
	lda.w {OAM_MapBlipY}	// Ypos of Link marker on Map    
	cmp.b #$FF
	beq WhenBlankedOut
	sta.w {YposLinkMarker}	// Store Current Y-pos on Map here while blanked out.              

WhenBlankedOut:	
	lda.b $15		// Load Frame Counter           
	lsr			// Get 5 Nibble to branch every 10 frames?
	lsr
	lsr
	lsr
	lsr
	bcc BlankMarker
	lda.w {YposLinkMarker}	// Load Y-pos on Map after blank is over
	sta.w {OAM_MapBlipY}	// Links Marker Ypos on Map               
	bne EndOverworldSet
BlankMarker:	
	lda.b #$FF		// Will make the marker blink. Here the possition is outside of screen
	sta.w {OAM_MapBlipY}	// Links Marker Ypos on Map
EndOverworldSet:	
	pla
	jmp $77E7

	
GetDiscoverData:	
	stx.w {mapVar_X}	// Current Column X-Pos         
	sty.w {mapVar_Y}	// Current Row. Takes value in $EB LSR 5 times
	txa
	asl
	tax
	lda.w {MapRam},x	// $7F50,x - Get Map Column         
	jsr ColumnData
	sta.w {mapVar}
	ldy.w {mapVar_Y}
	lda.w $7F51,x
	jsr ColumnData
	lda.b #$01		// Flag for?                
	sta.w {tileFlag}
	jsr DrawPartialMap
	rts

ColumnData:
	cpy.b #$00
	beq EndColumn
GetColumnData:
	lsr
	lsr
	dey
	bne GetColumnData
EndColumn:
	and.b #$03
	rts

org $BE4F
DrawPartialMap: 	//New for MMC5	
	lda.b #$00
	ldx.w {ColumnMap}	// Load X-pos and Y-pos of map
	ldy.w {RowMap}
	beq LoadTile	// Branch if first row

LoopPointerCalc:
	clc
	adc.b #$08
	dey
	cpy.b #$00
	bne LoopPointerCalc

LoadTile:	
	clc
	adc.w {ColumnMap}	// Add row offset
	tax
	lda.w MapNameTaRW1,x
	sta.w $7F08	// Tile
	
	lda.b #$01
	sta.w $7F07	// Length
	lda.b #$20
	sta.w $7F06	//Pointer Highbyte

	lda.w {RowMap}
	asl
	asl
	asl
	asl
	asl
	clc
	adc.b #$62
	adc.w {ColumnMap}	// Offset Row
	sta.w $7F05	// Pointer Lowbyte
	lda.b #$FF
	sta.w $7F09
	rts

MapNameTaRW1:
	db $30,$31,$32,$33,$34,$35,$36,$37	// DestPPU $2076
MapNameTaRW2:
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F	// DestPPU $2096
MapNameTaRW3:
	db $40,$41,$42,$43,$44,$45,$46,$47	// DestPPU $20B6
MapNameTaRW4:
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF	// DestPPU $20D6 


FullMapDrawFlag:
	lda.b {LevelNumber}	// Check Current Level
	bne Underworld

	lda.b #$01		// Flag to draw map while the screen opens
	sta.w {DrawFullMap}
Underworld:
	lda.b #$1A		// Hijack Fix Initial screen hijack
	sta.b $00

	rts


	
HealthRefill:
	lda.w $0670 		// Load Partial Health               
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc.b #$50
	jmp $6ED7


bank 6;		// PRG 18000
org $8089
	// jmp EndOverworldMapLoad	// This routine was originaly in the vector bank to swap to a other bank and back.
 	
org $8014
	dw MapNameTableData	// Load Tilemap + data of overwold to SRAM. The next pointer will be dungeon related
 
org $9300
MapNameTableData:			
//	db $3F,$00,$20,$0F,$30,$00,$12,$0F,$16,$27,$30,$0F		//Overworld data
//	db $1A,$37,$12,$0F,$17,$37,$12,$0F,$29,$27,$17,$0F
//	db $02,$22,$30,$0F,$16,$27,$30,$0F,$0C,$1C,$2C,$FF
//	db $01,$04,$05,$06,$8D,$57,$49,$99,$69,$00,$A0,$77
//	db $2A,$7F,$06,$00,$1D,$23,$49,$79,$FF,$FF,$FF,$FF
//	db $FF,$FF,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
//	db $FF,$FF,$FF,$FF,$FF,$FF,$FF

// This are the metadata to go into the PPU nametable. Map
// This will arrange tilemaping of the map in the HUD. 
// MoveMap will use same offset with different PPU pointers in table.

org $934F	// This org is not needed but the above data might be edited by other tools.
	db $20,$62,$08
	db $24,$24,$24,$24,$24,$24,$24,$24	//DestPPU $2076
	db $20,$82,$08
	db $24,$24,$24,$24,$24,$24,$24,$24	//DestPPU $2096
	db $20,$A2,$08
	db $24,$24,$24,$24,$24,$24,$24,$24	//DestPPU $20B6
	db $20,$C2,$08
	db $24,$24,$24,$24,$24,$24,$24,$24,$FF	//DestPPU $20D6

org $9D70
UpdatePartialMapTile:	
	jsr $A080	// Check stuff and goes into PPU routines?
	lda.b {LevelNumber}	// Check for overworld
	bne NotOverworld
	
	lda.w {DrawFullMap}	// Flag Full Map Update
	beq UpdateTile
	bmi EraseMap
	jsr DrawFullMap
UpdateTile:	
	ldx.w {tileFlag}	// $6CB4, Checks if Scrolling/Transition? 00=Normal 01=?
	beq EndCheckStuff

	lda.w {PpuStatus}	// Read PPU status to reset the high/low latch
	lda.w $7F06
	sta.w {PpuAddress}	// Write the high byte 
	lda.w $7F05
	sta.w {PpuAddress}	// Write the low byte 

	lda.w $7F08		// Load Tile to update
	sta.w {PpuData}		// Write to PPU
	
NotOverworld:	
	lda.b #$00
	sta.w {tileFlag}	// $6CB4
EndCheckStuff:
	rts
EraseMap:
	txa
	pha
	tya
	pha
	
	jsr EraseMapNametable
	
	pla			// Backup from stuck
	tay
	pla
	tax
	
	jmp NotOverworld

//---------------------------------------------------------------
//---------------------------------------------------------------
//Byte Column Encoding
//Bottom Half 	Top Half
//	1 1 1 1   	1 1 1 1 Show Full Column	$FF
//	1 0 0 0		0 0 0 0 First Tile Bottom  	$80
//	0 1 0 0		0 0 0 0 Second Tile Bottom 	$40 and $10 is the last one.
//  This map File will be copied to SRAM $7F50 and drawn fully at lunch.
// $00 PPU Offset
// $01 Row

DrawFullMap:
	lda.b $FF		// PPU Ctrl
	ora.b #$04		// Row write
	sta.w {PpuControl1}
	
	lda.w {PpuStatus}	// Reset latch
	
	lda.b #$20               
	sta.w {PpuAddress}	// HighByte PPU 
	
	ldy.w $7F04		// Column counter  [00-0F]
	
	tya		// We like to skip every second column to be drawn. Since one tile is two columns of discovery data.
	lsr
	tax		// Offset with x data table and PPU pointer  [00-07, $7F0A]
	
	clc
	adc.b #$62		// Table  [76, 76, 77, 77, 78, 78 , .. , 7D, 7D]
	sta.w {PpuAddress}	// LowByte PPU
	
MapColumnLoop:
	lda.w $7F50,y
	
BitCheckLoop:
	lsr		// Every two bit is a tile to check
	bcs StoreTile2
	lsr
	bcs StoreTile
	
NoTile:
	tay			// KeepBitCheckValue
	
	// lda #$24		// Empty Tile (debugging)
	lda.w {PpuData}		// Bump Vram
	bcc SetNextBit
	
StoreTile2:
	lsr			// Same Tile
	
StoreTile:
	tay			// KeepBitCheckValue
	
	lda.w CopyMapNameTa,x
	sta.w {PpuData}
		
SetNextBit:	
	txa			// Next Row CopyMapNameTa
	clc
	adc.b #$08
	tax
	
	tya			// KeepBitCheckValue
	bne BitCheckLoop	// Next Row
	
NextColumn:
	lda.w $7F04		// Next column
	// clc			// No carry from above math
	adc.b #$01
	cmp.b #$10		// Check if finished
	bne StoreColumnOffset
	
	lda.b #$00		// SetFlagDrawn	
	sta.w $7F02
	
StoreColumnOffset:
	sta.w $7F04		// Current Column
	
	lda.b $FF		// Restore PPU Ctrl
	sta.w {PpuControl1}
	
	rts

CopyMapNameTa:
	db $30,$31,$32,$33,$34,$35,$36,$37	//DestPPU $2076
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F	//DestPPU $2096
	db $40,$41,$42,$43,$44,$45,$46,$47	//DestPPU $20B6
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF	//DestPPU $20D6 

//---------------------------------------------------------------
//---------------------------------------------------------------
EraseMapNametable:
	pha		// Backup A Not sure if needed. X Y I did check

	ldy.b #$62
ClearMap:	
	lda.w {PpuStatus}
	lda.b #$20
	sta.w {PpuAddress}	// PpuAddr_2006
	sty.w {PpuAddress}	// PpuAddr_2006
	ldx.b #$08	// A Row
	lda.b #$24	// EmptyTiles
LoopClear:	
	sta.w {PpuData}
	dex
	bne LoopClear

	tya		// Offset PPU pointer till done
	clc
	adc.b #$20
	cmp.b #$E2
	beq EndClearMap
	tay
	jmp ClearMap
		
EndClearMap:	
	lda.b #$00
	sta.w {DrawFullMap}
	
	pla
	rts


org $A00E	// This is just a small part of the pointer table here. Would be cool to have the full table and content.
	dw overworld_attributes	// PRG $1BEF0
org $A07E	// 0x1A08E
// Repoint attribute and tilemaps for Dungeon maps
	dw $A2D3	// db $D3,$A2 - For original Automap tilemap

//------------------------------------

org $BEF0	// HUD Arrangement Hearts,Rupee.. (This is covered in what patch?)
// Overworld tiles Attributes, HUD attribute table
overworld_attributes:
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

//------------------------------------

bank 7;		// PRG 1C000
base $C000	// Set offset of last bank

org $E4C1
	jsr UpdatePartialMapTile	// ? - Will make screen black if nop

org $E901
	jsr CopyToSRAM

org $EBF2	// Set Flags to draw map or clear it.
	jsr $7FA0
	
org $F322
	jsr {BankSplice}


// This is needed for Original MMC1 
bank 2;
org $8A7F
	incbin code/gameplay/automap_tiles.bin

// Automap tiles for MMC5
bank 8; org $22B00
	incbin code/gameplay/automap_tiles.bin
bank 10; org $29300
	incbin code/gameplay/automap_tiles.bin
org $2A300
	incbin code/gameplay/automap_tiles.bin
org $2B300
	incbin code/gameplay/automap_tiles.bin
bank 11; org $2C300
	incbin code/gameplay/automap_tiles.bin

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Depents on "rupee.asm" to write a routine where the original Hud preset table was!
//org $A507	// CPU $6C97, 0x06517
// Also expansion and table at bank 5, org $AC70
// "move_maps.asm" will have needed changes for it to work.

// Further depends so the world will not come with messed up columns with wrong pattern arrangment/fuctioning caves..
// "visible_secrets.asm"
// "overworld_screens.asm" does debend on visible secrets


