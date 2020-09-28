//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

bank 1; org $8DB4	// $04DC4-$06003
// Title screen and Intro graphics
	incbin code/optional/la_gfx/la_gfx00a.bin
	incbin code/optional/la_gfx/la_gfx00b.bin
bank 2; org $807F	// $0808F-$0900F
// Link, items, HUD and Font sprites 
	incbin code/optional/la_gfx/la_gfx01a.bin
	incbin code/optional/la_gfx/la_gfx01b.bin
	incbin code/optional/la_gfx/la_gfx01c.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// $0C12B-$0D12A
	incbin code/optional/la_gfx/la_gfx02a.bin
	incbin code/optional/la_gfx/la_gfx02b.bin
// NPC and enemy sprites
org $911B	// $0D12B-$0EBEF
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
	incbin /code/optional/la_gfx/OverworldAssets.bin
// Dungeons Cracked Walls
	incbin /code/optional/la_gfx/DungeonAssets.bin
