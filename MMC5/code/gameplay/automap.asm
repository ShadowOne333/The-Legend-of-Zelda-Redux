//***********************************************************
//	Automap for MMC5 (by bogaa)
//***********************************************************

//***********************************************************
//	Table file
//***********************************************************

table code/text/text.tbl,ltr

// SRAM Map SaveFormat:
//	File1 $7F60
//	File2 $7F70
//	File3 $7F80

// The Full map is 16 byte wide. Every byte represents a Column.
// Byte Column Encoding
// Bottom Half 	Top Half
//	1 1 1 1   	1 1 1 1 Show Full Column	$ff
//	1 0 0 0		0 0 0 0 First Tile Bottom  	$80
//	0 1 0 0		0 0 0 0 Second Tile Bottom 	$40 and $10 is the last one.

// This map File will be copied to SRAM $7f50 and drawn fully at lunch. After there will be checks for current screen.

// $7F00 Current Column map
// $7F01 Current Row map
// $7F02 Flag to Draw Full Map
// $7F03 Ypos Link Marker on map. Used while flashing and blanked out.

// $6CB4 Flag Used when start Scrolling. LinkMarker Update?
// The HudMap does consist of 32 tiles. 4 Rows and 8 Columns.
// $6CB6 00=Column1, 01=Column2, 02=Column3, 03=Column4, 04=Column5, 05=Column6, 06=Column7, 07=Column5 
// $6CB7	00=MapRow1, 01=MapRow2, 02=MapRow3, 03=MapRow4 


bank 1;		// PRG 4000
org $A450
CopyToSRAM:
	ldy.b #$00	// Copy code block to SRAM. Run on startup
CopyToSRAMLoop:
	lda.w CodeBlock,y
	sta.w $7F90,y
	iny
	cpy.b #$6F    	// Size of block - Max size. This can be used to copy other code as well.
	// Probably would be good to define SRAM locations/Routines to make code more readable.
	// Define $7f90=BankSplice // Check if bank 5 and go to SRAM or Bank 5 location accordingly
	bne CopyToSRAMLoop

//************************************************************
//			MMC5 Feature 
//************************************************************

//MMC5 For Additional SRAM. Only used with MMC5, so I copy the same code to not break anything when used on a different mapper.
	lda.b #$01	// Switch SRAM Page
	sta.w $5113

CopyToSRAM2:
	ldy.b #$00       // Copy code block to SRAM. Run on startup
CopyToSRAMLoop2:
	lda.w CodeBlock,y
	sta.w $7F90,y
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
	inc.w $7F02	// SetFlag to draw map
	lda.b #$00	// Used for waterfall.asm. It needs a buffer before it can run in play mode since automap is bussy doing things
	sta.w $0704
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
	lda.w $7F50,x
	sta.w $7F60,y
	dey
	dex
	bpl LoadMapLoop1
	jmp $9D2A	// FixHijack?             

LoadMap:
	jsr ChooseMap
LoadMapLoop2:	
	lda.w $7F60,y	// Will bring the save2 map to the right location in SRAM. When you load game        
	sta.w $7F50,x
	dey
	dex
	bpl LoadMapLoop2
	jmp $E625	// Fix Hijack?              
	
DeleteMapFromSave:	// Delete map from save file
	jsr Delete
	jmp $A764	// Fix Hijack?
	jsr Delete
	jmp $AF5A	// FixH ijack?

Delete:	
	ldx.b #$0F
	lda.b #$00
LoopDelete:
	sta.w $7F50,x
	dex
	bpl LoopDelete
	rts                      

ChooseMap:
	ldy.b #$0F	// Choose Save Map 1
	ldx.b $16	// Load Current Save Slot
	beq EndLoad
	ldy.b #$1F	// Choose Save Map 2
	dex
	beq EndLoad
	ldy.b #$2F	// Choose Save Map 3
EndLoad:	
	ldx.b #$0F	// LoadMapSize
	rts


bank 5;		// PRG 14000
org $85A0	// Free Space for new Code ----------------------------------------------
VisitedMapFlags:	// !!	
	lda.b $EB	// Get Map Xpos and Ypos
	and.b #$0F	// Take Xpos and move to X register
	tax
	lsr
	sta.w $7F00
	pha
	
	lda.b $EB	// Take Ypos shift to lower nibble (halfbyte) move to Y register.             
	lsr
	lsr
	lsr
	lsr
	tay
	
	lsr		// Devide since marker moves half a tile. Push Ypos/Row Map   
	sta.w $7F01
	pha

	lda.b #$01	// Check for top Row?
	cpy.b #$00
	beq StoreVisitFlag

