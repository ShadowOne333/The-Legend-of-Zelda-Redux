//***********************************************************
//	Original NES graphics
//***********************************************************

bank 1; org $8DB4	// 0x04DC4-0x06003
// Title screen and Intro graphics
	incbin code/optional/original_gfx/originalGFX_00a.bin
	incbin code/optional/original_gfx/originalGFX_00b.bin
bank 2; org $807F	// 0x0808F-0x0900F
// Link, items, HUD and Font sprites 
	incbin code/optional/original_gfx/originalGFX_01a.bin
	incbin code/optional/original_gfx/originalGFX_01b.bin
	incbin code/optional/original_gfx/originalGFX_01c.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// 0x0C12B-0x0D12A
	incbin code/optional/original_gfx/originalGFX_02a.bin
	incbin code/optional/original_gfx/originalGFX_02b.bin
// NPC and enemy sprites
org $915B	// 0x0D16B-0x0EBEF
	incbin code/optional/original_gfx/originalGFX_03a.bin
	incbin code/optional/original_gfx/originalGFX_03b.bin
	incbin code/optional/original_gfx/originalGFX_03c.bin
	incbin code/optional/original_gfx/originalGFX_03d.bin
	incbin code/optional/original_gfx/originalGFX_03e.bin
	incbin code/optional/original_gfx/originalGFX_03f.bin
	incbin code/optional/original_gfx/originalGFX_03g.bin
	incbin code/optional/original_gfx/originalGFX_03h.bin
// Overworld Cracked Walls and Burnable Tree
org $AC60	// 0x0EC70
	incbin code/optional/original_gfx/OverworldAssets.bin
// Dungeons Cracked Walls
	incbin code/optional/original_gfx/DungeonAssets.bin

// MMC1 Animated tiles frames
org $AEA0	// 0x0EEB0
	incbin code/optional/original_gfx/ow_1st_frame1.chr
	incbin code/optional/original_gfx/ow_2nd_frame1.chr
	incbin code/optional/original_gfx/ow_1st_frame2.chr
	incbin code/optional/original_gfx/ow_2nd_frame2.chr
	incbin code/optional/original_gfx/ow_1st_frame3.chr
	incbin code/optional/original_gfx/ow_2nd_frame3.chr

// Restore Ganon's original palette after he recovers from vulnerable state
bank 4; org $AF67	// 0x12F77
	db $16,$2C,$3C

// Restore Ganon's original palette
bank 6; org $A205	// 0x1A215
	db $0F,$16,$2C,$3C
