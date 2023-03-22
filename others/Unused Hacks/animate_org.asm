//***********************************************************
//		MMC1 ANIMATION (BY FISKBIT)
//	    Original Snarfblasm code by Fiskbit
// (Reworked for compilation with xkas ASM by ShadowOne333)
//*********************************************************** 

// Adds background animation to Zelda 1 by creating 4 identical RAM banks and inserting different frames of animation into each. Includes a waterfall animation as a proof of concept. Can be used with the automap if the automap graphics are written to all 4 banks instead of just the original 1.

// Intended for use with PRG0. PRG1 will likely require tweaking some of the addresses.

define 	current_level	$10
define	animation_timer	$4F

define	graphics_chunk_index	$051D

define	has_clock	$066C

// Bank 2
define	LoadFixedGraphics	$8012

// Bank 3
define	LoadAreaGraphics	$8044
define	GetOverworldGraphicsChunk	$8091
define	CopyBufferToPpuBank3	$80DC

define	Setup	$E440
define	Reset	$FF50
define	WriteMmc1ControlRegister	$FF98
define	SwitchBank	$FFAC

define	PPU_CONTROL	$2000
define	PPU_MASK	$2001
define	PPU_STATUS	$2002
define	PPU_SCROLL	$2005
define	PPU_ADDRESS	$2006
define	PPU_DATA	$2007

define	MMC1_CONTROL	$8000
define	MMC1_CHR_BANK_0	$A000
define	MMC1_CHR_BANK_1	$C000

define	kMmc1ControlMirroringV	%0000010
define	kMmc1ControlMirroringH	%0000011
define	kMmc1ControlPrgC000Fixed	%0001100
define	kMmc1Control4KbChr	%0010000

// This should be a power of 2. Additional banks will have to be added to the dAnimatedGraphicsBank tables.
define kNumAnimationBanks	4


//****************************************
//	iNES Header
//****************************************
	db $4E,$45,$53,$1A	// Header (NES $1A)
	db $08			// 8 x 16k PRG banks
	db $00			// 0 x 8k CHR banks
	db %00010010		// ROM Settings
	//  |||||||^--- Mirroring: Vertical
	//  ||||||^--- SRAM: Yes
	//  |||||^--- 512k Trainer: Not used
	//  ||||^--- 4 Screen VRAM: Not used
	//  ^^^^--- Mapper: 1
	db %00001000		// RomType: NES 2.0
	db $00,$00		// iNES Tail
	db %01110000		// PRG-RAM size: 70 << 7 (3800)
	db %00001001		// CHR-RAM size: 09 << 7 (C800)
	db $00,$00,$00,$00	// iNES Tail


//----------------------------------------
//	Bank 1; $04000-$08000
//----------------------------------------

bank 1;	org $8D87	// 0x04D97
// Optimizes the Bank1 graphics copy routine.
// Note that the size in $02-03 is big endian.
	ldy.b #$00

CopyBufferToPpuBank1_SkipInitY:
// If there are no hundreds, skip to the partial block.
	lda.b $02
	beq CopyBufferToPpuBank1_LowPart
CopyBufferToPpuBank1_CopyLoopHigh:
// Copy this block of #$100.
	lda.b ($00),y
	sta.w {PPU_DATA}
	iny
	bne CopyBufferToPpuBank1_CopyLoopHigh

// Advance the destination by #$100.
	inc.b $01

// Reduce the remaining size by #$100. If this was the last full #$100, move on to the remaining partial block.
	dec.b $02
	bne CopyBufferToPpuBank1_CopyLoopHigh
	beq CopyBufferToPpuBank1_LowPart	// Unconditional

CopyBufferToPpuBank1_CopyLoopLow:
// Copy one byte of the partial block.
	lda.b ($00),y
	sta.w {PPU_DATA}
	iny

CopyBufferToPpuBank1_LowPart:
// If we haven't finished the partial block, copy the next byte.
	cpy.b $03
	bne CopyBufferToPpuBank1_CopyLoopLow

// Advance to the next chunk and return.
	inc.w {graphics_chunk_index}
	rts

	fill $09,$00

//.IF $ > $8DB4
//	.ERROR Exceeded allocated region.
//.ENDIF
//.IF $ < $8DB4
//	.DSB $8DB4 - $, $00  // Force a crash if this is executed.
//.ENDIF


bank 1;	org $6ACB	// 0x06ADB
// Update an MMC1 write to use 4 KB mode.
	lda.b #{kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringV}


//----------------------------------------
//	Bank 2; $08000-$0C000
//----------------------------------------

bank 2;	org $AF90	// 0x0AFA0
Hijack_HandleAnimation:
// We only animate on the overworld.
	lda.b {current_level}
	bne Hijack_HandleAnimation_Done

// We use our own timer to avoid jumps in the animation when entering the overworld or pausing.
	lda.b {animation_timer}
	lsr
	lsr
	lsr
	lsr
	and.b #({kNumAnimationBanks}-1)
	clc
	adc.b #$01
	jsr WriteMmc1ChrBank1

	inc.b {animation_timer}

