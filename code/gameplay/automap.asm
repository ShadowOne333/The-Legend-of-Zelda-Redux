//***********************************************************
//		AUTOMAP PLUS (BY SNARFBLAM)
//	Disassembled and modified for 1/4 hearts 
//		decrements by ShadowOne333
//*********************************************************** 

//****************************************
//	Table file
//****************************************
table code/text/text.tbl,ltr

//****************************************
//	Control codes
//****************************************

define	RUPEE	$F7
//define	ARROW	$65
define	KEY	$F9
define	BOMB	$61
//define	LOW_X	$62

//***********************************************************

bank 1;
// Change the symbol for infinite keys from "A" to infinite symbol
org $A5A1	// 0x065B1
	lda.b #$64	// Originally A9 0A (LDA #$0A)


// Flip heart rows in HUD:
//org $A507	// 0x06517
	//db $20,$B6,$08	// Originally 20 B6 08
//org $A512	// 0x06522
	//db $20,$96,$08	// Originally 20 D6 08

org $A738	// 0x06748
	cmp.b #$C0	// Originally C9 80 (CMP #$80) - (CMP #$F8 in Automap) Changes the break point for when to change the heart sprite when losing health
org $A741	// 0x06751
	jmp $BD42	// Jump to $BD42 ($17D52 in PC address) - Originally A9 65 D0 02 (LDA #$65, BNE $A747 or $6757 in PC)
	nop		// Originally $02 - NOP a leftover byte the original Automap code forgot


bank 2;
org $A2C7	// 0x0A2D7
	jsr $B020	// Jump to subroutine at $B020 (or $0B030 in PC) - Originally 20 64 A7 (JSR $A764, or $0A774 in PC)
org $A5FE	// 0x0A60E
	jsr $B010	// Jump to subroutine at $B010 (or $0B020 in PC) - Originally 20 25 E6 (JSR $E625, or $1E635 in PC)
org $A77A	// 0x0A78A
	jsr $B000	// Jump to subroutine at $B000 (or $0B010 in PC) - Originally 20 2A 9D (JSR $9D2A, or $9D3A in PC)
org $ABB5	// 0x0ABC5
	jmp $B026	// Jump to $B026 (or $0B036 in PC) - Originally 20 64 A7 (JMP $AF5A, or $0AF6A in PC)


org $B000	// 0x0B010 - Free space
	jsr $B037	// 20 37 B0
code_B003:	// B003:
	lda.w $7F50,x	// BD 50 7F
	sta.w $7F60,y	// 99 60 7F
	dey
	dex
	bpl code_B003	// 10 F6
	jmp $9D2A	// 4C 2A 9D
	jsr $B037	// 20 37 B0
code_B013:	// B013:
	lda.w $7F60,y	// B9 60 7F
	sta.w $7F50,x	// 9D 50 7F
	dey
	dex
	bpl code_B013	// 10 F6
	jmp $E625	// 4C 25 E6
	jsr $B02C	// 20 2C B0
	jmp $A764	// 4C 64 A7
	jsr $B02C	// 20 2C B0
	jmp $AF5A	// 4C 5A AF
	ldx.b #$0F	// A2 0F
	lda.b #$00	// A9 00
code_B030:	// B030:
	sta.w $7F50,x	// 9D 50 7F
	dex
	bpl code_B030	// 10 FA
	rts

	ldy.b #$0F	// A0 0F
	ldx.b $16	// A6 16
	beq $B044	// F0 07
	ldy.b #$1F	// A0 1F
	dex
	beq code_B044	// F0 02
	ldy.b #$2F	// A0 2F
code_B044:	// B044:
	ldx.b #$0F	// A2 0F
	rts


bank 5;
org $85A0	// 0x145B0
	lda.b $EB	// A5 EB
	and.b #$0F	// 29 0F
	tax
	lsr
	pha
	lda.b $EB	// A5 EB
	lsr
	lsr
	lsr
	lsr
	tay
	lsr
	pha
	lda.b #$01	// A9 01
	cpy.b #$00	// C0 00
	beq code_85BA	// F0 04
code_85B6:	// 0x85B6:
	asl
	dey
	bne code_85B6	// D0 FC
