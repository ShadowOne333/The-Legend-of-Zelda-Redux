//***********************************************************
//		Change Dungeon Music
//	Code by tacoschip, new Dungeon theme by gzip
//***********************************************************

bank 0; org $9CE5
dungeon_music:
	jmp .start


bank 0; org $8000
.start:
	cpy #$10		// Dungeon music (sequence 1+2)
	beq .load
	cpy #$11
	beq .load

	// 06 = Dungeon 9

	lda $8D5F,y		// Normal tracks
	jmp $9CE8

.load:
	tya			// Section 1 or 2
	and #$01
	asl
	asl
	asl
	sta $66

	lda $10			// Dungeon 1-8
	// clc
	adc #$FF
	asl
	asl
	asl
	asl
	// clc
	adc $66
	tay

	lda .header+0,y		// Note length  (table, index)
	sta $05F4

	lda .header+1,y		// Song ptr
	sta $66
	lda .header+2,y
	sta $67

	lda .header+3,y		// Triangle
	sta $060C

	lda .header+4,y		// Square2
	sta $060B

	lda .header+5,y		// Square1
	sta $060D
	sta $05F5

	lda .header+6,y
	sta $0619

	lda .header+7,y
	sta $05F1

	jmp $9D1A

.header:
	db $00,$DD,$90,$45,$22,$00,$01,$01	// Normal 1
	db $00,$3A,$91,$39,$1C,$00,$01,$01	// Normal 2

	db $11, .new_light_1, .new_light_1>>8, .new_light_1_tri-.new_light_1_sq2, .new_light_1_sq1-.new_light_1_sq2,$00,$01,$01
	db $00, .new_light_2, .new_light_2>>8, .new_light_2_tri-.new_light_2_sq2, .new_light_2_sq1-.new_light_2_sq2,$00,$01,$01

	db $00,$DD,$90,$45,$22,$00,$01,$01	// Normal 1
	db $00,$3A,$91,$39,$1C,$00,$01,$01	// Normal 2

	db $11, .new_light_1, .new_light_1>>8, .new_light_1_tri-.new_light_1_sq2, .new_light_1_sq1-.new_light_1_sq2,$00,$01,$01
	db $00, .new_light_2, .new_light_2>>8, .new_light_2_tri-.new_light_2_sq2, .new_light_2_sq1-.new_light_2_sq2,$00,$01,$01

	db $00,$DD,$90,$45,$22,$00,$01,$01	// Normal 1
	db $00,$3A,$91,$39,$1C,$00,$01,$01	// Normal 2

	db $11, .new_light_1, .new_light_1>>8, .new_light_1_tri-.new_light_1_sq2, .new_light_1_sq1-.new_light_1_sq2,$00,$01,$01
	db $00, .new_light_2, .new_light_2>>8, .new_light_2_tri-.new_light_2_sq2, .new_light_2_sq1-.new_light_2_sq2,$00,$01,$01

	db $00,$DD,$90,$45,$22,$00,$01,$01	// Normal 1
	db $00,$3A,$91,$39,$1C,$00,$01,$01	// Normal 2

	db $11, .new_light_1, .new_light_1>>8, .new_light_1_tri-.new_light_1_sq2, .new_light_1_sq1-.new_light_1_sq2,$00,$01,$01
	db $00, .new_light_2, .new_light_2>>8, .new_light_2_tri-.new_light_2_sq2, .new_light_2_sq1-.new_light_2_sq2,$00,$01,$01


//-------------------------------------
// Zelda: A New Light music track notes by gzip

// Dungeons 1 Music Notes Data
.new_light_1:

// Square 2 (22 bytes)
.new_light_1_sq2:
	db $83,$14,$1E,$14,$1E,$14,$1E,$14
	db $1E,$12,$1E,$12,$1E,$12,$1E,$12
	db $1E,$10,$1E,$10,$1E,$10,$1E,$10
	db $1E,$0E,$1E,$0E,$1E,$0E,$1E,$0E
	db $1E,$00

// Square 1 (23 bytes)
.new_light_1_sq1:
	db $81,$08,$83,$1A,$24,$1A,$24,$1A
	db $24,$1A,$24,$18,$24,$18,$24,$18
	db $24,$18,$24,$16,$24,$16,$24,$16
	db $24,$16,$24,$14,$24,$14,$24,$14
	db $24,$14,$24

// Triangle (18 bytes)
.new_light_1_tri:
	db $85,$14,$08,$1A,$22,$20,$12,$08
	db $08,$10,$08,$83,$10,$81,$08,$16
	db $83,$08,$20,$85,$1E,$0E,$08,$08


// Dungeons 2 Music Notes Data
.new_light_2:

// Square 2 (1C bytes)
.new_light_2_sq2:
	db $83,$0C,$1E,$0C,$1E,$0C,$1E,$0C
	db $1E,$0A,$1E,$0A,$1E,$0A,$1E,$0A
	db $1E,$70,$18,$12,$1E,$18,$24,$24
	db $24,$30,$30,$00

// Square 1 (1D bytes)
.new_light_2_sq1:
	db $81,$08,$83,$14,$22,$14,$0A,$14
	db $0A,$14,$0A,$14,$0A,$14,$0A,$14
	db $0A,$14,$0A,$12,$1E,$18,$24,$1E
	db $1E,$2A,$2A,$2A,$2A

// Triangle (31 bytes)
.new_light_2_tri:
	db $81,$0C,$0A,$85,$0C,$83,$08,$14
	db $81,$08,$24,$83,$08,$22,$81,$0A
	db $72,$85,$0A,$86,$08,$14,$81,$08
	db $22,$83,$08,$20,$81,$0A,$12,$18
	db $12,$18,$1E,$18,$1E,$24,$1E,$24
	db $2A,$32,$2A,$24,$1E,$24,$1C,$18
	db $12

warnpc $8D60+1

bank 0; org $A000
warnpc $BF50+1

