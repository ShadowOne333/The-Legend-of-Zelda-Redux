;***********************************************************
;		MMC1 ANIMATION (BY FISKBIT)
;	    Original Snarfblasm code by Fiskbit
; (Reworked for compilation with xkas ASM by ShadowOne333)
;*********************************************************** 

; Adds background animation to Zelda 1 by creating 4 identical RAM banks and inserting different frames of animation into each. Includes a waterfall animation as a proof of concept. Can be used with the automap if the automap graphics are written to all 4 banks instead of just the original 1.

; Intended for use with PRG0. PRG1 will likely require tweaking some of the addresses.

!current_level			= $10
!animation_timer		= $4F
!graphics_chunk_index		= $051D
!has_clock			= $066C
!disable_animation		= $07FF

; Bank 2
!LoadFixedGraphics		= $8012

; Bank 3
!LoadAreaGraphics		= $8044
!GetOverworldGraphicsChunk	= $8091
!CopyBufferToPpuBank3		= $80DC

!Setup				= $E440
!Reset				= $FF50
!WriteMmc1ControlRegister	= $FF98
!SwitchBank			= $FFAC

!PPU_CONTROL			= $2000
!PPU_MASK			= $2001
!PPU_STATUS			= $2002
!PPU_SCROLL			= $2005
!PPU_ADDRESS			= $2006
!PPU_DATA			= $2007

!MMC1_CONTROL			= $8000
!MMC1_CHR_BANK_0		= $A000
!MMC1_CHR_BANK_1		= $C000

!kMmc1ControlMirroringV		= %0000010
!kMmc1ControlMirroringH		= %0000011
!kMmc1ControlPrgC000Fixed	= %0001100
!kMmc1Control4KbChr		= %0010000

; This should be a power of 2. Additional banks will have to be added to the dAnimatedGraphicsBank tables.
!kNumAnimationBanks		= 4

;----------------------------------------
;	Bank 1; $04000-$08000
;----------------------------------------

%org($8D87,1)		; 0x04D97
; Optimizes the Bank1 graphics copy routine.
; Note that the size in $02-03 is big endian.
	ldy #$00

CopyBufferToPpuBank1_SkipInitY:
; If there are no hundreds, skip to the partial block.
	lda $02
	beq CopyBufferToPpuBank1_LowPart
CopyBufferToPpuBank1_CopyLoopHigh:
; Copy this block of #$100.
	lda ($00),y
	sta !PPU_DATA
	iny
	bne CopyBufferToPpuBank1_CopyLoopHigh

; Advance the destination by #$100.
	inc $01

; Reduce the remaining size by #$100. If this was the last full #$100, move on to the remaining partial block.
	dec $02
	bne CopyBufferToPpuBank1_CopyLoopHigh
	beq CopyBufferToPpuBank1_LowPart	; Unconditional

CopyBufferToPpuBank1_CopyLoopLow:
; Copy one byte of the partial block.
	lda ($00),y
	sta !PPU_DATA
	iny

CopyBufferToPpuBank1_LowPart:
; If we haven't finished the partial block, copy the next byte.
	cpy $03
	bne CopyBufferToPpuBank1_CopyLoopLow

; Advance to the next chunk and return.
	inc !graphics_chunk_index
	rts

	fillbyte $00 : fill $09


%org($AACB,1)		; 0x06ADB
; Update an MMC1 write to use 4 KB mode.
	lda #!kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringV


;----------------------------------------
;	Bank 2; $08000-$0C000
;----------------------------------------

%org($AF90,2)		; 0x0AFA0
;%org($AF31,5)		; 0x16F41
Hijack_HandleAnimation:
; We only animate on the overworld.
	lda !current_level
	ora !disable_animation
	bne Hijack_HandleAnimation_Done

; We use our own timer to avoid jumps in the animation when entering the overworld or pausing.
	lda !animation_timer
	lsr
	lsr
	lsr
	lsr
	and #(!kNumAnimationBanks-1)
	clc
	adc #$01
	jsr WriteMmc1ChrBank1

	inc !animation_timer

