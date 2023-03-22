//***********************************************************
//	Implement CAUTION text from version PRG1
//***********************************************************

//***********************************************************
//	Table file
//***********************************************************

table code/text/text.tbl,ltr

//------------------------------------

bank 5;
// Changes Y position of the "Continue/Save/Retry text
org $8AE5	// 0x14AF5
	db $50,$27,$37,$47	// Originally 4F 67 7F 
// Changes Y position of the red/white flashing when selecting an option to fit the new spacing
org $8AEC	// 0x14AFC
	db $23,$D2,$43
	db $00,$FF,$CB,$CB,$D3

// New text imported into free space from the PRG1 version
bank 6;
// Pointer change
org $A004	// 0x1A014
	dw save_text	// Pointer originally B4 A2 ($A2B4), changed to D0 AC ($ACD0)
// Fill with FFs (original location of the Continue/Save/Retry text)
org $A2B4	// 0x1A2C4-0x1A2E2
	fill $1F,$FF

// New location:
org $ACD0	// 0x1ACE0
save_text:
	db $23,$C0,$7F,$00	// PPU Transfer
	db $20,$AC,$08		// PPU Transfer (20 6C 08)
	db "CONTINUE"		// 0C 18 17 1D 12 17 1E 0E - CONTINUE
	db $20,$EC,$04		// PPU Transfer (20 CC 04)
	db "SAVE"		// 1C 0A 1F 0E - SAVE
	db $21,$2C,$05		// PPU Transfer
	db "RETRY"		// 1B 0E 1D 1B 22 - RETRY 
	db $23,$D8,$20		// Text Box Tile attribute PPU transfer - Originally 23 D8 60 55
	db $FF,$5F,$5F,$5F,$5F,$5F,$5F,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $21,$83,$01,$69	// PPU Transfers
	db $21,$84,$58,$6A	// for the box
	db $21,$9C,$01,$6B	// or line tiles
	db $21,$A3,$CB,$6C	// that surround
	db $21,$BC,$CB,$6C	// the Caution
	db $23,$03,$01,$6E	// text
	db $23,$04,$58,$6A	// ...
	db $23,$1C,$01,$6D	// ...
	db $21,$CC,$08		// PPU Transfer
	db "CAUTION!"		// 0C 0A 1E 1D 12 18 17 - CAUTION
	db $22,$05,$16		// PPU Transfer
	db "TO AVOID DAMAGING GAME"	// 1D 18 24 0A 1F 18 12 0D 24 0D 0A 16 0A 10 12 17 10 24 10 0A 16 0E - TO AVOID DAMAGING GAME
	db $22,$45,$16		// PPU Transfer
	db "SAVE DATA, HOLD IN THE"	// 12 17 0F 18 24 24 1C 0A 1F 0E 0D 28 24 24 11 18 15 0D 24 24 12 17 - INFO  SAVED,  HOLD  IN
	db $22,$85,$16		// PPU Transfer
	db "RESET BUTTON WHILE YOU"	// 1B 0E 1C 0E 1D 24 24 0B 1E 1D 1D 18 17 24 24 0A 1C 24 24 22 18 1E - RESET  BUTTON  AS  YOU
	db $22,$C5,$16		// PPU Transfer
	db "TURN OFF THE POWER.   "	// 1D 1E 1B 17 24 19 18 20 0E 1B 24 18 0F 0F 63 - TURN POWER OFF.


// Fix Game Over flashing text (by stratoform)
bank 5;
org $8B55	// 0x14B65
	jsr gameover_flash_call
	nop
	sta.w $0305
	rts

org $BF40	// 0x17F50
gameover_flash_call:
	beq gameover_flash_done	// Old detour code

	lda.b $13		// Get save option (0-2)
	and.b #$03

	tay			// Load correct palette
	lda.w gameover_flash_attr,y

gameover_flash_done:
	rts

gameover_flash_attr:
	db $05,$50,$55