code_85BA:	// 0x85BA:
	ora.w $7F50,x	// 1D 50 7F
	sta.w $7F50,x	// 9D 50 7F
	pla
	tay
	pla
	tax
	jsr $BC30	// 20 30 BC
	jmp $A9F4	// 4C F4 A9

org $A8BE	// 0x168CE
	jsr $85A0	// Jump to subroutine at $85A0 (or $145B0 in PC) - Originally 20 F4 A9 (JSR $A9F4, or $16A04 in PC)


org $AF20	// 0x16F30
	lda.b $10	// A5 10
 	beq code_AF2E	// F0 0A
	lda.b $14	// A5 14
	cmp.b #$0E	// C9 0E
	bne code_AF2E	// D0 04
	lda.b #$7E	// A9 7E
	sta.b $14	// 85 14
code_AF2E:	// 0x16F3E
	inc.b $13	// E6 13
	rts


org $B01A	// 0x1702A
	jmp $AF20	// Jump to $AF20, or 16F30 in PC - Originally E6 13 60 (INC $13, RTS)

org $B1F2	// 0x17202
	cmp.b #$D7	// Originally CMP $F8
	bcs code_B1FD	// B0 07
	clc
	adc.b #$18	// Originally ADC #$06
	sta.w $0670	// 8D 70 06
	rts
code_B1FD:	// 0x1720D
	lda.b #$00
	sta.w $0670	// 8D 70 06
	jsr $746C	// 20 6C 74
	bne code_B214	// D0 0D
	dec $0670	// CE 70 06
	lda.b #$00	// A9 00
	sta.w $052E	// 8D 2E 05
	sta.b $63	// 85 63
	sta.b $E0	// 85 E0
	rts
code_B214:
	inc $066F	// EE 6F 06
	rts


org $BC00	// 0x17C10 - Free space
	pha
	lda.b $10	// A5 10
	bne code_BC25	// D0 20
	lda.w $0254	// AD 54 02
	cmp.b #$FF	// C9 FF
	beq code_BC0F	// F0 03
	sta.w $7F29	// 8D 29 7F
code_BC0F:	// 0x17C1F
	lda.b $15	// A5 15
	lsr
	lsr
	lsr
	lsr
	lsr
	bcc code_BC20	// 90 08
	lda.w $7F29	// AD 29 7F
	sta.w $0254	// 8D 54 02
	bne code_BC25	// D0 05
code_BC20:	// 0x17C30
	lda #$FF	// A9 FF
	sta.w $0254	// 8D 54 02
code_BC25:	// 0x17C35
	pla
	jmp $77E7	// Jump to $77E7 (0x07067)

org $BC30	// 0x17C40 - Free space
code_BC30:
	stx.w $6C02	// 8E 02 6C
	sty.w $6C03	// 8C 03 6C
	txa
	asl
	tax
	lda.w $7F50,x	// BD 50 7F
	jsr $BC5A	// 20 5A BC
	sta.w $6C01	// 8D 01 6C
 	sta.w $7F11	// 8D 11 7F
	ldy.w $6C03	// AC 03 6C
	lda.w $7F51,x	// BD 51 7F
	jsr $BC5A	// 20 5A BC
	sta.w $7F12	// 8D 12 7F
	lda.b #$01	// A9 01
	sta.w $6C00	// 8D 00 6C
	jsr $BCB0	// 20 B0 BC
	rts
code_BC5A:	// BC5A:
	cpy.b #$00	// C0 00
	beq code_BC63	// F0 05
code_BC5E:	// BC5E:
	lsr
	lsr
	dey
	bne code_BC5E	// D0 FB
code_BC63:	// BC63:
	and.b #$03	// 29 03
	rts

	lda.w $2002	// AD 02 20 -> PPU_STATUS = #$30
	lda.b #$13	// A9 13
	sta.w $2006	// 8D 06 20 -> PPU_ADDRESS = #$00
	lda.b #$00	// A9 00
	sta.w $2006	// 8D 06 20 -> PPU_ADDRESS = #$00
	lda.b #$00	// A9 00
	sta.w $6C05	// 8D 05 6C