Hijack_HandleAnimation_Done:
; Animation Lake fix ported from  MMC5 animation (by Bogaa)
; Lake Drain
	lda $051A	; Lake Drain active on that screen.
	beq SkipLake
	cmp #$0C	; Lake Fully Drained = $0C
	bne DrainSpeed
	lda #$00	; Stop Animation
	sta !animation_timer
DrainSpeed:
	inc !animation_timer
	lda !animation_timer
	cmp #$04	; Check max frame. So it will animate every 4 frames
	bne SkipLake
	lda #$0F	; Set to trigger next frame
	sta !animation_timer
SkipLake:
; Perform the hijacked instruction.
	lda !has_clock
	rts


LoadFixedGraphicsAllBanks:
	lda #$00
-	
	clc
	adc #$01
	pha
	jsr WriteMmc1ChrBank1

	jsr !LoadFixedGraphics

; We want to skip the sprite chunk for the rest of the banks.
	lda #$01
	sta !graphics_chunk_index

	pla

	ldy !disable_animation
	bne LoadFixedGraphicsAllBanks_Done

	cmp #!kNumAnimationBanks
	bcc -

LoadFixedGraphicsAllBanks_Done:
	lda #$00
	sta !graphics_chunk_index

; Restore the original bank.
	lda #$01
	jsr WriteMmc1ChrBank1

	rts


;----------------------------------------
;	Bank 3; $08000-$0C000
;----------------------------------------

%org($80EE,3)		; 0x0C0FE
; Optimizes the Bank3 graphics copy routine, since we're calling this a few times during game setup.
; Note that the size in $02-03 is big endian.
CopyBufferToPpuBank1_InitY:
	ldy #$00

; If there are no hundreds, skip to the partial block.
	lda $02
	beq CopyBufferToPpuBank3_LowPart

CopyBufferToPpuBank3_CopyLoopHigh:
; Copy this block of #$100.
	lda ($00),y
	sta !PPU_DATA
	iny
	bne CopyBufferToPpuBank3_CopyLoopHigh

; Advance the destination by #$100.
	inc $01

; Reduce the remaining size by #$100. If this was the last full #$100, move on to the remaining partial block.
	dec $02
	bne CopyBufferToPpuBank3_CopyLoopHigh
	beq CopyBufferToPpuBank3_LowPart	; Unconditional


CopyBufferToPpuBank3_CopyLoopLow:
; Copy one byte of the partial block.
	lda ($00),y
	sta !PPU_DATA
	iny

CopyBufferToPpuBank3_LowPart:
; If we haven't finished the partial block, copy the next byte.
	cpy $03
	bne CopyBufferToPpuBank3_CopyLoopLow

; Advance to the next chunk and return.
	inc !graphics_chunk_index
	rts

	fillbyte $00 : fill $09


;%org($ABDB,3)		; 0x0EBEB
%org($ADE0,3)		; 0x0EDF0
LoadAreaGraphicsWrapper:
; Ensure the correct bank is loaded.
	lda #$01
	jsr WriteMmc1ChrBank1
	jmp !LoadAreaGraphics

LoadAnimatedGraphicsBanks:
; Make sure our PPU state is as expected.
	lda #$00
	sta !PPU_MASK
	sta !PPU_CONTROL
	bit !PPU_STATUS

	jsr TestChr
	bne LoadAnimatedGraphicsBanks_Done

; Set the starting bank. This is one less than the target bank.
	lda #$01
	sta $04

; Advance to the next bank.
-
	inc $04

; Make sure we're doing overworld background graphics.
	lda #$00
	sta !graphics_chunk_index

; Swap in the target bank.
	lda $04
	jsr WriteMmc1ChrBank1

; Get the graphics pointer and size.
	ldx #$00
	jsr !GetOverworldGraphicsChunk

	jsr !CopyBufferToPpuBank3

; Copy in the animated tiles.
	jsr CopyAnimatedTiles

; Repeat unless this wasn't the last bank.
	lda $04
	cmp #!kNumAnimationBanks
	bcc -

