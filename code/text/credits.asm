;***********************************************************
;	Zelda 1 Credits Text
;***********************************************************

;****************************************
; Table file
;****************************************
incsrc "code/text/text.tbl"

;****************************************
; Control codes
;****************************************
!nextline	= $40	; Jump to next line
!endline	= $C0	; End line parsing
!end		= $FF 	; End

;***********************************************************
;	"Saving Zelda" text pointers
;***********************************************************
; Pointers for text that appears right after saving Zelda
%org($A9B4,2)		; 0x0A9C4
	lda.b #end_text1
	sta $00
	lda.b #end_text1>>8
	sta $01

; Horizontal starting position for "THANKS LINK..."
%org($A94A,2)		; 0x0A95A
	lda #$A6	; Originally LDA #$A4
; Horizontal starting position for "THE HERO..."
%org($A992,2)		; 0x0A9A2
	db $C4,$E7	; Originally C4 E4
;This is an LDA $AB67,Y (B9 07 AB in Hex starting at $AB56)
%org($AB56,2)		; 0x0AB66
	lda end_text2,y	; Originally LDA $AB07,Y
; The table here tells the game what position each character in the "PEACE RETURNS TO HYRULE" text is placed in the Credits
%org($AB6C,2)		; 0x0AB7C
	lda layout_text2,y	; Originally LDA $AAD3,Y

;***********************************************************
;	Credits roll text pointers
;***********************************************************

; The credits pointers are stored in a very odd way ($17 entries)
; For the first entry in the credits, "STAFF" located at $AC5C (or 0x0AC6C), the pointer is $AC5C.
; The 2 byte pointers are separated into two different addresses. The lower bytes for each pointer begin at $AC2E (or 0x0AC3E) with $5C. and the second/high byte of the pointers begin at $AC45 (or 0x0AC55) with $AC. The two bytes combined form the pointer for the "STAFF" text. Code related to the credits begins at $AE13.

%org($AC16,2)		; 0x0AC26
PPUDestLow:
	db $28,$29,$2A,$2B,$20,$21,$22,$23
	db $28,$29,$2A,$2B
	
%org($AC22,2)		; 0x0AC32
PPUDestOffset:	; Line Breaks
	db $46,$10,$50,$84,$30,$60,$01,$48	; Originally $46,$10,$90,$84,$24,$30,$01,$48
	db $03,$25,$05,$40	; Originally $03,$25,$05,$40

; Pointer low byte for each entry
%org($AC2E,2)		; 0x0AC3E
low_bytes:
	db credits_00,credits_01,credits_02,credits_03
	db credits_04,credits_05,credits_06,credits_07
	db credits_08,credits_09,credits_10,credits_11
	db credits_12,credits_13,credits_14,credits_15
	db credits_16,credits_17,credits_18,credits_19
	db credits_20,credits_21,credits_22
	db credits_New1,credits_New2,credits_New3,credits_New4

; Pointer high byte for each entry
%org($AC45,2)		; 0x0AC55
high_bytes:
	db credits_00>>8,credits_01>>8,credits_02>>8,credits_03>>8
	db credits_04>>8,credits_05>>8,credits_06>>8,credits_07>>8
	db credits_08>>8,credits_09>>8,credits_10>>8,credits_11>>8
	db credits_12>>8,credits_13>>8,credits_14>>8,credits_15>>8
	db credits_16>>8,credits_17>>8,credits_18>>8,credits_19>>8
	db credits_20>>8,credits_21>>8,credits_22>>8
	db credits_New1>>8,credits_New2>>8,credits_New3>>8,credits_New4>>8

