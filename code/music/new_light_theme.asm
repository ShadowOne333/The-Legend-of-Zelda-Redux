//-------------------------------------
// Zelda: A New Light music track notes by gzip

// Dungeons 1 Music Notes Data
define new_light_01_notes $11
define new_light_01_reverb_sq $00
define new_light_01_reverb_tri $00
define new_light_01_reverb_bits_sq $90

// Square 2 (22 bytes)
.new_light_01_sq2:
	db $83,$14,$1E,$14,$1E,$14,$1E,$14
	db $1E,$12,$1E,$12,$1E,$12,$1E,$12
	db $1E,$10,$1E,$10,$1E,$10,$1E,$10
	db $1E,$0E,$1E,$0E,$1E,$0E,$1E,$0E
	db $1E,$00

// Square 1 (23 bytes)
.new_light_01_sq1:
	db $81,$08,$83,$1A,$24,$1A,$24,$1A
	db $24,$1A,$24,$18,$24,$18,$24,$18
	db $24,$18,$24,$16,$24,$16,$24,$16
	db $24,$16,$24,$14,$24,$14,$24,$14
	db $24,$14,$24

// Triangle (18 bytes)
.new_light_01_tri:
	db $85,$14,$08,$1A,$22,$20,$12,$08
	db $08,$10,$08,$83,$10,$81,$08,$16
	db $83,$08,$20,$85,$1E,$0E,$08,$08

warnpc .new_light_01_sq2+$100+1


// Dungeons 2 Music Notes Data
define new_light_02_notes $00
define new_light_02_reverb_sq $00
define new_light_02_reverb_tri $00
define new_light_02_reverb_bits_sq $90

// Square 2 (1C bytes)
.new_light_02_sq2:
	db $83,$0C,$1E,$0C,$1E,$0C,$1E,$0C
	db $1E,$0A,$1E,$0A,$1E,$0A,$1E,$0A
	db $1E,$70,$18,$12,$1E,$18,$24,$24
	db $24,$30,$30,$00

// Square 1 (1D bytes)
.new_light_02_sq1:
	db $81,$08,$83,$14,$22,$14,$0A,$14
	db $0A,$14,$0A,$14,$0A,$14,$0A,$14
	db $0A,$14,$0A,$12,$1E,$18,$24,$1E
	db $1E,$2A,$2A,$2A,$2A

// Triangle (31 bytes)
.new_light_02_tri:
	db $81,$0C,$0A,$85,$0C,$83,$08,$14
	db $81,$08,$24,$83,$08,$22,$81,$0A
	db $72,$85,$0A,$86,$08,$14,$81,$08
	db $22,$83,$08,$20,$81,$0A,$12,$18
	db $12,$18,$1E,$18,$1E,$24,$1E,$24
	db $2A,$32,$2A,$24,$1E,$24,$1C,$18
	db $12

warnpc .new_light_02_sq2+$100+1