LoadAnimatedGraphicsBanks_Done:
	lda #$00
	sta !graphics_chunk_index

; Return to the main bank.
	lda #$01
	jsr WriteMmc1ChrBank1
    
; Set CHR Bank 0 because we don't do that in reset anymore.
	lda #$00
	sta !MMC1_CHR_BANK_0
	sta !MMC1_CHR_BANK_0
	sta !MMC1_CHR_BANK_0
	sta !MMC1_CHR_BANK_0
	sta !MMC1_CHR_BANK_0

	rts


dAnimatedGraphicsBankListLow:
    db dAnimatedGraphicsBank1
    db dAnimatedGraphicsBank2
    db dAnimatedGraphicsBank3

dAnimatedGraphicsBankListHigh:
    db dAnimatedGraphicsBank1>>8
    db dAnimatedGraphicsBank2>>8
    db dAnimatedGraphicsBank3>>8

; Destination (big endian), source (little endian), size (little endian). Max 256 bytes. Negative-terminated.
; GFX		PPU
; Automap	$1300
; Secrets	$1540
; 1st Water	$1780
; 2nd Water	$1880

dAnimatedGraphicsBank1:
; 1st Half of Water graphics
	db $17,$80
	dw dOW_1st_Frame1
	dw dOW_1st_Frame1_End-dOW_1st_Frame1

; 2nd Half of Water graphics
	db $18,$80
	dw dOW_2nd_Frame1
	dw dOW_2nd_Frame1_End-dOW_2nd_Frame1
	db $FF


dAnimatedGraphicsBank2:
; 1st Half of Water graphics
	db $17,$80
	dw dOW_1st_Frame2
	dw dOW_1st_Frame2_End-dOW_1st_Frame2

; 2nd Half of Water graphics
	db $18,$80
	dw dOW_2nd_Frame2
	dw dOW_2nd_Frame2_End-dOW_2nd_Frame2
	db $FF


dAnimatedGraphicsBank3:
; 1st Half of Water graphics
	db $17,$80
	dw dOW_1st_Frame3
	dw dOW_1st_Frame3_End-dOW_1st_Frame3

; 2nd Half of Water graphics
	db $18,$80
	dw dOW_2nd_Frame3
	dw dOW_2nd_Frame3_End-dOW_2nd_Frame3
	db $FF

;------------------------------------

CopyAnimatedTiles:
	ldx $04

; Get the address of this bank's animated tile info. We do -2 because the lowest bank is 2.
	lda dAnimatedGraphicsBankListLow-2,x
	sta $05
	lda dAnimatedGraphicsBankListHigh-2,x
	sta $06

	ldy #$FF
; Write the PPU address. If this is negative, we're done.
-
	iny
	lda ($05),y
	bmi CopyAnimatedTiles_Done

	bit !PPU_STATUS
	sta !PPU_ADDRESS
	iny
	lda ($05),y
	sta !PPU_ADDRESS

; Source
	iny
	lda ($05),y
	sta $00
	iny
	lda ($05),y
	sta $01

; Size. The size needs to be big endian, but is stored in the struct as little endian, so we swap it here.
	iny
	lda ($05),y
	sta $03
	iny
	lda ($05),y
	sta $02

; Copy the graphics into place.
	sty $07
	jsr CopyBufferToPpuBank1_InitY
	ldy $07

	jmp -

CopyAnimatedTiles_Done:
	rts


; 780->83F, 880->99F
; OW Water tiles, 1st Half, 1st Frame
dOW_1st_Frame1:
	incbin code/animation/ow_1st_frame1.chr
dOW_1st_Frame1_End:

; OW Water tiles, 2nd Half, 1st Frame
dOW_2nd_Frame1:
	incbin code/animation/ow_2nd_frame1.chr
dOW_2nd_Frame1_End:

; OW Water tiles, 1st Half, 2nd Frame
dOW_1st_Frame2:
	incbin code/animation/ow_1st_frame2.chr