code_BC78:	// BC78
	lda.b #$00	// A9 00
	sta.w $6C04	// 8D 04 6C
code_BC7D:	// BC7D
	ldx.w $6C04	// AE 04 6C
	ldy.w $6C05	// AC 05 6C
	jsr $BC30	// Jump to $BC30
	txa
	pha
	jsr $BCA2	// Jump to $BCA2
	pla
	tax
	inc.w $6C04	// EE 04 6C
	lda.w $6C04	// AD 04 6C
	cmp.b #$08	// C9 08
	bne code_BC7D	// D0 E6
	inc.w $6C05	// EE 05 6C
	lda.w $6C05	// AD 05 6C
	cmp.b #$04	// C9 04
	bne code_BC78	// D0 D7
	rts
code_BCA2:	// BCA2:
	ldx.b #$00	// A2 00
code_BCA4:	// BCA4:
	lda.w $7F18,x	// BD 18 7F
	sta.w $2007	// 8D 07 20 -> PPU_DATA = #$90
	inx
	cpx.b #$10	// E0 10
	bne code_BCA4	// D0 F5
	rts
	lda.b $00	// A5 00
	pha
	lda.b $01	// A5 01
	pha
	ldx.b #$00	// A2 00
	lda.w $6C03	// AD 03 6C
	lsr
	tay
	bcc code_BCC1	// 90 02
	ldx.b #$80	// A2 80
code_BCC1:	// BCC1:
	stx.b $00		// 86 00
	lda.w $6C02	// AD 02 6C
	asl
	asl
	asl
	asl
	clc
	adc.b $00		// 65 00
	sta.b $00		// 85 00
	sta.w $7F16	// 8D 16 7F
	tya
	adc.b #$AD	// 69 AD
	sta.b $01		// 85 01
	tya
	adc.b #$13	// 69 13
	sta.w $7F15	// 8D 15 7F
	lda.b #$10	// A9 10
	sta.w $7F17	// 8D 17 7F
	ldy.b #$00	// A0 00
code_BCE4:	// BCE4:
	lda.b #$FF	// A9 FF
	lsr.w $7F11	// 4E 11 7F
 	bcs code_BCED	// B0 02
	and.b #$0F	// 29 0F
code_BCED:	// BCED:
	lsr.w $7F12	// 4E 12 7F
	bcs code_BCF4	// B0 02
	and.b #$F0	// 29 F0
code_BCF4:	// BCF4:
	sta.w $7F13,y	// 99 13 7F
	iny
	cpy.b #$02	// C0 02
	bne code_BCE4	// D0 E8
	ldy.b #$03	// A0 03
code_BCFE:	// BCFE:
	lda.b ($00),y	// B1 00
	and.w $7F13	// 2D 13 7F
	sta.w $7F18,y	// 99 18 7F
	dey
	bpl code_BCFE	// 10 F5
	ldy.b #$07	// A0 07
code_BD0B:	// BD0B:
	lda.b ($00),y	// B1 00
	and.w $7F14	// 2D 14 7F
	sta.w $7F18,y	// 99 18 7F
	dey
 	cpy.b #$03	// C0 03
	bne code_BD0B	// D0 F3
	ldy.b #$0B	// A0 0B
code_BD1A:	// BD1A:
	lda.b ($00),y	// B1 00
	and.w $7F13	// 2D 13 7F
	sta.w $7F18,y	// 99 18 7F
	dey
	cpy.b #$07	// C0 07
	bne code_BD1A	// D0 F3
	ldy.b #$0F	// A0 0F
code_BD29:	// BD29:
	lda.b ($00),y	// B1 00
	and.w $7F14	// 2D 14 7F
	sta.w $7F18,y	// 99 18 7F
	dey
	cpy.b #$0B	// C0 0B
	bne code_BD29	// D0 F3
	lda.b #$FF	// A9 FF
	sta.w $7F28	// 8D 28 7F
	pla
	sta.b $01	// 85 01
	pla
	sta.b $00	// 85 00
	rts
code_BD42:	// BD42: 1/4 Hearts subroutine
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


bank 6;
org $8089	// 0x18099 - Free space
	jmp $FFC0	// Jump to $FFC0 (or $1FFD0 in PC) - Originally E6 11 60 (INC $11, RTS)

