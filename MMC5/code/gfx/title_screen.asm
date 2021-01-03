//***********************************************************
//	Title screen changes
//***********************************************************

//****************************************
//	Hyrule Fantasy subtitle
//****************************************

// HYRULE FANTASY Tiles
// ———————————————
bank 6;
org $AA15	// 0x1AA25
	db $E2,$24,$24,$5D,$54,$56,$58,$5A,$5C,$C2,$C3	// Originally E2 24 24 24 24 24 24 24 C1 C2 C3
	db $C4,$C5,$55,$57,$59,$5B,$5D,$24,$24,$24,$E3	// Originally C4 C5 24 24 24 24 24 24 24 24 E3
// Attribute table
org $AC9F	// 0x1ACAF
	db $6E,$5F,$57,$5D,$DF,$BB	// Originally 6E 5F 55 5D DF BB


// Palette changes for subtitle
// ———————————————
bank 2;
// Change palette to make water/sword blue-er and HYRULE FANTASY a deep blue color
org $94FD	// 0x0950D
	db $36,$30,$21,$02	// Originally 36 30 3B 22
	db $36,$30,$21,$16	// Originally 36 30 3B 16
org $950D	// 0x0951D
	db $36,$30,$21,$02	// Originally 36 30 3B 22

// Title screen Fade-out palette changes for HYRULE FANTASY subtitle, added in the Title Screen Fade-Out section!


//****************************************
//	Waterfall slow animation
//****************************************

org $98F5	// 0x09905
	nop
	nop
	nop


//****************************************
//	ZELDA tiles palette
//****************************************

org $985E	// 0x0986E
	db $36,$16,$28,$0F


//****************************************
//	Triforce glow
//****************************************

org $9863	// 0x09873
	db $28,$28,$28,$38,$38,$30,$30,$38


//****************************************
//	Title screen fade out
//****************************************

// Palette changes for Fade-out on title screen
// Includes changes for the HYRULE FANTASY subtitle, and new Triforce palette changes
org $9969	// 0x09979
// First sequence (Green)
	// New palette		// Original Palette
	db $36,$0F,$00,$10	// 36 0F 00 10
	db $36,$16,$28,$0F	// 36 17 27 0F, $996D, 0x0997D
	db $36,$08,$1A,$28	// 36 08 1A 28
	db $36,$30,$3B,$02	// 36 30 3B 22, $9975, 0x09985
	db $36,$30,$3B,$16	// 36 30 3B 16
	db $36,$16,$28,$0F	// 36 17 27 0F, $997D, 0x0998D
	db $36,$08,$1A,$28	// 36 08 1A 28
	db $36,$30,$3B,$02	// 36 30 3B 22, $9985, 0x09995
// Second sequence (Sky Blue)
	db $39,$0F,$00,$10	// 39 0F 00 10
	db $39,$16,$28,$0F	// 39 17 27 0F, $998D, 0x0999D
	db $39,$08,$1A,$28	// 39 08 1A 28
	db $39,$30,$3B,$02	// 39 30 3B 22, $9995, 0x099A5
	db $39,$30,$3B,$16	// 39 30 3B 16
	db $39,$16,$28,$0F	// 39 17 27 0F, $999D, 0x099AD
	db $39,$08,$1A,$28	// 39 08 1A 28
	db $39,$30,$3B,$02	// 39 30 3B 22, $99A5, 0x099B5
// Third sequence (Turquoise)
	db $31,$0F,$00,$10	// 31 0F 00 10
	db $31,$16,$28,$0F	// 31 17 27 0F, $99AD, 0x099BD
	db $31,$08,$1A,$28	// 31 08 1A 28
	db $31,$30,$3B,$02	// 31 30 3B 22, $99C5, 0x099D5
	db $31,$30,$3B,$16	// 31 30 3B 16
	db $31,$16,$28,$0F	// 31 17 27 0F, $99BD, 0x099CD
	db $31,$08,$1A,$28	// 31 08 1A 28
	db $31,$30,$3B,$02	// 31 30 3B 22, $99C5, 0x099D5
