//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

// Automap tiles for Original MMC1 
bank 2;
org $8A7F
	incbin code/gameplay/automap_tiles.bin

bank 3; 
// Overworld Cracked Walls and Burnable Tree
org $AC10	// 0x0EC20
	incbin code/optional/la_gfx/OverworldAssets.bin
// Dungeons Cracked Walls
	incbin code/optional/la_gfx/DungeonAssets.bin

// Link's Awakening GFX for MMC5
bank 8; org $20000	// 0x20010
	incbin code/optional/la_gfx/LACHR.bin
// Automap tiles for MMC5
org $22B00
	incbin code/gameplay/automap_tiles.bin
bank 10; org $29300
	incbin code/gameplay/automap_tiles.bin
org $2A300
	incbin code/gameplay/automap_tiles.bin
org $2B300
	incbin code/gameplay/automap_tiles.bin
bank 11; org $2C300
	incbin code/gameplay/automap_tiles.bin


//--------------------------------------------------------------
//	Pallete changes
//--------------------------------------------------------------

bank 6; 
// Change brown colour of Link to have more contrast
// Overworld palette
org $9313	// 0x19323
	db $0F,$29,$27,$07	// Black, green, beige, brown
// Dungeons palettes
org $940F	// 0x1941F
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $950B	// 0x1951B
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $9607	// 0x19617
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $9703	// 0x19713
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $97FF	// 0x1980F
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $98FB	// 0x1990B
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $99F7	// 0x19A07
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $9AF3	// 0x19B03
	db $0F,$29,$27,$07	// Black, green, beige, brown
org $9BEF	// 0x19BFF
	db $0F,$29,$27,$07	// Black, green, beige, brown

// Change palette of Link on File Select screen
org $9CEB	// 0x19CFB
	db $0F,$29,$27,$07	// Black, green, beige, brown
	db $0F,$22,$27,$07	// Black, blue, beige, brown
	db $0F,$16,$27,$07	// Black, red, beige, brown
