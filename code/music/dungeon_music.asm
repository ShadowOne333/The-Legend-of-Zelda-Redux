//***********************************************************
//		Change Dungeon Music
//	Code by tacoschip, new Dungeon theme by gzip
//***********************************************************

bank 0; org $9C97
	jmp .start
	nop

bank 0; org $9F8F
	jmp .reverb_bits_square

bank 0; org $9E98
	jmp .noise_channel
	nop

// ###################################################

incsrc "code/music/zelda1_dungeon_theme.asm"

bank 0; org $9CBC
	lda $6C			// Sequence #
	ldy $10
	cmp .songs_end-1,y
	jmp .loop

warnpc $9CC6+1


bank 0; org $8000
.loop:
	bne .sequence		// Keep playing

	lda .songs_loop-1,y
	bcs .sequence		// cmp = sec

.start:
	ldy $10			// Dungeon 1-8
	lda .songs-1,y

.sequence:
	sta $6C
	tay

	lda .notes,y
	sta $05F4

	lda .square2_0,y
	sta $66
	lda .square2_1,y
	sta $67

	lda .triangle,y
	sta $060C

	lda .square1,y
	sta $060B

	lda .noise,y		// Default disabled
	sta $060D
	sta $05F5

	lda .reverb_sq,y
	sta $0619

	lda .reverb_tri,y
	sta $05F1

	jmp $9D1A

.reverb_bits_square:
	ldy $0609			// check dungeon song
	cpy #$40
	beq .reverb_bits_square_custom

	ora #$90			// normal feedback
	rts

.reverb_bits_square_custom:
	ldy $6C
	ora .reverb_bits_sq,y
	rts

.noise_channel:
	cmp #$40			// allow dungeon songs
	beq .noise_allow

	and #$91			// keep intro, overworld, ending
	beq .noise_mute

.noise_allow:
	lda $05F5			// check valid noise start ptr
	beq .noise_mute

	jmp $9E9C

.noise_mute:
	jmp $9ED3

.songs:
	db .zelda_1-.header
	db .new_light_1-.header
	db .perils_darkness_1-.header
	db .triforce_power_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .perils_darkness_1-.header
	db .triforce_power_1-.header

.songs_end:
	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .perils_darkness_1_end-.header
	db .triforce_power_1_end-.header

	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .perils_darkness_1_end-.header
	db .triforce_power_1_end-.header

.songs_loop:
	db .zelda_1-.header
	db .new_light_1-.header
	db .perils_darkness_1-.header
	db .triforce_power_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .perils_darkness_1-.header
	db .triforce_power_1-.header

	incsrc "code/music/new_light_theme.asm"
	incsrc "code/music/triforce_power_theme.asm"
	incsrc "code/music/perils_darkness_theme.asm"

.header:

.notes:
	.zelda_1:
		db {zelda_01_notes}
		db {zelda_02_notes}
	.zelda_1_end:

	.new_light_1:
		db {new_light_01_notes}
		db {new_light_02_notes}
	.new_light_1_end:

	.triforce_power_1:
		db {triforce_power_01_notes}
		db {triforce_power_02_notes}
		db {triforce_power_03_notes}
	.triforce_power_1_end:

	.perils_darkness_1:
		db {perils_darkness_01_notes}
		db {perils_darkness_02_notes}
	.perils_darkness_1_end:

.square2_0:
	db .zelda_01_sq2
	db .zelda_02_sq2

	db .new_light_01_sq2
	db .new_light_02_sq2

	db .triforce_power_01_sq2
	db .triforce_power_02_sq2
	db .triforce_power_03_sq2

	db {perils_darkness_01_sq2}
	db {perils_darkness_02_sq2}

.square2_1:
	db .zelda_01_sq2>>8
	db .zelda_02_sq2>>8

	db .new_light_01_sq2>>8
	db .new_light_02_sq2>>8

	db .triforce_power_01_sq2>>8
	db .triforce_power_02_sq2>>8
	db .triforce_power_03_sq2>>8

	db {perils_darkness_01_sq2}>>8
	db {perils_darkness_02_sq2}>>8

.triangle:
	db .zelda_01_tri-.zelda_01_sq2
	db .zelda_02_tri-.zelda_02_sq2

	db .new_light_01_tri-.new_light_01_sq2
	db .new_light_02_tri-.new_light_02_sq2

	db .triforce_power_01_tri-.triforce_power_01_sq2
	db .triforce_power_02_tri-.triforce_power_02_sq2
	db .triforce_power_03_tri-.triforce_power_03_sq2

	db {perils_darkness_01_tri}-{perils_darkness_01_sq2}
	db {perils_darkness_02_tri}-{perils_darkness_02_sq2}

.square1:
	db .zelda_01_sq1-.zelda_01_sq2
	db .zelda_02_sq1-.zelda_02_sq2

	db .new_light_01_sq1-.new_light_01_sq2
	db .new_light_02_sq1-.new_light_02_sq2

	db .triforce_power_01_sq1-.triforce_power_01_sq2
	db .triforce_power_02_sq1-.triforce_power_02_sq2
	db .triforce_power_03_sq1-.triforce_power_03_sq2

	db {perils_darkness_01_sq1}-{perils_darkness_01_sq2}
	db {perils_darkness_02_sq1}-{perils_darkness_02_sq2}

.noise:
	db $00
	db $00

	db $00
	db $00

	db $00
	db $00
	db $00

	db $00
	db $00

.reverb_sq:
	db {zelda_01_reverb_sq}
	db {zelda_02_reverb_sq}

	db {new_light_01_reverb_sq}
	db {new_light_02_reverb_sq}

	db {triforce_power_01_reverb_sq}
	db {triforce_power_02_reverb_sq}
	db {triforce_power_03_reverb_sq}

	db {perils_darkness_01_reverb_sq}
	db {perils_darkness_02_reverb_sq}

.reverb_tri:
	db {zelda_01_reverb_tri}
	db {zelda_02_reverb_tri}

	db {new_light_01_reverb_tri}
	db {new_light_02_reverb_tri}

	db {triforce_power_01_reverb_tri}
	db {triforce_power_02_reverb_tri}
	db {triforce_power_03_reverb_tri}

	db {perils_darkness_01_reverb_tri}
	db {perils_darkness_02_reverb_tri}

.reverb_bits_sq:
	db {zelda_01_reverb_bits_sq}
	db {zelda_02_reverb_bits_sq}

	db {new_light_01_reverb_bits_sq}
	db {new_light_02_reverb_bits_sq}

	db {triforce_power_01_reverb_bits_sq}
	db {triforce_power_02_reverb_bits_sq}
	db {triforce_power_03_reverb_bits_sq}

	db {perils_darkness_01_reverb_bits_sq}
	db {perils_darkness_02_reverb_bits_sq}

warnpc $8D60+1

bank 0; org $A000
warnpc $BF50+1

