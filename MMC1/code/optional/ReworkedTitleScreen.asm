//****************************************************************
//    Rework the Title Screen to match recent Zelda titles
//****************************************************************

// Title screen and Intro reworked graphics
bank 1;
// Blank out some of the leaves sprites so the subtitle can be seen
org $5394	// 0x053A4
	fill $10,$00
org $53B4	// 0x053C4
	fill $10,$00
	db $00,$00,$80,$80,$C0,$C0,$C0,$40
	db $00,$00,$40,$60,$20,$20,$20,$00

// Import new title screen graphics
org $56B4	// 0x056C4-0x05EE4
	incbin code/optional/zelda_title/reworked_title.chr


//*******************************************
//	Title screen tile mappings
//*******************************************
bank 6;
org $1A93B	// 0x1A94B
	db $20,$C0,$20
	db $DC,$D7,$24,$24,$24,$E2,$24,$24
	db $9C,$9D,$9D,$C9,$BF,$BF,$BF,$BF
	db $BF,$BF,$BF,$C0,$24,$24,$24,$24
	db $24,$24,$E3,$24,$24,$24,$D6,$DF
org $1A95E	// 0x1A96E
	db $20,$E0,$20
	db $DE,$EE,$24,$24,$24,$E3,$24,$24
	db $71,$72,$73,$74,$75,$76,$77,$78
	db $7C,$8C,$79,$7A,$7B,$AE,$AF,$24
	db $24,$24,$E2,$24,$24,$24,$D6,$DB
org $1A981	// 0x1A991
	db $21,$00,$20
	db $DE,$D8,$EF,$24,$24,$E2,$24,$24
	db $7D,$7E,$7F,$80,$81,$82,$83,$84
	db $85,$86,$87,$88,$89,$8A,$8B,$24
	db $24,$24,$E3,$24,$24,$24,$D6,$DF
org $1A9A4	// 0x1A9B4
	db $21,$20,$20
	db $DC,$DA,$D7,$24,$24,$E3,$24,$24
	db $24,$8D,$8E,$24,$90,$91,$92,$93
	db $94,$95,$96,$97,$98,$99,$9A,$9B
	db $24,$24,$E2,$24,$24,$D4,$D9,$DB
org $1A9C7	// 0x1A9D7
	db $21,$40,$20
	db $DC,$D9,$EE,$24,$24,$E2,$24,$24
	db $9E,$9F,$A0,$A1,$A2,$A3,$A4,$A5
	db $A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD
	db $24,$24,$E3,$24,$24,$D6,$DB,$DF
org $1A9EA	// 0x1A9FA
	db $21,$60,$20
	db $DE,$DB,$D7,$24,$24,$E3,$70,$24
	db $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7
	db $B8,$B9,$BA,$BB,$BC,$BD,$BE,$8F
	db $24,$24,$E2,$24,$24,$D6,$DB,$DB
org $1AA0D	// 0x1AA1D
	db $21,$80,$20
	db $DC,$DD,$D7,$24,$24,$E2,$24,$24
	db $24,$24,$24,$24,$24,$C1,$C2,$C3
	db $C4,$C5,$24,$24,$24,$24,$24,$24
	db $24,$24,$E3,$24,$24,$D6,$DB,$DF
org $1AA30	// 0x1AA40
	db $21,$A0,$20
	db $DE,$DB,$EE,$24,$24,$E3,$24,$C6
	db $C7,$C8,$C8,$C8,$24,$24,$CA,$CB
	db $CC,$CD,$C8,$C8,$C8,$C8,$E8,$E9
	db $D3,$24,$E2,$24,$24,$D6,$DB,$DB


// Attribute table
org $AC9F	// 0x1ACAF
	db $6E,$5F,$55,$5D,$DF,$BB
	// 26 55 55 55 55 99



