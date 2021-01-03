//***********************************************************
//	Rearrange Bosses for Both Quests
//***********************************************************

// Disables the new custom cracked walls and burnable tree secrets to be completely hidden like in the original game for the purists.

// Dungeons cracked walls
bank 5;

// Dungeon Right Walls:
org $A012	// 0x16022
	db $DF,$DF,$DF,$DF,$F5,$F5,$DF,$DF,$DF,$DF,$F5,$F5	// Originally DF DF DF DF F5 F5 DF DF DF DF F5 F5
// Dungeon Left Walls:
org $A04E	// 0x1605E
	db $F5,$F5,$DE,$DE,$DE,$DE,$F5,$F5,$DE,$DE,$DE,$DE	// Originally F5 F5 DE DE DE DE F5 F5 DE DE DE DE
// Dungeon Bottom Wall:
org $A08A	// 0x1609A
	db $DD,$DD,$F5,$DD,$DD,$F5,$DD,$DD,$F5,$DD,$DD,$F5	// Originally DD DD F5 DD DD F5 DD DD F5 DD DD F5
// Dungeon Top Wall:
org $A0C7	// 0x160D7
	db $DC,$DC,$F5,$DC,$DC,$F5,$DC,$DC,$F5,$DC,$DC,$F5	// Originally F5 DC DC F5 DC DC F5 DC DC F5 DC DC


// Overworld cracked walls and burnable tree
org $AC30	// 0x16C40
	db $C8, $D8, $C4, $BC, $C0, $C0	// Alternate secret tile codes table
