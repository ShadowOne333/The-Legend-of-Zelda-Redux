//**********************************************
// MMC1 to MMC3 hack for Zelda 1 (by Infidelity)
//	Disassembled by ShadowOne333
//**********************************************

//------------------------------------
//	iNES Header
//------------------------------------

// 0x00006 - 42
	db $4E,$45,$53,$1A	// Header (NES $1A)
	db 8			// 8 x 16k PRG banks
	db 0			// 0 x 8k CHR banks
	db %01000010		
	//	   ^--- Mirroring: Vertical
	//	  ^--- SRAM: Yes
	//	 ^--- 512k Trainer: Not used
	//	^--- 4 Screen VRAM: Not used
	//  ^^^^--- Mapper: 3
	db %00000000		// RomType: NES
	db $00,$00,$00,$00	// iNES Tail
	db $00,$00,$00,$00

//------------------------------------
//	Graphics pointers
//------------------------------------

// bank 1;
// org $8D3B	
// Pointers for Intro and Title screen graphics
// org $8DB4	
// Start of routine for Intro and Title screen graphics

// bank 2;
// org $8000	// 0x8010
// Pointers for Link, items, HUD and Font sprites
// org $8015	// 0x8025
// Start of routine for Link, items, HUD and Font sprites

// bank 3;
// org $8028	// 0xC038
// Pointer for Dungeon background tiles
// org $802A	// 0xC03A
// Pointer for Dungeon sprites
// org $802C	// 0xC03C
// Pointer for Overworld background tiles
// org $802E	// 0xC03E
// Pointer for Overworld sprites
// org $8064	// 0xC074
// Start of routine for Dungeon tiles
// org $8091	// 0xC0A1
// Start of routine for Overworld tiles

//------------------------------------
//	ROM Start
//------------------------------------

bank 0;
org $BF76	// 0x03F86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x03FBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x03FEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 1;
org $AACB	// 0x06ADB
	lda.b #$C0

org $BF76	// 0x07F86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x07FBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x07FEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 2;
org $BF76	// 0x0BF86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x0BFBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x0BFEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 3;
org $BF76	// 0x0FF86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x0FFBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x0FFEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 4;
org $BF76	// 0x13F86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x13FBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x13FEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 5;
org $BF76	// 0x17F86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x17FBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x17FEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 6;
org $BF76	// 0x1BF86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr $BF98
	lda.b #$00
	sta.w $8001
	jmp $BF90

	fill $08,$00

	lda.b #$07
	jsr $FFAC
	jmp $FFCD
	sta.w $8000
	rts

org $BFAC	// 0x1BFBC
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001
	rts
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

org $BFDF	// 0x1BFEF
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

//------------------------------------

bank 7;
org $E621	// 0x1E631
	jsr $FFC4

org $E9BD	// 0x1E9CD
	lda.b #$00
	sta.w $A000

org $E9CB	// 0x1E9DB
	lda.b #$C0

org $EB70	// 0x1EB80
	lda.b #$C0

org $EBB1	// 0x1EBC1
	lda.b #$C0

org $FF76	// 0x1FF86
	lda.b #$80
	sta.w $A001
	lda.b #$C0
	jsr label1	// JSR $FF98
	lda.b #$00
	sta.w $8001
	jmp label2	// JMP $FF90

	db $00,$00,$00,$02
	db $04,$05,$06,$07
label2:	// FF90:
	lda.b #$07
	jsr $FFAC
	jmp $FFCD

label1:	// FF98:
	sta.w $8000
	rts

org $FFAC	// 0x1FFBC
FFAC:
	asl
	pha
	lda.b #$86
	sta.w $8000
	pla
	sta.w $8001
	ora.b #$01
	pha
	lda.b #$87
	sta.w $8000
	pla
	sta.w $8001	// $FFC0 - Start of Unused space
	rts
FFC4:
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts
FFCD:
	ldx.b #$05
label3:	// $FFCF
	stx.w $8000
	lda.w $FF8A,x
	sta.w $8001
	dex
	bpl label3	// BPL $F4
	jmp $E440
	db $FF
// FFEF:
	sta.w $0302
	lda.b #$01
	sta.w $A000
	rts

