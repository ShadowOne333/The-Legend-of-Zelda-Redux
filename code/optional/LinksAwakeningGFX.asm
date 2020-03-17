//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

bank 1; org $8DB4	// $04DC4-$06003
// Title screen and Intro graphics
	incbin optional/la_gfx00.bin
bank 2; org $807F	// $0808F-$0900F
// Link, items, HUD and Font sprites 
	incbin optional/la_gfx01.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// $0C12B-$0D12A
	incbin optional/la_gfx02.bin
// NPC and enemy sprites
org $911B	// $0D12B-$0F12B
	incbin optional/la_gfx03.bin
