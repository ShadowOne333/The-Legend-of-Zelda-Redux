//--------------------------------------------------------------
//	iNES Header
//--------------------------------------------------------------

	db $4E,$45,$53,$1A    	// Header (NES $1A)
	db 8             	// 8 x 16k PRG banks
	db 8	         	// 8 x 8k CHR banks
	db %01010010     	// ROM Settings
	//  |||||||^--- Mirroring: Vertical
	//  ||||||^--- SRAM: Yes
	//  |||||^--- 512k Trainer: Not used
	//  ||||^--- 4 Screen VRAM: Not used
	//  ^^^^--- Mapper: 5
	db %00000000      	// RomType: NES
	db $00,$00,$00,$00  	// iNES Tail 
	db $00,$00,$00,$00    


//--------------------------------------------------------------
//	ROM Start	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 2; org $8000	// 0x08010
//org $A5E4
//		lda.b #$00	// Load overworld
//		sta.b $10		
//		sta.w $0656

bank 3;		// 0x0C010
//org $ABFC				
//	jsr $8091	// Load GFX, No Loads are disabled. Might be useful to free some space.

bank 5; org $B489	// 0x17499
// This is run to go to a other level
//	ldy.b $EB		// Y is based on map location
//	lda.w $68FE,y		// Load Dungeon 01 store calculated value to $10.

//	and.b #$FC
//	cmp.b #$40
//	bcc StoreCurrentLevel
//	ldy.b #$0B
//	cmp.b #$50
//	bne DoElse     		// Used for single rooms?
//	iny
//DoElse:
//	tya
//	jmp $B44C
//StoreCurrentLevel:
//	lsr
//	lsr
//	sta.b $10


//--------------------------------------------------------------
// Bank 6, $18000
//--------------------------------------------------------------

bank 6; org $8000	// 0x18010

org $8070	// 0x18080
	jsr CHRSwaping	// Hijack without disabling old the PPU load routine since it is used for multiple things.

//	LDA $10		// Load Current Level
//	ASL
//	TAX
//	LDA $8014,x    	// Load graphic pointer based on Level
//	STA $00
//	INX
//	LDA $8014,x
//	STA $01
//	JSR $80B5
//	JSR $80D7
//	LDA #$00
//	STA $13
//	INC $11
//	RTS


// Hijack (same as "waterfall.asm", but this will not work with MMC5 anyway)
org $A08C	// 0x1A09C
// Here the routine just changes to bank 6 and is about to go to the HUD update (Don't know what the table at 1A000 is for!)
	jsr CHRanimation	// Hijack (Original jsr $A0F6)

// Free Space
org $B000	// 0x1B010
CHRanimation:
// RAM addresses $0628-$062C seem to be unused. We'll use these for the animation counters
	lda.b $10
	bne EndCHRAnimation
	lda.b $12
	cmp.b #$05
	bne EndCHRAnimation

	inc.w $0628	//$0780
	lda.w $0628	//$0780
	cmp.b #$10	// Set to run all 10 Frames
	bne EndCHRAnimation
	lda.b #$00	// Reset Counter of 10 Frames
	sta.w $0628	//$0780
	
	inc.w $0629	//$0781
	lda.w $0629	//$0781
	cmp.b #$04	// Check if max Bank Frame is reached. 
	bne AnimationOverworld
	lda.b #$00	// Reset Bank Frame
	sta.w $0629	//$0781

AnimationOverworld:
	tax
	
	lda.w AnimationBankOverworld,x
	tay
	
	sty.w $5128	// Tiles 1/4
	lda.w $062A	//$0782
	sta.w $5124	// Unused Sprite Page
	iny
	sty.w $5129	// Tiles 2/4
	lda.w $062B	//$0786
	sta.w $5125	// Unused Sprite Page? Tree, Doors?
	iny				
	sty.w $512A	// Tiles 3/4			
	iny	
	sty.w $512B	// Tiles 4/4

EndCHRAnimation:	
// Lake Drain
	lda.w $051A	// Lake Drain active on that screen.
	beq SkipLake
	cmp.b #$0C	// Lake Fully Drained = $0C
	bne DrainSpeed
	lda.b #$00	// Stop Animation
	sta.w $0628	//$0780
DrainSpeed:
	lda.w $0628	//$0780
	cmp.b #$04	// Check max frame. So it will animate every 4 frames
	bne SkipLake
	lda.b #$0F	// Set to trigger next frame
	sta.w $0628	//$0780		
SkipLake:
	jsr $A0F6	// Hijackfix
	rts

//--------------------------------------------------------------

AnimationBankOverworld:
	db $24,$28,$2C,$30

