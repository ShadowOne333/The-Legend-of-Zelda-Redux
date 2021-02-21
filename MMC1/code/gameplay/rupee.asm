//***********************************************************
//		999 Rupee counter
//***********************************************************

// 999 Rupee HUD update. We will use an extended HUD since it would need to be rearranged and made compatible with arrows patch

// HUD Icons values
define	RUPEE	$F7
define	ARROW	$65
define	KEY	$F9
define	BOMB	$61
define	LOW_X	$62

//------------------------------------

bank 5;
// Table preset - Expanded for one Entry
org $AC70	// 0x16C80
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

org $B8A0	// CPU $B8A0, PRG $178A0, PC 0x178B0	
// Original routine to load HUD preset. You will find the preset Format further down
UpdateRupee:
	ldy.b #$3D	// Size of the preset is expanded to max $3D (default $2E)
PreTableUpdater:
	lda.w $AC70,y
	sta.w $0302,y
	dey
	bpl PreTableUpdater
// Update Values
	lda.w $067B	// Load hundredths
	beq setX	// If $00, store $62 (small x)
	sta.w $031B
Load10th:
	lda.w $067A	// Load 10th
	lsr		// Shift bits in place
	lsr
	lsr
	lsr
	sta.w $031C
Load01th:
	lda.w $067A			
	beq setBlank	// Set Blank if 00 and 00
NotBlank:
	and.b #$0F	// Cut lower 4bits (lower nibble)
	sta.w $031D                
EndPTU:
	rts           
setX:
	lda.b #$62
	sta.w $031B
	jmp Load10th

setBlank:
	lda.w $067B
	beq Blank
	lda.w $067A
	sta.w $031D
	jmp NotBlank
Blank:	
	lda.b #$24
	sta.w $031D
	rts


bank 1;
// Make rupee arrow, $0677 counter
org $A58C	// PRG $0658C, PC 0x0659C
	lda.w $0677	// Select Arrow counter instead of rupee ($066D)
	ldy.b #$2D	// Move offset of value updater to the second line (default $302,y $2C)

// Make rupee counter decimal and extended to 999. Also, we need to count in hex too since stores would need way more work otherwise.

// RAM Values
// $066D - Rupee hex
// $067D - Add
// $067E - Substract
// $067B - Rupee hundredths value
// $067A - Rupee dec
// $0679 - Rupee hex hundredths

org $A539	// 0x06549
// Do another jump and do the hex counter first and reset buffer
	jmp $6C97	// Jump add rupee code and come back
Substrrupee:
	lda.w $067E	// Check if CounterBuffer is zero
	cmp.b #$00
	beq FrameCheck 
	ldx.w $067A	// Load rupee to X
	dec.w $067E	// Decrease buffer
	dex
	jsr HextoDec
	sta.w $067A	// Store decimal value
	lda.b #$10	// Sound 
	sta.w $0604   
FrameCheck:
	lda.b $15	// It does load FrameCounter
	lsr
	bcs EndFrameCheck
	jmp $6D05	// Jump over free newly available space
EndFrameCheck:
	rts

	fillto $A570,$FF	// Until org $A570, PRG $6570
l_6570:	// $6570, 0x06580, $6D00 in SRAM
	fill $05,$EA	// Fill 5 bytes with NOP

	jsr $9397	// jsr GenerateHexValue, PRG $15397
	jsr $B8A0	// UpdateRupee
	

// Free space
org $A507	// CPU $6C97, 0x06517
AddingRupee:
	lda.w $067D	// Check if CounterBuffer is zero
	cmp.b #$00
	beq JumpSkipAdding
	ldx.w $067A	// Load rupee value to X
	dec.w $067D	// Decrease buffer
	inx
	jsr HextoDec	// Store decimal value
	sta.w $067A
	lda.b #$10	// Sound
	sta.w $0604
JumpSkipAdding:   
	jmp $6CCC	// Back to skip adding
	fill $0D,$FF


bank 5;		// Free space
org $9352	// CPU $9352, 0x15362
HextoDec:
	txa		// Load rupee
	and.b #$0F	// Cut off High byte
	cmp.b #$0F	// Check if under $00
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
	cmp.b #$A0	// Check $99 mark to add 100
	beq addHundredths
	rts
sub10:
	txa
	sbc.b #$06
	cmp.b #$F9	// Check $00 mark in loop sub 100
	beq subHundredths
	rts

addHundredths:
	lda.w $067B
	clc 
	adc.b #$01
	cmp.b #$0A	// Max out if over 900 
	beq maxout
	sta.w $067B
	lda.b #$00
	sta.w $067A
	rts

subHundredths:
	lda.w $067B
	beq end1	// End if hundredths are $00
	dec.w $067B
	lda.b #$99
	sta.w $067A
	rts

maxout:
	lda.b #$99	// Add max value to decimal value
	sta.w $067A
	rts		// To do take X and make it dec in A. Check for plus or minus and operate that with $067B. Also set limit!

GenerateHexValue:	// $9397, 0x153A7
// True table at $B900, PRG $17900, PC 0x17910
// Table for 100th place, then add extra bit
	lda.w $067A	// Load 10
	and.b #$0F	// Take lower bit
	tay		// Store bits to add at the end
	lda $067A	// Load 10 and shift it to 01
	lsr
	lsr
	lsr
	lsr
	sta.b $01	// Store shifted 10 value
	lda.w $067B	// 100 and add it to shifted 10 value to get table index
	beq Check00
back100:
	asl
	asl
	asl
	asl
	clc
	adc.b $01
	sta.b $01
	ldx.b $01
	lda TrueTableHex10,x
CheckMax:
	cmp.b #$FF
	beq Max
	clc
	adc.b #$01
	dey
	bpl CheckMax
	sbc.b #$00			
	sta.w $066D
	rts
Max: 	
	sta.w $066D
	rts
Check00:
	lda.w $067A
	beq Reset
	lda.w $067B
	jmp back100
Reset: 
	sta.w $066D
	rts


org $9F00	// 0x15F10, Originally $B8F0, 0x17900, moved for compatibility with Automap!
// CPU $B8F0, PRG $178F0, PC 0x17900 (Originally 0x17910)
TrueTableHex10:		
// This table needs only to get base 8 bit to find out that we have enough money.
// So there are a lot of FF needed you could mistake as free space.
	db $00,$0A,$14,$1E,$28,$32,$3C,$46
	db $50,$5A,$64,$6E,$78,$82,$8C,$96
	db $A0,$AA,$B4,$BE,$C8,$D2,$DC,$E6
	db $F0,$FA,$FF

	fillto $9F9C,$FF	// Ends at $9F9C, 0x15FAC


