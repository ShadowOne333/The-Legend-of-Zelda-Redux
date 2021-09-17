//***********************************************************
//	Grey tiles Automap (for Original HUD)
//***********************************************************

bank 6; 
// PPU transfers for Automap tiles in the HUD and Subscreen
org $9352	// 0x19361
	db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
org $935D	// 0x1936D
	db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
org $9368	// 0x19378
	db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
org $9373	// 0x19383
	db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5

org $BEF0	// 0x1BF00
//OverworldAttributeData:
// New data to change map colors
	db $23,$C0,$10		// PPU Transfer $23C0
	db $00,$00,$40,$00,$00,$44,$55,$55	// Attribute table for HUD
	db $00,$00,$04,$00,$00,$44,$55,$55	// Attribute table for HUD
