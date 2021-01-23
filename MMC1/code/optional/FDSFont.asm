//***********************************************************
//	FDS Font and characters
//***********************************************************

bank 2; org $877F	// 0x0878F-0x08E8F
// Import Famicom Disk System font and characters
	incbin code/optional/fds_font/fds_font.chr
// Infinity symbol (+840 bytes)
org $8DBF	// 0x08DCF
	incbin code/optional/fds_font/infinity_symbol.chr
