//-------------------------------------
// Zelda: Triforce Power music track notes by Matrixz

// Dungeons 1 Music Notes Data
define triforce_power_01_notes $10
define triforce_power_01_reverb_sq $00
define triforce_power_01_reverb_tri $80
define triforce_power_01_reverb_bits_sq $32

// Square 2 ($47 bytes)
.triforce_power_01_sq2:
	db $81,$08,$20,$22,$83,$30,$81,$20,$22,$83,$30,$81,$20,$22,$83,$30
	db $08,$08,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83
	db $2E,$08,$08,$81,$1C,$1E,$83,$2C,$81,$1C,$1E,$83,$2C,$81,$1C,$1E
	db $83,$2C,$08,$08,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83,$2E,$81,$1E
	db $20,$83,$2E,$08,$81,$08,$00

// Square 1 ($48 bytes)
.triforce_power_01_sq1:
	db $81,$08,$81,$08,$20,$22,$83,$30,$81,$20,$22,$83,$30,$81,$20,$22
	db $83,$30,$08,$08,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83,$2E,$81,$1E
	db $20,$83,$2E,$08,$08,$81,$1C,$1E,$83,$2C,$81,$1C,$1E,$83,$2C,$81
	db $1C,$1E,$83,$2C,$08,$08,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83,$2E
	db $81,$1E,$20,$83,$2E,$08,$08,$00

// Triangle ($42 bytes)
.triforce_power_01_tri:
	db $81,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
	db $1C,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
	db $1A,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
	db $18,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
	db $1A,$00

warnpc .triforce_power_01_sq2+$100+1

// Dungeons 2 Music Notes Data
define triforce_power_02_notes $10
define triforce_power_02_reverb_sq $80
define triforce_power_02_reverb_tri $80
define triforce_power_02_reverb_bits_sq $32

// Square 2 ($47 bytes)
.triforce_power_02_sq2:
	db $81,$08,$20,$22,$83,$30,$81,$20,$22,$83,$30,$81,$20,$22,$83,$30
	db $08,$08,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83,$2E,$81,$1E,$20,$83
	db $2E,$08,$08,$81,$1C,$1E,$83,$2C,$81,$1C,$1E,$83,$2C,$81,$1C,$1E
	db $83,$2C,$08,$08,$81,$1A,$1C,$83,$2A,$81,$1A,$1C,$83,$2A,$81,$1A
	db $1C,$83,$2A,$08,$81,$08,$00

// Square 1 ($29 bytes)
.triforce_power_02_sq1:
	db $86,$30,$81,$2E,$30,$86,$34,$81,$30,$2E,$86,$20,$08,$83,$08,$82
	db $20,$1E,$20,$86,$2C,$81,$2A,$2C,$86,$30,$81,$2C,$2A,$86,$1C,$08
	db $83,$08,$82,$1C,$1A,$1C,$08,$08,$00

// Triangle ($42 bytes)
.triforce_power_02_tri:
	db $81,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
	db $1C,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
	db $1A,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
	db $18,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
	db $16,$00

warnpc .triforce_power_02_sq2+$100+1

// Dungeons 3 Music Notes Data
define triforce_power_03_notes $10
define triforce_power_03_reverb_sq $80
define triforce_power_03_reverb_tri $80
define triforce_power_03_reverb_bits_sq $32

// Square 2 ($47 bytes)
.triforce_power_03_sq2:
	db $81,$08,$28,$2A,$83,$38,$81,$28,$2A,$83,$38,$81,$28,$2A,$83,$38
	db $08,$08,$81,$26,$28,$83,$36,$81,$26,$28,$83,$36,$81,$26,$28,$83
	db $36,$08,$08,$81,$2C,$2E,$83,$3C,$81,$2C,$2E,$83,$3C,$81,$2C,$2E
	db $83,$3C,$08,$08,$81,$2E,$30,$83,$3E,$81,$2E,$30,$83,$3E,$81,$2E
	db $30,$83,$3E,$08,$81,$08,$00

// Square 1 ($2b bytes)
.triforce_power_03_sq1:
	db $85,$1A,$81,$08,$22,$24,$38,$85,$36,$83,$08,$2E,$81,$36,$85,$34
	db $81,$08,$28,$85,$26,$08,$81,$08,$85,$24,$81,$08,$81,$22,$24,$2E
	db $85,$3A,$83,$08,$32,$85,$30,$08,$08,$08,$00

// Triangle ($41 bytes)
.triforce_power_03_tri:
	db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
	db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	db $28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28
	db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
	db $00

warnpc .triforce_power_03_sq2+$100+1

