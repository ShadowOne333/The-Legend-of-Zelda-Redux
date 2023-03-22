//***********************************************************
//	Original NES graphics
//***********************************************************

// Automap tiles for Original MMC1 
bank 2;
org $8A7F
	incbin code/gameplay/automap_tiles.bin

bank 3; 
// Overworld Cracked Walls and Burnable Tree
org $AC10	// 0x0EC20
	incbin code/optional/original_gfx/OverworldAssets.bin
// Dungeons Cracked Walls
	incbin code/optional/original_gfx/DungeonAssets.bin

// Original NES GFX for MMC5
bank 8; org $20000	// 0x20010
	incbin code/optional/original_gfx/CHR.bin
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

// Restore Ganon's original palette
bank 6;
org $A205	// 0x1A215
	db $0F,$16,$2C,$3C