CheckNext:	
	asl
	dey		// Decrement Row
	bne CheckNext

StoreVisitFlag:	
	ora.w $7F50,x
	sta.w $7F50,x
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
	dec.w $7F02	// SetFlag to clear map
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
	lda.b $10	// Load Current Level		
	beq EndLvLCheck	// Branch if Overworld            
	lda.b $14	// Load PPU Index                 
	cmp.b #$0E	// Check?     
	bne EndLvLCheck                
	lda.b #$7E                 
	sta.b $14	// Update PPU Index              
EndLvLCheck:	
	inc.b $13	// Increase Routine Index   
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
	lda.b $10		// Load Current Level           
	bne EndOverworldSet	// Branch Not overworld     
	lda.w $0254		// Ypos of Link marker on Map    
	cmp.b #$FF
	beq WhenBlankedOut
	sta.w $7F03		// Store Current Ypos on Map here while blanked out.              

WhenBlankedOut:	
	lda.b $15	// Load Frame Counter           
	lsr		// Get 5 Nibble to branch every 10 frames?
	lsr
	lsr
	lsr
	lsr
	bcc BlankMarker
	lda.w $7F03	// Load Ypos on Map after blank is over
	sta.w $0254	// Links Marker Ypos on Map               
	bne EndOverworldSet
BlankMarker:	
	lda.b #$FF	// Will make the marker blink. Here the possition is outside of screen
	sta.w $0254	// Links Marker Ypos on Map
EndOverworldSet:	
	pla
	jmp $77E7

	
GetDiscoverData:	
	stx.w $6CB6	// CurrentColumn xPos         
	sty.w $6CB7	// CurrentRow. Takes value in $EB LSR 5 times
	txa
	asl
	tax
	lda.w $7F50,x	// Get Map Column         
	jsr ColumnData
	sta.w $6CB5
	ldy.w $6CB7
	lda.w $7F51,x
	jsr ColumnData
	lda.b #$01	// Flag for?                
	sta.w $6CB4
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
	ldx.w $7F00	// Load xPos and Ypos of map
	ldy.w $7F01
	beq LoadTile	// Branch if first row

LoopPointerCalc:
	clc
	adc.b #$08
	dey
	cpy.b #$00
	bne LoopPointerCalc

LoadTile:	
	clc
	adc.w $7F00	// Add row offset
	tax
	lda.w MapNameTaRW1,x
	sta.w $7F08	// Tile
	
	lda.b #$01
	sta.w $7F07	// Length
	lda.b #$20
	sta.w $7F06	//Pointer Highbyte

	lda.w $7F01
	asl
	asl
	asl
	asl
	asl
	clc
	adc.b #$76
	adc.w $7F00	// Offset Row
	sta.w $7F05	// Pointer Lowbyte
	lda.b #$FF
	sta.w $7F09
	rts

MapNameTaRW1:
	db $30,$31,$32,$33,$34,$35,$36,$37	// DestPPU $2076
MapNameTaRW2:
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F	// DestPPU $2096
MapNameTaRW3:
	db $40,$41,$42,$43,$44,$45,$46,$47	// DestPPU $20b6
MapNameTaRW4:
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF	// DestPPU $20d6 


FullMapDrawFlag:
	lda.b $10		// Check Current Level
	bne Underworld

	lda.b #$01	// Flag to draw map while the screen opens
	sta.w $7F02
Underworld:
	lda.b #$1A	// HijackFix Initial screen hijack
	sta.b $00

	rts


	
HealthRefill:
	lda.w $0670 	// Load Partial Health               
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
	db $24,$24,$24,$24,$24,$24,$24,$24	//DestPPU $20b6
	db $20,$C2,$08
	db $24,$24,$24,$24,$24,$24,$24,$24,$FF	//DestPPU $20d6

org $9D70
UpdatePartialMapTile:	
	jsr $A080	// Check stuff and goes into PPU routines?
	lda.b $10		// Check for overworld? 
	bne NotOverworld
	
	lda.w $7F02	// FlagFullMapUpdate
	beq UpdateTile
	bmi EraseMap
	jsr DrawFullMap
UpdateTile:	
	ldx.w $6CB4	// Checks if Scrolling/Transition? 00=Normal 01=?
	beq EndCheckStuff

	lda.w $2002	// Read PPU status to reset the high/low latch
	lda.w $7F06
	sta.w $2006	// Write the high byte 
	lda.w $7F05
	sta.w $2006	// Write the low byte 

	lda.w $7F08	// Load Tile to update
	sta.w $2007	// Write to PPU
	
NotOverworld:	
	lda.b #$00
	sta.w $6CB4
EndCheckStuff:
	rts
