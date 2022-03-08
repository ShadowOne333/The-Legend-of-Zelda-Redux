//***********************************************************
//	ZELDA name doesn't trigger 2nd Quest
//***********************************************************

// Change TUNIC text back to RING
bank 2;	org $9F6A	// 0x09F7A
	lda.b #$00	// Originally LDA #$01