dOW_1st_Frame2_End:

; OW Water tiles, 2nd Half, 2nd Frame
dOW_2nd_Frame2:
	incbin code/animation/ow_2nd_frame2.chr
dOW_2nd_Frame2_End:

; OW Water tiles, 1st Half, 3rd Frame
dOW_1st_Frame3:
	incbin code/animation/ow_1st_frame3.chr
dOW_1st_Frame3_End:

; OW Water tiles, 2nd Half, 3rd Frame
dOW_2nd_Frame3:
	incbin code/animation/ow_2nd_frame3.chr
dOW_2nd_Frame3_End:

;----------------------------------------

; CHR-RAM test for flashcarts and non-iNES 2.0 compatible emulators
TestChr:
	ldx #$10
	ldy #$07
-
	tya
	jsr WriteMmc1ChrBank1
	stx !PPU_ADDRESS
	stx !PPU_ADDRESS
	lda dChrTestTable,y
	sta !PPU_DATA
	dey
	bpl -

	ldy #$07
-
	tya
	jsr WriteMmc1ChrBank1
	stx !PPU_ADDRESS
	stx !PPU_ADDRESS
	lda !PPU_DATA
	lda !PPU_DATA
	cmp dChrTestTable,y
	bne TestChr_Failure
	dey
	bpl -

	iny
	sty !disable_animation
	rts

TestChr_Failure:
	ldy #$01
	sty !disable_animation
	rts

dChrTestTable:
	db $00,$FF,$5A,$A5,$F0,$0F,$55,$AA



;----------------------------------------
;	Bank 3; $08000-$0C000
;----------------------------------------

%org($E956,7)		; 0x1E966
	jmp LoadFixedGraphicsAllBanks

%org($E98E,7)		; 0x1E99E
	jsr LoadAreaGraphicsWrapper

; Update MMC1 writes to use 4 KB mode.
%org($E9BA,7)		; 0x1E9CA
	db !kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringH
%org($E9BE,7)		; 0x1E9CE
	db !kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringV
%org($E9CC,7)		; 0x1E9DC
	db !kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringH
%org($EB71,7)		; 0x1EB81
	db !kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringH
%org($EBB2,7)		; 0x1EBC2
	db !kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringH


%org($EC7A,7)		; 0x1EC8A
;%org($EF71,7)		; 0x1EF81
	jsr Hijack_HandleAnimation


%org($FF6D,7)		; 0x1FF7D
; MMC1 is reset at this point, so we're executing from bank 7 now.
	; Turn on 4 KB banking.
	lda #(!kMmc1Control4KbChr|!kMmc1ControlPrgC000Fixed|!kMmc1ControlMirroringH)
	jsr !WriteMmc1ControlRegister

	lda #$03
	jsr !SwitchBank
	jsr LoadAnimatedGraphicsBanks

	jmp !Setup


WriteMmc1ChrBank1:
	sta !MMC1_CHR_BANK_1
	lsr
	sta !MMC1_CHR_BANK_1
 	lsr
	sta !MMC1_CHR_BANK_1
	lsr
	sta !MMC1_CHR_BANK_1
	lsr
	sta !MMC1_CHR_BANK_1
	rts

	;fillbyte $EA : fill $07


;----------------------------------------
;	Reset Vector
;----------------------------------------

; The reset vector points into the swappable bank instead of fixed bank for the non-fixed banks, which breaks our new setup code that assumes we're in bank 7 after issuing an MMC1 reset.
; There are less lazy solutions to this (like putting in a proper reset stub in each swappable bank).
%org($BFFC,0)		; 0x0400C
	dw !Reset
%org($BFFC,1)		; 0x0800C
	dw !Reset
%org($BFFC,2)		; 0x0C00C
	dw !Reset
%org($BFFC,3)		; 0x1000C
	dw !Reset
%org($BFFC,4)		; 0x1400C
	dw !Reset
%org($BFFC,5)		; 0x1800C
	dw !Reset
%org($BFFC,6)		; 0x1C00C
	dw !Reset



