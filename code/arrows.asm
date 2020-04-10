//****************************************
// Separate Arrows-only counter
//****************************************

// Unused RAM addresses?
// $0677 - $067B
// $067F

// Unused SRAM addresses by BogaaBogaa
// CPU $7F2D-7FFE is free SRAM. Or PRG $779D

// $206B PPU offset to start Icon drawing       
// $84 offset or table size.. format??
	
// HUD Icons values
define	RUPEE	$F7
define	ARROW	$65
define	KEY	$F9
define	BOMB	$61
define	LOW_X	$62


bank 5;
//Make are sutract from arrow counter
org $8E8A	// $14E9A - CPU $8E8A, PRG $14E8A
	dec.w $0677

// Shop
// CPU $88E7
// lda.w $066D
// lda.w $0430,x	Load money cost in shop inventory and compares to your money. 
// bcc 			branches RTS			Needs to be extandet to check decimal. 
//
// lda.w $0430,x	Loade money cost in shop inventory //cpu $88ef

// Item cost
// $6ABA Base Table iteam Cost. Shop PRG $1863c

// Arrow ID Shop $72AC
// $730C will run when buying item..

// LDA $72A4,X   loade iteam ID to compare what to do with it           
// TAX                      
// TAY                      
// JMP $E73A                


// 999 rupee HUD update
UpdateRupee:
org $B8A0	// $178B0 - CPU $B8A0, PRG $178A0	
 //Original routine to loade HUD preset. You will find the preset format furter down
	ldy.b #$3D			//Size off the preset is expanded to max $3D (default $2E)
PreTableUpdater:	
	lda.w $AC70,y
	sta.w $0302,y
	dey
	bpl PreTableUpdater
	// Update Values
	lda.w $067B			// Load hundredths
	beq setX			// If $00 store $62 (little x)
	sta.w $031B	
Load10th:		
	lda.w $066D	// Load 10th
	//and.b #$F0	// Cut upper 4bit
	lsr		// Shift bits in place
	lsr
	lsr
	lsr
	sta.w $031C
Load01th:
	lda.w $066D	// Cut lower 4bit
	beq setBlank	// Set Blank if 00 and 00
	and.b #$0F
	sta.w $031D
	rts
setX:
	lda.b #$62
	sta.w $031B
	jmp Load10th
setBlank:
	lda.w $066D
	beq return1
	sta.w $031D
return1:
	rts
	lda.b #$20
	sta.w $031D
	rts


////////////////////////////////////////////////////////////////////////////////////////
// How does the HUD format work at CPU $302 raw table at PRG $6507 (expanded at $7770)?/
////////////////////////////////////////////////////////////////////////////////////////

// Hex 20B608 2424242424242424 20D608 2424242424242424 206C03210024 20AC03210024 20CC03210024 FF
// Dec uuppss nnnnnnnnnnnnnnnn uuppss nnnnnnnnnnnnnnnn uuppssnnnnnn uuppssnnnnnn uuppssnnnnnn ff    
// Dec        HeartRowTop             HeartRowbot      rupee         key          bomb   	    (add two digit entry 208c022100)
// uu - PPU page number high
// pp - PPU page number low
// ss - Length of data transfered
// nn - Symbols for nametable
// F - End of Table

//$31C Rupees
//$322	Keys
//$328	Bombs
//$32e	Arrows


// Table - Expanded for one Entry
org $AC70	// $16C80
	db $20,$B6,$08	// PPU transfer to $20D6
	db $24,$24,$24,$24,$24,$24,$24,$24
	db $20,$96,$08	// PPU transfer to $20B6
	db $24,$24,$24,$24,$24,$24,$24,$24
	db $20,$6C,$03	// PPU transfer to $206C
	db {LOW_X},$00,$24	
	db $20,$AC,$03	// PPU transfer to $20AC
	db {LOW_X},$00,$24
	db $20,$CC,$03	// PPU transfer to $20CC
	db {LOW_X},$00,$24
	db $20,$8C,$03	// PPU transfer to $208C
	db {LOW_X},$00,$24,$FF


//****************************************
// Rupee to 999
//****************************************

bank 1;
//Make rupee arrow counter
org $A58C	// $0659C
	lda.w $0677	// Select Arrow counter instead of rupee ($066D)
	ldy.b #$2D	// Move offset of value updater to the second line (Default $0302,y $2C)

//Make rupee counter decimal and extanded to 999. Also we need to count in hex too, since stores would make way more work otherwise
org $A539	// $6549 ($37 byte)
	//66D Rupee
	//67D Add
	//67E Substract
	//67B Hundredths value
	//67A Rupee dec
	jmp $6C97   	//Jump to add rupee code and come back
SubstactRupee:
	lda.w $067E 	//Check if CounterBuffer is zero
	cmp.b #$00
	beq FrameCheck
	ldx.w $066D	// Load rupee to X
	dec.w $067E	// Decrease buffer
	dex
	jsr HextoDec
	sta.w $066D	// Store decimal value	
	lda.b #$10	// Sound 
	sta.w $0604
FrameCheck:
	lda.b $15
	lsr
	bcs return2
	jmp $6D08	// Jump over free newli avalible space
return2:
	rts  
	fill $1A,$FF	// Until org $A570, PRG $6570
	jsr $B8A0	// UpdateRupee

// Free space
//org $2513	//CPU 6CA3 ($1C byte)
org $2507	// $6500, 0x06510
AddingRupee:
	lda.w $067D   	 	// Check if CounterBuffer is zero
	cmp.b #$00
	beq JumpSkipAdding
	ldx.w $066D		// Load rupee value to X
	dec.w $067D		// Decrease buffer
	inx
	jsr HextoDec		// Store decimal value
	sta.w $066D	
	lda.b #$10		// Sound
	sta.w $0604
JumpSkipAdding:   
	jmp $6CCC		// Back to skip adding
	fill $0D,$FF


bank 5;		// Free space
org $9352	// $15362, CPU 9352, PRG $15352
HextoDec:
	txa		// Load rupee
	and.b #$0F	// Cut off Hhigh byte
	cmp.b #$0F	// Check under $00
	bcs sub10	
	cmp.b #$0A	// Check if over $09
	bcs add10
	txa
end1:
	rts
add10:
	txa
	clc
	adc.b #$06
	cmp.b #$A0		// Check $99 mark to add 100
	beq addHundredths
	rts
sub10:
	txa
	sbc.b #$06
	cmp.b #$F9		// Check $00 mark in loop sub 100
	beq subHundredths
	rts
addHundredths:
	lda.w $067B
	clc 
	adc.b #$01
	cmp.b #$0A		// Max out if over 900 
	beq maxout
	sta.w $067B
	lda.b #$00
	sta.w $066D
	rts
subHundredths:
	lda.w $067B
	beq end1		// End if hundredths are $00
	dec.w $067B
	lda.b #$99
	sta.w $066D
	rts
maxout:
	lda.b #$99		// Add max value to decimal value
	sta.w $066D
	rts			// To-do: Take X and make it dec in A. Check for plus or minus and operate that wiht $067b. Also set limit!
