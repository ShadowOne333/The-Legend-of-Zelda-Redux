;***********************************************************
;		999 Rupee counter
;***********************************************************

; 999 Rupee HUD update. We will use an extended HUD since it would need to be rearranged and made compatible with arrows patch

; HUD Icons values
!RUPEE	= $F7
!ARROW	= $65
!KEY	= $F9
!BOMB	= $61
!LOW_X	= $62

;------------------------------------

; Table preset - Expanded for one Entry
%org($AC70,5)		; 0x16C80
	db $20,$B6,$08	; PPU transfer to $20D6
	db $24,$24,$24,$24,$24,$24,$24,$24
	db $20,$96,$08	; PPU transfer to $20B6
	db $24,$24,$24,$24,$24,$24,$24,$24
	db $20,$6C,$03	; PPU transfer to $206C
	db !LOW_X,$00,$24	
	db $20,$AC,$03	; PPU transfer to $20AC
	db !LOW_X,$00,$24
	db $20,$CC,$03	; PPU transfer to $20CC
	db !LOW_X,$00,$24
	db $20,$8C,$03	; PPU transfer to $208C
	db !LOW_X,$00,$24,$FF

%org($B8A0,5)		; CPU $B8A0, PRG $178A0, PC 0x178B0
; Original routine to load HUD preset. You will find the preset Format further down
UpdateRupee:
	ldy #$3D	; Size of the preset is expanded to max $3D (default $2E)
PreTableUpdater:
	lda $AC70,y
	sta $0302,y
	dey
	bpl PreTableUpdater
; Update Values
	lda $067B	; Load hundredths
	beq setX	; If $00, store $62 (small x)
	sta $031B	; Print in place of the small X
Load10th:
	lda $067A	; Load 10th
	lsr		; Shift bits in place
	lsr
	lsr
	lsr
	sta $031C	; Print on the first digit after the small 'x'
Load01th:
	lda $067A
	beq setBlank	; Set Blank if 00 and 00
NotBlank:
	cmp #$0A	; Check for 10 rupees
	bcc KeepSingleDigit	; Keep a single digit if less than 10 rupees
	and #$0F	; Cut lower 4bits (lower nibble)
	sta $031D	; Print on the second digit after the small 'x'
	rts		; EndPTU

KeepSingleDigit:	; $9F64 - called via jmp from KeepSingleDigit in UpdateRupee
	lda $067B		; Check if hundreds digit is present
	bne KeepSingleDigit_Hundreds
	lda $067A		; No hundreds: reload ones digit
	sta $031C		; Write to tens position (display as "x5" style)
	rts
KeepSingleDigit_Hundreds:
	lda $067A		; Hundreds present: reload ones digit
	sta $031D		; Write to ones position ($031C already holds the correct tens digit of 0)
	rts

setX:
	lda #$62
	sta $031B
	jmp Load10th

setBlank:
	lda $067B
	beq Blank
	lda $067A
	sta $031D
	jmp NotBlank
Blank:	
	lda #$24
	sta $031D
	rts


; Make rupee arrow, $0677 counter
%org($A58C,1)		; PRG $0658C, PC 0x0659C
	lda $0677	; Select Arrow counter instead of rupee ($066D)
	ldy #$2D	; Move offset of value updater to the second line (default $302,y $2C)

; Make rupee counter decimal and extended to 999. Also, we need to count in hex too since stores would need way more work otherwise.

; RAM Values
; $066D - Rupee hex
; $067D - Add
; $067E - Substract
; $067B - Rupee hundredths value
; $067A - Rupee dec
; $0679 - Rupee hex hundredths

%org($A539,1)		; 0x06549
; Do another jump and do the hex counter first and reset buffer
	jmp $6C97	; Jump add rupee code and come back
Substrrupee:
	lda $067E	; Check if CounterBuffer is zero
	cmp #$00
	beq FrameCheck 
	ldx $067A	; Load rupee to X
	dec $067E	; Decrease buffer
	dex
	jsr HextoDec
	sta $067A	; Store decimal value
	lda #$10	; Sound 
	sta $0604   
FrameCheck:
	lda $15	; It does load FrameCounter
	lsr
	bcs EndFrameCheck
	jmp $6D05	; Jump over free newly available space
EndFrameCheck:
	rts

	%fillto($A570,1,$FF)	; Until org $A570, PRG $6570
