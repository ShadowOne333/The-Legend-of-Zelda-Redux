;***********************************************************
;		Only Zelda 1 Dungeon Music
;***********************************************************

%org($8066,0)		; 0x00076
.zelda1_songs:
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header

	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header

.zelda1_songs_end:
	db .zelda_1_end-.header
	db .zelda_1_end-.header
	db .zelda_1_end-.header
	db .zelda_1_end-.header

	db .zelda_1_end-.header
	db .zelda_1_end-.header
	db .zelda_1_end-.header
	db .zelda_1_end-.header

.zelda1_songs_loop:
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header

	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header
	db .zelda_1-.header

