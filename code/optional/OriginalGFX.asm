//***********************************************************
//	Link's Awakening DX Graphics
//***********************************************************

bank 1; org $8DB4	// $04DC4-$06003
// Title screen and Intro graphics
	incbin code/optional/originalGFX_00.bin
bank 2; org $807F	// $0808F-$0900F
// Link, items, HUD and Font sprites 
	incbin code/optional/originalGFX_01.bin
bank 3; 
// Dungeon and overworld tiles
org $811B	// $0C12B-$0D12A
	incbin code/optional/originalGFX_02.bin
// NPC and enemy sprites
org $911B	// $0D12B-$0F12B
	incbin code/optional/originalGFX_03.bin