Hijack_HandleAnimation_Done:
// Perform the hijacked instruction.
	lda.w {has_clock}

	rts

LoadFixedGraphicsAllBanks:
	lda.b #$00
-;	clc
	adc.b #$01
	pha
	jsr WriteMmc1ChrBank1

	jsr {LoadFixedGraphics}

// We want to skip the sprite chunk for the rest of the banks.
	lda.b #$01
	sta.w {graphics_chunk_index}

	pla
	cmp.b #{kNumAnimationBanks}
	bcc -

	lda.b #$00
	sta.w {graphics_chunk_index}

// Restore the original bank.
	lda.b #$01
	jsr WriteMmc1ChrBank1

	rts

    
//.IF $ > $BF50
//	.ERROR Exceeded region at 03:ABDB.
//.ENDIF


//----------------------------------------
//	Bank 3; $08000-$0C000
//----------------------------------------

bank 3;
org $80EE	// 0x0C0FE
// Optimizes the Bank3 graphics copy routine, since we're calling this a few times during game setup.
// Note that the size in $02-03 is big endian.
CopyBufferToPpuBank1_InitY:
	ldy.b #$00

// If there are no hundreds, skip to the partial block.
	lda.b $02
	beq CopyBufferToPpuBank3_LowPart

CopyBufferToPpuBank3_CopyLoopHigh:
// Copy this block of #$100.
	lda.b ($00),y
	sta.w {PPU_DATA}
	iny
	bne CopyBufferToPpuBank3_CopyLoopHigh

// Advance the destination by #$100.
	inc.b $01

// Reduce the remaining size by #$100. If this was the last full #$100, move on to the remaining partial block.
	dec.b $02
	bne CopyBufferToPpuBank3_CopyLoopHigh
	beq CopyBufferToPpuBank3_LowPart	// Unconditional


CopyBufferToPpuBank3_CopyLoopLow:
// Copy one byte of the partial block.
	lda.b ($00),y
	sta.w {PPU_DATA}
	iny

CopyBufferToPpuBank3_LowPart:
// If we haven't finished the partial block, copy the next byte.
	cpy.b $03
	bne CopyBufferToPpuBank3_CopyLoopLow

// Advance to the next chunk and return.
	inc {graphics_chunk_index}
	rts

	fill $09,$00


//.IF $ > $811B
//	.ERROR Exceeded allocated region.
//.ENDIF
//.IF $ < $811B
//	.DSB $811B - $, $00	// Force a crash if this is executed.
//.ENDIF


//bank 3;	org $ABDB	// 0x0EBEB
bank 3;	org $AD90	// 0x0EDA0
LoadAreaGraphicsWrapper:
// Ensure the correct bank is loaded.
	lda.b #$01
	jsr WriteMmc1ChrBank1
	jmp {LoadAreaGraphics}

LoadAnimatedGraphicsBanks:
// Make sure our PPU state is as expected.
	lda.b #$00
	sta.w {PPU_MASK}
	sta.w {PPU_CONTROL}
	bit.w {PPU_STATUS}

// Set the starting bank. This is one less than the target bank.
	lda.b #$01
	sta.b $04

// Advance to the next bank.
-;	inc.b $04

// Make sure we're doing overworld background graphics.
	lda.b #$00
	sta.w {graphics_chunk_index}

// Swap in the target bank.
	lda.b $04
	jsr WriteMmc1ChrBank1

// Get the graphics pointer and size.
	ldx.b #$00
	jsr {GetOverworldGraphicsChunk}

	jsr {CopyBufferToPpuBank3}

// Copy in the animated tiles.
	jsr CopyAnimatedTiles

// Repeat unless this wasn't the last bank.
	lda.b $04
	cmp.b #{kNumAnimationBanks}
	bcc -

	lda.b #$00
	sta.w {graphics_chunk_index}

// Return to the main bank.
	lda.b #$01
	jsr WriteMmc1ChrBank1
    
// Set CHR Bank 0 because we don't do that in reset anymore.
	lda.b #$00
	sta.w {MMC1_CHR_BANK_0}
	sta.w {MMC1_CHR_BANK_0}
	sta.w {MMC1_CHR_BANK_0}
	sta.w {MMC1_CHR_BANK_0}
	sta.w {MMC1_CHR_BANK_0}

	rts


dAnimatedGraphicsBankListLow:
    db dAnimatedGraphicsBank1
    db dAnimatedGraphicsBank2
    db dAnimatedGraphicsBank3

dAnimatedGraphicsBankListHigh:
    db dAnimatedGraphicsBank1>>8
    db dAnimatedGraphicsBank2>>8
    db dAnimatedGraphicsBank3>>8

// Destination (big endian), source (little endian), size (little endian). Max 256 bytes. Negative-terminated.
dAnimatedGraphicsBank1:
	db $18,$90
	dw dWaterfallFrame1
	dw dWaterfallFrame1_End-dWaterfallFrame1
	db $FF

//.IF $ - dAnimatedGraphicsBank1 > 256
//	.ERROR dAnimatedGraphicsBank1 too large.
//.ENDIF