SetCHRStart:
	ldy.b #$00
		
	sty.w $5120	// Link, Sprite 1/8
	iny
	sty.w $5121	// Items, Sprite 2/8
	iny
	sty.w $5122	// Enemy1, Sprite 3/8
	iny
	sty.w $5123	// Enemy2, Sprite 4/8
	iny
	sty.w $5124	// Fonts. This is the second page for CHR Sprites. Normaly this is pulled of the first page (Tiles). Sprite 5/8, NOT USED
	sty.w $5128	// This is the page for Tiles 1/4
	iny
	sty.w $5125	// SpritePageFixes Since we have a extra page for sprites instead the tile page. Sprite 6/8, Trees,Doors
	sty.w $5129	// Tiles 2/4
	iny
	sty.w $5126	// Sprite 7/8
	sty.w $512A	// Tiles 3/4
	iny
	sty.w $5127	// Sprite 8/8
	sty.w $512B	// Tiles 4/4

	rts

CHRSwaping:	// Levels
	ldy.b $10	// Current level
	lda.w CHRBankTableSprites,y
	tay
// Link and the Items are permanent avalible. No need to swap $5120 and $5121
	sty.w $5122	//Enemy1, Sprite 3/8
	iny
	sty.w $5123	//Enemy2, Sprite 4/8

	ldy.b $10
	lda.w CHRBankTableTiles,y
	tay

	sty.w $5128	// Tiles 1/4
	sty.w $062A	//$0782	// Init Frame to animate for Sprites
	iny
	sty.w $5129	// Tiles 2/4
	sty.w $062B	//$0786	// Init Frame to animate for Sprites
	iny
	sty.w $512A	// Tiles 3/4
	sty.w $5126	// Sprite 7/8, Needed for movable block sprite in dungeons
	iny
	sty.w $512B	// Tiles 4/4
	sty.w $5127	// Sprite 8/8, Needed for movable block sprite in overworld

	lda.b $10	//Hijack Fix
	asl
	tax

	rts

//LVL	00, 01, 02, 03, 04, 05, 06, 07, 08, 09	// 00 = Overworld
CHRBankTableSprites:
	db $08,$0E,$14,$16,$18,$1A,$1C,$1E,$20,$22
CHRBankTableTiles:
	db $0A,$10,$10,$10,$10,$10,$10,$10,$10,$10


//--------------------------------------------------------------
//	Bank 7, $1C000
//--------------------------------------------------------------
bank 7; org $C000	// 0x1C010

	org $E45B	// Jump waiting for interrupt. After RTI waiting for NMI

	org $E9BB	// 0x1E9CB
		bne $05
		lda.b #%01000100	// #$44 Vertical scrolling
		sta.w $5105		//Name Table Setting
		rts
	
	org $E9CB	// 0x1E9DB
		fill $05,$EA	// Fill 0x05 bytes with NOP
		//nop,nop,nop,nop,nop
		
	org $EB70	// 0x1EB80
		fill $05,$EA	// Fill 0x05 bytes with NOP
		//nop,nop,nop,nop,nop
		rts
		
	org $EBB1	// 0x1EBC1
		fill $05,$EA	// Fill 0x05 bytes with NOP
		//nop,nop,nop,nop,nop

	org $FF43	//Original VectorStart
	VectorStart:	// MMC5 Vector Initial Settings
		lda.b #$01		// Set 16kb ($4000) segment Bank	
		sta.w $5100
		lda.b #%00000011	// Set CHR mode 00=8KB pages 03=1KB pages
		sta.w $5101
		lda.b #%00000010	// Enable PRG RAM=02
		sta.w $5102
		lda.b #%00000001		// Enable PRG RAM=01	
		sta.w $5103
		lda.b #%01010000		// $50 NameTable Setting Horizontal Scrolling
		sta.w $5105

	InitialSet:	// It will set everything to default. Not sure if this is needed or even right in here.
	//	lda.b #$00			//PRG BankSwitch Setting (PRG RAM Mode 1 {Mode is set in $5100})
	//	sta.w $5113
	//	lda.b #$0F			//PRG BankSwitch (PRG RAM Mode l) 16kb sould ignore lower bits
	//	sta.w $5015
	//	lda.b #$80			//PRG BankSwitch $8000-$bfff (PRG Mode l) 16kb sould ignore lower bits
	//	sta.w $5115
	//	lda.b #$8E			//PRG BankSwitch $c000-$ffff (PRG Mode l) 16kb sould ignore lower bits
	//	sta.w $5117

		lda.b #$06	// Swap Bank 06
		jsr BankSwapPRG
		jsr SetCHRStart

	OrginalVectorStart:                      
		cld                      
		lda.b #$00                 
		sta.w $2000                
		ldx #$FF                 
		txs                      
	PPUReady:
		lda.w $2002                
		and.b #$80                 
		beq PPUReady                
	PPUReady2:	
		lda.w $2002                
		and.b #$80                 
		beq PPUReady2                
		rts
		
	org $FFAC	// Original PRG swap start will make it more compatible with other patches (I hope)
	BankSwapPRG:
		pha					
		asl
		adc.b #$80	// Add base to the bank offset
		sta.w $5115	// Swap PRG Bank $8000-$BFFF
		pla
		rts

		fillto $FFE2,$FF
		
	org $FFE2	
	SetHorizontalScroll:
		sta.w $0302		// HudUpdateTable will be off when FF
		lda.b #%01010000	// $50 NameTable Setting Horizontal Scrolling
		sta.w $5105
		rts
			
	org $FFFC
		dw VectorStart	// Vector Reset Pointer


