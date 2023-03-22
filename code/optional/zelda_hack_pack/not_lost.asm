//
// 	Not Lost (Woods & Hills)
//	(gzip's Zelda Hack Pack)

//------------------------------------
// Make the Lost Woods & Lost Hills just a normal screen instead of having to always walk the correct path to go through

bank 1; org $ADA6	// 0x6DB6
// Change the Lost Woods map location in the code so it never triggers
	cpy.b #$FF	// Originally CPY #$61

org $ADC8	// 0x6DD8
// Change the Lost Hills map location in the code so it never triggers
	cpy.b #$FF	// Originally CPY #$1B