l_6570:	; $6570, 0x06580, $6D00 in SRAM
	nop #05

	jsr $9397	; jsr GenerateHexValue, PRG $15397
	jsr $B8A0	; UpdateRupee
	

; Free space
%org($A507,1)		; CPU $6C97, 0x06517
AddingRupee:
	lda $067D	; Check if CounterBuffer is zero
	cmp #$00
	beq JumpSkipAdding
	ldx $067A	; Load rupee value to X
	dec $067D	; Decrease buffer
	inx
	jsr HextoDec	; Store decimal value
	sta $067A
	lda #$10	; Sound
	sta $0604
JumpSkipAdding:   
	jmp $6CCC	; Back to skip adding
	fillbyte $FF : fill $0D


%org($9352,5)		; CPU $9352, 0x15362, Free space
HextoDec:
	txa		; Load rupee
	and #$0F	; Cut off High byte
	cmp #$0F	; Check if under $00
	bcs sub10
	cmp #$0A	; Check if over $09
	bcs add10
	txa
end1:
	rts
add10:
	txa
	clc
	adc #$06
	cmp #$A0	; Check $99 mark to add 100
	beq addHundredths
	rts
sub10:
	txa
	sbc #$06
	cmp #$F9	; Check $00 mark in loop sub 100
	beq subHundredths
	rts

addHundredths:
	lda $067B
	clc 
	adc #$01
	cmp #$0A	; Max out if over 900 
	beq maxout
	sta $067B
	lda #$00
	sta $067A
	rts

subHundredths:
	lda $067B
	beq end1	; End if hundredths are $00
	dec $067B
	lda #$99
	sta $067A
	rts

maxout:
	lda #$99	; Add max value to decimal value
	sta $067A
	rts		; To do take X and make it dec in A. Check for plus or minus and operate that with $067B. Also set limit!

GenerateHexValue:	; $9397, 0x153A7
; True table at $B900, PRG $17900, PC 0x17910
; Table for 100th place, then add extra bit
	lda $067A	; Load 10
	and #$0F	; Take lower bit
	tay		; Store bits to add at the end
	lda $067A	; Load 10 and shift it to 01
	lsr
	lsr
	lsr
	lsr
	sta $01	; Store shifted 10 value
	lda $067B	; 100 and add it to shifted 10 value to get table index
	beq Check00
back100:
	; FIX: Multiply hundreds by 10 (not 16) to get correct TrueTableHex10 index offset.
	; Previous code used ASL x4 which multiplied by 16, causing the wrong table entry to be selected for any value >= 100.
	; For example, 100 rupees would produce $066D=$A0 (160) instead of $64 (100), letting you buy 160-rupee items with only 100 rupees.
	;
	; We could use a small HundredsTens lookup table (at $9EF6) to get hundreds*10, then add the tens digit to form the correct index into TrueTableHex10.
	; However, since that's already in TrueTableHex10, we'll reuse that one instead
	;
	; Old (buggy):
	;   asl / asl / asl / asl    ; A = hundreds * 16  <-- WRONG
	;   clc
	;   adc $01                ; A = hundreds*16 + tens
	;
	; New (fixed):
	ldx $067B		; X = hundreds digit (0-9)
	lda TrueTableHex10,x	; A = hundreds * 10  (index row offset), lda HundredsTens,x
	clc
	adc $01
	sta $01
	ldx $01
	lda TrueTableHex10,x
CheckMax:
	cmp #$FF
	beq Max
	clc
	adc #$01
	dey
	bpl CheckMax
	sbc #$00			
	sta $066D
	rts
Max: 	
	sta $066D
	rts
Check00:
	lda $067A
	beq Reset
	lda $067B
	jmp back100
Reset: 
	sta $066D
	rts


%org($9F00,5)		; 0x15F10, Originally $B8F0, 0x17900, moved for compatibility with Automap!
; CPU $B8F0, PRG $178F0, PC 0x17900 (Originally 0x17910)
TrueTableHex10:		
; This table needs only to get base 8 bit to find out that we have enough money.
; So there are a lot of FF needed you could mistake as free space.
	db $00,$0A,$14,$1E,$28,$32,$3C,$46
	db $50,$5A,$64,$6E,$78,$82,$8C,$96
	db $A0,$AA,$B4,$BE,$C8,$D2,$DC,$E6
	db $F0,$FA,$FF

	%fillto($9F9C,5,$FF)	; Ends at $9F9C, 0x15FAC

