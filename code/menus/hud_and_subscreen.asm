//***********************************************************
//	HUD & Subscreen Changes
//***********************************************************

//***********************************************************
//	Table file
//***********************************************************

table code/text/text.tbl,ltr

//------------------------------------

// Change the "X" in the HUD with a custom tile for a new "x"
bank 1;
org $8795	// 0x047A5
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for "x" with Rupee icon in secret caves
org $A59D	// 0x065AD
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for the Key counter with Infinite symbol
org $A5DB	// 0x065EB
	ldy.b #$62	// Originally A0 21 (LDY #$21) - Used for main HUD


// Dummy PPU transfer (not applied in-game, can be left without changing)
org $A51D	// 0x0652D - 0x06C96
	db $20,$6C,$03,$59,$00,$24	// Originally 20 6C 03 21 00 24
	db $20,$AC,$03,$59,$00,$24	// Originally 20 AC 03 21 00 24
	db $20,$CC,$03,$59,$00,$24	// Originally 20 CC 03 21 00 24


// White outline to hearts in HUD (Also changes the outer line of the CAUTION message):
// 0x19XXX: All the dungeon related data in 0x19XXX with the same palette was modified
bank 6;
org $9307	// 0x19317
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9403	// 0x19413
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $94FF	// 0x1950F
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 2)
org $95FB	// 0x1960B
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 3)
org $9607	// 0x19617
	db $0F,$29,$27,$17	// Originally 0F 29 37 17 - Change Link's color for Dungeon 3 to not be pale
org $96F7	// 0x19707
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Change Link's color for Dungeon 4 (Dungeon 5 in 2nd Quest) to not be pale
org $97F3	// 0x19803
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $98EF	// 0x198FF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $99EB	// 0x199FB
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Change Link's color for Dungeon 7 to not be pale
org $9AE7	// 0x19AF7
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9BE3	// 0x19BF3
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9CDF	// 0x19CEF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36


// Subscreen - "USE B BUTTON" text for "B BUTTON" and blank-out below row
org $A039	// 0x1A049
	db b_button>>8,b_button	// Change pointer to upper B button text, label "b_button"
	db blank>>8,blank	// Change pointer to lower B button text, label "blank"
org $A350	// 0x1A360
b_button:
	db $2A,$45,$08
	db "B BUTTON"	// Originally "USE B BUTTON"
	db $FF
org $A35C	// 0x1A36C
blank:
	db $2A,$64,$09
	db "SAVE:UP+A"	// Originally "FOR THIS"
blank_rest:
	db $2A,$6F,$01
	db $6E		// Box bottom-left corner
	db $2A,$70,$4B
	db $6A,$2A,$7B,$01,$6D,$FF	// Other tiles for the box


// Change "TRIFORCE" for "TRIFORCE OF WISDOM"
//org $9D5B	// 0x19D6B
//triforce_name:
	//db $2B,$A7,$12		// Originally 2B AC 08
	//db "TRIFORCE OF WISDOM"	// TRIFORCE
	//db $FF
// Pointer to transfer Triforce name to RAM at 1A06C ($1A05C)
//org $A05C
	//dw triforce_name
