//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

bank 1; org $8DB4	// 0x04DC4-0x06003
// Title screen and Intro graphics
	incbin code/optional/la_gfx/la_gfx00a.bin
	incbin code/optional/la_gfx/la_gfx00b.bin
bank 2; org $807F	// 0x0808F-0x0900F
// Link, items, HUD and Font sprites 
	incbin code/optional/la_gfx/la_gfx01a.bin
	incbin code/optional/la_gfx/la_gfx01b.bin
	incbin code/optional/la_gfx/la_gfx01c.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// 0x0C12B-0x0D12A
	incbin code/optional/la_gfx/la_gfx02a.bin
	incbin code/optional/la_gfx/la_gfx02b.bin
// NPC and enemy sprites
org $915B	// 0x0D16B-0x0EBEF
	incbin code/optional/la_gfx/la_gfx03a.bin
	incbin code/optional/la_gfx/la_gfx03b.bin
	incbin code/optional/la_gfx/la_gfx03c.bin
	incbin code/optional/la_gfx/la_gfx03d.bin
	incbin code/optional/la_gfx/la_gfx03e.bin
	incbin code/optional/la_gfx/la_gfx03f.bin
	incbin code/optional/la_gfx/la_gfx03g.bin
	incbin code/optional/la_gfx/la_gfx03h.bin
// Overworld Cracked Walls and Burnable Tree
org $AC10	// 0x0EC20
	incbin code/optional/la_gfx/OverworldAssets.bin
// Dungeons Cracked Walls
	incbin code/optional/la_gfx/DungeonAssets.bin

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
