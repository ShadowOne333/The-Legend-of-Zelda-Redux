//
// Dungeon Music from Zelda: A New Light
//	(gzip's Zelda Hack Pack)

//------------------------------------
bank 0; org $8DFD	// 0x0E0D
// Dungeons 1-8 Music Parts Definitions (2 * 8 = 10 bytes)
	db $11	// Originally $00

//-------------------------------------
// Zelda: A New Light music track notes

// Dungeons 1 Music Notes Data
org $90DD	// 0x10ED
// Square 2 (22 bytes)
	db $83,$14,$1E,$14,$1E,$14,$1E,$14
	db $1E,$12,$1E,$12,$1E,$12,$1E,$12
	db $1E,$10,$1E,$10,$1E,$10,$1E,$10
	db $1E,$0E,$1E,$0E,$1E,$0E,$1E,$0E
	db $1E,$00
// Square 1 (23 bytes)
	db $81,$08,$83,$1A,$24,$1A,$24,$1A
	db $24,$1A,$24,$18,$24,$18,$24,$18
	db $24,$18,$24,$16,$24,$16,$24,$16
	db $24,$16,$24,$14,$24,$14,$24,$14
	db $24,$14,$24
// Triangle (18 bytes)
	db $85,$14,$08,$1A,$22,$20,$12,$08
	db $08,$10,$08,$83,$10,$81,$08,$16
	db $83,$08,$20,$85,$1E,$0E,$08,$08

// Dungeons 2 Music Notes Data
org $113A	// 0x114A
// Square 2 (1C bytes)
	db $83,$0C,$1E,$0C,$1E,$0C,$1E,$0C
	db $1E,$0A,$1E,$0A,$1E,$0A,$1E,$0A
	db $1E,$70,$18,$12,$1E,$18,$24,$24
	db $24,$30,$30,$00
// Square 1 (1D bytes)
	db $81,$08,$83,$14,$22,$14,$0A,$14
	db $0A,$14,$0A,$14,$0A,$14,$0A,$14
	db $0A,$14,$0A,$12,$1E,$18,$24,$1E
	db $1E,$2A,$2A,$2A,$2A
// Triangle (31 bytes)
	db $81,$0C,$0A,$85,$0C,$83,$08,$14
	db $81,$08,$24,$83,$08,$22,$81,$0A
	db $72,$85,$0A,$86,$08,$14,$81,$08
	db $22,$83,$08,$20,$81,$0A,$12,$18
	db $12,$18,$1E,$18,$1E,$24,$1E,$24
	db $2A,$32,$2A,$24,$1E,$24,$1C,$18
	db $12