// Fourth sequence (Green)
	db $3C,$0F,$00,$10	// 3C 0F 00 10
	db $3C,$16,$28,$0F	// 3C 17 27 0F, $99CD, 0x099DD
	db $3C,$08,$1A,$28	// 3C 08 1A 28
	db $3C,$30,$3B,$02	// 3C 30 3B 22, $99E5, 0x099F5
	db $3C,$30,$3B,$16	// 3C 30 3B 16
	db $3C,$16,$28,$0F	// 3C 17 27 0F, $99DD, 0x099ED
	db $3C,$08,$1A,$28	// 3C 08 1A 28
	db $3C,$30,$3B,$02	// 3C 30 3B 22, $99E5, 0x099F5
// Fifth sequence (Blue)
	db $3B,$0F,$00,$10	// 3B 0F 00 10
	db $3B,$16,$28,$0F	// 3B 17 27 0F, $99ED, 0x099FD
	db $3B,$08,$1A,$28	// 3B 08 1A 28
	db $3B,$10,$3B,$02	// 3B 10 3B 22, $99F5, 0x09A05
	db $3B,$10,$3B,$16	// 3B 10 3B 16
	db $3B,$16,$28,$0F	// 3B 17 27 0F, $99FD, 0x09A0D
	db $3B,$08,$1A,$28	// 3B 08 1A 28
	db $3B,$10,$3B,$02	// 3B 10 3B 22, $9A05, 0x09A15
// Sixth sequence (Deep Blue)
	db $2C,$0F,$00,$10	// 2C 0F 00 10
	db $2C,$16,$28,$0F	// 2C 17 27 0F, $9A0D, 0x09A1D
	db $2C,$08,$1A,$28	// 2C 08 1A 28
	db $2C,$10,$3B,$02	// 2C 10 3B 22, $9A15, 0x09A25
	db $2C,$10,$3B,$16	// 2C 10 3B 16
	db $2C,$16,$28,$0F	// 2C 17 27 0F, $9A1D, 0x09A2D
	db $2C,$08,$1A,$28	// 2C 08 1A 28
	db $2C,$10,$3B,$02	// 2C 10 3B 22, $9A25, 0x09A35
// Seventh sequence (Dark Blue)
	db $1C,$0F,$00,$10	// 1C 0F 00 10
	db $1C,$16,$28,$0F	// 1C 17 27 0F, $9A2D, 0x09A3D
	db $1C,$08,$1A,$28	// 1C 08 1A 28
	db $1C,$10,$3B,$02	// 1C 10 3B 22, $9A35, 0x09A45
	db $1C,$10,$3B,$16	// 1C 10 3B 16
	db $1C,$16,$28,$0F	// 1C 17 27 0F, $9A4D, 0x09A5D
	db $1C,$08,$1A,$28	// 1C 08 1A 28
	db $1C,$10,$3B,$02	// 1C 10 3B 22, $9A55, 0x09A65
// Eighth sequence (Dark Purple)
	db $02,$0F,$00,$10	// 02 0F 00 10
	db $02,$06,$28,$0F	// 02 06 27 0F
	db $02,$0A,$1A,$18	// 02 0A 1A 18
	db $02,$10,$2B,$12	// 02 10 2B 12
	db $02,$10,$2B,$06	// 02 10 2B 06
	db $02,$06,$28,$0F	// 02 06 27 0F
	db $02,$0A,$1A,$18	// 02 0A 1A 18
	db $02,$10,$2B,$12	// 02 10 2B 12
// Eighth sequence (Black)
	db $0C,$0F,$00,$10	// 0C 0F 00 10
	db $0C,$03,$17,$0F	// 0C 03 16 0F
	db $0C,$01,$0A,$08	// 0C 01 0A 08
	db $0C,$00,$1B,$02	// 0C 00 1B 02
	db $0C,$00,$1B,$02	// 0C 00 1B 02
	db $0C,$03,$17,$0F	// 0C 03 16 0F
	db $0C,$01,$0A,$08	// 0C 01 0A 08
	db $0C,$00,$1B,$02	// 0C 00 1B 02


