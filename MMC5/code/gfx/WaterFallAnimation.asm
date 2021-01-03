//  Notes:

//	RAM
//  51d graphic index/loading??
//  
//  When $10 is 00 you are on the overworld
//  When $12 is 05 MainGame loop
//  $EB  Map Location YX (Y=Ypos on Map) (X=Xpos on Map)




//****************************************
// Code:
//****************************************

bank 6;
//Hijack
org $a08c				//PRG 1a08c Here the routine just change to bank 6 and is about to go to the hud update (Donno what the table at 1a000 is for!)
	jsr TileAnimation	//Hijack (Orginal jsr $a0f6)


//FreeSpace
org $9f00		//PRG 19f00
//$704 Flag/buffer to run animation. 10 will run animation
//$701 Shift offset for waterfall tile
//$703 Animation frame buffer

TileAnimation:
	lda $10		//Check if overworld 00
	bne EndTileAnimation
	
	lda $12		//Check if Gameloop Normal 05
	cmp #$05
	bne EndTileAnimation
	
	lda $704	//Make a buffer for transition to run after a view frames. Since before it would not keep up
	cmp #$10
	beq SetFrame
	inc $704	//decrease Flag till 00 to start


EndTileAnimation:	
	jsr $a0f6	//Make sure to end after this test or you get glitches while scrolling
	rts
	
	
SetFrame:
	inc $703	//Run all 3 frames
	lda $703
	cmp #$02
	beq Splash
	cmp #$03
	bne EndTileAnimation
	lda #$00
	sta $703
	
	
	inc $701
	lda $701
	cmp #$08
	bne Start
	lda #$00	//Reset Shift Value
	sta $701
Start:	
	lda $2002	//Read Status to reset latch. (Make PPU Ready)
	lda #$18	//Set DestPPU $18 uper byte (writen only once!?)
	sta $2006

	lda #$90	//Set DestPPU $90 lower byte
	sta $2006
	
	ldx #$0f	//Set 1 Tile Size (10byte) minimal value for it to work.
	
	lda $701	//Move shifting point to middle of table
	adc #$0f
	tay	
LoopAni:	
	lda WaterFallTiles,y
	sta $2007
	dey			//Shift Tile
	dex
	bne LoopAni
	jmp EndTileAnimation
	

Splash:	//Second Animation

	lda $2002	//Read Status to reset latch. (Make PPU Ready)
	lda #$18	//Set DestPPU $18 uper byte (writen only once!?)
	sta $2006

	lda #$80	//Set DestPPU $90 lower byte
	sta $2006
	
	ldx #$00	//set counter
	ldy	#$0f	//Size of tile to update

	lda $15
	and #$08
	beq LoopAniSp2
	
LoopAniSp:	
	lda FirstTile,x
	sta $2007
	inx
	dey
	bne LoopAniSp
	
	jmp EndTileAnimation	
LoopAniSp2:	
	lda SecondTile,x
	sta $2007
	inx
	dey
	bne LoopAniSp2
	
	jmp EndTileAnimation

	
	
FirstTile:
db $7F,$D7,$FC,$FF,$FF,$3D,$C3,$7E,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$AD

SecondTile:
db $BE,$F3,$7F,$BF,$C1,$FF,$FF,$7E,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$AD
	
WaterFallTiles:
db $D7,$AB,$7D,$FE,$FF,$FF,$FF,$FF,$EB,$D5,$BE,$7F,$FF,$FF,$FF,$FF,$D7,$AB,$7D,$FE,$FF,$FF,$FF,$FF,$EB,$D5,$BE,$7F,$FF,$FF,$FF,$FF



//	Notes and stuff
//155ae Combp.. c1 Waterfall
//15ea9 Waterfall combo

//169ec Ground tile 26262626 We need
//Set Column Data Tile Mappings for current screen

//$00-$01		Offset in Cartridge RAM for Screen Tile Mappings
//$02-$03		Pointer for Screen Column Data
//$04-$05		Pointer for Column Definitions
//$06			Various Uses (Column Data Offset, Column Loop)
//$07			Loop Variable (Column End)
//$08-$09		Offset in Cartridge RAM for Screen Status (visited, secret)
//$0C			Repeat Switch (00 or FF)
//$0D			Column Tile Code

//Hijack at 16a8e (aa8e 20 2aac ) to check if waterall tile. 89 Store tiles at 6639? then rts. if not bfaa


//***************
//**Tilemapping**
//***************


bank 5;
	org $a9f0
	db $89,$88,$89,$88		//End Of Waterfall  Orginal($8B,$88,$8B,$88)
	
	org $aa8e
	jsr WaterFallSquare		//Check if tile is waterfall and replace column squere assembly
	
	
	
	org $af40				//$ac2a I hardcoded and branch on a tile read in the PPU CHR.. I know this is bad but could not figure anythings else without wasting more time..
	WaterFallSquare:
	cmp #$89
	bne SkipWaterFallSquare
	
	LDX $0D					//Check End waterfall sqare. 
	CPX #$10
	BCC SkipWaterFallSquare
	
	STA ($00),y			
	INY
	STA ($00),y	
	
	TAX
	
	TYA
	CLC
	ADC #$15
	TAY
	
	TXA
	
	STA ($00),y	
	INY
	STA ($00),y	
	RTS
	
	SkipWaterFallSquare:
	jsr $aaf1 	//FixHijack
	rts
	
	
	
	