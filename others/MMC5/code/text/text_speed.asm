//***********************************************************
//	Increase text printing speed
//***********************************************************

bank 1; 
// Increase text print speed
org $881C	// 0x0482C
	lda.b #$04	// Originally LDA $06

// Skip SFX sound for spaces in text
//org $884C	// 0x0485C
//	cmp.b #$25	// Originally CMP #$25
