//  Notes:

//	RAM
//  51D graphic index/loading??
//  
//  When $10 is 00 you are on the overworld
//  When $12 is 05 MainGame loop
//  $EB  Map Location YX (Y=Ypos on Map) (X=Xpos on Map)

//  PRG ROM
//  C010 Sprite Pointer Dungeon (10 Index??)
//  C030 Graphic Pointer 	xxxx 		yyyy
//  						DestTile	DestSprit
//  
//  C05E index 0 overwold 1 title?	
//  
//  C028
//  00 = Dungeon Doors covers Map
//  01 = Monster Dungeon 1
//  03 = Overworld
//  04 = Enemy set Overworld
//

//  C026 Ganon
//
//  C014
//


//****************************************
//	Code:
//****************************************

bank 6;
// Hijack
org $A08C	// 0x1A09C
// PRG 1A08C Here the routine just change to bank 6 and is about to go to the hud update (Dunno what the table at 1A000 is for)
	jsr TileAnimation	// Hijack (Orginal JSR $A0F6)


//Free Space
org $9D90	// 0x19DA0
// PRG 19D90
TileAnimation:
	lda.b $10		// Check if overworld 00
	bne EndTileAnimation2
	lda.b $E1		// Check if scrolling? Needed for redux!
	bne EndTileAnimation2
	lda.b $EB		// Check Screen to enable, Needed for redux!	
	cmp.b #$1A		// $1A is waterfall screen, Needed for redux!
	bne EndTileAnimation2
	lda.b $12		// Check if Gameloop Normal 05
	cmp.b #$05
	beq Animate
	jsr $A0F6		// Make sure to end after this test or you get glitches while scrolling
	rts


EndTileAnimation:	
	lda.w $0700
	cmp.b #$01
	beq AnimateSplash	// Branch for second tile animation in between waterfall frames
EndTileAnimation2:	
	jsr $A0F6		// Fix Hijack and contine Normal routines
	rts
	
Animate:
	lda $0700
	beq FrameAnim
	
FrameSkip:	
	dec $0700
	jmp EndTileAnimation
	
FrameAnim:	
	ldy.w $0701	// Set WaterFall to $0F Frames
	iny
	tya
	and.b #$0F	// Number of frames (15)
	sta.w $0701

	lda.b #$02	// Animation Speed
	sta.w $0700	

	lda.w $2002	// Read Status to reset latch. (Make PPU Ready)
	lda.b #$18	// Set DestPPU $18 upper byte (writen only once!?)
	sta.w $2006

	lda.b #$90	// Set DestPPU $90 lower byte
	sta.w $2006
	sta.w $2006
	
	ldx.b #$0F	// Set 2 Tile Size (20byte since 40 is to much)
	
	lda.w $0701	// Move shifting point to middle of table
	adc.b #$0F
	tay
	
LoopAni:
	lda WaterfallTiles,y
	sta.w $2007
	dey		// Shift Tile
	dex
	bne LoopAni
	
	jmp EndTileAnimation2



AnimateSplash:	// Second Animation
	lda.w $2002	// Read Status to reset latch. (Make PPU Ready)
	lda.b #$18	// Set DestPPU $18 upper byte (writen only once!?)
	sta.w $2006

	lda #$80	// Set DestPPU $90 lower byte
	sta $2006
	sta $2006
	
//	ldx #$00	// Set counter
	ldy #$0F	// Size of tile to update
	lda $15		// Animation Control for every 10 frame somewhat
	and #$10
	beq LoopAniSp2
	
LoopAniSp:	
	lda FirstTile,x
	sta $2007
	inx
	dey
	bne LoopAniSp
	
	jmp EndTileAnimation2
	
LoopAniSp2:	
	lda SecondTile,x
	sta $2007
	inx
	dey
	bne LoopAniSp2
	
	jmp EndTileAnimation2
	
	
FirstTile:
	db $7E,$DB,$FF,$FF,$3C,$C3,$FF,$7E
	db $FF,$FF,$FF,$FF,$FF,$FF,$7E,$AD

SecondTile:
	db $BD,$E7,$7E,$BD,$C3,$FF,$FF,$7E
	db $FF,$FF,$FF,$FF,$FF,$FF,$7E,$AD
	
WaterfallTiles:
	db $D7,$AB,$7D,$FE,$FF,$FF,$FF,$FF
	db $EB,$D5,$BE,$7F,$FF,$FF,$FF,$FF
	db $D7,$AB,$7D,$FE,$FF,$FF,$FF,$FF
	db $EB,$D5,$BE,$7F,$FF,$FF,$FF,$FF
//WaterfallTile1:
//	db $BF,$BB,$33,$35,$11,$00,$10,$52
//	db $FF,$FB,$7B,$7F,$B7,$BD,$FF,$FF
//WaterfallTile2:
//	db $DA,$FE,$EB,$EB,$DB,$FF,$FF,$FF
//	db $FF,$FF,$EF,$EF,$FF,$FF,$FF,$FF


//	Notes and stuff
// 155AE Combo.. C1 Waterfall
// 15EA9 Waterfall combo

// 169EC Ground tile 26262626 We need
// Set Column Data Tile Mappings for current screen

// $00-$01		Offset in Cartridge RAM for Screen Tile Mappings
// $02-$03		Pointer for Screen Column Data
// $04-$05		Pointer for Column Definitions
// $06			Various Uses (Column Data Offset, Column Loop)
// $07			Loop Variable (Column End)
// $08-$09		Offset in Cartridge RAM for Screen Status (visited, secret)
// $0C			Repeat Switch (00 or FF)
// $0D			Column Tile Code

// Hijack at 16A8E (AA8E 20 2AAC) to check if waterfall tile.
// 89 Store tiles at 6639? then RTS. If not BFAA


//***************
//**Tilemapping**
//***************

bank 5;
org $A9F0	// 0x16A00
	db $89,$88,$89,$88	// End Of Waterfall, Original ($8B,$88,$8B,$88)
	
org $AA8E	// 0x16A9E
	jsr WaterFallSquare	// Check if tile is waterfall and replace column square assembly

org $AF40	// 0x16F50
// $AC2A I hardcoded and branch on a tile read in the PPU CHR.. I know this is bad but could not figure anythings else without wasting more time..
WaterFallSquare:
	cmp.b #$89
	bne SkipWaterFallSquare
	
	ldx.b $0D			// Check End waterfall sqare. 
	cpx.b #$10
	bcc SkipWaterFallSquare
	
	sta.b ($00),y
	iny
	sta.b ($00),y
	
	tax
	
	tya
	clc
	adc.b #$15
	tay
	
	txa
	
	sta.b ($00),y	
	iny
	sta.b ($00),y	
	rts
	
SkipWaterFallSquare:
	jsr $AAF1 		// Fix Hijack
	rts