EraseMap:
	txa
	pha
	tya
	pha
	
	jsr EraseMapNametable
	
	pla		// Backup from stuck
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
//  This map File will be copied to SRAM $7f50 and drawn fully at lunch.
// $00 PPU Offset
// $01 Row

DrawFullMap:
	lda.b $00		// Backup to stuck
	pha
	txa
	pha
	tya
	pha
	
	ldx.w $7F0A	// CopyMapNameTa
	ldy.w $7F04	// Column counter
	
	lda.b #$76
	clc
	adc.w $7F0A	// Offset with x data table and PPU pointer
	sta.b $00		// Holds LowByte PPU

NextColumnSave:		
	lda.b #$03	// Check 4 rows
	sta.b $01

MapColumnLoop:
	clc
	lda.w $7F50,y

BitCheckLoop:
	lsr		// Every two bit is a tile to check
	bcs StoreTile
	lsr
	bcs StoreTile
	
	pha		// KeepBitCheckValue
	
//	LDA $2002		//StoreEmptyTile This is not needed but helpful for debugging	       
//	LDA #$20               
//	STA $2006		//PpuAddr_2006         
//	LDA $00 	             
//	STA $2006		//PpuAddr_2006
//	lda #$24
//	sta $2007
SetNextBit:	
	lda.b $00	// RowSwitch
	clc
	adc.b #$20
	sta.b $00
	
	txa		// Next Row CopyMapNameTa
	clc
	adc.b #$08
	tax
	
	pla		// KeepBitCheckValue
	
	dec.b $01	// Next Row
	bmi NextColumn
	jmp BitCheckLoop

StoreTile:
	pha		// KeepBitCheckValue
	
	lda.w $2002	       
	lda.b #$20               
	sta.w $2006	// PpuAddr_2006         
	lda.b $00 	             
	sta.w $2006	// PpuAddr_2006
	lda.w CopyMapNameTa,x
	sta.w $2007

	jmp SetNextBit
	
NextColumn:		
	txa		// Set CopyMapNameTa x to first row next tile
	sec
	sbc.b #$1F
	tax
	
	lda.b $00		// Update PPU Pointer to next Row
	sec
	sbc.b #$7F
	sta.b $00
	
	iny
	cpy.b #$10	// Check if finished
	bne StoreColumnOffset

	lda.b #$00	// SetFlagDrawn	
	sta.w $7F02
	ldy.b #$00
StoreColumnOffset:
	sty.w $7F04	// Current Column
	tya
	lsr
	sta.w $7F0A	// We like to skip every second column to be drawn. Since one tile is two columns of discovery data.

	pla		// Backup from stuck
	tay
	pla
	tax
	pla
	sta.b $00

	rts

CopyMapNameTa:
	db $30,$31,$32,$33,$34,$35,$36,$37	//DestPPU $2076
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F	//DestPPU $2096
	db $40,$41,$42,$43,$44,$45,$46,$47	//DestPPU $20B6
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF	//DestPPU $20D6 

//---------------------------------------------------------------
//---------------------------------------------------------------
EraseMapNametable:
	pha		// Backup A Not sure if needed.. X Y I did check

	ldy.b #$76
ClearMap:	
	lda.w $2002
	lda.b #$20
	sta.w $2006	// PpuAddr_2006
	sty.w $2006	// PpuAddr_2006
	ldx.b #$08	// A Row
	lda.b #$24	// EmptyTiles
LoopClear:	
	sta.w $2007
	dex
	bne LoopClear

	tya		// Offset PPU pointer till done
	clc
	adc.b #$20
	cmp.b #$F6
	beq EndClearMap
	tay
	jmp ClearMap
		
EndClearMap:	
	lda.b #$00
	sta.w $7F02
	
	pla
	rts


org $A00E	// This is just a small part of the pointer table here. Would be cool to have the full table and content.
	dw HudArrangment	// PRG $1BEF0
org $A07E
	dw $A2D3	// Bug? Patch overwrites?

org $BEF0	// HUD Arrangement Hearts,Rupee.. (This is covered in what patch?)
	HudArrangment:
	// MODIFIED IN MOVE_MAPS.ASM
	//org $BF00				
	//	db $CC,$AA,$A6	//Part of the map nametable attribute. To make wood green

bank 7;		// PRG 1C000
base $C000	// Set offset of last bank

org $E4C1
	jsr UpdatePartialMapTile	// ? - Will make screen black if nop

org $E901
	jsr CopyToSRAM

org $EBF2	// Set Flags to draw map or clear it.
	jsr $7FA0
	
org $F322
	jsr $7F90


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
// "overworld_screens.asm" does debenp on visible secrets



