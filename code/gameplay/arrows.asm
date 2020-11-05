//************************************************************
//		Separate Arrows-only counter 
//	THIS PATCH DEPENDS ON THE 999 RUPEE HACK
//************************************************************

bank 4;
org $B042	// 0x13042 DropList

db $22,$18,$22,$18,$23,$55,$22,$22,$18,$18	// H R H R F R H H R R    R50-H40-F10
db $0F,$18,$55,$18,$0F,$22,$21,$18,$55,$18	// 5 R H R 5 H C R R R    R50-520-C10 
db $22,$00,$18,$21,$18,$22,$00,$18,$00,$22	// H B R C R H B R B H    R30-H30-B30-C10 
db $22,$22,$23,$18,$22,$23,$22,$55,$22,$18	// H H F R H F H H H R    H60-R20-F20 

//00 = Bomb
//0F = 5 Rupees
//18 = Rupee
//21 = Clock
//22 = Heart
//23 = Fairy
//55 = Arrow     


bank 1;
//Make rupee arrow counter
org $A58C  	// 0x0659C
	lda.w $0677		// Select Arrow counter instead of rupee ($066D)
	ldy.b #$2D		// Move offset of value updater to the second line (default $302,y $2C)

org $8926	// 0x04936
	jsr ShopArrow
	nop

org $AC02	// CPU $7392, 0x06C12
	jmp $7EE1

org $B751	// CPU $7EE1, 0x07761
	cmp.b #$55
	beq ArrowDrop
	lda.w $72A4,x            	
	jmp.w $7395
ArrowDrop:
	lda.w $0659		// Switch item property - 01=Wood,02=Silver
	beq GiveWood
	ldy.b #$02		// Put Item ID store
	jmp.w $7399
GiveWood:	
	ldy #$02
	lda #$01		// Put Item ID store
	jmp $7399


org $A423	// 0x06433
ShopArrow:			// $6B1C ID 02 at $7392. This ID is read and put into Y	
	cpy.b #$02		// Compare ID and end if not arrow
	bne EndArrowShop
	lda.w $0677		// Get arrow count
	clc
	adc.b #$1E		// Give 30 arrows
	ldx.w $0659		// Get arrow type (1,2)
	cmp.w ArrowShopMax,x
	bcc ArrowShopStore
	lda ArrowShopMax,x	// Limit arrows
ArrowShopStore:
	sta.w $0677
EndArrowShop:	
	lda.b #$40                 
	sta.b $29 
	rts
ArrowShopMax:
	db $0,$1E,$3C		// 0,30,60


org $ABD1	// CPU $7361, 0x06BE1
// GiveArrowDrop Hijack before it gets rid of the iteam
	jsr $BFC0		// jsr GiveArrowDrop
	nop
	nop
	nop


// For Overworld
bank 4;
org $BFC0	// PRG $13FC0, 0x13FD0
GiveArrowDrop:
	lda $AC,x		// Check if the item is an arrow before it deletes.
	cmp.b #$55
	bne BackDeleting
	txa
	pha
	lda.w $0677		// Get arrow count
	clc
	adc.b #$05		// Give 5 arrows
	ldx.w $0659		// Get arrow type (1,2)
	cmp.w ArrowDropMax,x
	bcc ArrowDropStore
	lda ArrowDropMax,x	// Limit arrows
ArrowDropStore:
	sta.w $0677
	pla
	tax
BackDeleting:
	lda.b #$FF
	sta.b $AC,x
	sta.b $84,x
	rts
ArrowDropMax:
	db $00,$1E,$3C		// 0,30,60


// COPY OF ABOVE CODE
// Will run in dungeons
bank 1;
org $BFC0	// 0x07FD0
GiveArrowDrop:
	lda $AC,x		// Check if the item is a arrow before it deletes.
	cmp.b #$55
	bne BackDeleting
	txa
	pha
	lda.w $0677		// Get arrow count
	clc
	adc.b #$05		// Give 5 arrows
	ldx.w $0659		// Get arrow type (1,2)
	cmp.w ArrowDropMax,x
	bcc ArrowDropStore
	lda ArrowDropMax,x	// Limit arrows
ArrowDropStore:
	sta.w $0677
	pla
	tax
BackDeleting:
	lda.b #$FF
	sta.b $AC,x
	sta.b $84,x
	rts
ArrowDropMax:
	db $00,$1E,$3C		// 0,30,60


///////////////copy////////////////

bank 5;
org $8E80	// 0x14E90
	lda.w $0677		// Check if now Arrows (default rupee 066D)

org $8E8A	// 0x14E9A
	dec.w $0677


// cpu $8E72 Check if bow in inventory


// Shop
// cpu $88E7
// lda $066D
// lda $0430,x	Load money cost in shop inventory and compares to your money. 
// bcc 		Branches RTS			Needs to be extandet to check decimal.
// lda $0430,x	Load money cost in shop inventory //cpu $88ef

// Item cost
// $6ABA Base Table item Cost. Shop PRG $1863C

// Arrow ID Shop $72AC
// $730C will run when buying item..

// LDA $72A4,X   Load iteam ID to compare what to do with it
// TAX
// TAY
// JMP $E73A


////////////////////////////////////////////////////////////////////////////////////////
// How does the HUD format work at CPU $302 raw table at PRG $6507 (expanded at $7770)?/
////////////////////////////////////////////////////////////////////////////////////////

// Hex 20B608 2424242424242424 20D608 2424242424242424 206C03210024 20AC03210024 20CC03210024 FF
// Dec uuppss nnnnnnnnnnnnnnnn uuppss nnnnnnnnnnnnnnnn uuppssnnnnnn uuppssnnnnnn uuppssnnnnnn FF    
// Dec        HeartRowTop             HeartRowbot      rupee         key          bomb   	    (add two digit entry 208c022100)
// uu - PPU page number high
// pp - PPU page number low
// ss - Length of data transfered
// nn - Symbols for nametable
// FF - End of Table

// $031C - Rupees
// $0322 - Keys
// $0328 - Bombs
// $032E - Arrows

//--- !!! BELOW CODE IS INCLUDED IN RUPEE.ASM !!! ---\\\
// Table preset - Expanded for one Entry
//org $AC70	// PRG $16C70
//	db $20,$B6,$08	// PPU transfer to $20D6
//	db $24,$24,$24,$24,$24,$24,$24,$24
//	db $20,$D6,$08	// PPU transfer to $20B6
//	db $24,$24,$24,$24,$24,$24,$24,$24
//	db $20,$6C,$03	// PPU transfer to $206C
//	db {LOW_X},$00,$24	
//	db $20,$AC,$03	// PPU transfer to $20AC
//	db {LOW_X},$00,$24
//	db $20,$CC,$03	// PPU transfer to $20CC
//	db {LOW_X},$00,$24
//	db $20,$8C,$03	// PPU transfer to $208C
//	db {LOW_X},$00,$24,$FF
