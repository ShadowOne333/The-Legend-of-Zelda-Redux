//****************************************
// Increase initial max bombs from 8 to 10
//****************************************
bank 2; org $9F4B	// 0x09F5B
	lda.b  #$0A	// Originally A9 08 (LDA $08)
	

//****************************************
// Increase bomb upgrades from 4 to 10
//****************************************
bank 1; org $8B8A	// 0x04B9A
	adc.b  #$0A	// Originally 69 04 (ADC #$04)
