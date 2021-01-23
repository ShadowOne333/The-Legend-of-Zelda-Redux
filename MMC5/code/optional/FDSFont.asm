//***********************************************************
//	Import FDS font and characters for MMC5 version
//***********************************************************

// Bank 8
bank 8;
org $21000	// 0x21010
	incbin code/optional/fds_font/fds_font.chr
org $21640	// 0x21650
	incbin code/optional/fds_font/infinity_symbol.chr
org $22800	// 0x22810
	incbin code/optional/fds_font/fds_font.chr
org $22E40	// 0x22E50
	incbin code/optional/fds_font/infinity_symbol.chr

// Bank 9
bank 9;
org $24000	// 0x24010
	incbin code/optional/fds_font/fds_font.chr
org $24640	// 0x24650
	incbin code/optional/fds_font/infinity_symbol.chr

// Bank 10
bank 10;
org $29000	// 0x29010
	incbin code/optional/fds_font/fds_font.chr
org $29640	// 0x29650
	incbin code/optional/fds_font/infinity_symbol.chr
org $2A000	// 0x2A010
	incbin code/optional/fds_font/fds_font.chr
org $2A640	// 0x2A650
	incbin code/optional/fds_font/infinity_symbol.chr
org $2B000	// 0x2B010
	incbin code/optional/fds_font/fds_font.chr
org $2B640	// 0x2B650
	incbin code/optional/fds_font/infinity_symbol.chr

// Bank 11
bank 11; org $2C000	// 0x2C010
	incbin code/optional/fds_font/fds_font.chr
org $2C640	// 0x2C650
	incbin code/optional/fds_font/infinity_symbol.chr