%org($AC5C,2)		; 0x0AC6C
; Blank out all of the original Credits text previous data (for extra free space in case it`s needed). This gives 0x19E bytes of free space!
	%fillto($ADFA,2,$FF)

;***********************************************************
;   "Saving Zelda" 1st and 2nd text
;***********************************************************

; First text after saving Zelda
%org($A860,2)		; 0x0A870
; The table found here determines the position of each character in the 'end_text2' text table. Each value corresponds to each text character (one by one). If said text is extended (or shortened), so should this table to account for the new (or reduced) characters, as well as their position in the screen.

layout_text2:
; FINALLY,
	db $AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4
; PEACE RETURNS TO HYRULE.
	db $E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,$F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB
; THIS ENDS THE STORY.
	db $4C,$4D,$4E,$4F,$50,$51,$52,$53

end_text1:	; $A8A0 - Originally $A959, 0x0A969
	db "THANKS, LINK, YOU'RE",	' '|!nextline
	db "THE HERO OF HYRULE",	'!'|!endline
; Second text after saving Zelda
end_text2:	; $A8C8 - Originally $AB07, 0x0AB17
	db "AND THUS,"			;24 0A 17 0D 24 1C 18 28
	db "PEACE RETURNS TO HYRULE."	;19 0E 0A 0C 0E 24 1B 0E 1D 1E 1B 17 1C 24 1D 18 24 11 22 1B 1E 15 0E 2C
	db "THE END.",!end;24 24 24 24 FF
	%fillto($A900,2,$FF)

;***********************************************************
;  Credits Roll and Post-credits text
;***********************************************************

%org($ADFA,2)		; 0x0AE0A, Atribute table data for text color.
	db $00,$AA,$FF,$FF,$55,$AA,$AA
	db $FF,$FF,$FF,$55,$00,$00,$00
	db $00,$00,$00,$00,$50,$00,$00
	db $00,$AA,$00,$00

%org($B050,2)		; 0x0B060, Originally $AC60, 0x0AC70
; Length, X Position, "Text"
; Hiroshi Yamauchi, Shigeru Miyamoto, Takashi Tezuka, Toshihiko Nakago, Yasunari Soejima, Tatsuo Nishiyama, Koji Kondo
credits_00:
	db $07,$0C," STAFF "			; STAFF
credits_01:
	db $13,$07,"EXECUTIVE PRODUCER:"	; Executive Producer:
credits_02:
	db $10,$08,"HIROSHI YAMAUCHI"		; Hiroshi Yamauchi
credits_03:
	db $09,$0C,"PRODUCER:"	; Producer... Shigeru Miyamoto
credits_04:
	db $09,$0C,"DIRECTOR:"	; Director... Shigeru Miyamoto
credits_05:
	db $0E,$09,"TAKASHI TEZUKA"		; ..... Takashi Tezuka
credits_06:
	db $09,$0C,"DESIGNER:"	; Designer... Toshihiko Nakago
credits_07:
	db $01,$0B," "	; Removed "PROGRAMMER:" and added it as extended text - db $0B,$0B,"PROGRAMMER:"
credits_08:
	db $10,$08,"YASUNARI SOEJIMA"		; Yasunari Soejima
credits_09:
	db $10,$08,"TATSUO NISHIYAMA"		; Tatsuo Nishiyama
credits_10:
	db $0F,$09,"SOUND COMPOSER:"		; Sound Composer:
credits_11:
	db $0A,$0B,"KOJI KONDO"			; Koji Kondo

credits_12:
	db $18,$04,"ANOTHER QUEST WILL START"	; Another quest will start
credits_13:
	db $0A,$0B,"FROM HERE."			; from here.
credits_14:
	db $17,$05,"PRESS THE START BUTTON."	; Press the START button
credits_15:
	db $0E,$09,$FC,"1986 NINTENDO"		; (C)1986 Nintendo

credits_16:
	db $0E,$09,"YOU ARE GREAT!"		; You are great!
credits_17:
	db $0D,$09,"         -   "		; "         -   "
credits_18:
	db $13,$06,"YOU HAVE AN AMAZING"	; You have an amazing
credits_19:
	db $11,$08,"WISDOM AND POWER!"		; Wisdom and Power!
credits_20:
	db $07,$0C,"THE END"			; The End
credits_21:
	db $15,$05,$2D,"THE LEGEND OF ZELDA",$2D; "The Legend of Zelda"
credits_22:
	db $0E,$09,$FC,"1986 NINTENDO",!end	; (C)1986 Nintendo

;-----------------------------------------------------------
;	Extra credits lines (by bogaa)
;-----------------------------------------------------------

%org($B1C0,2)		; 0x0B1D0
ExtraCredits:
	sty $050A  	; Hijack Fix
	tya
	cmp #$0D	; Number of line in Credits to draw to
	bne Text2
	ldx #$13	; Length of name
LoopText1:
	lda credits_New1,x
	sta $0309,x
	dex
	bne LoopText1
	rts		; EndRoutine and hijack
	
Text2:
	cmp #$13
	bne Text3
	ldx #$13	; Length of name
LoopText2:	
	lda credits_New1,x
	sta $0309,x
	dex
	bne LoopText2	
	rts
	
Text3:
	cmp #$1A
	bne Text4
	ldx #$12	; Length of name
LoopText3:
	lda credits_New2,x
	sta $0309,x
	dex
	bne LoopText3
	rts

Text4:
	cmp #$21
	bne Text5
	ldx #$11	; Length of name
LoopText4:
	lda credits_New3,x
	sta $0309,x
	dex
	bne LoopText4
	rts

Text5:
	cmp #$22
	bne EndExtraCredit
	ldx #$13	; Length of name
LoopText5:
	lda credits_New4,x
	sta $0309,x
	dex
	bne LoopText5
	rts

EndExtraCredit:	
	rts

credits_New1:
	db $FF,"   SHIGERU MIYAMOTO"	
credits_New2:
	db $FF,"    TAKASHI TEZUKA"	
credits_New3:
	db $FF,"      PROGRAMMER:"
credits_New4:
	db $FF,"   TOSHIHIKO NAKAGO"


%org($ABC0,2)		; 0x0ABD0
	db $02,$03,$78,$00	; Timer how long to scroll 02 78 lines first quest. 03 00 line second quest.

; $E2 + $FC TimerLine count 
; $050A	Does Count a line of NT data
; $050C	? Where to update nametable?
; $050D	? Steps 00 to 07
; $050E	TextPointer ID

; $0302 PPU Highbyte. $FF will not run it. $22 is also the high_byte of the destination?
; $0303 PPU Lowbyte? Followed by nametable data

;-----------------------------------------------------------
;   Original routine found at $AE13 for Credits scrolling
;-----------------------------------------------------------

%org($AE13,2)		; 0x0AE23
DrawLine:	; Does Draw a line of nt data to PPU
	ldy #$1F	; Stores 2 lines of $24 probably empty space
	lda #$24
LoopEmptySpace:
	sta $0305,y 	; $0305+ Will be the table that will update the ppu with one line of nametable data
	dey
	bpl LoopEmptySpace

	lda $050A		; Current Line
	beq SetEndDataTable
	cmp #$01
	beq DrawBorder		; Start drawin left right border
	cmp #$2E
	bcc DrawBorder2 	; Stop drawing that border
	bne SetEndDataTable

DrawBorder:
	ldy #$19
	lda #$FA   		; Border Tile (bricks)

LoopBorderTop:
	sta $0308,y
	dey
	bpl LoopBorderTop

DrawBorder2:
	lda #$FA
	sta $0308
	sta $0321

SetEndDataTable:
	lda #$FF		; ???
	sta $0325
	sta $0330
	lda #$20
	sta $0304
	ldx $050C
	lda PPUDestLow,x	; $AC16
	sta $0302
	lda $050D
	tay
	asl
	asl
	asl
	asl
	asl
	
	sta $0303
	lda PPUDestOffset,x 	; $AC22, Line Breaks
BitCheck:
	asl
	dey
	bpl BitCheck
	bcc $79

	ldy $050E   		; Load Text Pointer ID
	cpy #$1B		; Compare if the end of the table is reached? SecondQuest? $17
	bcs LineStepper
	ldx $16
	lda $062D,x
	bne TextCheck
	cpy #$10
	bcs IncreaseTexpointerID
	
TextCheck:	
	ldx $16
	lda $062D,x
	beq LoadTextPointer
	cpy #$0C
	bcc LoadTextPointer
	cpy #$10
	bcc IncreaseTexpointerID

LoadTextPointer:	
	lda low_bytes,y	; $AC2E      
	sta $00
	lda high_bytes,y	; $AC45      
	sta $01
	ldy #$00
	lda ($00),y	; Copy pointer from $00 to $02 too
	sta $02
	iny
	lda ($00),y
	tax
	iny

WriteTextLoop:
	lda ($00),y
	sta $0305,x
	iny
	inx
	dec $02
	bne WriteTextLoop

	ldy $050E
	cpy #$0C		; Empty Line?
	bcc IncreaseTexpointerID
	cpy #$11		; Empty Line?
	bne IncreaseTexpointerID

	lda $16
	asl
	asl
	asl
	tay
	ldx #$00

LoopFor:
	lda $0638,y	; Updates stuff in RAM to PPU nametable data
	sta $030E,x
	iny
	inx
	cpx #$08
	bcc LoopFor

	ldy $0016
	lda $0630,y
	jsr $6E55	; ???
	ldx #$02
LoopFor2:
	lda $01,x
	sta $0318,x
	dex
	bpl LoopFor2

	ldy $050E
IncreaseTexpointerID:
	inc $050E
LineStepper:
	inc $050D
	lda $050C
	and #$03
	cmp #$03
	lda #$08
	bcc Check	; ???
	lda #$06
Check:
	cmp $050D
	bne LineWhatEver
	lda #$00

UpdateLineStepper:
	sta $050D
	ldy $050C
	iny
	cpy #$0C
	bcc LineWhat
	tay
LineWhat:
	sty $050C
LineWhatEver:
	lda $050A
	lsr
	bcs EndLine
	lsr
	bcs EndLine
	ldx #$00
	stx $0328
	stx $032F
	tay
	lda $ADFA,y
	ldy #$05

LoopWhat:
	sta $0329,y
	dey
	bpl LoopWhat

	ldy #$23
	lda $0302
	and #$08
	beq EndFlag
	ldy #$2B

EndFlag:
	sty $0325
	lda $050A
	and #$1F
	asl
	adc #$C0
	sta $0326
	lda #$08
	sta $0327

EndLine:
	ldy $050A
	iny
	tya
	and #$1F
	cmp #$1E
	bcc EndEver
	iny
	iny
EndEver:
	jsr ExtraCredits
	rts

