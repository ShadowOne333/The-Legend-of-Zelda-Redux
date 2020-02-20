//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

bank 1; org $8DB4	// $04DC4-$06003
// Title screen and Intro graphics
	incbin optional/la_gfx00.bin
bank 2; org $807F	// $0808F-$0900F
// Link, items, HUD and Font sprites 
	incbin optional/la_gfx01.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// $0C12B-$0D12A
	incbin optional/la_gfx02.bin
// NPC and enemy sprites
org $911B	// $0D12B-$0F12B
	incbin optional/la_gfx03.bin


//***********************************************************
//	Recoloured Dungeons
//***********************************************************

bank 6;
// Level 1 - 1st Quest Colors (Blue)
org $9407	// $19417
	db $0F,$0C,$1C,$2C
	db $0F,$12,$1C,$2C
org $9478	// $19488
	db $0F,$0C,$1C,$2C
	db $0F,$12,$1C,$2C
//org $94B8	// $194C8 (Fading on Staircase)
//	db $0F,$0C,$1C,$2C
//	db $0F,$12,$1C,$2C
// Level 2 - 1st Quest Colors (Purple)
org $9503	// $19513
	db $0F,$03,$13,$23
	db $0F,$04,$13,$23
//org $9574	// $19584
//	db $0F,$03,$13,$23
//	db $0F,$04,$13,$23
org $95B4	// $195C4
	db $0F,$03,$13,$23
	db $0F,$04,$13,$23
// Level 3 - 1st Quest Colors (Orange)
org $95FF	// $1960F
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
org $9670	// $19680
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
org $96B0	// $196C0
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
// Level 4 - 1st Quest Colors (Yellow)
org $96FB	// $1970B
	db $0F,$08,$18,$28
	db $0F,$12,$18,$28
//org $976C	// $1977C
//	db $0F,$08,$18,$28
//	db $0F,$12,$18,$28
org $97AC	// $197BC
	db $0F,$08,$18,$28
	db $0F,$12,$18,$28
// Level 5 - 1st Quest Colors (Brown)
org $97F7	// $19807
	db $0F,$08,$07,$18
	db $0F,$08,$07,$18
org $9868	// $19878
	db $0F,$08,$07,$18
	db $0F,$08,$07,$18
org $98A8	// $198B8
	db $0F,$08,$07,$18
	db $0F,$08,$07,$18
// Level 6 - 1st Quest Colors (Gray w/Red)
org $98F3	// $19903
	db $0F,$00,$10,$20
	db $0F,$16,$10,$20
//org $9964	// $19974
//	db $0F,$00,$10,$20
//	db $0F,$16,$10,$20
org $99A4	// $199B4
	db $0F,$00,$10,$20
	db $0F,$16,$10,$20
// Level 7 - 1st Quest Colors (Deep blue)
org $99EF	// $199FF
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
org $9A60	// $19A70
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
org $9AA0	// $19AB0
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
// Level 8 - 1st Quest Colors (Green)
org $9AEB	// $19AFB
	db $0F,$0A,$1A,$2A
	db $0F,$12,$1A,$2A
//org $9B5C	// $19B6C
//	db $0F,$0A,$1A,$2A
//	db $0F,$12,$1A,$2A
org $9B9C	// $19BAC
	db $0F,$0A,$1A,$2A
	db $0F,$12,$1A,$2A
// Level 9 - 1st Quest Colors (Red)
org $9BE7	// $19BF7
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26	// Originally 0F 1D 16 26 - Changed for compatibility with other dungeons
org $9C58	// $19C68
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26
org $9C98	// $19CA8
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26


//***********************************************************
//	Rearrange Bosses for Both Quests
//***********************************************************

// Changes bosses to:
// 1st Quest - Level 4: Changes the Manhandla in the level to Red Lanmolas, keeps the two-headed Gleeok at the end
// 1st Quest - Level 7: Changes the Aquamentus for a Patra with Oval attack cycle
// 2nd Quest - Level 2: Changes the two-headed Gleeok to Blue Lanmolas (You can still fight a two-headed Gleeok in Level 6)
// 2nd Quest - Level 8: Changes the 3 Dodongos to a Patra with Circle attack cycle

// Dungeons 1-9 1st Quest
bank 3;
org $8006	// $0C016
// Graphics pointer for Dungeon ?
	dw $9A9B	// dungeon?_graphics	// $9A9B (9B 9A)
org $8022	// $0C032
// Graphics pointer for Dungeon ?
	dw $A7DB	// dungeon?_graphics	// $9A9B (DB A7)

// Tables for Dungeons 1-9 1st Quest
bank 6;
org $8810	// $18820
	db $03
org $8813	// $18823
	db $3A
org $8821	// $18831
	db $53
org $8870	// $18880
	db $93
org $8890	// $188A0
	db $86
org $8893	// $188A3
	db $05
org $8B0C	// $18B1C
	dw $E785
org $8B1C	// $18B2C
	db $AA
org $8B2A	// $18B3A
	db $07
org $8B39	// $18B49
	db $EA
org $8B58	// $18B68
	db $85
org $8B6A	// $18B7A
	dl $C586E8
org $8B8D	// $18B9D
	db $48
org $8BAA	// $18BBA
	db $84
org $8E1A	// $18E2A
	db $64
org $8E2B	// $18E3B
	db $7B
org $8E39	// $18E49
	db $52
org $8E3B	// $18E4B
	db $64
org $8E4A	// $18E5A
	dw $643B
org $8E5A	// $18E6A
	db $64
org $8E69	// $18E79
	db $52
org $8E7B	// $18E8B
	db $52
org $8EAB	// $18EBB
	db $05

// Tables for Dungeons 1-9 2nd Quest
org $9109	// $19119
	db $85
org $910B	// $1911B
	db $2C
org $910D	// $1911D
	db $AA
org $9128	// $19138
	db $AA
org $913D	// $1914D
	db $08
org $913F	// $1914F
	db $85
org $916D	// $1917D
	db $07
org $91BD	// $191CD
	db $A4
org $91ED	// $191FD
	db $84
org $924D	// $1925D
	db $03


//****************************************
// Increase bomb upgrades from 4 to 5
//****************************************
bank 1; org $8B8A	// $04B9A
	adc.b  #$05	// Originally 69 04 (ADC #$04)


//***********************************************************

// Optional?
// One of the MMC conversions, either MMC3 or MMC5, or Optimum
// (Is this really needed?)