dAnimatedGraphicsBank2:
	db $18,$90
	dw dWaterfallFrame2
	dw dWaterfallFrame2_End-dWaterfallFrame2
	db $FF

//.IF $ - dAnimatedGraphicsBank2 > 256
//	.ERROR dAnimatedGraphicsBank2 too large.
//.ENDIF

dAnimatedGraphicsBank3:
	db $18,$90
	dw dWaterfallFrame3
	dw dWaterfallFrame3_End-dWaterfallFrame3
	db $FF

//.IF $ - dAnimatedGraphicsBank3 > 256
//	.ERROR dAnimatedGraphicsBank3 too large.
//.ENDIF


CopyAnimatedTiles:
	ldx.b $04

// Get the address of this bank's animated tile info. We do -2 because the lowest bank is 2.
	lda.w dAnimatedGraphicsBankListLow-2,x
	sta.b $05
	lda.w dAnimatedGraphicsBankListHigh-2,x
	sta.b $06

	ldy.b #$FF
// Write the PPU address. If this is negative, we're done.
-;	iny
	lda.b ($05),y
	bmi CopyAnimatedTiles_Done

	bit.w {PPU_STATUS}
	sta.w {PPU_ADDRESS}
	iny
	lda.b ($05),y
	sta.w {PPU_ADDRESS}

// Source
	iny
	lda.b ($05),y
	sta.b $00
	iny
	lda.b ($05),y
	sta.b $01

// Size. The size needs to be big endian, but is stored in the struct as little endian, so we swap it here.
	iny
	lda.b ($05),y
	sta.b $03
	iny
	lda.b ($05),y
	sta.b $02

// Copy the graphics into place.
	sty.b $07
	jsr CopyBufferToPpuBank1_InitY
	ldy.b $07

	jmp -

CopyAnimatedTiles_Done:
	rts


dWaterfallFrame1:
	incbin code/animation/waterfall_frame1.chr
dWaterfallFrame1_End:

dWaterfallFrame2:
	incbin code/animation/waterfall_frame2.chr
dWaterfallFrame2_End:

dWaterfallFrame3:
	incbin code/animation/waterfall_frame3.chr
dWaterfallFrame3_End:


//.IF $ > $BF50
//	.ERROR Exceeded region at 03:ABDB.
//.ENDIF


//----------------------------------------
//	Bank 3; $08000-$0C000
//----------------------------------------

bank 7;	org $E956	// 0x1E969
	jmp LoadFixedGraphicsAllBanks

bank 7;	org $E98E	// 0x1E99E
	jsr LoadAreaGraphicsWrapper

// Update MMC1 writes to use 4 KB mode.
bank 7;	org $E9BA	// 0x1E9CA
	db {kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringH}
bank 7;	org $E9BE	// 0x1E9CE
	db {kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringV}
bank 7;	org $E9CC	// 0x1E9DC
	db {kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringH}
bank 7;	org $EB71	// 0x1EB81
	db {kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringH}
bank 7;	org $EBB2	// 0x1EBC2
	db {kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringH}


bank 7;	org $EC7A	// 0x1EC8A
	jsr Hijack_HandleAnimation


bank 7;	org $FF6D	// 0x1FF7D
// MMC1 is reset at this point, so we're executing from bank 7 now.
	// Turn on 4 KB banking.
	lda.b #({kMmc1Control4KbChr}|{kMmc1ControlPrgC000Fixed}|{kMmc1ControlMirroringH})
	jsr {WriteMmc1ControlRegister}

	lda.b #$03
	jsr {SwitchBank}
	jsr LoadAnimatedGraphicsBanks

	jmp {Setup}


WriteMmc1ChrBank1:
	sta.w {MMC1_CHR_BANK_1}
	lsr
	sta.w {MMC1_CHR_BANK_1}
 	lsr
	sta.w {MMC1_CHR_BANK_1}
	lsr
	sta.w {MMC1_CHR_BANK_1}
	lsr
	sta.w {MMC1_CHR_BANK_1}
	rts


//.IF $ > $FF98
//	.ERROR Exceeded region at 07:FF6D.
//.ENDIF


//----------------------------------------
//	Reset Vector
//----------------------------------------

// The reset vector points into the swappable bank instead of fixed bank for the non-fixed banks, which breaks our new setup code that assumes we're in bank 7 after issuing an MMC1 reset.
// There are less lazy solutions to this (like putting in a proper reset stub in each swappable bank).
bank 0;	org $BFFC	// 0x0400C
	dw {Reset}
bank 1;	org $BFFC	// 0x0800C
	dw {Reset}
bank 2;	org $BFFC	// 0x0C00C
	dw {Reset}
bank 3;	org $BFFC	// 0x1000C
	dw {Reset}
bank 4;	org $BFFC	// 0x1400C
	dw {Reset}
bank 5;	org $BFFC	// 0x1800C
	dw {Reset}
bank 6;	org $BFFC	// 0x1C00C
	dw {Reset}