// PPU transfers for Automap tiles in the HUD and Subscreen
org $934F	// 0x1935F
	//db $20,$62,$48,$F5
	//db $20,$82,$48,$F5 
	//db $20,$A2,$48,$F5
	//db $20,$C2,$48,$F5
	//fill $0D,$FF	// FF FF FF FF FF FF FF FF FF FF FF FF FF
	db $20,$62,$08,$30,$31,$32,$33,$34,$35,$36,$37
	db $20,$82,$08,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
	db $20,$A2,$08,$40,$41,$42,$43,$44,$45,$46,$47
	db $20,$C2,$08,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F 
	db $FF

// ASM... for what?
org $9D70	// 0x19D80
	jsr $A080	// 20 80 A0
	lda.b $10	// A5 10
	bne code_9D87	// D0 10
	ldx.w $6C00	// AE 00 6C
	beq code_9D8C	// F0 10
	lda.b #$15	// A9 15
	sta.b $00	// 85 00
	lda.b #$7F	// A9 7F
	sta.b $01	// 85 01
	jsr $A0F6	// 20 F6 A0
code_9D87:	// 9D87:
	lda.b #$00	// A9 00
	sta.w $6C00	// 8D 00 6C
code_9D8C:	// 9D8C:
	rts

org $A00E	// 0x1A01E
// Repoint the subscreen palette mappings for the new Automap tiles
	dw subscreen_attributes	// F0 BE (Pointer to $BEF0) - Originally D3 A2 (Pointer to $A2D3 or $1A2E3 in PC)

org $A07E	// 0x1A08E
// Repoint CPU address (?)
	// dw cpu_address	// D3 A2 (Pointer to $A2D3) - Originally 02 03 (Pointer to $0302)
	db $D3,$A2

// Attribute table and tilemap for the Automap graphics in the HUD and Subscreen
org $BEF0	// 0x1BF00
subscreen_attributes:
	db $23,$C0,$10		// PPU Transfer $23C0
	db $C0,$FF,$70,$00,$00,$44,$55,$55	// Attribute table for HUD
	db $FF,$FF,$37,$00,$00,$44,$55,$55	// Attribute table for HUD
	db $20,$6F,$0E		// PPU Transfer to $206F
	db $69,"B",$6B,$69,"A",$6B,$24,$24,$2F,"LIFE",$2F	// Tiles for item rectangles, B/A and -LIFE-
	db $20,$CF,$06		// PPU Transfer to $20CF
	db $6E,$6A,$6D,$6E,$6A,$6D	// Tiles for the bottom of the HUD rectangles
	db $20,$8F,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$91,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$92,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$94,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$6B,$84,{RUPEE},$24,{KEY},{BOMB},$FF	// PPU Transfer for Rupee, (Empty), Key and Bomb icons in HUD (Jumps 0x20 in PPU per icon)
	db $29,$84,$09		// PPU Transfer to $2984
	db "INVENTORY"		// Tiles for "INVENTORY"



bank 7;
org $E4C1	// 0x1E4D1
	jsr $9D70	// Jump to subroutine at $9D70 - Originally 20 80 A0 (JSR $A080)
org $F322	// 0x1F332
	jsr $FFD6	// Jump to subroutine at $FFD6 ($1FFE6 in PC) - Originally 20 E7 77 (JSR $77E7)

org $FFC0	// 0x1FFD0 - Start of Unused Space
	lda.b $10	// A5 10
	bne code_FFD1	// D0 0D - BNE $FFD1
	lda.b #$05	// A9 05
	jsr $FFAC	// 20 AC FF
	jsr $BC66	// 20 66 BC
	lda.b #$06	// A9 06
	jsr $FFAC	// 20 AC FF
code_FFD1:	// 0x1FFE1
	inc.b $11	// E6 11 
	rts
org $FFD6	// 0x1FFE6
	pha
	lda.w $8000	// AD 00 80
	cmp.b #$20	// C9 20
	bne code_FFE2	// D0 04
	pla
	jmp $BC00	// 4C 00 BC
code_FFE2:	// 0x1FFF2	
	pla
	jmp $77E7 	// 4C E7 77


