//***********************************************************
//	Zelda 1 + A New Light Dungeon Music Themes
//***********************************************************

bank 0; org $8066
.songs:
	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

.songs_end:
	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .zelda_1_end-.header
	db .new_light_1_end-.header

	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .zelda_1_end-.header
	db .new_light_1_end-.header

.songs_loop:
	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

