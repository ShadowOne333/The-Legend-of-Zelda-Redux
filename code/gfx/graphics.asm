//***********************************************************
//	Import modified graphics
//***********************************************************

bank 1; org $8DB4	// 0x04DC4-0x06003
	incbin code/gfx/data_00a.bin	// $8DB4 - Intro/Waterfall/Vines graphics
	incbin code/gfx/data_00b.bin	// $96B4 - Title Screen graphics

bank 2; org $807F	// 0x0808F-0x0900F
// Link, items, HUD and Font sprites - $807F
	incbin code/gfx/data_01a.bin
// Font sprites  - $877F
	incbin code/gfx/data_01b.bin
// Hearts, rupee, key, copyright and some brick sprites - $8E7F
	incbin code/gfx/data_01c.bin

bank 3; 
// Dungeon and overworld tiles
org $811B
// 0x0C12B-0x0C93A - Dungeon background tiles
	incbin code/gfx/data_02a.bin
// 0x0C93B-0x0D15A - Overworld background tiles
	incbin code/gfx/data_02b.bin

org $915B
// 0x0D15B-0x0D87A - Overworld NPC and Enemy sprites 
	incbin code/gfx/data_03a.bin
// 0x0D87B-0x0DA9A - Dungeon 3, 5, 8 Enemy sprites
	incbin code/gfx/data_03b.bin
// 0x0DA9B-0x0DCBA - Dungeon 4, 6, 9 Enemy sprites
	incbin code/gfx/data_03c.bin
// 0x0DCBB-0x0DDBA - Dungeon Common Enemies and NPC sprites
	incbin code/gfx/data_03d.bin
// 0x0DCBB-0x0DFDA - Dungeon 1, 2, 7 Enemy sprites
	incbin code/gfx/data_03e.bin
// 0x0DFDB-0x0E3DA - Dungeon 1, 2, 5, 7 Bosses (Aquamentus, Dodongo)
	incbin code/gfx/data_03f.bin
// 0x0E3DB-0x0E7DA - Dungeon 3, 4, 6, 8 Bosses (Manhandalla, Gohma, Gleeok)
	incbin code/gfx/data_03g.bin
// 0x0E7DB-0x0EBEF - Dungeon 9 Bosses (Ganon, Patra) and Zelda/Triforce
	incbin code/gfx/data_03h.bin


