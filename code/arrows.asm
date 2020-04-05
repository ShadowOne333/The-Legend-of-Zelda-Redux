//****************************************
// Separate Arrows-only counter
//****************************************

// Unused RAM addresses?
// $0677 - $067B
// $067F

// Unused SRAM addresses by BogaaBogaa
// CPU $7F2D-7FFE is free SRAM. Or PRG $779D

// HUD Icons values
define	RUPEE	$F7
define	ARROW	$65
define	KEY	$F9
define	BOMB	$61
define	LOW_X	$62


//bank 5;
// Hijack original Arrow usage routine
//org $8E72	// $14E85
// 05:8E72:AD 5A 06  LDA $065A = #$01
// 05:8E75:F0 2F     BEQ $8EA6
// 05:8E77:A2 12     LDX #$12
// 05:8E79:B5 AC     LDA $AC,X @ $00BE = #$00
// 05:8E7B:F0 03     BEQ $8E80
// 05:8E7D:0A        ASL
// 05:8E7E:90 26     BCC $8EA6
// 05:8E80:AD 6D 06  LDA $066D = #$EB
// 05:8E83:F0 21     BEQ $8EA6
// 05:8E85:A9 02     LDA #$02
// 05:8E87:20 80 6D  JSR $6D80
//>05:8E8A:EE 7E 06  INC $067E = #$00
// 05:8E8D:A9 10     LDA #$10
// 05:8E8F:95 AC     STA $AC,X @ $00BE = #$00
// 05:8E91:A9 C0     LDA #$C0
// 05:8E93:9D BC 03  STA $03BC,X @ $03CE = #$C0
// 05:8E96:20 16 71  JSR $7116
// 05:8E99:B5 98     LDA $98,X @ $00AA = #$01
// 05:8E9B:29 0C     AND #$0C
// 05:8E9D:F0 07     BEQ $8EA6
// 05:8E9F:B5 70     LDA $70,X @ $0082 = #$ED
// 05:8EA1:18        CLC
// 05:8EA2:69 03     ADC #$03
// 05:8EA4:95 70     STA $70,X @ $0082 = #$ED
// 	rts

bank 1;
//Visual changes
// Expand table (CPU $6D01)
org $A570	// $06580
	ldy.b #$2E
// Table to move so we have more space to add an entry
	lda.w $AC70,y	// $16C80

bank 5;
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
	db $20,$8C,$02	// PPU transfer to $208C
	db {LOW_X},$00,$FF

bank 1;
// "Erase old tables" (+ update RAM $0677 routine)
org $A507	// $06517
	lda.w $0677
	sta.w $032E
	ldy.b #$21
	lda.w $0664
	rts
	fill $1D,$FF


// Load more space into SRAM. This will add the next 256 bytes. (Value $A5 was in that bank before so we put it into new space)
//org $8D31	// $04D41
//	db $80
//org $B86F	// $0787F
//	db $A5

// Hijack update half heart value to $302 table. (After rupee update)
org $A594	// $065A4
	jsr $6C97	// Jump to $6C97 (0x06517)
	nop
	nop

// Hijack point(CPU $6D0B after $300 page update) 
	//put 657b 4c9d85
// New space (CPU $859D)
	//put 1459d (Tried to write a PPU routine here but then decided to do it properly with existing routines)



// How does the format work at CPU $302 raw table at PRG $6507 (expanded at $7770)?

// Hex 20B608 2424242424242424 20D608 2424242424242424 206C03210024 20AC03210024 20CC03210024 FF
// Dec uuppss nnnnnnnnnnnnnnnn uuppss nnnnnnnnnnnnnnnn uuppssnnnnnn uuppssnnnnnn uuppssnnnnnn ff    
// Dec        HeartRowTop             HeartRowbot      rupee         key          bomb   	    (add two digit entry 208c022100)
// uu - PPU page number high
// pp - PPU page number low
// ss - Length of data transfered
// nn - Symbols for nametable
// ff - End of Table

//$31c 	Rupees
//$322	Keys
//$328	Bombs
//$32e	Arrows

// PRG 1a080 PPU update routine
// PRG 1a0a2 write to ppu
