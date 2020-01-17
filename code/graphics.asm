//****************************************
// Import modified graphics
//****************************************

bank 1; org $8DB4	// $04DC4-$06003
// Title screen and Intro graphics
	incbin code/data_00.bin
bank 2; org $807F	// $0808F-$0900F
// Link, items, HUD and Font sprites 
	incbin code/data_01.bin

bank 3; 
// Dungeon and overworld tiles
org $811B	// $0C12B-$0D12A
	incbin code/data_02.bin
// NPC and enemy sprites
org $911B	// $0D12B-$0F12B
	incbin code/data_03.bin

bank 5;
// Automap tilemap (Filling map tiles)
org $AD00	// $16D10-16F0C
	incbin code/data_04.bin
