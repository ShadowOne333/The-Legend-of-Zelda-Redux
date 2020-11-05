//****************************************
// Increase bomb upgrades from 4 to 5
//****************************************
bank 1; org $8B8A	// 0x04B9A
	adc.b  #$05	// Originally 69 04 (ADC #$04)
