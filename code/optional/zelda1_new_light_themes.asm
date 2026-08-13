;***********************************************************
;	Zelda 1 + A New Light Dungeon Music Themes
;***********************************************************

%org($8066,0)		; 0x00076
.newlight_songs:
	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

.newlight_songs_end:
	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .zelda_1_end-.header
	db .new_light_1_end-.header

	db .zelda_1_end-.header
	db .new_light_1_end-.header
	db .zelda_1_end-.header
	db .new_light_1_end-.header

.newlight_songs_loop:
	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

	db .zelda_1-.header
	db .new_light_1-.header
	db .zelda_1-.header
	db .new_light_1-.header

