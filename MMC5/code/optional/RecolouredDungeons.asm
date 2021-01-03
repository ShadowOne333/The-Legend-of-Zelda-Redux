//***********************************************************
//	Recoloured Dungeons
//***********************************************************

bank 6;
// Level 1 - 1st Quest Colors (Blue)
org $9407	// 0x19417
	db $0F,$0C,$1C,$2C
	db $0F,$12,$1C,$2C
org $941B	// 0x1942B (Sprites)
	db $0F,$0C,$1C,$2C
org $9478	// 0x19488
	db $0F,$0C,$1C,$2C
	db $0F,$12,$1C,$2C
org $94B8	// 0x194C8 (Fading on Staircase)
	db $0F,$0C,$1C,$2C
	db $0F,$12,$1C,$2C
org $94D0	// 0x194E0 (Dark Rooms)
	db $0F,$0F,$0F,$0C
// Level 2 - 1st Quest Colors [Lvl 3 - 2nd Quest] (Purple)
org $9503	// 0x19513
	db $0F,$03,$13,$23
	db $0F,$04,$13,$23
org $9517	// 0x19527 (Sprites)
	db $0F,$03,$13,$23
org $9574	// 0x19584 (Fading on Staircase)
	db $0F,$03,$13,$23
	db $0F,$04,$13,$23
org $95B4	// 0x195C4
	db $0F,$03,$13,$23
	db $0F,$04,$13,$23
org $95CC	// 0x195DC (Dark Rooms)
	db $0F,$0F,$0F,$03
// Level 3 - 1st Quest Colors [Lvl 2 - 2nd Quest] (Orange)
org $95FF	// 0x1960F
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
org $9613	// 0x19623 (Sprites)
	db $0F,$07,$17,$27
org $9670	// 0x19680
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
org $96B0	// 0x196C0
	db $0F,$07,$17,$27
	db $0F,$12,$17,$27
org $96C8	// 0x196D8 (Dark Rooms)
	db $0F,$0F,$0F,$07
// Level 4 - 1st Quest Colors (Yellow)
org $96FB	// 0x1970B
	db $0F,$08,$18,$28
	db $0F,$12,$18,$28
org $970F	// 0x1971F (Sprites)
	db $0F,$08,$18,$28
org $976C	// 0x1977C (Fading on Staircase)
	db $0F,$08,$18,$28
	db $0F,$12,$18,$28
org $97AC	// 0x197BC
	db $0F,$08,$18,$28
	db $0F,$12,$18,$28
org $97C4	// 0x197D4 (Dark Rooms)
	db $0F,$0F,$0F,$08
// Level 5 - 1st Quest Colors (Dark Red/Brown)
org $97F7	// 0x19807
	db $0F,$0F,$07,$17
	db $0F,$06,$07,$17
org $980B	// 0x1981B (Sprites)
	db $0F,$06,$07,$17
org $9868	// 0x19878
	db $0F,$0F,$07,$17
	db $0F,$06,$07,$17
org $98A8	// 0x198B8
	db $0F,$0F,$07,$17
	db $0F,$06,$07,$17
org $98C0	// 0x198D0 (Dark Rooms)
	db $0F,$0F,$0F,$06
// Level 6 - 1st Quest Colors (Gray w/Red)
org $98F3	// 0x19903
	db $0F,$00,$10,$20
	db $0F,$16,$10,$20
org $9907	// 0x19917 (Sprites)
	db $0F,$00,$10,$20
org $9964	// 0x19974 (Fading on Staircase)
	db $0F,$00,$10,$20
	db $0F,$16,$10,$20
org $99A4	// 0x199B4
	db $0F,$00,$10,$20
	db $0F,$16,$10,$20
org $99BC	// 0x199CC (Dark Rooms)
	db $0F,$0F,$0F,$00
// Level 7 - 1st Quest Colors (Deep blue)
org $99EF	// 0x199FF
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
org $9A03	// 0x19A13 (Sprites)
	db $0F,$02,$12,$22
org $9A60	// 0x19A70
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
org $9AA0	// 0x19AB0
	db $0F,$02,$12,$22
	db $0F,$1C,$12,$22
org $9AB8	// 0x19AC8 (Dark Rooms)
	db $0F,$0F,$0F,$02
// Level 8 - 1st Quest Colors (Green)
org $9AEB	// 0x19AFB
	db $0F,$0A,$1A,$2A
	db $0F,$12,$1A,$2A
org $9AFF	// 0x19B0F (Sprites)
	db $0F,$0A,$1A,$2A
org $9B5C	// 0x19B6C (Fading on Staircase)
	db $0F,$0A,$1A,$2A
	db $0F,$12,$1A,$2A
org $9B9C	// 0x19BAC
	db $0F,$0A,$1A,$2A
	db $0F,$12,$1A,$2A
org $9BB4	// 0x19BC4 (Dark Rooms)
	db $0F,$0F,$0F,$0A
// Level 9 - 1st Quest Colors (Red)
org $9BE7	// 0x19BF7
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26	// Originally 0F 1D 16 26 - Changed for compatibility with other dungeons
org $9BFB	// 0x19C0B (Sprites)
	db $0F,$06,$16,$26
org $9C58	// 0x19C68
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26
org $9C98	// 0x19CA8
	db $0F,$06,$16,$26
	db $0F,$06,$16,$26
org $9CB0	// 0x19CC0 (Dark Rooms)
	db $0F,$0F,$0F,$06