//--------------------------------------------------------------
//	Bank 8, $20000
//--------------------------------------------------------------
//bank 8; org $20000	// 0x20010
//	incbin code/gfx/NewCHR.bin

//--------------------------------------------------------------
// Notes
// PRG $8000 Graphic pointer $7F80, $7F87, $7F8E - Link, Font, Key, 3 entries Source Length PPU Destination
//	$B496 Title
//	$C028 Main	


// ROM Graphic
//	4DC4 Puff Letter Magic
//	808F Link Main
//	878F Sprites
//	C12B Dungeon Sprite


// PRG $18000 Dungeon Pointer

// 18000	18013	Ten 2-byte pointers specifying which PPU Spriteblock to use for levels 0 (overworld) and 1 - 9.
// 18014	18027	Ten 2-byte pointers specifying location of level data blocks.
// 1802A	1803D	Ten 2-byte pointers specifying which PPU Spriteblock to use for levels 0 - 9 for second quest.


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// PRG Bank Swap Replacement until end of file
//--------------------------------------------------------------
//	ROM Start	/	PRG Bank Swap Replacement 
//--------------------------------------------------------------
bank 0; org $8000	// 0x00010

org $BF7B	// 0x03F8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 199 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts


//--------------------------------------------------------------
//	Bank 1, $4000	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 1; org $8000	// 0x04010
	
org $BF7B	// 0x07F8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts
	
//--------------------------------------------------------------
//	Bank 2, $8000	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 2; org $8000	// 0x08010
	
org $BF7B	// 0x0BF8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts
	
	
//--------------------------------------------------------------
//	Bank 3, $C000	/ 	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 3; org $8000	// 0x0C010
	
org $BF7B	// 0x0FF8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts

	
//--------------------------------------------------------------
//	Bank 4, $10000	/ 	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 4;	org $8000	// 0x10010

org $BF7B	// 0x13F8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts	


//--------------------------------------------------------------
//	Bank 5, $14000	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 5; org $8000	// 0x14010

org $BF7B	// 0x17F8B
	fill $15,$EA	// Fill 0x15 bytes with NOP
	//nop (x15 bytes, or 21 times)

	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts                


//--------------------------------------------------------------
//	Bank 6, $18000	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 6; org $BF7B	// 0x1BF8B
	fill $15,$EA	// Fill 0x15 bytes with NOP	
	//nop (x15 bytes, or 21 times)
	
	lda.b #$07
	jsr $BFAC
	jmp $E440
	fill $13,$EA	// Fill 0x13 bytes with NOP
	//nop (x13 bytes, or 19 times)
	rts

	jsr BankSwapPRG
	fill $10,$EA	// Fill 0x10 bytes with NOP
	//nop (x10 bytes, or 16 times)
	rts


//--------------------------------------------------------------
//	Bank 7, $1C000	/	PRG Bank Swap Replacement
//--------------------------------------------------------------
bank 7; org $C000	// 0x1C010

	org $E621	// 0x1E631
	jsr SetHorizontalScroll
	
	org $FF7B	// This should be at $FF78, but the addictional PPU check for the initial setup seems not to hurt?
//Some more space at one block thanks to that change
		jmp LoadBank7
	//Clear out old routines
		fillto $FF90,$FF
	
	org $FF90
	LoadBank7:
		lda.b #$07	// Load Bank 7
		jsr BankSwapPRG
		jmp $E440	// Bankswaping Detour? Grab value $00 store it at $F4, then swap to bank 5 and continues with routines
	//Clear out old routines
		fillto $FFAC,$FF

