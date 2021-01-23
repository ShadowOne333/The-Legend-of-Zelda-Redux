//***********************************************************
//	Change the Tunics to original NES Rings
//***********************************************************

// Change TUNIC text back to RING
bank 2;	org $93F2	// 0x09402
	db $05, "BLUE RING     RED RING",{end}
//05 0B 15 1E 0E 24 1B 12 17 10 24 24 24 24 24 1B 0E 0D 24 1B 12 17 10 FF


// Change tunic graphics back to ring
bank 2;	org $84DF	// 0x084EF
	incbin code/optional/rings/Ring.chr

// Tunic graphics for MMC5
bank 8;	org $20460	// 0x20470
	incbin code/optional/rings/Ring.chr
